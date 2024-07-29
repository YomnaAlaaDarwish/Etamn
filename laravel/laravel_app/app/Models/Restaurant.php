<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Restaurant extends Model
{
    use HasFactory;

    // Define the fields that can be mass assigned.
    protected $fillable = ['name', 'latitude', 'longitude', 'type'];
}
