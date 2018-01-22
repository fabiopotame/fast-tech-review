<?php

namespace App;
use Illuminate\Database\Eloquent\Model;

class Beer extends Model
{

    protected $table = 'beers';
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */

    protected $fillable = [
          'id', 
          'name', 
          'tagline', 
          'first_brewed', 
          'description', 
          'image_url', 
          'abv', 
          'ibu', 
          'target_fg', 
          'target_og', 
          'ebc', 
          'srm', 
          'ph', 
          'attenuation_level', 
          'volume', 
          'boil_volume', 
          'brewers_tips', 
          'contributed_by',
    ];
    
    /**
     * The attributes excluded from the model's JSON form.
     *
     * @var array
     */
    protected $hidden = [
        'created_at',
        'updated_at',
    ];

    protected $dateFormat = 'm/Y';
}