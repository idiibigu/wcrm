/*M!999999\- enable the sandbox mode */ 

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;
DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(999) DEFAULT NULL,
  `password` varchar(999) DEFAULT NULL,
  `uid` varchar(999) DEFAULT NULL,
  `role` varchar(999) NOT NULL DEFAULT 'admin',
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `tokenVersion` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `agent_chats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent_chats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_uid` varchar(999) DEFAULT NULL,
  `uid` varchar(999) DEFAULT NULL,
  `chat_id` varchar(999) DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `agent_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent_task` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_uid` varchar(999) DEFAULT NULL,
  `uid` varchar(999) DEFAULT NULL,
  `title` varchar(999) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `agent_comments` longtext DEFAULT NULL,
  `status` varchar(999) DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `agents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `agents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_uid` varchar(999) DEFAULT NULL,
  `uid` varchar(999) DEFAULT NULL,
  `role` varchar(999) DEFAULT 'agent',
  `email` varchar(999) DEFAULT NULL,
  `password` varchar(999) DEFAULT NULL,
  `name` varchar(999) DEFAULT NULL,
  `mobile` varchar(999) DEFAULT NULL,
  `comments` longtext DEFAULT NULL,
  `is_active` int(1) DEFAULT 1,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  `logs` longtext DEFAULT NULL,
  `mask_number` int(11) DEFAULT 1,
  `allow_send_new_qr` int(11) DEFAULT 0,
  `allow_save_contact` int(11) DEFAULT 0,
  `fcm_data` longtext DEFAULT NULL,
  `tokenVersion` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_owner_uid` (`owner_uid`(150)),
  KEY `idx_uid` (`uid`(150)),
  KEY `idx_owner_active` (`owner_uid`(150),`is_active`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth` (
  `session` varchar(50) NOT NULL,
  `id` varchar(80) NOT NULL,
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`value`)),
  UNIQUE KEY `idxunique` (`session`,`id`),
  KEY `idxsession` (`session`),
  KEY `idxid` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `beta_api_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `beta_api_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `msg_id` varchar(999) DEFAULT NULL,
  `request` longtext DEFAULT NULL,
  `err` longtext DEFAULT NULL,
  `response` longtext DEFAULT NULL,
  `status` varchar(999) DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `beta_campaign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `beta_campaign` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `campaign_id` varchar(999) NOT NULL,
  `uid` varchar(999) NOT NULL,
  `title` varchar(999) NOT NULL,
  `template_name` varchar(999) NOT NULL,
  `template_language` varchar(999) NOT NULL,
  `phonebook_id` varchar(999) NOT NULL,
  `phonebook_name` varchar(999) NOT NULL,
  `status` varchar(999) NOT NULL DEFAULT 'PENDING',
  `total_contacts` int(11) NOT NULL DEFAULT 0,
  `sent_count` int(11) NOT NULL DEFAULT 0,
  `delivered_count` int(11) NOT NULL DEFAULT 0,
  `read_count` int(11) NOT NULL DEFAULT 0,
  `failed_count` int(11) NOT NULL DEFAULT 0,
  `body_variables` longtext DEFAULT NULL,
  `header_variable` longtext DEFAULT NULL,
  `button_variables` longtext DEFAULT NULL,
  `schedule` datetime DEFAULT NULL,
  `timezone` varchar(999) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `template_type` varchar(20) DEFAULT 'STANDARD',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `beta_campaign_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `beta_campaign_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) NOT NULL,
  `campaign_id` varchar(999) NOT NULL,
  `contact_name` varchar(999) NOT NULL,
  `contact_mobile` varchar(999) NOT NULL,
  `meta_msg_id` varchar(999) DEFAULT NULL,
  `status` varchar(999) NOT NULL DEFAULT 'PENDING',
  `delivery_status` varchar(999) DEFAULT NULL,
  `delivery_time` varchar(999) DEFAULT NULL,
  `error_message` longtext DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `beta_chatbot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `beta_chatbot` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `source` varchar(999) DEFAULT 'wa_chatbot',
  `title` varchar(999) DEFAULT NULL,
  `flow_id` varchar(999) DEFAULT NULL,
  `active` int(11) DEFAULT 1,
  `origin` longtext DEFAULT NULL,
  `origin_id` varchar(999) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_uid_active` (`uid`(150),`active`),
  KEY `idx_uid_origin` (`uid`(100),`origin_id`(100)),
  KEY `idx_uid_flow` (`uid`(120),`flow_id`(120)),
  KEY `idx_uid_source_active` (`uid`(100),`source`(50),`active`)
) ENGINE=InnoDB AUTO_INCREMENT=123 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `beta_chats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `beta_chats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `old_chat_id` varchar(999) DEFAULT NULL,
  `profile` longtext DEFAULT NULL,
  `origin_instance_id` varchar(999) DEFAULT NULL,
  `chat_id` varchar(999) DEFAULT NULL,
  `last_message` longtext DEFAULT NULL,
  `chat_label` longtext DEFAULT NULL,
  `chat_note` longtext DEFAULT NULL,
  `sender_name` varchar(999) DEFAULT NULL,
  `sender_mobile` varchar(999) DEFAULT NULL,
  `unread_count` bigint(20) DEFAULT 0,
  `origin` varchar(999) DEFAULT NULL,
  `assigned_agent` longtext DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `kanban_order` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_uid_chatid` (`uid`(100),`chat_id`(100)),
  KEY `idx_uid_origin` (`uid`(120),`origin`(50)),
  KEY `idx_uid_updated` (`uid`(150)),
  KEY `idx_sender_mobile` (`sender_mobile`(150)),
  KEY `idx_uid_unread` (`uid`(150),`unread_count`),
  KEY `idx_uid_origin_updated` (`uid`(80),`origin`(50)),
  KEY `idx_beta_chats_uid_updatedAt` (`uid`(100),`updatedAt`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `beta_conversation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `beta_conversation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(999) DEFAULT NULL,
  `chat_id` varchar(999) DEFAULT NULL,
  `uid` varchar(999) DEFAULT NULL,
  `status` varchar(999) DEFAULT NULL,
  `metaChatId` varchar(999) DEFAULT NULL,
  `msgContext` longtext DEFAULT NULL,
  `reaction` varchar(999) DEFAULT NULL,
  `timestamp` varchar(999) DEFAULT NULL,
  `senderName` varchar(999) DEFAULT NULL,
  `senderMobile` varchar(999) DEFAULT NULL,
  `star` varchar(999) DEFAULT NULL,
  `route` varchar(999) DEFAULT NULL,
  `context` longtext DEFAULT NULL,
  `origin` varchar(999) DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  `sentBy` varchar(999) DEFAULT NULL,
  `err` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_uid_chat_route` (`uid`(50),`chat_id`(50),`route`(50)),
  KEY `idx_uid_metachatid` (`uid`(100),`metaChatId`(100)),
  KEY `idx_chat_timestamp` (`chat_id`(100)),
  KEY `idx_uid_chat_timestamp` (`uid`(50),`chat_id`(50)),
  KEY `idx_chat_type_route` (`chat_id`(80),`type`(50),`route`(50))
) ENGINE=InnoDB AUTO_INCREMENT=468 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `beta_flows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `beta_flows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `is_active` int(11) DEFAULT 1,
  `uid` varchar(999) DEFAULT NULL,
  `flow_id` varchar(999) DEFAULT NULL,
  `source` varchar(999) DEFAULT NULL,
  `name` varchar(999) DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_uid_active_source` (`uid`(120),`is_active`,`source`(50)),
  KEY `idx_uid_flow` (`uid`(120),`flow_id`(120))
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `broadcast`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `broadcast` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `broadcast_id` varchar(999) DEFAULT NULL,
  `uid` varchar(999) DEFAULT NULL,
  `title` varchar(999) DEFAULT NULL,
  `templet` longtext DEFAULT NULL,
  `phonebook` longtext DEFAULT NULL,
  `status` varchar(999) DEFAULT NULL,
  `schedule` datetime DEFAULT NULL,
  `timezone` varchar(999) DEFAULT 'Asia/Kolkata',
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `broadcast_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `broadcast_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `broadcast_id` varchar(999) DEFAULT NULL,
  `templet_name` varchar(999) DEFAULT NULL,
  `is_read` int(1) DEFAULT 0,
  `meta_msg_id` varchar(999) DEFAULT NULL,
  `sender_mobile` varchar(999) DEFAULT NULL,
  `send_to` varchar(999) DEFAULT NULL,
  `delivery_status` varchar(999) DEFAULT 'PENDING',
  `delivery_time` varchar(999) DEFAULT NULL,
  `err` longtext DEFAULT NULL,
  `example` longtext DEFAULT NULL,
  `contact` longtext DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `chat_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `hex` varchar(999) DEFAULT NULL,
  `title` longtext DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  `show_on_kanban` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `idx_uid` (`uid`(150))
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `chat_widget`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_widget` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unique_id` varchar(999) DEFAULT NULL,
  `uid` varchar(999) DEFAULT NULL,
  `title` varchar(999) DEFAULT NULL,
  `whatsapp_number` varchar(999) DEFAULT NULL,
  `logo` varchar(999) DEFAULT NULL,
  `place` varchar(999) DEFAULT NULL,
  `size` varchar(999) DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `chatbot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `chatbot` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `title` varchar(999) DEFAULT NULL,
  `for_all` int(1) DEFAULT 0,
  `chats` longtext DEFAULT NULL,
  `flow` longtext DEFAULT NULL,
  `flow_id` varchar(999) DEFAULT NULL,
  `active` int(1) DEFAULT 0,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `origin` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `chats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `chats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chat_id` varchar(999) DEFAULT NULL,
  `uid` varchar(999) DEFAULT NULL,
  `last_message_came` varchar(999) DEFAULT NULL,
  `chat_note` longtext DEFAULT NULL,
  `chat_tags` longtext DEFAULT NULL,
  `sender_name` varchar(999) DEFAULT NULL,
  `sender_mobile` varchar(999) DEFAULT NULL,
  `chat_status` varchar(999) DEFAULT 'open',
  `is_opened` int(1) DEFAULT 0,
  `last_message` longtext DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `origin` varchar(999) DEFAULT 'meta',
  `profile` longtext DEFAULT NULL,
  `other` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `phonebook_id` varchar(999) DEFAULT NULL,
  `phonebook_name` varchar(999) DEFAULT NULL,
  `name` varchar(999) DEFAULT NULL,
  `mobile` varchar(999) DEFAULT NULL,
  `var1` varchar(999) DEFAULT NULL,
  `var2` varchar(999) DEFAULT NULL,
  `var3` varchar(999) DEFAULT NULL,
  `var4` varchar(999) DEFAULT NULL,
  `var5` varchar(999) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `var6` varchar(999) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_uid_mobile` (`uid`(120),`mobile`(80)),
  KEY `idx_uid` (`uid`(150))
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `contact_form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_form` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(999) DEFAULT NULL,
  `name` varchar(999) DEFAULT NULL,
  `mobile` varchar(999) DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `faq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `faq` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` longtext DEFAULT NULL,
  `answer` longtext DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `fcm_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fcm_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `token` text DEFAULT NULL,
  `other` longtext DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `flow_id` varchar(999) DEFAULT NULL,
  `title` varchar(999) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `prevent_list` longtext DEFAULT NULL,
  `ai_list` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flow_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `uniqueId` varchar(999) DEFAULT NULL,
  `inputs` longtext DEFAULT NULL,
  `other` longtext DEFAULT NULL,
  `meta_data` longtext DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flow_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_session` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `origin` varchar(999) DEFAULT NULL,
  `origin_id` varchar(999) DEFAULT NULL,
  `flow_id` varchar(999) DEFAULT NULL,
  `sender_mobile` varchar(999) DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_uid_flow_sender` (`uid`(50),`flow_id`(50),`sender_mobile`(80)),
  KEY `idx_uid_flow` (`uid`(120),`flow_id`(120)),
  KEY `idx_uid_origin_flow` (`uid`(80),`origin`(50),`flow_id`(80))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `flow_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `source` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `data` longtext NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `g_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `g_auth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `label` varchar(999) DEFAULT NULL,
  `url` longtext DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `gen_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wa_mobile` varchar(999) DEFAULT NULL,
  `email` varchar(999) DEFAULT NULL,
  `msg` varchar(999) DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `instagram_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `instagram_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` text DEFAULT NULL,
  `webhook_id` text DEFAULT NULL,
  `ig_graph_id` text DEFAULT NULL,
  `user_id` text DEFAULT NULL,
  `page_id` text DEFAULT NULL,
  `username` text DEFAULT NULL,
  `name` text DEFAULT NULL,
  `profile_pic` longtext DEFAULT NULL,
  `access_token` longtext DEFAULT NULL,
  `token_type` text DEFAULT NULL,
  `expires_in` bigint(20) DEFAULT NULL,
  `connected_at` datetime DEFAULT NULL,
  `other` longtext DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `instance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `title` varchar(999) DEFAULT NULL,
  `number` varchar(999) DEFAULT NULL,
  `uniqueId` varchar(999) DEFAULT NULL,
  `qr` longtext DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  `other` longtext DEFAULT NULL,
  `status` longtext DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_uniqueid` (`uniqueId`(150)),
  KEY `idx_uid_status` (`uid`(120),`status`(50)),
  KEY `idx_uid` (`uid`(150))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `messenger_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `messenger_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `page_id` varchar(999) DEFAULT NULL,
  `page_name` varchar(999) DEFAULT NULL,
  `page_access_token` longtext DEFAULT NULL,
  `user_access_token` longtext DEFAULT NULL,
  `profile_pic` varchar(999) DEFAULT NULL,
  `webhook_id` varchar(999) DEFAULT NULL,
  `connected_at` timestamp NULL DEFAULT current_timestamp(),
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `meta_api`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `meta_api` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `waba_id` varchar(999) DEFAULT NULL,
  `business_account_id` varchar(999) DEFAULT NULL,
  `access_token` varchar(999) DEFAULT NULL,
  `business_phone_number_id` varchar(999) DEFAULT NULL,
  `app_id` varchar(999) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `embed_data` longtext DEFAULT NULL,
  `login_type` varchar(999) DEFAULT 'manual',
  `is_coexistence` tinyint(1) DEFAULT 0,
  `platform_type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_uid` (`uid`(150))
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `meta_templet_media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `meta_templet_media` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `templet_name` varchar(999) DEFAULT NULL,
  `meta_hash` varchar(999) DEFAULT NULL,
  `file_name` varchar(999) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `mobile_app`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `mobile_app` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fcmJson` longtext DEFAULT NULL,
  `appTheme` longtext DEFAULT NULL,
  `other` longtext DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `payment_mode` varchar(999) DEFAULT NULL,
  `amount` varchar(999) DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  `s_token` varchar(999) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` varchar(50) DEFAULT 'PENDING',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `page` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `slug` varchar(999) DEFAULT NULL,
  `title` varchar(999) DEFAULT NULL,
  `image` varchar(999) DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `permanent` int(1) DEFAULT 0,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `partners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `partners` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filename` varchar(999) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `phonebook`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phonebook` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(999) DEFAULT NULL,
  `uid` varchar(999) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_uid` (`uid`(150))
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plan` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(999) DEFAULT NULL,
  `short_description` longtext DEFAULT NULL,
  `allow_tag` int(1) DEFAULT 0,
  `allow_note` int(1) DEFAULT 0,
  `allow_chatbot` int(1) DEFAULT 0,
  `contact_limit` varchar(999) DEFAULT NULL,
  `allow_api` int(1) DEFAULT 0,
  `is_trial` int(1) DEFAULT 0,
  `price` bigint(20) DEFAULT NULL,
  `price_strike` varchar(999) DEFAULT NULL,
  `plan_duration_in_days` varchar(999) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `qr_account` int(11) DEFAULT 0,
  `wa_warmer` int(11) DEFAULT 0,
  `rest_api_qr` int(11) DEFAULT 0,
  `instagram_inbox` int(11) DEFAULT 0,
  `telegram_inbox` int(11) DEFAULT 0,
  `allow_wa_forms` int(11) DEFAULT 0,
  `messenger_inbox` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `qr_campaign_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `qr_campaign_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `campaign_id` int(11) DEFAULT NULL,
  `uid` varchar(999) DEFAULT NULL,
  `contact_name` varchar(999) DEFAULT NULL,
  `contact_mobile` varchar(999) DEFAULT NULL,
  `status` varchar(999) DEFAULT NULL,
  `error_msg` longtext DEFAULT NULL,
  `sent_at` timestamp NULL DEFAULT current_timestamp(),
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `read_at` timestamp NULL DEFAULT NULL,
  `delivered_at` timestamp NULL DEFAULT NULL,
  `delivery_status` varchar(999) DEFAULT NULL,
  `message_id` varchar(999) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `qr_campaigns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `qr_campaigns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `title` varchar(999) DEFAULT NULL,
  `instance_id` varchar(999) DEFAULT NULL,
  `phonebook_id` varchar(999) DEFAULT NULL,
  `message_type` varchar(999) DEFAULT NULL,
  `message_text` longtext DEFAULT NULL,
  `media_url` longtext DEFAULT NULL,
  `media_caption` longtext DEFAULT NULL,
  `delay_min` int(11) DEFAULT 5,
  `delay_max` int(11) DEFAULT 15,
  `random_suffix` tinyint(4) DEFAULT 1,
  `status` varchar(999) DEFAULT 'pending',
  `total_contacts` int(11) DEFAULT 0,
  `sent_count` int(11) DEFAULT 0,
  `failed_count` int(11) DEFAULT 0,
  `scheduled_at` datetime DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `other` longtext DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `quick_reply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `quick_reply` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `msg` longtext DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_uid` (`uid`(150))
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `socket_id` varchar(999) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1319 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `smtp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `smtp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(999) DEFAULT NULL,
  `host` varchar(999) DEFAULT NULL,
  `port` varchar(999) DEFAULT NULL,
  `password` varchar(999) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `username` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `telegram_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `telegram_session` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `session_id` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `api_id` varchar(255) DEFAULT NULL,
  `api_hash` varchar(255) DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  `session` longtext DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `session_id` (`session_id`),
  UNIQUE KEY `session_id_2` (`session_id`),
  UNIQUE KEY `session_id_3` (`session_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `templets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `templets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `type` varchar(999) DEFAULT NULL,
  `title` varchar(999) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `testimonial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `testimonial` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(999) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `reviewer_name` varchar(999) DEFAULT NULL,
  `reviewer_position` varchar(999) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `undefined`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `undefined` (
  `session` varchar(50) NOT NULL,
  `id` varchar(80) NOT NULL,
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`value`)),
  UNIQUE KEY `idxunique` (`session`,`id`),
  KEY `idxsession` (`session`),
  KEY `idxid` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(999) DEFAULT 'user',
  `uid` varchar(999) DEFAULT NULL,
  `name` varchar(999) DEFAULT NULL,
  `email` varchar(999) DEFAULT NULL,
  `password` varchar(999) DEFAULT NULL,
  `mobile_with_country_code` varchar(999) DEFAULT NULL,
  `timezone` varchar(999) DEFAULT 'Asia/Kolkata',
  `plan` longtext DEFAULT NULL,
  `plan_expire` varchar(999) DEFAULT NULL,
  `trial` int(1) DEFAULT 0,
  `api_key` varchar(999) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `fcm_data` longtext DEFAULT NULL,
  `fcm_inbox` longtext DEFAULT NULL,
  `tokenVersion` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_uid` (`uid`(150))
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `wa_call_bot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wa_call_bot` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `title` varchar(999) DEFAULT NULL,
  `flow_id` varchar(999) DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  `active` int(11) DEFAULT 1,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `wa_call_broadcasts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wa_call_broadcasts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(255) NOT NULL,
  `campaign_id` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `flow_id` varchar(255) NOT NULL,
  `status` enum('draft','requesting_permissions','ready','running','paused','completed','failed') DEFAULT 'draft',
  `contacts` longtext NOT NULL,
  `call_delay` int(11) DEFAULT 5000,
  `max_concurrent_calls` int(11) DEFAULT 1,
  `retry_failed` tinyint(1) DEFAULT 0,
  `retry_count` int(11) DEFAULT 0,
  `total_contacts` int(11) DEFAULT 0,
  `permission_requested` int(11) DEFAULT 0,
  `permission_granted` int(11) DEFAULT 0,
  `permission_denied` int(11) DEFAULT 0,
  `calls_initiated` int(11) DEFAULT 0,
  `calls_completed` int(11) DEFAULT 0,
  `calls_failed` int(11) DEFAULT 0,
  `logs` longtext DEFAULT NULL,
  `meta_data` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `started_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `campaign_id` (`campaign_id`),
  KEY `idx_uid` (`uid`),
  KEY `idx_status` (`status`),
  KEY `idx_campaign_id` (`campaign_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `wa_call_flows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wa_call_flows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `is_active` int(11) DEFAULT 1,
  `uid` varchar(999) DEFAULT NULL,
  `flow_id` varchar(999) DEFAULT NULL,
  `source` varchar(999) DEFAULT NULL,
  `name` varchar(999) DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `wa_call_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wa_call_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(255) NOT NULL,
  `call_id` varchar(255) NOT NULL,
  `flow_id` varchar(255) DEFAULT NULL,
  `status` enum('connected','ended','failed') DEFAULT 'connected',
  `transcription_json` longtext DEFAULT NULL,
  `recording_user` varchar(255) DEFAULT NULL,
  `recording_assistant` varchar(255) DEFAULT NULL,
  `recording_stereo` varchar(255) DEFAULT NULL,
  `error_message` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `meta_data` text DEFAULT NULL,
  `ended_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_uid` (`uid`),
  KEY `idx_call_id` (`call_id`),
  KEY `idx_flow_id` (`flow_id`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `wa_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wa_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(255) DEFAULT NULL,
  `uniqueId` varchar(255) DEFAULT NULL,
  `jid` varchar(255) DEFAULT NULL,
  `name` varchar(999) DEFAULT NULL,
  `mobile` varchar(50) DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_jid_instance` (`jid`(100),`uniqueId`(100)),
  KEY `idx_wa_contacts_uid_uniqueId` (`uid`(100),`uniqueId`(100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `wa_form_submissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wa_form_submissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` text DEFAULT NULL,
  `flow_id` text DEFAULT NULL,
  `form_name` text DEFAULT NULL,
  `from_phone` text DEFAULT NULL,
  `raw_payload` longtext DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `wa_forms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wa_forms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` text DEFAULT NULL,
  `name` text DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `flow_id` text DEFAULT NULL,
  `flow_status` text DEFAULT NULL,
  `fields_json` longtext DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `warmer_script`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `warmer_script` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `message` longtext DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_uid` (`uid`(150))
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `warmers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `warmers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(999) DEFAULT NULL,
  `instances` longtext DEFAULT NULL,
  `is_active` int(11) DEFAULT 1,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_uid_active` (`uid`(150),`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `web_private`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `web_private` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pay_offline_id` varchar(999) DEFAULT NULL,
  `pay_offline_key` longtext DEFAULT NULL,
  `offline_active` int(1) DEFAULT 0,
  `pay_stripe_id` varchar(999) DEFAULT NULL,
  `pay_stripe_key` varchar(999) DEFAULT NULL,
  `stripe_active` int(1) DEFAULT 0,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `pay_paypal_id` varchar(999) DEFAULT NULL,
  `pay_paypal_key` varchar(999) DEFAULT NULL,
  `paypal_active` varchar(999) DEFAULT NULL,
  `rz_id` varchar(999) DEFAULT NULL,
  `rz_key` varchar(999) DEFAULT NULL,
  `rz_active` varchar(999) DEFAULT NULL,
  `pay_paystack_id` varchar(999) DEFAULT NULL,
  `pay_paystack_key` varchar(999) DEFAULT NULL,
  `paystack_active` varchar(999) DEFAULT NULL,
  `qr_storage` varchar(999) DEFAULT 'local',
  `mongodb_string` longtext DEFAULT NULL,
  `embed_app_sec` varchar(999) DEFAULT NULL,
  `embed_app_id` varchar(999) DEFAULT NULL,
  `embed_app_config` varchar(999) DEFAULT NULL,
  `teleAppId` text DEFAULT NULL,
  `teleHash` text DEFAULT NULL,
  `pay_mercadopago_public_key` text DEFAULT NULL,
  `pay_mercadopago_access_token` text DEFAULT NULL,
  `mercadopago_active` int(1) DEFAULT 0,
  `fcm_apiKey` longtext DEFAULT NULL,
  `fcm_authDomain` longtext DEFAULT NULL,
  `fcm_projectId` longtext DEFAULT NULL,
  `fcm_storageBucket` longtext DEFAULT NULL,
  `fcm_messagingSenderId` longtext DEFAULT NULL,
  `fcm_appId` longtext DEFAULT NULL,
  `fcm_measurementId` longtext DEFAULT NULL,
  `fcm_vapidKey` longtext DEFAULT NULL,
  `fcm_clientEmail` longtext DEFAULT NULL,
  `fcm_privateKey` longtext DEFAULT NULL,
  `insta_app_id` text DEFAULT NULL,
  `insta_app_secret` text DEFAULT NULL,
  `insta_callback_url` text DEFAULT NULL,
  `messenger_app_secret` longtext DEFAULT NULL,
  `messenger_app_id` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `web_public`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `web_public` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `currency_code` varchar(999) DEFAULT NULL,
  `logo` varchar(999) DEFAULT NULL,
  `app_name` varchar(999) DEFAULT NULL,
  `custom_home` varchar(999) DEFAULT NULL,
  `is_custom_home` int(1) DEFAULT 0,
  `meta_description` longtext DEFAULT NULL,
  `currency_symbol` varchar(999) DEFAULT NULL,
  `chatbot_screen_tutorial` varchar(999) DEFAULT NULL,
  `broadcast_screen_tutorial` varchar(999) DEFAULT NULL,
  `home_page_tutorial` varchar(999) DEFAULT NULL,
  `login_header_footer` int(1) DEFAULT 1,
  `exchange_rate` varchar(999) DEFAULT NULL,
  `google_client_id` varchar(999) DEFAULT NULL,
  `google_login_active` int(11) DEFAULT 1,
  `rtl` int(11) DEFAULT 0,
  `other` longtext DEFAULT NULL,
  `fb_login_app_id` varchar(999) DEFAULT NULL,
  `fb_login_active` varchar(999) DEFAULT NULL,
  `fb_login_app_sec` varchar(999) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `webhook_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `webhook_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(255) NOT NULL,
  `webhook_id` varchar(36) NOT NULL,
  `method` enum('GET','POST','PUT','DELETE') NOT NULL DEFAULT 'POST',
  `event_type` varchar(255) DEFAULT 'unknown',
  `payload` text DEFAULT NULL,
  `status` enum('RECEIVED','FAILED') NOT NULL DEFAULT 'RECEIVED',
  `error` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `webhooks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `webhooks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `method` enum('GET','POST','PUT','DELETE') NOT NULL DEFAULT 'POST',
  `secret` varchar(255) DEFAULT NULL,
  `webhook_id` varchar(36) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Clean production bootstrap administrator. Demo accounts and data are intentionally omitted.
INSERT INTO admin (email, password, uid, role, tokenVersion) VALUES ('admin@admin.com', '$2b$12$SHZSjHWp7.iCaO06jVkFZuq3q5Jy.Y9sNwNv5Tz3rihq4D17eL106', '20d3dd0795874a81bbc2329bfc4e2b6e', 'admin', 0);
INSERT INTO web_private (qr_storage) VALUES ('local');
INSERT INTO web_public (currency_code, logo, app_name, meta_description, currency_symbol, google_login_active, fb_login_active) VALUES ('USD', 'wcrm-by-idiibi.png', 'WCRM by Idiibi', 'WCRM by Idiibi brings WhatsApp customer management and automation together in one platform.', '$', 0, 0);
