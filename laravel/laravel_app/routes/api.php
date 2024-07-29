<?php

use App\Http\Controllers\DoctorController;
use App\Http\Controllers\PatientController;


//use App\Http\Controllers\LaboratoryController;
//use App\Http\Controllers\PrescriptionController;
use App\Http\Controllers\SurgeryController;
use App\Http\Controllers\XRayController;
//use App\Http\Controllers\LipidController;

Route::post('add-patient', [PatientController::class, 'addPatient']);
Route::get('getPatient/{nationalId}', [PatientController::class, 'getPatient']);

Route::post('add-doctor', [DoctorController::class, 'insertDoctor']);
Route::get('getDoctor/{nationalId}', [DoctorController::class, 'getDoctor']);

//Route::post('add-Laboratory', [LaboratoryController::class, 'insertLaboratory']);
//Route::get('getPatient/{nationalId}', [DoctorController::class, 'getPatient']);


//Route::post('Upload_Prescription', [PrescriptionController::class, 'insertPrescription']);
//Route::get('Show_Prescriptions/{nationalId}', [PrescriptionController::class, 'getPrescriptionsByNationalId']);


Route::post('add-Surgery', [SurgeryController::class, 'addSurgery']);
Route::get('getSurgery/{nationalId}', [SurgeryController::class, 'getSurgery']);

Route::post('add-XRay', [XRayController::class, 'addXRay']);
Route::get('getXRay/{nationalId}', [XRayController::class, 'getXRay']);


//Route::post('add-Lipid', [LipidController::class, 'insertLipid']);
//Route::get('getLipid/{nationalId}', [LipidController::class, 'getLipidReportsByNationalId']);

Route::post('add-Lipid', [LipidController::class, 'insertLipid']);
Route::get('getLipid/{nationalId}', [LipidController::class, 'getLipidReportsByNationalId']);

Route::post('add-Blood', [LipidController::class, 'insertBlood']);
Route::get('getBlood/{nationalId}', [LipidController::class, 'getBloodsByNationalId']);