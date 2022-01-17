-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 17, 2022 at 03:14 PM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 8.0.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `buy-it`
--

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `id` int(12) NOT NULL,
  `name` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `orderid` int(12) NOT NULL,
  `userName` varchar(128) NOT NULL,
  `phone` bigint(10) NOT NULL,
  `pname` varchar(128) NOT NULL,
  `quantity` int(12) NOT NULL,
  `total` int(225) NOT NULL,
  `address` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`orderid`, `userName`, `phone`, `pname`, `quantity`, `total`, `address`) VALUES
(2, 'jisha', 0, 'pen', 1, 1200, 'abcdfsdsfdhs'),
(3, 'jisha', 9656754158, 'pen', 2, 20, 'dsfjhgkhl');

-- --------------------------------------------------------

--
-- Table structure for table `otps`
--

CREATE TABLE `otps` (
  `id` int(12) NOT NULL,
  `phone` bigint(10) NOT NULL,
  `otp` int(4) NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `otps`
--

INSERT INTO `otps` (`id`, `phone`, `otp`, `time`) VALUES
(1, 9656754158, 2618, '2022-01-15 15:37:01'),
(2, 9656754158, 7636, '2022-01-15 15:43:36'),
(3, 9656754158, 7722, '2022-01-15 15:51:13'),
(4, 9656754158, 7596, '2022-01-15 17:40:06'),
(5, 9656754158, 1267, '2022-01-16 04:06:50'),
(6, 9656754158, 3351, '2022-01-16 08:05:48'),
(7, 9656754158, 2815, '2022-01-16 10:21:02'),
(8, 9656754158, 8167, '2022-01-16 15:15:13'),
(9, 9656754158, 1844, '2022-01-16 15:56:35');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `pid` int(12) NOT NULL,
  `pname` varchar(128) NOT NULL,
  `price` int(128) NOT NULL,
  `category` varchar(256) NOT NULL,
  `description` varchar(256) NOT NULL,
  `rating` int(12) NOT NULL,
  `quantity` int(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`pid`, `pname`, `price`, `category`, `description`, `rating`, `quantity`) VALUES
(0, '0', 10, 'study material', 'balck color,sharp point', 5, 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) NOT NULL,
  `name` varchar(128) NOT NULL,
  `userName` varchar(128) NOT NULL,
  `email` varchar(128) NOT NULL,
  `phone` bigint(10) NOT NULL,
  `password` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `userName`, `email`, `phone`, `password`) VALUES
(1, 'Jisha', 'jisha', 'jisha@gmail.com', 9656754158, '$2b$10$NsVLimFZt2sP.2BMN/qa6umyZwNqQfxnNGBxhWff9MPY07foSWEUy'),
(2, 'Jisha', 'jisha', 'jisha@gmail.com', 9656754158, '$2b$10$NsVLimFZt2sP.2BMN/qa6umyZwNqQfxnNGBxhWff9MPY07foSWEUy'),
(3, 'Jisha', 'jisha', 'jisha@gmail.com', 9656754158, '$2b$10$NsVLimFZt2sP.2BMN/qa6umyZwNqQfxnNGBxhWff9MPY07foSWEUy'),
(4, 'Jisha', 'jisha', 'jisha@gmail.com', 9656754158, '$2b$10$NsVLimFZt2sP.2BMN/qa6umyZwNqQfxnNGBxhWff9MPY07foSWEUy'),
(5, 'Jisha', 'jisha', 'jisha@gmail.com', 9656754158, '$2b$10$NsVLimFZt2sP.2BMN/qa6umyZwNqQfxnNGBxhWff9MPY07foSWEUy'),
(6, 'Jisha', 'jisha', 'jisha@gmail.com', 9656754158, '$2b$10$NsVLimFZt2sP.2BMN/qa6umyZwNqQfxnNGBxhWff9MPY07foSWEUy'),
(7, 'Jisha', 'jisha', 'jisha@gmail.com', 9656754158, '$2b$10$NsVLimFZt2sP.2BMN/qa6umyZwNqQfxnNGBxhWff9MPY07foSWEUy'),
(8, 'jisha', 'jisha', 'jisha@gmail.com', 9656754158, '$2b$10$NsVLimFZt2sP.2BMN/qa6umyZwNqQfxnNGBxhWff9MPY07foSWEUy');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`orderid`);

--
-- Indexes for table `otps`
--
ALTER TABLE `otps`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `orderid` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `otps`
--
ALTER TABLE `otps`
  MODIFY `id` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
