<?php

namespace App;
use Illuminate\Database\Eloquent\Model;

class Ingredient extends Model
{

    protected $table = 'ingredients';
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */

    protected $fillable = [
          'id', 
    ];
  
}