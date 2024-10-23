<?php

use App\Providers\GenericHelperServiceProvider;
use App\Providers\InstallerServiceProvider;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Mail;
use App\Model\EmailManagement;

if (! function_exists('getSetting')) {
    function getSetting($key, $default = null)
    {
        try {
            $dbSetting = TCG\Voyager\Facades\Voyager::setting($key, $default);
        }
        catch (Exception $exception){
            $dbSetting = null;
        }

        $configSetting = config('app.'.$key);
        if ($dbSetting) {
            // If voyager setting is file type, extract the value only
            if (is_string($dbSetting) && strpos($dbSetting, 'download_link')) {
                $file = json_decode($dbSetting);
                if ($file) {
                    $file = Storage::disk(config('filesystems.defaultFilesystemDriver'))->url(str_replace('\\','/',$file[0]->download_link));
                }
                return $file;
            }

            return $dbSetting;
        }
        if ($configSetting) {
            return $configSetting;
        }

        return $default;
    }
}

function getLockCode(){
    if(session()->get(InstallerServiceProvider::$lockCode) == env('APP_KEY')){
        return true;
    }
    else{
        return false;
    }
}

function setLockCode($code){
    $sessData = [];
    $sessData[$code] = env('APP_KEY');
    session($sessData);
    return true;
}

function getUserAvatarAttribute($a){
    return GenericHelperServiceProvider::getStorageAvatarPath($a);
}

function handledExec($command, $throw_exception = true) {
    $result = exec('('.$command.')', $output, $return_code);
    if ($throw_exception) {
        if (($result === false) || ($return_code !== 0)) {
            throw new Exception('Error processing command: ' . $command . "\n\n" . implode("\n", $output) . "\n\n");
        }
    }
    return implode("\n", $output);
}

function checkMysqlndForPDO(){
    $dbHost = env('DB_HOST');
    $dbUser = env('DB_USERNAME');
    $dbPass = env('DB_PASSWORD');
    $dbName = env('DB_DATABASE');

    $pdo = new PDO('mysql:host=' . $dbHost . ';dbname=' . $dbName, $dbUser, $dbPass);
    if (strpos($pdo->getAttribute(PDO::ATTR_CLIENT_VERSION), 'mysqlnd') !== false) {
        return true;
    }
    return false;
}

function checkForMysqlND(){
    if (extension_loaded('mysqlnd')) {
        return true;
    }
    return false;
}

//get email template
	function get_email($id){
		$arr = EmailManagement::where('id',$id)
				->first();
		return $arr;
	}
//send email template
	function send_email($data){
		// toEmails = Receiver Email, bccEmails = Bcc Receiver, ccEmails = Cc Receiver, files = For attatchment files.
		$data['body'] = str_replace(array("[SCREEN_NAME]", "[YEAR]"), array(config('app.site.name'),date('Y')), $data['body']);
		
        Mail::send('email.sendmail', $data, function($message)use($data) {
            $message->to($data["toEmails"]);
			if(isset($data['bccEmails']) && count($data['bccEmails']) > 0){
				$message->bcc($data["bccEmails"]);
			}
			if(isset($data['ccEmails']) && count($data['ccEmails']) > 0){
				$message->cc($data["ccEmails"]);
			}
            $message->subject($data["subject"]);
			if(isset($data['files']) && count($data['files']) > 0){
				foreach ($data['files'] as $file){
					$message->attach($file);
				}
            }
        });
	}
	function formatNumber($number) {
		if ($number >= 1000000) {
			return number_format($number / 1000000, 1) . 'm';
		} elseif ($number >= 1000) {
			return number_format($number / 1000, 1) . 'k';
		} else {
			return $number;
		}
	}
