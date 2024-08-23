-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jul 08, 2024 at 03:02 PM
-- Server version: 8.0.31
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `defence_student`
--

-- --------------------------------------------------------

--
-- Table structure for table `attachments`
--

DROP TABLE IF EXISTS `attachments`;
CREATE TABLE IF NOT EXISTS `attachments` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filename` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `driver` int NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `post_id` bigint UNSIGNED DEFAULT NULL,
  `message_id` bigint UNSIGNED DEFAULT NULL,
  `coconut_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `has_thumbnail` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `payment_request_id` bigint UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `attachments_user_id_foreign` (`user_id`),
  KEY `attachments_post_id_foreign` (`post_id`),
  KEY `attachments_message_id_foreign` (`message_id`),
  KEY `attachments_type_index` (`type`),
  KEY `attachments_payment_request_id_foreign` (`payment_request_id`),
  KEY `attachments_coconut_id_index` (`coconut_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `attachments`
--

INSERT INTO `attachments` (`id`, `filename`, `driver`, `type`, `user_id`, `post_id`, `message_id`, `coconut_id`, `has_thumbnail`, `created_at`, `updated_at`, `payment_request_id`) VALUES
('1ca5ad2584cc472fac5a68cbcc8ac3cd', 'posts/images/1ca5ad2584cc472fac5a68cbcc8ac3cd.jpg', 0, 'jpg', 3, 1, NULL, NULL, 1, '2024-07-05 07:36:30', '2024-07-05 07:37:09', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `contact_messages`
--

DROP TABLE IF EXISTS `contact_messages`;
CREATE TABLE IF NOT EXISTS `contact_messages` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `contact_messages_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
CREATE TABLE IF NOT EXISTS `countries` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `countries_name_unique` (`name`),
  KEY `countries_country_code_index` (`country_code`),
  KEY `countries_phone_code_index` (`phone_code`)
) ENGINE=InnoDB AUTO_INCREMENT=251 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `countries`
--

