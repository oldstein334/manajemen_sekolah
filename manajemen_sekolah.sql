-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 15, 2024 at 07:43 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `manajemen_sekolah`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `LogNamaSiswa` ()   BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE siswa_id INT;
    DECLARE nama VARCHAR(100);
    DECLARE cur CURSOR FOR SELECT siswa_id, nama FROM Siswa;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO siswa_id, nama;
        IF done THEN
            LEAVE read_loop;
        END IF;
        INSERT INTO LogSiswa (siswa_id, action_type, new_nama)
        VALUES (siswa_id, 'LOG NAMA', nama);
    END LOOP;

    CLOSE cur;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TampilSemuaSiswa` ()   BEGIN
    SELECT * FROM Siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TampilSiswaByGenderAndClass` (IN `gender` CHAR(1), IN `class_id` INT)   BEGIN
    IF gender IN ('L', 'P') THEN
        SELECT s.* FROM Siswa s
        JOIN PendaftaranSiswa ps ON s.siswa_id = ps.siswa_id
        WHERE s.jenis_kelamin = gender AND ps.kelas_id = class_id;
    ELSE
        SELECT 'Jenis kelamin harus L atau P' AS error;
    END IF;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `JumlahSiswa` () RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE jumlah INT;
    SELECT COUNT(*) INTO jumlah FROM Siswa;
    RETURN jumlah;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `JumlahSiswaByGenderAndClass` (`gender` CHAR(1), `class_id` INT) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE jumlah INT;
    SELECT COUNT(*) INTO jumlah FROM Siswa s
    JOIN PendaftaranSiswa ps ON s.siswa_id = ps.siswa_id
    WHERE s.jenis_kelamin = gender AND ps.kelas_id = class_id;
    RETURN jumlah;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `detailsiswa`
--

