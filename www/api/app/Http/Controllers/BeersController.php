<?php

namespace App\Http\Controllers;

use App\Beer;
use App\Ingredient;
use App\Method;
use App\FoodPairing;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use Carbon\Carbon;

class BeersController extends Controller
{

	public function __construct(Request $request) {
		if(!empty($_GET['callback'])) {
			$this->callback = $_GET['callback'];
		}
	}

	private $callback = null;
	private $message = '';
	private $filters = [
				'abv_gt' 		=> 'isNumber',		
				'abv_lt' 		=> 'isNumber',		
				'ibu_gt' 		=> 'isNumber',		
				'ibu_lt' 		=> 'isNumber',		
				'ebc_gt' 		=> 'isNumber',		
				'ebc_lt' 		=> 'isNumber',		
				'beer_name' 	=> 'isString',		
				'yeast'			=> 'isString',		
				'brewed_before' => 'isDate',	
				'brewed_after'	=> 'isDate',
				'hops'			=> 'isString',
				'malt'			=> 'isString',
				'food'			=> 'isString',
				'ids'			=> 'isString',
				'callback'		=> 'isString',
				];

	/**
	 * Action to list data
	 * @return array
	 */
	public function index($id = null)
	{
		if(!$this->validateFilters($id)) {
			return $this->message;
		}

		$ids = NULL;
		if(!empty($_GET['ids'])) {
			 $ids = $this->validateIds($_GET['ids']);
			 if(!$ids) {
			 	return $this->message;
			 }
		}

		$orderBy = 'id';
		if($id == 'random') {
			$orderBy = DB::raw('RAND()');
		}

		$beers = $this->convertJson(Beer::select('beers.*', DB::raw('DATE_FORMAT(first_brewed,\'%m/%Y\') as first_brewed'))
			->where(function($where) use ($id, $ids, $orderBy) {
				if(is_numeric($id)) {
					$where->where('beers.id', $id);
				}
				if(!empty($_GET['abv_gt'])) {
					$where->where('beers.abv', '>', $_GET['abv_gt']);
				}
				if(!empty($_GET['abv_lt'])) {
					$where->where('beers.abv', '<', $_GET['abv_lt']);
				}
				if(!empty($_GET['ibu_gt'])) {
					$where->where('beers.ibu', '>', $_GET['ibu_gt']);
				}
				if(!empty($_GET['ibu_lt'])) {
					$where->where('beers.ibu', '<', $_GET['ibu_lt']);
				}
				if(!empty($_GET['ebc_gt'])) {
					$where->where('beers.ebc', '>', $_GET['ebc_gt']);
				}
				if(!empty($_GET['ebc_lt'])) {
					$where->where('beers.ebc', '<', $_GET['ebc_lt']);
				}
				if(!empty($_GET['beer_name'])) {
					$where->where('beers.name', 'like', '%'.str_replace('_', ' ', $_GET['beer_name']).'%');
				}
				if(!empty($_GET['brewed_before'])) {
					$brewedBefore = Carbon::createFromFormat('m-Y', $_GET['brewed_before'])->startOfMonth()->toDateString();
					$where->where('beers.first_brewed', "<", $brewedBefore);
				}
				if(!empty($_GET['brewed_after'])) {
					$brewedAfter = Carbon::createFromFormat('m-Y', $_GET['brewed_after'])->endOfMonth()->toDateString();
					$where->where('beers.first_brewed', ">", $brewedAfter);
				}
				if(!empty($_GET['food'])) {
			 		$where->where(DB::raw('(SELECT count(id) FROM food_pairings where food_pairings.text LIKE "%'.$_GET['food'].'%" AND food_pairings.beer_id = beers.id)'), '>', 0);
			 	}
			 	if(!is_null($ids)) {
					$where->where('beers.id', $ids);
				}
				if(!empty($_GET['yeast']) || !empty($_GET['hops']) || !empty($_GET['malt'])) {
					$where->where(DB::raw($this->queryBuilder()), '>', 0);
				}
			})
			->limit('50')
			->orderBy($orderBy)
			->get()
			->toArray());

		if(!empty($beers)) {
			foreach ($beers as $index => $beer) {
				$methods = Method::select('methods.name as method_name', 'methods_attributes.*')
				->leftJoin('methods_attributes', 'methods_attributes.method_id', 'methods.id')
				->where('methods.beer_id', $beer['id'])
				->get()
				->toArray();
				foreach ($methods as $key => $method) {
					if(is_null($method['content'])) {
						$beers[$index]['method'][$method['method_name']] = NULL;
						continue;
					}
					if($this->isJson($method['content'])) {
						$method['content'] = json_decode($method['content'], true);
					}
					$beers[$index]['method'][$method['method_name']][$method['name']] = $method['content'];
				}

				foreach ($beers[$index]['method'] as $in => $value) {
					if(count($value) > 1) {
						$beers[$index]['method'][$in] = [$value];
					}
				}

				$ingredients = Ingredient::select('*')
				->join('ingredients_contents', 'ingredients_contents.ingredient_id', 'ingredients.id')
				->join('ingredients_attributes', 'ingredients_attributes.ingredients_content_id', 'ingredients_contents.id')
				->where('ingredients.beer_id', $beer['id'])
				->get()
				->toArray();

				$ingredientsArray = [];
				foreach ($ingredients as $key => $ingredient) {
					if($this->isJson($ingredient['value'])) {
						$ingredient['value'] = json_decode($ingredient['value'] , true);
					}
					$ingredientsArray[$ingredient['name']][$ingredient['ingredients_content_id']][$ingredient['title']] = $ingredient['value'];
				}
				foreach ($ingredientsArray as $key => $value) {
					$ingredientsArray[$key] = array_values($ingredientsArray[$key]);
					if(count($ingredientsArray[$key]) == 1) {
						$ingredientsArray[$key] = $ingredientsArray[$key][0][$key];
					}
				}
				$beers[$index]['ingredients'] = $ingredientsArray; 

				$foodPairings = FoodPairing::select('text')
				->where('beer_id', $beer['id'])
				->get()
				->toArray();

				$foodPairingsArray = [];
				foreach ($foodPairings as $key => $foodPairing) {
					$beers[$index]['food_pairing'][] = $foodPairing[key($foodPairing)];
				}

			}
		}
		return $this->convertCallback($beers, $this->callback);
	}