INSERT INTO `countries` (`id`, `name`, `country_code`, `phone_code`, `created_at`, `updated_at`) VALUES
(1, 'All', NULL, NULL, '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(2, 'Afghanistan', 'AF', '93', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(3, 'Albania', 'AL', '355', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(4, 'Algeria', 'DZ', '213', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(5, 'American Samoa', 'AS', '1684', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(6, 'Andorra', 'AD', '376', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(7, 'Angola', 'AO', '244', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(8, 'Anguilla', 'AI', '1264', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(9, 'Antarctica', 'AQ', '672', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(10, 'Antigua and Barbuda', 'AG', '1268', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(11, 'Argentina', 'AR', '54', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(12, 'Armenia', 'AM', '374', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(13, 'Aruba', 'AW', '297', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(14, 'Australia', 'AU', '61', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(15, 'Austria', 'AT', '43', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(16, 'Azerbaijan', 'AZ', '994', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(17, 'Bahamas (the)', 'BS', '1242', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(18, 'Bahrain', 'BH', '973', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(19, 'Bangladesh', 'BD', '880', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(20, 'Barbados', 'BB', '1246', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(21, 'Belarus', 'BY', '375', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(22, 'Belgium', 'BE', '32', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(23, 'Belize', 'BZ', '501', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(24, 'Benin', 'BJ', '229', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(25, 'Bermuda', 'BM', '1441', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(26, 'Bhutan', 'BT', '975', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(27, 'Bolivia (Plurinational State of)', 'BO', '591', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(28, 'Bonaire, Sint Eustatius and Saba', 'BQ', '599', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(29, 'Bosnia and Herzegovina', 'BA', '387', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(30, 'Botswana', 'BW', '267', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(31, 'Bouvet Island', 'BV', '55', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(32, 'Brazil', 'BR', '55', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(33, 'British Indian Ocean Territory (the)', 'IO', '246', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(34, 'Brunei Darussalam', 'BN', '673', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(35, 'Bulgaria', 'BG', '359', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(36, 'Burkina Faso', 'BF', '226', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(37, 'Burundi', 'BI', '257', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(38, 'Cabo Verde', 'CV', '238', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(39, 'Cambodia', 'KH', '855', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(40, 'Cameroon', 'CM', '237', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(41, 'Canada', 'CA', '1', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(42, 'Cayman Islands (the)', 'KY', '1345', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(43, 'Central African Republic (the)', 'CF', '236', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(44, 'Chad', 'TD', '235', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(45, 'Chile', 'CL', '56', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(46, 'China', 'CN', '86', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(47, 'Christmas Island', 'CX', '61', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(48, 'Cocos (Keeling) Islands (the)', 'CC', '672', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(49, 'Colombia', 'CO', '57', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(50, 'Comoros (the)', 'KM', '269', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(51, 'Congo (the Democratic Republic of the)', 'CG', '242', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(52, 'Congo (the)', 'CG', '242', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(53, 'Cook Islands (the)', 'CK', '682', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(54, 'Costa Rica', 'CR', '506', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(55, 'Croatia', 'HR', '385', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(56, 'Cuba', 'CU', '53', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(57, 'Curaçao', 'CW', '599', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(58, 'Cyprus', 'CY', '357', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(59, 'Czechia', 'CZ', '420', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(60, 'Côte d\'Ivoire', 'CI', '225', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(61, 'Denmark', 'DK', '45', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(62, 'Djibouti', 'DJ', '253', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(63, 'Dominica', 'DM', '1767', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(64, 'Dominican Republic (the)', 'DO', '1809', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(65, 'Ecuador', 'EC', '593', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(66, 'Egypt', 'EG', '20', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(67, 'El Salvador', 'SV', '503', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(68, 'Equatorial Guinea', 'GQ', '240', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(69, 'Eritrea', 'ER', '291', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(70, 'Estonia', 'EE', '372', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(71, 'Eswatini', 'SWZ', '268', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(72, 'Ethiopia', 'ET', '251', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(73, 'Falkland Islands (the) [Malvinas]', 'FK', '500', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(74, 'Faroe Islands (the)', 'FO', '298', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(75, 'Fiji', 'FJ', '679', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(76, 'Finland', 'FI', '358', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(77, 'France', 'FR', '33', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(78, 'French Guiana', 'GF', '594', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(79, 'French Polynesia', 'PF', '689', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(80, 'French Southern Territories (the)', 'GF', '594', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(81, 'Gabon', 'GA', '241', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(82, 'Gambia (the)', 'GM', '220', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(83, 'Georgia', 'GE', '995', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(84, 'Germany', 'DE', '49', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(85, 'Ghana', 'GH', '233', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(86, 'Gibraltar', 'GI', '350', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(87, 'Greece', 'GR', '30', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(88, 'Greenland', 'GL', '299', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(89, 'Grenada', 'GD', '1473', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(90, 'Guadeloupe', 'GP', '590', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(91, 'Guam', 'GU', '1671', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(92, 'Guatemala', 'GT', '502', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(93, 'Guernsey', 'GG', '44', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(94, 'Guinea', 'GN', '224', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(95, 'Guinea-Bissau', 'GW', '245', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(96, 'Guyana', 'GY', '592', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(97, 'Haiti', 'HT', '509', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(98, 'Heard Island and McDonald Islands', 'HM', '0', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(99, 'Holy See (the)', 'VA', '39', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(100, 'Honduras', 'HN', '504', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(101, 'Hong Kong', 'HK', '852', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(102, 'Hungary', 'HU', '36', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(103, 'Iceland', 'IS', '354', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(104, 'India', 'IN', '91', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(105, 'Indonesia', 'ID', '62', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(106, 'Iran (Islamic Republic of)', 'IR', '98', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(107, 'Iraq', 'IQ', '964', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(108, 'Ireland', 'IE', '353', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(109, 'Isle of Man', 'IM', '44', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(110, 'Israel', 'IL', '972', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(111, 'Italy', 'IT', '39', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(112, 'Jamaica', 'JM', '1876', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(113, 'Japan', 'JP', '81', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(114, 'Jersey', 'JE', '44', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(115, 'Jordan', 'JO', '962', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(116, 'Kazakhstan', 'KZ', '7', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(117, 'Kenya', 'KE', '254', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(118, 'Kiribati', 'KI', '686', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(119, 'Korea (the Democratic People\'s Republic of)', 'KP', '850', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(120, 'Korea (the Republic of)', 'KP', '850', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(121, 'Kuwait', 'KW', '965', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(122, 'Kyrgyzstan', 'KG', '996', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(123, 'Lao People\'s Democratic Republic (the)', 'LA', '856', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(124, 'Latvia', 'LV', '371', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(125, 'Lebanon', 'LB', '961', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(126, 'Lesotho', 'LS', '266', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(127, 'Liberia', 'LR', '231', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(128, 'Libya', 'LY', '218', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(129, 'Liechtenstein', 'LI', '423', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(130, 'Lithuania', 'LT', '370', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(131, 'Luxembourg', 'LU', '352', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(132, 'Macao', 'MO', '853', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(133, 'Madagascar', 'MG', '261', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(134, 'Malawi', 'MW', '265', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(135, 'Malaysia', 'MY', '60', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(136, 'Maldives', 'MV', '960', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(137, 'Mali', 'ML', '223', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(138, 'Malta', 'MT', '356', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(139, 'Marshall Islands (the)', 'MH', '692', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(140, 'Martinique', 'MQ', '596', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(141, 'Mauritania', 'MR', '222', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(142, 'Mauritius', 'MU', '230', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(143, 'Mayotte', 'YT', '269', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(144, 'Mexico', 'MX', '52', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(145, 'Micronesia (Federated States of)', 'FM', '691', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(146, 'Moldova (the Republic of)', 'MD', '373', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(147, 'Monaco', 'MC', '377', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(148, 'Mongolia', 'MN', '976', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(149, 'Montenegro', 'ME', '382', '2022-04-14 15:05:50', '2022-04-14 15:05:50'),
(150, 'Montserrat', 'MS', '1664', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(151, 'Morocco', 'MA', '212', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(152, 'Mozambique', 'MZ', '258', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(153, 'Myanmar', 'MM', '95', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(154, 'Namibia', 'NA', '264', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(155, 'Nauru', 'NR', '674', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(156, 'Nepal', 'NP', '977', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(157, 'Netherlands (the)', 'NL', '31', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(158, 'New Caledonia', 'NC', '687', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(159, 'New Zealand', 'NZ', '64', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(160, 'Nicaragua', 'NI', '505', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(161, 'Niger (the)', 'NE', '227', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(162, 'Nigeria', 'NG', '234', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(163, 'Niue', 'NU', '683', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(164, 'Norfolk Island', 'NF', '672', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(165, 'Northern Mariana Islands (the)', 'MP', '1670', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(166, 'Norway', 'NO', '47', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(167, 'Oman', 'OM', '968', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(168, 'Pakistan', 'PK', '92', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(169, 'Palau', 'PW', '680', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(170, 'Palestine, State of', 'PH', '63', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(171, 'Panama', 'PA', '507', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(172, 'Papua New Guinea', 'PG', '675', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(173, 'Paraguay', 'PY', '595', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(174, 'Peru', 'PE', '51', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(175, 'Philippines (the)', 'PH', '63', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(176, 'Pitcairn', 'PN', '64', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(177, 'Poland', 'PL', '48', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(178, 'Portugal', 'PT', '351', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(179, 'Puerto Rico', 'PR', '1787', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(180, 'Qatar', 'QA', '974', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(181, 'Republic of North Macedonia', 'MK', '389', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(182, 'Romania', 'RO', '40', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(183, 'Russian Federation (the)', 'RU', '70', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(184, 'Rwanda', 'RW', '250', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(185, 'Réunion', 'RE', '262', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(186, 'Saint Barthélemy', 'BL', '590', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(187, 'Saint Helena, Ascension and Tristan da Cunha', 'SH', '290', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(188, 'Saint Kitts and Nevis', 'KN', '1869', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(189, 'Saint Lucia', 'LC', '1758', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(190, 'Saint Martin (French part)', 'MF', '590', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(191, 'Saint Pierre and Miquelon', 'PM', '508', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(192, 'Saint Vincent and the Grenadines', 'VC', '1784', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(193, 'Samoa', 'WS', '684', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(194, 'San Marino', 'SM', '378', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(195, 'Sao Tome and Principe', 'ST', '239', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(196, 'Saudi Arabia', 'SA', '966', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(197, 'Senegal', 'SN', '221', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(198, 'Serbia', 'RS', '381', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(199, 'Seychelles', 'SC', '248', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(200, 'Sierra Leone', 'SL', '232', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(201, 'Singapore', 'SG', '65', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(202, 'Sint Maarten (Dutch part)', 'SX', '1', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(203, 'Slovakia', 'SK', '421', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(204, 'Slovenia', 'SI', '386', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(205, 'Solomon Islands', 'SB', '677', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(206, 'Somalia', 'SO', '252', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(207, 'South Africa', 'ZA', '27', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(208, 'South Georgia and the South Sandwich Islands', 'GS', '500', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(209, 'South Sudan', 'SS', '211', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(210, 'Spain', 'ES', '34', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(211, 'Sri Lanka', 'LK', '94', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(212, 'Sudan (the)', 'SS', '211', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(213, 'Suriname', 'SR', '597', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(214, 'Svalbard and Jan Mayen', 'SJ', '47', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(215, 'Sweden', 'SE', '46', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(216, 'Switzerland', 'CH', '41', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(217, 'Syrian Arab Republic', 'SY', '963', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(218, 'Taiwan', 'TW', '886', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(219, 'Tajikistan', 'TJ', '992', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(220, 'Tanzania, United Republic of', 'TZ', '255', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(221, 'Thailand', 'TH', '66', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(222, 'Timor-Leste', 'TL', '670', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(223, 'Togo', 'TG', '228', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(224, 'Tokelau', 'TK', '690', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(225, 'Tonga', 'TO', '676', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(226, 'Trinidad and Tobago', 'TT', '1868', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(227, 'Tunisia', 'TN', '216', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(228, 'Turkey', 'TR', '90', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(229, 'Turkmenistan', 'TM', '7370', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(230, 'Turks and Caicos Islands (the)', 'TC', '1649', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(231, 'Tuvalu', 'TV', '688', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(232, 'Uganda', 'UG', '256', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(233, 'Ukraine', 'UA', '380', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(234, 'United Arab Emirates (the)', 'AE', '971', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(235, 'United Kingdom of Great Britain and Northern Ireland (the)', 'GB', '44', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(236, 'United States Minor Outlying Islands (the)', 'UM', '1', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(237, 'United States of America (the)', 'US', '1', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(238, 'Uruguay', 'UY', '598', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(239, 'Uzbekistan', 'UZ', '998', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(240, 'Vanuatu', 'VU', '678', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(241, 'Venezuela (Bolivarian Republic of)', 'VE', '58', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(242, 'Viet Nam', 'VN', '84', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(243, 'Virgin Islands (British)', 'VG', '1284', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(244, 'Virgin Islands (U.S.)', 'VI', '1340', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(245, 'Wallis and Futuna', 'WF', '681', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(246, 'Western Sahara', 'EH', '212', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(247, 'Yemen', 'YE', '967', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(248, 'Zambia', 'ZM', '260', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(249, 'Zimbabwe', 'ZW', '263', '2022-04-14 15:05:51', '2022-04-14 15:05:51'),
(250, 'Åland Islands', 'AX', '358', '2022-04-14 15:05:51', '2022-04-14 15:05:51');

-- --------------------------------------------------------

--
-- Table structure for table `country_taxes`
--

DROP TABLE IF EXISTS `country_taxes`;
CREATE TABLE IF NOT EXISTS `country_taxes` (
  `tax_id` bigint UNSIGNED NOT NULL,
  `country_id` bigint UNSIGNED NOT NULL,
  KEY `country_taxes_tax_id_foreign` (`tax_id`),
  KEY `country_taxes_country_id_foreign` (`country_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `creator_offers`
--

DROP TABLE IF EXISTS `creator_offers`;
CREATE TABLE IF NOT EXISTS `creator_offers` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `old_profile_access_price` double DEFAULT '5',
  `old_profile_access_price_3_months` double(8,2) DEFAULT '5.00',
  `old_profile_access_price_6_months` double DEFAULT '5',
  `old_profile_access_price_12_months` double DEFAULT '5',
  `expires_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `creator_offers_user_id_foreign` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `data_rows`
--

DROP TABLE IF EXISTS `data_rows`;
CREATE TABLE IF NOT EXISTS `data_rows` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `data_type_id` int UNSIGNED NOT NULL,
  `field` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `required` tinyint(1) NOT NULL DEFAULT '0',
  `browse` tinyint(1) NOT NULL DEFAULT '1',
  `read` tinyint(1) NOT NULL DEFAULT '1',
  `edit` tinyint(1) NOT NULL DEFAULT '1',
  `add` tinyint(1) NOT NULL DEFAULT '1',
  `delete` tinyint(1) NOT NULL DEFAULT '1',
  `details` text COLLATE utf8mb4_unicode_ci,
  `order` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `data_rows_data_type_id_foreign` (`data_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=387 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `data_rows`
--

INSERT INTO `data_rows` (`id`, `data_type_id`, `field`, `type`, `display_name`, `required`, `browse`, `read`, `edit`, `add`, `delete`, `details`, `order`) VALUES
(1, 1, 'id', 'number', 'ID', 1, 1, 1, 0, 0, 0, '{}', 1),
(2, 1, 'name', 'text', 'Name', 1, 1, 1, 1, 1, 1, '{}', 3),
(3, 1, 'email', 'text', 'Email', 1, 1, 1, 1, 1, 1, '{}', 4),
(4, 1, 'password', 'password', 'Password', 1, 0, 0, 1, 1, 0, '{}', 5),
(5, 1, 'remember_token', 'text', 'Remember Token', 0, 0, 0, 0, 0, 0, '{}', 8),
(6, 1, 'created_at', 'timestamp', 'Created At', 0, 0, 1, 0, 0, 0, '{}', 38),
(7, 1, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 34),
(8, 1, 'avatar', 'image', 'Avatar', 0, 1, 1, 1, 0, 1, '{}', 2),
(9, 1, 'user_belongsto_role_relationship', 'relationship', 'Role', 0, 0, 1, 1, 1, 0, '{\"model\":\"TCG\\\\Voyager\\\\Models\\\\Role\",\"table\":\"roles\",\"type\":\"belongsTo\",\"column\":\"role_id\",\"key\":\"id\",\"label\":\"display_name\",\"pivot_table\":\"roles\",\"pivot\":\"0\",\"taggable\":\"0\"}', 17),
(10, 1, 'user_belongstomany_role_relationship', 'relationship', 'Roles', 0, 0, 0, 0, 0, 0, '{\"model\":\"TCG\\\\Voyager\\\\Models\\\\Role\",\"table\":\"roles\",\"type\":\"belongsToMany\",\"column\":\"id\",\"key\":\"id\",\"label\":\"display_name\",\"pivot_table\":\"user_roles\",\"pivot\":\"1\",\"taggable\":\"0\"}', 18),
(11, 1, 'settings', 'hidden', 'Settings', 0, 0, 0, 0, 0, 0, '{}', 19),
(12, 2, 'id', 'number', 'ID', 1, 0, 0, 0, 0, 0, NULL, 1),
(13, 2, 'name', 'text', 'Name', 1, 1, 1, 1, 1, 1, NULL, 2),
(14, 2, 'created_at', 'timestamp', 'Created At', 0, 0, 0, 0, 0, 0, NULL, 3),
(15, 2, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, NULL, 4),
(16, 3, 'id', 'number', 'ID', 1, 0, 0, 0, 0, 0, '{}', 1),
(17, 3, 'name', 'text', 'Name', 1, 1, 1, 1, 1, 1, '{}', 2),
(18, 3, 'created_at', 'timestamp', 'Created At', 0, 0, 0, 0, 0, 0, '{}', 3),
(19, 3, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 4),
(20, 3, 'display_name', 'text', 'Display Name', 1, 1, 1, 1, 1, 1, '{}', 5),
(21, 1, 'role_id', 'text', 'Role', 0, 0, 1, 1, 1, 1, '{}', 6),
(22, 4, 'id', 'text', 'Id', 1, 0, 0, 1, 1, 1, '{\"description\":\"Unique Wallet Identifier. If adding a new entry from admin panel, entry a random, unique string.\"}', 1),
(23, 4, 'user_id', 'text', 'User Id', 0, 1, 1, 1, 1, 1, '{}', 3),
(24, 4, 'total', 'text', 'Total', 0, 1, 1, 1, 1, 1, '{}', 5),
(27, 4, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 6),
(28, 4, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 7),
(29, 6, 'id', 'text', 'UUID', 1, 0, 0, 0, 1, 0, '{}', 1),
(30, 6, 'filename', 'text', 'Filename', 1, 1, 1, 1, 1, 1, '{}', 9),
(31, 6, 'driver', 'select_dropdown', 'Driver', 1, 1, 1, 1, 1, 1, '{\"default\":\"0\",\"options\":{\"0\":\"Local\",\"1\":\"S3\",\"2\":\"Wasabi\",\"3\":\"DigitalOcean\",\"4\":\"Minio\",\"5\":\"Pushr\"}}', 7),
(32, 6, 'type', 'text', 'Type', 1, 1, 1, 1, 1, 1, '{}', 8),
(33, 6, 'user_id', 'text', 'User Id', 0, 1, 1, 1, 1, 1, '{}', 3),
(34, 6, 'post_id', 'text', 'Post Id', 0, 1, 1, 1, 1, 1, '{}', 4),
(35, 6, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 11),
(36, 6, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 13),
(37, 9, 'id', 'text', 'UUID', 1, 0, 1, 1, 1, 1, '{\"description\":\"Unique Wallet Identifier. If adding a new entry from admin panel, entry a random, unique string.\"}', 1),
(38, 9, 'from_user_id', 'text', 'From User Id', 0, 1, 1, 1, 1, 1, '{}', 3),
(39, 9, 'to_user_id', 'text', 'To User Id', 0, 1, 1, 1, 1, 1, '{}', 5),
(40, 9, 'type', 'select_dropdown', 'Type', 1, 1, 1, 1, 1, 1, '{\"default\":\"tip\",\"options\":{\"tip\":\"Tip\",\"reaction\":\"Reaction\",\"new-comment\":\"Comment\",\"new-subscription\":\"Subscription\",\"withdrawal-action\":\"Withdrawal\",\"new-message\":\"Message\"}}', 11),
(41, 9, 'post_id', 'text', 'Post Id', 0, 0, 1, 1, 1, 1, '{}', 6),
(42, 9, 'post_comment_id', 'text', 'Post Comment Id', 0, 0, 1, 1, 1, 1, '{}', 7),
(43, 9, 'subscription_id', 'text', 'Subscription Id', 0, 0, 1, 1, 1, 1, '{}', 8),
(44, 9, 'transaction_id', 'text', 'Transaction Id', 0, 0, 1, 1, 1, 1, '{}', 9),
(45, 9, 'reaction_id', 'text', 'Reaction Id', 0, 0, 1, 1, 1, 1, '{}', 10),
(47, 9, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 16),
(48, 9, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 17),
(49, 10, 'id', 'text', 'Id', 1, 0, 0, 0, 0, 0, '{}', 1),
(50, 10, 'user_id', 'text', 'User Id', 1, 1, 1, 1, 1, 1, '{}', 3),
(51, 10, 'post_id', 'text', 'Post Id', 1, 1, 1, 1, 1, 1, '{}', 4),
(52, 10, 'message', 'text', 'Message', 1, 1, 1, 1, 1, 1, '{}', 5),
(53, 10, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 6),
(54, 10, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 7),
(55, 11, 'id', 'text', 'Id', 1, 1, 1, 0, 0, 0, '{}', 1),
(56, 11, 'user_id', 'text', 'User Id', 1, 1, 1, 1, 1, 1, '{}', 3),
(57, 11, 'text', 'text', 'Text', 0, 1, 1, 1, 1, 1, '{}', 5),
(58, 11, 'status', 'select_dropdown', 'Status', 1, 1, 1, 1, 1, 1, '{\"default\":\"requested\",\"options\":{\"0\":\"Pending\",\"1\":\"Approved\",\"2\":\"Disapproved\"}}', 6),
(59, 11, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 11),
(60, 11, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 10),
(61, 12, 'id', 'text', 'Id', 1, 0, 0, 0, 0, 0, '{}', 1),
(62, 12, 'user_id', 'text', 'User Id', 0, 1, 1, 1, 1, 1, '{}', 3),
(63, 12, 'post_id', 'text', 'Post Id', 0, 1, 1, 1, 1, 1, '{}', 4),
(64, 12, 'post_comment_id', 'text', 'Post Comment Id', 0, 1, 1, 1, 1, 1, '{}', 5),
(65, 12, 'reaction_type', 'select_dropdown', 'Reaction Type', 0, 1, 1, 1, 1, 1, '{\"default\":\"like\",\"options\":{\"like\":\"Like\"}}', 6),
(66, 12, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 7),
(67, 12, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 8),
(68, 13, 'id', 'text', 'Id', 1, 0, 0, 0, 0, 0, '{}', 1),
(69, 13, 'sender_user_id', 'text', 'SubscriberID', 1, 1, 1, 1, 1, 1, '{}', 3),
(70, 13, 'recipient_user_id', 'text', 'CreatorID', 1, 1, 1, 1, 1, 1, '{}', 5),
(71, 13, 'paypal_agreement_id', 'text', 'Paypal ID', 0, 1, 1, 1, 1, 1, '{}', 10),
(72, 13, 'stripe_subscription_id', 'text', 'Stripe ID', 0, 1, 1, 1, 1, 1, '{}', 13),
(73, 13, 'paypal_plan_id', 'text', 'Paypal Plan ID', 0, 0, 1, 1, 1, 1, '{}', 11),
(74, 13, 'type', 'select_dropdown', 'Type', 1, 1, 1, 1, 1, 1, '{\"default\":\"one-month-subscription\",\"options\":{\"one-month-subscription\":\"One month sub\",\"three-months-subscription\":\"Three months sub\",\"six-months-subscription\":\"Six months sub\",\"yearly-subscription\":\"Yearly sub\"}}', 7),
(75, 13, 'status', 'select_dropdown', 'Status', 1, 1, 1, 1, 1, 1, '{\"default\":\"pending\",\"options\":{\"pending\":\"Pending\",\"completed\":\"Completed\",\"suspended\":\"Suspended\",\"update-needed\":\"Update needed\",\"canceled\":\"Canceled\",\"expired\":\"Expired\"}}', 6),
(76, 13, 'expires_at', 'timestamp', 'Expires At', 0, 1, 1, 1, 1, 1, '{}', 14),
(77, 13, 'canceled_at', 'timestamp', 'Canceled At', 0, 0, 1, 1, 1, 1, '{}', 15),
(78, 13, 'amount', 'text', 'Amount', 0, 1, 1, 1, 1, 1, '{}', 9),
(79, 13, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 16),
(80, 13, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 17),
(81, 14, 'id', 'text', 'Id', 1, 1, 0, 0, 0, 0, '{}', 1),
(82, 14, 'sender_user_id', 'text', 'SenderID', 1, 1, 1, 1, 1, 1, '{}', 3),
(83, 14, 'recipient_user_id', 'text', 'RecipientID', 0, 1, 1, 1, 1, 1, '{}', 5),
(84, 14, 'subscription_id', 'text', 'SubscriptionID', 0, 1, 1, 1, 1, 1, '{}', 10),
(85, 14, 'post_id', 'text', 'PostID', 0, 1, 1, 1, 1, 1, '{}', 11),
(86, 14, 'stripe_transaction_id', 'text', 'StripeTransactionID', 0, 0, 1, 1, 1, 1, '{}', 12),
(87, 14, 'stripe_session_id', 'text', 'StripeSessionID', 0, 0, 1, 1, 1, 1, '{}', 15),
(88, 14, 'paypal_transaction_id', 'text', 'PaypalTransactionID', 0, 0, 1, 1, 1, 1, '{}', 16),
(89, 14, 'paypal_transaction_token', 'text', 'PaypalTransactionToken', 0, 0, 1, 1, 1, 1, '{}', 18),
(90, 14, 'status', 'select_dropdown', 'Status', 1, 1, 1, 1, 1, 1, '{\"default\":\"pending\",\"options\":{\"pending\":\"Pending\",\"canceled\":\"Canceled\",\"approved\":\"Approved\",\"declined\":\"Declined\",\"refunded\":\"Refunded\",\"initiated\":\"Initiated\",\"partially-paid\":\"Partially paid\"}}', 6),
(91, 14, 'type', 'select_dropdown', 'Type', 1, 1, 1, 1, 1, 1, '{\"default\":\"tip\",\"options\":{\"tip\":\"Post Tip\",\"chat-tip\":\"Chat tip\",\"post-unlock\":\"Post unlock\",\"message-unlock\":\"Message unlock\",\"deposit\":\"Deposit\",\"withdrawal\":\"Withdrawal\",\"one-month-subscription\":\"One month sub\",\"three-months-subscription\":\"Three months sub\",\"six-months-subscription\":\"Six months sub\",\"yearly-subscription\":\"Yearly sub\",\"subscription-renewal\":\"Subscription renewal\",\"stream-access\":\"Stream unlock\"}}', 7),
(92, 14, 'payment_provider', 'select_dropdown', 'Payment Provider', 1, 1, 1, 1, 1, 1, '{\"default\":\"credit\",\"options\":{\"stripe\":\"Stripe\",\"paypal\":\"Paypal\",\"ccbill\":\"CCBill\",\"coinbase\":\"Coinbase\",\"nowpayments\":\"Nowpayments\",\"paystack\":\"Paystack\",\"oxxo\":\"Oxxo\",\"credit\":\"Credit\"}}', 8),
(93, 14, 'currency', 'text', 'Currency', 1, 0, 1, 1, 1, 1, '{}', 21),
(94, 14, 'paypal_payer_id', 'text', 'PaypalPayerId', 0, 0, 1, 1, 1, 1, '{}', 19),
(95, 14, 'amount', 'text', 'Amount', 1, 1, 1, 1, 1, 1, '{}', 9),
(96, 14, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 28),
(97, 14, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 30),
(98, 15, 'id', 'text', 'Id', 1, 0, 0, 0, 0, 0, '{}', 1),
(99, 15, 'user_id', 'text', 'User Id', 1, 1, 1, 1, 1, 1, '{}', 3),
(100, 15, 'post_id', 'text', 'Post Id', 1, 1, 1, 1, 1, 1, '{}', 4),
(101, 15, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 5),
(102, 15, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 6),
(103, 16, 'id', 'text', 'Id', 1, 1, 0, 0, 0, 0, '{}', 1),
(104, 16, 'name', 'text', 'Name', 1, 1, 1, 1, 1, 1, '{}', 4),
(105, 16, 'user_id', 'text', 'User Id', 1, 1, 1, 1, 1, 1, '{}', 3),
(106, 16, 'type', 'select_dropdown', 'Type', 1, 1, 1, 1, 1, 1, '{\"default\":\"followers\",\"options\":{\"followers\":\"Followers\",\"blocked\":\"Blocked\",\"custom\":\"Custom\"}}', 5),
(107, 16, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 6),
(108, 16, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 7),
(109, 17, 'id', 'text', 'Id', 1, 0, 0, 0, 0, 0, '{}', 1),
(110, 17, 'list_id', 'text', 'List Id', 1, 1, 1, 1, 1, 1, '{}', 2),
(111, 17, 'user_id', 'text', 'User Id', 1, 1, 1, 1, 1, 1, '{}', 5),
(112, 17, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 6),
(113, 17, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 7),
(114, 18, 'id', 'text', 'Id', 1, 0, 0, 0, 0, 0, '{}', 1),
(115, 18, 'sender_id', 'text', 'Sender Id', 1, 1, 1, 1, 1, 1, '{}', 3),
(116, 18, 'receiver_id', 'text', 'Receiver Id', 1, 1, 1, 1, 1, 1, '{}', 5),
(117, 18, 'replyTo', 'text', 'ReplyTo', 1, 0, 1, 1, 1, 1, '{}', 6),
(118, 18, 'message', 'text', 'Message', 0, 1, 1, 1, 1, 1, '{}', 8),
(119, 18, 'isSeen', 'checkbox', 'IsSeen', 1, 1, 1, 1, 1, 1, '{\"on\":\"True\",\"off\":\"False\",\"checked\":\"true\"}', 9),
(120, 18, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 10),
(121, 18, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 11),
(122, 19, 'id', 'text', 'Id', 1, 0, 0, 0, 0, 0, '{}', 1),
(123, 19, 'user_id', 'text', 'User Id', 1, 1, 1, 1, 1, 1, '{}', 3),
(124, 19, 'amount', 'text', 'Amount', 1, 1, 1, 1, 1, 1, '{}', 4),
(125, 19, 'status', 'select_dropdown', 'Status', 1, 1, 1, 1, 1, 1, '{\"default\":\"requested\",\"options\":{\"requested\":\"Requested\",\"rejected\":\"Rejected\",\"approved\":\"Approved\"}}', 6),
(126, 19, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 12),
(127, 19, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 9),
(128, 20, 'id', 'text', 'Id', 1, 0, 0, 0, 0, 0, '{}', 1),
(129, 20, 'name', 'text', 'Name', 1, 1, 1, 1, 1, 1, '{}', 2),
(130, 20, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 3),
(131, 20, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 4),
(132, 21, 'id', 'text', 'Id', 1, 0, 0, 0, 0, 0, '{}', 1),
(133, 21, 'name', 'text', 'Name', 1, 1, 1, 1, 1, 1, '{}', 2),
(134, 21, 'percentage', 'text', 'Value', 1, 1, 1, 1, 1, 1, '{\"description\":\"If tax type is \'Fixed\' this value represents a fixed amount, otherwise it is a percentage from the payment amount\"}', 3),
(135, 21, 'type', 'radio_btn', 'Type', 1, 1, 1, 1, 1, 1, '{\"default\":\"inclusive\",\"options\":{\"inclusive\":\"Inclusive\",\"exclusive\":\"Exclusive\",\"fixed\":\"Fixed\"}}', 4),
(136, 21, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 0, 0, 1, '{}', 5),
(137, 21, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 6),
(138, 21, 'tax_belongstomany_country_relationship', 'relationship', 'Countries', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\Model\\\\Country\",\"table\":\"countries\",\"type\":\"belongsToMany\",\"column\":\"id\",\"key\":\"id\",\"label\":\"name\",\"pivot_table\":\"country_taxes\",\"pivot\":\"1\",\"taggable\":\"0\"}', 7),
(142, 14, 'taxes', 'text', 'Taxes', 0, 0, 0, 0, 0, 0, '{}', 24),
(143, 1, 'username', 'text', 'Username', 1, 1, 1, 1, 1, 1, '{}', 10),
(145, 1, 'bio', 'text', 'Bio', 0, 0, 1, 1, 0, 1, '{}', 11),
(146, 1, 'location', 'text', 'Location', 0, 0, 1, 1, 0, 1, '{}', 12),
(147, 1, 'website', 'text', 'Website', 0, 0, 1, 1, 0, 1, '{}', 13),
(148, 1, 'cover', 'image', 'Cover', 0, 0, 1, 1, 0, 1, '{}', 7),
(149, 1, 'email_verified_at', 'timestamp', 'Email verified', 0, 1, 1, 1, 1, 1, '{}', 35),
(150, 1, 'public_profile', 'checkbox', 'Public Profile', 1, 0, 1, 1, 1, 1, '{\"on\":\"On\",\"off\":\"Off\",\"checked\":\"true\"}', 20),
(151, 1, 'profile_access_price', 'text', 'Profile Price', 1, 1, 1, 1, 0, 1, '{}', 23),
(152, 1, 'billing_address', 'text', 'Billing Address', 0, 0, 1, 1, 0, 1, '{}', 27),
(153, 1, 'first_name', 'text', 'First Name', 0, 0, 1, 1, 0, 1, '{}', 28),
(154, 1, 'last_name', 'text', 'Last Name', 0, 0, 1, 1, 0, 1, '{}', 29),
(155, 1, 'city', 'text', 'City', 0, 0, 1, 1, 0, 1, '{}', 30),
(156, 1, 'country', 'text', 'Country', 0, 0, 1, 1, 0, 1, '{}', 31),
(157, 1, 'state', 'text', 'State', 0, 0, 1, 1, 0, 1, '{}', 32),
(158, 1, 'postcode', 'text', 'Postcode', 0, 0, 1, 1, 0, 1, '{}', 33),
(159, 27, 'id', 'text', 'Id', 1, 0, 1, 0, 0, 1, '{}', 1),
(160, 27, 'slug', 'text', 'Slug', 1, 1, 1, 1, 1, 1, '{}', 4),
(161, 27, 'title', 'text', 'Title', 1, 1, 1, 1, 1, 1, '{}', 2),
(162, 27, 'content', 'rich_text_box', 'Content', 1, 0, 1, 1, 1, 1, '{\"tinymceOptions\":{\"toolbar\":\"undo redo | formatselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | fontsizeselect\",\"plugins\":\"lists link image\",\"image_title\":true,\"automatic_uploads\":false,\"file_picker_types\":\"image\",\"image_advtab\":true,\"file_picker_callback\":\"function(callback, value, meta) { if (meta.filetype === \'image\') { var input = document.createElement(\'input\'); input.setAttribute(\'type\', \'text\'); input.setAttribute(\'placeholder\', \'Enter image URL\'); input.oninput = function() { callback(input.value, {alt: \'\'}); }; document.body.appendChild(input); input.focus(); input.onblur = function() { document.body.removeChild(input); }; } }\",\"fontsize_formats\":\"8pt 10pt 12pt 14pt 18pt 24pt 36pt\",\"style_formats\":[{\"title\":\"Headers\",\"items\":[{\"title\":\"Header 1\",\"block\":\"h1\"},{\"title\":\"Header 2\",\"block\":\"h2\"},{\"title\":\"Header 3\",\"block\":\"h3\"},{\"title\":\"Header 4\",\"block\":\"h4\"},{\"title\":\"Header 5\",\"block\":\"h5\"},{\"title\":\"Header 6\",\"block\":\"h6\"}]},{\"title\":\"Inline\",\"items\":[{\"title\":\"Bold\",\"icon\":\"bold\",\"format\":\"bold\"},{\"title\":\"Italic\",\"icon\":\"italic\",\"format\":\"italic\"},{\"title\":\"Underline\",\"icon\":\"underline\",\"format\":\"underline\"},{\"title\":\"Strikethrough\",\"icon\":\"strikethrough\",\"format\":\"strikethrough\"},{\"title\":\"Superscript\",\"icon\":\"superscript\",\"format\":\"superscript\"},{\"title\":\"Subscript\",\"icon\":\"subscript\",\"format\":\"subscript\"}]}],\"content_style\":\"body { font-family:Helvetica,Arial,sans-serif; font-size:14px }\"}}', 5),
(163, 27, 'created_at', 'timestamp', 'Created At', 0, 0, 1, 0, 0, 1, '{}', 10),
(164, 27, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 11),
(165, 14, 'invoice_id', 'text', 'InvoiceID', 0, 1, 1, 1, 1, 1, '{}', 13),
(166, 28, 'id', 'text', 'Id', 1, 0, 0, 0, 0, 0, '{}', 1),
(167, 28, 'user_id', 'text', 'User Id', 1, 1, 1, 1, 1, 1, '{}', 3),
(168, 28, 'files', 'text', 'Files', 0, 0, 0, 1, 0, 0, '{}', 5),
(169, 28, 'rejectionReason', 'text', 'Rejection Reason', 0, 1, 1, 1, 1, 1, '{}', 7),
(170, 28, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 8),
(171, 28, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 9),
(172, 19, 'message', 'text', 'Message', 0, 1, 1, 1, 1, 1, '{}', 8),
(173, 28, 'status', 'select_dropdown', 'Status', 1, 1, 1, 1, 1, 1, '{\"default\":\"pending\",\"options\":{\"pending\":\"Pending\",\"rejected\":\"Rejected\",\"verified\":\"Verified\"}}', 6),
(179, 9, 'withdrawal_id', 'text', 'Withdrawal Id', 0, 0, 1, 1, 1, 1, '{}', 13),
(180, 9, 'user_message_id', 'text', 'User Message Id', 0, 0, 1, 1, 1, 1, '{}', 15),
(186, 17, 'user_list_member_hasone_user_list_relationship', 'relationship', 'List name', 0, 1, 1, 0, 0, 1, '{\"model\":\"App\\\\Model\\\\UserList\",\"table\":\"user_lists\",\"type\":\"hasOne\",\"column\":\"id\",\"key\":\"list_id\",\"label\":\"name\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 3),
(189, 6, 'message_id', 'text', 'Message Id', 0, 1, 1, 1, 1, 1, '{}', 6),
(192, 1, 'birthdate', 'date', 'Birthdate', 0, 0, 1, 1, 1, 1, '{}', 36),
(193, 1, 'identity_verified_at', 'timestamp', 'ID verifed', 0, 1, 1, 1, 1, 1, '{}', 37),
(194, 29, 'id', 'text', 'Id', 1, 0, 0, 0, 0, 0, '{}', 1),
(195, 29, 'from_user_id', 'text', 'Reporter ID', 1, 1, 1, 1, 1, 1, '{\"validation\":{\"rule\":[\"required\"]}}', 3),
(196, 29, 'user_id', 'text', 'Reported ID', 1, 1, 1, 1, 1, 1, '{\"validation\":{\"rule\":[\"required\"]}}', 5),
(197, 29, 'post_id', 'text', 'PostID', 0, 1, 1, 1, 1, 1, '{}', 6),
(198, 29, 'details', 'text', 'Details', 0, 1, 1, 1, 1, 1, '{}', 9),
(199, 29, 'type', 'select_dropdown', 'Type', 1, 1, 1, 1, 1, 1, '{\"default\":\"I don\'t like this post\",\"options\":{\"I don\'t like this post\":\"I don\'t like this post\",\"Content is offensive or violates Terms of Service.\":\"Content is offensive or violates Terms of Service.\",\"Content contains stolen material (DMCA)\":\"Content contains stolen material (DMCA)\",\"Content is spam\":\"Content is spam\",\"Report abuse\":\"Report abuse\"}}', 10),
(200, 29, 'status', 'select_dropdown', 'Status', 1, 1, 1, 1, 1, 1, '{\"default\":\"received\",\"options\":{\"received\":\"Received\",\"seen\":\"Seen\",\"solved\":\"Solved\"}}', 11),
(201, 29, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 12),
(202, 29, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 13),
(205, 30, 'id', 'text', 'Id', 1, 0, 0, 0, 0, 0, '{}', 1),
(206, 30, 'email', 'text', 'Email', 1, 1, 1, 1, 1, 1, '{}', 2),
(207, 30, 'subject', 'text', 'Subject', 1, 1, 1, 1, 1, 1, '{}', 3),
(208, 30, 'message', 'text', 'Message', 1, 1, 1, 1, 1, 1, '{}', 4),
(209, 30, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 5),
(210, 30, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 6),
(223, 32, 'id', 'text', 'Id', 1, 0, 0, 0, 0, 0, '{}', 1),
(224, 32, 'user_id', 'text', 'User Id', 1, 1, 1, 1, 1, 1, '{}', 2),
(225, 32, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 0, 0, 1, '{}', 4),
(226, 32, 'updated_at', 'timestamp', 'Updated At', 0, 0, 1, 0, 0, 0, '{}', 5),
(227, 32, 'featured_user_hasone_user_relationship', 'relationship', 'Username', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 3),
(228, 33, 'id', 'text', 'Id', 1, 0, 0, 0, 0, 0, '{}', 1),
(229, 33, 'user_id', 'text', 'User Id', 1, 1, 1, 1, 1, 1, '{}', 3),
(230, 33, 'transaction_id', 'text', 'Transaction Id', 1, 1, 1, 1, 1, 1, '{}', 4),
(231, 33, 'status', 'select_dropdown', 'Status', 1, 1, 1, 1, 1, 1, '{\"default\":\"pending\",\"options\":{\"pending\":\"Pending\",\"rejected\":\"Rejected\",\"approved\":\"Approved\"}}', 5),
(232, 33, 'type', 'select_dropdown', 'Type', 0, 1, 1, 1, 1, 1, '{\"default\":\"deposit\",\"options\":{\"deposit\":\"Deposit\"}}', 6),
(233, 33, 'reason', 'text', 'Reason', 0, 1, 1, 1, 1, 1, '{}', 7),
(234, 33, 'message', 'text', 'Message', 0, 1, 1, 1, 1, 1, '{}', 8),
(235, 33, 'amount', 'text', 'Amount', 0, 1, 1, 1, 1, 1, '{}', 9),
(236, 33, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 10),
(237, 33, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 11),
(238, 33, 'payment_request_hasmany_attachment_relationship', 'relationship', 'Files', 0, 0, 1, 1, 0, 0, '{\"model\":\"App\\\\Model\\\\Attachment\",\"table\":\"attachments\",\"type\":\"hasMany\",\"column\":\"payment_request_id\",\"key\":\"id\",\"label\":\"filename\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 12),
(239, 11, 'price', 'text', 'Price', 1, 1, 1, 1, 1, 1, '{}', 4),
(240, 19, 'payment_method', 'text', 'Payment Method', 0, 1, 1, 1, 1, 1, '{}', 10),
(241, 19, 'payment_identifier', 'text', 'Payment Identifier', 0, 1, 1, 1, 1, 1, '{}', 11),
(242, 34, 'id', 'text', 'Id', 1, 0, 0, 0, 0, 0, '{}', 1),
(243, 34, 'invoice_id', 'text', 'Invoice Id', 1, 1, 1, 1, 1, 1, '{}', 2),
(244, 34, 'data', 'text', 'Data', 1, 0, 0, 0, 0, 0, '{}', 4),
(245, 34, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 5),
(246, 34, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 6),
(247, 13, 'ccbill_subscription_id', 'text', 'Ccbill Id', 0, 1, 1, 1, 1, 1, '{}', 12),
(248, 13, 'provider', 'select_dropdown', 'Provider', 1, 0, 1, 1, 1, 1, '{\"default\":\"credit\",\"options\":{\"stripe\":\"Stripe\",\"paypal\":\"Paypal\",\"ccbill\":\"CCBill\",\"credit\":\"Credit\"}}', 8),
(249, 1, 'gender_id', 'text', 'Gender Id', 0, 0, 0, 0, 0, 0, '{}', 15),
(250, 1, 'gender_pronoun', 'text', 'Gender Pronoun', 0, 0, 1, 1, 0, 1, '{}', 16),
(251, 1, 'paid_profile', 'checkbox', 'Paid Profile', 1, 1, 1, 1, 1, 1, '{\"on\":\"On\",\"off\":\"Off\",\"checked\":\"true\"}', 22),
(252, 1, 'profile_access_price_6_months', 'text', 'Profile for Price 6 Months', 0, 0, 1, 1, 0, 1, '{}', 25),
(253, 1, 'profile_access_price_3_months', 'text', 'Profile for Price 3 Months', 0, 0, 1, 1, 0, 1, '{}', 24),
(254, 1, 'profile_access_price_12_months', 'text', 'Profile for Price 12 Months', 0, 0, 1, 1, 0, 1, '{}', 26),
(255, 1, 'auth_provider', 'text', 'Auth Provider', 0, 0, 1, 0, 0, 1, '{}', 39),
(256, 1, 'auth_provider_id', 'text', 'Auth Provider Id', 0, 0, 1, 0, 0, 1, '{}', 40),
(257, 1, 'enable_2fa', 'checkbox', 'Enable 2fa', 0, 0, 1, 1, 0, 1, '{\"on\":\"On\",\"off\":\"Off\",\"checked\":\"false\"}', 41),
(258, 1, 'enable_geoblocking', 'checkbox', 'Enable Geoblocking', 0, 0, 1, 1, 0, 1, '{\"on\":\"On\",\"off\":\"Off\",\"checked\":\"false\"}', 42),
(259, 1, 'open_profile', 'checkbox', 'Open Profile', 0, 1, 1, 1, 1, 1, '{\"on\":\"On\",\"off\":\"Off\",\"checked\":\"false\"}', 21),
(263, 27, 'page_order', 'text', 'Order', 1, 1, 1, 1, 1, 1, '{}', 6),
(264, 27, 'shown_in_footer', 'checkbox', 'Shown in Footer', 0, 1, 1, 1, 1, 1, '{\"on\":\"On\",\"off\":\"Off\",\"checked\":\"true\"}', 7),
(265, 19, 'fee', 'text', 'Fee', 0, 1, 1, 1, 1, 1, '{}', 5),
(266, 19, 'processed', 'checkbox', 'Processed', 1, 1, 1, 1, 1, 1, '{\"on\":\"True\",\"off\":\"False\",\"checked\":\"false\"}', 7),
(267, 14, 'stream_id', 'text', 'StreamID', 0, 1, 1, 1, 1, 1, '{}', 14),
(268, 14, 'user_message_id', 'text', 'MessageID', 0, 1, 1, 1, 1, 1, '{}', 17),
(269, 14, 'coinbase_charge_id', 'text', 'Coinbase Charge Id', 0, 0, 1, 1, 1, 1, '{}', 20),
(270, 14, 'coinbase_transaction_token', 'text', 'Coinbase Transaction Token', 0, 0, 1, 1, 1, 1, '{}', 22),
(271, 14, 'nowpayments_payment_id', 'text', 'Nowpayments Payment Id', 0, 0, 1, 1, 1, 1, '{}', 23),
(272, 14, 'nowpayments_order_id', 'text', 'Nowpayments Order Id', 0, 0, 1, 1, 1, 1, '{}', 27),
(273, 14, 'ccbill_payment_token', 'text', 'Ccbill Payment Token', 0, 0, 1, 1, 1, 1, '{}', 29),
(274, 14, 'ccbill_transaction_id', 'text', 'Ccbill Transaction Id', 0, 0, 1, 1, 1, 1, '{}', 31),
(275, 14, 'ccbill_subscription_id', 'text', 'Ccbill Subscription Id', 0, 0, 1, 1, 1, 1, '{}', 32),
(276, 14, 'paystack_payment_token', 'text', 'Paystack Payment Token', 0, 0, 1, 1, 1, 1, '{}', 33),
(278, 1, 'referral_code', 'text', 'Referral Code', 0, 0, 1, 1, 0, 1, '{}', 9),
(298, 37, 'id', 'text', 'Id', 1, 0, 0, 0, 0, 0, '{}', 1),
(299, 37, 'user_id', 'text', 'User Id', 1, 1, 1, 1, 1, 1, '{}', 3),
(300, 37, 'stream_id', 'text', 'Stream Id', 1, 1, 1, 1, 1, 1, '{}', 4),
(301, 37, 'message', 'text', 'Message', 1, 1, 1, 1, 1, 1, '{}', 5),
(302, 37, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 6),
(303, 37, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 7),
(304, 38, 'id', 'text', 'Id', 1, 1, 0, 0, 0, 0, '{}', 1),
(305, 38, 'user_id', 'text', 'User Id', 1, 1, 1, 1, 1, 1, '{}', 3),
(306, 38, 'status', 'select_dropdown', 'Status', 1, 1, 1, 1, 1, 1, '{\"default\":\"requested\",\"options\":{\"in-progress\":\"In progress\",\"ended\":\"Ended\",\"deleted\":\"Deleted\"}}', 4),
(307, 38, 'name', 'text', 'Name', 0, 1, 1, 1, 1, 1, '{}', 5),
(308, 38, 'slug', 'text', 'Slug', 0, 0, 1, 1, 1, 1, '{}', 6),
(309, 38, 'poster', 'text', 'Poster', 0, 0, 1, 1, 1, 1, '{}', 11),
(310, 38, 'price', 'text', 'Price', 1, 1, 1, 1, 1, 1, '{}', 7),
(311, 38, 'requires_subscription', 'checkbox', 'Requires Subscription', 0, 1, 1, 1, 1, 1, '{\"on\":\"True\",\"off\":\"False\",\"checked\":\"true\"}', 8),
(312, 38, 'sent_expiring_reminder', 'checkbox', 'Sent Expiring Reminder', 0, 0, 1, 1, 1, 1, '{\"on\":\"True\",\"off\":\"False\",\"checked\":\"true\"}', 9),
(313, 38, 'is_public', 'checkbox', 'Is Public', 0, 1, 1, 1, 1, 1, '{\"on\":\"True\",\"off\":\"False\",\"checked\":\"true\"}', 10),
(314, 38, 'pushr_id', 'text', 'Pushr Id', 1, 0, 1, 1, 1, 1, '{}', 12),
(315, 38, 'rtmp_key', 'text', 'Rtmp Key', 0, 0, 1, 1, 1, 1, '{}', 13),
(316, 38, 'rtmp_server', 'text', 'Rtmp Server', 0, 0, 1, 1, 1, 1, '{}', 14),
(317, 38, 'hls_link', 'text', 'Hls Link', 0, 0, 1, 1, 1, 1, '{}', 15),
(318, 38, 'vod_link', 'text', 'Vod Link', 0, 0, 1, 1, 1, 1, '{}', 16),
(319, 38, 'settings', 'text', 'Settings', 0, 0, 0, 0, 0, 1, '{}', 17),
(320, 38, 'ended_at', 'text', 'Ended At', 0, 1, 1, 1, 1, 1, '{}', 18),
(321, 38, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 19),
(322, 38, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 20),
(323, 39, 'id', 'text', 'Id', 1, 0, 0, 0, 0, 0, '{}', 1),
(324, 39, 'used_by', 'text', 'Used By (UserID)', 1, 1, 1, 1, 1, 1, '{}', 3),
(325, 39, 'referral_code', 'text', 'Referral Code', 1, 1, 1, 1, 1, 1, '{}', 2),
(326, 39, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 4),
(327, 39, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 5),
(328, 40, 'id', 'text', 'Id', 1, 0, 0, 0, 0, 0, '{}', 1),
(329, 40, 'from_user_id', 'text', 'From User Id', 0, 1, 1, 1, 1, 1, '{}', 3),
(330, 40, 'to_user_id', 'text', 'To User Id', 0, 1, 1, 1, 1, 1, '{}', 5),
(331, 40, 'transaction_id', 'text', 'Transaction Id', 0, 1, 1, 1, 1, 1, '{}', 6),
(332, 40, 'referral_code_usage_id', 'text', 'Referral Code Usage Id', 0, 0, 1, 1, 1, 1, '{}', 7),
(333, 40, 'amount', 'text', 'Amount', 0, 1, 1, 1, 1, 1, '{}', 8),
(334, 40, 'reward_type', 'text', 'Reward Type', 1, 1, 1, 1, 1, 1, '{}', 9),
(335, 40, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, '{}', 10),
(336, 40, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '{}', 11),
(337, 21, 'hidden', 'checkbox', 'Hidden', 1, 1, 1, 1, 1, 1, '{}', 7),
(338, 27, 'is_tos', 'checkbox', 'Is Tos', 0, 1, 1, 1, 1, 1, '{\"on\":\"On\",\"off\":\"Off\",\"checked\":\"true\"}', 8),
(339, 27, 'is_privacy', 'checkbox', 'Is Privacy', 0, 1, 1, 1, 1, 1, '{\"on\":\"On\",\"off\":\"Off\",\"checked\":\"true\"}', 9),
(340, 27, 'short_title', 'text', 'Short Title', 0, 1, 1, 1, 1, 1, '{\"description\":\"If provided, it will be used in places where a shorter version of the page name is needed.\"}', 3),
(341, 1, 'user_belongsto_user_gender_relationship', 'relationship', 'Gender', 0, 1, 1, 1, 0, 1, '{\"model\":\"App\\\\Model\\\\UserGender\",\"table\":\"user_genders\",\"type\":\"belongsTo\",\"column\":\"gender_id\",\"key\":\"id\",\"label\":\"gender_name\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 14),
(342, 4, 'wallet_hasone_user_relationship_1', 'relationship', 'Name', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"hasOne\",\"column\":\"id\",\"key\":\"user_id\",\"label\":\"name\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 4),
(343, 28, 'user_verify_hasone_user_relationship_1', 'relationship', 'Name', 0, 1, 1, 1, 0, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"hasOne\",\"column\":\"id\",\"key\":\"user_id\",\"label\":\"name\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 4),
(344, 11, 'release_date', 'timestamp', 'Release Date', 0, 1, 1, 1, 1, 1, '{}', 8),
(345, 11, 'expire_date', 'timestamp', 'Expire Date', 0, 1, 1, 1, 1, 1, '{}', 9),
(346, 11, 'is_pinned', 'checkbox', 'Is Pinned', 1, 1, 1, 1, 1, 1, '{\"on\":\"On\",\"off\":\"Off\",\"checked\":\"true\"}', 7),
(348, 6, 'coconut_id', 'text', 'Coconut Id', 0, 0, 1, 1, 0, 0, '{}', 10),
(349, 6, 'has_thumbnail', 'text', 'Has Thumbnail', 0, 0, 0, 0, 0, 0, '{}', 12),
(350, 6, 'payment_request_id', 'text', 'Payment Request Id', 0, 0, 1, 1, 1, 0, '{}', 5),
(353, 29, 'user_report_hasone_user_relationship', 'relationship', 'Reporter', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"from_user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 2),
(354, 29, 'user_report_hasone_user_relationship_1', 'relationship', 'Reported', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 4),
(355, 9, 'stream_id', 'text', 'Stream Id', 0, 0, 1, 1, 1, 1, '{}', 12),
(356, 9, 'read', 'checkbox', 'Read', 1, 1, 1, 1, 1, 1, '{\"on\":\"True\",\"off\":\"False\",\"checked\":\"true\"}', 14),
(357, 18, 'price', 'text', 'Price', 0, 1, 1, 1, 1, 1, '{}', 7),
(358, 28, 'user_verify_belongsto_user_relationship', 'relationship', 'Username', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 2),
(359, 4, 'wallet_belongsto_user_relationship', 'relationship', 'Username', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 2),
(360, 9, 'notification_belongsto_user_relationship', 'relationship', 'From', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"from_user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 2),
(361, 9, 'notification_belongsto_user_relationship_1', 'relationship', 'To', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"to_user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 4),
(362, 18, 'user_message_belongsto_user_relationship', 'relationship', 'Sender', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"sender_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 2),
(363, 18, 'user_message_belongsto_user_relationship_1', 'relationship', 'Receiver', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"receiver_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 4),
(364, 12, 'reaction_belongsto_user_relationship', 'relationship', 'Username', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 2),
(365, 16, 'user_list_belongsto_user_relationship', 'relationship', 'Username', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 2),
(366, 17, 'user_list_member_belongsto_user_relationship', 'relationship', 'Member', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 4),
(368, 11, 'post_belongsto_user_relationship', 'relationship', 'Username', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 2),
(369, 6, 'attachment_belongsto_user_relationship', 'relationship', 'Username', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 2),
(370, 10, 'post_comment_belongsto_user_relationship', 'relationship', 'Username', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 2),
(371, 15, 'user_bookmark_belongsto_user_relationship', 'relationship', 'Username', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 2),
(372, 38, 'stream_belongsto_user_relationship', 'relationship', 'Username', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 2),
(373, 37, 'stream_message_belongsto_user_relationship', 'relationship', 'Username', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 2),
(374, 13, 'subscription_belongsto_user_relationship', 'relationship', 'Subscriber', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"sender_user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 2),
(375, 13, 'subscription_belongsto_user_relationship_1', 'relationship', 'Creator', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"recipient_user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 4),
(376, 14, 'transaction_belongsto_user_relationship', 'relationship', 'Sender', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"sender_user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 2),
(377, 14, 'transaction_belongsto_user_relationship_1', 'relationship', 'Recipient', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"recipient_user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 4),
(378, 14, 'mercado_payment_token', 'text', 'Mercado Payment Token', 0, 0, 1, 1, 1, 1, '{}', 25),
(379, 14, 'mercado_payment_id', 'text', 'Mercado Payment Id', 0, 0, 1, 1, 1, 1, '{}', 26),
(380, 19, 'withdrawal_belongsto_user_relationship', 'relationship', 'Username', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 2),
(381, 33, 'payment_request_belongsto_user_relationship', 'relationship', 'Username', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 2),
(382, 34, 'invoice_hasone_transaction_relationship', 'relationship', 'Transaction Id', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\Model\\\\Transaction\",\"table\":\"transactions\",\"type\":\"hasOne\",\"column\":\"invoice_id\",\"key\":\"id\",\"label\":\"id\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 3),
(383, 40, 'reward_belongsto_user_relationship', 'relationship', 'Referral', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"from_user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 2),
(384, 40, 'reward_belongsto_user_relationship_1', 'relationship', 'Referred', 0, 1, 1, 1, 1, 1, '{\"model\":\"App\\\\User\",\"table\":\"users\",\"type\":\"belongsTo\",\"column\":\"to_user_id\",\"key\":\"id\",\"label\":\"username\",\"pivot_table\":\"attachments\",\"pivot\":\"0\",\"taggable\":\"0\"}', 4),
(385, 29, 'message_id', 'text', 'MessageID', 0, 1, 1, 1, 1, 1, '{}', 7),
(386, 29, 'stream_id', 'text', 'StreamID', 0, 1, 1, 1, 1, 1, '{}', 8);

-- --------------------------------------------------------

--
-- Table structure for table `data_types`
--

DROP TABLE IF EXISTS `data_types`;
CREATE TABLE IF NOT EXISTS `data_types` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name_singular` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name_plural` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `model_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `policy_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `controller` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `generate_permissions` tinyint(1) NOT NULL DEFAULT '0',
  `server_side` tinyint NOT NULL DEFAULT '0',
  `details` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `data_types_name_unique` (`name`),
  UNIQUE KEY `data_types_slug_unique` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `data_types`
--

INSERT INTO `data_types` (`id`, `name`, `slug`, `display_name_singular`, `display_name_plural`, `icon`, `model_name`, `policy_name`, `controller`, `description`, `generate_permissions`, `server_side`, `details`, `created_at`, `updated_at`) VALUES
(1, 'users', 'users', 'User', 'Users', 'voyager-person', 'App\\User', 'App\\Policies\\VoyagerUserPolicy', 'TCG\\Voyager\\Http\\Controllers\\VoyagerUserController', NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"desc\",\"default_search_key\":null,\"scope\":null}', '2021-08-07 13:22:09', '2024-01-28 17:09:43'),
(2, 'menus', 'menus', 'Menu', 'Menus', 'voyager-list', 'TCG\\Voyager\\Models\\Menu', NULL, '', '', 1, 0, NULL, '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(3, 'roles', 'roles', 'Role', 'Roles', 'voyager-lock', 'TCG\\Voyager\\Models\\Role', NULL, 'TCG\\Voyager\\Http\\Controllers\\VoyagerRoleController', NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"desc\",\"default_search_key\":null,\"scope\":null}', '2021-08-07 13:22:09', '2021-10-23 15:18:27'),
(4, 'wallets', 'wallets', 'Wallet', 'Wallets', 'voyager-wallet', 'App\\Model\\Wallet', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2021-08-07 14:07:16', '2024-04-30 17:46:27'),
(6, 'attachments', 'attachments', 'Attachment', 'Attachments', 'voyager-paperclip', 'App\\Model\\Attachment', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2021-08-07 14:46:55', '2024-04-30 18:17:58'),
(9, 'notifications', 'notifications', 'Notification', 'Notifications', 'voyager-bell', 'App\\Model\\Notification', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2021-08-07 14:49:11', '2024-04-30 17:46:45'),
(10, 'post_comments', 'post-comments', 'Post Comment', 'Post Comments', 'voyager-bubble', 'App\\Model\\PostComment', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2021-08-07 14:50:55', '2024-04-30 18:18:48'),
(11, 'posts', 'user-posts', 'Post', 'Posts', 'voyager-images', 'App\\Model\\Post', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2021-08-07 14:52:37', '2024-04-30 18:15:47'),
(12, 'reactions', 'reactions', 'Reaction', 'Reactions', 'voyager-bubble-hear', 'App\\Model\\Reaction', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2021-08-07 14:54:58', '2024-04-30 17:57:48'),
(13, 'subscriptions', 'subscriptions', 'Subscription', 'Subscriptions', 'voyager-credit-cards', 'App\\Model\\Subscription', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2021-08-07 14:55:32', '2024-04-30 18:31:14'),
(14, 'transactions', 'transactions', 'Transaction', 'Transactions', 'voyager-dollar', 'App\\Model\\Transaction', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2021-08-07 14:56:33', '2024-04-30 18:44:52'),
(15, 'user_bookmarks', 'user-bookmarks', 'User Bookmark', 'User Bookmarks', 'voyager-bookmark', 'App\\Model\\UserBookmark', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2021-08-07 14:57:47', '2024-04-30 18:20:11'),
(16, 'user_lists', 'user-lists', 'User List', 'User Lists', 'voyager-list', 'App\\Model\\UserList', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2021-08-07 14:58:45', '2024-04-30 18:04:12'),
(17, 'user_list_members', 'user-list-members', 'User List Member', 'User List Members', 'voyager-people', 'App\\Model\\UserListMember', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2021-08-07 14:59:07', '2024-04-30 18:07:48'),
(18, 'user_messages', 'user-messages', 'User Message', 'User Messages', 'voyager-chat', 'App\\Model\\UserMessage', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2021-08-07 15:12:32', '2024-04-30 17:51:13'),
(19, 'withdrawals', 'withdrawals', 'Withdrawal', 'Withdrawals', 'voyager-calendar', 'App\\Model\\Withdrawal', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2021-08-07 15:21:14', '2024-04-30 18:39:56'),
(20, 'countries', 'countries', 'Country', 'Countries', 'voyager-location', 'App\\Model\\Country', NULL, NULL, NULL, 1, 1, '{\"order_column\":\"name\",\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2021-09-21 12:40:16', '2021-10-23 15:13:47'),
(21, 'taxes', 'taxes', 'Tax', 'Taxes', 'voyager-credit-card', 'App\\Model\\Tax', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2021-09-21 12:41:55', '2024-02-27 13:59:00'),
(27, 'public_pages', 'custom-pages', 'Public Page', 'Public Pages', 'voyager-news', 'App\\Model\\PublicPage', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2021-09-29 14:13:27', '2024-06-20 15:47:41'),
(28, 'user_verifies', 'user-verifies', 'User Verify', 'User Verifies', 'voyager-check', 'App\\Model\\UserVerify', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2021-10-20 10:41:44', '2024-04-30 17:18:52'),
(29, 'user_reports', 'user-reports', 'User Report', 'User Reports', 'voyager-eye', 'App\\Model\\UserReport', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2021-11-05 06:02:40', '2024-05-09 16:38:46'),
(30, 'contact_messages', 'contact-messages', 'Contact Message', 'Contact Messages', 'voyager-book', 'App\\Model\\ContactMessage', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2021-11-19 12:41:33', '2022-06-24 09:23:36'),
(32, 'featured_users', 'featured-users', 'Featured User', 'Featured Users', 'voyager-star', 'App\\Model\\FeaturedUser', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2022-02-01 09:30:10', '2024-04-22 09:33:58'),
(33, 'payment_requests', 'payment-requests', 'Payment Request', 'Payment Requests', 'voyager-window-list', 'App\\Model\\PaymentRequest', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2022-02-06 10:53:24', '2024-04-30 18:48:22'),
(34, 'invoices', 'invoices', 'Invoice', 'Invoices', 'voyager-receipt', 'App\\Model\\Invoice', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2022-08-04 13:36:47', '2024-04-30 18:51:33'),
(37, 'stream_messages', 'stream-messages', 'Stream Message', 'Stream Messages', 'voyager-chat', 'App\\Model\\StreamMessage', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2023-06-21 09:18:56', '2024-04-30 18:25:59'),
(38, 'streams', 'streams', 'Stream', 'Streams', 'voyager-video', 'App\\Model\\Stream', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2023-06-21 09:31:44', '2024-05-10 09:15:55'),
(39, 'referral_code_usages', 'referral-code-usages', 'Referrals', 'Referrals', 'voyager-group', 'App\\Model\\ReferralCodeUsage', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2023-06-21 10:56:01', '2023-06-21 10:57:13'),
(40, 'rewards', 'rewards', 'Referral', 'Referrals', 'voyager-group', 'App\\Model\\Reward', NULL, NULL, NULL, 1, 1, '{\"order_column\":null,\"order_display_column\":null,\"order_direction\":\"asc\",\"default_search_key\":null,\"scope\":null}', '2023-06-21 10:56:04', '2024-04-30 18:56:33');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
CREATE TABLE IF NOT EXISTS `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `featured_users`
--

DROP TABLE IF EXISTS `featured_users`;
CREATE TABLE IF NOT EXISTS `featured_users` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `featured_users_user_id_foreign` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

DROP TABLE IF EXISTS `invoices`;
CREATE TABLE IF NOT EXISTS `invoices` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `invoice_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoices_invoice_id_unique` (`invoice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
CREATE TABLE IF NOT EXISTS `jobs` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `queue` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `menus`
--

DROP TABLE IF EXISTS `menus`;
CREATE TABLE IF NOT EXISTS `menus` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `menus_name_unique` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `menus`
--

INSERT INTO `menus` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'admin', '2021-08-07 13:22:09', '2021-08-07 13:22:09');

-- --------------------------------------------------------

--
-- Table structure for table `menu_items`
--

DROP TABLE IF EXISTS `menu_items`;
CREATE TABLE IF NOT EXISTS `menu_items` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `menu_id` int UNSIGNED DEFAULT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `target` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '_self',
  `icon_class` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parent_id` int DEFAULT NULL,
  `order` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `route` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parameters` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `menu_items_menu_id_foreign` (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `menu_items`
--

INSERT INTO `menu_items` (`id`, `menu_id`, `title`, `url`, `target`, `icon_class`, `color`, `parent_id`, `order`, `created_at`, `updated_at`, `route`, `parameters`) VALUES
(1, 1, 'Dashboard', '', '_self', 'voyager-home', '#000000', NULL, 1, '2021-08-07 13:22:09', '2022-06-24 07:44:52', 'voyager.dashboard', 'null'),
(2, 1, 'Media', '', '_self', 'voyager-images', NULL, NULL, 2, '2021-08-07 13:22:09', '2021-08-08 17:02:02', 'voyager.media.index', NULL),
(3, 1, 'Users', '', '_self', 'voyager-person', NULL, 29, 1, '2021-08-07 13:22:09', '2021-08-07 15:29:55', 'voyager.users.index', NULL),
(4, 1, 'Roles', '', '_self', 'voyager-lock', NULL, 29, 3, '2021-08-07 13:22:09', '2021-10-20 10:50:11', 'voyager.roles.index', NULL),
(6, 1, 'Menu Builder', '', '_self', 'voyager-list', NULL, 5, 1, '2021-08-07 13:22:09', '2021-08-07 14:42:22', 'voyager.menus.index', NULL),
(7, 1, 'Database', '', '_self', 'voyager-data', NULL, 5, 2, '2021-08-07 13:22:09', '2021-08-07 14:42:22', 'voyager.database.index', NULL),
(8, 1, 'Compass', '', '_self', 'voyager-compass', NULL, 5, 3, '2021-08-07 13:22:09', '2021-08-07 14:42:22', 'voyager.compass.index', NULL),
(9, 1, 'BREAD', '', '_self', 'voyager-bread', NULL, 5, 4, '2021-08-07 13:22:09', '2021-08-07 14:42:22', 'voyager.bread.index', NULL),
(10, 1, 'Settings', '', '_self', 'voyager-settings', NULL, NULL, 11, '2021-08-07 13:22:09', '2023-06-21 09:32:27', 'voyager.settings.index', NULL),
(12, 1, 'Wallets', '', '_self', 'voyager-wallet', '#000000', 29, 4, '2021-08-07 14:07:16', '2021-10-20 10:50:11', 'voyager.wallets.index', 'null'),
(14, 1, 'Attachments', '', '_self', 'voyager-paperclip', '#000000', 28, 2, '2021-08-07 14:46:55', '2022-02-01 10:11:20', 'voyager.attachments.index', 'null'),
(15, 1, 'Notifications', '', '_self', 'voyager-bell', NULL, 29, 5, '2021-08-07 14:49:11', '2021-10-20 10:50:11', 'voyager.notifications.index', NULL),
(16, 1, 'Post Comments', '', '_self', 'voyager-bubble', NULL, 28, 3, '2021-08-07 14:50:55', '2022-02-01 10:11:20', 'voyager.post-comments.index', NULL),
(17, 1, 'Posts', '', '_self', 'voyager-images', NULL, 28, 1, '2021-08-07 14:52:37', '2021-08-07 15:28:22', 'voyager.user-posts.index', NULL),
(18, 1, 'Reactions', '', '_self', 'voyager-bubble-hear', NULL, 29, 7, '2021-08-07 14:54:58', '2021-10-20 10:50:11', 'voyager.reactions.index', NULL),
(19, 1, 'Subscriptions', '', '_self', 'voyager-credit-cards', NULL, 27, 1, '2021-08-07 14:55:32', '2021-08-07 15:25:55', 'voyager.subscriptions.index', NULL),
(20, 1, 'Transactions', '', '_self', 'voyager-dollar', NULL, 27, 2, '2021-08-07 14:56:33', '2021-08-07 15:25:55', 'voyager.transactions.index', NULL),
(21, 1, 'User Bookmarks', '', '_self', 'voyager-bookmark', NULL, 28, 4, '2021-08-07 14:57:47', '2022-02-01 10:11:20', 'voyager.user-bookmarks.index', NULL),
(22, 1, 'Lists', '', '_self', 'voyager-list', '#000000', 29, 8, '2021-08-07 14:58:45', '2021-10-20 10:50:11', 'voyager.user-lists.index', 'null'),
(23, 1, 'List Members', '', '_self', 'voyager-people', '#000000', 29, 9, '2021-08-07 14:59:07', '2021-10-20 10:49:58', 'voyager.user-list-members.index', 'null'),
(24, 1, 'Messages', '', '_self', 'voyager-chat', '#000000', 29, 6, '2021-08-07 15:12:32', '2021-10-20 10:50:11', 'voyager.user-messages.index', 'null'),
(25, 1, 'Withdrawals', '', '_self', 'voyager-calendar', NULL, 27, 3, '2021-08-07 15:21:14', '2021-08-07 15:25:53', 'voyager.withdrawals.index', NULL),
(26, 1, 'User lists', '', '_self', 'voyager-list', '#000000', NULL, 4, '2021-08-07 15:24:21', '2021-09-30 05:51:46', NULL, ''),
(27, 1, 'Money', '', '_self', 'voyager-dollar', '#000000', NULL, 7, '2021-08-07 15:25:37', '2023-06-21 09:32:27', NULL, ''),
(28, 1, 'Posts', '', '_self', 'voyager-images', '#000000', NULL, 5, '2021-08-07 15:27:03', '2021-09-30 05:51:46', NULL, ''),
(29, 1, 'Users', '', '_self', 'voyager-person', '#000000', NULL, 3, '2021-08-07 15:28:37', '2021-08-08 17:02:02', NULL, ''),
(30, 1, 'Countries', '', '_self', 'voyager-location', '#000000', 33, 2, '2021-09-21 12:40:16', '2021-09-30 05:56:53', 'voyager.countries.index', 'null'),
(31, 1, 'Taxes', '', '_self', 'voyager-credit-card', '#000000', 33, 1, '2021-09-21 12:41:55', '2021-09-30 05:56:53', 'voyager.taxes.index', 'null'),
(32, 1, 'Pages', '', '_self', 'voyager-news', '#000000', NULL, 9, '2021-09-29 14:13:27', '2023-06-21 09:32:27', 'voyager.custom-pages.index', 'null'),
(33, 1, 'Taxes', '', '_self', 'voyager-credit-card', '#000000', NULL, 8, '2021-09-30 05:55:21', '2023-06-21 09:32:27', NULL, ''),
(34, 1, 'Identity Checks', '', '_self', 'voyager-check', '#000000', 29, 2, '2021-10-20 10:41:44', '2021-10-20 10:51:40', 'voyager.user-verifies.index', 'null'),
(35, 1, 'User Reports', '', '_self', 'voyager-eye', '#000000', 29, 10, '2021-11-05 06:02:40', '2022-02-01 10:11:22', 'voyager.user-reports.index', 'null'),
(36, 1, 'Contact Messages', '', '_self', 'voyager-book', '#000000', NULL, 10, '2021-11-19 12:41:34', '2023-06-21 09:32:27', 'voyager.contact-messages.index', 'null'),
(37, 1, 'Featured Users', '', '_self', 'voyager-star', '#000000', 29, 11, '2022-02-01 09:30:11', '2022-02-01 10:11:54', 'voyager.featured-users.index', 'null'),
(38, 1, 'Payment Requests', '', '_self', 'voyager-window-list', '#000000', 27, 4, '2022-02-06 10:53:24', '2022-02-06 10:55:11', 'voyager.payment-requests.index', 'null'),
(39, 1, 'Invoices', '', '_self', 'voyager-receipt', NULL, 27, 5, '2022-08-04 13:36:47', '2022-08-04 13:37:16', 'voyager.invoices.index', NULL),
(41, 1, 'Stream Messages', '', '_self', 'voyager-chat', NULL, 42, 2, '2023-06-21 09:18:56', '2023-06-21 09:32:27', 'voyager.stream-messages.index', NULL),
(42, 1, 'Streams', '', '_self', 'voyager-video', '#000000', NULL, 6, '2023-06-21 09:26:54', '2023-06-21 09:32:27', NULL, ''),
(43, 1, 'Streams', '', '_self', 'voyager-video', '#000000', 42, 1, '2023-06-21 09:31:44', '2023-06-21 09:33:03', 'voyager.streams.index', 'null'),
(46, 1, 'Referrals', '', '_self', 'voyager-group', '#000000', 27, 6, '2023-06-21 10:56:04', '2023-06-21 11:01:29', 'voyager.rewards.index', 'null');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2016_01_01_000000_add_voyager_user_fields', 1),
(4, '2016_01_01_000000_create_data_types_table', 1),
(5, '2016_05_19_173453_create_menu_table', 1),
(6, '2016_10_21_190000_create_roles_table', 1),
(7, '2016_10_21_190000_create_settings_table', 1),
(8, '2016_11_30_135954_create_permission_table', 1),
(9, '2016_11_30_141208_create_permission_role_table', 1),
(10, '2016_12_26_201236_data_types__add__server_side', 1),
(11, '2017_01_13_000000_add_route_to_menu_items_table', 1),
(12, '2017_01_14_005015_create_translations_table', 1),
(13, '2017_01_15_000000_make_table_name_nullable_in_permissions_table', 1),
(14, '2017_03_06_000000_add_controller_to_data_types_table', 1),
(15, '2017_04_21_000000_add_order_to_data_rows_table', 1),
(16, '2017_07_05_210000_add_policyname_to_data_types_table', 1),
(17, '2017_08_05_000000_add_group_to_settings_table', 1),
(18, '2017_11_26_013050_add_user_role_relationship', 1),
(19, '2017_11_26_015000_create_user_roles_table', 1),
(20, '2018_03_11_000000_add_user_settings', 1),
(21, '2018_03_14_000000_add_details_to_data_types_table', 1),
(22, '2018_03_16_000000_make_settings_value_nullable', 1),
(23, '2019_08_19_000000_create_failed_jobs_table', 1),
(24, '2021_04_27_182503_create_posts_table', 1),
(25, '2021_04_27_183624_create_post_comments_table', 1),
(26, '2021_04_27_184708_create_reactions_table', 1),
(27, '2021_04_27_185338_create_subscriptions_table', 1),
(28, '2021_04_27_192318_create_withdrawals_table', 1),
(29, '2021_05_09_125019_user_messages', 1),
(30, '2021_05_09_125020_create_attachments_table', 1),
(31, '2021_05_20_181455_create_invoices_table', 1),
(32, '2021_05_23_190500_create_transactions_table', 1),
(33, '2021_07_26_182432_user_bookmarks', 1),
(34, '2021_07_26_182613_user_lists', 1),
(35, '2021_07_26_182632_user_list_members', 1),
(36, '2021_07_30_164554_create_notifications_table', 1),
(37, '2021_08_01_192155_create_jobs_table', 1),
(38, '2021_08_02_171126_create_wallets_table', 1),
(39, '2021_09_09_182917_create_user_reports', 1),
(40, '2021_09_10_155813_create_taxes_table', 1),
(41, '2021_09_10_160221_create_countries_table', 1),
(42, '2021_09_10_164638_create_country_taxes_table', 1),
(43, '2021_09_29_165028_add_public_pages_table', 1),
(44, '2021_10_20_143619_create_user_verifies_table', 1),
(45, '2021_10_25_184224_create_creator_offers', 1),
(46, '2021_11_19_174900_create_contact_messages_table', 1),
(47, '2021_11_21_171513_insert_default_admin_settings', 1),
(48, '2021_12_19_170152_v1_0_4', 1),
(49, '2021_12_19_170152_v1_0_5', 1),
(50, '2021_12_19_170152_v1_0_6', 1),
(51, '2021_12_28_170152_v1_1_0', 1),
(52, '2021_12_28_170152_v1_1_1', 1),
(53, '2021_12_31_170152_v1_1_2', 1),
(54, '2022_1_6_170152_v1_1_4', 1),
(55, '2022_1_8_170152_v1_1_5', 1),
(56, '2100_1_12_170153_v1_2_0', 1),
(57, '2101_1_20_170153_v1_3_1', 1),
(58, '2102_1_22_170153_v1_4_0', 1),
(59, '2103_1_25_170153_v1_5_0', 1),
(60, '2104_1_29_170153_v1_5_2', 1),
(61, '2105_1_31_170153_v1_6_0', 1),
(62, '2106_2_5_170153_v1_6_2', 1),
(63, '2107_02_01_205525_v1_7_0', 1),
(64, '2108_2_10_205525_v1_7_1', 1),
(65, '2109_2_11_205525_v1_8_1', 1),
(66, '2110_2_23_205525_v1_9_0', 1),
(67, '2111_2_23_205525_v2_0_0', 1),
(68, '2112_3_5_205525_v2_1_0', 1),
(69, '2113_3_10_205525_v2_2_0', 1),
(70, '2114_3_14_205525_v2_3_0', 1),
(71, '2116_03_10_185313_v2_4_0', 1),
(72, '2117_03_22_185313_v2_5_0', 1),
(73, '2118_03_28_202948_v2_6_0', 1),
(74, '2119_04_9_202948_v2_7_0', 1),
(75, '2119_04_9_202948_v2_8_0', 1),
(76, '2120_02_16_190107_v3_0_0', 1),
(77, '2121_04_30_190107_v3_2_0', 1),
(78, '2122_05_2_190107_v3_3_0', 1),
(79, '2123_05_9_190107_v3_4_0', 1),
(80, '2125_05_16_190107_v3_5_0', 1),
(81, '2126_05_20_190107_v3_5_1', 1),
(82, '2127_03_29_184610_v3_6_0', 1),
(83, '2128_05_31_184610_v3_7_0', 1),
(84, '2129_05_31_184610_v3_8_0', 1),
(85, '2130_05_31_184610_v3_9_0', 1),
(86, '2131_06_24_184610_v4_0_0', 1),
(87, '2132_07_8_184610_v4_2_0', 1),
(88, '2133_07_8_184610_v4_3_0', 1),
(89, '2134_07_8_184610_v4_3_1', 1),
(90, '2135_07_19_181329_v4_4_0', 1),
(91, '2136_08_13_141149_v4_5_0', 1),
(92, '2137_09_10_165955_v4_7_0', 1),
(93, '2138_09_10_165955_v4_8_0', 1),
(94, '2138_09_26_172825_v_4_9_0', 1),
(95, '2140_10_17_165955_v5_0_0', 1),
(96, '2142_10_20_165955_v5_1_0', 1),
(97, '2145_11_7_165955_v5_2_0', 1),
(98, '2145_11_7_165955_v5_3_0', 1),
(99, '2146_11_21_192853_v5_3_1', 1),
(100, '2147_11_22_192853_v5_4_0', 1),
(101, '2148_12_11_192854_v5_5_0', 1),
(102, '2149_12_29_192854_v5_6_0', 1),
(103, '2150_12_01_200043_v5_7_0', 1),
(104, '2151_3_07_200043_v5_8_0', 1),
(105, '2152_3_07_200043_v5_9_0', 1),
(106, '2153_3_07_200044_v6_1_0', 1),
(107, '2154_3_07_200045_v6_2_0', 1),
(108, '2155_3_07_200045_v6_3_0', 1),
(109, '2156_3_07_200046_v6_4_0', 1),
(110, '2157_09_20_181428_v6_5_0', 1),
(111, '2158_08_24_184332_v6_6_0', 1),
(112, '2158_08_24_184333_v6_7_0', 1),
(113, '2158_08_24_184334_v6_8_0', 1),
(114, '2159_08_24_184334_v6_9_0', 1),
(115, '2160_08_24_184334_v7_0_0', 1),
(116, '2161_03_26_203627_v7_1_0', 1);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
CREATE TABLE IF NOT EXISTS `notifications` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_user_id` bigint UNSIGNED DEFAULT NULL,
  `to_user_id` bigint UNSIGNED DEFAULT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `post_id` bigint UNSIGNED DEFAULT NULL,
  `post_comment_id` bigint UNSIGNED DEFAULT NULL,
  `subscription_id` bigint UNSIGNED DEFAULT NULL,
  `transaction_id` bigint UNSIGNED DEFAULT NULL,
  `reaction_id` bigint UNSIGNED DEFAULT NULL,
  `withdrawal_id` bigint UNSIGNED DEFAULT NULL,
  `user_message_id` bigint UNSIGNED DEFAULT NULL,
  `stream_id` bigint UNSIGNED DEFAULT NULL,
  `read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notifications_from_user_id_foreign` (`from_user_id`),
  KEY `notifications_to_user_id_foreign` (`to_user_id`),
  KEY `notifications_post_id_foreign` (`post_id`),
  KEY `notifications_post_comment_id_foreign` (`post_comment_id`),
  KEY `notifications_subscription_id_foreign` (`subscription_id`),
  KEY `notifications_transaction_id_foreign` (`transaction_id`),
  KEY `notifications_reaction_id_foreign` (`reaction_id`),
  KEY `notifications_withdrawal_id_foreign` (`withdrawal_id`),
  KEY `notifications_type_index` (`type`),
  KEY `notifications_user_message_id_index` (`user_message_id`),
  KEY `notifications_stream_id_foreign` (`stream_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
CREATE TABLE IF NOT EXISTS `password_resets` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payment_requests`
--

DROP TABLE IF EXISTS `payment_requests`;
CREATE TABLE IF NOT EXISTS `payment_requests` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `transaction_id` bigint UNSIGNED NOT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reason` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` double(8,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `payment_requests_user_id_foreign` (`user_id`),
  KEY `payment_requests_transaction_id_foreign` (`transaction_id`),
  KEY `payment_requests_status_index` (`status`),
  KEY `payment_requests_type_index` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
CREATE TABLE IF NOT EXISTS `permissions` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `key` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `table_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `permissions_key_index` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `key`, `table_name`, `created_at`, `updated_at`) VALUES
(1, 'browse_admin', NULL, '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(2, 'browse_bread', NULL, '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(3, 'browse_database', NULL, '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(4, 'browse_media', NULL, '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(5, 'browse_compass', NULL, '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(6, 'browse_menus', 'menus', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(7, 'read_menus', 'menus', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(8, 'edit_menus', 'menus', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(9, 'add_menus', 'menus', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(10, 'delete_menus', 'menus', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(11, 'browse_roles', 'roles', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(12, 'read_roles', 'roles', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(13, 'edit_roles', 'roles', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(14, 'add_roles', 'roles', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(15, 'delete_roles', 'roles', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(16, 'browse_users', 'users', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(17, 'read_users', 'users', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(18, 'edit_users', 'users', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(19, 'add_users', 'users', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(20, 'delete_users', 'users', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(21, 'browse_settings', 'settings', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(22, 'read_settings', 'settings', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(23, 'edit_settings', 'settings', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(24, 'add_settings', 'settings', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(25, 'delete_settings', 'settings', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(26, 'browse_hooks', NULL, '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(27, 'browse_wallets', 'wallets', '2021-08-07 14:07:16', '2021-08-07 14:07:16'),
(28, 'read_wallets', 'wallets', '2021-08-07 14:07:16', '2021-08-07 14:07:16'),
(29, 'edit_wallets', 'wallets', '2021-08-07 14:07:16', '2021-08-07 14:07:16'),
(30, 'add_wallets', 'wallets', '2021-08-07 14:07:16', '2021-08-07 14:07:16'),
(31, 'delete_wallets', 'wallets', '2021-08-07 14:07:16', '2021-08-07 14:07:16'),
(32, 'browse_attachments', 'attachments', '2021-08-07 14:46:55', '2021-08-07 14:46:55'),
(33, 'read_attachments', 'attachments', '2021-08-07 14:46:55', '2021-08-07 14:46:55'),
(34, 'edit_attachments', 'attachments', '2021-08-07 14:46:55', '2021-08-07 14:46:55'),
(35, 'add_attachments', 'attachments', '2021-08-07 14:46:55', '2021-08-07 14:46:55'),
(36, 'delete_attachments', 'attachments', '2021-08-07 14:46:55', '2021-08-07 14:46:55'),
(37, 'browse_notifications', 'notifications', '2021-08-07 14:49:11', '2021-08-07 14:49:11'),
(38, 'read_notifications', 'notifications', '2021-08-07 14:49:11', '2021-08-07 14:49:11'),
(39, 'edit_notifications', 'notifications', '2021-08-07 14:49:11', '2021-08-07 14:49:11'),
(40, 'add_notifications', 'notifications', '2021-08-07 14:49:11', '2021-08-07 14:49:11'),
(41, 'delete_notifications', 'notifications', '2021-08-07 14:49:11', '2021-08-07 14:49:11'),
(42, 'browse_post_comments', 'post_comments', '2021-08-07 14:50:55', '2021-08-07 14:50:55'),
(43, 'read_post_comments', 'post_comments', '2021-08-07 14:50:55', '2021-08-07 14:50:55'),
(44, 'edit_post_comments', 'post_comments', '2021-08-07 14:50:55', '2021-08-07 14:50:55'),
(45, 'add_post_comments', 'post_comments', '2021-08-07 14:50:55', '2021-08-07 14:50:55'),
(46, 'delete_post_comments', 'post_comments', '2021-08-07 14:50:55', '2021-08-07 14:50:55'),
(47, 'browse_posts', 'posts', '2021-08-07 14:52:37', '2021-08-07 14:52:37'),
(48, 'read_posts', 'posts', '2021-08-07 14:52:37', '2021-08-07 14:52:37'),
(49, 'edit_posts', 'posts', '2021-08-07 14:52:37', '2021-08-07 14:52:37'),
(50, 'add_posts', 'posts', '2021-08-07 14:52:37', '2021-08-07 14:52:37'),
(51, 'delete_posts', 'posts', '2021-08-07 14:52:37', '2021-08-07 14:52:37'),
(52, 'browse_reactions', 'reactions', '2021-08-07 14:54:58', '2021-08-07 14:54:58'),
(53, 'read_reactions', 'reactions', '2021-08-07 14:54:58', '2021-08-07 14:54:58'),
(54, 'edit_reactions', 'reactions', '2021-08-07 14:54:58', '2021-08-07 14:54:58'),
(55, 'add_reactions', 'reactions', '2021-08-07 14:54:58', '2021-08-07 14:54:58'),
(56, 'delete_reactions', 'reactions', '2021-08-07 14:54:58', '2021-08-07 14:54:58'),
(57, 'browse_subscriptions', 'subscriptions', '2021-08-07 14:55:32', '2021-08-07 14:55:32'),
(58, 'read_subscriptions', 'subscriptions', '2021-08-07 14:55:32', '2021-08-07 14:55:32'),
(59, 'edit_subscriptions', 'subscriptions', '2021-08-07 14:55:32', '2021-08-07 14:55:32'),
(60, 'add_subscriptions', 'subscriptions', '2021-08-07 14:55:32', '2021-08-07 14:55:32'),
(61, 'delete_subscriptions', 'subscriptions', '2021-08-07 14:55:32', '2021-08-07 14:55:32'),
(62, 'browse_transactions', 'transactions', '2021-08-07 14:56:33', '2021-08-07 14:56:33'),
(63, 'read_transactions', 'transactions', '2021-08-07 14:56:33', '2021-08-07 14:56:33'),
(64, 'edit_transactions', 'transactions', '2021-08-07 14:56:33', '2021-08-07 14:56:33'),
(65, 'add_transactions', 'transactions', '2021-08-07 14:56:33', '2021-08-07 14:56:33'),
(66, 'delete_transactions', 'transactions', '2021-08-07 14:56:33', '2021-08-07 14:56:33'),
(67, 'browse_user_bookmarks', 'user_bookmarks', '2021-08-07 14:57:47', '2021-08-07 14:57:47'),
(68, 'read_user_bookmarks', 'user_bookmarks', '2021-08-07 14:57:47', '2021-08-07 14:57:47'),
(69, 'edit_user_bookmarks', 'user_bookmarks', '2021-08-07 14:57:47', '2021-08-07 14:57:47'),
(70, 'add_user_bookmarks', 'user_bookmarks', '2021-08-07 14:57:47', '2021-08-07 14:57:47'),
(71, 'delete_user_bookmarks', 'user_bookmarks', '2021-08-07 14:57:47', '2021-08-07 14:57:47'),
(72, 'browse_user_lists', 'user_lists', '2021-08-07 14:58:45', '2021-08-07 14:58:45'),
(73, 'read_user_lists', 'user_lists', '2021-08-07 14:58:45', '2021-08-07 14:58:45'),
(74, 'edit_user_lists', 'user_lists', '2021-08-07 14:58:45', '2021-08-07 14:58:45'),
(75, 'add_user_lists', 'user_lists', '2021-08-07 14:58:45', '2021-08-07 14:58:45'),
(76, 'delete_user_lists', 'user_lists', '2021-08-07 14:58:45', '2021-08-07 14:58:45'),
(77, 'browse_user_list_members', 'user_list_members', '2021-08-07 14:59:07', '2021-08-07 14:59:07'),
(78, 'read_user_list_members', 'user_list_members', '2021-08-07 14:59:07', '2021-08-07 14:59:07'),
(79, 'edit_user_list_members', 'user_list_members', '2021-08-07 14:59:07', '2021-08-07 14:59:07'),
(80, 'add_user_list_members', 'user_list_members', '2021-08-07 14:59:07', '2021-08-07 14:59:07'),
(81, 'delete_user_list_members', 'user_list_members', '2021-08-07 14:59:07', '2021-08-07 14:59:07'),
(82, 'browse_user_messages', 'user_messages', '2021-08-07 15:12:32', '2021-08-07 15:12:32'),
(83, 'read_user_messages', 'user_messages', '2021-08-07 15:12:32', '2021-08-07 15:12:32'),
(84, 'edit_user_messages', 'user_messages', '2021-08-07 15:12:32', '2021-08-07 15:12:32'),
(85, 'add_user_messages', 'user_messages', '2021-08-07 15:12:32', '2021-08-07 15:12:32'),
(86, 'delete_user_messages', 'user_messages', '2021-08-07 15:12:32', '2021-08-07 15:12:32'),
(87, 'browse_withdrawals', 'withdrawals', '2021-08-07 15:21:14', '2021-08-07 15:21:14'),
(88, 'read_withdrawals', 'withdrawals', '2021-08-07 15:21:14', '2021-08-07 15:21:14'),
(89, 'edit_withdrawals', 'withdrawals', '2021-08-07 15:21:14', '2021-08-07 15:21:14'),
(90, 'add_withdrawals', 'withdrawals', '2021-08-07 15:21:14', '2021-08-07 15:21:14'),
(91, 'delete_withdrawals', 'withdrawals', '2021-08-07 15:21:14', '2021-08-07 15:21:14'),
(92, 'browse_countries', 'countries', '2021-09-21 12:40:16', '2021-09-21 12:40:16'),
(93, 'read_countries', 'countries', '2021-09-21 12:40:16', '2021-09-21 12:40:16'),
(94, 'edit_countries', 'countries', '2021-09-21 12:40:16', '2021-09-21 12:40:16'),
(95, 'add_countries', 'countries', '2021-09-21 12:40:16', '2021-09-21 12:40:16'),
(96, 'delete_countries', 'countries', '2021-09-21 12:40:16', '2021-09-21 12:40:16'),
(97, 'browse_taxes', 'taxes', '2021-09-21 12:41:55', '2021-09-21 12:41:55'),
(98, 'read_taxes', 'taxes', '2021-09-21 12:41:55', '2021-09-21 12:41:55'),
(99, 'edit_taxes', 'taxes', '2021-09-21 12:41:55', '2021-09-21 12:41:55'),
(100, 'add_taxes', 'taxes', '2021-09-21 12:41:55', '2021-09-21 12:41:55'),
(101, 'delete_taxes', 'taxes', '2021-09-21 12:41:55', '2021-09-21 12:41:55'),
(102, 'browse_public_pages', 'public_pages', '2021-09-29 14:13:27', '2021-09-29 14:13:27'),
(103, 'read_public_pages', 'public_pages', '2021-09-29 14:13:27', '2021-09-29 14:13:27'),
(104, 'edit_public_pages', 'public_pages', '2021-09-29 14:13:27', '2021-09-29 14:13:27'),
(105, 'add_public_pages', 'public_pages', '2021-09-29 14:13:27', '2021-09-29 14:13:27'),
(106, 'delete_public_pages', 'public_pages', '2021-09-29 14:13:27', '2021-09-29 14:13:27'),
(107, 'browse_user_verifies', 'user_verifies', '2021-10-20 10:41:44', '2021-10-20 10:41:44'),
(108, 'read_user_verifies', 'user_verifies', '2021-10-20 10:41:44', '2021-10-20 10:41:44'),
(109, 'edit_user_verifies', 'user_verifies', '2021-10-20 10:41:44', '2021-10-20 10:41:44'),
(110, 'add_user_verifies', 'user_verifies', '2021-10-20 10:41:44', '2021-10-20 10:41:44'),
(111, 'delete_user_verifies', 'user_verifies', '2021-10-20 10:41:44', '2021-10-20 10:41:44'),
(112, 'browse_user_reports', 'user_reports', '2021-11-05 06:02:40', '2021-11-05 06:02:40'),
(113, 'read_user_reports', 'user_reports', '2021-11-05 06:02:40', '2021-11-05 06:02:40'),
(114, 'edit_user_reports', 'user_reports', '2021-11-05 06:02:40', '2021-11-05 06:02:40'),
(115, 'add_user_reports', 'user_reports', '2021-11-05 06:02:40', '2021-11-05 06:02:40'),
(116, 'delete_user_reports', 'user_reports', '2021-11-05 06:02:40', '2021-11-05 06:02:40'),
(117, 'browse_contact_messages', 'contact_messages', '2021-11-19 12:41:33', '2021-11-19 12:41:33'),
(118, 'read_contact_messages', 'contact_messages', '2021-11-19 12:41:33', '2021-11-19 12:41:33'),
(119, 'edit_contact_messages', 'contact_messages', '2021-11-19 12:41:33', '2021-11-19 12:41:33'),
(120, 'add_contact_messages', 'contact_messages', '2021-11-19 12:41:33', '2021-11-19 12:41:33'),
(121, 'delete_contact_messages', 'contact_messages', '2021-11-19 12:41:33', '2021-11-19 12:41:33'),
(122, 'browse_featured_users', 'featured_users', '2022-02-01 09:30:11', '2022-02-01 09:30:11'),
(123, 'read_featured_users', 'featured_users', '2022-02-01 09:30:11', '2022-02-01 09:30:11'),
(124, 'edit_featured_users', 'featured_users', '2022-02-01 09:30:11', '2022-02-01 09:30:11'),
(125, 'add_featured_users', 'featured_users', '2022-02-01 09:30:11', '2022-02-01 09:30:11'),
(126, 'delete_featured_users', 'featured_users', '2022-02-01 09:30:11', '2022-02-01 09:30:11'),
(127, 'browse_payment_requests', 'payment_requests', '2022-02-06 10:53:24', '2022-02-06 10:53:24'),
(128, 'read_payment_requests', 'payment_requests', '2022-02-06 10:53:24', '2022-02-06 10:53:24'),
(129, 'edit_payment_requests', 'payment_requests', '2022-02-06 10:53:24', '2022-02-06 10:53:24'),
(130, 'add_payment_requests', 'payment_requests', '2022-02-06 10:53:24', '2022-02-06 10:53:24'),
(131, 'delete_payment_requests', 'payment_requests', '2022-02-06 10:53:24', '2022-02-06 10:53:24'),
(132, 'browse_invoices', 'invoices', '2022-08-04 13:36:47', '2022-08-04 13:36:47'),
(133, 'read_invoices', 'invoices', '2022-08-04 13:36:47', '2022-08-04 13:36:47'),
(134, 'edit_invoices', 'invoices', '2022-08-04 13:36:47', '2022-08-04 13:36:47'),
(135, 'add_invoices', 'invoices', '2022-08-04 13:36:47', '2022-08-04 13:36:47'),
(136, 'delete_invoices', 'invoices', '2022-08-04 13:36:47', '2022-08-04 13:36:47'),
(142, 'browse_stream_messages', 'stream_messages', '2023-06-21 09:18:56', '2023-06-21 09:18:56'),
(143, 'read_stream_messages', 'stream_messages', '2023-06-21 09:18:56', '2023-06-21 09:18:56'),
(144, 'edit_stream_messages', 'stream_messages', '2023-06-21 09:18:56', '2023-06-21 09:18:56'),
(145, 'add_stream_messages', 'stream_messages', '2023-06-21 09:18:56', '2023-06-21 09:18:56'),
(146, 'delete_stream_messages', 'stream_messages', '2023-06-21 09:18:56', '2023-06-21 09:18:56'),
(147, 'browse_streams', 'streams', '2023-06-21 09:31:44', '2023-06-21 09:31:44'),
(148, 'read_streams', 'streams', '2023-06-21 09:31:44', '2023-06-21 09:31:44'),
(149, 'edit_streams', 'streams', '2023-06-21 09:31:44', '2023-06-21 09:31:44'),
(150, 'add_streams', 'streams', '2023-06-21 09:31:44', '2023-06-21 09:31:44'),
(151, 'delete_streams', 'streams', '2023-06-21 09:31:44', '2023-06-21 09:31:44'),
(152, 'browse_referral_code_usages', 'referral_code_usages', '2023-06-21 10:56:01', '2023-06-21 10:56:01'),
(153, 'read_referral_code_usages', 'referral_code_usages', '2023-06-21 10:56:01', '2023-06-21 10:56:01'),
(154, 'edit_referral_code_usages', 'referral_code_usages', '2023-06-21 10:56:01', '2023-06-21 10:56:01'),
(155, 'add_referral_code_usages', 'referral_code_usages', '2023-06-21 10:56:01', '2023-06-21 10:56:01'),
(156, 'delete_referral_code_usages', 'referral_code_usages', '2023-06-21 10:56:01', '2023-06-21 10:56:01'),
(157, 'browse_rewards', 'rewards', '2023-06-21 10:56:04', '2023-06-21 10:56:04'),
(158, 'read_rewards', 'rewards', '2023-06-21 10:56:04', '2023-06-21 10:56:04'),
(159, 'edit_rewards', 'rewards', '2023-06-21 10:56:04', '2023-06-21 10:56:04'),
(160, 'add_rewards', 'rewards', '2023-06-21 10:56:04', '2023-06-21 10:56:04'),
(161, 'delete_rewards', 'rewards', '2023-06-21 10:56:04', '2023-06-21 10:56:04');

-- --------------------------------------------------------

--
-- Table structure for table `permission_role`
--

DROP TABLE IF EXISTS `permission_role`;
CREATE TABLE IF NOT EXISTS `permission_role` (
  `permission_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  PRIMARY KEY (`permission_id`,`role_id`),
  KEY `permission_role_permission_id_index` (`permission_id`),
  KEY `permission_role_role_id_index` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permission_role`
--

INSERT INTO `permission_role` (`permission_id`, `role_id`) VALUES
(1, 1),
(1, 3),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1),
(10, 1),
(11, 1),
(12, 1),
(13, 1),
(14, 1),
(15, 1),
(16, 1),
(16, 3),
(17, 1),
(17, 3),
(18, 1),
(19, 1),
(20, 1),
(21, 1),
(21, 3),
(22, 1),
(22, 3),
(23, 1),
(24, 1),
(25, 1),
(26, 1),
(27, 1),
(27, 3),
(28, 1),
(28, 3),
(29, 1),
(30, 1),
(31, 1),
(32, 1),
(33, 1),
(33, 3),
(34, 1),
(35, 1),
(36, 1),
(37, 1),
(37, 3),
(38, 1),
(38, 3),
(39, 1),
(40, 1),
(41, 1),
(42, 1),
(42, 3),
(43, 1),
(43, 3),
(44, 1),
(45, 1),
(46, 1),
(47, 1),
(47, 3),
(48, 1),
(48, 3),
(49, 1),
(50, 1),
(51, 1),
(52, 1),
(52, 3),
(53, 1),
(53, 3),
(54, 1),
(55, 1),
(56, 1),
(57, 1),
(57, 3),
(58, 1),
(58, 3),
(59, 1),
(60, 1),
(61, 1),
(62, 1),
(62, 3),
(63, 1),
(63, 3),
(64, 1),
(65, 1),
(66, 1),
(67, 1),
(67, 3),
(68, 1),
(68, 3),
(69, 1),
(70, 1),
(71, 1),
(72, 1),
(72, 3),
(73, 1),
(73, 3),
(74, 1),
(75, 1),
(76, 1),
(77, 1),
(77, 3),
(78, 1),
(78, 3),
(79, 1),
(80, 1),
(81, 1),
(82, 1),
(82, 3),
(83, 1),
(83, 3),
(84, 1),
(85, 1),
(86, 1),
(87, 1),
(87, 3),
(88, 1),
(88, 3),
(89, 1),
(90, 1),
(91, 1),
(92, 1),
(92, 3),
(93, 1),
(94, 1),
(95, 1),
(96, 1),
(97, 1),
(97, 3),
(98, 1),
(98, 3),
(99, 1),
(100, 1),
(101, 1),
(102, 1),
(102, 3),
(103, 1),
(103, 3),
(104, 1),
(105, 1),
(106, 1),
(107, 1),
(107, 3),
(108, 1),
(108, 3),
(109, 1),
(110, 1),
(111, 1),
(112, 1),
(112, 3),
(113, 1),
(113, 3),
(114, 1),
(115, 1),
(116, 1),
(117, 1),
(117, 3),
(118, 1),
(118, 3),
(119, 1),
(120, 1),
(121, 1),
(122, 1),
(122, 3),
(123, 1),
(124, 1),
(125, 1),
(126, 1),
(127, 1),
(127, 3),
(128, 1),
(129, 1),
(130, 1),
(131, 1),
(132, 1),
(132, 3),
(133, 1),
(133, 3),
(134, 1),
(135, 1),
(136, 1),
(142, 1),
(142, 3),
(143, 1),
(143, 3),
(144, 1),
(145, 1),
(146, 1),
(147, 1),
(147, 3),
(148, 1),
(148, 3),
(149, 1),
(150, 1),
(151, 1),
(152, 1),
(153, 1),
(154, 1),
(155, 1),
(156, 1),
(157, 1),
(158, 1),
(159, 1),
(160, 1),
(161, 1);

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
CREATE TABLE IF NOT EXISTS `posts` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `price` double(8,2) NOT NULL DEFAULT '0.00',
  `status` int NOT NULL DEFAULT '1',
  `release_date` timestamp NULL DEFAULT NULL,
  `expire_date` timestamp NULL DEFAULT NULL,
  `is_pinned` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `posts_user_id_foreign` (`user_id`),
  KEY `posts_status_index` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`id`, `user_id`, `text`, `price`, `status`, `release_date`, `expire_date`, `is_pinned`, `created_at`, `updated_at`) VALUES
(1, 3, 'Hi Check this', 2.00, 1, NULL, NULL, 0, '2024-07-05 07:36:41', '2024-07-05 07:37:09');

-- --------------------------------------------------------

--
-- Table structure for table `post_comments`
--

DROP TABLE IF EXISTS `post_comments`;
CREATE TABLE IF NOT EXISTS `post_comments` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `post_id` bigint UNSIGNED NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `post_comments_user_id_foreign` (`user_id`),
  KEY `post_comments_post_id_foreign` (`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `public_pages`
--

DROP TABLE IF EXISTS `public_pages`;
CREATE TABLE IF NOT EXISTS `public_pages` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `short_title` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `page_order` int UNSIGNED NOT NULL DEFAULT '0',
  `shown_in_footer` tinyint(1) DEFAULT NULL,
  `is_tos` tinyint(1) DEFAULT '0',
  `is_privacy` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `public_pages_slug_index` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `public_pages`
--

INSERT INTO `public_pages` (`id`, `slug`, `title`, `short_title`, `content`, `created_at`, `updated_at`, `page_order`, `shown_in_footer`, `is_tos`, `is_privacy`) VALUES
(3, 'terms-and-conditions', 'Terms and conditions', 'Terms', '<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Overview</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">This website is operated by Qdev Techs. Throughout the site, the terms &ldquo;we&rdquo;, &ldquo;us&rdquo; and &ldquo;our&rdquo; refer to Qdev Techs. Qdev Techs offers this website, including all information, tools and services available from this site to you, the user, conditioned upon your acceptance of all terms, conditions, policies and notices stated here.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">By visiting our site and/ or purchasing something from us, you engage in our &ldquo;Service&rdquo; and agree to be bound by the following terms and conditions (&ldquo;Terms of Service&rdquo;, &ldquo;Terms&rdquo;), including those additional terms and conditions and policies referenced herein and/or available by hyperlink. These Terms of Service apply&nbsp; to all users of the site, including without limitation users who are browsers, vendors, customers, merchants, and/ or contributors of content.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">Please read these Terms of Service carefully before accessing or using our website. By accessing or using any part of the site, you agree to be bound by these Terms of Service. If you do not agree to all the terms and conditions of this agreement, then you may not access the website or use any services. If these Terms of Service are considered an offer, acceptance is expressly limited to these Terms of Service.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">Any new features or tools which are added to the current store shall also be subject to the Terms of Service. You can review the most current version of the Terms of Service at any time on this page. We reserve the right to update, change or replace any part of these Terms of Service by posting updates and/or changes to our website. It is your responsibility to check this page periodically for changes. Your continued use of or access to the website following the posting of any changes constitutes acceptance of those changes.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Platform Terms</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">By agreeing to these Terms of Service, you represent that you are at least the age of majority in your state or province of residence, or that you are the age of majority in your state or province of residence and you have given us your consent to allow any of your minor dependents to use this site.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">You may not use our products for any illegal or unauthorized purpose nor may you, in the use of the Service, violate any laws in your jurisdiction (including but not limited to copyright laws).</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">You must not transmit any worms or viruses or any code of a destructive nature.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">A breach or violation of any of the Terms will result in an immediate termination of your Services.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">General Conditions</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">We reserve the right to refuse service to anyone for any reason at any time.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">You understand that your content (not including credit card information), may be transferred unencrypted and involve (a) transmissions over various networks; and (b) changes to conform and adapt to technical requirements of connecting networks or devices. Credit card information is always encrypted during transfer over networks.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">You agree not to reproduce, duplicate, copy, sell, resell or exploit any portion of the Service, use of the Service, or access to the Service or any contact on the website through which the service is provided, without express written permission by us.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">The headings used in this agreement are included for convenience only and will not limit or otherwise affect these Terms.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Accuracy, Completeness And Timeliness Of Information</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">We are not responsible if information made available on this site is not accurate, complete or current. The material on this site is provided for general information only and should not be relied upon or used as the sole basis for making decisions without consulting primary, more accurate, more complete or more timely sources of information. Any reliance on the material on this site is at your own risk.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">This site may contain certain historical information. Historical information, necessarily, is not current and is provided for your reference only. We reserve the right to modify the contents of this site at any time, but we have no obligation to update any information on our site. You agree that it is your responsibility to monitor changes to our site.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Modifications To The Service And Prices</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">Prices for our products are subject to change without notice.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">We reserve the right at any time to modify or discontinue the Service (or any part or content thereof) without notice at any time.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">We shall not be liable to you or to any third-party for any modification, price change, suspension or discontinuance of the Service.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\"><span style=\" font-family: Inter, -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, Helvetica Neue, Arial, Noto Sans, sans-serif, Apple Color Emoji, Segoe UI Emoji, Segoe UI Symbol, Noto Color Emoji;\"><span style=\"font-size: 24px; font-weight: 500;\">Products And Services</span></span></h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">Certain products or services may be available exclusively online through the website. These products or services may have limited quantities and are subject to return or exchange only according to our Return Policy.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">We have made every effort to display as accurately as possible the colors and images of our products that appear at the store. We cannot guarantee that your computer monitor\'s display of any color will be accurate.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">We reserve the right, but are not obligated, to limit the sales of our products or Services to any person, geographic region or jurisdiction. We may exercise this right on a case-by-case basis. We reserve the right to limit the quantities of any products or services that we offer. All descriptions of products or product pricing are subject to change at anytime without notice, at the sole discretion of our users. Users reserve the right to discontinue any product at any time. Any offer for any product or service made on this site is void where prohibited.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">We do not warrant that the quality of any products, services, information, or other material purchased or obtained by you will meet your expectations, or that any errors in the Service will be corrected.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\"><span style=\" font-family: Inter, -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, Helvetica Neue, Arial, Noto Sans, sans-serif, Apple Color Emoji, Segoe UI Emoji, Segoe UI Symbol, Noto Color Emoji;\"><span style=\"font-size: 24px; font-weight: 500;\">Accuracy Of Billing And Account Information</span></span></h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">We reserve the right to refuse any order you place with us. We may, in our sole discretion, limit or cancel quantities purchased per person, per household or per order. These restrictions may include orders placed by or under the same customer account, the same credit card, and/or orders that use the same billing and/or shipping address. In the event that we make a change to or cancel an order, we may attempt to notify you by contacting the e-mail and/or billing address/phone number provided at the time the order was made. We reserve the right to limit or prohibit orders that, in our sole judgment, appear to be placed by dealers, resellers or distributors.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">You agree to provide current, complete and accurate purchase and account information for all purchases made at our store.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">For more detail, please review our Returns Policy.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Optional Tools</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">We may provide you with access to third-party tools over which we neither monitor nor have any control nor input.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">You acknowledge and agree that we provide access to such tools &rdquo;as is&rdquo; and &ldquo;as available&rdquo; without any warranties, representations or conditions of any kind and without any endorsement. We shall have no liability whatsoever arising from or relating to your use of optional third-party tools.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">Any use by you of optional tools offered through the site is entirely at your own risk and discretion and you should ensure that you are familiar with and approve of the terms on which tools are provided by the relevant third-party provider(s).</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">We may also, in the future, offer new services and/or features through the website (including, the release of new tools and resources). Such new features and/or services shall also be subject to these Terms of Service.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Third-party Links</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">Certain content, products and services available via our Service may include materials from third-parties.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">Third-party links on this site may direct you to third-party websites that are not affiliated with us. We are not responsible for examining or evaluating the content or accuracy and we do not warrant and will not have any liability or responsibility for any third-party materials or websites, or for any other materials, products, or services of third-parties.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">We are not liable for any harm or damages related to the purchase or use of goods, services, resources, content, or any other transactions made in connection with any third-party websites. Please review carefully the third-party\'s policies and practices and make sure you understand them before you engage in any transaction. Complaints, claims, concerns, or questions regarding third-party products should be directed to the third-party.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">User Comments, Feedback And Other Submissions</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">If, at our request, you send certain specific submissions (for example contest entries) or without a request from us you send creative ideas, suggestions, proposals, plans, or other materials, whether online, by email, by postal mail, or otherwise (collectively, \'comments\'), you agree that we may, at any time, without restriction, edit, copy, publish, distribute, translate and otherwise use in any medium any comments that you forward to us. We are and shall be under no obligation (1) to maintain any comments in confidence; (2) to pay compensation for any comments; or (3) to respond to any comments.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">We may, but have no obligation to, monitor, edit or remove content that we determine in our sole discretion are unlawful, offensive, threatening, libelous, defamatory, pornographic, obscene or otherwise objectionable or violates any party&rsquo;s intellectual property or these Terms of Service.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">You agree that your comments will not violate any right of any third-party, including copyright, trademark, privacy, personality or other personal or proprietary right. You further agree that your comments will not contain libelous or otherwise unlawful, abusive or obscene material, or contain any computer virus or other malware that could in any way affect the operation of the Service or any related website. You may not use a false e-mail address, pretend to be someone other than yourself, or otherwise mislead us or third-parties as to the origin of any comments. You are solely responsible for any comments you make and their accuracy. We take no responsibility and assume no liability for any comments posted by you or any third-party.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">Your submission of personal information through the store is governed by our Privacy Policy. To view our Privacy Policy.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Errors, Inaccuracies And Omissions</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">Occasionally there may be information on our site or in the Service that contains typographical errors, inaccuracies or omissions that may relate to product descriptions, pricing, promotions, offers, product shipping charges, transit times and availability. We reserve the right to correct any errors, inaccuracies or omissions, and to change or update information or cancel orders if any information in the Service or on any related website is inaccurate at any time without prior notice (including after you have submitted your order).</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">We undertake no obligation to update, amend or clarify information in the Service or on any related website, including without limitation, pricing information, except as required by law. No specified update or refresh date applied in the Service or on any related website, should be taken to indicate that all information in the Service or on any related website has been modified or updated.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Prohibited Uses</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">In addition to other prohibitions as set forth in the Terms of Service, you are prohibited from using the site or its content: (a) for any unlawful purpose; (b) to solicit others to perform or participate in any unlawful acts; (c) to violate any international, federal, provincial or state regulations, rules, laws, or local ordinances; (d) to infringe upon or violate our intellectual property rights or the intellectual property rights of others; (e) to harass, abuse, insult, harm, defame, slander, disparage, intimidate, or discriminate based on gender, sexual orientation, religion, ethnicity, race, age, national origin, or disability; (f) to submit false or misleading information; (g) to upload or transmit viruses or any other type of malicious code that will or may be used in any way that will affect the functionality or operation of the Service or of any related website, other websites, or the Internet; (h) to collect or track the personal information of others; (i) to spam, phish, pharm, pretext, spider, crawl, or scrape; (j) for any obscene or immoral purpose; or (k) to interfere with or circumvent the security features of the Service or any related website, other websites, or the Internet. We reserve the right to terminate your use of the Service or any related website for violating any of the prohibited uses.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Disclaimer Of Warranties; Limitation Of Liability</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">We do not guarantee, represent or warrant that your use of our service will be uninterrupted, timely, secure or error-free.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">We do not warrant that the results that may be obtained from the use of the service will be accurate or reliable.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">You agree that from time to time we may remove the service for indefinite periods of time or cancel the service at any time, without notice to you.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">You expressly agree that your use of, or inability to use, the service is at your sole risk. The service and all products and services delivered to you through the service are (except as expressly stated by us) provided \'as is\' and \'as available\' for your use, without any representation, warranties or conditions of any kind, either express or implied, including all implied warranties or conditions of merchantability, merchantable quality, fitness for a particular purpose, durability, title, and non-infringement.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">In no case shall Qdev Techs, our directors, officers, employees, affiliates, agents, contractors, interns, suppliers, service providers or licensors be liable for any injury, loss, claim, or any direct, indirect, incidental, punitive, special, or consequential damages of any kind, including, without limitation lost profits, lost revenue, lost savings, loss of data, replacement costs, or any similar damages, whether based in contract, tort (including negligence), strict liability or otherwise, arising from your use of any of the service or any products procured using the service, or for any other claim related in any way to your use of the service or any product, including, but not limited to, any errors or omissions in any content, or any loss or damage of any kind incurred as a result of the use of the service or any content (or product) posted, transmitted, or otherwise made available via the service, even if advised of their possibility. Because some states or jurisdictions do not allow the exclusion or the limitation of liability for consequential or incidental damages, in such states or jurisdictions, our liability shall be limited to the maximum extent permitted by law.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Indemnification</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">You agree to indemnify, defend and hold harmless Qdev Techs and our parent, subsidiaries, affiliates, partners, officers, directors, agents, contractors, licensors, service providers, subcontractors, suppliers, interns and employees, harmless from any claim or demand, including reasonable attorneys&rsquo; fees, made by any third-party due to or arising out of your breach of these Terms of Service or the documents they incorporate by reference, or your violation of any law or the rights of a third-party.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Severability</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">In the event that any provision of these Terms of Service is determined to be unlawful, void or unenforceable, such provision shall nonetheless be enforceable to the fullest extent permitted by applicable law, and the unenforceable portion shall be deemed to be severed from these Terms of Service, such determination shall not affect the validity and enforceability of any other remaining provisions.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Termination</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">The obligations and liabilities of the parties incurred prior to the termination date shall survive the termination of this agreement for all purposes.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">These Terms of Service are effective unless and until terminated by either you or us. You may terminate these Terms of Service at any time by notifying us that you no longer wish to use our Services, or when you cease using our site.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">If in our sole judgment you fail, or we suspect that you have failed, to comply with any term or provision of these Terms of Service, we also may terminate this agreement at any time without notice and you will remain liable for all amounts due up to and including the date of termination; and/or accordingly may deny you access to our Services (or any part thereof).</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Entire Agreement</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">The failure of us to exercise or enforce any right or provision of these Terms of Service shall not constitute a waiver of such right or provision.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">These Terms of Service and any policies or operating rules posted by us on this site or in respect to The Service constitutes the entire agreement and understanding between you and us and govern your use of the Service, superseding any prior or contemporaneous agreements, communications and proposals, whether oral or written, between you and us (including, but not limited to, any prior versions of the Terms of Service).</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">Any ambiguities in the interpretation of these Terms of Service shall not be construed against the drafting party.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Governing Law</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">These Terms of Service and any separate agreements whereby we provide you Services shall be governed by and construed in accordance with the laws Prahova &ndash; Romania.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Changes To Terms Of Service</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">You can review the most current version of the Terms of Service at any time at this page.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">We reserve the right, at our sole discretion, to update, change or replace any part of these Terms of Service by posting updates and changes to our website. It is your responsibility to check our website periodically for changes. Your continued use of or access to our website or the Service following the posting of any changes to these Terms of Service constitutes acceptance of those changes.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Contact Information</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem;  font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">Questions about the Terms of Service should be sent to us over the <a href=\"../contact\">contact page</a>.</p>', '2021-09-30 06:37:35', '2021-09-30 06:37:35', 3, 1, 1, 0);
INSERT INTO `public_pages` (`id`, `slug`, `title`, `short_title`, `content`, `created_at`, `updated_at`, `page_order`, `shown_in_footer`, `is_tos`, `is_privacy`) VALUES
(4, 'privacy', 'Privacy Policy', 'Privacy', '<p class=\"MsoNormal\" style=\"margin-bottom: 0in; line-height: normal; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;\"><span style=\"font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">This Privacy Policy describes how your personal information is collected, used, and shared when you visit or make a purchase from https://your-domain.com (the &ldquo;Site&rdquo;). Continuing using this site means you agree to all of the mentions below.</span></p>\n<p class=\"MsoNormal\" style=\"margin-bottom: 0in; line-height: normal; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;\">&nbsp;</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Personal information we collect</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">When you visit the Site, we automatically collect certain information about your device, including information about your web browser, IP address, time zone, and some of the cookies that are installed on your device. Additionally, as you browse the Site, we collect information about the individual web pages or products that you view, what websites or search terms referred you to the Site, and information about how you interact with the Site. We refer to this automatically-collected information as &ldquo;Device Information.&rdquo;</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">We collect Device Information using the following technologies:</p>\n<ul style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">\n<li style=\"box-sizing: border-box;\">&ldquo;Cookies&rdquo; are data files that are placed on your device or computer and often include an anonymous unique identifier. For more information about cookies, and how to disable cookies, visit <a href=\"https://www.cookiesandyou.com/\" target=\"_blank\" rel=\"noopener\">cookiesandyou.com</a>.</li>\n<li style=\"box-sizing: border-box;\">&ldquo;Log files&rdquo; track actions occurring on the Site, and collect data including your IP address, browser type, Internet service provider, referring/exit pages, and date/time stamps.</li>\n</ul>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">The payments on our marketplace are made via Paypal, so we do not store any transactions related information, like credit card number, billing information etc. We do however store the Paypal transaction ID for easier reference in case of any disputes. We refer to this information as &ldquo;Order Information.&rdquo;</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">When we talk about &ldquo;Personal Information&rdquo; in this Privacy Policy, we are talking both about Device Information and Order Information.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">How do we use your personal information?</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">We use the Order Information that we collect generally to fulfill any orders placed through the Site). Additionally, we use this Order Information to:</p>\n<ul style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">\n<li style=\"box-sizing: border-box;\">Communicate with you;</li>\n<li style=\"box-sizing: border-box;\">Screen our orders for potential risk or fraud; and</li>\n<li style=\"box-sizing: border-box;\">When in line with the preferences you have shared with us, provide you with information or advertising relating to our products or services.</li>\n<li style=\"box-sizing: border-box;\">We use the Device Information that we collect to help us screen for potential risk and fraud (in particular, your IP address), and more generally to improve and optimize our Site (for example, by generating analytics about how our customers browse and interact with the Site, and to assess the success of our marketing and advertising campaigns).</li>\n</ul>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Sharing your personal information</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">We do not share your Personal Information with third parties.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">We use Google Analytics to help us understand how our customers use the Site. You can read more about how Google uses your Personal Information&nbsp;<a style=\"box-sizing: border-box; text-decoration-line: none; background-color: transparent;\" href=\"https://www.google.com/intl/en/policies/privacy/\" target=\"_blank\" rel=\"noopener\">Here</a>. You can also opt-out of Google Analytics&nbsp;<a style=\"box-sizing: border-box; text-decoration-line: none; background-color: transparent;\" href=\"https://tools.google.com/dlpage/gaoptout\" target=\"_blank\" rel=\"noopener\">Here</a>&nbsp;.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">Finally, we may also share&nbsp;<span style=\"box-sizing: border-box; font-weight: bolder;\">limited</span>&nbsp;Personal Information to comply with applicable laws and regulations, to respond to a subpoena, search warrant or other lawful request for information we receive, or to otherwise protect our rights.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Do not track</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">Please note that we do not alter our Site&rsquo;s data collection and use practices when we see a Do Not Track signal from your browser.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Your rights</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">If you are a European resident, you have the right to access personal information we hold about you and to ask that your personal information be corrected, updated, or deleted. If you would like to exercise this right, please contact us through the contact information below.</p>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">Additionally, if you are a European resident we note that we are processing your information in order to fulfill contracts we might have with you (for example if you make an order through the Site), or otherwise to pursue our legitimate business interests listed above.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Data retention</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">When you place an order through the Site, we will maintain your Order Information for our records unless and until you ask us to delete this information.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Minors</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">The Site is not intended for individuals under the age of 18.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Changes</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">We may update this privacy policy from time to time in order to reflect, for example, changes to our practices or for other operational, legal or regulatory reasons.</p>\n<h4 class=\"tosHeadLine\" style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 0.5rem; font-weight: 500; line-height: 1.2; font-size: 1.5rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\';\">Contact us</h4>\n<p style=\"box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 16px;\">For more information about our privacy practices, if you have questions, or if you would like to make a complaint, please contact us by e-mail at contact@website.com or by sending us a&nbsp;<a style=\"box-sizing: border-box; text-decoration-line: none; background-color: transparent;\" href=\"../contact\">contact message</a>.</p>', '2021-09-30 06:39:39', '2021-09-30 06:39:39', 2, 1, 0, 1),
(5, 'help', 'Help & FAQ', 'Help', '<p style=\"margin: 0px 0px 15px; padding: 0px; text-align: justify; font-family: \'Open Sans\', Arial, sans-serif;\"><strong style=\"box-sizing: border-box; font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; font-size: 16px; text-align: start;\">JustFans &ndash; Premium Content Creators SaaS</strong><span style=\"font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; font-size: 16px; text-align: start;\"> is a fully-featured PHP platform that allows you to start your own premium content-based social media platform in no time. It allows your users to post premium content, which can only be unlocked by other viewers when purchasing a monthly subscription. On top of that, creators can earn more money from tips and paid posts, on top of of the regular subscription content.<br></span><br style=\"box-sizing: border-box; font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; font-size: 16px; text-align: start;\"><span style=\"font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; font-size: 16px; text-align: start;\">The experience is powered by a mobile-first, clean and easy-to-use design, with De themes, RTL, and localization capabilities. It allows your creators to sell their premium content via monthly subscriptions, offers, bundles, tips, and pay to unlock posts.</span></p>\n<p style=\"text-align: start;\"><span style=\"font-family: Inter, -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, Helvetica Neue, Arial, Noto Sans, sans-serif, Apple Color Emoji, Segoe UI Emoji, Segoe UI Symbol, Noto Color Emoji;\"><span style=\"font-size: 24px; letter-spacing: -0.8px;\">Posting content</span></span></p>\n<p style=\"text-align: start;\"><span style=\"font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; font-size: 16px;\">In order to be able to start posting content and earn money, you will need to create an account, deppending on the platform settings you might have to verify it, then you will be able to create posts by accessing the <a href=\"http://localhost/only-fuck/public/admin/custom-pages/posts/create\">Create post</a> page, where you can upload any kind of media you want, by either drag and dropping your files onto the text area, or by clicking on the file icon bellow the text area.</span></p>\n<p style=\"text-align: start;\">&nbsp;</p>\n<p style=\"text-align: start;\"><span style=\"font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 24px; letter-spacing: -0.8px;\">Subscriptions</span></p>\n<p style=\"text-align: start;\"><span style=\"font-family: Helvetica Neue, Helvetica, Arial, sans-serif;\"><span style=\"font-size: 16px;\">Once you get an account rolling, you will be able to purchase user subscriptions, send tips and unlock posts with your PayPal account or a credit/debit card, via Stripe. Once you have valid subscription to a user, you will then also be able to chat with him via the live messenger. Subscriptions can be cancelled at any given time.<br></span></span></p>\n<p style=\"text-align: start;\">&nbsp;</p>\n<p><span style=\"font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 24px; letter-spacing: -0.8px;\">Taxes &amp; Rates</span></p>\n<p><span style=\"font-family: Helvetica Neue, Helvetica, Arial, sans-serif;\"><span style=\"font-size: 16px;\">Taxes can be set over the admin side by the site administrator. Generally, platform taxes can be set as an exclusive tax or custom set &amp; applied at withdrawal.&nbsp;</span></span></p>\n<p>&nbsp;</p>\n<p><span style=\"font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 24px; letter-spacing: -0.8px;\">Withdrawals&nbsp;</span></p>\n<p><span style=\"font-family: Helvetica Neue, Helvetica, Arial, sans-serif;\"><span style=\"font-size: 16px;\">Withdrawals can be requested by authors at any given time. We allow Paypal &amp; Bank Transfer and the transfer are manuall made by the administrator, as a two factor check.</span></span></p>\n<p>&nbsp;</p>\n<p><span style=\"font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 24px; letter-spacing: -0.8px;\">Reporting a user or a post</span></p>\n<p><span style=\"font-family: Helvetica Neue, Helvetica, Arial, sans-serif;\"><span style=\"font-size: 16px;\">In order to report a user or it\'s content, you can go to that user\'s profile or post, click on the three dots icon and select report. Our admins will analyze and take action&nbsp;accordingly. You can also block a certain user from seeing your profile or messaging you again.<br><br></span></span></p>\n<p><span style=\"font-family: Inter, -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, \'Noto Sans\', sans-serif, \'Apple Color Emoji\', \'Segoe UI Emoji\', \'Segoe UI Symbol\', \'Noto Color Emoji\'; font-size: 24px; letter-spacing: -0.8px;\">Got questions?</span></p>\n<p><span style=\"font-family: Helvetica Neue, Helvetica, Arial, sans-serif;\"><span style=\"font-size: 16px;\">If you have any questions whatsoever, do not heistate to send us a message via the <a href=\"http://localhost/only-fuck/public/admin/custom-pages/contact\">Contact Page</a>.</span></span></p>\n<p><span style=\"font-family: Helvetica Neue, Helvetica, Arial, sans-serif;\"><span style=\"font-size: 16px;\">&nbsp;</span></span></p>', '2021-09-30 06:40:09', '2023-11-27 17:39:52', 1, 1, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `reactions`
--

DROP TABLE IF EXISTS `reactions`;
CREATE TABLE IF NOT EXISTS `reactions` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `post_id` bigint UNSIGNED DEFAULT NULL,
  `post_comment_id` bigint UNSIGNED DEFAULT NULL,
  `reaction_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `reactions_user_id_post_id_unique` (`user_id`,`post_id`),
  UNIQUE KEY `reactions_user_id_post_comment_id_unique` (`user_id`,`post_comment_id`),
  KEY `reactions_post_id_foreign` (`post_id`),
  KEY `reactions_post_comment_id_foreign` (`post_comment_id`),
  KEY `reactions_reaction_type_index` (`reaction_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `referral_code_usages`
--

DROP TABLE IF EXISTS `referral_code_usages`;
CREATE TABLE IF NOT EXISTS `referral_code_usages` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `used_by` bigint UNSIGNED NOT NULL,
  `referral_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `referral_code_usages_used_by_index` (`used_by`),
  KEY `referral_code_usages_referral_code_index` (`referral_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rewards`
--

DROP TABLE IF EXISTS `rewards`;
CREATE TABLE IF NOT EXISTS `rewards` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `from_user_id` bigint UNSIGNED DEFAULT NULL,
  `to_user_id` bigint UNSIGNED DEFAULT NULL,
  `transaction_id` bigint UNSIGNED DEFAULT NULL,
  `referral_code_usage_id` bigint UNSIGNED DEFAULT NULL,
  `amount` double(8,2) DEFAULT NULL,
  `reward_type` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rewards_from_user_id_index` (`from_user_id`),
  KEY `rewards_to_user_id_index` (`to_user_id`),
  KEY `rewards_reward_type_index` (`reward_type`),
  KEY `rewards_transaction_id_index` (`transaction_id`),
  KEY `rewards_referral_code_usage_id_index` (`referral_code_usage_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_unique` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `display_name`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'Administrator', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(2, 'user', 'Normal User', '2021-08-07 13:22:09', '2021-08-07 13:22:09'),
(3, 'demo', 'Demo', '2021-11-22 10:25:03', '2021-11-22 10:25:03');

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
CREATE TABLE IF NOT EXISTS `settings` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `key` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `details` text COLLATE utf8mb4_unicode_ci,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order` int NOT NULL DEFAULT '1',
  `group` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `settings_key_unique` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=345 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `key`, `display_name`, `value`, `details`, `type`, `order`, `group`) VALUES
(1, 'site.name', 'Site name', 'Defence Student', '', 'text', 10, 'Site'),
(2, 'site.description', 'Site description', 'Site Description', '', 'text', 20, 'Site'),
(5, 'admin.bg_image', 'Admin Background Image', '', '', 'image', 5, 'Admin'),
(6, 'admin.title', 'Admin Title', 'DefenceStudent', '', 'text', 2, 'Admin'),
(7, 'admin.description', 'Admin Description', 'Welcome to DefenceStudent  Admin Panel. Log in to manage and customize your site!', '', 'text', 2, 'Admin'),
(8, 'admin.loader', 'Admin Loader', '', '', 'image', 3, 'Admin'),
(9, 'admin.icon_image', 'Admin Icon Image', '', '', 'image', 4, 'Admin'),
(12, 'feed.feed_posts_per_page', 'Posts per page', '3', NULL, 'text', 2, 'Feed'),
(15, 'feed.feed_suggestions_card_per_page', 'Suggestion box cards per page', '3', NULL, 'text', 90, 'Feed'),
(16, 'feed.feed_suggestions_total_cards', 'Suggestion box total cards', '3', NULL, 'text', 80, 'Feed'),
(30, 'media.ffprobe_path', 'FFProbe Path', NULL, '', 'text', 30, 'Media'),
(31, 'media.ffmpeg_path', 'FFMpeg Path', NULL, '', 'text', 20, 'Media'),
(32, 'media.allowed_file_extensions', 'Allowed file extensions', 'png,jpg,jpeg,wav,mp3,ogg,mp4,avi,mov,moov,m4v,mpeg,wmv,avi,asf', '{\n\"description\": \"If ffmpeg is not available, video formats will fallback to mp4 only.\"\n}', 'text', 70, 'Media'),
(33, 'media.max_file_upload_size', 'Max file uploads size', '9', '{\n\"description\":  \"File size in MB. Do not exceed PHP maximum upload size & post size as video uploads might silently fail.\"\n}', 'text', 110, 'Media'),
(34, 'websockets.pusher_app_key', 'Pusher App Key', NULL, NULL, 'text', 20, 'Websockets'),
(36, 'websockets.pusher_app_secret', 'Pusher App Secret', NULL, NULL, 'text', 30, 'Websockets'),
(37, 'websockets.pusher_app_cluster', 'Pusher Cluster Zone', NULL, NULL, 'text', 40, 'Websockets'),
(38, 'websockets.pusher_app_id', 'Pusher App ID', NULL, NULL, 'text', 10, 'Websockets'),
(39, 'payments.invoices_sender_name', 'Invoices Sender Name', 'Web Development for Digital Marketing Agency', NULL, 'text', 21, 'Payments'),
(40, 'payments.invoices_sender_country_name', 'Invoices Sender Country Name', 'Australia', NULL, 'text', 22, 'Payments'),
(41, 'payments.invoices_sender_street_address', 'Invoices Sender Street Address', '121 Kopkes Road', NULL, 'text', 23, 'Payments'),
(42, 'payments.invoices_sender_state_name', 'Invoices Sender State Name', 'Victoria', NULL, 'text', 24, 'Payments'),
(43, 'payments.invoices_sender_city_name', 'Invoices Sender City Name', '3351', NULL, 'text', 25, 'Payments'),
(44, 'payments.invoices_sender_postcode', 'Invoices Sender Postcode', 'PITFIELD', NULL, 'text', 26, 'Payments'),
(45, 'payments.invoices_sender_company_number', 'Invoices Sender Company Number', '(03) 5391 1216', NULL, 'text', 27, 'Payments'),
(46, 'payments.invoices_prefix', 'Invoices Prefix', 'OF', NULL, 'text', 28, 'Payments'),
(52, 'media.apply_watermark', 'Apply watermark', '0', '{\n\"on\" : \"On\",\n\"off\" : \"Off\",\n\"checked\" : true,\n\"description\": \"For images, GD library is required. For videos, either ffmpeg or coconut transcoders.\"\n}', 'checkbox', 120, 'Media'),
(53, 'media.watermark_image', 'Watermark image', '', NULL, 'file', 130, 'Media'),
(54, 'site.light_logo', 'Light site logo', '[{\"download_link\":\"settings\\\\July2024\\\\NpKPs2YR6YIZU4TlECV3.png\",\"original_name\":\"Defence-Student-logo.png\"}]', NULL, 'file', 40, 'Site'),
(55, 'site.dark_logo', 'Dark site logo', '', NULL, 'file', 50, 'Site'),
(56, 'site.favicon', 'Site favicon', '[{\"download_link\":\"settings\\\\July2024\\\\MbmbjQsk85cznfVKyvOM.jpg\",\"original_name\":\"cropped-Defence-Student-B16-scaled-1-32x32.jpg\"}]', NULL, 'file', 60, 'Site'),
(57, 'payments.stripe_public_key', 'Stripe Public Key', NULL, NULL, 'text', 37, 'Payments'),
(58, 'payments.stripe_secret_key', 'Stripe Secret Key', NULL, NULL, 'text', 38, 'Payments'),
(59, 'payments.stripe_webhooks_secret', 'Stripe Webhooks Secret', NULL, NULL, 'text', 39, 'Payments'),
(60, 'payments.paypal_client_id', 'Paypal Client Id', NULL, NULL, 'text', 40, 'Payments'),
(61, 'payments.paypal_secret', 'Paypal Secret', NULL, NULL, 'text', 41, 'Payments'),
(74, 'payments.paypal_live_mode', 'Paypal Live Mode', '1', '{\n\"true\" : \"On\",\n\"false\" : \"Off\",\n\"checked\" : true\n}', 'checkbox', 42, 'Payments'),
(78, 'emails.driver', 'Email driver', 'log', '{\n\"default\" : \"log\",\n\"options\" : {\n\"log\": \"Log\",\n\"sendmail\": \"Sendmail\",\n\"smtp\": \"SMTP\",\n\"mailgun\": \"Mailgun\"\n}\n}', 'select_dropdown', 43, 'Emails'),
(79, 'emails.from_name', 'Mail from name', NULL, NULL, 'text', 44, 'Emails'),
(80, 'emails.from_address', 'Mail from address', NULL, NULL, 'text', 45, 'Emails'),
(81, 'emails.mailgun_domain', 'Mailgun domain', NULL, NULL, 'text', 46, 'Emails'),
(82, 'emails.mailgun_secret', 'Mailgun secret', NULL, NULL, 'text', 47, 'Emails'),
(83, 'emails.smtp_host', 'SMTP Host', NULL, NULL, 'text', 49, 'Emails'),
(84, 'emails.smtp_port', 'SMTP Port', NULL, NULL, 'text', 50, 'Emails'),
(85, 'emails.smtp_encryption', 'SMTP Encryption', 'tls', '{\n\"default\" : \"tls\",\n\"options\" : {\n\"tls\": \"TLS\",\n\"ssl\": \"SSL\"\n}\n}', 'radio_btn', 51, 'Emails'),
(86, 'emails.smtp_username', 'SMTP Username', NULL, NULL, 'text', 52, 'Emails'),
(87, 'emails.smtp_password', 'SMTP Password', NULL, NULL, 'text', 53, 'Emails'),
(88, 'emails.mailgun_endpoint', 'Mailgun endpoint', NULL, NULL, 'text', 48, 'Emails'),
(95, 'storage.driver', 'Driver', 'public', '{\n\"default\" : \"public\",\n\"options\" : {\n\"public\": \"Local\",\n\"s3\": \"S3\",\n\"wasabi\": \"Wasabi\",\n\"do_spaces\": \"DigitalOcean Spaces\",\n\"minio\": \"Minio\",\n\"pushr\": \"Pushr\"\n}\n}', 'select_dropdown', 54, 'Storage'),
(96, 'storage.aws_access_key', 'Aws Access Key', NULL, NULL, 'text', 55, 'Storage'),
(97, 'storage.aws_secret_key', 'Aws Secret Key', NULL, NULL, 'text', 56, 'Storage'),
(98, 'storage.aws_region', 'Aws Region', NULL, NULL, 'text', 57, 'Storage'),
(99, 'storage.aws_bucket_name', 'Aws Bucket Name', NULL, NULL, 'text', 58, 'Storage'),
(100, 'storage.aws_cdn_enabled', 'Aws CloudFront Enabled', '0', '{\n\"true\" : \"On\",\n\"off\" : \"Off\",\n\"checked\" : false\n}', 'checkbox', 59, 'Storage'),
(101, 'storage.aws_cdn_presigned_urls_enabled', 'Aws CloudFront PreSigned Url\'s Enabled', '0', '{\n\"true\" : \"On\",\n\"false\" : \"Off\",\n\"checked\" : false\n}', 'checkbox', 61, 'Storage'),
(102, 'storage.aws_cdn_key_pair_id', 'Aws CloudFront Key Pair Id', NULL, NULL, 'text', 62, 'Storage'),
(103, 'storage.aws_cdn_private_key_path', 'Aws CloudFront Private Key Path', NULL, NULL, 'text', 63, 'Storage'),
(104, 'storage.cdn_domain_name', 'Aws CloudFront Domain Name', NULL, NULL, 'text', 60, 'Storage'),
(106, 'compliance.enable_cookies_box', 'Enable cookies box', '1', '{\n\"on\" : \"On\",\n\"off\" : \"Off\",\n\"checked\" : true\n}', 'checkbox', 1130, 'Compliance'),
(108, 'site.allow_theme_switch', 'Allow theme switch', '1', '{\n\"on\" : \"On\",\n\"off\" : \"Off\",\n\"checked\" : true,\n\"description\" : \"Allow users to switch between light and dark modes.\"\n}', 'checkbox', 70, 'Site'),
(109, 'site.default_user_theme', 'Default theme', 'light', '{\n\"default\" : \"light\",\n\"options\" : {\n\"light\": \"Light theme\",\n\"dark\": \"Dark theme\"\n}\n}', 'radio_btn', 80, 'Site'),
(110, 'site.allow_direction_switch', 'Allow direction switch', '1', '{\n\"on\" : \"On\",\n\"off\" : \"Off\",\n\"checked\" : true,\n\"description\": \"Allow users to switch site direction from ltr to rtl.\"\n}', 'checkbox', 90, 'Site'),
(111, 'site.default_site_direction', 'Default site direction', 'ltr', '{\n\"default\" : \"ltr\",\n\"options\" : {\n\"ltr\": \"Left to right\",\n\"rtl\": \"Right to left\"\n}\n}', 'radio_btn', 100, 'Site'),
(112, 'site.allow_language_switch', 'Allow language switch', '1', '{\n\"on\" : \"On\",\n\"off\" : \"Off\",\n\"checked\" : true,\n\"description\": \"Allow users to change site\'s language.\"\n}', 'checkbox', 110, 'Site'),
(113, 'site.default_site_language', 'Default site language', 'en', '{\n\"description\" : \"Language code. Must have a present language file in the resources/lang directory.\"\n}', 'text', 120, 'Site'),
(114, 'feed.disable_right_click', 'Disable right click on posts', '0', '{\n                    \"description\": \"If enabled, right click on posts media elements will be disabled, alongside view source shortcut.\"\n                }', 'checkbox', 6, 'Feed'),
(116, 'site.homepage_type', 'Homepage type', 'landing', '{\n\"default\" : \"landing\",\n\"options\" : {\n\"landing\": \"Landing page\",\n\"login\": \"Login page\"\n}\n}', 'radio_btn', 130, 'Site'),
(119, 'site.enforce_user_identity_checks', 'Enforce User Identity Check', '0', '{\n\"on\" : \"On\",\n\"off\" : \"Off\",\n\"checked\" : true,\n\"description\" : \"If enabled, users will only be able to post content & start streams if ID is verified.\"\n}', 'checkbox', 170, 'Site'),
(120, 'payments.currency_code', 'Site Currency Code', 'USD', '{\n                        \"description\": \"Mandatory for payment providers\"\n                    }', 'text', 66, 'Payments'),
(121, 'payments.currency_symbol', 'Site Currency Symbol', '$', '{\n                        \"description\": \"Can be a symbol or currency code and it`s shown everywhere in the website (if empty defaults to currency code)\"\n                    }', 'text', 67, 'Payments'),
(123, 'site.app_url', 'Site url', 'http://local.defencestudent.com', NULL, 'text', 1, 'Site'),
(124, 'site.allow_pwa_installs', 'Allow PWA Installs', '0', '{\n\"on\" : \"On\",\n\"off\" : \"Off\",\n\"checked\" : false,\n\"description\" : \"Turns the site into an installable PWA on all devices. Website must be server from a root domain.\"\n}', 'checkbox', 299, 'Site'),
(126, 'social-links.facebook_url', 'Facebook', '#', NULL, 'text', 80, 'Social links'),
(127, 'social-links.instagram_url', 'Instagram', '#', NULL, 'text', 81, 'Social links'),
(128, 'social-links.twitter_url', 'Twitter', '#', NULL, 'text', 82, 'Social links'),
(129, 'social-links.whatsapp_url', 'Whatsapp', NULL, NULL, 'text', 83, 'Social links'),
(130, 'social-links.tiktok_url', 'Tik Tok', '#', NULL, 'text', 84, 'Social links'),
(131, 'social-links.youtube_url', 'Youtube', NULL, NULL, 'text', 85, 'Social links'),
(138, 'payments.withdrawal_min_amount', 'Withdrawal request minimum amount', '20', '{\n\"description\": \"Default: 20\"\n}', 'text', 91, 'Payments'),
(139, 'payments.withdrawal_max_amount', 'Withdrawal request maximum amount', '500', '{\n\"description\": \"Default: 500\"\n}', 'text', 92, 'Payments'),
(140, 'payments.deposit_min_amount', 'Min deposit amount', '5', '{}', 'text', 93, 'Payments'),
(141, 'payments.deposit_max_amount', 'Max deposit amount', '500', '{}', 'text', 94, 'Payments'),
(142, 'media.enforce_mp4_conversion', 'Enforce mp4 videos re-conversion', '1', '{\n\"on\" : \"On\",\n\"off\" : \"Off\",\n\"checked\" : true,\n\"description\": \"Allows you skip mp4 re-conversion to platform standards, saving upload time and CPU usage. Recommended value: On.\"\n}', 'checkbox', 40, 'Media'),
(143, 'media.max_videos_length', 'Max videos length', '0', '{\n\"description\": \"Maximum videos length, specified in seconds. (0 = unlimited)\"\n}', 'text', 100, 'Media'),
(144, 'custom-code-ads.custom_css', 'Custom CSS Code', NULL, NULL, 'code_editor', 155, 'Custom Code / Ads'),
(145, 'custom-code-ads.custom_js', 'Custom JS Code', NULL, NULL, 'code_editor', 154, 'Custom Code / Ads'),
(146, 'feed.feed_suggestions_autoplay', 'Autoplay suggestions box slides', '0', '{\n\"on\" : \"On\",\n\"off\" : \"Off\",\n\"checked\" : true,\n}', 'checkbox', 70, 'Feed'),
(147, 'storage.was_access_key', 'Wasabi Access Key', NULL, NULL, 'text', 111, 'Storage'),
(148, 'storage.was_secret_key', 'Wasabi Secret Key', NULL, NULL, 'text', 112, 'Storage'),
(149, 'storage.was_region', 'Wasabi Region', NULL, NULL, 'text', 113, 'Storage'),
(150, 'storage.was_bucket_name', 'Wasabi Bucket', NULL, NULL, 'text', 114, 'Storage'),
(151, 'feed.allow_gallery_zoom', 'Allow post galleries Zoom in', '0', '{\n                    \"description\": \"If enabled, high-res photos will feature a zoom in/out option when previewing posts media.\"\n                }', 'checkbox', 7, 'Feed'),
(152, 'media.use_url_watermark', 'Use profile url watermark', '0', '{\n\"on\" : \"On\",\n\"off\" : \"Off\",\n\"checked\" : false,\n\"description\": \"* Not supported for coconut transcoder.\"\n}', 'checkbox', 140, 'Media'),
(153, 'custom-code-ads.sidebar_ad_spot', 'Sidebar Ad', NULL, '{\n    \"description\" : \"Will be shown on user feed & profiles, over the right sidebar.\"\n}', 'code_editor', 117, 'Custom Code / Ads'),
(154, 'site.hide_identity_checks', 'Hide identity checks menu', '0', '{\n\"on\" : \"On\",\n\"off\" : \"Off\",\n\"checked\" : false,\n\"description\" : \"If enabled, the users ID check module link will be hidden from the menus.\"\n}', 'checkbox', 180, 'Site'),
(155, 'feed.suggestions_skip_empty_profiles', 'Skip empty profiles out of the suggestions box', '0', '{\n\"on\" : \"On\",\n\"off\" : \"Off\",\n\"checked\" : false,\n\"description\" : \"If enabled, users will only get suggestions of profiles that have both avatar and cover filled in.\"\n}', 'checkbox', 40, 'Feed'),
(156, 'payments.coinbase_api_key', 'CoinBase Api Key', NULL, NULL, 'text', 35, 'Payments'),
(157, 'payments.coinbase_webhook_key', 'CoinBase Webhooks Secret', NULL, NULL, 'text', 36, 'Payments'),
(158, 'social-login.facebook_client_id', 'Facebook client ID', NULL, NULL, 'text', 70, 'Social login'),
(159, 'social-login.facebook_secret', 'Facebook client secret', NULL, NULL, 'text', 118, 'Social login'),
(160, 'social-login.twitter_client_id', 'Twitter client ID', NULL, NULL, 'text', 119, 'Social login'),
(161, 'social-login.twitter_secret', 'Twitter client secret', NULL, NULL, 'text', 120, 'Social login'),
(162, 'social-login.google_client_id', 'Google client ID', NULL, NULL, 'text', 121, 'Social login'),
(163, 'social-login.google_secret', 'Google client secret', NULL, NULL, 'text', 122, 'Social login'),
(164, 'site.slogan', 'Site slogan', NULL, NULL, 'text', 30, 'Site'),
(165, 'profiles.allow_profile_qr_code', 'Allow QR code generate on profiles', '0', '{\n\"on\" : \"On\",\n\"off\" : \"Off\",\n\"checked\" : false,\n\"description\" : \"If enabled, a button that allows generating and saving QR codes is shown.\"\n}', 'checkbox', 90, 'Profiles'),
(166, 'profiles.allow_gender_pronouns', 'Allow gender pronouns', '1', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : true,\n                        \"description\": \"If enabled, users will be able to enter custom pronouns which will be shown on profiles.\"\n                    }', 'checkbox', 80, 'Profiles'),
(167, 'site.redirect_page_after_register', 'Redirect page after register', 'feed', '\n                    {\n\"default\" : \"feed\",\n\"options\" : {\n\"feed\": \"Feed page\",\n\"settings\": \"User profile settings page\"\n}\n}', 'radio_btn', 150, 'Site'),
(168, 'payments.allow_manual_payments', 'Allow manual payments', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : true\n                    }', 'checkbox', 30, 'Payments'),
(169, 'media.use_chunked_uploads', 'Use chunked uploads', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"If enabled, file uploads will be split across multiple requests, allowing to bypass Cloudflare or max file limits.\"\n                    }', 'checkbox', 90, 'Media'),
(170, 'media.upload_chunk_size', 'Chunks size', '2', '{\n                        \"description\": \"File upload chunks size in MB. Can not exceed maximum server upload size.\"\n                    }', 'text', 80, 'Media'),
(171, 'site.enforce_email_validation', 'Enforce email validations', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"If enabled, all users will be disabled site access until they verified the email. If turned of, users will still receive a confirmation pop up in user settings.\"\n                    }', 'checkbox', 160, 'Site'),
(172, 'site.homepage_redirect', 'Homepage redirect', NULL, '{\n                        \"description\": \"If this setting is used, the `Homepage type` setting will not be used anymore.\"\n                    }', 'text', 140, 'Site'),
(173, 'media.users_covers_size', 'User cover images (re)size', '599x180', '{\n                        \"description\": \"Size to which the covers will be resized to. Increasing the resolution will give higher quality cover images, but bigger files. Make sure to use the same aspect ratio.\"\n                    }', 'text', 150, 'Media'),
(174, 'security.enable_2fa', 'Enable email 2FA on logins', '1', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : true,\n                        \"description\": \"If enabled, users which have 2FA enabled for their account, will be prompted with a security check when logging from new devices.\"\n                        }', 'checkbox', 85, 'Security'),
(175, 'security.default_2fa_on_register', 'Default 2FA setting on user register', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : true,\n                        \"description\": \"If enabled, users will have 2FA enabled by default, when creating new accounts.\"\n                        }', 'checkbox', 90, 'Security'),
(176, 'security.allow_users_2fa_switch', 'Allow users to turn off 2FA', '1', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : true,\n                        \"description\": \"If disabled, users won\'t be able to change their 2FA settings.\"\n                        }', 'checkbox', 95, 'Security'),
(177, 'profiles.default_profile_type_on_register', 'Default profile type on user register', 'paid', '{\n                            \"default\" : \"paid\",\n                            \"options\" : {\n                                \"paid\": \"Paid profile\",\n                                \"free\": \"Free profile\",\n                                \"open\": \"Open profile\"\n                            },\n                            \"description\": \"Paid = Subscription locked content, Free = Follow locked, Open = Content is available to un-registered users. PPV content is locked for all scenarios.\"\n                            }', 'radio_btn', 20, 'Profiles'),
(178, 'profiles.default_users_to_follow', 'Default users to follow on user register', NULL, '{\n                        \"description\": \"List of user-IDs to be followed by all users when registering, separated by a comma. If users are free, their content will be shown on the feed of new users.\"\n                        }', 'text', 36, 'Profiles'),
(179, 'storage.do_access_key', 'DO Access Key', NULL, NULL, 'text', 120, 'Storage'),
(180, 'storage.do_secret_key', 'DO Secret Key', NULL, NULL, 'text', 121, 'Storage'),
(181, 'storage.do_region', 'DO Region', NULL, NULL, 'text', 123, 'Storage'),
(183, 'storage.do_bucket_name', 'DO Bucket', NULL, NULL, 'text', 122, 'Storage'),
(184, 'payments.nowpayments_api_key', 'NowPayments Api Key', NULL, NULL, 'text', 33, 'Payments'),
(185, 'payments.nowpayments_ipn_secret_key', 'NowPayments IPN Secret Key', NULL, NULL, 'text', 34, 'Payments'),
(186, 'profiles.default_user_privacy_setting_on_register', 'Default user privacy setting on user register', 'public', '{\n                    \"default\" : \"public\",\n                    \"options\" : {\n                    \"public\": \"Public profile\",\n                    \"private\": \"Private profile\"\n                    },\n                    \"description\": \"If private, the profiles will be hidden from search results.\"\n                }', 'radio_btn', 30, 'Profiles'),
(187, 'payments.withdrawal_payment_methods', 'Withdrawal allowed payment methods', 'Bank transfer, Other', '{\n                            \"description\": \"Comma separated values (Bank transfer, Stripe, PayPal, Crypto, Other)\"\n                        }', 'text', 90, 'Payments'),
(188, 'security.enforce_app_ssl', 'Enforce platform SSL usage', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Usually not required, rarely, some hosting providers needs it.\"\n                        }', 'checkbox', 130, 'Security'),
(189, 'media.users_avatars_size', 'User avatar images (re)size', '96x96', '{\n                        \"description\": \"Size to which the avatars will be resized to. Increasing the resolution will give higher quality cover images, but bigger files. Make sure to use the same aspect ratio.\"\n                    }', 'text', 160, 'Media'),
(190, 'streams.allow_streams', 'Allow streams', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        }', 'checkbox', 163, 'Streams'),
(191, 'streams.max_live_duration', 'Max Live Stream Duration', '2', '{\n                            \"description\": \"Maximum time duration for a live stream set in hours\"\n                        }', 'text', 165, 'Streams'),
(192, 'streams.pushr_key', 'Pushr Key', NULL, NULL, 'text', 175, 'Streams'),
(193, 'streams.pushr_zone_id', 'Pushr Zone Id', NULL, NULL, 'text', 185, 'Streams'),
(194, 'streams.allow_dvr', 'Allow VOD', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Enabling VODs allow creators to watch their previous live streams (no extra fees when using Pushr provider)\"\n                        }', 'checkbox', 205, 'Streams'),
(195, 'streams.pushr_encoder', 'Pushr Encoder', NULL, '{\n                            \"description\": \"Pushr stream encoder. EG: `eu`\"\n                        }', 'text', 195, 'Streams'),
(196, 'streams.allow_mux', 'Allow MUX', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false\n                        }', 'checkbox', 215, 'Streams'),
(197, 'streams.allow_480p', 'Allow 480p', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false\n                        }', 'checkbox', 235, 'Streams'),
(198, 'streams.allow_360p', 'Allow 360p', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false\n                        }', 'checkbox', 225, 'Streams'),
(199, 'streams.allow_576p', 'Allow 576p', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false\n                        }', 'checkbox', 245, 'Streams'),
(200, 'streams.allow_720p', 'Allow 720p', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false\n                        }', 'checkbox', 255, 'Streams'),
(201, 'streams.allow_1080p', 'Allow 1080p', '1', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false\n                        }', 'checkbox', 265, 'Streams'),
(202, 'colors.theme_color_code', 'Theme color code', NULL, NULL, 'text', 210, 'Colors'),
(203, 'colors.theme_gradient_from', 'Theme gradient from', NULL, NULL, 'text', 220, 'Colors'),
(204, 'colors.theme_gradient_to', 'Theme gradient to', NULL, NULL, 'text', 230, 'Colors'),
(205, 'payments.default_subscription_price', 'Default subscription price', '5', NULL, 'text', 75, 'Payments'),
(206, 'payments.min_tip_value', 'Min tips value', '1', NULL, 'text', 85, 'Payments'),
(207, 'payments.max_tip_value', 'Max tips value', '500', NULL, 'text', 86, 'Payments'),
(208, 'media.ffmpeg_video_conversion_quality_preset', 'FFMpeg video conversion quality preset', 'balanced', '{\n\"description\" : \"Going for better quality will reduce the processing time but increase the file size, next to it\'s original size.\",\n\"default\" : \"size\",\n\"options\" : {\n\"size\": \"Size optimized\",\n\"balanced\": \"Balanced profile\",\n\"quality\": \"Quality optimized\"\n}\n}', 'radio_btn', 50, 'Media'),
(209, 'payments.offline_payments_owner', 'Account owner', NULL, NULL, 'text', 60, 'Payments'),
(210, 'payments.offline_payments_account_number', 'Account number', NULL, NULL, 'text', 80, 'Payments'),
(211, 'payments.offline_payments_bank_name', 'Bank name', NULL, NULL, 'text', 70, 'Payments'),
(212, 'payments.offline_payments_routing_number', 'Routing number', NULL, NULL, 'text', 90, 'Payments'),
(213, 'payments.offline_payments_iban', 'IBAN', NULL, '{\"description\" : \"If left empty, the bank transfer dialog, will be hidden, so custom providers can be used via \'Offline payments details box\'.\"}', 'text', 40, 'Payments'),
(214, 'payments.offline_payments_swift', 'BIC / SWIFT', NULL, NULL, 'text', 50, 'Payments'),
(215, 'payments.ccbill_account_number', 'CCBill Account Number', NULL, NULL, 'text', 28, 'Payments'),
(216, 'payments.ccbill_subaccount_number_recurring', 'CCBill SubAccount Number Recurring Payments', NULL, NULL, 'text', 29, 'Payments'),
(217, 'payments.ccbill_subaccount_number_one_time', 'CCBill SubAccount Number One Time Payments', NULL, NULL, 'text', 30, 'Payments'),
(218, 'payments.ccbill_flex_form_id', 'CCBill FlexForm Id', NULL, NULL, 'text', 31, 'Payments'),
(219, 'payments.ccbill_salt_key', 'CCBill Salt Key', NULL, NULL, 'text', 32, 'Payments'),
(220, 'compliance.enable_age_verification_dialog', 'Enable age verification dialog', '0', '{\n\"on\" : \"On\",\n\"off\" : \"Off\",\n\"checked\" : true,\n\"description\" \"Can be generally used for denying user access for minors, adult content info, etc.\"\n}', 'checkbox', 1140, 'Compliance'),
(221, 'compliance.age_verification_cancel_url', 'Age verification box cancel url', 'https://google.com', NULL, 'text', 1150, 'Compliance'),
(222, 'payments.maximum_subscription_price', 'Max subscription price', '500', NULL, 'text', 77, 'Payments'),
(223, 'payments.minimum_subscription_price', 'Min subscription price', '1', NULL, 'text', 76, 'Payments'),
(224, 'media.ffmpeg_audio_encoder', 'FFMPEG Audio encoder', 'aac', '{\n\"default\" : \"aac\",\n\"options\" : {\n\"aac\": \"AAC Encoder\",\n\"libfdk_aac\": \"libfdk_aac Encoder\",\n\"libmp3lame\": \"LAME MP3 Encoder\"\n},\n\"description\": \"AAC is recommended\"\n}', 'select_dropdown', 60, 'Media'),
(225, 'security.recaptcha_enabled', 'Enable Google reCAPTCHA', '0', '{\n                        \"description\": \"If enabled, it will be shown the public user registration page.\"\n                    }', 'checkbox', 1200, 'Security'),
(226, 'security.recaptcha_site_key', 'reCAPTCHA Site Key', NULL, NULL, 'text', 1210, 'Security'),
(227, 'security.recaptcha_site_secret_key', 'reCAPTCHA Secret Key', NULL, NULL, 'text', 1220, 'Security'),
(229, 'feed.min_post_description', 'Minimum post description length', '10', '{\n\"description\": \"If set to 0/empty, at least one post attachment is required. Otherwise, attachments are optional.\"\n}', 'text', 3, 'Feed'),
(230, 'media.max_avatar_cover_file_size', 'Max avatar & cover file size', '4', '{\n\"description\": \"File size in MB. Used for both avatar & cover\"\n}', 'text', 170, 'Media'),
(231, 'security.allow_geo_blocking', 'Allow users to be able to geoblock their profiles', '0', '{\n\"on\" : \"On\",\n\"off\" : \"Off\",\n\"checked\" : false,\n\"description\": \"If enabled, users will be able to disallow certain countries to access their content.\"\n}', 'checkbox', 80, 'Security'),
(232, 'security.abstract_api_key', 'IP geolocation API key (Abstract API)', NULL, NULL, 'text', 81, 'Security'),
(233, 'social-links.telegram_link', 'Telegram', NULL, NULL, 'text', 86, 'Social links'),
(234, 'payments.ccbill_datalink_username', 'CCBill DataLink Username', NULL, '{\n                            \"description\": \"Used for cancelling CCBill subscriptions programmatically. Enables users cancelling their CCBill subscriptions from their profile\"\n                        }', 'text', 33, 'Payments'),
(235, 'payments.ccbill_datalink_password', 'CCBill DataLink Password', NULL, NULL, 'text', 34, 'Payments'),
(236, 'payments.ccbill_checkout_disabled', 'Disable for checkout', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Won`t be shown on checkout, but it`s still available for deposits.\"\n                        }', 'checkbox', 36, 'Payments'),
(237, 'payments.ccbill_recurring_disabled', 'Disable for recurring payments', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Won`t be available for subscription payments, but it`s still available for deposits and one time payments.\"\n                        }', 'checkbox', 36, 'Payments'),
(238, 'payments.stripe_checkout_disabled', 'Disable for checkout', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Won`t be shown on checkout, but it`s still available for deposits.\"\n                        }', 'checkbox', 40, 'Payments'),
(239, 'payments.stripe_recurring_disabled', 'Disable for recurring payments', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Won`t be available for subscription payments, but it`s still available for deposits and one time payments.\"\n                        }', 'checkbox', 42, 'Payments'),
(240, 'payments.paypal_checkout_disabled', 'Disable for checkout', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Won`t be shown on checkout, but it`s still available for deposits.\"\n                        }', 'checkbox', 44, 'Payments'),
(241, 'payments.paypal_recurring_disabled', 'Disable for recurring payments', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Won`t be available for subscription payments, but it`s still available for deposits and one time payments.\"\n                        }', 'checkbox', 46, 'Payments'),
(242, 'payments.nowpayments_checkout_disabled', 'Disable for checkout', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Won`t be shown on checkout, but it`s still available for deposits.\"\n                        }', 'checkbox', 36, 'Payments'),
(243, 'payments.coinbase_checkout_disabled', 'Disable for checkout', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Won`t be shown on checkout, but it`s still available for deposits.\"\n                        }', 'checkbox', 38, 'Payments'),
(244, 'profiles.allow_users_enabling_open_profiles', 'Allow users making their profiles open', '0', '{\n                        \"true\" : \"Off\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"If enabled, users will be able to make their profiles open so anyone can their (non PPV) content.\"\n                    }', 'checkbox', 10, 'Profiles'),
(245, 'payments.paystack_secret_key', 'Paystack Secret Key', NULL, NULL, 'text', 28, 'Payments'),
(246, 'payments.paystack_checkout_disabled', 'Disable for checkout', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Won`t be shown on checkout, but it`s still available for deposits.\"\n                        }', 'checkbox', 44, 'Payments'),
(247, 'license.product_license_key', 'Product license key', '124b192e-1f3a-43ec-b380-00d92e59470d', '{\n                        \"description\": \"Your product license key. Can be taken out of your Codecanyon downloads page.\"\n                        }', 'text', 10, 'License'),
(248, 'payments.withdrawal_default_fee_percentage', 'Withdrawal fee percentage', '0', NULL, 'text', 96, 'Payments'),
(249, 'payments.withdrawal_allow_fees', 'Enable withdrawal fee', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Will enable admins to add a default fee percentage which will automatically apply to each withdrawal request.\"\n                        }', 'checkbox', 94, 'Payments'),
(250, 'payments.withdrawal_allow_only_for_verified', 'Enable only for verified creators', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Will enable withdrawal section into creators wallet only if they verified their identity.\"\n                        }', 'checkbox', 98, 'Payments'),
(251, 'storage.minio_access_key', 'Minio Access Key', NULL, NULL, 'text', 130, 'Storage'),
(252, 'storage.minio_secret_key', 'Minio Secret Key', NULL, NULL, 'text', 140, 'Storage'),
(253, 'storage.minio_region', 'Minio Region', NULL, NULL, 'text', 150, 'Storage'),
(254, 'storage.minio_bucket_name', 'Minio Bucket', NULL, NULL, 'text', 160, 'Storage'),
(255, 'storage.minio_endpoint', 'Minio Endpoint', NULL, NULL, 'text', 170, 'Storage'),
(256, 'referrals.enabled', 'Enable referral system', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        }', 'checkbox', 1245, 'Referrals'),
(257, 'referrals.fee_percentage', 'Referrals earning fee percentage', '5', '{\n                        \"description\": \"Payout percentage given to users from their referred people total earnings. If set to 0, referred users will generate no income.\"\n                    }', 'text', 1260, 'Referrals'),
(258, 'referrals.apply_for_months', 'Referrals months limit', '12', '{\n                        \"description\": \"Represents the number of months since users created their accounts so people who referred them earn a fee from their total earnings.\"\n                    }', 'text', 1265, 'Referrals'),
(259, 'referrals.fee_limit', 'Referrals fee limit', '1000', '{\n                        \"description\": \"Allows users to earn up to the specified limit per referred user.\"\n                    }', 'text', 1270, 'Referrals'),
(260, 'profiles.default_wallet_balance_on_register', 'Default wallet balance on user register', '0', '{\n                        \"description\" : \"Default wallet balance to be credited to new users.\"\n                    }\n                    ', 'text', 33, 'Profiles'),
(261, 'feed.suggestions_skip_unverified_profiles', 'Skip unverified profiles out of the suggestions box', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        }', 'checkbox', 50, 'Feed'),
(262, 'feed.suggestions_use_featured_users_list', 'Use featured users for the suggestions box', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        }', 'checkbox', 60, 'Feed'),
(263, 'referrals.referrals_default_link_page', 'Default referrals link page', 'profile', '{\n\"default\" : \"profile\",\n\"options\" : {\n\"profile\": \"User profile page\",\n\"register\": \"Register page\",\n\"home\": \"Homepage\"\n},\n\"description\": \"The default page for which the referral link will be created for.\"\n}', 'radio_btn', 1275, 'Referrals'),
(264, 'profiles.allow_profile_bio_markdown', 'Allow users to use markdown in profile description', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : true,\n                        \"description\": \"If enabled, users will be able to use markdown in their profile bios.\"\n                    }', 'checkbox', 40, 'Profiles'),
(265, 'profiles.allow_profile_bio_markdown_links', 'Allow hyperlinks in the markdown formatting', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : true,\n                        \"description\": \"If enabled, users will be able to post links within their descriptions.\"\n                    }', 'checkbox', 50, 'Profiles'),
(266, 'profiles.disable_profile_bio_excerpt', 'Disable profile\'s bio field excerpt', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : true,\n                        \"description\": \"If set to On, the bio will be auto-expanded and show more/less labels will be hidden.\"\n                    }', 'checkbox', 60, 'Profiles'),
(267, 'profiles.max_profile_bio_length', 'Maximum profile bio characters length', '1500', '{\n                        \"description\": \"Max profile bio length. If set to 0, no limit will be set.\"\n                    }', 'text', 70, 'Profiles'),
(268, 'websockets.driver', 'Websockets driver', 'pusher', '{\n\"default\" : \"pusher\",\n\"options\" : {\n\"pusher\": \"Pusher\",\n\"soketi\": \"Soketi\"\n}\n}', 'select_dropdown', 10, 'Websockets'),
(269, 'websockets.soketi_host_address', 'Soketi Host Address', NULL, NULL, 'text', 10, 'Websockets'),
(270, 'websockets.soketi_host_port', 'Soketi Host Port', NULL, NULL, 'text', 20, 'Websockets'),
(271, 'websockets.soketi_app_id', 'Soketi App ID', NULL, NULL, 'text', 30, 'Websockets'),
(272, 'websockets.soketi_app_key', 'Soketi App Key', NULL, NULL, 'text', 40, 'Websockets'),
(273, 'websockets.soketi_app_secret', 'Soketi App Secret', NULL, NULL, 'text', 50, 'Websockets'),
(274, 'websockets.soketi_use_TSL', 'Use TSL for Soketi', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false\n                    }', 'checkbox', 60, 'Websockets'),
(275, 'compliance.admin_approved_posts_limit', 'Admin pre-approved posts limit', '0', '\n                        {\n\"description\" : \"The number of posts that needs admin approval. After this number of posts has been reached, the creator can post freely (value = 0 means no limit).\"\n}', 'text', 1180, 'Compliance'),
(276, 'compliance.minimum_posts_until_creator', 'Required number of posts to be able to receive payments', '0', '{\n                        \"description\": \"Set a minimum number of posts for users to be able to earn money. Users won`t be able to receive money until they reach this limit (value = 0 means no limit).\"\n                        }', 'text', 1170, 'Compliance'),
(277, 'compliance.minimum_posts_deletion_limit', 'Deletion minimum posts limit', '0', '{\n                        \"description\": \"Set a minimum posts deletion limit for creators. Enforce them to have a minimum number of posts on their accounts (value = 0 means no limit).\"\n                        }', 'text', 1190, 'Compliance'),
(278, 'compliance.monthly_posts_before_inactive', 'Monthly posts required to keep account active', '0', '\n                        {\n\"description\" : \"The minimum monthly posts number a creator must publish before having his account marked as inactive. If value = 0, no inactivity rule will be applied.\"\n}', 'text', 1170, 'Compliance'),
(279, 'compliance.disable_creators_ppv_delete', 'Disable creators ability to delete purchased PPV content', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : true,\n                        \"description\": \"If enabled, creators won\'t be able to delete paid PPV content (paid posts/messages) if already paid by a customer.\"\n                    }', 'checkbox', 1190, 'Compliance'),
(280, 'payments.stripe_oxxo_provider_enabled', 'Allow OXXO', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Allow OXXO payment provider through Stripe. This will be shown as different option in checkout\"\n                        }', 'checkbox', 100, 'Payments'),
(283, 'social-links.reddit_url', 'Reddit', NULL, NULL, 'text', 90, 'Social links'),
(285, 'admin.send_notifications_on_contact', 'Admin notifications for contact messages', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"If enabled, the admin users will receive an email with the contents of the contact message.\"\n                        }', 'checkbox', 6, 'Admin'),
(286, 'site.hide_create_post_menu', 'Hide create post menu', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"If enabled, the create post module link will be hidden from the menus. Useful if running the site on one-creator mode.\"\n                        }', 'checkbox', 185, 'Site'),
(287, 'feed.hide_suggestions_slider', 'Hide the users suggestion box', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"If enabled, the users suggestion slider will be hidden from the feed page.\"\n                        }', 'checkbox', 35, 'Feed'),
(288, 'site.default_og_image', 'Default site og:image', '', '{\"description\" : \"The image to be used when sharing the site over social media sites.\"}', 'file', 65, 'Site'),
(289, 'profiles.enable_new_post_notification_setting', 'Enable new post notification setting', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : true,\n                        \"description\": \"If enabled, subscribers will be allowed to manage their (new) posts email notifications, while creators can choose to notify them or not, when creating new posts.\"\n                    }', 'checkbox', 100, 'Profiles'),
(290, 'profiles.default_new_post_notification_setting', 'Default new post notification setting on user register', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : true,\n                        \"description\": \"The default value for whether the user should receive emails when new content has been posted.\"\n                    }', 'checkbox', 110, 'Profiles'),
(291, 'security.enforce_email_valid_check', 'Enforce email deliverability check on register', '0', '{\n\"on\" : \"On\",\n\"off\" : \"Off\",\n\"checked\" : false,\n\"description\": \"If enabled, the emails used for signing up, are checked to see if they\'re valid ones.\"\n}', 'checkbox', 83, 'Security'),
(292, 'security.email_abstract_api_key', 'Email Validation API key (Abstract API)', NULL, NULL, 'text', 84, 'Security'),
(293, 'ai.open_ai_enabled', 'OpenAI Enabled', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Allow creators to use OpenAI to suggest a post or a profile description\"\n                        }', 'checkbox', 10, 'AI'),
(294, 'ai.open_ai_api_key', 'OpenAI Api Key', NULL, NULL, 'text', 20, 'AI'),
(295, 'ai.open_ai_completion_max_tokens', 'OpenAI Max Tokens', '100', '{\n                        \"description\": \"Dictates how long the suggestion should be. E.g. 1000 tokens is about 750 words. (shouldn`t exceed 2048 tokens)\"\n                    }', 'text', 30, 'AI'),
(296, 'ai.open_ai_completion_temperature', 'OpenAI Temperature', '1', '{\n                        \"description\": \"What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic.\"\n                    }', 'text', 40, 'AI'),
(297, 'feed.post_box_max_height', 'Post box max media height', NULL, '{\"description\" : \"Pixel value of maximum posts media height. EG: 450. If value is present, images and videos within post boxes will be cropped/adjusted to that max value when not in full screen.\"}', 'text', 4, 'Feed'),
(298, 'feed.allow_post_scheduling', 'Allow post scheduling', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Having this set to ON, will allow users to create posts with release & expiry dates.\"\n                        }', 'checkbox', 5, 'Feed'),
(299, 'payments.ccbill_skip_subaccount_from_cancellations', 'CCBill skip subaccount from cancellations', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Only use this if CCBill instructed you to do so. This is only required for rare CCBill accounts, users were required to skip providing their sub account during cancellation requests.\"\n                        }', 'checkbox', 35, 'Payments'),
(300, 'referrals.disable_for_non_verified', 'Disable referral system for non ID-checked users', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\" : \"If this option is enabled, the referral system will only be available to ID-verified users.\"\n                        }', 'checkbox', 1250, 'Referrals'),
(301, 'profiles.hide_non_verified_users_from_search', 'Hide non ID-verified users from the search page', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\" : \"If this option is enabled, non ID-verified users will not be shown on the search page.\"\n                        }', 'checkbox', 120, 'Profiles'),
(302, 'profiles.disable_website_link_on_profile', 'Disable website link from profile pages', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\" : \"If this option is enabled, website links won\'t be shown in the profile section.\"\n                        }', 'checkbox', 130, 'Profiles'),
(303, 'feed.enable_post_description_excerpts', 'Enable post description excerpts', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\" : \"If this option is enabled, a \'Show more\' label is shown for posts with descriptions larger than a line.\"\n                        }', 'checkbox', 5, 'Feed'),
(304, 'referrals.auto_follow_the_user', 'Auto-follow the user that have referred the newly register account', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\" : \"If this option is enabled, the newly created accounts will auto-follow the user that have referred them.\"\n                        }', 'checkbox', 1255, 'Referrals'),
(305, 'site.use_browser_language_if_available', 'Use preferred browser locale, if available', '1', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\" : \"If this option is enabled, if the user browser locale is available as a language, that will be used by default.\"\n                    }', 'checkbox', 125, 'Site'),
(306, 'storage.pushr_access_key', 'Pushr Access Key', NULL, NULL, 'text', 130, 'Storage'),
(307, 'storage.pushr_secret_key', 'Pushr Secret Key', NULL, NULL, 'text', 140, 'Storage'),
(308, 'storage.pushr_cdn_hostname', 'Pushr CDN Hostname', NULL, '{\n                        \"description\" : \"This field must contain the https:// prefix.\"\n                        }', 'text', 180, 'Storage'),
(309, 'storage.pushr_bucket_name', 'Pushr Bucket', NULL, NULL, 'text', 160, 'Storage'),
(310, 'storage.pushr_endpoint', 'Pushr S3 Endpoint', NULL, NULL, 'text', 170, 'Storage');
INSERT INTO `settings` (`id`, `key`, `display_name`, `value`, `details`, `type`, `order`, `group`) VALUES
(311, 'payments.offline_payments_custom_message_box', 'Offline payments details box', NULL, '{\"description\":\"This field can be used to add a custom info box, where users can be informed on any alternative offline payments you may accept.\"}', 'code_editor', 100, 'Payments'),
(312, 'payments.offline_payments_make_notes_field_mandatory', 'Make the notes field mandatory', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false\n                        }', 'checkbox', 110, 'Payments'),
(313, 'payments.offline_payments_minimum_attachments_required', 'Minimum file attachments required', '1', NULL, 'text', 120, 'Payments'),
(314, 'payments.currency_position', 'Currency position', 'left', '{\n                        \"default\" : \"left\",\n                        \"options\" : {\n                            \"right\": \"Right (99.99$)\",\n                            \"left\": \"Left ($99.99)\"\n                        },\n                        \"description\": \"Dictates if currency position should be left or right aligned besides amount across the website\"\n                    }', 'select_dropdown', 68, 'Payments'),
(315, 'site.timezone', 'Site Timezone ', 'UTC', '{\n                        \"default\" : \"UTC\",\n                        \"options\" : {\n   \"UTC\": \"UTC\",\n    \"Africa/Abidjan\": \"Africa/Abidjan\",\n    \"Africa/Accra\": \"Africa/Accra\",\n    \"Africa/Addis_Ababa\": \"Africa/Addis_Ababa\",\n    \"Africa/Algiers\": \"Africa/Algiers\",\n    \"Africa/Asmara\": \"Africa/Asmara\",\n    \"Africa/Bamako\": \"Africa/Bamako\",\n    \"Africa/Bangui\": \"Africa/Bangui\",\n    \"Africa/Banjul\": \"Africa/Banjul\",\n    \"Africa/Bissau\": \"Africa/Bissau\",\n    \"Africa/Blantyre\": \"Africa/Blantyre\",\n    \"Africa/Brazzaville\": \"Africa/Brazzaville\",\n    \"Africa/Bujumbura\": \"Africa/Bujumbura\",\n    \"Africa/Cairo\": \"Africa/Cairo\",\n    \"Africa/Casablanca\": \"Africa/Casablanca\",\n    \"Africa/Ceuta\": \"Africa/Ceuta\",\n    \"Africa/Conakry\": \"Africa/Conakry\",\n    \"Africa/Dakar\": \"Africa/Dakar\",\n    \"Africa/Dar_es_Salaam\": \"Africa/Dar_es_Salaam\",\n    \"Africa/Djibouti\": \"Africa/Djibouti\",\n    \"Africa/Douala\": \"Africa/Douala\",\n    \"Africa/El_Aaiun\": \"Africa/El_Aaiun\",\n    \"Africa/Freetown\": \"Africa/Freetown\",\n    \"Africa/Gaborone\": \"Africa/Gaborone\",\n    \"Africa/Harare\": \"Africa/Harare\",\n    \"Africa/Johannesburg\": \"Africa/Johannesburg\",\n    \"Africa/Juba\": \"Africa/Juba\",\n    \"Africa/Kampala\": \"Africa/Kampala\",\n    \"Africa/Khartoum\": \"Africa/Khartoum\",\n    \"Africa/Kigali\": \"Africa/Kigali\",\n    \"Africa/Kinshasa\": \"Africa/Kinshasa\",\n    \"Africa/Lagos\": \"Africa/Lagos\",\n    \"Africa/Libreville\": \"Africa/Libreville\",\n    \"Africa/Lome\": \"Africa/Lome\",\n    \"Africa/Luanda\": \"Africa/Luanda\",\n    \"Africa/Lubumbashi\": \"Africa/Lubumbashi\",\n    \"Africa/Lusaka\": \"Africa/Lusaka\",\n    \"Africa/Malabo\": \"Africa/Malabo\",\n    \"Africa/Maputo\": \"Africa/Maputo\",\n    \"Africa/Maseru\": \"Africa/Maseru\",\n    \"Africa/Mbabane\": \"Africa/Mbabane\",\n    \"Africa/Mogadishu\": \"Africa/Mogadishu\",\n    \"Africa/Monrovia\": \"Africa/Monrovia\",\n    \"Africa/Nairobi\": \"Africa/Nairobi\",\n    \"Africa/Ndjamena\": \"Africa/Ndjamena\",\n    \"Africa/Niamey\": \"Africa/Niamey\",\n    \"Africa/Nouakchott\": \"Africa/Nouakchott\",\n    \"Africa/Ouagadougou\": \"Africa/Ouagadougou\",\n    \"Africa/Porto-Novo\": \"Africa/Porto-Novo\",\n    \"Africa/Sao_Tome\": \"Africa/Sao_Tome\",\n    \"Africa/Tripoli\": \"Africa/Tripoli\",\n    \"Africa/Tunis\": \"Africa/Tunis\",\n    \"Africa/Windhoek\": \"Africa/Windhoek\",\n    \"America/Adak\": \"America/Adak\",\n    \"America/Anchorage\": \"America/Anchorage\",\n    \"America/Anguilla\": \"America/Anguilla\",\n    \"America/Antigua\": \"America/Antigua\",\n    \"America/Araguaina\": \"America/Araguaina\",\n    \"America/Argentina/Buenos_Aires\": \"America/Argentina/Buenos_Aires\",\n    \"America/Argentina/Catamarca\": \"America/Argentina/Catamarca\",\n    \"America/Argentina/Cordoba\": \"America/Argentina/Cordoba\",\n    \"America/Argentina/Jujuy\": \"America/Argentina/Jujuy\",\n    \"America/Argentina/La_Rioja\": \"America/Argentina/La_Rioja\",\n    \"America/Argentina/Mendoza\": \"America/Argentina/Mendoza\",\n    \"America/Argentina/Rio_Gallegos\": \"America/Argentina/Rio_Gallegos\",\n    \"America/Argentina/Salta\": \"America/Argentina/Salta\",\n    \"America/Argentina/San_Juan\": \"America/Argentina/San_Juan\",\n    \"America/Argentina/San_Luis\": \"America/Argentina/San_Luis\",\n    \"America/Argentina/Tucuman\": \"America/Argentina/Tucuman\",\n    \"America/Argentina/Ushuaia\": \"America/Argentina/Ushuaia\",\n    \"America/Aruba\": \"America/Aruba\",\n    \"America/Asuncion\": \"America/Asuncion\",\n    \"America/Atikokan\": \"America/Atikokan\",\n    \"America/Bahia\": \"America/Bahia\",\n    \"America/Bahia_Banderas\": \"America/Bahia_Banderas\",\n    \"America/Barbados\": \"America/Barbados\",\n    \"America/Belem\": \"America/Belem\",\n    \"America/Belize\": \"America/Belize\",\n    \"America/Blanc-Sablon\": \"America/Blanc-Sablon\",\n    \"America/Boa_Vista\": \"America/Boa_Vista\",\n    \"America/Bogota\": \"America/Bogota\",\n    \"America/Boise\": \"America/Boise\",\n    \"America/Cambridge_Bay\": \"America/Cambridge_Bay\",\n    \"America/Campo_Grande\": \"America/Campo_Grande\",\n    \"America/Cancun\": \"America/Cancun\",\n    \"America/Caracas\": \"America/Caracas\",\n    \"America/Cayenne\": \"America/Cayenne\",\n    \"America/Cayman\": \"America/Cayman\",\n    \"America/Chicago\": \"America/Chicago\",\n    \"America/Chihuahua\": \"America/Chihuahua\",\n    \"America/Costa_Rica\": \"America/Costa_Rica\",\n    \"America/Creston\": \"America/Creston\",\n    \"America/Cuiaba\": \"America/Cuiaba\",\n    \"America/Curacao\": \"America/Curacao\",\n    \"America/Danmarkshavn\": \"America/Danmarkshavn\",\n    \"America/Dawson\": \"America/Dawson\",\n    \"America/Dawson_Creek\": \"America/Dawson_Creek\",\n    \"America/Denver\": \"America/Denver\",\n    \"America/Detroit\": \"America/Detroit\",\n    \"America/Dominica\": \"America/Dominica\",\n    \"America/Edmonton\": \"America/Edmonton\",\n    \"America/Eirunepe\": \"America/Eirunepe\",\n    \"America/El_Salvador\": \"America/El_Salvador\",\n    \"America/Fort_Nelson\": \"America/Fort_Nelson\",\n    \"America/Fortaleza\": \"America/Fortaleza\",\n    \"America/Glace_Bay\": \"America/Glace_Bay\",\n    \"America/Goose_Bay\": \"America/Goose_Bay\",\n    \"America/Grand_Turk\": \"America/Grand_Turk\",\n    \"America/Grenada\": \"America/Grenada\",\n    \"America/Guadeloupe\": \"America/Guadeloupe\",\n    \"America/Guatemala\": \"America/Guatemala\",\n    \"America/Guayaquil\": \"America/Guayaquil\",\n    \"America/Guyana\": \"America/Guyana\",\n    \"America/Halifax\": \"America/Halifax\",\n    \"America/Havana\": \"America/Havana\",\n    \"America/Hermosillo\": \"America/Hermosillo\",\n    \"America/Indiana/Indianapolis\": \"America/Indiana/Indianapolis\",\n    \"America/Indiana/Knox\": \"America/Indiana/Knox\",\n    \"America/Indiana/Marengo\": \"America/Indiana/Marengo\",\n    \"America/Indiana/Petersburg\": \"America/Indiana/Petersburg\",\n    \"America/Indiana/Tell_City\": \"America/Indiana/Tell_City\",\n    \"America/Indiana/Vevay\": \"America/Indiana/Vevay\",\n    \"America/Indiana/Vincennes\": \"America/Indiana/Vincennes\",\n    \"America/Indiana/Winamac\": \"America/Indiana/Winamac\",\n    \"America/Inuvik\": \"America/Inuvik\",\n    \"America/Iqaluit\": \"America/Iqaluit\",\n    \"America/Jamaica\": \"America/Jamaica\",\n    \"America/Juneau\": \"America/Juneau\",\n    \"America/Kentucky/Louisville\": \"America/Kentucky/Louisville\",\n    \"America/Kentucky/Monticello\": \"America/Kentucky/Monticello\",\n    \"America/Kralendijk\": \"America/Kralendijk\",\n    \"America/La_Paz\": \"America/La_Paz\",\n    \"America/Lima\": \"America/Lima\",\n    \"America/Los_Angeles\": \"America/Los_Angeles\",\n    \"America/Lower_Princes\": \"America/Lower_Princes\",\n    \"America/Maceio\": \"America/Maceio\",\n    \"America/Managua\": \"America/Managua\",\n    \"America/Manaus\": \"America/Manaus\",\n    \"America/Marigot\": \"America/Marigot\",\n    \"America/Martinique\": \"America/Martinique\",\n    \"America/Matamoros\": \"America/Matamoros\",\n    \"America/Mazatlan\": \"America/Mazatlan\",\n    \"America/Menominee\": \"America/Menominee\",\n    \"America/Merida\": \"America/Merida\",\n    \"America/Metlakatla\": \"America/Metlakatla\",\n    \"America/Mexico_City\": \"America/Mexico_City\",\n    \"America/Miquelon\": \"America/Miquelon\",\n    \"America/Moncton\": \"America/Moncton\",\n    \"America/Monterrey\": \"America/Monterrey\",\n    \"America/Montevideo\": \"America/Montevideo\",\n    \"America/Montserrat\": \"America/Montserrat\",\n    \"America/Nassau\": \"America/Nassau\",\n    \"America/New_York\": \"America/New_York\",\n    \"America/Nipigon\": \"America/Nipigon\",\n    \"America/Nome\": \"America/Nome\",\n    \"America/Noronha\": \"America/Noronha\",\n    \"America/North_Dakota/Beulah\": \"America/North_Dakota/Beulah\",\n    \"America/North_Dakota/Center\": \"America/North_Dakota/Center\",\n    \"America/North_Dakota/New_Salem\": \"America/North_Dakota/New_Salem\",\n    \"America/Nuuk\": \"America/Nuuk\",\n    \"America/Ojinaga\": \"America/Ojinaga\",\n    \"America/Panama\": \"America/Panama\",\n    \"America/Pangnirtung\": \"America/Pangnirtung\",\n    \"America/Paramaribo\": \"America/Paramaribo\",\n    \"America/Phoenix\": \"America/Phoenix\",\n    \"America/Port-au-Prince\": \"America/Port-au-Prince\",\n    \"America/Port_of_Spain\": \"America/Port_of_Spain\",\n    \"America/Porto_Velho\": \"America/Porto_Velho\",\n    \"America/Puerto_Rico\": \"America/Puerto_Rico\",\n    \"America/Punta_Arenas\": \"America/Punta_Arenas\",\n    \"America/Rainy_River\": \"America/Rainy_River\",\n    \"America/Rankin_Inlet\": \"America/Rankin_Inlet\",\n    \"America/Recife\": \"America/Recife\",\n    \"America/Regina\": \"America/Regina\",\n    \"America/Resolute\": \"America/Resolute\",\n    \"America/Rio_Branco\": \"America/Rio_Branco\",\n    \"America/Santarem\": \"America/Santarem\",\n    \"America/Santiago\": \"America/Santiago\",\n    \"America/Santo_Domingo\": \"America/Santo_Domingo\",\n    \"America/Sao_Paulo\": \"America/Sao_Paulo\",\n    \"America/Scoresbysund\": \"America/Scoresbysund\",\n    \"America/Sitka\": \"America/Sitka\",\n    \"America/St_Barthelemy\": \"America/St_Barthelemy\",\n    \"America/St_Johns\": \"America/St_Johns\",\n    \"America/St_Kitts\": \"America/St_Kitts\",\n    \"America/St_Lucia\": \"America/St_Lucia\",\n    \"America/St_Thomas\": \"America/St_Thomas\",\n    \"America/St_Vincent\": \"America/St_Vincent\",\n    \"America/Swift_Current\": \"America/Swift_Current\",\n    \"America/Tegucigalpa\": \"America/Tegucigalpa\",\n    \"America/Thule\": \"America/Thule\",\n    \"America/Thunder_Bay\": \"America/Thunder_Bay\",\n    \"America/Tijuana\": \"America/Tijuana\",\n    \"America/Toronto\": \"America/Toronto\",\n    \"America/Tortola\": \"America/Tortola\",\n    \"America/Vancouver\": \"America/Vancouver\",\n    \"America/Whitehorse\": \"America/Whitehorse\",\n    \"America/Winnipeg\": \"America/Winnipeg\",\n    \"America/Yakutat\": \"America/Yakutat\",\n    \"America/Yellowknife\": \"America/Yellowknife\",\n    \"Antarctica/Casey\": \"Antarctica/Casey\",\n    \"Antarctica/Davis\": \"Antarctica/Davis\",\n    \"Antarctica/DumontDUrville\": \"Antarctica/DumontDUrville\",\n    \"Antarctica/Macquarie\": \"Antarctica/Macquarie\",\n    \"Antarctica/Mawson\": \"Antarctica/Mawson\",\n    \"Antarctica/McMurdo\": \"Antarctica/McMurdo\",\n    \"Antarctica/Palmer\": \"Antarctica/Palmer\",\n    \"Antarctica/Rothera\": \"Antarctica/Rothera\",\n    \"Antarctica/Syowa\": \"Antarctica/Syowa\",\n    \"Antarctica/Troll\": \"Antarctica/Troll\",\n    \"Antarctica/Vostok\": \"Antarctica/Vostok\",\n    \"Arctic/Longyearbyen\": \"Arctic/Longyearbyen\",\n    \"Asia/Aden\": \"Asia/Aden\",\n    \"Asia/Almaty\": \"Asia/Almaty\",\n    \"Asia/Amman\": \"Asia/Amman\",\n    \"Asia/Anadyr\": \"Asia/Anadyr\",\n    \"Asia/Aqtau\": \"Asia/Aqtau\",\n    \"Asia/Aqtobe\": \"Asia/Aqtobe\",\n    \"Asia/Ashgabat\": \"Asia/Ashgabat\",\n    \"Asia/Atyrau\": \"Asia/Atyrau\",\n    \"Asia/Baghdad\": \"Asia/Baghdad\",\n    \"Asia/Bahrain\": \"Asia/Bahrain\",\n    \"Asia/Baku\": \"Asia/Baku\",\n    \"Asia/Bangkok\": \"Asia/Bangkok\",\n    \"Asia/Barnaul\": \"Asia/Barnaul\",\n    \"Asia/Beirut\": \"Asia/Beirut\",\n    \"Asia/Bishkek\": \"Asia/Bishkek\",\n    \"Asia/Brunei\": \"Asia/Brunei\",\n    \"Asia/Chita\": \"Asia/Chita\",\n    \"Asia/Choibalsan\": \"Asia/Choibalsan\",\n    \"Asia/Colombo\": \"Asia/Colombo\",\n    \"Asia/Damascus\": \"Asia/Damascus\",\n    \"Asia/Dhaka\": \"Asia/Dhaka\",\n    \"Asia/Dili\": \"Asia/Dili\",\n    \"Asia/Dubai\": \"Asia/Dubai\",\n    \"Asia/Dushanbe\": \"Asia/Dushanbe\",\n    \"Asia/Famagusta\": \"Asia/Famagusta\",\n    \"Asia/Gaza\": \"Asia/Gaza\",\n    \"Asia/Hebron\": \"Asia/Hebron\",\n    \"Asia/Ho_Chi_Minh\": \"Asia/Ho_Chi_Minh\",\n    \"Asia/Hong_Kong\": \"Asia/Hong_Kong\",\n    \"Asia/Hovd\": \"Asia/Hovd\",\n    \"Asia/Irkutsk\": \"Asia/Irkutsk\",\n    \"Asia/Jakarta\": \"Asia/Jakarta\",\n    \"Asia/Jayapura\": \"Asia/Jayapura\",\n    \"Asia/Jerusalem\": \"Asia/Jerusalem\",\n    \"Asia/Kabul\": \"Asia/Kabul\",\n    \"Asia/Kamchatka\": \"Asia/Kamchatka\",\n    \"Asia/Karachi\": \"Asia/Karachi\",\n    \"Asia/Kathmandu\": \"Asia/Kathmandu\",\n    \"Asia/Khandyga\": \"Asia/Khandyga\",\n    \"Asia/Kolkata\": \"Asia/Kolkata\",\n    \"Asia/Krasnoyarsk\": \"Asia/Krasnoyarsk\",\n    \"Asia/Kuala_Lumpur\": \"Asia/Kuala_Lumpur\",\n    \"Asia/Kuching\": \"Asia/Kuching\",\n    \"Asia/Kuwait\": \"Asia/Kuwait\",\n    \"Asia/Macau\": \"Asia/Macau\",\n    \"Asia/Magadan\": \"Asia/Magadan\",\n    \"Asia/Makassar\": \"Asia/Makassar\",\n    \"Asia/Manila\": \"Asia/Manila\",\n    \"Asia/Muscat\": \"Asia/Muscat\",\n    \"Asia/Nicosia\": \"Asia/Nicosia\",\n    \"Asia/Novokuznetsk\": \"Asia/Novokuznetsk\",\n    \"Asia/Novosibirsk\": \"Asia/Novosibirsk\",\n    \"Asia/Omsk\": \"Asia/Omsk\",\n    \"Asia/Oral\": \"Asia/Oral\",\n    \"Asia/Phnom_Penh\": \"Asia/Phnom_Penh\",\n    \"Asia/Pontianak\": \"Asia/Pontianak\",\n    \"Asia/Pyongyang\": \"Asia/Pyongyang\",\n    \"Asia/Qatar\": \"Asia/Qatar\",\n    \"Asia/Qostanay\": \"Asia/Qostanay\",\n    \"Asia/Qyzylorda\": \"Asia/Qyzylorda\",\n    \"Asia/Riyadh\": \"Asia/Riyadh\",\n    \"Asia/Sakhalin\": \"Asia/Sakhalin\",\n    \"Asia/Samarkand\": \"Asia/Samarkand\",\n    \"Asia/Seoul\": \"Asia/Seoul\",\n    \"Asia/Shanghai\": \"Asia/Shanghai\",\n    \"Asia/Singapore\": \"Asia/Singapore\",\n    \"Asia/Srednekolymsk\": \"Asia/Srednekolymsk\",\n    \"Asia/Taipei\": \"Asia/Taipei\",\n    \"Asia/Tashkent\": \"Asia/Tashkent\",\n    \"Asia/Tbilisi\": \"Asia/Tbilisi\",\n    \"Asia/Tehran\": \"Asia/Tehran\",\n    \"Asia/Thimphu\": \"Asia/Thimphu\",\n    \"Asia/Tokyo\": \"Asia/Tokyo\",\n    \"Asia/Tomsk\": \"Asia/Tomsk\",\n    \"Asia/Ulaanbaatar\": \"Asia/Ulaanbaatar\",\n    \"Asia/Urumqi\": \"Asia/Urumqi\",\n    \"Asia/Ust-Nera\": \"Asia/Ust-Nera\",\n    \"Asia/Vientiane\": \"Asia/Vientiane\",\n    \"Asia/Vladivostok\": \"Asia/Vladivostok\",\n    \"Asia/Yakutsk\": \"Asia/Yakutsk\",\n    \"Asia/Yangon\": \"Asia/Yangon\",\n    \"Asia/Yekaterinburg\": \"Asia/Yekaterinburg\",\n    \"Asia/Yerevan\": \"Asia/Yerevan\",\n    \"Atlantic/Azores\": \"Atlantic/Azores\",\n    \"Atlantic/Bermuda\": \"Atlantic/Bermuda\",\n    \"Atlantic/Canary\": \"Atlantic/Canary\",\n    \"Atlantic/Cape_Verde\": \"Atlantic/Cape_Verde\",\n    \"Atlantic/Faroe\": \"Atlantic/Faroe\",\n    \"Atlantic/Madeira\": \"Atlantic/Madeira\",\n    \"Atlantic/Reykjavik\": \"Atlantic/Reykjavik\",\n    \"Atlantic/South_Georgia\": \"Atlantic/South_Georgia\",\n    \"Atlantic/St_Helena\": \"Atlantic/St_Helena\",\n    \"Atlantic/Stanley\": \"Atlantic/Stanley\",\n    \"Australia/Adelaide\": \"Australia/Adelaide\",\n    \"Australia/Brisbane\": \"Australia/Brisbane\",\n    \"Australia/Broken_Hill\": \"Australia/Broken_Hill\",\n    \"Australia/Darwin\": \"Australia/Darwin\",\n    \"Australia/Eucla\": \"Australia/Eucla\",\n    \"Australia/Hobart\": \"Australia/Hobart\",\n    \"Australia/Lindeman\": \"Australia/Lindeman\",\n    \"Australia/Lord_Howe\": \"Australia/Lord_Howe\",\n    \"Australia/Melbourne\": \"Australia/Melbourne\",\n    \"Australia/Perth\": \"Australia/Perth\",\n    \"Australia/Sydney\": \"Australia/Sydney\",\n    \"Europe/Amsterdam\": \"Europe/Amsterdam\",\n    \"Europe/Andorra\": \"Europe/Andorra\",\n    \"Europe/Astrakhan\": \"Europe/Astrakhan\",\n    \"Europe/Athens\": \"Europe/Athens\",\n    \"Europe/Belgrade\": \"Europe/Belgrade\",\n    \"Europe/Berlin\": \"Europe/Berlin\",\n    \"Europe/Bratislava\": \"Europe/Bratislava\",\n    \"Europe/Brussels\": \"Europe/Brussels\",\n    \"Europe/Bucharest\": \"Europe/Bucharest\",\n    \"Europe/Budapest\": \"Europe/Budapest\",\n    \"Europe/Busingen\": \"Europe/Busingen\",\n    \"Europe/Chisinau\": \"Europe/Chisinau\",\n    \"Europe/Copenhagen\": \"Europe/Copenhagen\",\n    \"Europe/Dublin\": \"Europe/Dublin\",\n    \"Europe/Gibraltar\": \"Europe/Gibraltar\",\n    \"Europe/Guernsey\": \"Europe/Guernsey\",\n    \"Europe/Helsinki\": \"Europe/Helsinki\",\n    \"Europe/Isle_of_Man\": \"Europe/Isle_of_Man\",\n    \"Europe/Istanbul\": \"Europe/Istanbul\",\n    \"Europe/Jersey\": \"Europe/Jersey\",\n    \"Europe/Kaliningrad\": \"Europe/Kaliningrad\",\n    \"Europe/Kiev\": \"Europe/Kiev\",\n    \"Europe/Kirov\": \"Europe/Kirov\",\n    \"Europe/Lisbon\": \"Europe/Lisbon\",\n    \"Europe/Ljubljana\": \"Europe/Ljubljana\",\n    \"Europe/London\": \"Europe/London\",\n    \"Europe/Luxembourg\": \"Europe/Luxembourg\",\n    \"Europe/Madrid\": \"Europe/Madrid\",\n    \"Europe/Malta\": \"Europe/Malta\",\n    \"Europe/Mariehamn\": \"Europe/Mariehamn\",\n    \"Europe/Minsk\": \"Europe/Minsk\",\n    \"Europe/Monaco\": \"Europe/Monaco\",\n    \"Europe/Moscow\": \"Europe/Moscow\",\n    \"Europe/Oslo\": \"Europe/Oslo\",\n    \"Europe/Paris\": \"Europe/Paris\",\n    \"Europe/Podgorica\": \"Europe/Podgorica\",\n    \"Europe/Prague\": \"Europe/Prague\",\n    \"Europe/Riga\": \"Europe/Riga\",\n    \"Europe/Rome\": \"Europe/Rome\",\n    \"Europe/Samara\": \"Europe/Samara\",\n    \"Europe/San_Marino\": \"Europe/San_Marino\",\n    \"Europe/Sarajevo\": \"Europe/Sarajevo\",\n    \"Europe/Saratov\": \"Europe/Saratov\",\n    \"Europe/Simferopol\": \"Europe/Simferopol\",\n    \"Europe/Skopje\": \"Europe/Skopje\",\n    \"Europe/Sofia\": \"Europe/Sofia\",\n    \"Europe/Stockholm\": \"Europe/Stockholm\",\n    \"Europe/Tallinn\": \"Europe/Tallinn\",\n    \"Europe/Tirane\": \"Europe/Tirane\",\n    \"Europe/Ulyanovsk\": \"Europe/Ulyanovsk\",\n    \"Europe/Uzhgorod\": \"Europe/Uzhgorod\",\n    \"Europe/Vaduz\": \"Europe/Vaduz\",\n    \"Europe/Vatican\": \"Europe/Vatican\",\n    \"Europe/Vienna\": \"Europe/Vienna\",\n    \"Europe/Vilnius\": \"Europe/Vilnius\",\n    \"Europe/Volgograd\": \"Europe/Volgograd\",\n    \"Europe/Warsaw\": \"Europe/Warsaw\",\n    \"Europe/Zagreb\": \"Europe/Zagreb\",\n    \"Europe/Zaporozhye\": \"Europe/Zaporozhye\",\n    \"Europe/Zurich\": \"Europe/Zurich\",\n    \"Indian/Antananarivo\": \"Indian/Antananarivo\",\n    \"Indian/Chagos\": \"Indian/Chagos\",\n    \"Indian/Christmas\": \"Indian/Christmas\",\n    \"Indian/Cocos\": \"Indian/Cocos\",\n    \"Indian/Comoro\": \"Indian/Comoro\",\n    \"Indian/Kerguelen\": \"Indian/Kerguelen\",\n    \"Indian/Mahe\": \"Indian/Mahe\",\n    \"Indian/Maldives\": \"Indian/Maldives\",\n    \"Indian/Mauritius\": \"Indian/Mauritius\",\n    \"Indian/Mayotte\": \"Indian/Mayotte\",\n    \"Indian/Reunion\": \"Indian/Reunion\",\n    \"Pacific/Apia\": \"Pacific/Apia\",\n    \"Pacific/Auckland\": \"Pacific/Auckland\",\n    \"Pacific/Bougainville\": \"Pacific/Bougainville\",\n    \"Pacific/Chatham\": \"Pacific/Chatham\",\n    \"Pacific/Chuuk\": \"Pacific/Chuuk\",\n    \"Pacific/Easter\": \"Pacific/Easter\",\n    \"Pacific/Efate\": \"Pacific/Efate\",\n    \"Pacific/Fakaofo\": \"Pacific/Fakaofo\",\n    \"Pacific/Fiji\": \"Pacific/Fiji\",\n    \"Pacific/Funafuti\": \"Pacific/Funafuti\",\n    \"Pacific/Galapagos\": \"Pacific/Galapagos\",\n    \"Pacific/Gambier\": \"Pacific/Gambier\",\n    \"Pacific/Guadalcanal\": \"Pacific/Guadalcanal\",\n    \"Pacific/Guam\": \"Pacific/Guam\",\n    \"Pacific/Honolulu\": \"Pacific/Honolulu\",\n    \"Pacific/Kanton\": \"Pacific/Kanton\",\n    \"Pacific/Kiritimati\": \"Pacific/Kiritimati\",\n    \"Pacific/Kosrae\": \"Pacific/Kosrae\",\n    \"Pacific/Kwajalein\": \"Pacific/Kwajalein\",\n    \"Pacific/Majuro\": \"Pacific/Majuro\",\n    \"Pacific/Marquesas\": \"Pacific/Marquesas\",\n    \"Pacific/Midway\": \"Pacific/Midway\",\n    \"Pacific/Nauru\": \"Pacific/Nauru\",\n    \"Pacific/Niue\": \"Pacific/Niue\",\n    \"Pacific/Norfolk\": \"Pacific/Norfolk\",\n    \"Pacific/Noumea\": \"Pacific/Noumea\",\n    \"Pacific/Pago_Pago\": \"Pacific/Pago_Pago\",\n    \"Pacific/Palau\": \"Pacific/Palau\",\n    \"Pacific/Pitcairn\": \"Pacific/Pitcairn\",\n    \"Pacific/Pohnpei\": \"Pacific/Pohnpei\",\n    \"Pacific/Port_Moresby\": \"Pacific/Port_Moresby\",\n    \"Pacific/Rarotonga\": \"Pacific/Rarotonga\",\n    \"Pacific/Saipan\": \"Pacific/Saipan\",\n    \"Pacific/Tahiti\": \"Pacific/Tahiti\",\n    \"Pacific/Tarawa\": \"Pacific/Tarawa\",\n    \"Pacific/Tongatapu\": \"Pacific/Tongatapu\",\n    \"Pacific/Wake\": \"Pacific/Wake\",\n    \"Pacific/Wallis\": \"Pacific/Wallis\"\n                        },\n                        \"description\": \"Dictates the website global timezone. Other external services like payment providers might not use the same timezone.\"\n                    }', 'select_dropdown', 300, 'Site'),
(316, 'feed.show_attachments_counts_for_ppv', 'Show attachments counts for PPV posts', '0', '{\n\"on\" : \"On\",\n\"off\" : \"Off\",\n\"checked\" : true,\n}', 'checkbox', 75, 'Feed'),
(317, 'payments.mercado_access_token', 'Mercado Access Token', NULL, '', 'text', 102, 'Payments'),
(318, 'payments.mercado_checkout_disabled', 'Disable for checkout', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Won`t be shown on checkout, but it`s still available for deposits.\"\n                        }', 'checkbox', 104, 'Payments'),
(319, 'streams.allow_free_streams', 'Allow free streams', '1', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"If disabled, PPV only streams will be enforced.\"\n                        }', 'checkbox', 164, 'Streams'),
(320, 'payments.disable_local_wallet_for_subscriptions', 'Disable local wallet based subscriptions', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"If disabled, users will not be able to do local wallet subscriptions, only one-time payments. Sometimes, payment providers might enforce this requirement.\"\n                        }', 'checkbox', 130, 'Payments'),
(321, 'payments.min_ppv_post_price', 'Min PPV post price', '1', NULL, 'text', 100, 'Payments'),
(322, 'payments.max_ppv_post_price', 'Max PPV post price', '500', NULL, 'text', 105, 'Payments'),
(323, 'payments.min_ppv_message_price', 'Min PPV message price', '1', NULL, 'text', 110, 'Payments'),
(324, 'payments.max_ppv_message_price', 'Max PPV message price', '500', NULL, 'text', 115, 'Payments'),
(325, 'payments.min_ppv_stream_price', 'Min PPV stream price', '5', NULL, 'text', 120, 'Payments'),
(326, 'payments.max_ppv_stream_price', 'Max PPV stream price', '500', NULL, 'text', 125, 'Payments'),
(327, 'payments.withdrawal_custom_message_box', 'Withdrawal payments details box', NULL, '{\"description\":\"This field can be used to add a custom info box, where users can be informed on any withdrawal information they might need to know about.\"}', 'code_editor', 99, 'Payments'),
(328, 'admin.send_notifications_on_pending_posts', 'Admin notifications for posts to be approved', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"If enabled, the admin users will receive an email whenever a post is pending approval.\"\n                        }', 'checkbox', 10, 'Admin'),
(329, 'media.transcoding_driver', 'Transcoding driver', 'none', '{\n\"default\" : \"pusher\",\n\"options\" : {\n\"none\": \"None\",\n\"ffmpeg\": \"FFmpeg\",\n\"coconut\": \"Coconut\"\n}\n}', 'select_dropdown', 10, 'Media'),
(330, 'media.coconut_api_key', 'Coconut API Key', NULL, '', 'text', 180, 'Media'),
(331, 'media.coconut_audio_encoder', 'Coconut Audio encoder', 'aac', '{\n\"default\" : \"aac\",\n\"options\" : {\n\"aac\": \"AAC Encoder\",\n\"mp3\": \"MP3 Encoder\"\n},\n\"description\": \"AAC is recommended for best compatibility.\"\n}', 'select_dropdown', 190, 'Media'),
(332, 'media.coconut_video_conversion_quality_preset', 'Coconut video quality preset', 'coconut_balanced', '{\n\"description\" : \"Going for better quality will reduce the processing time but increase the file size, next to it\'s original size.\",\n\"default\" : \"coconut_balanced\",\n\"options\" : {\n\"coconut_size\": \"Size optimized\",\n\"coconut_balanced\": \"Balanced profile\",\n\"coconut_quality\": \"Quality optimized\"\n}\n}', 'radio_btn', 200, 'Media'),
(333, 'media.coconut_enforce_mp4_conversion', 'Enforce mp4 videos re-conversion', '1', '{\n\"on\" : \"On\",\n\"off\" : \"Off\",\n\"checked\" : true,\n\"description\": \"Allows you skip mp4 re-conversion to platform standards, reducing costs. Recommended value: On.\"\n}', 'checkbox', 210, 'Media'),
(334, 'feed.default_search_widget_filter', 'Default search widget filter', 'top', '{\n\"default\" : \"top\",\n\"options\" : {\n\"live\": \"Live\",\n\"top\": \"Top\",\n\"people\": \"People\",\n\"videos\": \"Videos\",\n\"photos\": \"Photos\"\n}\n}', 'select_dropdown', 100, 'Feed'),
(335, 'profiles.disable_profile_offers', 'Disable profile promotions', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Disables creator time limited offers. Sometimes, payment providers like CCBill might ask for this.\"\n                        }', 'checkbox', 140, 'Profiles'),
(336, 'media.coconut_video_region', 'Coconut region', NULL, '{\n\"description\" : \"Make sure you\'re using the same region under which you registered the account on. EG: us-east-1/us-west-2/eu-west-1\"}', 'text', 185, 'Media'),
(337, 'payments.withdrawal_enable_stripe_connect', 'Enable Stripe Connect for withdrawals', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Enables withdrawals through Stripe Connect. Will enforce users going through Stripe onboarding to validate their details\"\n                        }', 'checkbox', 100, 'Payments'),
(338, 'payments.withdrawal_stripe_connect_webhooks_secret', 'Stripe Connect Webhooks Secret', NULL, '{\n                        \"description\": \"It must be set if Stripe Connect is enabled\"\n                        }', 'text', 101, 'Payments'),
(339, 'payments.stripe_ideal_provider_enabled', 'Allow iDEAL', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Enable iDEAL payment provider through Stripe. This will allow customers to use iDEAL as payment provider in Stripe Checkout (currency must be EUR)\"\n                        }', 'checkbox', 102, 'Payments'),
(340, 'payments.stripe_blik_provider_enabled', 'Allow Blik', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Enable Blik payment provider through Stripe. This will allow customers to use Blik as payment provider in Stripe Checkout (currency must be PLN)\"\n                        }', 'checkbox', 104, 'Payments'),
(341, 'payments.stripe_bancontact_provider_enabled', 'Allow Bancontact', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Enable Bancontact payment provider through Stripe. This will allow customers to use Bancontact as payment provider in Stripe Checkout (currency must be EUR)\"\n                        }', 'checkbox', 106, 'Payments'),
(342, 'payments.stripe_eps_provider_enabled', 'Allow EPS', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Enable EPS payment provider through Stripe. This will allow customers to use EPS as payment provider in Stripe Checkout (currency must be EUR)\"\n                        }', 'checkbox', 108, 'Payments'),
(343, 'payments.stripe_giropay_provider_enabled', 'Allow Giropay', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Enable Giropay payment provider through Stripe. This will allow customers to use Giropay as payment provider in Stripe Checkout (currency must be EUR)\"\n                        }', 'checkbox', 110, 'Payments'),
(344, 'payments.stripe_przelewy_provider_enabled', 'Allow Przelewy24', '0', '{\n                        \"true\" : \"On\",\n                        \"false\" : \"Off\",\n                        \"checked\" : false,\n                        \"description\": \"Enable Przelewy24 payment provider through Stripe. This will allow customers to use Przelewy24 as payment provider in Stripe Checkout (currency must be EUR or PLN)\"\n                        }', 'checkbox', 112, 'Payments');

-- --------------------------------------------------------

--
-- Table structure for table `streams`
--

DROP TABLE IF EXISTS `streams`;
CREATE TABLE IF NOT EXISTS `streams` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `poster` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` double(8,2) NOT NULL DEFAULT '0.00',
  `requires_subscription` tinyint(1) DEFAULT '0',
  `sent_expiring_reminder` tinyint(1) DEFAULT '0',
  `is_public` tinyint(1) DEFAULT '1',
  `pushr_id` bigint UNSIGNED NOT NULL,
  `rtmp_key` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rtmp_server` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hls_link` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vod_link` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `settings` text COLLATE utf8mb4_unicode_ci,
  `ended_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `streams_pushr_id_unique` (`pushr_id`),
  KEY `streams_user_id_foreign` (`user_id`),
  KEY `streams_status_index` (`status`),
  KEY `streams_slug_index` (`slug`),
  KEY `streams_is_public_index` (`is_public`),
  KEY `streams_requires_subscription_index` (`requires_subscription`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `stream_messages`
--

DROP TABLE IF EXISTS `stream_messages`;
CREATE TABLE IF NOT EXISTS `stream_messages` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `stream_id` bigint UNSIGNED NOT NULL,
  `message` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `stream_messages_user_id_foreign` (`user_id`),
  KEY `stream_messages_stream_id_foreign` (`stream_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `subscriptions`
--

DROP TABLE IF EXISTS `subscriptions`;
CREATE TABLE IF NOT EXISTS `subscriptions` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `sender_user_id` bigint UNSIGNED NOT NULL,
  `recipient_user_id` bigint UNSIGNED NOT NULL,
  `paypal_agreement_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stripe_subscription_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paypal_plan_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ccbill_subscription_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `provider` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  `canceled_at` datetime DEFAULT NULL,
  `amount` double(8,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `subscriptions_paypal_agreement_id_index` (`paypal_agreement_id`),
  KEY `subscriptions_stripe_subscription_id_index` (`stripe_subscription_id`),
  KEY `subscriptions_type_index` (`type`),
  KEY `subscriptions_provider_index` (`provider`),
  KEY `subscriptions_status_index` (`status`),
  KEY `subscriptions_sender_user_id_foreign` (`sender_user_id`),
  KEY `subscriptions_recipient_user_id_foreign` (`recipient_user_id`),
  KEY `subscriptions_paypal_plan_id_index` (`paypal_plan_id`),
  KEY `subscriptions_ccbill_subscription_id_index` (`ccbill_subscription_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `taxes`
--

DROP TABLE IF EXISTS `taxes`;
CREATE TABLE IF NOT EXISTS `taxes` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `percentage` double(8,2) NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `hidden` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
CREATE TABLE IF NOT EXISTS `transactions` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `sender_user_id` bigint UNSIGNED NOT NULL,
  `recipient_user_id` bigint UNSIGNED DEFAULT NULL,
  `subscription_id` bigint UNSIGNED DEFAULT NULL,
  `post_id` bigint UNSIGNED DEFAULT NULL,
  `stream_id` bigint UNSIGNED DEFAULT NULL,
  `invoice_id` bigint UNSIGNED DEFAULT NULL,
  `user_message_id` bigint UNSIGNED DEFAULT NULL,
  `stripe_transaction_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stripe_session_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paypal_transaction_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paypal_transaction_token` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `coinbase_charge_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `coinbase_transaction_token` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nowpayments_payment_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nowpayments_order_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ccbill_payment_token` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ccbill_transaction_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ccbill_subscription_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paystack_payment_token` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mercado_payment_token` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mercado_payment_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_provider` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `currency` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `paypal_payer_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` double(8,2) NOT NULL,
  `taxes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `transactions_sender_user_id_foreign` (`sender_user_id`),
  KEY `transactions_recipient_user_id_foreign` (`recipient_user_id`),
  KEY `transactions_subscription_id_foreign` (`subscription_id`),
  KEY `transactions_post_id_foreign` (`post_id`),
  KEY `transactions_stream_id_foreign` (`stream_id`),
  KEY `transactions_stripe_transaction_id_index` (`stripe_transaction_id`),
  KEY `transactions_stripe_session_id_index` (`stripe_session_id`),
  KEY `transactions_paypal_payer_id_index` (`paypal_payer_id`),
  KEY `transactions_paypal_transaction_id_index` (`paypal_transaction_id`),
  KEY `transactions_paypal_transaction_token_index` (`paypal_transaction_token`),
  KEY `transactions_coinbase_charge_id_index` (`coinbase_charge_id`),
  KEY `transactions_coinbase_transaction_token_index` (`coinbase_transaction_token`),
  KEY `transactions_nowpayments_payment_id_index` (`nowpayments_payment_id`),
  KEY `transactions_nowpayments_order_id_index` (`nowpayments_order_id`),
  KEY `transactions_ccbill_payment_token_index` (`ccbill_payment_token`),
  KEY `transactions_ccbill_transaction_id_index` (`ccbill_transaction_id`),
  KEY `transactions_ccbill_subscription_id_index` (`ccbill_subscription_id`),
  KEY `transactions_status_index` (`status`),
  KEY `transactions_type_index` (`type`),
  KEY `transactions_invoice_id_foreign` (`invoice_id`),
  KEY `transactions_paystack_payment_token_index` (`paystack_payment_token`),
  KEY `transactions_user_message_id_foreign` (`user_message_id`),
  KEY `transactions_mercado_payment_token_index` (`mercado_payment_token`),
  KEY `transactions_mercado_payment_id_index` (`mercado_payment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `translations`
--

DROP TABLE IF EXISTS `translations`;
CREATE TABLE IF NOT EXISTS `translations` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `table_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `column_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `foreign_key` int UNSIGNED NOT NULL,
  `locale` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `translations_table_name_column_name_foreign_key_locale_unique` (`table_name`,`column_name`,`foreign_key`,`locale`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_id` bigint UNSIGNED DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `referral_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bio` text COLLATE utf8mb4_unicode_ci,
  `birthdate` date DEFAULT NULL,
  `location` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `website` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cover` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `identity_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gender_id` bigint UNSIGNED DEFAULT NULL,
  `gender_pronoun` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `public_profile` tinyint(1) NOT NULL DEFAULT '1',
  `paid_profile` tinyint(1) NOT NULL DEFAULT '1',
  `profile_access_price` double(8,2) NOT NULL DEFAULT '5.00',
  `profile_access_price_6_months` double DEFAULT '5',
  `profile_access_price_3_months` double(8,2) DEFAULT '5.00',
  `profile_access_price_12_months` double DEFAULT '5',
  `billing_address` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `first_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `postcode` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `auth_provider` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `auth_provider_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stripe_account_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stripe_onboarding_verified` tinyint(1) DEFAULT '0',
  `enable_2fa` tinyint(1) DEFAULT NULL,
  `enable_geoblocking` tinyint(1) DEFAULT NULL,
  `open_profile` tinyint(1) DEFAULT '0',
  `country_id` bigint UNSIGNED DEFAULT NULL,
  `settings` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  UNIQUE KEY `users_username_unique` (`username`),
  UNIQUE KEY `users_referral_code_unique` (`referral_code`),
  KEY `users_role_id_foreign` (`role_id`),
  KEY `users_auth_provider_index` (`auth_provider`),
  KEY `users_auth_provider_id_index` (`auth_provider_id`),
  KEY `users_gender_id_foreign` (`gender_id`),
  KEY `users_birthdate_index` (`birthdate`),
  KEY `users_location_index` (`location`),
  KEY `users_enable_2fa_index` (`enable_2fa`),
  KEY `users_enable_geoblocking_index` (`enable_geoblocking`),
  KEY `users_open_profile_index` (`open_profile`),
  KEY `users_country_id_foreign` (`country_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `role_id`, `name`, `email`, `username`, `referral_code`, `bio`, `birthdate`, `location`, `website`, `avatar`, `cover`, `email_verified_at`, `identity_verified_at`, `password`, `gender_id`, `gender_pronoun`, `public_profile`, `paid_profile`, `profile_access_price`, `profile_access_price_6_months`, `profile_access_price_3_months`, `profile_access_price_12_months`, `billing_address`, `first_name`, `last_name`, `city`, `country`, `state`, `postcode`, `remember_token`, `auth_provider`, `auth_provider_id`, `stripe_account_id`, `stripe_onboarding_verified`, `enable_2fa`, `enable_geoblocking`, `open_profile`, `country_id`, `settings`, `created_at`, `updated_at`) VALUES
(1, 1, 'Admin', 'admin@defencestudent.com', 'u1720162874', '7MNHH336', NULL, NULL, NULL, NULL, NULL, NULL, '2024-07-05 01:31:14', NULL, '$2y$10$jp9qauh9xNQKh4qMG38xheIussOpW4A2WKlcmzhyEzPBJ6gXpHw6m', NULL, NULL, 1, 1, 5.00, 5, 5.00, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, '{\"notification_email_new_sub\":\"true\",\"notification_email_new_message\":\"false\",\"notification_email_expiring_subs\":\"true\",\"notification_email_renewals\":\"false\",\"notification_email_new_tip\":\"true\",\"notification_email_new_comment\":\"false\",\"notification_email_new_post_created\":\"false\",\"locale\":\"en\",\"notification_email_new_ppv_unlock\":\"true\",\"notification_email_creator_went_live\":\"false\"}', '2024-07-05 01:31:14', '2024-07-05 01:31:14'),
(2, 2, 'Chandra Outlook', 'chandranath@gmail.com', 'u1720181458', 'X0RWTKAV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '$2y$10$puerB36yq.6tDM8D4KZVBeXtjGaVbEvavjd3uklwn4wO5W2ULEwXK', NULL, NULL, 1, 1, 5.00, 5, 5.00, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, '{\"notification_email_new_sub\":\"true\",\"notification_email_new_message\":\"false\",\"notification_email_expiring_subs\":\"true\",\"notification_email_renewals\":\"false\",\"notification_email_new_tip\":\"true\",\"notification_email_new_comment\":\"false\",\"notification_email_new_post_created\":\"false\",\"locale\":\"en\",\"notification_email_new_ppv_unlock\":\"true\",\"notification_email_creator_went_live\":\"false\"}', '2024-07-05 06:40:58', '2024-07-05 06:40:58'),
(3, 2, 'CD', 'chandra@test.com', 'u1720184754', 'MXW76G99', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '$2y$10$Oeb5F7x/3w8f456rqVYnr..5Zf/WdyDA9VHk908.maFZ6wdaIMcv6', NULL, NULL, 1, 1, 5.00, 5, 5.00, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, '{\"notification_email_new_sub\":\"true\",\"notification_email_new_message\":\"false\",\"notification_email_expiring_subs\":\"true\",\"notification_email_renewals\":\"false\",\"notification_email_new_tip\":\"true\",\"notification_email_new_comment\":\"false\",\"notification_email_new_post_created\":\"false\",\"locale\":\"en\",\"notification_email_new_ppv_unlock\":\"true\",\"notification_email_creator_went_live\":\"false\"}', '2024-07-05 07:35:54', '2024-07-05 07:35:54');

-- --------------------------------------------------------

--
-- Table structure for table `user_bookmarks`
--

DROP TABLE IF EXISTS `user_bookmarks`;
CREATE TABLE IF NOT EXISTS `user_bookmarks` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `post_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_bookmarks_user_id_foreign` (`user_id`),
  KEY `user_bookmarks_post_id_foreign` (`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_codes`
--

DROP TABLE IF EXISTS `user_codes`;
CREATE TABLE IF NOT EXISTS `user_codes` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_codes_user_id_foreign` (`user_id`),
  KEY `user_codes_code_index` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_devices`
--

DROP TABLE IF EXISTS `user_devices`;
CREATE TABLE IF NOT EXISTS `user_devices` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `address` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `signature` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_devices_user_id_foreign` (`user_id`),
  KEY `user_devices_signature_index` (`signature`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_genders`
--

DROP TABLE IF EXISTS `user_genders`;
CREATE TABLE IF NOT EXISTS `user_genders` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `gender_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_genders_gender_name_index` (`gender_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_genders`
--

INSERT INTO `user_genders` (`id`, `gender_name`, `created_at`, `updated_at`) VALUES
(1, 'Male', NULL, NULL),
(2, 'Female', NULL, NULL),
(3, 'Couple', NULL, NULL),
(4, 'Other', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_lists`
--

DROP TABLE IF EXISTS `user_lists`;
CREATE TABLE IF NOT EXISTS `user_lists` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'custom',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_lists_user_id_foreign` (`user_id`),
  KEY `user_lists_type_index` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_lists`
--

INSERT INTO `user_lists` (`id`, `name`, `user_id`, `type`, `created_at`, `updated_at`) VALUES
(1, 'Following', 1, 'following', '2024-07-05 01:31:16', '2024-07-05 01:31:16'),
(2, 'Blocked', 1, 'blocked', '2024-07-05 01:31:16', '2024-07-05 01:31:16'),
(3, 'Following', 2, 'following', '2024-07-05 06:40:58', '2024-07-05 06:40:58'),
(4, 'Blocked', 2, 'blocked', '2024-07-05 06:40:58', '2024-07-05 06:40:58'),
(5, 'Following', 3, 'following', '2024-07-05 07:35:56', '2024-07-05 07:35:56'),
(6, 'Blocked', 3, 'blocked', '2024-07-05 07:35:56', '2024-07-05 07:35:56');

-- --------------------------------------------------------

--
-- Table structure for table `user_list_members`
--

DROP TABLE IF EXISTS `user_list_members`;
CREATE TABLE IF NOT EXISTS `user_list_members` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `list_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `list_id_user_id` (`list_id`,`user_id`),
  KEY `user_list_members_user_id_foreign` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_messages`
--

DROP TABLE IF EXISTS `user_messages`;
CREATE TABLE IF NOT EXISTS `user_messages` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `sender_id` bigint UNSIGNED NOT NULL,
  `receiver_id` bigint UNSIGNED NOT NULL,
  `replyTo` int NOT NULL DEFAULT '0',
  `message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `isSeen` tinyint(1) NOT NULL DEFAULT '0',
  `price` double(8,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_messages_sender_id_foreign` (`sender_id`),
  KEY `user_messages_receiver_id_foreign` (`receiver_id`),
  KEY `user_messages_isseen_index` (`isSeen`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_reports`
--

DROP TABLE IF EXISTS `user_reports`;
CREATE TABLE IF NOT EXISTS `user_reports` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `from_user_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `post_id` bigint UNSIGNED DEFAULT NULL,
  `message_id` bigint DEFAULT NULL,
  `stream_id` bigint DEFAULT NULL,
  `details` text COLLATE utf8mb4_unicode_ci,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_reports_from_user_id_foreign` (`from_user_id`),
  KEY `user_reports_post_id_index` (`post_id`),
  KEY `user_reports_type_index` (`type`),
  KEY `user_reports_status_index` (`status`),
  KEY `user_reports_user_id_foreign` (`user_id`),
  KEY `user_reports_message_id_index` (`message_id`),
  KEY `user_reports_stream_id_index` (`stream_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE IF NOT EXISTS `user_roles` (
  `user_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `user_roles_user_id_index` (`user_id`),
  KEY `user_roles_role_id_index` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_verifies`
--

DROP TABLE IF EXISTS `user_verifies`;
CREATE TABLE IF NOT EXISTS `user_verifies` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `files` text COLLATE utf8mb4_unicode_ci,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `rejectionReason` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_verifies_user_id_foreign` (`user_id`),
  KEY `user_verifies_status_index` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wallets`
--

DROP TABLE IF EXISTS `wallets`;
CREATE TABLE IF NOT EXISTS `wallets` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `total` double(8,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `wallets_user_id_foreign` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `wallets`
--

INSERT INTO `wallets` (`id`, `user_id`, `total`, `created_at`, `updated_at`) VALUES
('1a0c027048e746a096da48e86a368c5d', 2, 0.00, '2024-07-05 06:40:58', '2024-07-05 06:40:58'),
('27370846529e444fbddbc301f04ae4e4', 1, 0.00, '2024-07-05 01:31:16', '2024-07-05 01:31:16'),
('55512517e80045f2a8a027bcf5854c5b', 3, 0.00, '2024-07-05 07:35:56', '2024-07-05 07:35:56');

-- --------------------------------------------------------

--
-- Table structure for table `withdrawals`
--

DROP TABLE IF EXISTS `withdrawals`;
CREATE TABLE IF NOT EXISTS `withdrawals` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `amount` double(8,2) NOT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci,
  `fee` double(8,2) DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `processed` tinyint(1) NOT NULL DEFAULT '0',
  `payment_method` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_identifier` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stripe_payout_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stripe_transfer_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `withdrawals_user_id_foreign` (`user_id`),
  KEY `withdrawals_status_index` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attachments`
--
ALTER TABLE `attachments`
  ADD CONSTRAINT `attachments_message_id_foreign` FOREIGN KEY (`message_id`) REFERENCES `user_messages` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `attachments_payment_request_id_foreign` FOREIGN KEY (`payment_request_id`) REFERENCES `payment_requests` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `attachments_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `attachments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `country_taxes`
--
ALTER TABLE `country_taxes`
  ADD CONSTRAINT `country_taxes_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `country_taxes_tax_id_foreign` FOREIGN KEY (`tax_id`) REFERENCES `taxes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `creator_offers`
--
ALTER TABLE `creator_offers`
  ADD CONSTRAINT `creator_offers_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `data_rows`
--
ALTER TABLE `data_rows`
  ADD CONSTRAINT `data_rows_data_type_id_foreign` FOREIGN KEY (`data_type_id`) REFERENCES `data_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `featured_users`
--
ALTER TABLE `featured_users`
  ADD CONSTRAINT `featured_users_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `menu_items`
--
ALTER TABLE `menu_items`
  ADD CONSTRAINT `menu_items_menu_id_foreign` FOREIGN KEY (`menu_id`) REFERENCES `menus` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `1` FOREIGN KEY (`user_message_id`) REFERENCES `user_messages` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notifications_from_user_id_foreign` FOREIGN KEY (`from_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notifications_post_comment_id_foreign` FOREIGN KEY (`post_comment_id`) REFERENCES `post_comments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notifications_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notifications_reaction_id_foreign` FOREIGN KEY (`reaction_id`) REFERENCES `reactions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notifications_stream_id_foreign` FOREIGN KEY (`stream_id`) REFERENCES `streams` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notifications_subscription_id_foreign` FOREIGN KEY (`subscription_id`) REFERENCES `subscriptions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notifications_to_user_id_foreign` FOREIGN KEY (`to_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notifications_transaction_id_foreign` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notifications_withdrawal_id_foreign` FOREIGN KEY (`withdrawal_id`) REFERENCES `withdrawals` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payment_requests`
--
ALTER TABLE `payment_requests`
  ADD CONSTRAINT `payment_requests_transaction_id_foreign` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `payment_requests_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `permission_role`
--
ALTER TABLE `permission_role`
  ADD CONSTRAINT `permission_role_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `permission_role_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `post_comments`
--
ALTER TABLE `post_comments`
  ADD CONSTRAINT `post_comments_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `post_comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `reactions`
--
ALTER TABLE `reactions`
  ADD CONSTRAINT `reactions_post_comment_id_foreign` FOREIGN KEY (`post_comment_id`) REFERENCES `post_comments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reactions_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reactions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `referral_code_usages`
--
ALTER TABLE `referral_code_usages`
  ADD CONSTRAINT `referral_code_usages_used_by_foreign` FOREIGN KEY (`used_by`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `rewards`
--
ALTER TABLE `rewards`
  ADD CONSTRAINT `rewards_from_user_id_foreign` FOREIGN KEY (`from_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `rewards_referral_code_usage_id_foreign` FOREIGN KEY (`referral_code_usage_id`) REFERENCES `referral_code_usages` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `rewards_to_user_id_foreign` FOREIGN KEY (`to_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `rewards_transaction_id_foreign` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `streams`
--
ALTER TABLE `streams`
  ADD CONSTRAINT `streams_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `stream_messages`
--
ALTER TABLE `stream_messages`
  ADD CONSTRAINT `stream_messages_stream_id_foreign` FOREIGN KEY (`stream_id`) REFERENCES `streams` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `stream_messages_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD CONSTRAINT `subscriptions_recipient_user_id_foreign` FOREIGN KEY (`recipient_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `subscriptions_sender_user_id_foreign` FOREIGN KEY (`sender_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `transactions_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transactions_recipient_user_id_foreign` FOREIGN KEY (`recipient_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transactions_sender_user_id_foreign` FOREIGN KEY (`sender_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transactions_stream_id_foreign` FOREIGN KEY (`stream_id`) REFERENCES `streams` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transactions_subscription_id_foreign` FOREIGN KEY (`subscription_id`) REFERENCES `subscriptions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transactions_user_message_id_foreign` FOREIGN KEY (`user_message_id`) REFERENCES `user_messages` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`),
  ADD CONSTRAINT `users_gender_id_foreign` FOREIGN KEY (`gender_id`) REFERENCES `user_genders` (`id`),
  ADD CONSTRAINT `users_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

--
-- Constraints for table `user_bookmarks`
--
ALTER TABLE `user_bookmarks`
  ADD CONSTRAINT `user_bookmarks_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_bookmarks_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_codes`
--
ALTER TABLE `user_codes`
  ADD CONSTRAINT `user_codes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_devices`
--
ALTER TABLE `user_devices`
  ADD CONSTRAINT `user_devices_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_lists`
--
ALTER TABLE `user_lists`
  ADD CONSTRAINT `user_lists_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_list_members`
--
ALTER TABLE `user_list_members`
  ADD CONSTRAINT `user_list_members_list_id_foreign` FOREIGN KEY (`list_id`) REFERENCES `user_lists` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_list_members_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_messages`
--
ALTER TABLE `user_messages`
  ADD CONSTRAINT `user_messages_receiver_id_foreign` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_messages_sender_id_foreign` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_reports`
--
ALTER TABLE `user_reports`
  ADD CONSTRAINT `user_reports_from_user_id_foreign` FOREIGN KEY (`from_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_reports_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD CONSTRAINT `user_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_roles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_verifies`
--
ALTER TABLE `user_verifies`
  ADD CONSTRAINT `user_verifies_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `wallets`
--
ALTER TABLE `wallets`
  ADD CONSTRAINT `wallets_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `withdrawals`
--
ALTER TABLE `withdrawals`
  ADD CONSTRAINT `withdrawals_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
