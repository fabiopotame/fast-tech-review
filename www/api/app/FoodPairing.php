<?php

namespace App;
use Illuminate\Database\Eloquent\Model;

class FoodPairing extends Model
{

    protected $table = 'food_pairings';
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */

    protected $fillable = [
          'id', 
    ];
  
}