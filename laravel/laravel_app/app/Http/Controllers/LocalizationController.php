<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\App;

class LocalizationController extends Controller
{
    public function index($locale)
    {
        App::setLocale($locale);
        return response()->json([
            'hello' => __('messages.hello'),
            'change_language' => __('messages.change_language'),
        ]);
    }
}