	/**
	 * This recursive function convert Json data to array.
	 * @return array
	 */
	private function convertJson($data) 
	{
		$return = [];
		if(empty($data)) {
			return $return;
		}
		foreach ($data as $key => $value) {
			if(is_array($value)) {
				$return[] = $this->convertJson($value);
			} else {
				if($this->isJson($value)) {
					$return[$key] = json_decode($value, true);
				} else {
					$return[$key] = $value;
				}
			}
		}
		return $return;
	}

	/**
	 * Check if data is Json.
	 * @return boolean
	 */
	private function isJson($string) {
		json_decode($string);
		return (json_last_error() == JSON_ERROR_NONE);
	}

	/**
	 * Output it, wrapped in the method name.
	 * @return array
	 */
	private function convertCallback($data, $callback = null) {
		if(!empty($callback)) {
			return $callback . '('.$data.')';
		}
		return $data;
	}

	/**
	 * Validation of filters
	 * @return boolean
	 */
	private function validateFilters($id = null)
	{	
		if(!empty($id) && ((!is_numeric($id) && $id != 'random'))) {
			$message = 'beerId must be a number and greater than 0';
			$this->createErrorMessage('id', $message, $id);
			return false;
		}
		if(!empty($_GET)) {
			foreach ($_GET as $key => $value) {
				if(!array_key_exists($key, $this->filters) || empty($value)) {
					$message = 'Must have a value and if you are using multiple words use underscores to separate';
					$this->createErrorMessage($key, $message, $value);
					return false;
				}
				$filter = $this->filters[$key];
				if(!$this->$filter($key, $value)) {
					return false;
				}
			}
		}
		return true;
	}

	/**
	 * Validation and organization of ids separated by pipe
	 * @return array
	 */
	private function validateIds($ids)
	{
		$ids = explode('|', $ids);
		foreach ($ids as $key => $value) {
			if(!is_numeric($value) || empty($value)) {
				$message = 'Must contain only numbers separated by pipe';
				$this->createErrorMessage($key, $message, $value);
				return false;
			}
		}
		return $ids;
	}

	/**
	 * Validation if data is number
	 * @return boolean
	 */
	private function isNumber($param, $data = null)
	{
		if(!is_numeric($data)) {
			$message = 'Must be a number greater than 0';
			$this->createErrorMessage($param, $message, $data);
			return false;
		}
		return true;
	} 

	/**
	 * Validation if data is string (disabled)
	 * @return boolean
	 */
	private function isString($param, $data = null)
	{
		return true;
	} 

	/**
	 * Validation if data is date (format m-Y)
	 * @return boolean
	 */
	private function isDate($param, $data = null)
	{
		$date = explode('-', $data);
		if(empty($date[0]) || empty($date[1]) || !is_numeric($date[1]) || $date[0] < 1 || $date[0] > 12 || !is_numeric($date[1])) {
			$message = 'invalid date';
			$this->createErrorMessage($param, $message, $data);
			return false;
		}
		return true;
	} 

	/**
	 * Create error message
	 * @return array
	 */
	private function createErrorMessage($param, $message, $value)
	{
		$this->message = ['statusCode' 	=> 400, 
							  'error' 	=> 'Bad Request',
							  'message'	=> 'Invalid query params',
							  'data'	=> [
									    ['param' => $param,
									    'msg' 	=> $message,
									    'value' => $value]
							  ]
					    ];

	}

	/**
	 * Query for filter
	 * @return array
	 */
	private function queryBuilder() 
	{
		$query = '(select count(beer_id) from `ingredients_attributes` ia
					inner join `ingredients_contents` ic
					on ia.`ingredients_content_id` = ic.`id`
					inner join `ingredients` i
					on ic.`ingredient_id` = i.`id`
					where i.beer_id = beers.id
					and ia.title = \'name\' AND (';

		$ingredients = 'AND ( ';
		$condition = false;

		if(!empty($_GET['yeast'])) {
			$query .= '( ia.value LIKE "%'.$_GET['yeast'].'%" AND i.name = "yeast") ';
			$condition = true;
		}
		if(!empty($_GET['hops'])) {
			if($condition) {
				$query       .= ' OR ';
			}
			$query .= '( ia.value LIKE "%'.$_GET['hops'].'%" AND i.name = "hops" )';
			$condition 	= true;
		}
		if(!empty($_GET['malt'])) {
			if($condition) {
				$query       .= ' OR ';
			}
			$query .= '( ia.value LIKE "%'.$_GET['malt'].'%" AND i.name = "malt" )';
		}

		$query .= '))';
		return $query;
	}
}