CREATE TABLE `detailsiswa` (
  `detail_id` int(11) NOT NULL,
  `siswa_id` int(11) DEFAULT NULL,
  `hobi` varchar(255) DEFAULT NULL,
  `cita_cita` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detailsiswa`
--

INSERT INTO `detailsiswa` (`detail_id`, `siswa_id`, `hobi`, `cita_cita`) VALUES
(1, 1, 'Membaca', 'Dokter'),
(2, 2, 'Bermain Sepak Bola', 'Pemrogram'),
(3, 3, 'Menari', 'Guru'),
(4, 4, 'Menyanyi', 'Artis'),
(5, 5, 'Melukis', 'Pelukis');

-- --------------------------------------------------------

--
-- Table structure for table `guru`
--

CREATE TABLE `guru` (
  `guru_id` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `alamat` varchar(255) DEFAULT NULL,
  `no_telepon` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `guru`
--

INSERT INTO `guru` (`guru_id`, `nama`, `tanggal_lahir`, `alamat`, `no_telepon`) VALUES
(1, 'Andi Saputra', '1975-08-12', 'Jl. Merdeka No. 10', '081234567890'),
(2, 'Budi Santoso', '1980-05-22', 'Jl. Kenangan No. 23', '081234567891'),
(3, 'Citra Lestari', '1982-11-30', 'Jl. Bahagia No. 45', '081234567892'),
(4, 'Dewi Kurnia', '1978-04-18', 'Jl. Mawar No. 67', '081234567893'),
(5, 'Eka Prasetya', '1979-09-15', 'Jl. Melati No. 89', '081234567894');

-- --------------------------------------------------------

--
-- Table structure for table `indexsiswa`
--

CREATE TABLE `indexsiswa` (
  `siswa_id` int(11) DEFAULT NULL,
  `kelas_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kelas`
--

CREATE TABLE `kelas` (
  `kelas_id` int(11) NOT NULL,
  `nama_kelas` varchar(50) DEFAULT NULL,
  `tingkat` varchar(10) DEFAULT NULL,
  `wali_kelas_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kelas`
--

INSERT INTO `kelas` (`kelas_id`, `nama_kelas`, `tingkat`, `wali_kelas_id`) VALUES
(1, 'Kelas 1A', '1', 1),
(2, 'Kelas 1B', '1', 2),
(3, 'Kelas 2A', '2', 3),
(4, 'Kelas 2B', '2', 4),
(5, 'Kelas 3A', '3', 5);

-- --------------------------------------------------------

--
-- Table structure for table `logsiswa`
--

CREATE TABLE `logsiswa` (
  `log_id` int(11) NOT NULL,
  `siswa_id` int(11) DEFAULT NULL,
  `action_type` varchar(20) DEFAULT NULL,
  `old_nama` varchar(100) DEFAULT NULL,
  `new_nama` varchar(100) DEFAULT NULL,
  `old_tanggal_lahir` date DEFAULT NULL,
  `new_tanggal_lahir` date DEFAULT NULL,
  `old_alamat` varchar(255) DEFAULT NULL,
  `new_alamat` varchar(255) DEFAULT NULL,
  `old_jenis_kelamin` enum('L','P') DEFAULT NULL,
  `new_jenis_kelamin` enum('L','P') DEFAULT NULL,
  `old_no_telepon` varchar(15) DEFAULT NULL,
  `new_no_telepon` varchar(15) DEFAULT NULL,
  `action_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `logsiswa`
--

INSERT INTO `logsiswa` (`log_id`, `siswa_id`, `action_type`, `old_nama`, `new_nama`, `old_tanggal_lahir`, `new_tanggal_lahir`, `old_alamat`, `new_alamat`, `old_jenis_kelamin`, `new_jenis_kelamin`, `old_no_telepon`, `new_no_telepon`, `action_time`) VALUES
(22, 0, 'BEFORE INSERT', NULL, 'Ahmad', NULL, '2010-01-15', NULL, 'Jl. Cemara No. 1', NULL, 'L', NULL, '081234567895', '2024-07-15 02:57:16'),
(23, 7, 'AFTER INSERT', NULL, 'Ahmad', NULL, '2010-01-15', NULL, 'Jl. Cemara No. 1', NULL, 'L', NULL, '081234567895', '2024-07-15 02:57:16'),
(24, 0, 'BEFORE INSERT', NULL, 'Budi', NULL, '2010-02-20', NULL, 'Jl. Cemara No. 2', NULL, 'L', NULL, '081234567896', '2024-07-15 02:57:16'),
(25, 8, 'AFTER INSERT', NULL, 'Budi', NULL, '2010-02-20', NULL, 'Jl. Cemara No. 2', NULL, 'L', NULL, '081234567896', '2024-07-15 02:57:16'),
(26, 0, 'BEFORE INSERT', NULL, 'Citra', NULL, '2010-03-25', NULL, 'Jl. Cemara No. 3', NULL, 'P', NULL, '081234567897', '2024-07-15 02:57:16'),
(27, 9, 'AFTER INSERT', NULL, 'Citra', NULL, '2010-03-25', NULL, 'Jl. Cemara No. 3', NULL, 'P', NULL, '081234567897', '2024-07-15 02:57:16'),
(28, 0, 'BEFORE INSERT', NULL, 'Dewi', NULL, '2010-04-30', NULL, 'Jl. Cemara No. 4', NULL, 'P', NULL, '081234567898', '2024-07-15 02:57:16'),
(29, 10, 'AFTER INSERT', NULL, 'Dewi', NULL, '2010-04-30', NULL, 'Jl. Cemara No. 4', NULL, 'P', NULL, '081234567898', '2024-07-15 02:57:16'),
(30, 0, 'BEFORE INSERT', NULL, 'Eko', NULL, '2010-05-05', NULL, 'Jl. Cemara No. 5', NULL, 'L', NULL, '081234567899', '2024-07-15 02:57:16'),
(31, 11, 'AFTER INSERT', NULL, 'Eko', NULL, '2010-05-05', NULL, 'Jl. Cemara No. 5', NULL, 'L', NULL, '081234567899', '2024-07-15 02:57:16'),
(32, 7, 'BEFORE UPDATE', 'Ahmad', 'Ahmad', '2010-01-15', '2010-01-15', 'Jl. Cemara No. 1', 'Jl.Mangga No 8', 'L', 'L', '081234567895', '081234567895', '2024-07-15 03:19:37'),
(33, 7, 'AFTER UPDATE', 'Ahmad', 'Ahmad', '2010-01-15', '2010-01-15', 'Jl. Cemara No. 1', 'Jl.Mangga No 8', 'L', 'L', '081234567895', '081234567895', '2024-07-15 03:19:37'),
(34, 8, 'BEFORE UPDATE', 'Budi', 'Budi', '2010-02-20', '2010-02-20', 'Jl. Cemara No. 2', 'Jl.Rambutan No 9', 'L', 'L', '081234567896', '081234567896', '2024-07-15 03:19:37'),
(35, 8, 'AFTER UPDATE', 'Budi', 'Budi', '2010-02-20', '2010-02-20', 'Jl. Cemara No. 2', 'Jl.Rambutan No 9', 'L', 'L', '081234567896', '081234567896', '2024-07-15 03:19:37'),
(37, 11, 'BEFORE DELETE', 'Eko', NULL, '2010-05-05', NULL, 'Jl. Cemara No. 5', NULL, 'L', NULL, '081234567899', NULL, '2024-07-15 03:28:17'),
(38, 11, 'AFTER DELETE', 'Eko', NULL, '2010-05-05', NULL, 'Jl. Cemara No. 5', NULL, 'L', NULL, '081234567899', NULL, '2024-07-15 03:28:17'),
(39, 0, 'BEFORE INSERT', NULL, 'Fajar', NULL, '2010-06-01', NULL, 'Jl. Anggrek No. 1', NULL, NULL, NULL, NULL, '2024-07-15 03:52:15'),
(40, 12, 'AFTER INSERT', NULL, 'Fajar', NULL, '2010-06-01', NULL, 'Jl. Anggrek No. 1', NULL, NULL, NULL, NULL, '2024-07-15 03:52:15'),
(41, 12, 'BEFORE UPDATE', 'Fajar', 'Fajar', '2010-06-01', '2010-06-01', 'Jl. Anggrek No. 1', 'Jl. Anggrek No. 2', NULL, 'L', NULL, NULL, '2024-07-15 03:58:34'),
(42, 12, 'AFTER UPDATE', 'Fajar', 'Fajar', '2010-06-01', '2010-06-01', 'Jl. Anggrek No. 1', 'Jl. Anggrek No. 2', NULL, 'L', NULL, NULL, '2024-07-15 03:58:34');

-- --------------------------------------------------------

--
-- Table structure for table `matapelajaran`
--

CREATE TABLE `matapelajaran` (
  `mata_pelajaran_id` int(11) NOT NULL,
  `nama_pelajaran` varchar(100) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `matapelajaran`
--

INSERT INTO `matapelajaran` (`mata_pelajaran_id`, `nama_pelajaran`, `deskripsi`) VALUES
(1, 'Matematika', 'Pelajaran Matematika untuk SD'),
(2, 'Bahasa Indonesia', 'Pelajaran Bahasa Indonesia untuk SD'),
(3, 'Ilmu Pengetahuan Alam', 'Pelajaran IPA untuk SD'),
(4, 'Ilmu Pengetahuan Sosial', 'Pelajaran IPS untuk SD'),
(5, 'Pendidikan Jasmani', 'Pelajaran Olahraga untuk SD');

-- --------------------------------------------------------

--
-- Table structure for table `pendaftaransiswa`
--

CREATE TABLE `pendaftaransiswa` (
  `pendaftaran_id` int(11) NOT NULL,
  `siswa_id` int(11) DEFAULT NULL,
  `kelas_id` int(11) DEFAULT NULL,
  `tanggal_pendaftaran` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pendaftaransiswa`
--

INSERT INTO `pendaftaransiswa` (`pendaftaran_id`, `siswa_id`, `kelas_id`, `tanggal_pendaftaran`) VALUES
(31, 7, 1, '2023-07-01'),
(32, 8, 2, '2023-07-02'),
(33, 9, 3, '2023-07-03'),
(34, 10, 4, '2023-07-04'),
(35, 11, 5, '2023-07-05');

-- --------------------------------------------------------

--
-- Table structure for table `siswa`
--

CREATE TABLE `siswa` (
  `siswa_id` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `alamat` varchar(255) DEFAULT NULL,
  `jenis_kelamin` enum('L','P') DEFAULT NULL,
  `no_telepon` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `siswa`
--

INSERT INTO `siswa` (`siswa_id`, `nama`, `tanggal_lahir`, `alamat`, `jenis_kelamin`, `no_telepon`) VALUES
(7, 'Ahmad', '2010-01-15', 'Jl.Mangga No 8', 'L', '081234567895'),
(8, 'Budi', '2010-02-20', 'Jl.Rambutan No 9', 'L', '081234567896'),
(9, 'Citra', '2010-03-25', 'Jl. Cemara No. 3', 'P', '081234567897'),
(10, 'Dewi', '2010-04-30', 'Jl. Cemara No. 4', 'P', '081234567898'),
(12, 'Fajar', '2010-06-01', 'Jl. Anggrek No. 2', 'L', NULL);

--
-- Triggers `siswa`
--
DELIMITER $$
CREATE TRIGGER `AfterDeleteSiswa` AFTER DELETE ON `siswa` FOR EACH ROW BEGIN
    INSERT INTO LogSiswa (siswa_id, action_type, old_nama, old_tanggal_lahir, old_alamat, old_jenis_kelamin, old_no_telepon)
    VALUES (OLD.siswa_id, 'AFTER DELETE', OLD.nama, OLD.tanggal_lahir, OLD.alamat, OLD.jenis_kelamin, OLD.no_telepon);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `AfterInsertSiswa` AFTER INSERT ON `siswa` FOR EACH ROW BEGIN
    INSERT INTO LogSiswa (siswa_id, action_type, new_nama, new_tanggal_lahir, new_alamat, new_jenis_kelamin, new_no_telepon)
    VALUES (NEW.siswa_id, 'AFTER INSERT', NEW.nama, NEW.tanggal_lahir, NEW.alamat, NEW.jenis_kelamin, NEW.no_telepon);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `AfterUpdateSiswa` AFTER UPDATE ON `siswa` FOR EACH ROW BEGIN
    INSERT INTO LogSiswa (siswa_id, action_type, old_nama, new_nama, old_tanggal_lahir, new_tanggal_lahir, old_alamat, new_alamat, old_jenis_kelamin, new_jenis_kelamin, old_no_telepon, new_no_telepon)
    VALUES (OLD.siswa_id, 'AFTER UPDATE', OLD.nama, NEW.nama, OLD.tanggal_lahir, NEW.tanggal_lahir, OLD.alamat, NEW.alamat, OLD.jenis_kelamin, NEW.jenis_kelamin, OLD.no_telepon, NEW.no_telepon);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `BeforeDeleteSiswa` BEFORE DELETE ON `siswa` FOR EACH ROW BEGIN
    INSERT INTO LogSiswa (siswa_id, action_type, old_nama, old_tanggal_lahir, old_alamat, old_jenis_kelamin, old_no_telepon)
    VALUES (OLD.siswa_id, 'BEFORE DELETE', OLD.nama, OLD.tanggal_lahir, OLD.alamat, OLD.jenis_kelamin, OLD.no_telepon);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `BeforeInsertSiswa` BEFORE INSERT ON `siswa` FOR EACH ROW BEGIN
    INSERT INTO LogSiswa (siswa_id, action_type, new_nama, new_tanggal_lahir, new_alamat, new_jenis_kelamin, new_no_telepon)
    VALUES (NEW.siswa_id, 'BEFORE INSERT', NEW.nama, NEW.tanggal_lahir, NEW.alamat, NEW.jenis_kelamin, NEW.no_telepon);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `BeforeUpdateSiswa` BEFORE UPDATE ON `siswa` FOR EACH ROW BEGIN
    INSERT INTO LogSiswa (siswa_id, action_type, old_nama, new_nama, old_tanggal_lahir, new_tanggal_lahir, old_alamat, new_alamat, old_jenis_kelamin, new_jenis_kelamin, old_no_telepon, new_no_telepon)
    VALUES (OLD.siswa_id, 'BEFORE UPDATE', OLD.nama, NEW.nama, OLD.tanggal_lahir, NEW.tanggal_lahir, OLD.alamat, NEW.alamat, OLD.jenis_kelamin, NEW.jenis_kelamin, OLD.no_telepon, NEW.no_telepon);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `viewsiswafiltered`
-- (See below for the actual view)
--
CREATE TABLE `viewsiswafiltered` (
`siswa_id` int(11)
,`nama` varchar(100)
,`tanggal_lahir` date
,`alamat` varchar(255)
,`jenis_kelamin` enum('L','P')
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `viewsiswahorizontal`
-- (See below for the actual view)
--
CREATE TABLE `viewsiswahorizontal` (
`siswa_id` int(11)
,`nama` varchar(100)
,`tanggal_lahir` date
,`alamat` varchar(255)
,`jenis_kelamin` enum('L','P')
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `viewsiswavertical`
-- (See below for the actual view)
--
CREATE TABLE `viewsiswavertical` (
`nama` varchar(100)
,`jenis_kelamin` enum('L','P')
);

-- --------------------------------------------------------

--
-- Structure for view `viewsiswafiltered`
--
DROP TABLE IF EXISTS `viewsiswafiltered`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewsiswafiltered`  AS SELECT `viewsiswahorizontal`.`siswa_id` AS `siswa_id`, `viewsiswahorizontal`.`nama` AS `nama`, `viewsiswahorizontal`.`tanggal_lahir` AS `tanggal_lahir`, `viewsiswahorizontal`.`alamat` AS `alamat`, `viewsiswahorizontal`.`jenis_kelamin` AS `jenis_kelamin` FROM `viewsiswahorizontal` WHERE `viewsiswahorizontal`.`jenis_kelamin` = 'L'WITH LOCAL CHECK OPTION  ;

-- --------------------------------------------------------

--
-- Structure for view `viewsiswahorizontal`
--
DROP TABLE IF EXISTS `viewsiswahorizontal`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewsiswahorizontal`  AS SELECT `siswa`.`siswa_id` AS `siswa_id`, `siswa`.`nama` AS `nama`, `siswa`.`tanggal_lahir` AS `tanggal_lahir`, `siswa`.`alamat` AS `alamat`, `siswa`.`jenis_kelamin` AS `jenis_kelamin` FROM `siswa` ;

-- --------------------------------------------------------

--
-- Structure for view `viewsiswavertical`
--
DROP TABLE IF EXISTS `viewsiswavertical`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `viewsiswavertical`  AS SELECT `siswa`.`nama` AS `nama`, `siswa`.`jenis_kelamin` AS `jenis_kelamin` FROM `siswa` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `detailsiswa`
--
ALTER TABLE `detailsiswa`
  ADD PRIMARY KEY (`detail_id`),
  ADD KEY `siswa_id` (`siswa_id`);

--
-- Indexes for table `guru`
--
ALTER TABLE `guru`
  ADD PRIMARY KEY (`guru_id`);

--
-- Indexes for table `indexsiswa`
--
ALTER TABLE `indexsiswa`
  ADD KEY `siswa_id` (`siswa_id`,`kelas_id`);

--
-- Indexes for table `kelas`
--
ALTER TABLE `kelas`
  ADD PRIMARY KEY (`kelas_id`),
  ADD KEY `wali_kelas_id` (`wali_kelas_id`);

--
-- Indexes for table `logsiswa`
--
ALTER TABLE `logsiswa`
  ADD PRIMARY KEY (`log_id`);

--
-- Indexes for table `matapelajaran`
--
ALTER TABLE `matapelajaran`
  ADD PRIMARY KEY (`mata_pelajaran_id`);

--
-- Indexes for table `pendaftaransiswa`
--
ALTER TABLE `pendaftaransiswa`
  ADD PRIMARY KEY (`pendaftaran_id`),
  ADD KEY `kelas_id` (`kelas_id`),
  ADD KEY `idx_siswa_kelas` (`siswa_id`,`kelas_id`);

--
-- Indexes for table `siswa`
--
ALTER TABLE `siswa`
  ADD PRIMARY KEY (`siswa_id`),
  ADD KEY `idx_siswa_nama_alamat` (`nama`,`alamat`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `detailsiswa`
--
ALTER TABLE `detailsiswa`
  MODIFY `detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `guru`
--
ALTER TABLE `guru`
  MODIFY `guru_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `kelas`
--
ALTER TABLE `kelas`
  MODIFY `kelas_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `logsiswa`
--
ALTER TABLE `logsiswa`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `matapelajaran`
--
ALTER TABLE `matapelajaran`
  MODIFY `mata_pelajaran_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `pendaftaransiswa`
--
ALTER TABLE `pendaftaransiswa`
  MODIFY `pendaftaran_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `siswa`
--
ALTER TABLE `siswa`
  MODIFY `siswa_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detailsiswa`
--
ALTER TABLE `detailsiswa`
  ADD CONSTRAINT `detailsiswa_ibfk_1` FOREIGN KEY (`siswa_id`) REFERENCES `siswa` (`siswa_id`);

--
-- Constraints for table `kelas`
--
ALTER TABLE `kelas`
  ADD CONSTRAINT `kelas_ibfk_1` FOREIGN KEY (`wali_kelas_id`) REFERENCES `guru` (`guru_id`);

--
-- Constraints for table `pendaftaransiswa`
--
ALTER TABLE `pendaftaransiswa`
  ADD CONSTRAINT `pendaftaransiswa_ibfk_1` FOREIGN KEY (`siswa_id`) REFERENCES `siswa` (`siswa_id`),
  ADD CONSTRAINT `pendaftaransiswa_ibfk_2` FOREIGN KEY (`kelas_id`) REFERENCES `kelas` (`kelas_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
