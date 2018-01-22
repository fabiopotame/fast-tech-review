<?php

namespace App;
use Illuminate\Database\Eloquent\Model;

class Method extends Model
{

    protected $table = 'methods';
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */

    protected $fillable = [
          'id', 
    ];
  
}