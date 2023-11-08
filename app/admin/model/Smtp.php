<?php

namespace app\admin\model;

use think\Model;

class Smtp extends Model
{

    // 开启自动写入时间戳字段
    protected $autoWriteTimestamp = 'int';
    // 定义时间戳字段名
    protected $createTime = 'createtime';
    //protected $updateTime = 'updatetime';


    public function getEncryptionAttr($value)
{
    $arr = array (
  1 => '不支持',
  2 => 'ssl',
);
    $data = explode(',',$value);
    foreach($data as &$item){
        if(array_key_exists($item,$arr)){
            $item = $arr[$item];
        }
    }
    $this->set('encryption_name',implode(',',$data)) ;
    $this->append(array_merge($this->append,['encryption_name']));
    return $value;
}
public function getSendtimeAttr($value)
{
    if($value){
        return date('Y-m-d H:i:s',$value);
    }else{
        return null;
    }
   
}
public function setSendtimeAttr($value)
{
    return strtotime($value);
}

    
public function scopeDateRange($query,$field,$data)
{
    if(is_string($data)){
        $arr  =explode(' - ',$data);
        if(count($arr)==2){
            $query->whereTime($field, 'between', $arr) ;
        }
    }
}
}