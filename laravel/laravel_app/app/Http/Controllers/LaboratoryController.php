<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Web3\Web3;
use Web3\Contract;
use Web3\Providers\HttpProvider;
use Web3\RequestManagers\HttpRequestManager;
use Web3\Utils;
use Illuminate\Support\Facades\Log;

class LaboratoryController extends Controller
{
    protected $web3;
    protected $contract;
    protected $contractAddress = '0xE18A12F364BD9D99E9039827392FD480e8ad6429'; // Replace with actual contract address
    protected $fromAddress = '0xc6c48fB29E809586a4569B90Ac69E554F8b200BC'; // Replace with actual address
    protected $privateKey = '0xa27317ff48dc94c1521bad66485d2357dde2d29fada09300a79da831e7ea86e5'; // Replace with actual private key

    public function __construct()
    {
        $ganacheUrl = 'http://127.0.0.1:7545';
        $this->web3 = new Web3(new HttpProvider(new HttpRequestManager($ganacheUrl, 10))); // 10 seconds timeout

        $contractABI = '[{
            "constant": false,
            "inputs": [
                {"name": "_name", "type": "string"},
                {"name": "_imageHash", "type": "string"},
                {"name": "_email", "type": "string"},
                {"name": "_password", "type": "string"}
            ],
            "name": "addLaboratory",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        }, {
            "constant": true,
            "inputs": [{"name": "_index", "type": "uint256"}],
            "name": "getLaboratory",
            "outputs": [
                {"name": "name", "type": "string"},
                {"name": "imageHash", "type": "string"},
                {"name": "email", "type": "string"},
                {"name": "password", "type": "string"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        }]';

        $this->contract = new Contract($this->web3->provider, $contractABI);
    }

    public function insertLaboratory(Request $request)
    {
        $request->validate([
            'name' => 'required|string',
            'imageHash' => 'required|string',
            'email' => 'required|string',
            'password' => 'required|string'
        ]);

        $name = $request->input('name');
        $imageHash = $request->input('imageHash');
        $email = $request->input('email');
        $password = $request->input('password');
        Log::info('Received data: ', ['name' => $name, 'imageHash' => $imageHash, 'email' => $email, 'password' => $password]);

        try {
            $this->sendTransaction('addLaboratory', [$name, $imageHash, $email, $password]);
            return response()->json(['status' => 'success']);
        } catch (\Exception $e) {
            Log::error('An unexpected error occurred: ' . $e->getMessage());
            return response()->json(['status' => 'error', 'message' => 'An unexpected error occurred']);
        }
    }

    private function sendTransaction($methodName, $params)
    {
        $transactionOptions = [
            'from' => $this->fromAddress,
            'gas' => '0x30D40', // Increased to 200000
            'gasPrice' => '0x9184e72a000' // 10000000000000
        ];

        $callback = function ($err, $transaction) use ($params) {
            if ($err !== null) {
                Log::error('Error in callback: ' . $err->getMessage());
                return response()->json(['error' => 'Error: ' . $err->getMessage()], 500);
            }

            $this->web3->eth->getTransactionCount($this->fromAddress, 'latest', function ($err, $nonce) use ($transaction, $params) {
                if ($err !== null) {
                    Log::error('Error getting transaction count: ' . $err->getMessage());
                    return response()->json(['error' => 'Error: ' . $err->getMessage()], 500);
                }

                $transactionData = [
                    'nonce' => Utils::toHex($nonce, true),
                    'from' => $this->fromAddress,
                    'to' => $this->contractAddress,
                    'gas' => '0x30D40', // Increased to 200000
                    'gasPrice' => '0x9184e72a000', // 10000000000000
                    'data' => $transaction
                ];

                try {
                    $signedTransaction = $this->web3->eth->accounts->signTransaction($transactionData, $this->privateKey);
                    if ($signedTransaction === false) {
                        Log::error("signTransaction returned false.");
                        return response()->json(['error' => 'Failed to sign transaction'], 500);
                    }

                    $this->web3->eth->sendSignedTransaction($signedTransaction['rawTransaction'], function ($err, $txHash) {
                        if ($err !== null) {
                            Log::error('Error sending signed transaction: ' . $err->getMessage());
                            return response()->json(['error' => 'Error: ' . $err->getMessage()], 500);
                        }
                        Log::info('Transaction hash: ' . $txHash);
                        return response()->json(['transaction' => $txHash], 200);
                    });
                } catch (\Exception $e) {
                    Log::error("Exception during signing transaction: " . $e->getMessage());
                    return response()->json(['error' => 'Error signing transaction: ' . $e->getMessage()], 500);
                }
            });
        };

        call_user_func_array([$this->contract->at($this->contractAddress), 'send'], array_merge([$methodName], $params, [$transactionOptions, $callback]));
    }

    public function getLaboratoryByName($name)
    {
        try {
            $this->contract->at($this->contractAddress)->call('getLaboratory', $name, ['from' => $this->fromAddress], function ($err, $result) {
                if ($err !== null) {
                    Log::error('Error in contract call: ' . $err->getMessage());
                    return response()->json(['error' => 'Error: ' . $err->getMessage()], 500);
                }

                if (!is_array($result) || !isset($result[0]) || !isset($result[1]) || !isset($result[2]) || !isset($result[3])) {
                    Log::error('Missing expected keys in result. Result: ' . json_encode($result));
                    return response()->json(['error' => 'Invalid result set from contract.'], 500);
                }

                $laboratory = [
                    'name' => $result[0],
                    'imageHash' => $result[1],
                    'email' => $result[2],
                    'password' => $result[3]
                ];

                return response()->json($laboratory, 200);
            });
        } catch (\Exception $e) {
            Log::error('An unexpected error occurred: ' . $e->getMessage());
            return response()->json(['status' => 'error', 'message' => 'An unexpected error occurred']);
        }
    }

    public function getAllLaboratoryNames()
    {
        try {
            $this->contract->at($this->contractAddress)->call('laboratoryCount', [], function ($err, $count) {
                if ($err !== null) {
                    Log::error('Error in contract call: ' . $err->getMessage());
                    return response()->json(['error' => 'Error: ' . $err->getMessage()], 500);
                }

                $names = [];
                for ($i = 1; $i <= $count->value; $i++) {
                    $this->contract->at($this->contractAddress)->call('getLaboratory', $i, function ($err, $result) use (&$names) {
                        if ($err !== null) {
                            Log::error('Error in contract call: ' . $err->getMessage());
                            return response()->json(['error' => 'Error: ' . $err->getMessage()], 500);
                        }

                        $names[] = $result[0];
                    });
                }

                return response()->json($names, 200);
            });
        } catch (\Exception $e) {
            Log::error('An unexpected error occurred: ' . $e->getMessage());
            return response()->json(['status' => 'error', 'message' => 'An unexpected error occurred']);
        }
    }
}