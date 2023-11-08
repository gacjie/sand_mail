<?php
declare (strict_types = 1);
namespace app\command;
use think\console\Command;
use think\console\Input;
use think\console\input\Argument;
use think\console\input\Option;
use think\console\Output;
use think\facade\Db;
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

class Cron extends Command
{
    protected function configure()
    {
        // 指令配置
        $this->setName('cron')
            ->setDescription('the cron command');
    }
    protected function execute(Input $input, Output $output)
    {
        $ritorn = $this->sendmail();
        // 指令输出
        if($ritorn){
            $output->writeln("发信任务已执行完成\n");
        }else{
            $output->writeln($ritorn);
        }
    }
    public function sendmail(){
        $site = config('site');
        $smtparr = Db::name('smtp')
                    ->where('sendtime','<', time()-$site['interval'])
                    ->where('switch', 'on')
                    ->orderRaw("rand() , id DESC")
                    ->limit((int)$site['limit'])
                    ->select()
                    ->toArray();
        if(empty($smtparr)){
                echo "没有可用的发信箱\n";
                exit;
        }
        $email = Db::name('temp')->where('switch', 'on')->orderRaw("rand() , id DESC")->select()->toArray();
        $mailer = new PHPMailer(true);                              // Passing `true` enables exceptions
        $mailer->CharSet ="UTF-8";                     //设定邮件编码
        $mailer->SMTPDebug = $site['debug'];                        // 调试模式输出
        $mailer->isSMTP();                             // 使用SMTP
        $mailer->SMTPAuth = true;                      // 允许 SMTP 认证
        foreach ($smtparr as $smtp) {
            $smtp['sendtime'] = time();
            $receives = Db::name('email')->where('switch', 'on')->limit((int)$site['num'])->select()->toArray();
            if(empty($receives)){
                echo "没有可用的收信箱\n";
                exit;
                }
            shuffle($email);
            $mailer->Host = $smtp['server'];                // SMTP服务器
            $mailer->Username = $smtp['username'];                // SMTP 用户名  即邮箱的用户名
            $mailer->Password = $smtp['password'];             // SMTP 密码  部分邮箱是授权码(例如163邮箱)
            if($smtp['encryption'] != 1){
                $mailer->SMTPSecure = "ssl";                    // 允许 TLS 或者ssl协议
            }
            $mailer->Port = $smtp['port'];                            // 服务器端口 25 或者465 具体要看邮箱服务器支持
            $mailer->setFrom($smtp['username'], $site['sname']);  //发件人
            $mailer->addReplyTo($smtp['username'], $site['sname']); //回复的时候回复给哪个邮箱 建议和发件人一致
            $mailer->isHTML(true);                                  // 是否以HTML文档格式发送  发送后客户端可直接显示对应HTML内容
            $mailer->Subject = $email[0]['name'];
            $mailer->Body    = $email[0]['content'];
            $send_log = [];
            if($site['mode'] == "2"){
                foreach ($receives as $receive){
                    $mailer->addAddress($receive['email'], $receive['name']);  // 收件人
                    try {
                        $mailer->send();
                        $status = "yes";
                        Db::name('email')->update(["id"=>$receive['id'],"switch"=>"off"]);
                    } catch (Exception $e) {
                        $status = $mailer->ErrorInfo;
                        $smtp['switch'] = "off";
                    }
                    $mailer->clearAddresses();
                    $send_log[] = ["email" => $receive['email'],"smail" => $smtp['username'],"temp" => $email[0]['name'],"stime" => $smtp['sendtime'],"status" => $status];
                }
            }else{
                foreach ($receives as $receive){
                    $mailer->addAddress($receive['email'], $receive['name']);  // 收件人
                    $send_log[] = ["email" => $receive['email'],"smail" => $smtp['username'],"temp" => $email[0]['name'],"stime" => $smtp['sendtime'],"status" => "yes"];
                    $receive['switch'] = "off";
                }
                try {
                    $mailer->send();
                    foreach ($receives as $receive){
                        Db::name('email')->update(["id"=>$receive['id'],"switch"=>"off"]);
                    }
                } catch (Exception $e) {
                    foreach ($send_log as $log){
                        $log['status'] = $mailer->ErrorInfo;
                    }
                    $smtp['switch'] = "off";
                }
                $mailer->clearAddresses();
            }
            Db::name('smtp')->update($smtp);
            Db::name('send_log')->insertAll($send_log);
            sleep((int)$site['sleep']);
        };
        return true;
    }
}
