<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Web3\Web3;
use Web3\Contract;
use Web3\Providers\HttpProvider;
use Web3\RequestManagers\HttpRequestManager;
use Web3\Utils;
use Illuminate\Support\Facades\Log;

class XRayController extends Controller
{
    protected $web3;
    protected $contract;
    protected $contractAddress = '0xc3D1Cc776Fb4759D3052D8D36425fC2c54A3f7bA'; // Replace with actual contract address
    protected $fromAddress = '0xc6c48fB29E809586a4569B90Ac69E554F8b200BC'; // Replace with actual address
    protected $privateKey = '0xa27317ff48dc94c1521bad66485d2357dde2d29fada09300a79da831e7ea86e5'; // Replace with actual private key

    public function __construct()
    {
        $ganacheUrl = 'http://127.0.0.1:7545';
        $this->web3 = new Web3(new HttpProvider(new HttpRequestManager($ganacheUrl, 10))); // 10 seconds timeout

        $contractABI = '[{
            "constant": false,
            "inputs": [
                {"name": "_nationalId", "type": "uint256"},
                {"name": "_imageUrl", "type": "string"},
                {"name": "_date", "type": "string"}
            ],
            "name": "addXRay",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        }, {
            "constant": true,
            "inputs": [{"name": "_nationalId", "type": "uint256"}],
            "name": "getXRay",
            "outputs": [
                {"name": "nationalId", "type": "uint256"},
                {"name": "imageUrl", "type": "string"},
                {"name": "date", "type": "string"}
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        }]';

        $this->contract = new Contract($this->web3->provider, $contractABI);
    }

    public function addXRay(Request $request) {
        $request->validate([
            'nationalId' => 'required|numeric',
            'imageUrl' => 'required|string',
            'date' => 'required|string'
        ]);

        $nationalId = (int) $request->input('nationalId');
        $imageUrl = $request->input('imageUrl');
        $date = $request->input('date');
        Log::info('Received data: ', ['nationalId' => $nationalId, 'imageUrl' => $imageUrl, 'date' => $date]);

        try {
            $this->sendTransaction('addXRay', [$nationalId, $imageUrl, $date]);
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

    public function getXRay($nationalId)
    {
        try {
            Log::info('Request received for nationalId: ' . $nationalId);

            $this->contract->at($this->contractAddress)->call('getXRay', $nationalId, ['from' => $this->fromAddress], function ($err, $result) use ($nationalId) {
                if ($err !== null) {
                    Log::error('Error in contract call: ' . $err->getMessage());
                    echo $this->jsonResponse(['error' => 'Error: ' . $err->getMessage()], 500);
                    return;
                }

                Log::info('Raw contract result: ' . json_encode($result));

                if (!is_array($result) || !isset($result['nationalId']) || !isset($result['imageUrl']) || !isset($result['date'])) {
                    Log::error('Missing expected keys in result. Result: ' . json_encode($result));
                    echo $this->jsonResponse(['error' => 'Invalid result set from contract.'], 500);
                    return;
                }

                $nationalIdValue = $result['nationalId']->value;

                Log::info('Returning JSON response');

                echo $this->jsonResponse([
                    'nationalId' => $nationalIdValue,
                    'imageUrl' => $result['imageUrl'],
                    'date' => $result['date']
                ], 200);
            });

        } catch (\Exception $e) {
            Log::error('An unexpected error occurred: ' . $e->getMessage());
            return response()->json(['error' => 'An unexpected error occurred: ' . $e->getMessage()], 500);
        }
    }

    private function jsonResponse($data, $status)
    {
        http_response_code($status);
        header('Content-Type: application/json');
        echo json_encode($data);
    }
}