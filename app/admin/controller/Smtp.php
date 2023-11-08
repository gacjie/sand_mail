<?php
namespace app\admin\controller;

use app\common\controller\AddonBase;
use think\facade\View;
use think\facade\Db;
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

class Smtp extends AdminBase
{

    public function initialize(){
		parent::initialize();
        $this->model = new \app\admin\model\Smtp();
    }
    public function index(){
		if(!$this->request->isAjax()){
        	return View::fetch();
		}else{
			return $this->getList();
		}
    }

   public function getList(){
   		$page = $this->request->param('page',1,'intval');
   		$limit = $this->request->param('limit',10,'intval');
   		$count = $this->model->count();
   		$data = $this->model->with([])
		   ->where(function($query){
            $query->dateRange('sendtime',$this->request->param('sendtime',null));
            
                    $id = $this->request->param('id',null);
                    if($id){
                        $query->whereLike('id',"%{$id}%");
                    }
                    

                    $server = $this->request->param('server',null);
                    if($server){
                        $query->whereLike('server',"%{$server}%");
                    }
                    

                $encryption = $this->request->param('encryption',null);
                if($encryption){
                    $query->where('encryption',$encryption);
                }
                

                    $port = $this->request->param('port',null);
                    if($port){
                        $query->whereLike('port',"%{$port}%");
                    }
                    

                    $username = $this->request->param('username',null);
                    if($username){
                        $query->whereLike('username',"%{$username}%");
                    }
                    

                    $password = $this->request->param('password',null);
                    if($password){
                        $query->whereLike('password',"%{$password}%");
                    }
                    

                    $switch = $this->request->param('switch',null);
                    if($switch){
                        $query->whereLike('switch',"%{$switch}%");
                    }
                    
        })
           ->order('id','desc')
		   ->page($page,$limit)->select();
   		return json([
				'code'=> 0,
				'count'=> $count,
   				'data'=>$data,
   				'msg'=>__('Search successful')
   		]);
   }
   

   public function add(){
	   	if($this->request->isPost()){
	   		$data = $this->request->post();
            if (!isset($data['switch']))
                $data['switch'] = 'off';
            $data['sendtime']="1970-01-01 08:00:00";
	   		if( $this->model->save($data,false)){
	   			$this->success(__('Add successful'));
	   		}else{
	   			$this->error(__('Add failed'));
	   		}
	   	}
		
	   	return View::fetch('edit');
   }
   public function test(){
	   	if($this->request->isPost()){
	   		$data = $this->request->post();
	   		$smtp =  $this->model->where('id',$data['id'])->find();
            $mailer = new PHPMailer(true);                              // Passing `true` enables exceptions
            try {
                //服务器配置
                $mailer->CharSet ="UTF-8";                     //设定邮件编码
                $mailer->SMTPDebug = (int)config('site.debug');                        // 调试模式输出
                $mailer->isSMTP();                             // 使用SMTP
                $mailer->Host = $smtp['server'];                // SMTP服务器
                $mailer->SMTPAuth = true;                      // 允许 SMTP 认证
                $mailer->Username = $smtp['username'];                // SMTP 用户名  即邮箱的用户名
                $mailer->Password = $smtp['password'];             // SMTP 密码  部分邮箱是授权码(例如163邮箱)
                if($smtp['encryption'] != 1){
                    $mailer->SMTPSecure = "ssl";                    // 允许 TLS 或者ssl协议
                }
                $mailer->Port = $smtp['port'];                            // 服务器端口 25 或者465 具体要看邮箱服务器支持
                $mailer->setFrom($smtp['username'], '测试发件人');  //发件人
                $mailer->addReplyTo($smtp['username'], '测试发件人'); //回复的时候回复给哪个邮箱 建议和发件人一致
                $mailer->isHTML(true);                                  // 是否以HTML文档格式发送  发送后客户端可直接显示对应HTML内容
                $mailer->Subject = '测试标题';
                $mailer->Body    = '测试内容';
                $mailer->addAddress($data['email'], '测试收件人');  // 收件人
                $mailer->send();
                $mailer->clearAddresses();
                $this->success('发送成功');
            } catch (Exception $e) {
                $error = $mailer->ErrorInfo;
                if($error == "SMTP Error: Could not authenticate."){
                    $error = "登陆失败，请检查登陆信息是否正确。";
                }
                $this->error($error);
            }
	   	}
		$id = $this->request->param('id');
	   	if(!$id){
	   		$this->success(__('Parameter error'));
	   	}
	   	$info =  $this->model->where('id',$id)->find();
   		if(!$info){
	   		$this->success(__('Parameter error'));
	   	}
		
	   	View::assign('smtp',$info);
	   	return View::fetch('test');
   }


   public function leading(){
   	   	if($this->request->isPost()){
   	   		$file = $_FILES['file'];
   	   		$inputFileName = $file['tmp_name'];
            try {
                ob_end_clean();//清除缓冲区,避免乱码
                $inputFileType = \PHPExcel_IOFactory::identify($inputFileName);

                $objReader  = \PHPExcel_IOFactory::createReader($inputFileType);

                $objPHPExcel = $objReader->load($inputFileName);
            } catch(\Exception $e) {
                 die('加载文件发生错误：”'.pathinfo($inputFileName,PATHINFO_BASENAME).'”: '.$e->getMessage());
            }
            //形成数组
             $excel_data = $objPHPExcel->getSheet(0)->toArray();


            $insert_data = array();
            foreach($excel_data as $k=>$v){
        
                
        if($k>0){
           
        $insert_data[$k]['server'] = isset($v[0]) ? $v[0] : '';
$insert_data[$k]['encryption'] = isset($v[1]) ? $v[1] : '';
$insert_data[$k]['port'] = isset($v[2]) ? $v[2] : '';
$insert_data[$k]['username'] = isset($v[3]) ? $v[3] : '';
$insert_data[$k]['password'] = isset($v[4]) ? $v[4] : '';
$insert_data[$k]['switch'] = isset($v[6]) ? $v[6] : '';
}
            }


   	   		if( $this->model->saveAll($insert_data,false)){
   	   			$this->success(__('Add successful'));
   	   		}else{
   	   			$this->error(__('Add failed'));
   	   		}
   	   	}
   		
   	   	return View::fetch('leading');
     }

   public function edit(){
	   	if($this->request->isPost()){
	   		$data = $this->request->post();
            if (!isset($data['switch']))
                            $data['switch'] = 'off';
                            
            if( $this->model->find($data['id'])->save($data)){
	   			$this->success(__('Editor successful'));
	   		}else{
	   			$this->error(__('Editor failed'));
	   		}
	   	}
	   	$id = $this->request->param('id');
	   	if(!$id){
	   		$this->success(__('Parameter error'));
	   	}
	   	$info =  $this->model->where('id',$id)->find();
   		if(!$info){
	   		$this->success(__('Parameter error'));
	   	}
		
	   	View::assign('smtp',$info);
        return View::fetch('edit');
   }

   public function delete(){
   		$idsStr = $this->request->param('idsStr');
   		if(!$idsStr){
   			$this->success(__('Parameter error'));
   		}
   		if( $this->model->where('id','in',$idsStr)->delete()){
   			$this->success(__('Delete successful'));
   		}else{
   			$this->error(__('Delete error'));
   		}
   }

   public function sw(){
      	$data = $this->request->param();
            if( $this->model->where('id',$data['id'])->update($data)){
                 $this->success(__('Editor successful'));
            }else{
                 $this->error(__('Editor failed'));
            }
      }

}
