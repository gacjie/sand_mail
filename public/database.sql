-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- 主机： localhost
-- 生成日期： 2022-05-11 14:33:02
-- 服务器版本： 5.5.62-log
-- PHP 版本： 7.4.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `www_email_cc`
--

-- --------------------------------------------------------

--
-- 表的结构 `cm_admin`
--

CREATE TABLE `cm_admin` (
  `id` int(10) UNSIGNED NOT NULL COMMENT 'ID',
  `username` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '用户名',
  `nickname` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '昵称',
  `password` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密码',
  `salt` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密码盐',
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '头像',
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '电子邮箱',
  `loginfailure` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '失败次数',
  `logintime` int(10) DEFAULT NULL COMMENT '登录时间',
  `loginip` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '登录IP',
  `createtime` int(10) DEFAULT NULL COMMENT '创建时间',
  `updatetime` int(10) DEFAULT NULL COMMENT '更新时间',
  `token` varchar(59) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Session标识',
  `status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'normal' COMMENT '状态'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员表';

--
-- 转存表中的数据 `cm_admin`
--

INSERT INTO `cm_admin` (`id`, `username`, `nickname`, `password`, `salt`, `avatar`, `email`, `loginfailure`, `logintime`, `loginip`, `createtime`, `updatetime`, `token`, `status`) VALUES
(1, 'admin', 'Admin', '127ada38d1af636e313a787ef2e6f43d', 'p9t3fc', '/static/images/avatar.png', 'admin@admin.com', 0, 1600298414, '123.196.11.216', 1492186163, 1601174630, '04e8afb9-646c-4a41-8452-cd6330c3232b', 'normal');

-- --------------------------------------------------------

--
-- 表的结构 `cm_auth_group`
--

CREATE TABLE `cm_auth_group` (
  `id` int(10) UNSIGNED NOT NULL,
  `createtime` int(11) NOT NULL,
  `updatetime` int(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  `status` varchar(30) DEFAULT 'normal' COMMENT '状态',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '角色组',
  `rules` text COMMENT '权限',
  `remark` text COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色组管理';

--
-- 转存表中的数据 `cm_auth_group`
--

INSERT INTO `cm_auth_group` (`id`, `createtime`, `updatetime`, `status`, `title`, `rules`, `remark`) VALUES
(1, 1601170339, 1650810307, 'normal', '超级管理员', '0,37,38,39,40,31,33,34,32,26,29,28,27,46,49,47,48,1,6,5,4,2,3,7', '超级管理员');

-- --------------------------------------------------------

--
-- 表的结构 `cm_auth_group_access`
--

CREATE TABLE `cm_auth_group_access` (
  `uid` mediumint(8) UNSIGNED NOT NULL,
  `group_id` mediumint(8) UNSIGNED NOT NULL,
  `createtime` int(11) DEFAULT '0' COMMENT '添加时间',
  `updatetime` int(11) DEFAULT '0' COMMENT '修改时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `cm_auth_group_access`
--

INSERT INTO `cm_auth_group_access` (`uid`, `group_id`, `createtime`, `updatetime`) VALUES
(1, 1, 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `cm_auth_rule`
--

CREATE TABLE `cm_auth_rule` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` tinyint(4) NOT NULL DEFAULT '1',
  `pid` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '父ID',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '规则名称',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '规则名称',
  `icon` varchar(50) NOT NULL DEFAULT 'fa-circle-o' COMMENT '图标',
  `condition` varchar(255) NOT NULL DEFAULT '' COMMENT '条件',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `ismenu` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '是否为菜单',
  `createtime` int(10) DEFAULT NULL COMMENT '创建时间',
  `updatetime` int(10) DEFAULT NULL COMMENT '更新时间',
  `weigh` int(10) NOT NULL DEFAULT '0' COMMENT '权重',
  `status` varchar(30) NOT NULL DEFAULT 'normal' COMMENT '状态',
  `auth_open` tinyint(4) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='节点表';

--
-- 转存表中的数据 `cm_auth_rule`
--

INSERT INTO `cm_auth_rule` (`id`, `type`, `pid`, `name`, `title`, `icon`, `condition`, `remark`, `ismenu`, `createtime`, `updatetime`, `weigh`, `status`, `auth_open`) VALUES
(1, 1, 0, 'admin/Auth', '权限管理', 'fa-group', '', '', 1, 1601167936, 1633571964, 99, 'normal', 1),
(2, 1, 1, 'admin/index', '人员管理', 'fa-group', '', '', 1, NULL, 1633074665, 2, 'normal', 1),
(3, 1, 1, 'AuthGroup/index', '角色管理', 'fa-group', '', '', 1, 1601168043, 1633074681, 100, 'normal', 1),
(4, 1, 6, 'AuthRule/add', '菜单添加', 'fa-add', '', '', 0, 1601122750, 1633074703, 100, 'normal', 1),
(5, 1, 6, 'AuthRule/edit', '菜单编辑', 'fa-edit', '', '', 0, 1601122878, 1601123339, 100, 'normal', 1),
(6, 1, 1, 'AuthRule/index', '菜单管理', 'fa-bars', '', '', 1, NULL, 1633074651, 1, 'normal', 1),
(7, 1, 0, 'general.Config/index', '系统设置', 'fa-gear', '', '', 1, NULL, 1633571952, 99, 'normal', 1),
(26, 1, 0, 'temp/index', '邮件模板', 'fa-list', '', '', 1, 1633078055, 1633571939, 3, 'normal', 1),
(27, 1, 26, 'temp/add', '添加', '', '', '', 0, 1633078055, 1633078055, 0, 'normal', 1),
(28, 1, 26, 'temp/edit', '编辑 ', '', '', '', 0, 1633078055, 1633078055, 0, 'normal', 1),
(29, 1, 26, 'temp/del', '删除', '', '', '', 0, 1633078055, 1633078055, 0, 'normal', 1),
(31, 1, 0, 'email/index', '收件信箱', 'fa-list', '', '', 1, 1633078172, 1633571912, 1, 'normal', 1),
(32, 1, 31, 'email/add', '添加', '', '', '', 0, 1633078172, 1633078172, 0, 'normal', 1),
(33, 1, 31, 'email/edit', '编辑 ', '', '', '', 0, 1633078172, 1633078172, 0, 'normal', 1),
(34, 1, 31, 'email/del', '删除', '', '', '', 0, 1633078172, 1633078172, 0, 'normal', 1),
(37, 1, 0, 'send_log/index', '发信日志', 'fa-list', '', '', 1, 1633571843, 1633571873, 0, 'normal', 1),
(38, 1, 37, 'send_log/add', '添加', '', '', '', 0, 1633571843, 1633571843, 0, 'normal', 1),
(39, 1, 37, 'send_log/edit', '编辑 ', '', '', '', 0, 1633571843, 1633571843, 0, 'normal', 1),
(40, 1, 37, 'send_log/del', '删除', '', '', '', 0, 1633571843, 1633571843, 0, 'normal', 1),
(46, 1, 0, 'smtp/index', '发信地址', 'fa-list', '', '', 1, 1633583761, 1633583806, 3, 'normal', 1),
(47, 1, 46, 'smtp/add', '添加', '', '', '', 0, 1633583761, 1633583761, 0, 'normal', 1),
(48, 1, 46, 'smtp/edit', '编辑 ', '', '', '', 0, 1633583761, 1633583761, 0, 'normal', 1),
(49, 1, 46, 'smtp/del', '删除', '', '', '', 0, 1633583761, 1633583761, 0, 'normal', 1);

-- --------------------------------------------------------

--
-- 表的结构 `cm_config`
--

CREATE TABLE `cm_config` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '变量名',
  `group` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '分组',
  `title` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '变量标题',
  `tip` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '变量描述',
  `type` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '类型:string,text,int,bool,array,datetime,date,file',
  `value` text COLLATE utf8mb4_unicode_ci COMMENT '变量值',
  `content` text COLLATE utf8mb4_unicode_ci COMMENT '变量字典数据',
  `rule` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '验证规则',
  `extend` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '扩展属性',
  `setting` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '配置'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置';

--
-- 转存表中的数据 `cm_config`
--

INSERT INTO `cm_config` (`id`, `name`, `group`, `title`, `tip`, `type`, `value`, `content`, `rule`, `extend`, `setting`) VALUES
(1, 'name', 'basic', '站点名称', '请填写站点名称', 'string', '邮件群发系统', '', 'required', 'class=\"layui-input\"', NULL),
(2, 'beian', 'basic', '备案号', '粤ICP备15000000号-1', 'string', '', '', '', 'class=\"layui-input\"', NULL),
(3, 'sleep', 'basic', '延时执行(秒)', '', 'string', '1', '{\"1\":\"\"}', '', 'class=\"layui-input\"', NULL),
(4, 'limit', 'basic', '任务限额', '', 'string', '10', '{\"1\":\"\"}', '', 'class=\"layui-input\"', NULL),
(5, 'interval', 'basic', '发信间隔(秒)', '', 'string', '86400', '{\"1\":\"\"}', '', 'class=\"layui-input\"', NULL),
(6, 'sname', 'basic', '发件名称', '', 'string', '筱杰小栈', '{\"1\":\"\"}', '', 'class=\"layui-input\"', NULL),
(7, 'mode', 'basic', '群发模式', '', 'select', '2', '{\"1\":\"\\u6279\\u91cf\\u53d1\\u9001\",\"2\":\"\\u5206\\u522b\\u53d1\\u9001\"}', '', '', NULL),
(8, 'num', 'basic', '群发数量', '', 'string', '1', '{\"1\":\"\"}', '', 'class=\"layui-input\"', NULL),
(9, 'debug', 'basic', '调试模式', '', 'select', '0', '{\"0\":\"(0)\\u7981\\u7528\\u8c03\\u8bd5\",\"1\":\"(1)\\u8f93\\u51fa\\u5ba2\\u6237\\u7aef\\u6d88\\u606f\",\"2\":\"(2)\\u8f93\\u51fa\\u670d\\u52a1\\u5668\\u54cd\\u5e94\",\"3\":\"(3)\\u8f93\\u51fa\\u521d\\u59cb\\u8fde\\u63a5\\u4fe1\\u606f\",\"4\":\"(4)\\u8f93\\u51fa\\u5e95\\u5c42\\u7684\\u4fe1\\u606f\"}', '', '', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `cm_email`
--

CREATE TABLE `cm_email` (
  `id` int(10) UNSIGNED NOT NULL COMMENT '用户编号',
  `name` text NOT NULL COMMENT '用户名称',
  `email` text NOT NULL COMMENT '邮件地址',
  `switch` text NOT NULL COMMENT '状态开关'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='收件信箱';

-- --------------------------------------------------------

--
-- 表的结构 `cm_send_log`
--

CREATE TABLE `cm_send_log` (
  `id` int(10) UNSIGNED NOT NULL COMMENT '日志编号',
  `email` text NOT NULL COMMENT '收件邮箱',
  `smail` text NOT NULL COMMENT '发信邮箱',
  `temp` text NOT NULL COMMENT '模版名称',
  `stime` int(11) NOT NULL COMMENT '发信时间',
  `status` text NOT NULL COMMENT '发信状态'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='发信日志';

-- --------------------------------------------------------

--
-- 表的结构 `cm_smtp`
--

CREATE TABLE `cm_smtp` (
  `id` int(10) UNSIGNED NOT NULL COMMENT '发信编号',
  `server` text NOT NULL COMMENT '邮箱主机',
  `encryption` enum('1','2') NOT NULL COMMENT '加密方式:1=不支持,2=ssl',
  `port` int(11) NOT NULL COMMENT '发信端口',
  `username` text NOT NULL COMMENT '发信账号',
  `password` text NOT NULL COMMENT '发信密码',
  `sendtime` int(11) NOT NULL COMMENT '上次发信',
  `switch` text NOT NULL COMMENT '状态开关'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='发信地址';

-- --------------------------------------------------------

--
-- 表的结构 `cm_temp`
--

CREATE TABLE `cm_temp` (
  `id` int(10) UNSIGNED NOT NULL COMMENT '邮件编号',
  `name` text NOT NULL COMMENT '邮件标题',
  `content` text NOT NULL COMMENT '邮件内容',
  `switch` text NOT NULL COMMENT '状态开关'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='邮件模板';

--
-- 转储表的索引
--

--
-- 表的索引 `cm_admin`
--
ALTER TABLE `cm_admin`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `cm_auth_group`
--
ALTER TABLE `cm_auth_group`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `cm_auth_group_access`
--
ALTER TABLE `cm_auth_group_access`
  ADD UNIQUE KEY `uid_group_id` (`uid`,`group_id`),
  ADD KEY `uid` (`uid`),
  ADD KEY `group_id` (`group_id`);

--
-- 表的索引 `cm_auth_rule`
--
ALTER TABLE `cm_auth_rule`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`) USING BTREE,
  ADD KEY `pid` (`pid`),
  ADD KEY `weigh` (`weigh`);

--
-- 表的索引 `cm_config`
--
ALTER TABLE `cm_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- 表的索引 `cm_email`
--
ALTER TABLE `cm_email`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `cm_send_log`
--
ALTER TABLE `cm_send_log`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `cm_smtp`
--
ALTER TABLE `cm_smtp`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `cm_temp`
--
ALTER TABLE `cm_temp`
  ADD PRIMARY KEY (`id`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `cm_admin`
--
ALTER TABLE `cm_admin`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID', AUTO_INCREMENT=3;

--
-- 使用表AUTO_INCREMENT `cm_auth_group`
--
ALTER TABLE `cm_auth_group`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `cm_auth_rule`
--
ALTER TABLE `cm_auth_rule`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- 使用表AUTO_INCREMENT `cm_config`
--
ALTER TABLE `cm_config`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- 使用表AUTO_INCREMENT `cm_email`
--
ALTER TABLE `cm_email`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户编号';

--
-- 使用表AUTO_INCREMENT `cm_send_log`
--
ALTER TABLE `cm_send_log`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '日志编号';

--
-- 使用表AUTO_INCREMENT `cm_smtp`
--
ALTER TABLE `cm_smtp`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '发信编号';

--
-- 使用表AUTO_INCREMENT `cm_temp`
--
ALTER TABLE `cm_temp`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '邮件编号';
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
