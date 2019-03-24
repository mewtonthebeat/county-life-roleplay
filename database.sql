-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Hostiteľ: 127.0.0.1
-- Čas generovania: Ne 24.Mar 2019, 19:24
-- Verzia serveru: 10.1.38-MariaDB
-- Verzia PHP: 7.3.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Databáza: `countyliferp`
--

DELIMITER $$
--
-- Procedúry
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_DiscordActivateUser` (IN `database_id` INT, IN `user_discord_id` VARCHAR(256))  NO SQL
UPDATE
	discord_tokens
SET
	discord_id = user_discord_id
WHERE
	id = database_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_DiscordDeactivateUser` (IN `database_discord_id` VARCHAR(256))  NO SQL
UPDATE
	discord_tokens
SET
	discord_id = NULL
WHERE
	discord_id = database_discord_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_DiscordReadToken` (IN `generated_token` VARCHAR(255))  NO SQL
SELECT 
	id, 
    user_id,
    token,
    discord_id
FROM
	discord_tokens
WHERE
	token = generated_token
AND
	discord_id IS NULL$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `achievements_list`
--

CREATE TABLE `achievements_list` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `descr` text NOT NULL,
  `hidden` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `achievements_list`
--

INSERT INTO `achievements_list` (`id`, `name`, `descr`, `hidden`) VALUES
(1, 'Welcome to Red County', 'Vytvor si prvy charakter.', 0),
(2, 'First Step #1', 'Napis prvu spravu do chatu.', 0),
(3, 'First Step #2', 'Napis tisic sprav do chatu.', 0),
(4, 'First Step #3', 'Napis milion sprav do chatu.', 0),
(5, 'First Step #4', 'Napis 10 milionov sprav do chatu.', 0),
(6, 'Stage V', 'Dosiahni roleplay level 5.', 0),
(7, 'Stage X', 'Dosiahni roleplay level 10.', 0),
(8, 'Stage XX', 'Dosiahni roleplay level 20.', 0),
(9, 'Stage L', 'Dosiahni roleplay level 50.', 0),
(10, 'Everybody Dies', 'Dostan Character Kill.', 0),
(11, 'Imprisoned', 'Dostan sa do Admin-Jailu.', 0),
(12, 'Leave us', 'Dostan kick zo serveru.', 0),
(13, 'See you! Well, maybe', 'Dostan ban.', 0),
(14, 'Pay those bills', 'Ziskaj Donator Level podporenim serveru.', 0),
(15, 'Getting Rich #1', 'Maj pri sebe aspon 10.000$ v hotovosti.', 0),
(16, 'Getting Rich #2', 'Maj pri sebe aspon 50.000$ v hotovosti.', 0),
(17, 'Getting Rich #3', 'Maj pri sebe aspon 100.000$ v hotovosti.', 0),
(18, 'Getting Rich #4', 'Maj pri sebe aspon 500.000$ v hotovosti.', 0),
(19, 'Getting Rich #5', 'Maj pri sebe aspon 1.000.000$ v hotovosti.', 0),
(20, 'First Vehicle', 'Kup si prve vozidlo.', 0),
(21, 'Going Expensive #1', 'Kup si vozidlo najmenej za 50.000$.', 0),
(22, 'Going Expensive #2', 'Kup si vozidlo najmenej za 150.000$.', 0),
(23, 'Going Really Expensive', 'Kup si vozidlo za kredity.', 0),
(24, 'First House', 'Kup si prvy dom.', 0),
(25, 'Expensive Housing', 'Kup si dom najmenej za 100.000$.', 0),
(26, 'Rental is for Mentals #1', 'Prenajmi si hotelovu izbu.', 0),
(27, 'Rental is for Mentals #2', 'Prenajmi si hotelovu izbu aspon na 50 dni.', 0),
(28, 'Making Business', 'Kup si prvy biznis.', 0),
(29, 'Making BIG Business', 'Kup si biznis ktory stoji viac ako 100.000$.', 0),
(30, 'Get that Eagle', 'Ziskaj zbran Desert Eagle.', 0),
(31, 'Luigi', 'Ziskaj zbran Shotgun.', 0),
(32, 'FBI! Open up!', 'Ziskaj zbran M4.', 0),
(33, 'Manhunt', 'Ziskaj zbran Vesnicka Puska', 0),
(34, 'Fast Traveler', 'Chod nejakym vozidlom aspon 120 MPH.', 0),
(35, 'Drink all that booze', 'Maj aspon 2 promile alkoholu.', 0),
(36, 'Well fuck booze', 'Nafukaj aspon 2 promile alkoholu.', 0),
(37, 'Do you have your angel?', 'Zomri.', 0),
(38, 'Michalovska burina', 'Pod bracho, dame finske!', 1),
(39, 'Michalovske psychadelika', 'Nie si z Michaloviec?', 1),
(40, 'Daniel Coles 2014', 'Bud ako Daniel Coles v 2014tom!', 1),
(41, 'Swingers Party', 'Prezi hromadnu teleportaciu adminom', 1),
(42, 'Genocide', 'Zhyn, ked admin vsetkych vyhodi', 1);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `anawalt_kontrakt`
--

CREATE TABLE `anawalt_kontrakt` (
  `id` int(11) NOT NULL,
  `finished` tinyint(4) NOT NULL,
  `woodtype` tinyint(4) NOT NULL,
  `needcount` mediumint(9) NOT NULL,
  `price` int(11) NOT NULL,
  `datereq` int(11) NOT NULL,
  `datefin` int(11) NOT NULL,
  `signedby` varchar(32) NOT NULL,
  `fullfiled` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `anawalt_sklad`
--

CREATE TABLE `anawalt_sklad` (
  `itemtype` int(11) NOT NULL,
  `itemcount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `anawalt_sklad`
--

INSERT INTO `anawalt_sklad` (`itemtype`, `itemcount`) VALUES
(49, 0),
(50, 0),
(51, 0),
(52, 0);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `anawalt_trees`
--

CREATE TABLE `anawalt_trees` (
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `placedby` varchar(30) NOT NULL,
  `treetype` tinyint(4) NOT NULL,
  `steps` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `bazar_log`
--

CREATE TABLE `bazar_log` (
  `id` int(11) NOT NULL,
  `date` int(11) NOT NULL,
  `employee_name` varchar(26) NOT NULL,
  `message` varchar(144) CHARACTER SET utf8 COLLATE utf8_czech_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `cctv`
--

CREATE TABLE `cctv` (
  `ID` int(11) NOT NULL,
  `cctv_name` varchar(45) NOT NULL,
  `cctv_x` float NOT NULL,
  `cctv_y` float NOT NULL,
  `cctv_z` float NOT NULL,
  `cctv_rot_x` float NOT NULL,
  `cctv_rot_y` float NOT NULL,
  `cctv_rot_z` float NOT NULL,
  `cctv_vw` int(11) NOT NULL,
  `cctv_interior` int(11) NOT NULL,
  `cctv_faction` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `char_alcohol_inv`
--

CREATE TABLE `char_alcohol_inv` (
  `Username` text NOT NULL,
  `Name` text NOT NULL,
  `ObjectId` int(11) NOT NULL,
  `Alcohol` int(11) NOT NULL,
  `Objem` int(11) NOT NULL,
  `DecreaseBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `char_clothing`
--

CREATE TABLE `char_clothing` (
  `Username` varchar(32) CHARACTER SET utf8 COLLATE utf8_czech_ci NOT NULL,
  `SlotID` tinyint(4) NOT NULL DEFAULT '0',
  `ModelID` smallint(6) NOT NULL,
  `Bone` tinyint(4) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `RX` float NOT NULL,
  `RY` float NOT NULL,
  `RZ` float NOT NULL,
  `SX` float NOT NULL,
  `SY` float NOT NULL,
  `SZ` float NOT NULL,
  `COLOR1` int(11) NOT NULL,
  `COLOR2` int(11) NOT NULL,
  `Active` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `char_drugs_inv`
--

CREATE TABLE `char_drugs_inv` (
  `Username` varchar(32) NOT NULL,
  `Slot1` int(11) NOT NULL,
  `Slot2` int(11) NOT NULL,
  `Slot3` int(11) NOT NULL,
  `Slot4` int(11) NOT NULL,
  `Slot5` int(11) NOT NULL,
  `Slot6` int(11) NOT NULL,
  `Slot7` int(11) NOT NULL,
  `Slot8` int(11) NOT NULL,
  `Slot9` int(11) NOT NULL,
  `Slot10` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `char_eweapons`
--

CREATE TABLE `char_eweapons` (
  `user` text NOT NULL,
  `weaponid` int(11) NOT NULL,
  `iswork` int(11) NOT NULL,
  `isperm` int(11) NOT NULL,
  `serialnumber` int(11) NOT NULL,
  `origin` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `char_inventory`
--

CREATE TABLE `char_inventory` (
  `id` int(11) NOT NULL,
  `Username` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Mask` int(11) NOT NULL,
  `BoomBox` int(11) NOT NULL,
  `ObcianskyPreukaz` int(11) NOT NULL,
  `RybyKG` float NOT NULL,
  `pepsiCan` int(11) NOT NULL,
  `colaCan` int(11) NOT NULL,
  `kitKatChocolate` int(11) NOT NULL,
  `pringlesChips` int(11) NOT NULL,
  `FishingPermit` int(11) NOT NULL,
  `pacidlo` smallint(6) NOT NULL,
  `lano` smallint(6) NOT NULL,
  `puta` smallint(6) NOT NULL,
  `vrece` smallint(6) NOT NULL,
  `kocka` smallint(6) NOT NULL,
  `Blood` tinyint(4) NOT NULL,
  `Blood_Owner` varchar(30) NOT NULL,
  `VodicakA` tinyint(4) NOT NULL,
  `VodicakB` tinyint(4) NOT NULL,
  `VodicakC` tinyint(4) NOT NULL,
  `VodicakT` tinyint(4) NOT NULL,
  `PermFly` int(11) NOT NULL,
  `PermBoat` int(11) NOT NULL,
  `CreditCard` int(11) NOT NULL,
  `Marihuana` mediumint(9) NOT NULL,
  `Marihuana_Seed` mediumint(9) NOT NULL,
  `Cigarety` int(11) NOT NULL,
  `Zapalovac` int(11) NOT NULL,
  `Telefon` tinyint(4) NOT NULL,
  `SimKarta` int(11) NOT NULL,
  `Naboje` int(11) NOT NULL,
  `Bandaz` int(11) NOT NULL,
  `ZbrojnyPreukaz` tinyint(4) NOT NULL,
  `LotteryTicket` smallint(6) NOT NULL,
  `CarBattery` smallint(6) NOT NULL,
  `Vysielacka` float NOT NULL,
  `VysielackaToggle` tinyint(4) NOT NULL,
  `CarOil` int(11) NOT NULL,
  `PizzaItem` int(11) NOT NULL,
  `KanisterType` tinyint(4) NOT NULL,
  `Kanister` smallint(6) NOT NULL,
  `Rezerva` tinyint(4) NOT NULL,
  `weeds_1` int(11) NOT NULL,
  `weeds_2` int(11) NOT NULL,
  `weeds_3` int(11) NOT NULL,
  `hnojivo` int(11) NOT NULL,
  `Sprite` int(11) NOT NULL,
  `SpriteLean` int(11) NOT NULL,
  `PETCup` int(11) NOT NULL,
  `Prometh` int(11) NOT NULL,
  `Backpack` int(11) NOT NULL,
  `weapon_1` int(11) NOT NULL,
  `weapon_2` int(11) NOT NULL,
  `ammo_1` int(11) NOT NULL,
  `ammo_2` int(11) NOT NULL,
  `Skateboard` int(11) NOT NULL,
  `Katalogy` int(11) NOT NULL,
  `Tree_Sadenice` int(11) NOT NULL,
  `Tree_Log_Oak` int(11) NOT NULL,
  `Tree_Log_Birch` int(11) NOT NULL,
  `Tree_Log_Spruce` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `char_main`
--

CREATE TABLE `char_main` (
  `id` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `active` tinyint(4) NOT NULL,
  `Username` varchar(35) CHARACTER SET utf8 COLLATE utf8_czech_ci NOT NULL,
  `Money` float NOT NULL,
  `Assistances` int(11) NOT NULL DEFAULT '0',
  `Gender` int(11) NOT NULL,
  `Health` float NOT NULL,
  `Armour` float NOT NULL,
  `Hunger` float NOT NULL,
  `PosX` float NOT NULL,
  `PosY` float NOT NULL,
  `PosZ` float NOT NULL,
  `VirtualWorld` int(11) NOT NULL,
  `Interior` int(11) NOT NULL,
  `SkinID` int(11) NOT NULL,
  `Faction` int(11) NOT NULL,
  `FactionRank` int(11) NOT NULL,
  `FactionTitle` text NOT NULL,
  `FactionBadge` int(11) NOT NULL,
  `RoleplayLevel` int(11) NOT NULL,
  `XP` int(11) NOT NULL,
  `PlayTimeHour` int(11) NOT NULL,
  `PlayTimeMin` int(11) NOT NULL,
  `Vyplata` int(11) NOT NULL,
  `VyplataExpire` int(11) NOT NULL,
  `LastOn` datetime NOT NULL,
  `ID_ReleaseDate` date NOT NULL,
  `ID_DateOfBirth` date NOT NULL,
  `ID_PlaceOfBirth` text NOT NULL,
  `ID_Settlement` text NOT NULL,
  `ID_CardID` int(11) NOT NULL,
  `skin_Civil` int(11) NOT NULL,
  `skin_Work` int(11) NOT NULL,
  `IsWorking` int(11) NOT NULL,
  `isPKed` tinyint(4) NOT NULL,
  `PKDate` datetime NOT NULL,
  `PKReason` text NOT NULL,
  `PKAdmin` text NOT NULL,
  `WasPlayed` tinyint(4) NOT NULL,
  `IsCuffed` tinyint(4) NOT NULL,
  `HasVrece` tinyint(4) NOT NULL,
  `HasLano` tinyint(4) NOT NULL,
  `skinStorage1` smallint(6) NOT NULL,
  `skinStorage2` smallint(6) NOT NULL,
  `skinStorage3` smallint(6) NOT NULL,
  `skinStorage4` smallint(6) NOT NULL,
  `skinStorage5` smallint(6) NOT NULL,
  `Vypoved` bigint(20) NOT NULL,
  `Prizvuk` text CHARACTER SET utf8 COLLATE utf8_slovak_ci NOT NULL,
  `Popis` text NOT NULL,
  `Illegal_Faction` int(11) NOT NULL,
  `Illegal_FactionRank` int(11) NOT NULL,
  `IsInJail` tinyint(4) NOT NULL,
  `JailTime` bigint(20) NOT NULL,
  `phone_PayMode` tinyint(4) NOT NULL,
  `phone_Credit` int(11) NOT NULL,
  `FightStyle` tinyint(4) NOT NULL DEFAULT '4',
  `PayDayTime` int(11) NOT NULL,
  `Vyplata_TYP` int(4) NOT NULL,
  `PHONE_SleepMode` tinyint(4) NOT NULL,
  `PHONE_BackGround` tinyint(4) NOT NULL,
  `IsInDeathMode` tinyint(4) NOT NULL,
  `FactionJoined` int(11) NOT NULL,
  `Illegal_Faction_Joined` int(11) NOT NULL,
  `VyplataPlay` int(11) NOT NULL,
  `WalkStyle` tinyint(4) NOT NULL,
  `BloodAlcohol` int(11) NOT NULL,
  `optShowColor` int(11) NOT NULL,
  `Freeze` int(11) NOT NULL,
  `FreezeUnix` int(11) NOT NULL,
  `WEAPONSKILL_PISTOL` int(11) NOT NULL,
  `WEAPONSKILL_PISTOL_SILENCED` int(11) NOT NULL,
  `WEAPONSKILL_DESERT_EAGLE` int(11) NOT NULL,
  `WEAPONSKILL_SHOTGUN` int(11) NOT NULL,
  `WEAPONSKILL_SAWNOFF_SHOTGUN` int(11) NOT NULL,
  `WEAPONSKILL_SPAS12_SHOTGUN` int(11) NOT NULL,
  `WEAPONSKILL_MICRO_UZI` int(11) NOT NULL,
  `WEAPONSKILL_MP5` int(11) NOT NULL,
  `WEAPONSKILL_AK47` int(11) NOT NULL,
  `WEAPONSKILL_M4` int(11) NOT NULL,
  `WEAPONSKILL_SNIPERRIFLE` int(11) NOT NULL,
  `opt_vyppasy` tinyint(4) NOT NULL,
  `trestnebody` int(11) NOT NULL DEFAULT '0',
  `zakazrizeni` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `char_pokuty`
--

CREATE TABLE `char_pokuty` (
  `Username` text CHARACTER SET utf8 COLLATE utf8_czech_ci NOT NULL,
  `Suma` mediumint(9) NOT NULL,
  `Dovod` text NOT NULL,
  `Date` int(11) NOT NULL,
  `Officer` text NOT NULL,
  `Paid` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `char_radios`
--

CREATE TABLE `char_radios` (
  `Username` text CHARACTER SET utf8 COLLATE utf8_czech_ci NOT NULL,
  `NAME` text NOT NULL,
  `URL` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `char_stats`
--

CREATE TABLE `char_stats` (
  `id` int(11) NOT NULL,
  `Username` varchar(64) NOT NULL,
  `money_work` int(11) NOT NULL,
  `money_accepted` int(11) NOT NULL,
  `money_admin` int(11) NOT NULL,
  `money_givenby` int(11) NOT NULL,
  `money_spent` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `char_trestneciny`
--

CREATE TABLE `char_trestneciny` (
  `Username` text CHARACTER SET utf8 COLLATE utf8_czech_ci NOT NULL,
  `Cin` text NOT NULL,
  `Udelil` text NOT NULL,
  `Datum` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `char_vehicles`
--

CREATE TABLE `char_vehicles` (
  `id` int(11) NOT NULL,
  `SPZ` varchar(32) NOT NULL,
  `Model` smallint(6) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `Angle` float NOT NULL,
  `VirtualWorld` mediumint(9) NOT NULL,
  `Interior` tinyint(4) NOT NULL,
  `Park_X` float NOT NULL,
  `Park_Y` float NOT NULL,
  `Park_Z` float NOT NULL,
  `Park_A` float NOT NULL,
  `Park_VW` mediumint(4) NOT NULL,
  `Park_INT` mediumint(9) NOT NULL,
  `Color_1` smallint(4) NOT NULL,
  `Color_2` smallint(4) NOT NULL,
  `Paintjob` tinyint(4) NOT NULL,
  `Siren` tinyint(4) NOT NULL,
  `Faction_Legal` tinyint(4) NOT NULL,
  `Faction_Ilegal` tinyint(4) NOT NULL,
  `MileAge` float NOT NULL,
  `Nitrous` float NOT NULL,
  `Fuel` tinyint(4) NOT NULL,
  `Battery` smallint(6) NOT NULL,
  `Health` float NOT NULL,
  `MaxHealth` float NOT NULL,
  `IsWanted` tinyint(4) NOT NULL,
  `IsWantedFor` text NOT NULL,
  `dmg_Panels` int(11) NOT NULL,
  `dmg_Doors` int(11) NOT NULL,
  `dmg_Lights` int(11) NOT NULL,
  `dmg_Tires` int(11) NOT NULL,
  `tune_Slot0` smallint(6) NOT NULL,
  `tune_Slot1` smallint(6) NOT NULL,
  `tune_Slot2` smallint(6) NOT NULL,
  `tune_Slot3` smallint(6) NOT NULL,
  `tune_Slot4` smallint(6) NOT NULL,
  `tune_Slot5` smallint(6) NOT NULL,
  `tune_Slot6` smallint(6) NOT NULL,
  `tune_Slot7` smallint(6) NOT NULL,
  `tune_Slot8` smallint(6) NOT NULL,
  `tune_Slot9` smallint(6) NOT NULL,
  `tune_Slot10` smallint(6) NOT NULL,
  `tune_Slot11` smallint(6) NOT NULL,
  `tune_Slot12` smallint(6) NOT NULL,
  `tune_Slot13` smallint(6) NOT NULL,
  `Owner` varchar(30) CHARACTER SET utf8 COLLATE utf8_czech_ci NOT NULL,
  `SecondOwner` varchar(30) CHARACTER SET utf8 COLLATE utf8_czech_ci NOT NULL,
  `isUnParked` tinyint(4) NOT NULL,
  `param_engine` tinyint(4) NOT NULL,
  `param_lights` tinyint(4) NOT NULL,
  `param_doors` tinyint(4) NOT NULL,
  `param_bonnet` tinyint(4) NOT NULL,
  `param_boot` tinyint(4) NOT NULL,
  `wind_0` tinyint(4) NOT NULL,
  `wind_1` tinyint(4) NOT NULL,
  `wind_2` tinyint(4) NOT NULL,
  `wind_3` tinyint(4) NOT NULL,
  `weapon_1` int(11) NOT NULL,
  `ammo_1` int(11) NOT NULL,
  `weapon_2` int(11) NOT NULL,
  `ammo_2` int(11) NOT NULL,
  `weapon_3` int(11) NOT NULL,
  `ammo_3` int(11) NOT NULL,
  `weed` int(11) NOT NULL,
  `weed_seed` int(11) NOT NULL,
  `pacidlo` int(11) NOT NULL,
  `lano` int(11) NOT NULL,
  `vrece` int(11) NOT NULL,
  `puta` int(11) NOT NULL,
  `rezerva` smallint(6) NOT NULL,
  `TaxameterItem` tinyint(4) NOT NULL,
  `CarRadio` tinyint(4) NOT NULL,
  `AlarmItem` tinyint(4) NOT NULL,
  `Oil` float NOT NULL,
  `Sun_LDoor` tinyint(4) NOT NULL,
  `Sun_RDoor` tinyint(4) NOT NULL,
  `Sun_Hood` tinyint(4) NOT NULL,
  `Sun_Boot` tinyint(4) NOT NULL,
  `Sun_FBumper` tinyint(4) NOT NULL,
  `Sun_RBumper` tinyint(4) NOT NULL,
  `SPZDown` tinyint(4) NOT NULL,
  `tovar_typ` int(11) NOT NULL,
  `tovar` int(11) NOT NULL,
  `drevo` int(11) NOT NULL,
  `Impounded` tinyint(4) NOT NULL,
  `Impounded_By` text NOT NULL,
  `Impounded_Date` int(11) NOT NULL,
  `Impounded_Unix` int(11) NOT NULL,
  `Impounded_Fine` int(11) NOT NULL,
  `Impounded_Reason` text NOT NULL,
  `NoBreakin` tinyint(4) NOT NULL,
  `PlexWindows` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `dealership_places`
--

CREATE TABLE `dealership_places` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `owner` text NOT NULL,
  `price` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `vw` int(11) NOT NULL,
  `interior` int(11) NOT NULL,
  `vx` float NOT NULL,
  `vy` float NOT NULL,
  `vz` float NOT NULL,
  `va` float NOT NULL,
  `multiplier` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `dealership_places`
--

INSERT INTO `dealership_places` (`id`, `name`, `owner`, `price`, `x`, `y`, `z`, `vw`, `interior`, `vx`, `vy`, `vz`, `va`, `multiplier`) VALUES
(0, 'Watson Automotive', '', 9999990, 613.209, -494.493, 16.3359, 0, 0, 641.274, -499.803, 16.1076, 268.05, 1000),
(1, 'Big Mike\'s', '', 0, 611.753, -518.343, 16.3533, 0, 0, 619.863, -524.868, 16.0289, 88.7413, 1000),
(2, 'Mr Grant\'s Bike Shed', '', 0, 701.47, -520.923, 16.3359, 0, 0, 701.587, -523.345, 16.1071, 90.1454, 1000),
(3, 'Nevada Airfield Stockade', '', 0, 414.575, 2533.63, 19.1484, 0, 0, 425.228, 2501.57, 16.9433, 89.0872, 1000),
(4, 'Peller\'s Boating', '', 0, 2156.54, -99.4672, 3.28053, 0, 0, 2106.78, -95.7777, -0.266695, 126.747, 1000),
(5, 'Bub\'s Bike Shop', '', 0, 2334.51, -67.2755, 26.4844, 0, 0, 2336.02, -69.807, 26.2642, 269.654, 1000);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `dealership_vehicles`
--

CREATE TABLE `dealership_vehicles` (
  `dealid` tinyint(4) NOT NULL,
  `model` smallint(6) NOT NULL,
  `price` int(11) NOT NULL,
  `kredity` int(11) NOT NULL,
  `donatorlevel` tinyint(4) NOT NULL,
  `recolourable` tinyint(4) NOT NULL,
  `factiontype1` tinyint(4) NOT NULL,
  `factiontype2` tinyint(4) NOT NULL,
  `factiontype3` tinyint(4) NOT NULL,
  `factiontype4` tinyint(4) NOT NULL,
  `factiontype5` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `dealership_vehicles`
--

INSERT INTO `dealership_vehicles` (`dealid`, `model`, `price`, `kredity`, `donatorlevel`, `recolourable`, `factiontype1`, `factiontype2`, `factiontype3`, `factiontype4`, `factiontype5`) VALUES
(0, 400, 46990, 0, 0, 1, 0, 0, 0, 0, 0),
(0, 401, 42990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 602, 78990, 400, 0, 0, 0, 0, 0, 0, 0),
(0, 496, 38990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 518, 34990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 527, 38990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 589, 37990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 419, 62890, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 587, 84980, 450, 0, 0, 0, 0, 0, 0, 0),
(0, 533, 48990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 526, 39890, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 474, 67990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 545, 97890, 600, 0, 0, 0, 0, 0, 0, 0),
(0, 517, 56790, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 410, 30990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 600, 32990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 436, 30290, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 439, 58890, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 549, 34990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 491, 45990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 445, 67990, 380, 0, 0, 0, 0, 0, 0, 0),
(0, 507, 78990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 585, 64990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 466, 38990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 492, 41990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 546, 45990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 551, 51990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 516, 40990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 467, 34990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 426, 89990, 350, 0, 0, 0, 0, 0, 0, 0),
(0, 547, 37990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 405, 59890, 350, 0, 0, 0, 0, 0, 0, 0),
(0, 580, 199990, 900, 0, 0, 0, 0, 0, 0, 0),
(0, 409, 349990, 1700, 0, 0, 0, 0, 0, 0, 0),
(0, 550, 40990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 566, 52990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 540, 43990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 421, 78990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 529, 41890, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 579, 99990, 350, 0, 0, 0, 0, 0, 0, 0),
(0, 404, 30090, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 489, 78990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 479, 37990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 458, 39990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 554, 82990, 350, 0, 0, 0, 0, 0, 0, 0),
(0, 478, 31290, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 543, 36990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 440, 63990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 413, 65990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 582, 45990, 0, 0, 0, 3, 4, 0, 0, 0),
(0, 418, 61990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 482, 75990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 459, 75990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 536, 89990, 400, 2, 0, 0, 0, 0, 0, 0),
(0, 575, 87990, 400, 2, 0, 0, 0, 0, 0, 0),
(0, 534, 85990, 400, 2, 0, 0, 0, 0, 0, 0),
(0, 567, 82990, 400, 2, 0, 0, 0, 0, 0, 0),
(0, 535, 90090, 400, 2, 0, 0, 0, 0, 0, 0),
(0, 576, 79990, 400, 2, 0, 0, 0, 0, 0, 0),
(0, 412, 79990, 400, 2, 0, 0, 0, 0, 0, 0),
(0, 402, 119990, 600, 0, 0, 0, 0, 0, 0, 0),
(0, 542, 42990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 603, 119990, 550, 3, 0, 0, 0, 0, 0, 0),
(0, 541, 499990, 2000, 3, 0, 0, 1, 0, 0, 0),
(0, 415, 289990, 1980, 3, 0, 0, 0, 0, 0, 0),
(0, 480, 99990, 0, 1, 0, 0, 0, 0, 0, 0),
(0, 562, 169990, 1000, 1, 0, 0, 0, 0, 0, 0),
(0, 565, 89990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 434, 79990, 400, 3, 0, 0, 0, 0, 0, 0),
(0, 411, 999990, 5000, 3, 0, 0, 0, 0, 0, 0),
(0, 559, 109990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 561, 62990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 560, 85990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 506, 209990, 0, 1, 0, 0, 0, 0, 0, 0),
(0, 451, 279990, 0, 2, 0, 0, 0, 0, 0, 0),
(0, 558, 78990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 555, 168990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 477, 68990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 483, 74990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 500, 64990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 416, 37990, 0, 0, 0, 2, 0, 0, 0, 0),
(0, 490, 79990, 0, 0, 0, 1, 2, 4, 0, 0),
(0, 528, 115990, 0, 0, 0, 1, 0, 0, 0, 0),
(0, 470, 98990, 0, 3, 0, 0, 0, 0, 0, 0),
(0, 596, 39990, 0, 0, 0, 2, 1, 0, 0, 0),
(0, 597, 39990, 0, 0, 0, 1, 2, 0, 0, 0),
(0, 598, 35990, 0, 0, 0, 1, 0, 0, 0, 0),
(0, 599, 49990, 0, 0, 0, 1, 0, 0, 0, 0),
(0, 438, 39990, 0, 0, 0, 8, 0, 0, 0, 0),
(0, 420, 45990, 0, 0, 0, 8, 0, 0, 0, 0),
(0, 525, 69990, 0, 0, 0, 1, 2, 10, 0, 0),
(1, 431, 139990, 0, 0, 0, 1, 2, 4, 0, 0),
(1, 437, 149990, 0, 0, 0, 1, 2, 4, 0, 0),
(1, 552, 89990, 0, 0, 0, 2, 0, 0, 0, 0),
(1, 433, 145990, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 427, 149990, 0, 0, 0, 1, 2, 0, 0, 0),
(1, 407, 129990, 0, 0, 0, 2, 0, 0, 0, 0),
(1, 544, 129990, 0, 0, 0, 2, 0, 0, 0, 0),
(1, 601, 299990, 0, 0, 0, 1, 0, 0, 0, 0),
(1, 428, 109990, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 499, 107890, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 609, 99990, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 578, 145990, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 455, 159990, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 414, 115590, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 456, 139990, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 581, 64990, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 462, 25990, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 521, 62990, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 463, 46990, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 461, 63990, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 468, 32590, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 586, 39990, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 471, 34990, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 571, 49990, 0, 3, 0, 0, 0, 0, 0, 0),
(2, 523, 35990, 0, 0, 0, 1, 0, 0, 0, 0),
(3, 511, 4999990, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 512, 2599990, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 593, 2099990, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 519, 4999990, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 548, 4999990, 0, 0, 0, 1, 4, 0, 0, 0),
(3, 417, 799990, 0, 0, 0, 2, 0, 0, 0, 0),
(3, 487, 1099990, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 488, 799990, 0, 0, 0, 3, 0, 0, 0, 0),
(3, 497, 799990, 0, 0, 0, 1, 0, 0, 0, 0),
(4, 472, 89990, 0, 0, 0, 1, 2, 0, 0, 0),
(4, 473, 49990, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 493, 599990, 0, 3, 0, 0, 0, 0, 0, 0),
(4, 595, 125990, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 484, 189990, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 453, 109990, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 430, 109990, 0, 0, 0, 1, 0, 0, 0, 0),
(4, 452, 167990, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 446, 96990, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 454, 219990, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 475, 65490, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 514, 119990, 600, 0, 0, 0, 0, 0, 0, 0),
(5, 509, 5990, 100, 0, 0, 0, 0, 0, 0, 0),
(5, 481, 9990, 200, 1, 0, 0, 0, 0, 0, 0),
(5, 510, 9990, 200, 2, 0, 0, 0, 0, 0, 0),
(1, 531, 20990, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `economy_overall`
--

CREATE TABLE `economy_overall` (
  `id` int(11) NOT NULL,
  `categoryid` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `value` int(11) NOT NULL,
  `value2` int(11) NOT NULL,
  `lastupdate` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `economy_overall`
--

INSERT INTO `economy_overall` (`id`, `categoryid`, `name`, `value`, `value2`, `lastupdate`) VALUES
(2, 1, 'Hrobar', 2450, 0, 1550062415),
(3, 1, 'Prenasanie krabic (PC)', 10, 71, 1549100357),
(4, 1, 'Prenasanie krabic (MG)', 10, 71, 1549100366),
(0, 1, 'null', 0, 0, 0),
(1, 1, 'null_tr', 0, 0, 1549100376),
(5, 3, 'VodicakA', 1800, 0, 1549100412),
(6, 3, 'VodicakB', 2200, 0, 1549100408),
(7, 3, 'VodicakBLow', 400, 0, 1548745089),
(8, 3, 'VodicakC', 2800, 0, 1549100417),
(9, 3, 'VodicakT', 3000, 0, 1549100421),
(10, 2, 'Nezamestnany vyplata', 200, 451, 1549100387),
(11, 2, 'Newbie bonus', 400, 0, 1549100392),
(12, 2, 'Vyplata za biznis', 0, 0, 1549899928),
(13, 4, 'Kupa auta od serveru pre bazar', 15000, 0, 1548955625),
(14, 5, 'Pridavok k loterii', 1200, 22000, 1549100446),
(15, 5, 'Dolarov za 1 gold', 32, 0, 1550868647),
(16, 6, 'Colt 45', 1290, 0, 0),
(17, 6, 'Desert Eagle', 4990, 0, 0),
(18, 6, 'Brokovnica', 7890, 0, 0),
(19, 6, 'Puska', 9990, 0, 0),
(20, 6, 'Vesta', 890, 0, 0),
(21, 1, 'Sadenie stromov (Anawalt)', 40, 61, 1549984458),
(22, 1, 'Zrezavanie stromov (Anawalt)', 110, 41, 1550062402),
(23, -1, 'Vykup dreva v ALC (dub,1ks)', 0, 0, 1551557701),
(24, -1, 'Vykup dreva v ALC (breza,1ks)', 0, 0, 1551557704),
(25, -1, 'Vykup dreva v ALC (smrek,1ks)', 0, 0, 1551557708),
(26, 5, 'Kontrakt ALC (dub,100ks)', 300, 0, 1549486256),
(27, 5, 'Kontrakt ALC (breza,100ks)', 275, 0, 1549486260),
(28, 5, 'Kontrakt ALC (smrek,100ks)', 230, 0, 1549486264),
(29, 5, 'Min. ks dreva (ALC kontrakt)', 1000, 0, 0),
(30, 5, 'Mult. ks dreva (Anawalt)', 60, 0, 1550303059),
(31, 1, 'Rozrezavanie dreva (ALC)', 185, 0, 1550062409),
(32, 1, 'Cistenie ulic', 115, 0, 0),
(33, 2, 'Bonus k vyplate (don.1)', 200, 0, 0),
(34, 2, 'Bonus k vyplate (don.2)', 400, 0, 0),
(35, 2, 'Bonus k vyplate (don.3)', 800, 0, 0),
(36, 1, 'Rozvoz pizze (fin)', 185, 0, 0),
(37, 1, 'Rozvoz pizze (tringelt)', 1, 50, 0);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `faction_vehicles`
--

CREATE TABLE `faction_vehicles` (
  `id` int(11) NOT NULL,
  `SPZ` text NOT NULL,
  `Model` smallint(11) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `Angle` float NOT NULL,
  `VirtualWorld` mediumint(11) NOT NULL,
  `Interior` tinyint(11) UNSIGNED NOT NULL,
  `Color1` tinyint(11) UNSIGNED NOT NULL,
  `Color2` tinyint(11) UNSIGNED NOT NULL,
  `Paintjob` tinyint(11) UNSIGNED NOT NULL,
  `Siren` tinyint(11) UNSIGNED NOT NULL,
  `Faction` tinyint(11) UNSIGNED NOT NULL,
  `MileAge` float NOT NULL,
  `Nitrous` float NOT NULL,
  `Fuel` smallint(6) NOT NULL,
  `Battery` smallint(6) NOT NULL,
  `Health` float NOT NULL,
  `dmg_Panels` int(11) NOT NULL,
  `dmg_Doors` int(11) NOT NULL,
  `dmg_Lights` int(11) NOT NULL,
  `dmg_Tires` int(11) NOT NULL,
  `tune_Slot0` smallint(6) NOT NULL,
  `tune_Slot1` smallint(6) NOT NULL,
  `tune_Slot2` smallint(6) NOT NULL,
  `tune_Slot3` smallint(6) NOT NULL,
  `tune_Slot4` smallint(6) NOT NULL,
  `tune_Slot5` smallint(6) NOT NULL,
  `tune_Slot6` smallint(6) NOT NULL,
  `tune_Slot7` smallint(6) NOT NULL,
  `tune_Slot8` smallint(6) NOT NULL,
  `tune_Slot9` smallint(6) NOT NULL,
  `tune_Slot10` smallint(6) NOT NULL,
  `tune_Slot11` smallint(6) NOT NULL,
  `tune_Slot12` smallint(6) NOT NULL,
  `tune_Slot13` smallint(6) NOT NULL,
  `def_Health` float NOT NULL,
  `TaxameterItem` tinyint(4) NOT NULL,
  `CarRadio` tinyint(4) NOT NULL,
  `Oil` float NOT NULL,
  `AlarmItem` tinyint(4) NOT NULL,
  `Sun_LDoor` tinyint(4) NOT NULL,
  `Sun_RDoor` tinyint(4) NOT NULL,
  `Sun_Hood` tinyint(4) NOT NULL,
  `Sun_Boot` tinyint(4) NOT NULL,
  `Sun_FBumper` tinyint(4) NOT NULL,
  `Sun_RBumper` tinyint(4) NOT NULL,
  `SPZDown` tinyint(4) NOT NULL,
  `UnitText` text NOT NULL,
  `NoBreakin` tinyint(4) NOT NULL,
  `Bazar_Price` int(11) NOT NULL,
  `Bazar_Buyout` int(11) NOT NULL,
  `Bazar_DateAdded` bigint(20) NOT NULL,
  `Bazar_AddedBy` text NOT NULL,
  `Bazar_BoughtFor` int(11) NOT NULL,
  `Bazar_Desc` text NOT NULL,
  `PlexWindows` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_actors`
--

CREATE TABLE `gm_actors` (
  `uid` smallint(6) NOT NULL,
  `Skin` smallint(6) NOT NULL,
  `Label` text NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `Angle` float NOT NULL,
  `VirtualWorld` mediumint(9) NOT NULL,
  `AnimName` varchar(32) NOT NULL,
  `AnimNumber` smallint(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_adtabula`
--

CREATE TABLE `gm_adtabula` (
  `Model` int(11) NOT NULL,
  `AssignedBiz` int(11) NOT NULL,
  `X` float NOT NULL,
  `Y` int(11) NOT NULL,
  `Z` float NOT NULL,
  `RX` float NOT NULL,
  `RY` float NOT NULL,
  `RZ` float NOT NULL,
  `VW` int(11) NOT NULL,
  `INTERIOR` int(11) NOT NULL,
  `LABEL` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_arrows`
--

CREATE TABLE `gm_arrows` (
  `id` int(11) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `VW` int(11) NOT NULL,
  `INTERIOR` int(11) NOT NULL,
  `ToX` float NOT NULL,
  `ToY` float NOT NULL,
  `ToZ` float NOT NULL,
  `ToAngle` float NOT NULL,
  `ToVW` int(11) NOT NULL,
  `ToINTERIOR` int(11) NOT NULL,
  `Label` text NOT NULL,
  `Faction` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `gm_arrows`
--

INSERT INTO `gm_arrows` (`id`, `X`, `Y`, `Z`, `VW`, `INTERIOR`, `ToX`, `ToY`, `ToZ`, `ToAngle`, `ToVW`, `ToINTERIOR`, `Label`, `Faction`) VALUES
(1, 3686.79, 1300.45, 1068.24, 10540, 0, 3691.33, 1271.04, 1066.52, 180, 10540, 0, '/enter', 0),
(2, 3691.33, 1271.04, 1066.52, 10540, 0, 3686.79, 1300.45, 1068.24, 0, 10540, 0, '/enter', 0),
(3, 3703.57, 1254.4, 851.472, 10540, 0, 3704.97, 1243, 1068.14, 180, 10540, 0, '/enter', 0),
(4, 3704.97, 1243, 1068.14, 10540, 0, 3703.57, 1254.4, 851.471, 180, 10540, 0, '/enter', 0),
(5, 1874.63, -1860.07, 13.6685, 0, 0, 1874.31, -1859.19, 13.668, 0, 0, 0, '/enter', 0),
(6, 1874.55, -1858.97, 13.6685, 0, 0, 1874.58, -1860.37, 13.668, 180, 0, 0, '/enter', 0),
(7, 1482.75, -1848.77, 3645.63, 10701, 0, 1493.49, -1791.24, 2981.35, 90, 10701, 0, '/enter', 0),
(8, 1493.49, -1791.24, 2981.35, 10701, 0, 1482.75, -1848.77, 3645.63, 270, 10701, 0, '/enter', 0),
(9, 2327.91, -1363.35, 24.0288, 0, 0, 35.207, 1669.26, 1218, 14, 13493, 0, '/enter', 0),
(10, 35.289, 1669.32, 1218, 13493, 0, 2327.81, -1362.91, 24.029, 10, 0, 0, '/enter', 0),
(12, -1842.28, 134.628, 1748.7, 12000, 0, 2048.07, -1802.69, 14.85, 180, 0, 0, '/enter', 0),
(13, 2895.54, -234.728, 7.0538, 0, 0, 2897.82, -234.663, 1.88, 270, 0, 0, '/enter', 0),
(14, 2897.82, -234.663, 1.88829, 0, 0, 2895.57, -234.728, 7.053, 90, 0, 0, '/enter', 0),
(18, 2129.96, -1761.35, 13.5625, 0, 0, 2131.5, -1763.66, 13.648, 182.259, 0, 0, '/enter', 0),
(19, 2131.5, -1763.39, 13.6484, 0, 0, 2129.9, -1759.29, 13.562, 1.002, 0, 0, '/enter', 0),
(22, 3700.36, 1235.03, 851.472, 10540, 0, 1568.65, -1690.23, 5.89, 178.99, 10540, 0, '/enter', 0),
(23, 1568.63, -1690.59, 5.89062, 10540, 0, 3700.27, 1236.72, 851.47, 359.94, 10540, 0, '/enter', 0),
(24, 1588.25, -1640.54, 13.1674, 10540, 0, 1588.52, -1630.86, 13.38, 358.056, 0, 0, '/exit', 0),
(29, 2067.26, -1196.77, 1024.15, 13005, 0, 734.376, -1362.66, 25.69, 269.14, 0, 0, '/enter', 0),
(30, 1565.28, -1665.11, 28.3956, 0, 0, 3692.97, 1251.08, 851.47, 270, 10540, 0, '/enter', 0),
(31, 3693.09, 1251.01, 851.472, 10540, 0, 1565.28, -1665.11, 28.395, 1.09, 0, 0, '/enter', 0),
(32, 305.113, -159.135, 879.577, 0, 0, 2693.58, -936.42, 1097.51, 178.321, 15252, 0, '/exit', 0),
(33, 2693.57, -936.676, 1097.51, 15252, 0, 304.79, -159.25, 879.577, 99.275, 0, 0, '/enter', 0),
(34, -1855.79, 744.145, 1498.17, 13878, 0, 1074.46, -1113.22, 24.337, 272.01, 0, 0, '/exit', 0),
(36, 2318.4, -1324.35, 1233.44, 10550, 0, -60.77, -1576.93, 2.61, 225.98, 0, 0, '/exit', 0),
(37, 2337.92, -1337.6, 1233.44, 10550, 0, 1568.73, -1690.57, 5.89, 17.803, 10550, 0, '/enter', 0),
(39, 1568.64, -1689.97, 6.21875, 10550, 0, 2338.31, -1337.5, 1233.43, 269.22, 10550, 0, '/enter', 0),
(42, 1505.07, 2393.32, 971.18, 0, 59, 1446.23, -1469.32, 13.3717, 268.165, 0, 0, '/enter', 0),
(43, 1444.3, -1468.87, 13.3685, 0, 0, 1505, 2393.29, 971.18, 359.177, 0, 13371, '/enter', 0),
(47, 3703.57, 1254.4, 851.472, 12347, 0, 3704.99, 1243.72, 1068.14, 0, 12347, 0, '/enter', 0),
(48, -2187.28, 643.404, 2001.09, 18391, 0, -2207.05, 651.804, 2005.85, 90, 18391, 0, '/enter', 0),
(49, -2207.08, 651.797, 2005.85, 18391, 0, -2187.28, 643.403, 2001.08, 0, 18391, 0, '/enter', 0),
(50, 53.9791, 1667.38, 1222.09, 12298, 0, 53.851, 1667.4, 1218, 90, 12298, 0, '/enter', 0),
(51, 53.851, 1667.4, 1218, 12298, 0, 53.979, 1667.38, 1222.09, 90, 12298, 0, '/enter', 0),
(52, 1233.2, 297.167, 19.5547, 0, 0, 1583.38, -1639.11, 13.27, 0, 6, 0, '/enter', 0),
(53, 1583.38, -1639.11, 13.2778, 6, 0, 1232.92, 297.278, 19.554, 66.25, 0, 0, '/enter', 0),
(66, 1483.96, 1328.78, 280.906, 16988, 0, 1216.74, 490.311, 20.234, 62, 0, 0, '/exit', 2),
(67, 1216.74, 490.311, 20.2345, 0, 0, 1483.95, 1328.78, 280.906, 0, 16988, 0, '/enter', 2),
(68, 1486.35, 1341.04, 280.908, 16988, 0, 1484.65, 1341.02, 280.906, 90, 16988, 0, '/exit', 2),
(69, 1484.6, 1341.16, 280.906, 16988, 0, 1486.35, 1341.02, 280.9, 270, 16988, 0, '/enter', 2),
(70, 1487.08, 1331.33, 280.908, 16988, 0, 1484.82, 1331.34, 280.9, 90, 16988, 0, '/exit', 2),
(71, 1484.82, 1331.34, 280.906, 16988, 0, 1487.07, 1331.33, 280.9, 270, 16988, 0, '/enter', 2),
(72, -593.735, 2020.05, 60.3828, 0, 0, -591.186, 1991.1, 9.25, 165.283, 0, 0, '/enter', 0),
(73, -591.344, 1990.98, 9.25, 0, 0, -593.348, 2020.32, 60.382, 328.362, 0, 0, '/exit', 0);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_atms`
--

CREATE TABLE `gm_atms` (
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `RX` float NOT NULL,
  `RY` float NOT NULL,
  `RZ` float NOT NULL,
  `VW` int(11) NOT NULL,
  `Interior` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `gm_atms`
--

INSERT INTO `gm_atms` (`X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `VW`, `Interior`) VALUES
(2257.31, 32.2704, 26.1009, 0, 0, -178.403, 0, 0),
(1369.19, 703.044, 3026.37, 0, 0, 181.807, 17898, 0),
(2303.58, -9.74197, 26.1109, 0, 0, 270.458, 0, 0),
(661.364, -563.074, 15.9859, 0, 0, -90.2281, 0, 0),
(-180.517, 1053.05, 19.3622, 0, 0, 271.453, 0, 0),
(-211.445, 1210.2, 19.4622, 0, 0, 0.33862, 0, 0),
(1389.39, 462.843, 19.8409, 0, 0, -23.9935, 0, 0),
(252.975, -62.1655, 1.19813, 0, 0, -0.326063, 0, 0),
(2246.78, -87.5322, 26.0803, 0, 0, 89.2241, 0, 0),
(1404.02, 236.964, 19.1647, 0, 0, 243.333, 0, 0),
(1299.42, 310.729, 19.0847, 0, 0, 157.949, 0, 0),
(142.47, -174.735, 1.16813, 0, 0, 268.046, 0, 0),
(242.569, -172.188, 1.16813, 0, 0, 271.806, 0, 0),
(621.243, -494.762, 15.9359, 0, 0, 179.426, 0, 0),
(1808.31, -1356.2, 15.4262, 0, 146.6, 91.0385, 0, 0),
(-75.635, -1177.12, 1.52236, 0, 0, 242.666, 0, 0);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_bankaccs`
--

CREATE TABLE `gm_bankaccs` (
  `id` int(11) NOT NULL,
  `AccID` int(11) NOT NULL,
  `Owner` varchar(32) NOT NULL,
  `PIN` int(11) NOT NULL,
  `Cash` float NOT NULL,
  `Block` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_businesses`
--

CREATE TABLE `gm_businesses` (
  `Name` tinytext NOT NULL,
  `Owner` tinytext CHARACTER SET utf8 COLLATE utf8_czech_ci NOT NULL,
  `SecOwner` tinytext NOT NULL,
  `PosX` float NOT NULL,
  `PosY` float NOT NULL,
  `PosZ` float NOT NULL,
  `PosAngle` float NOT NULL,
  `PosVirtualWorld` smallint(6) NOT NULL,
  `PosInterior` smallint(6) NOT NULL,
  `VirtualWorld` smallint(6) NOT NULL,
  `InteriorID` tinyint(4) NOT NULL,
  `IsLocked` tinyint(4) NOT NULL,
  `MusicAddress` text NOT NULL,
  `BuyPrice` int(11) NOT NULL,
  `BusinessType` tinyint(4) NOT NULL,
  `EntryFee` smallint(6) NOT NULL,
  `Storage` int(11) NOT NULL,
  `Tovar` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `gm_businesses`
--

INSERT INTO `gm_businesses` (`Name`, `Owner`, `SecOwner`, `PosX`, `PosY`, `PosZ`, `PosAngle`, `PosVirtualWorld`, `PosInterior`, `VirtualWorld`, `InteriorID`, `IsLocked`, `MusicAddress`, `BuyPrice`, `BusinessType`, `EntryFee`, `Storage`, `Tovar`) VALUES
('Palomino Creek Tosser', 'Ne', 'Ne', 2250.77, 32.9677, 26.4909, 177.154, 0, 0, 17424, 84, 0, '', 121487, 4, 50, 8276, 625),
('Palomino Creek Town Hall', 'Ne', 'Ne', 2269.72, -74.7481, 26.7724, 0.409261, 0, 0, 19340, 86, 0, '', 0, 1, 0, 0, 0),
('Greenlake Savings', 'Ne', 'Ne', 2303.23, -16.1528, 26.4909, 270.459, 0, 0, 17898, 68, 0, '', -1, 1, 0, 75, 0),
('Wilson\'s General Store', 'Ne', 'Ne', 2246.5, 50.2085, 26.4909, 0.409739, 0, 0, 10069, 39, 1, '', 89087, 1, 0, 1381, 0),
('Matterson\'s Butcher Shop', 'Ne', 'Ne', 2260.33, 50.4051, 26.4909, 0.722534, 0, 0, 18980, 61, 0, '', 68837, 1, 0, 0, 0),
('Rusty Brown Donuts', 'Ne', 'Ne', 2277.78, 50.831, 26.4909, 1.34901, 0, 0, 12669, 11, 0, '', 118787, 1, 0, 253, 0),
('Little Lady Sex Shop', 'Ne', 'Ne', 2302.8, 14.151, 26.4909, 272.385, 0, 0, 15571, 7, 0, '', 94487, 1, 0, 243, 0),
('Duck\'s Clothing Store', 'Ne', 'Ne', 2303.63, 30.9225, 26.4909, 271.131, 0, 0, 10351, 56, 0, '', 114737, 2, 0, 5378, 0),
('Fleisch and Bier', 'Ne', 'Ne', 2333.92, -18.4132, 26.4844, 41.479, 0, 0, 18152, 67, 1, '', 89087, 1, 0, 0, 0),
('Palomino Creek Ammu-Nation', 'Ne', 'Ne', 2334.62, 61.6268, 26.4839, 90.9627, 0, 0, 15643, 46, 0, '', 134987, 5, 50, 1618, 49951),
('The Well Stacked Pizza', 'Ne', 'Ne', 2334.46, 74.998, 26.4841, 88.4561, 0, 0, 10821, 10, 0, '', 93137, 1, 0, 1716, 0),
('Prázdna budova (50000$)', 'Ne', 'Ne', 2302.64, 56.295, 26.4909, 273.011, 0, 0, 19760, 59, 1, '', 67500, 1, 0, 0, 0),
('Prázdny objekt (35000$)', 'Ne', 'Ne', 2273.5, 82.667, 26.4844, 181.854, 0, 0, 10352, 59, 1, '', 47250, 1, 0, 0, 0),
('Prázdny objekt (35000$)', 'Ne', 'Ne', 2251.91, 81.0056, 26.7037, 179.972, 0, 0, 19127, 59, 1, '', 47250, 1, 0, 0, 0),
('Prázdny objekt (35000$)', 'Ne', 'Ne', 2235.96, 80.9697, 26.7037, 181.54, 0, 0, 11342, 59, 1, '', 47250, 1, 0, 0, 0),
('Bailey\'s Pub', 'Ne', 'Ne', 2334.86, 55.4147, 26.4835, 90.9861, 0, 0, 15735, 50, 0, '', 40500, 1, 75, 0, 49944),
('Vice Governor\'s Office', 'Ne', 'Ne', 2334.68, 42.9305, 26.4838, 89.1061, 0, 0, 16655, 59, 1, 'https://vocaroo.com/media_command.php?media=s0wWyKz2P51I&command=download_mp3', 67500, 1, 0, 0, 0),
('Prázdny objekt (60000$)', 'Ne', 'Ne', 2333.42, 30.9681, 26.6752, 89.7328, 0, 0, 15941, 59, 1, '', 81000, 1, 0, 0, 0),
('Hamilton\'s Electro World', 'Ne', 'Ne', 2333.79, 18.8095, 26.4766, 90.9862, 0, 0, 19692, 92, 0, '', 47250, 1, 75, 2878, 50000),
('Prázdny objekt (25000$)', 'Ne', 'Ne', 2302.88, -49.6372, 26.4844, 270.842, 0, 0, 12245, 59, 1, '', 33750, 1, 0, 0, 0),
('Prázdny objekt', 'Ne', 'Ne', 2303.33, -61.2769, 26.4844, 270.529, 0, 0, 10322, 0, 0, '', 33750, 1, 0, 0, 0),
('Prázdny objekt (25000$)', 'Ne', 'Ne', 2303.24, -68.6682, 26.4844, 269.902, 0, 0, 19424, 59, 1, '', 33750, 1, 0, 0, 0),
('Prázdny objekt (25000$)', 'Ne', 'Ne', 2331.33, -37.2748, 26.4844, 181.854, 0, 0, 11130, 59, 1, '', 33750, 1, 0, 0, 0),
('Trafika u Rùže', 'Ne', 'Ne', 2322.42, -37.5548, 26.4844, 181.541, 0, 0, 15409, 58, 0, 'NEJLEPŠÍ SONGA ZMRDI', 33750, 1, 75, 605, 549950),
('Swoop Taxi Service', 'Ne', 'Ne', 2418.92, 83.3994, 26.598, 272.699, 0, 0, 16029, 81, 0, '', 0, 5, 0, 0, 0),
('Palomino Creek Block 1', 'Ne', 'Ne', 2284.47, 72.011, 26.4909, 93.3385, 0, 0, 18225, 75, 0, '', -1, 1, 0, 0, 0),
('Vortex Insurance Company', 'Ne', 'Ne', 2265.14, 82.1145, 26.4844, 181.386, 0, 0, 18680, 59, 0, '', 33750, 1, 75, 1650, 0),
('Church of Cartwell', 'Ne', 'Ne', 2256.69, -44.2681, 26.6834, 180.759, 0, 0, 10137, 59, 0, '', 0, 1, 0, 0, 0),
('Palomino Creek Block 2', 'Ne', 'Ne', 2303.5, -42.2846, 26.4844, 269.723, 0, 0, 17044, 87, 0, '', 0, 1, 0, 0, 0),
('San Andreas Sheriff\'s Department', 'Ne', 'Ne', 630.017, -571.617, 16.3359, 91.4692, 0, 0, 12347, 76, 0, '', 0, 5, 0, 684, 0),
('Dillimore Gas', 'Ne', 'Ne', 660.608, -570.84, 16.3359, 270.662, 0, 0, 15818, 84, 0, '', 93137, 4, 75, 5433, 880),
('Burger Shot', 'Ne', 'Ne', 664.734, -548.013, 16.3359, 181.048, 0, 0, 13029, 20, 0, '', 75587, 1, 0, 192, 0),
('Prázdny objekt (30000$)', 'Ne', 'Ne', 691.261, -583.534, 16.3281, 274.085, 0, 0, 15907, 59, 1, '', 40500, 1, 0, 0, 0),
('Prázdny objekt (30000$)', 'Ne', 'Ne', 672.324, -627.78, 16.3359, 91.4103, 0, 0, 19496, 59, 1, '', 40500, 1, 0, 0, 0),
('Prázdny objekt (30000$)', 'Ne', 'Ne', 672.063, -646.722, 16.3359, 91.7236, 0, 0, 19331, 59, 0, '', 40500, 1, 0, 0, 0),
('Prázdny objekt (30000$)', 'Ne', 'Ne', 690.929, -633.224, 16.3359, 271.868, 0, 0, 19056, 59, 0, '', 40500, 1, 0, 0, 0),
('Prázdny objekt (30000$)', 'Ne', 'Ne', 691.362, -640.519, 16.3221, 269.988, 0, 0, 14357, 59, 0, '', 40500, 1, 0, 0, 0),
('Prázdny objekt (30000$)', 'Ne', 'Ne', 691.203, -621.539, 16.3359, 271.242, 0, 0, 16093, 59, 1, '', 40500, 1, 0, 0, 0),
('Marco\'s Bistro', 'Ne', 'Ne', 691.362, -614.122, 16.3359, 269.989, 0, 0, 13461, 83, 0, '', 89087, 1, 0, 20, 0),
('Prázdny objekt (30000$)', 'Ne', 'Ne', 695.044, -499.474, 16.3359, 179.748, 0, 0, 18630, 59, 1, '', 40500, 1, 0, 0, 0),
('Prázdny objekt (30000$)', 'Ne', 'Ne', 701.772, -494.252, 16.3359, 181.001, 0, 0, 15000, 59, 1, '', 40500, 1, 0, 0, 0),
('Prázdny objekt (30000$)', 'Ne', 'Ne', 712.787, -498.971, 16.3359, 90.7604, 0, 0, 17569, 59, 1, '', 40500, 1, 0, 0, 0),
('Harris Barber Shop', 'Ne', 'Ne', 672.611, -496.916, 16.3359, 90.1338, 0, 0, 16033, 4, 0, '', 47912, 1, 75, 150, 0),
('The Welcome Pump', 'Ne', 'Ne', 681.647, -475.926, 16.3359, 0.519641, 0, 0, 14322, 33, 0, '', 118787, 1, 0, 47, 0),
('Sub Urban', 'Ne', 'Ne', 671.639, -519.96, 16.3359, 44.7001, 0, 0, 10747, 17, 0, '', 87737, 2, 0, 820, 0),
('Prázdny objekt (26000$)', 'Ne', 'Ne', 648.783, -519.964, 16.5537, 0.519641, 0, 0, 11153, 59, 0, '', 35100, 1, 0, 0, 0),
('Prázdny objekt (100000$)', 'Ne', 'Ne', 854.57, -603.966, 18.4219, 178.307, 0, 0, 11244, 59, 1, '', 135000, 1, 0, 0, 0),
('Prázdny objekt (50000$)', 'Ne', 'Ne', 823.558, -576.031, 16.3359, 88.4024, 0, 0, 10316, 59, 1, '', 67500, 1, 0, 0, 0),
('Prázdny objekt (50000$)', 'Ne', 'Ne', 822.748, -557.199, 16.3359, 90.5958, 0, 0, 19879, 59, 1, '', 67500, 1, 0, 0, 0),
('Prázdny objekt (50000$)', 'Ne', 'Ne', 801.008, -574.054, 16.3359, 268.884, 0, 0, 16006, 59, 1, '', 67500, 1, 0, 0, 0),
('General Store', 'Ne', 'Ne', 690.493, -546.765, 16.3359, 269.824, 0, 0, 14138, 9, 0, '', 87737, 1, 0, 3266, 0),
('Underground Cobra Gym', 'Ne', 'Ne', 1360.35, 206.762, 19.5547, 157.537, 0, 0, 17934, 1, 0, '', 106637, 5, 75, 225, 0),
('Prázdny objekt (30000$)', 'Ne', 'Ne', 1345.08, 214.715, 19.5469, 157.223, 0, 0, 11698, 59, 1, '', 40500, 1, 0, 0, 0),
('Prázdny objekt (30000$)', 'Ne', 'Ne', 1340.67, 216.998, 19.5547, 156.91, 0, 0, 18938, 59, 1, '', 40500, 1, 0, 0, 0),
('Prázdny objekt (30000$)', 'Ne', 'Ne', 1331.87, 220.502, 19.5547, 154.717, 0, 0, 12113, 59, 1, '', 40500, 1, 0, 0, 0),
('Prázdny objekt (30000$)', 'Ne', 'Ne', 1325.32, 223.619, 19.5547, 154.403, 0, 0, 12895, 59, 1, '', 40500, 1, 0, 0, 0),
('Prázdny objekt (30000$)', 'Ne', 'Ne', 1311.71, 229.153, 19.5547, 154.403, 0, 0, 16635, 59, 1, '', 40500, 1, 0, 0, 0),
('Rasc\' Restaurant 18', 'Ne', 'Ne', 1294.49, 236.13, 19.5547, 197.644, 0, 0, 16130, 83, 0, '', 30000, 1, 75, 675, 0),
('Caine Motel', 'Ne', 'Ne', 1274.22, 238.106, 19.5547, 66.9822, 0, 0, 17349, 70, 0, '', 67500, 1, 75, 2100, 0),
('Prázdny objekt (50000$)', 'Ne', 'Ne', 1268.01, 224.572, 19.5547, 65.1022, 0, 0, 17267, 59, 1, '', 67500, 1, 0, 0, 0),
('Grocery Store', 'Ne', 'Ne', 1259.14, 203.805, 19.5547, 66.3555, 0, 0, 18843, 57, 0, '', 87197, 1, 0, 6310, 0),
('Starbucks Coffee', 'Ne', 'Ne', 1244.12, 204, 19.6454, 337.368, 0, 0, 10823, 55, 0, '', 114197, 1, 0, 38, 0),
('Hardware Store', 'Ne', 'Ne', 1238.81, 235.283, 19.5547, 247.754, 0, 0, 14533, 77, 0, '', 129587, 5, 0, 1736, 0),
('Prázdny objekt (20000$)', 'Ne', 'Ne', 1256.24, 274.246, 19.5547, 337.055, 0, 0, 13144, 59, 1, '', 27000, 1, 0, 0, 0),
('Prázdny objekt (20000$)', 'Ne', 'Ne', 1261.57, 271.451, 19.5547, 337.055, 0, 0, 17152, 59, 0, '', 27000, 1, 0, 0, 0),
('Inside Track Betting', 'Ne', 'Ne', 1289.41, 270.965, 19.5547, 66.9823, 0, 0, 10106, 78, 0, '', 202487, 5, 0, 42, 0),
('Prázdny objekt (40000$)', 'Ne', 'Ne', 1296.42, 287.623, 19.5469, 66.3556, 0, 0, 17803, 59, 1, '', 54000, 1, 0, 0, 0),
('Prázdny objekt (40000$)', 'Ne', 'Ne', 1303.59, 305.279, 19.5469, 67.9223, 0, 0, 18854, 59, 1, '', 54000, 1, 0, 0, 0),
('Prázdny objekt (70000$)', 'Ne', 'Ne', 1311.22, 329.329, 19.9141, 24.296, 0, 0, 12520, 59, 1, '', 94500, 1, 0, 0, 0),
('Prázdny objekt (15000$)', 'Ne', 'Ne', 1288.2, 316.234, 19.5547, 156.596, 0, 0, 15889, 0, 1, '', 20250, 1, 5, 5, 0),
('Prázdny objekt (15000$)', 'Ne', 'Ne', 1276.81, 321.298, 19.5547, 156.596, 0, 0, 11896, 59, 1, '', 20250, 1, 0, 0, 0),
('Prázdny objekt (150000$)', 'Ne', 'Ne', 1252.8, 351.469, 19.5547, 339.248, 0, 0, 13748, 59, 1, '', 202500, 1, 0, 0, 0),
('Prázdny objekt (50000$)', 'Ne', 'Ne', 1235.16, 360.194, 19.5547, 335.802, 0, 0, 17643, 59, 1, '', 67500, 1, 0, 0, 0),
('Prázdny objekt (50000$)', 'Ne', 'Ne', 1277.63, 370.622, 19.5547, 68.2358, 0, 0, 15890, 59, 1, '', 67500, 1, 0, 0, 0),
('Prázdny objekt (50000$)', 'Ne', 'Ne', 1285.09, 385.549, 19.5547, 67.609, 0, 0, 12030, 59, 1, '', 67500, 1, 0, 0, 0),
('Prázdny objekt (50000$)', 'Ne', 'Ne', 1303.36, 363.062, 19.6882, 157.827, 0, 0, 10827, 59, 1, '', 67500, 1, 0, 0, 0),
('Prázdny objekt (40000$)', 'Ne', 'Ne', 1322.15, 352.414, 19.5547, 64.7656, 0, 0, 14267, 59, 1, '', 54000, 1, 0, 0, 0),
('Prázdny objekt (30000$)', 'Ne', 'Ne', 1320.73, 296.542, 19.5547, 245.561, 0, 0, 10273, 59, 1, '', 40500, 1, 0, 0, 0),
('Prázdny objekt (30000$)', 'Ne', 'Ne', 1315.89, 285.954, 19.5547, 244.934, 0, 0, 12762, 59, 1, '', 40500, 1, 0, 0, 0),
('Prázdny objekt (30000$)', 'Ne', 'Ne', 1313.16, 279.119, 19.5547, 246.814, 0, 0, 15803, 59, 1, '', 40500, 1, 0, 0, 0),
('The Well Stacked Pizza', 'Ne', 'Ne', 1364.74, 249.553, 19.5669, 247.441, 0, 0, 19053, 10, 0, '', 202487, 1, 0, 721, 0),
('Locals Only!', 'Ne', 'Ne', 1356.18, 305.773, 19.5547, 338.622, 0, 0, 13529, 24, 0, '', 102587, 2, 0, 1315, 0),
('Prázdny objekt (50000$)', 'Ne', 'Ne', 1373.57, 298.309, 19.5547, 337.682, 0, 0, 15495, 59, 1, '', 67500, 1, 0, 0, 0),
('Montgomery Electronics', 'Ne', 'Ne', 1401.95, 284.918, 19.5547, 338.622, 0, 0, 13077, 92, 0, '', 107987, 1, 0, 3030, 0),
('Prázdny objekt (80000$)', 'Ne', 'Ne', 1414.16, 262.139, 19.5547, 248.068, 0, 0, 15819, 59, 1, '', 108000, 1, 0, 0, 0),
('Autoškola', 'Ne', 'Ne', 1403.8, 239.638, 19.5547, 246.188, 0, 0, 16468, 49, 0, '', 0, 4, 0, 0, 0),
('Montgomery Gas Station', 'Ne', 'Ne', 1383.2, 465.147, 20.1965, 338.367, 0, 0, 19690, 84, 0, '', 102587, 4, 75, 3625, 0),
('San Andreas Network News', 'Ne', 'Ne', 1371.32, 406.003, 19.7578, 247.5, 0, 0, 16188, 80, 0, '', 0, 5, 0, 0, 0),
('Prázdný objekt (150000$)', 'Ne', 'Ne', 1351.77, 348.534, 20.4559, 247.187, 0, 0, 12880, 59, 1, '', 202500, 1, 0, 0, 0),
('Clarkwell\'s Farm', 'Ne', 'Ne', 1902.65, 177.814, 37.1434, 82.4748, 0, 0, 16610, 0, 0, '', 337487, 5, 0, 0, 0),
('Chapman\'s Farm', 'Ne', 'Ne', 1548.57, 37.1845, 24.1406, 150.855, 0, 0, 18428, 0, 0, '', 674987, 5, 0, 0, 0),
('Beacon Hill Farm', 'Ne', 'Ne', -380.791, -1059.19, 59.0103, 266.712, 0, 0, 16121, 0, 0, '', 539987, 5, 0, 0, 0),
('The Truth\'s Farm', 'Ne', 'Ne', -1095.45, -1627.26, 76.3672, 89.5686, 0, 0, 17773, 0, 0, '', 674987, 5, 0, 0, 0),
('Angel Pine Junkyard', 'Ne', 'Ne', -1935.59, -1788.27, 31.5401, 351.856, 0, 0, 14367, 0, 0, '', 364487, 5, 0, 0, 0),
('LOCALS ONLY!', 'Ne', 'Ne', 273.894, -158.061, 1.57812, 89.5377, 0, 0, 16958, 6, 0, '', 47237, 2, 0, 800, 0),
('Prázdny objekt (35000$)', 'Ne', 'Ne', 273.897, -180.624, 1.57812, 89.5378, 0, 0, 17215, 59, 1, '', 47250, 1, 0, 0, 0),
('Prázdny objekt (35000$)', 'Ne', 'Ne', 273.4, -195.513, 1.57045, 89.5378, 0, 0, 17687, 59, 1, '', 47250, 1, 0, 0, 0),
('Milwaukee Restaurant', 'Ne', 'Ne', 292.044, -195.486, 1.57812, 271.563, 0, 0, 14702, 62, 0, '', 47250, 1, 0, 0, 0),
('Zchátralá pizzérie', 'Ne', 'Ne', 203.508, -203.375, 1.57812, 0.84, 0, 0, 19437, 59, 1, '', 0, 1, 0, 0, 0),
('Ammu Nation', 'Ne', 'Ne', 241.801, -178.411, 1.57812, 271.54, 0, 0, 14302, 12, 0, '', 148487, 5, 50, 5071, 2648),
('Motorcycle Pub', 'Ne', 'Ne', 172.882, -151.827, 1.57812, 134.612, 0, 0, 18391, 65, 0, '', 80987, 1, 0, 116, 0),
('Prázdny objekt (90000$)', 'Ne', 'Ne', 172.8, -201.743, 1.57031, 46.2509, 0, 0, 15435, 59, 1, '', 121500, 1, 0, 0, 0),
('Liquor Store', 'Ne', 'Ne', 256.172, -63.8812, 1.57812, 3.61417, 0, 0, 15437, 0, 0, '', 39137, 1, 75, 0, 0),
('Old Warehouse', 'Ne', 'Ne', 207.769, -64.2492, 1.57812, 359.227, 0, 0, 16114, 53, 0, '', 0, 5, 0, 0, 0),
('Montgomery Crippen Memorial', 'Ne', 'Ne', 1243.4, 330.735, 19.5547, 156.667, 0, 0, 16238, 97, 0, '', 0, 5, 0, 0, 0),
('Hilltop Farm ', 'Ne', 'Ne', 1035.7, -361.732, 73.8979, 186.175, 0, 0, 18039, 0, 0, '', 350987, 1, 0, 0, 0),
('Buck\'s Coffee', 'Ne', 'Ne', 2334.86, 4.466, 26.4835, 82.8636, 0, 0, 12668, 0, 0, '', 67487, 1, 0, 0, 100),
('Montgomery Pine Complex', 'Ne', 'Ne', 1309.2, 381.231, 19.5625, 333.637, 0, 0, 15744, 75, 0, '', 0, 1, 0, 50, 0),
('Montgomery Birch Complex', 'Ne', 'Ne', 1338.15, 381.107, 19.5625, 68.8914, 0, 0, 19752, 87, 0, '', 0, 1, 0, 0, 0),
('Bone County Sheriff\'s Department', 'Ne', 'Ne', -216.566, 979.221, 19.4964, 89.9374, 0, 0, 10867, 94, 0, '', 0, 5, 0, 0, 0),
('Fort Carson Medical Center', 'Ne', 'Ne', -315.918, 1055.54, 19.7428, 181.455, 0, 0, 13940, 0, 1, '', 0, 5, 0, 0, 0),
('Fort Carson Diner', 'Ne', 'Ne', -53.8508, 1189.56, 19.359, 181.638, 0, 0, 15237, 62, 0, '', 74237, 1, 0, 84, 0),
('Black Devils', 'Ne', 'Ne', -19.2028, 1175.59, 19.5634, 181.638, 0, 0, 15378, 93, 0, '', 141737, 1, 0, 0, 0),
('Rusty Brown Donuts', 'Ne', 'Ne', -143.967, 1221.89, 19.8992, 0.529341, 0, 0, 16768, 11, 0, '', 175487, 1, 0, 57, 0),
('Prázdny objekt (20000$)', 'Ne', 'Ne', -206.136, 1212.22, 19.8903, 90.7702, 0, 0, 19841, 0, 0, '', 27000, 1, 0, 0, 0),
('Prázdny objekt (50000$)', 'Ne', 'Ne', -145.829, 1173.38, 19.7413, 180.071, 0, 0, 16630, 0, 0, '', 67500, 1, 0, 0, 0),
('Prázdny objekt (20000$)', 'Ne', 'Ne', -126.992, 1188.81, 19.7418, 179.444, 0, 0, 18060, 0, 0, '', 27000, 1, 0, 0, 0),
('Prázdny objekt (50000$)', 'Ne', 'Ne', -92.4995, 1190.71, 19.7418, 178.505, 0, 0, 13636, 0, 0, '', 67500, 1, 0, 0, 0),
('Prázdny objekt (20000$)', 'Ne', 'Ne', -182.002, 1186.5, 19.7491, 271.228, 0, 0, 13489, 0, 0, '', 27000, 1, 0, 0, 0),
('Prázdny objekt (20000$)', 'Ne', 'Ne', -182.249, 1177.53, 19.7413, 270.602, 0, 0, 12621, 0, 0, '', 27000, 1, 0, 0, 0),
('Prázdny objekt (20000$)', 'Ne', 'Ne', -182.293, 1163.28, 19.7491, 270.915, 0, 0, 19784, 0, 0, '', 27000, 1, 0, 0, 0),
('Prázdny objekt (20000$)', 'Ne', 'Ne', -181.696, 1133.04, 19.7413, 270.288, 0, 0, 11001, 0, 0, '', 27000, 1, 0, 0, 0),
('Prázdny objekt (50000$)', 'Ne', 'Ne', -177.76, 1110.68, 19.7413, 316.012, 0, 0, 10837, 0, 0, '', 67500, 1, 0, 0, 0),
('Prázdny objekt (20000$)', 'Ne', 'Ne', -180.669, 1088.54, 19.7413, 224.855, 0, 0, 18633, 0, 0, '', 27000, 1, 0, 0, 0),
('Prázdny objekt (20000$)', 'Ne', 'Ne', -181.508, 1063.29, 19.7421, 269.662, 0, 0, 10415, 0, 0, '', 27000, 1, 0, 0, 0),
('Prázdny objekt (20000$)', 'Ne', 'Ne', -204.042, 1033.06, 19.7413, 89.8074, 0, 0, 16576, 0, 0, '', 27000, 1, 0, 0, 0),
('Prázdny objekt (20000$)', 'Ne', 'Ne', -204.777, 1053.56, 19.7413, 91.6874, 0, 0, 17165, 0, 0, '', 27000, 1, 0, 0, 0),
('Prázdny objekt (20000$)', 'Ne', 'Ne', -204.473, 1062.34, 19.7413, 89.1807, 0, 0, 14298, 0, 0, '', 27000, 1, 0, 0, 0),
('Hells Hole Pub', 'Ne', 'Ne', -204.748, 1089.14, 19.7335, 135.241, 0, 0, 18255, 99, 0, 'http://usa17.fastcast4u.com:5784/stream/1/', 27000, 1, 25, 576, 298),
('Prázdny objekt (20000$)', 'Ne', 'Ne', -204.471, 1137.77, 19.7413, 90.7473, 0, 0, 19828, 0, 0, '', 27000, 1, 0, 0, 0),
('Prázdny objekt (20000$)', 'Ne', 'Ne', -204.58, 1144.23, 19.7413, 89.8073, 0, 0, 15967, 0, 0, '', 27000, 1, 0, 0, 0),
('Prázdny objekt (20000$)', 'Ne', 'Ne', -203.943, 1152.93, 19.7413, 91.6873, 0, 0, 12196, 0, 0, '', 27000, 1, 0, 0, 0),
('Electroworld', 'Ne', 'Ne', -204.084, 1172.12, 19.7413, 90.4339, 0, 0, 12793, 92, 0, '', 121487, 1, 0, 112, 0),
('Prázdny objekt (20000$)', 'Ne', 'Ne', -203.486, 1183.42, 19.7413, 92.6272, 0, 0, 16960, 0, 0, '', 27000, 1, 0, 0, 0),
('Grocery&Liqour Store', 'Ne', 'Ne', -181.531, 1034.72, 19.7421, 271.856, 0, 0, 15948, 57, 0, '', 87737, 1, 0, 1228, 0),
('Grocery Store', 'Ne', 'Ne', -600.302, -1076.76, 23.5963, 52.8728, 0, 0, 18252, 57, 0, '', 161987, 1, 0, 16660, 0),
('Information Centre', 'Ne', 'Ne', -591.733, -1063.78, 23.7452, 55.3794, 0, 0, 15486, 59, 0, '', 0, 1, 0, 30, 0),
('Duck\'s Clothing', 'Ne', 'Ne', -582.911, -1046.55, 23.748, 54.7526, 0, 0, 12019, 56, 0, '', 215987, 2, 0, 1890, 0),
('MnB Electronics', 'Ne', 'Ne', -596.832, -1070.79, 23.7452, 54.7995, 0, 0, 15569, 44, 0, '', 175487, 3, 0, 25170, 0),
('McCormick\'s Burgeria', 'Ne', 'Ne', -587.486, -1057.01, 23.7452, 52.9194, 0, 0, 12992, 62, 0, '', 106637, 1, 0, 88, 0),
('Ammu Nation', 'Ne', 'Ne', -315.492, 829.827, 14.2421, 88.4562, 0, 0, 13068, 46, 0, '', 229487, 5, 0, 18495, 49999),
('Hayes\' Home Service', 'Ne', 'Ne', 2186.32, -38.3305, 28.154, 357.996, 0, 0, 12934, 81, 0, '', 0, 4, 0, 598, 2),
('?????', 'Ne', 'Ne', 64.8963, 1005.69, 13.7312, 181.33, 0, 0, 11475, 63, 0, '', 0, 5, 0, 0, 0),
('?????', 'Ne', 'Ne', 1272.91, 384.671, 19.5547, 336.169, 0, 0, 13593, 63, 0, '', 0, 5, 0, 880864, 0),
('Red County Fire Department', 'Ne', 'Ne', 1233.42, 506.362, 20.2345, 151.319, 0, 0, 16988, 82, 0, '', 0, 5, 0, 115, 0),
('Pentagon Club', 'Ne', 'Ne', 202.46, -35.0116, 2.57031, 87.2006, 0, 0, 13972, 95, 1, 'https://cao.oeaa.cc/2136a3bfaf3bb16580799eae22c53aeb/uFAWIKVThjA', 0, 1, 75, 675, 193),
('Grocery Store', 'Ne', 'Ne', 143.332, -201.354, 1.57812, 316.95, 0, 0, 10949, 57, 0, '', 121500, 1, 25, 861, 0),
('Anawalt Lumber Corp.', 'Ne', 'Ne', -468.827, -70.4593, 60.2682, 180.969, 0, 0, 15797, 96, 0, '', 0, 1, 0, 0, 0),
('Dick\'s Sounds', 'Ne', 'Ne', 2305.81, 82.6451, 26.4787, 178.588, 0, 0, 13065, 92, 0, '', 114990, 1, 25, 12382, 0),
('San Andreas Courthouse', 'Ne', 'Ne', -205.752, 1119.25, 19.9314, 87.8184, 0, 0, 11061, 5, 0, '', 0, 5, 25, 175, 0),
('RCSD Traffic Enforcement', 'Ne', 'Ne', 1418.31, 222.103, 19.5618, 65.0754, 0, 0, 19786, 51, 1, '', 0, 1, 0, 80, 49978),
('San Andreas County Range', 'Ne', 'Ne', 2318.71, -90.2807, 26.4844, 358.963, 0, 0, 19845, 100, 1, '.', 74990, 5, 50, 750, 782),
('Flint County Xoomer', 'Ne', 'Ne', -75.2068, -1175.2, 1.9803, 242.376, 0, 0, 16918, 84, 0, '', 119990, 5, 5, 1425, 69996),
('Myriad\'s Diner', 'Ne', 'Ne', -87.8581, -1202.02, 2.89162, 255.93, 0, 0, 11462, 38, 0, '', 89990, 5, 0, 42, 69993);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_business_fuel`
--

CREATE TABLE `gm_business_fuel` (
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `AssignedBusiness` int(11) NOT NULL,
  `Price_Benzin` float NOT NULL,
  `Price_Diesel` float NOT NULL,
  `Price_Kerosin` float NOT NULL,
  `Price_LPG` float NOT NULL,
  `Storage_Benzin` int(11) NOT NULL,
  `Storage_Diesel` int(11) NOT NULL,
  `Storage_Kerosin` int(11) NOT NULL,
  `Storage_LPG` int(11) NOT NULL,
  `IsUsing_Benzin` int(11) NOT NULL,
  `IsUsing_Diesel` int(11) NOT NULL,
  `IsUsing_Kerosin` int(11) NOT NULL,
  `IsUsing_LPG` int(11) NOT NULL,
  `CisloBoxu` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `gm_business_fuel`
--

INSERT INTO `gm_business_fuel` (`X`, `Y`, `Z`, `AssignedBusiness`, `Price_Benzin`, `Price_Diesel`, `Price_Kerosin`, `Price_LPG`, `Storage_Benzin`, `Storage_Diesel`, `Storage_Kerosin`, `Storage_LPG`, `IsUsing_Benzin`, `IsUsing_Diesel`, `IsUsing_Kerosin`, `IsUsing_LPG`, `CisloBoxu`) VALUES
(2277.39, 31.8094, 26.5962, 17424, 15.54, 1.234, 1.234, 1.234, 0, 500, 500, 500, 1, 0, 0, 0, 'PCT-1-1'),
(2279.47, 30.6177, 26.5962, 17424, 15.54, 13.54, 1.234, 1.234, 371, 500, 500, 500, 1, 0, 0, 0, 'PCT-1-2'),
(2274.55, 26.9211, 26.5962, 17424, 1.233, 13.54, 1.234, 1.234, 500, 355, 500, 500, 0, 1, 0, 0, 'PCT-2-1'),
(2276.62, 25.7206, 26.5962, 17424, 4.499, 13.54, 1.234, 1.234, 500, 500, 500, 500, 0, 1, 0, 0, 'PCT-2-2'),
(655.773, -574.539, 16.3359, 15818, 15.54, 15.54, 1.234, 1.234, 0, 500, 500, 500, 1, 0, 0, 0, 'DGS-1-1'),
(655.772, -572.952, 16.3359, 15818, 15.54, 15.54, 1.234, 1.234, 339, 500, 500, 500, 1, 0, 0, 0, 'DGS-1-2'),
(655.83, -571.184, 16.3359, 15818, 3, 13.54, 1.234, 1.234, 500, 500, 500, 500, 0, 1, 0, 0, 'DGS-2-1'),
(655.831, -569.555, 16.3359, 15818, 2.5, 13.54, 1.234, 1.234, 500, 498, 500, 500, 0, 1, 0, 0, 'DGS-2-2'),
(1385.22, 458.414, 20.0583, 19690, 15.54, 1.234, 1.234, 1.234, 346, 500, 500, 500, 1, 0, 0, 0, 'MGS-1-1'),
(1383.5, 459.217, 20.0589, 19690, 15.54, 1.234, 1.234, 1.234, 494, 500, 500, 500, 1, 0, 0, 0, 'MGS-1-2'),
(1380.76, 460.399, 20.0562, 19690, 1.234, 13.54, 1.234, 1.234, 500, 500, 500, 500, 0, 1, 0, 0, 'MGS-2-1'),
(1379.08, 461.165, 20.0503, 19690, 1.234, 13.54, 1.234, 1.234, 500, 500, 500, 500, 0, 1, 0, 0, 'MGS-2-2'),
(-89.6295, -1176.91, 2.12037, 16918, 1.234, 1.234, 1.234, 1.234, 311, 500, 500, 500, 1, 0, 0, 0, 'FCX-1-1'),
(-84.9901, -1165.17, 2.24135, 16918, 1.234, 1.234, 1.234, 1.234, 431, 500, 500, 500, 1, 0, 0, 0, 'FCX-1-2'),
(-91.7994, -1161.97, 2.24996, 16918, 1.234, 1.234, 1.234, 1.234, 500, 500, 500, 500, 0, 1, 0, 0, 'FCX-2-2'),
(-96.7559, -1173.9, 2.33639, 16918, 1.234, 1.234, 1.234, 1.234, 500, 356, 500, 500, 0, 1, 0, 0, 'FCX-2-1');

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_calls`
--

CREATE TABLE `gm_calls` (
  `id` int(11) NOT NULL,
  `Caller` varchar(25) NOT NULL,
  `Situation` text NOT NULL,
  `Location` text NOT NULL,
  `FromNumber` int(11) NOT NULL,
  `Date` int(11) NOT NULL,
  `FactionType` int(11) NOT NULL,
  `Handled` tinyint(4) NOT NULL,
  `Handlers` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_crates`
--

CREATE TABLE `gm_crates` (
  `id` int(11) NOT NULL,
  `UnixOrder` int(11) NOT NULL,
  `UnixArrive` int(11) NOT NULL,
  `Weapon_1` int(11) NOT NULL,
  `Weapon_2` int(11) NOT NULL,
  `Weapon_3` int(11) NOT NULL,
  `Weapon_4` int(11) NOT NULL,
  `Weapon_5` int(11) NOT NULL,
  `Kevlar_1` int(11) NOT NULL,
  `Kevlar_2` int(11) NOT NULL,
  `Kevlar_3` int(11) NOT NULL,
  `Owner` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_drops`
--

CREATE TABLE `gm_drops` (
  `dropType` int(11) NOT NULL,
  `dropDetail` smallint(6) NOT NULL,
  `dropCount` int(11) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `RZ` float NOT NULL,
  `VirtualWorld` mediumint(9) NOT NULL,
  `Interior` tinyint(4) NOT NULL,
  `PlacedBy` text NOT NULL,
  `Date` text NOT NULL,
  `dropFaction` tinyint(4) NOT NULL,
  `dropText` text NOT NULL,
  `object` int(11) NOT NULL,
  `serialnum` bigint(20) NOT NULL,
  `origin` text NOT NULL,
  `iswork` int(11) NOT NULL,
  `isperm` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_entrances`
--

CREATE TABLE `gm_entrances` (
  `Label` text NOT NULL,
  `Pickup` int(11) NOT NULL,
  `InteriorID` int(11) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `A` float NOT NULL,
  `VW` int(11) NOT NULL,
  `INT` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_factions`
--

CREATE TABLE `gm_factions` (
  `nid` int(11) NOT NULL,
  `ID` int(11) NOT NULL,
  `Name` text NOT NULL,
  `Type` int(11) NOT NULL,
  `Cash` int(11) NOT NULL,
  `FactionChat` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `gm_factions`
--

INSERT INTO `gm_factions` (`nid`, `ID`, `Name`, `Type`, `Cash`, `FactionChat`) VALUES
(14, 1, 'San Andreas Sheriff\'s Department', 1, 204641, 0),
(15, 2, 'Red County Fire Department', 2, 45760, 0),
(16, 3, 'San Andreas Government', 4, 2557575, 0),
(17, 4, 'San Andreas Network News', 3, 20224, 0),
(19, 6, 'Swoop Taxi', 8, 48500, 0),
(20, 7, 'BCSD (inactive)', 1, 20080, 0),
(21, 50, 'Smetiari (inactiv)', 6, 0, 0),
(22, 51, 'Zametaè ulíc', 7, 0, 0),
(23, 52, 'Donáška pizze', 9, 300, 0),
(24, 53, 'Prep. spolocnost (inact', 11, 0, 0),
(25, 54, 'Pohrebná služba', 0, 0, 0),
(26, 8, 'Hayes\' Home Service', 10, 12102, 0),
(28, 9, 'Gaudet Cars', 12, 560000, 0),
(30, 10, 'San Andreas National Park Service', 1, 85360, 0),
(32, 5, 'Anawalt Lumber', 5, 8920, 0);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_farms`
--

CREATE TABLE `gm_farms` (
  `name` varchar(128) NOT NULL,
  `owner` varchar(32) NOT NULL,
  `buyprice` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `pmaxx` float NOT NULL,
  `pmaxy` float NOT NULL,
  `pminx` float NOT NULL,
  `pminy` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_garages`
--

CREATE TABLE `gm_garages` (
  `Street` tinytext NOT NULL,
  `City` tinytext NOT NULL,
  `Number` tinyint(4) NOT NULL,
  `PSC` smallint(6) NOT NULL,
  `Owner` tinytext NOT NULL,
  `SecOwner` tinytext NOT NULL,
  `pX` float NOT NULL,
  `pY` float NOT NULL,
  `pZ` float NOT NULL,
  `pA` float NOT NULL,
  `vX` float NOT NULL,
  `vY` float NOT NULL,
  `vZ` float NOT NULL,
  `vA` float NOT NULL,
  `VW` mediumint(9) NOT NULL,
  `Interior` tinyint(4) NOT NULL,
  `InteriorID` tinyint(4) NOT NULL,
  `IsLocked` tinyint(4) NOT NULL,
  `BuyPrice` int(11) NOT NULL,
  `AssignedHouse` int(11) NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `gm_garages`
--

INSERT INTO `gm_garages` (`Street`, `City`, `Number`, `PSC`, `Owner`, `SecOwner`, `pX`, `pY`, `pZ`, `pA`, `vX`, `vY`, `vZ`, `vA`, `VW`, `Interior`, `InteriorID`, `IsLocked`, `BuyPrice`, `AssignedHouse`, `id`) VALUES
('Elm Street Garage', 'Palomino Creek', 2, 30001, 'Ne', 'Ne', 2206.41, 58.0556, 27.6919, 90.088, 2208.66, 58.0591, 27.6919, 270.088, 0, 0, 3, 1, 0, 20001, 3),
('Elm Street Garage', 'Palomino Creek', 1, 30002, 'Ne', 'Ne', 2206.08, 54.1653, 27.7439, 88.5938, 2208.33, 54.1101, 27.7439, 268.594, 0, 0, 3, 1, 0, 20001, 4),
('Elm Street Garage', 'Palomino Creek', 1, 30003, 'Ne', 'Ne', 2206.62, 110.425, 27.6555, 91.4139, 2208.87, 110.481, 27.6555, 271.414, 0, 0, 3, 1, 0, 20002, 5),
('Elm Street Garage', 'Palomino Creek', 2, 30004, 'Ne', 'Ne', 2206.34, 114.217, 27.7005, 90.088, 2208.59, 114.221, 27.7005, 270.088, 0, 0, 3, 0, 0, 20002, 6),
('Elm Street Garage', 'Palomino Creek', 1, 30005, 'Ne', 'Ne', 2252.76, 167.537, 27.4838, 0.546081, 2252.78, 165.287, 27.4838, 180.546, 0, 0, 3, 0, 0, 20004, 7),
('Elm Street Garage', 'Palomino Creek', 1, 30006, 'Ne', 'Ne', 2290.15, 159.351, 27.7131, 359.923, 2290.14, 157.101, 27.7131, 539.923, 0, 0, 3, 0, 0, 20005, 8),
('Elm Street Garage', 'Palomino Creek', 2, 30007, 'Ne', 'Ne', 2294, 159.29, 27.703, 5.24613, 2294.21, 157.049, 27.703, 185.246, 0, 0, 3, 0, 0, 20005, 9),
('Decatur Street Garage', 'Palomino Creek', 1, 30008, 'Ne', 'Ne', 2253.48, 109.282, 27.7033, 358.666, 2253.42, 107.033, 27.7033, 538.666, 0, 0, 3, 0, 0, 20006, 10),
('Decatur Street Garage', 'Palomino Creek', 1, 30009, 'Ne', 'Ne', 2261.45, 109.257, 27.6992, 359.293, 2261.42, 107.007, 27.6992, 539.293, 0, 0, 3, 0, 0, 20007, 11),
('Decatur Street Garage', 'Palomino Creek', 2, 30010, 'Ne', 'Ne', 2265.21, 109.007, 27.6587, 357.726, 2265.13, 106.759, 27.6587, 537.726, 0, 0, 3, 1, 0, 20007, 12),
('Main Street Garage', 'Palomino Creek', 1, 30011, 'Ne', 'Ne', 2326.44, 120.4, 27.6856, 89.8474, 2328.69, 120.394, 27.6856, 269.847, 0, 0, 3, 0, 0, 20008, 13),
('Main Street Garage', 'Palomino Creek', 2, 30012, 'Ne', 'Ne', 2326.61, 124.29, 27.6577, 89.5341, 2328.86, 124.272, 27.6577, 269.534, 0, 0, 3, 0, 0, 20008, 14),
('Main Street Garage', 'Palomino Creek', 1, 30013, 'Ne', 'Ne', 2361.05, 120.352, 27.6286, 270.329, 2358.8, 120.339, 27.6286, 450.329, 0, 0, 3, 1, 0, 20009, 15),
('Main Street Garage', 'Palomino Creek', 5, 30015, 'Ne', 'Ne', 2326.39, 154.29, 27.694, 90.427, 2328.64, 154.306, 27.694, 270.427, 0, 0, 3, 1, 0, 20012, 17),
('Main Street Garage', 'Palomino Creek', 5, 30016, 'Ne', 'Ne', 2326.55, 158.035, 27.6681, 90.1137, 2328.8, 158.039, 27.6681, 270.114, 0, 0, 3, 1, 0, 20012, 18),
('Main Street Garage', 'Palomino Creek', 1, 30017, 'Ne', 'Ne', 2361.16, 170.298, 27.6475, 269.945, 2358.91, 170.3, 27.6475, 449.945, 0, 0, 3, 0, 0, 20013, 19),
('Main Street Garage', 'Palomino Creek', 2, 30018, 'Ne', 'Ne', 2361.06, 174.274, 27.6309, 268.378, 2358.81, 174.338, 27.6309, 448.378, 0, 0, 3, 0, 0, 20013, 20),
('Main Street Garage', 'Palomino Creek', 2, 30019, 'Ne', 'Ne', 2326.63, 195.398, 27.6543, 90.7399, 2328.88, 195.427, 27.6543, 270.74, 0, 0, 3, 0, 0, 20014, 21),
('Main Street Garage', 'Palomino Creek', 1, 30020, 'Ne', 'Ne', 2326.83, 199.154, 27.6217, 87.6066, 2329.08, 199.06, 27.6217, 267.607, 0, 0, 3, 0, 0, 20014, 22),
('Main Street Garage', 'Palomino Creek', 1, 30021, 'Ne', 'Ne', 2361.13, 183.019, 27.6401, 269.655, 2358.88, 183.032, 27.6401, 449.655, 0, 0, 3, 0, 0, 20015, 23),
('Main Street Garage', 'Palomino Creek', 2, 30022, 'Ne', 'Ne', 2361.02, 179.09, 27.6233, 270.595, 2358.77, 179.067, 27.6233, 450.595, 0, 0, 3, 0, 0, 20015, 24),
('Reagan Street Garage', 'Palomino Creek', 1, 30023, 'Ne', 'Ne', 2279.58, 8.55074, 27.4688, 358.956, 2279.53, 6.30112, 27.4688, 538.956, 0, 0, 3, 0, 0, 20016, 25),
('Reagan Street Garage', 'Palomino Creek', 2, 30024, 'Ne', 'Ne', 2240.24, -2.86563, 27.4838, 1.77619, 2240.31, -5.11455, 27.4838, 181.776, 0, 0, 3, 0, 0, 20017, 26),
('Reagan Street Garage', 'Palomino Creek', 1, 30025, 'Ne', 'Ne', 2198.55, -65.9955, 27.4838, 90.1603, 2200.8, -65.9892, 27.4838, 270.16, 0, 0, 3, 1, 0, 20019, 27),
('Reagan Street Garage', 'Palomino Creek', 1, 30026, 'Ne', 'Ne', 2186.79, -79.9803, 27.4688, 90.1603, 2189.04, -79.974, 27.4688, 270.16, 0, 0, 3, 0, 0, 20020, 28),
('Bottom Street Garage', 'Palomino Creek', 1, 30027, 'Ne', 'Ne', 2254.7, -134.273, 27.4688, 179.461, 2254.72, -132.023, 27.4688, 359.461, 0, 0, 3, 0, 0, 20021, 29),
('Bottom Street Garage', 'Palomino Creek', 1, 30028, 'Ne', 'Ne', 2263.2, -135.716, 27.4688, 180.088, 2263.2, -133.466, 27.4688, 360.089, 0, 0, 3, 1, 0, 20022, 30),
('Bottom Street Garage', 'Palomino Creek', 1, 30029, 'Ne', 'Ne', 2299.01, -124.026, 27.4838, 178.835, 2299.06, -121.777, 27.4838, 358.835, 0, 0, 3, 0, 0, 20023, 31),
('Bottom Street Garage', 'Palomino Creek', 1, 30030, 'Ne', 'Ne', 2327.51, -123.93, 27.4838, 181.028, 2327.47, -121.68, 27.4838, 361.028, 0, 0, 3, 1, 0, 20024, 32),
('Paris Street Garage', 'Palomino Creek', 1, 30031, 'Ne', 'Ne', 2358.21, -109.805, 27.5873, 179.774, 2358.22, -107.555, 27.5873, 359.774, 0, 0, 3, 1, 0, 20025, 33),
('Paris Street Garage', 'Palomino Creek', 1, 30032, 'Ne', 'Ne', 2397.67, -98.019, 27.7511, 180.401, 2397.66, -95.769, 27.7511, 360.401, 0, 0, 3, 0, 0, 20026, 34),
('Paris Street Garage', 'Palomino Creek', 1, 30033, 'Ne', 'Ne', 2418.71, -97.8003, 28.2445, 179.774, 2418.72, -95.5503, 28.2445, 359.774, 0, 0, 3, 0, 0, 20027, 35),
('Paris Street Garage ', 'Palomino Creek', 1, 30034, 'Ne', 'Ne', 2431.81, -81.4, 26.4844, 181.028, 2431.77, -79.1504, 26.4844, 361.028, 0, 0, 3, 1, 0, 20025, 36),
('Paris Street Garage ', 'Palomino Creek', 2, 30035, 'Ne', 'Ne', 2438.39, -81.4734, 26.4844, 181.341, 2438.34, -79.224, 26.4844, 361.341, 0, 0, 3, 0, 0, 20026, 37),
('Paris Street Garage ', 'Palomino Creek', 3, 30036, 'Ne', 'Ne', 2445, -81.7458, 26.4844, 181.341, 2444.94, -79.4964, 26.4844, 361.341, 0, 0, 3, 0, 0, 20027, 38),
('Reagan Street Garage ', 'Palomino Creek', 1, 30037, 'Ne', 'Ne', 2358.26, -65.4981, 27.4688, 179.751, 2358.27, -63.2481, 27.4688, 359.751, 0, 0, 3, 0, 0, 20028, 39),
('Reagan Street Garage ', 'Palomino Creek', 1, 30038, 'Ne', 'Ne', 2397.73, -54.2155, 27.4838, 179.437, 2397.76, -51.9656, 27.4838, 359.437, 0, 0, 3, 0, 0, 20029, 40),
('Reagan Street Garage ', 'Palomino Creek', 1, 30039, 'Ne', 'Ne', 2424.58, -64.5991, 27.4688, 179.751, 2424.59, -62.3491, 27.4688, 359.751, 0, 0, 3, 0, 0, 20030, 41),
('Reagan Street Garage ', 'Palomino Creek', 1, 30040, 'Ne', 'Ne', 2444.1, -54.157, 27.4838, 179.751, 2444.11, -51.907, 27.4838, 359.751, 0, 0, 3, 0, 0, 20031, 42),
('Maple Street Garage', 'Palomino Creek', 2, 30044, 'Ne', 'Ne', 2416.28, 1.98274, 26.4844, 269.364, 2414.03, 2.00771, 26.4844, 449.364, 0, 0, 3, 0, 0, 20034, 46),
('Maple Street Garage', 'Palomino Creek', 1, 30045, 'Ne', 'Ne', 2376.16, 26.26, 27.7319, 89.5322, 2378.41, 26.2417, 27.7319, 269.532, 0, 0, 3, 0, 0, 20035, 47),
('Maple Street Garage', 'Palomino Creek', 1, 30046, 'Ne', 'Ne', 2413.69, 11.296, 26.4915, 269.99, 2411.44, 11.2964, 26.4915, 449.99, 0, 0, 3, 1, 0, 20036, 48),
('Maple Street Garage', 'Palomino Creek', 1, 30047, 'Ne', 'Ne', 2376.27, 38.1259, 27.7145, 89.8454, 2378.52, 38.1199, 27.7145, 269.845, 0, 0, 3, 1, 0, 20037, 49),
('Maple Street Garage', 'Palomino Creek', 2, 30048, 'Ne', 'Ne', 2376.38, 34.3208, 27.696, 91.0988, 2378.63, 34.3639, 27.696, 271.099, 0, 0, 3, 1, 0, 20037, 50),
('Maple Street Garage', 'Palomino Creek', 1, 30049, 'Ne', 'Ne', 2376.21, 75.3904, 27.7229, 90.4722, 2378.46, 75.409, 27.7229, 270.472, 0, 0, 3, 1, 0, 20038, 51),
('Maple Street Garage', 'Palomino Creek', 2, 30050, 'Ne', 'Ne', 2376.1, 79.172, 27.74, 88.5921, 2378.35, 79.1167, 27.74, 268.592, 0, 0, 3, 1, 0, 20038, 52),
('Maple Street Garage', 'Palomino Creek', 1, 30051, 'Ne', 'Ne', 2402.65, 109.679, 27.7675, 359.605, 2402.63, 107.429, 27.7675, 539.605, 0, 0, 3, 0, 0, 20039, 53),
('Maple Street Garage', 'Palomino Creek', 2, 30052, 'Ne', 'Ne', 2406.51, 109.755, 27.7798, 2.11128, 2406.59, 107.507, 27.7798, 182.111, 0, 0, 3, 0, 0, 20039, 54),
('Maple Street Garage', 'Palomino Creek', 1, 30053, 'Ne', 'Ne', 2447.58, 59.3506, 27.7142, 359.315, 2447.55, 57.1007, 27.7142, 539.315, 0, 0, 3, 1, 0, 20041, 55),
('Maple Street Garage', 'Palomino Creek', 2, 30054, 'Ne', 'Ne', 2451.52, 59.3604, 27.7158, 358.688, 2451.47, 57.111, 27.7158, 538.688, 0, 0, 3, 1, 0, 20041, 56),
('Crest Road Garage', 'Palomino Creek', 1, 30055, 'Ne', 'Ne', 2441.61, 11.3356, 26.4844, 91.0988, 2443.86, 11.3787, 26.4844, 271.099, 0, 0, 3, 0, 0, 20042, 57),
('Crest Road Garage', 'Palomino Creek', 1, 30056, 'Ne', 'Ne', 2486.57, 71.9533, 26.4844, 270.303, 2484.32, 71.9414, 26.4844, 450.303, 0, 0, 3, 0, 0, 20043, 58),
('Crest Road Garage', 'Palomino Creek', 1, 30057, 'Ne', 'Ne', 2446.1, 88.0381, 27.7414, 90.1582, 2448.35, 88.0444, 27.7414, 270.158, 0, 0, 3, 0, 0, 20044, 59),
('Crest Road Garage', 'Palomino Creek', 2, 30058, 'Ne', 'Ne', 2446, 84.2657, 27.7579, 89.5315, 2448.25, 84.2473, 27.7579, 269.532, 0, 0, 3, 0, 0, 20044, 60),
('Crest Road Garage', 'Palomino Creek', 1, 30059, 'Ne', 'Ne', 2469.31, 131.462, 26.4837, 1.48398, 2469.36, 129.213, 26.4837, 181.484, 0, 0, 3, 0, 0, 20045, 61),
('Crest Road Garage', 'Palomino Creek', 1, 30060, 'Ne', 'Ne', 2491.57, 134.319, 27.0712, 1.48385, 2491.63, 132.069, 27.0712, 181.484, 0, 0, 3, 0, 0, 20047, 62),
('Crest Road Garage', 'Palomino Creek', 2, 30061, 'Ne', 'Ne', 2496.04, 134.342, 27.0714, 0.856837, 2496.07, 132.092, 27.0714, 180.857, 0, 0, 3, 0, 0, 20047, 63),
('Crest Road Garage', 'Palomino Creek', 1, 30062, 'Ne', 'Ne', 2503.47, 91.6546, 26.4915, 181.629, 2503.41, 93.9037, 26.4915, 361.629, 0, 0, 3, 0, 0, 20048, 64),
('Crest Road Garage', 'Palomino Creek', 1, 30063, 'Ne', 'Ne', 2528.62, 134.047, 26.4844, 0.254109, 2528.63, 131.797, 26.4844, 180.254, 0, 0, 3, 0, 0, 20050, 65),
('Clean Street Garage', 'Palomino Creek', 1, 30064, 'Ne', 'Ne', 2553.55, 81.34, 26.4837, 269.387, 2551.3, 81.3641, 26.4837, 449.387, 0, 0, 3, 0, 0, 20051, 66),
('Clean Street Garage', 'Palomino Creek', 1, 30065, 'Ne', 'Ne', 2511.51, 69.3861, 27.0768, 91.4118, 2513.76, 69.4416, 27.0768, 271.412, 0, 0, 3, 0, 0, 20052, 67),
('Clean Street Garage', 'Palomino Creek', 2, 30066, 'Ne', 'Ne', 2511.34, 73.795, 27.0786, 89.2185, 2513.59, 73.7643, 27.0786, 269.218, 0, 0, 3, 0, 0, 20052, 68),
('Clean Street Garage', 'Palomino Creek', 1, 30067, 'Ne', 'Ne', 2556.25, 14.1685, 27.0681, 269.724, 2554, 14.1794, 27.0681, 449.724, 0, 0, 3, 0, 0, 20054, 69),
('Clean Street Garage', 'Palomino Creek', 2, 30068, 'Ne', 'Ne', 2556.27, 9.56672, 27.0683, 268.784, 2554.02, 9.61448, 27.0683, 448.784, 0, 0, 3, 0, 0, 20054, 70),
('Clean Street Garage', 'Palomino Creek', 1, 30069, 'Ne', 'Ne', 2556.29, 2.05376, 26.4766, 270.663, 2554.04, 2.02771, 26.4766, 450.663, 0, 0, 3, 0, 0, 20055, 71),
('Clean Street Garage', 'Palomino Creek', 1, 30070, 'Ne', 'Ne', 2517.55, -25.9213, 27.7043, 180.108, 2517.55, -23.6713, 27.7043, 360.108, 0, 0, 3, 0, 0, 20056, 72),
('Clean Street Garage', 'Palomino Creek', 2, 30071, 'Ne', 'Ne', 2521.31, -25.987, 27.7149, 177.916, 2521.39, -23.7385, 27.7149, 357.916, 0, 0, 3, 0, 0, 20056, 73),
('Clean Street Garage', 'Palomino Creek', 1, 30072, 'Ne', 'Ne', 2505.22, 9.50156, 27.7401, 0.254109, 2505.23, 7.25158, 27.7401, 180.254, 0, 0, 3, 1, 0, 20057, 74),
('Clean Street Garage', 'Palomino Creek', 2, 30073, 'Ne', 'Ne', 2501.47, 9.3645, 27.7179, 359.628, 2501.45, 7.11455, 27.7179, 539.628, 0, 0, 3, 0, 0, 20057, 75),
('Clean Street Garage', 'Palomino Creek', 1, 30074, 'Ne', 'Ne', 2480.1, -26.0751, 27.7278, 180.736, 2480.07, -23.8253, 27.7278, 360.736, 0, 0, 3, 0, 0, 20058, 76),
('Clean Street Garage', 'Palomino Creek', 2, 30075, 'Ne', 'Ne', 2476.27, -26.1427, 27.7388, 178.856, 2476.31, -23.8931, 27.7388, 358.856, 0, 0, 3, 0, 0, 20058, 77),
('Clean Street Garage', 'Palomino Creek', 1, 30076, 'Ne', 'Ne', 2492.77, 9.37953, 27.7189, 1.2174, 2492.82, 7.13003, 27.7189, 181.217, 0, 0, 3, 0, 0, 20059, 78),
('Clean Street Garage', 'Palomino Creek', 2, 30077, 'Ne', 'Ne', 2496.46, 9.15816, 27.683, 358.711, 2496.41, 6.90873, 27.683, 538.711, 0, 0, 3, 0, 0, 20059, 79),
('Fullum Street Garage', 'Dillimore', 1, 30078, 'Ne', 'Ne', 756.974, -581.871, 17.3281, 269.801, 754.724, -581.863, 17.3281, 449.801, 0, 0, 3, 0, 0, 20082, 80),
('Mayor Street Garage', 'Dillimore', 1, 30079, 'Ne', 'Ne', 752.471, -492.604, 17.3281, 0.039565, 752.472, -494.854, 17.3281, 180.04, 0, 0, 3, 0, 0, 20083, 81),
('Mayor Street Garage', 'Dillimore', 2, 30080, 'Ne', 'Ne', 750.417, -555.748, 17.3432, 179.873, 750.422, -553.498, 17.3432, 359.873, 0, 0, 3, 0, 0, 20084, 82),
('Mayor Street Garage', 'Dillimore', 3, 30081, 'Ne', 'Ne', 762.952, -504.18, 17.3432, 358.788, 762.904, -506.43, 17.3432, 538.788, 0, 0, 3, 0, 0, 20085, 83),
('Mayor Street Garage', 'Dillimore', 4, 30082, 'Ne', 'Ne', 771.925, -555.966, 17.3432, 180.187, 771.918, -553.716, 17.3432, 360.187, 0, 0, 3, 0, 0, 20086, 84),
('Mayor Street Garage', 'Dillimore', 6, 30083, 'Ne', 'Ne', 827.453, -492.904, 17.3281, 1.27165, 827.503, -495.153, 17.3281, 181.272, 0, 0, 3, 0, 0, 20088, 85),
('Prázdny objekt', 'Dillimore', 1, 30084, 'Ne', 'Ne', 844.783, -602.576, 18.4219, 180.5, 844.763, -600.326, 18.4219, 360.5, 0, 0, 2, 0, 121000, 0, 86),
('Main Street Garage', 'Blueberry', 1, 30085, 'Ne', 'Ne', 250.129, -125.694, 2.75173, 269.637, 247.879, -125.68, 2.75173, 449.637, 0, 0, 3, 0, 0, 20149, 87),
('Main Street Garage ', 'Blueberry', 2, 30086, 'Ne', 'Ne', 250.127, -129.496, 2.75131, 268.697, 247.877, -129.444, 2.75131, 448.697, 0, 0, 3, 0, 0, 20149, 88),
('Main Street Garage', 'Blueberry', 1, 30087, 'Ne', 'Ne', 250.23, -88.1833, 2.76957, 269.95, 247.98, -88.1813, 2.76957, 449.95, 0, 0, 3, 0, 0, 20150, 89),
('Main Street Garage', 'Blueberry', 2, 30088, 'Ne', 'Ne', 250.254, -84.4443, 2.77352, 270.89, 248.005, -84.4793, 2.77352, 450.89, 0, 0, 3, 0, 0, 20150, 90),
('St. James Street Garage', 'Blueberry', 1, 30089, 'Ne', 'Ne', 277.998, -52.2612, 1.58524, 359.564, 277.981, -54.5111, 1.58524, 539.564, 0, 0, 2, 1, 0, 20151, 91),
('St. James Street Garage', 'Blueberry', 1, 30090, 'Ne', 'Ne', 287.467, -49.5856, 1.57812, 0.190774, 287.475, -51.8356, 1.57812, 180.191, 0, 0, 3, 0, 0, 20152, 92),
('First Street Garage', 'Blueberry', 1, 30091, 'Ne', 'Ne', 315.282, -88.067, 2.78394, 88.8417, 317.531, -88.1124, 2.78394, 268.842, 0, 0, 3, 0, 0, 20153, 93),
('First Street Garage', 'Blueberry', 2, 30092, 'Ne', 'Ne', 315.329, -84.332, 2.77627, 86.6483, 317.575, -84.4635, 2.77627, 266.648, 0, 0, 3, 0, 0, 20153, 94),
('First Street Garage', 'Blueberry', 1, 30093, 'Ne', 'Ne', 314.919, -125.515, 2.84408, 92.6018, 317.167, -125.413, 2.84408, 272.602, 0, 0, 3, 0, 0, 20154, 95),
('First Street Garage', 'Blueberry', 2, 30094, 'Ne', 'Ne', 314.994, -129.267, 2.83192, 88.5284, 317.244, -129.324, 2.83192, 268.528, 0, 0, 3, 0, 0, 20154, 96),
('Hacienda Carvajal Garage', 'Red County', 1, 30095, 'Ne', 'Ne', 2887.26, -159.288, 20.3138, 181.902, 2887.19, -157.039, 20.3138, 361.902, 0, 0, 3, 0, 0, 20194, 97),
('Hacienda Carvajal Garage', 'Red County', 1, 30096, 'Ne', 'Ne', 2883.78, -236.612, 7.0538, 88.504, 2886.03, -236.671, 7.0538, 268.504, 0, 0, 3, 0, 0, 20197, 98),
('East Highways Mansion Garage', 'Los Angeles', 1, 30097, 'Ne', 'Ne', 2921.82, -793.154, 11.0606, 269.612, 2919.57, -793.139, 11.0606, 449.612, 0, 0, 3, 0, 0, 20198, 99),
('East Highways Mansion Garage', 'Red County', 1, 30098, 'Ne', 'Ne', 2929.7, -758.686, 11.58, 257.079, 2927.51, -758.183, 11.58, 437.079, 0, 0, 3, 0, 0, 20199, 100),
('East Highways Mansion Garage', 'Red County', 1, 30099, 'Ne', 'Ne', 2926.46, -723.641, 11.0353, 268.359, 2924.21, -723.577, 11.0353, 448.359, 0, 0, 3, 0, 0, 20200, 101),
('East Highways Mansion Garage', 'Red County', 1, 30100, 'Ne', 'Ne', 2941.25, -659.115, 10.8805, 268.985, 2939, -659.075, 10.8805, 448.985, 0, 0, 3, 0, 0, 20202, 102),
('Far Street Garage', 'Fort Carson', 1, 30101, 'Ne', 'Ne', -240.146, 995.914, 19.7422, 179.867, -240.141, 998.164, 19.7422, 359.867, 0, 0, 3, 1, 0, 20248, 103),
('Half Street Garage', 'Fort Carson', 5, 30102, 'Ne', 'Ne', -368.008, 1102.97, 19.7422, 88.7075, -365.759, 1102.92, 19.7422, 268.707, 0, 0, 3, 0, 0, 20258, 104),
('Half Street Garage', 'Fort Carson', 7, 30103, 'Ne', 'Ne', -305.959, 1120.97, 19.7422, 0.055953, -305.957, 1118.72, 19.7422, 180.056, 0, 0, 3, 0, 0, 20260, 105),
('Home Street Garage', 'Fort Carson', 4, 30104, 'Ne', 'Ne', -25.9814, 1120.79, 19.7422, 0.055953, -25.9792, 1118.54, 19.7422, 180.056, 0, 0, 3, 0, 0, 20264, 106),
('Low Street Garage', 'Fort Carson', 1, 30105, 'Ne', 'Ne', 6.70725, 1083.79, 19.7422, 269.189, 4.45748, 1083.82, 19.7422, 449.189, 0, 0, 3, 0, 0, 20266, 107),
('West Street Garage', 'Fort Carson', 3, 30106, 'Ne', 'Ne', -252.963, 1158.72, 19.7422, 270.106, -255.213, 1158.71, 19.7422, 450.106, 0, 0, 3, 0, 0, 20252, 108),
('Mayor Street Dillimore', 'Dillimore', 5, 30107, 'Ne', 'Ne', 785.904, -494.851, 17.3359, 357.543, 785.807, -497.099, 17.3359, 537.543, 0, 0, 1, 0, 0, 20087, 110),
('Trash Warehouse', 'Blueberry', 1, 30108, 'Ne', 'Ne', 259.515, 7.19034, 2.44235, 278.667, 257.29, 6.85128, 2.44235, 458.667, 0, 0, 3, 1, 17990, 0, 111),
('Main Street Garage', 'Palomino Creek', 1, 30109, 'Ne', 'Ne', 2361.39, 124.386, 27.6836, 297.415, 2359.39, 123.35, 27.6836, 477.415, 0, 0, 1, 1, 0, 20009, 112),
('Flint County Xoomer', 'Flint County', 1, 30110, 'Ne', 'Ne', -78.1088, -1181.05, 1.80827, 242.095, -80.0972, -1180, 1.80827, 422.095, 0, 0, 1, 1, 4990, 0, 113);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_garage_interiors`
--

CREATE TABLE `gm_garage_interiors` (
  `id` int(11) NOT NULL,
  `vX` float NOT NULL,
  `vY` float NOT NULL,
  `vZ` float NOT NULL,
  `vA` float NOT NULL,
  `pX` float NOT NULL,
  `pY` float NOT NULL,
  `pZ` float NOT NULL,
  `pA` float NOT NULL,
  `Interior` int(11) NOT NULL,
  `Name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `gm_garage_interiors`
--

INSERT INTO `gm_garage_interiors` (`id`, `vX`, `vY`, `vZ`, `vA`, `pX`, `pY`, `pZ`, `pA`, `Interior`, `Name`) VALUES
(1, 612.287, -125.428, 1002, 270.23, 620.882, -130.275, 1003.03, 270, 4, 'Small Garage'),
(2, 612.477, -76.5352, 1002.07, 269.781, 620.005, -71.063, 1002.25, 0, 4, 'Medium Garage'),
(3, -1082.35, 391.725, 13.9952, 45, -1083.08, 387.034, 14.227, 227.536, 4, 'Small Custom Garage 1'),
(4, 2058.35, -1833.73, 949.726, 180.708, 2058.41, -1829.93, 949.727, 179.759, 4, 'Kepler garaz'),
(5, 2162.35, -1762.12, 899.714, 271.809, 2159.44, -1762.19, 899.714, 270.293, 60, 'Kepler garaz k domu id 58');

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_gps`
--

CREATE TABLE `gm_gps` (
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `Name` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `gm_gps`
--

INSERT INTO `gm_gps` (`X`, `Y`, `Z`, `Name`) VALUES
(2269.72, -74.6041, 26.7724, 'Palomino Creek Town Hall (radnice)'),
(2302.99, -16.1005, 26.4909, 'Greenlake Savings (banka)'),
(2260.33, 50.4051, 26.4909, 'Palomino Creek Butchers (øeznictví)'),
(2305.77, 82.7869, 26.4787, 'Palomino Creek Electronics (elektronika)'),
(2448.07, 111.545, 26.598, 'Palomino Creek Mechanics (upgrade shop)'),
(630.419, -571.58, 16.3359, 'Red County Sheriff\'s Office (policie)'),
(-1881.74, -1695.36, 21.7461, 'Angel Pine Junkyard (šrotovištì)'),
(1204.21, 515.609, 19.7452, 'Red County Fire Department (hasièi)'),
(1204.21, 515.609, 19.7452, 'Montgomery Crippen Memorial (nemocnice)'),
(2148.15, -95.3299, 2.73448, 'Palomino Creek Fishing Pier (rybaøení)'),
(1274.4, 237.923, 19.5547, 'Caine Motel (motel)'),
(633, -587.118, 16.3359, 'Dillimore Impound (odahové parkovisko)'),
(2186.53, -38.2416, 28.154, 'Hayes\' Home Service (autodielòa)'),
(1300.07, 215.458, 19.5547, 'Brigáda nošení krabic (Montgomery)'),
(2323.78, 60.3297, 26.4922, 'Brigáda nošení krabic (Palomino Creek)'),
(-216.58, 978.975, 19.4969, 'Bone County Sheriff\'s Department (policie)'),
(-525.075, -485.58, 25.5234, 'Prodej zboží (pøekladištì)'),
(701.47, -520.923, 16.3359, 'Mr Grant\'s Bike Shed (prodejna motorek)'),
(611.52, -518.427, 16.3359, 'Big Mike\'s (prodejna náklaïákù)'),
(613.064, -494.374, 16.3359, 'Watson Automotive (prodejna automobilù)'),
(414.799, 2533.83, 19.1484, 'Nevada Airfield Stockade (prodejna letounù)'),
(2156.38, -99.5133, 3.27728, 'Peller\'s Boating (prodejna lodí)'),
(-435.992, -60.3328, 58.875, 'Anawalt Lumber Corp.'),
(1367.73, 250.467, 19.5669, 'Rozvoz pizze, Montgomery (práce)'),
(216.446, 16.0762, 2.5708, 'Smetiar, Blueberry (príace)'),
(846.893, -601.031, 18.4219, 'Zametanie ulíc, Dillimore (práce)'),
(2105.84, -101.794, 2.05496, 'Rybáøské molo (rybaøení)'),
(1403.98, 239.304, 19.5547, 'Autoškola'),
(-239.84, 1208.63, 19.7422, 'Gaudet Cars (Autobazar)'),
(202.853, -35.2633, 2.57031, 'Pentagon Club'),
(2318.82, -89.6588, 26.4844, 'General Store (Palomino Creek)'),
(1401.95, 284.918, 19.5547, 'Montgomery Electronics'),
(672.911, -497.414, 16.3359, 'Harris Barber Shop'),
(-204.265, 1089.17, 19.7344, 'Hells Hole Pub'),
(2334.37, -67.2358, 26.4844, 'Bub\'s Bike Shop (prodejna kol)'),
(-80.3147, -1172.7, 2.14801, 'Flint County Xoomer');

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_graffiti`
--

CREATE TABLE `gm_graffiti` (
  `MatSize` int(11) NOT NULL,
  `Text` text NOT NULL,
  `Font` text NOT NULL,
  `FontSize` int(11) NOT NULL,
  `Bold` int(11) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `RX` float NOT NULL,
  `RY` float NOT NULL,
  `RZ` float NOT NULL,
  `VW` int(11) NOT NULL,
  `INTERIOR` int(11) NOT NULL,
  `Owner` varchar(35) NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_hasicaky`
--

CREATE TABLE `gm_hasicaky` (
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `RX` float NOT NULL,
  `RY` float NOT NULL,
  `RZ` float NOT NULL,
  `VW` int(11) NOT NULL,
  `INTERIOR` int(11) NOT NULL,
  `SPOTREBA` int(11) NOT NULL,
  `PKONTROLA` int(11) NOT NULL,
  `STOLEN` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_houses`
--

CREATE TABLE `gm_houses` (
  `Street` tinytext NOT NULL,
  `City` tinytext NOT NULL,
  `Number` tinyint(4) NOT NULL,
  `PSC` smallint(6) NOT NULL,
  `Owner` tinytext CHARACTER SET utf8 COLLATE utf8_czech_ci NOT NULL,
  `SecOwner` tinytext NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `Angle` float NOT NULL,
  `VW` mediumint(9) NOT NULL,
  `Interior` tinyint(4) NOT NULL,
  `InteriorID` tinyint(4) NOT NULL,
  `IsLocked` tinyint(4) NOT NULL,
  `BuyPrice` int(11) NOT NULL,
  `IsRental` tinyint(4) NOT NULL,
  `RentTo` int(11) NOT NULL,
  `ExteriorFurniture` tinyint(4) NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `gm_houses`
--

INSERT INTO `gm_houses` (`Street`, `City`, `Number`, `PSC`, `Owner`, `SecOwner`, `X`, `Y`, `Z`, `Angle`, `VW`, `Interior`, `InteriorID`, `IsLocked`, `BuyPrice`, `IsRental`, `RentTo`, `ExteriorFurniture`, `id`) VALUES
('Elm Street', 'Palomino Creek', 1, 20001, 'Ne', 'Ne', 2206.28, 62.2327, 28.2488, 90.4013, 0, 0, 31, 1, 35078, 0, 0, 2, 1),
('Elm Street', 'Palomino Creek', 2, 20002, 'Ne', 'Ne', 2206.01, 106.137, 28.3869, 88.9071, 0, 0, 31, 0, 35078, 0, 0, 2, 2),
('Elm Street', 'Palomino Creek', 3, 20003, 'Ne', 'Ne', 2236.38, 167.914, 28.1535, 359.317, 0, 0, 31, 1, 25398, 0, 0, 2, 3),
('Elm Street', 'Palomino Creek', 4, 20004, 'Ne', 'Ne', 2257.98, 168.131, 28.1536, 0.569583, 0, 0, 31, 1, 36288, 0, 0, 2, 4),
('Elm Street', 'Palomino Creek', 5, 20005, 'Ne', 'Ne', 2285.91, 159.889, 28.4453, 1.17253, 0, 0, 31, 1, 36288, 0, 0, 2, 5),
('Decatur Street', 'Palomino Creek', 6, 20006, 'Ne', 'Ne', 2249.22, 109.743, 28.4453, 359.293, 0, 0, 31, 0, 36288, 0, 0, 2, 6),
('Decatur Street', 'Palomino Creek', 7, 20007, 'Ne', 'Ne', 2269.48, 109.81, 28.4453, 0.859573, 0, 0, 31, 0, 36288, 0, 0, 2, 7),
('Main Street', 'Palomino Creek', 1, 20008, 'Ne', 'Ne', 2325.71, 116.161, 28.4453, 89.8474, 0, 0, 31, 0, 43548, 0, 0, 2, 8),
('Main Street', 'Palomino Creek', 2, 20009, 'Ne', 'Ne', 2362.09, 116.073, 28.4453, 271.582, 0, 0, 31, 1, 43548, 0, 0, 2, 9),
('Main Street', 'Palomino Creek', 3, 20010, 'Ne', 'Ne', 2325.66, 136.302, 28.4453, 88.2571, 0, 0, 31, 0, 39918, 0, 0, 2, 10),
('Main Street', 'Palomino Creek', 4, 20011, 'Ne', 'Ne', 2362.01, 141.993, 28.4453, 269.029, 0, 0, 31, 0, 39918, 0, 0, 2, 11),
('Main Street', 'Palomino Creek', 5, 20012, 'Ne', 'Ne', 2325.66, 162.215, 28.4453, 88.547, 0, 0, 31, 1, 48388, 0, 1549362426, 2, 12),
('Main Street', 'Palomino Creek', 6, 20013, 'Ne', 'Ne', 2362.14, 166.121, 28.4453, 269.318, 0, 0, 31, 0, 48388, 0, 0, 2, 13),
('Main Street', 'Palomino Creek', 7, 20014, 'Ne', 'Ne', 2325.58, 191.092, 28.4453, 90.1133, 0, 0, 31, 0, 48388, 0, 0, 2, 14),
('Main Street', 'Palomino Creek', 8, 20015, 'Ne', 'Ne', 2362.24, 187.143, 28.4453, 272.475, 0, 0, 31, 0, 48388, 0, 0, 2, 15),
('Reagan Street', 'Palomino Creek', 1, 20016, 'Ne', 'Ne', 2271.52, -10.6101, 28.0485, 1.14944, 0, 0, 31, 0, 49598, 0, 0, 2, 16),
('Reagan Street', 'Palomino Creek', 2, 20017, 'Ne', 'Ne', 2246.47, -4.54477, 28.1562, 1.14944, 0, 0, 31, 0, 49598, 0, 0, 2, 17),
('Reagan Street', 'Palomino Creek', 3, 20018, 'Ne', 'Ne', 2203.08, -39.4742, 28.0363, 92.957, 0, 0, 31, 1, 49598, 0, 1549314564, 1, 18),
('Reagan Street', 'Palomino Creek', 4, 20019, 'Ne', 'Ne', 2200.17, -59.5667, 28.1562, 90.1603, 0, 0, 31, 1, 49598, 0, 0, 2, 19),
('Reagan Street', 'Palomino Creek', 5, 20020, 'Ne', 'Ne', 2206.06, -88.0387, 28.1513, 90.787, 0, 0, 31, 0, 49598, 0, 0, 2, 20),
('Bottom Street', 'Palomino Creek', 1, 20021, 'Ne', 'Ne', 2247.64, -119.314, 28.132, 181.341, 0, 0, 31, 0, 55648, 0, 0, 2, 21),
('Bottom Street', 'Palomino Creek', 2, 20022, 'Ne', 'Ne', 2271.27, -116.149, 28.1291, 181.341, 0, 0, 31, 1, 55648, 0, 0, 2, 22),
('Bottom Street', 'Palomino Creek', 3, 20023, 'Ne', 'Ne', 2292.61, -122.085, 28.1562, 180.401, 0, 0, 31, 1, 55648, 0, 0, 2, 23),
('Bottom Street', 'Palomino Creek', 4, 20024, 'Ne', 'Ne', 2321.13, -121.906, 28.0822, 180.084, 0, 0, 31, 1, 55648, 0, 0, 2, 24),
('Paris Street', 'Palomino Creek', 1, 20025, 'Ne', 'Ne', 2366.16, -90.3461, 28.3093, 181.654, 0, 0, 31, 1, 97998, 0, 1550614593, 2, 25),
('Paris Street', 'Palomino Creek', 2, 20026, 'Ne', 'Ne', 2391.25, -95.6848, 28.2699, 181.968, 0, 0, 31, 0, 97998, 0, 0, 2, 26),
('Paris Street', 'Palomino Creek', 3, 20027, 'Ne', 'Ne', 2412.36, -95.6128, 28.7486, 181.028, 0, 0, 31, 0, 97998, 0, 0, 2, 27),
('Reagan Street', 'Palomino Creek', 6, 20028, 'Ne', 'Ne', 2366.2, -46.2106, 28.1562, 181.631, 0, 0, 31, 0, 49598, 0, 0, 2, 28),
('Reagan Street', 'Palomino Creek', 7, 20029, 'Ne', 'Ne', 2391.27, -52.1222, 28.1562, 180.063, 0, 0, 31, 1, 49598, 0, 1550989940, 2, 29),
('Reagan Street', 'Palomino Creek', 8, 20030, 'Ne', 'Ne', 2417.6, -49.179, 28.0506, 181.003, 0, 0, 31, 1, 49598, 0, 0, 2, 30),
('Reagan Street', 'Palomino Creek', 9, 20031, 'Ne', 'Ne', 2437.64, -52.077, 28.1562, 181.944, 0, 0, 31, 1, 49598, 0, 0, 2, 31),
('Reagan Street', 'Palomino Creek', 13, 20032, 'Ne', 'Ne', 2449.45, -12.7664, 27.6797, 89.1959, 0, 0, 31, 0, 49598, 0, 0, 2, 32),
('Maple Street', 'Palomino Creek', 1, 20033, 'Ne', 'Ne', 2375.74, -8.73652, 28.4453, 88.9059, 0, 0, 31, 0, 43548, 0, 0, 2, 33),
('Maple Street', 'Palomino Creek', 2, 20034, 'Ne', 'Ne', 2410.56, -4.81772, 27.6835, 179.437, 0, 0, 33, 1, 43548, 0, 1550695398, 1, 34),
('Maple Street', 'Palomino Creek', 3, 20035, 'Ne', 'Ne', 2375.64, 21.9116, 28.4453, 87.9656, 0, 0, 31, 0, 43548, 0, 0, 2, 35),
('Maple Street', 'Palomino Creek', 4, 20036, 'Ne', 'Ne', 2409.4, 27.3648, 27.6191, 180.69, 0, 0, 31, 1, 43548, 0, 0, 2, 36),
('Maple Street', 'Palomino Creek', 5, 20037, 'Ne', 'Ne', 2375.17, 42.2425, 28.4416, 90.4721, 0, 0, 31, 1, 43548, 0, 0, 2, 37),
('Maple Street', 'Palomino Creek', 6, 20038, 'Ne', 'Ne', 2375.49, 71.0268, 28.4416, 89.5322, 0, 0, 31, 1, 43548, 0, 0, 2, 38),
('Maple Street', 'Palomino Creek', 7, 20039, 'Ne', 'Ne', 2398.26, 109.886, 28.4453, 358.665, 0, 0, 31, 1, 62908, 0, 1549383644, 2, 39),
('Maple Street', 'Palomino Creek', 8, 20040, 'Ne', 'Ne', 2413.6, 59.9421, 28.4453, 359.628, 0, 0, 31, 0, 37498, 0, 0, 2, 40),
('Maple Street', 'Palomino Creek', 9, 20041, 'Ne', 'Ne', 2443.41, 59.7689, 28.4453, 359.628, 0, 0, 31, 1, 37498, 0, 0, 2, 41),
('Crest Road', 'Palomino Creek', 1, 20042, 'Ne', 'Ne', 2447.37, 17.6629, 27.558, 0.22985, 0, 0, 31, 0, 55648, 0, 0, 2, 42),
('Crest Road', 'Palomino Creek', 2, 20043, 'Ne', 'Ne', 2480.55, 65.077, 27.6835, 178.809, 0, 0, 31, 0, 55648, 0, 0, 2, 43),
('Crest Road', 'Palomino Creek', 3, 20044, 'Ne', 'Ne', 2445.65, 92.1992, 28.4453, 89.8448, 0, 0, 31, 0, 55648, 0, 0, 2, 44),
('Crest Road', 'Palomino Creek', 4, 20045, 'Ne', 'Ne', 2453.18, 127.081, 27.5606, 269.676, 0, 0, 31, 0, 55648, 0, 0, 2, 45),
('Crest Road', 'Palomino Creek', 5, 20046, 'Ne', 'Ne', 2478.16, 96.22, 27.5611, 269.99, 0, 0, 31, 0, 55648, 0, 0, 2, 46),
('Crest Road', 'Palomino Creek', 6, 20047, 'Ne', 'Ne', 2486.17, 126.299, 27.6392, 90.158, 0, 0, 31, 0, 55648, 0, 0, 2, 47),
('Crest Road', 'Palomino Creek', 7, 20048, 'Ne', 'Ne', 2519.35, 96.32, 27.6835, 90.1347, 0, 0, 31, 0, 55648, 0, 0, 2, 48),
('Crest Road', 'Palomino Creek', 8, 20049, 'Ne', 'Ne', 2519.49, 127.084, 27.6719, 88.9045, 0, 0, 31, 0, 55648, 0, 0, 2, 49),
('Crest Road', 'Palomino Creek', 9, 20050, 'Ne', 'Ne', 2534.75, 128.349, 27.4558, 270.013, 0, 0, 31, 0, 55648, 0, 0, 2, 50),
('Clean Street', 'Palomino Creek', 1, 20051, 'Ne', 'Ne', 2549.4, 97.3939, 27.5921, 180.399, 0, 0, 31, 0, 55648, 0, 0, 2, 51),
('Clean Street', 'Palomino Creek', 2, 20052, 'Ne', 'Ne', 2519.23, 64.048, 27.567, 178.206, 0, 0, 31, 0, 55648, 0, 0, 2, 52),
('Clean Street', 'Palomino Creek', 3, 20053, 'Ne', 'Ne', 2549.34, 56.2768, 27.6719, 357.748, 0, 0, 31, 0, 55648, 0, 0, 2, 53),
('Clean Street', 'Palomino Creek', 4, 20054, 'Ne', 'Ne', 2548.59, 19.4031, 27.5476, 0.277659, 0, 0, 31, 0, 55648, 0, 0, 2, 54),
('Clean Street', 'Palomino Creek', 5, 20055, 'Ne', 'Ne', 2550.66, -4.92312, 27.6756, 180.107, 0, 0, 31, 0, 55648, 0, 0, 2, 55),
('Clean Street', 'Palomino Creek', 6, 20056, 'Ne', 'Ne', 2513.31, -26.4955, 28.4453, 179.483, 0, 0, 31, 0, 55648, 0, 0, 2, 56),
('Clean Street', 'Palomino Creek', 7, 20057, 'Ne', 'Ne', 2509.55, 9.92548, 28.4453, 2.13414, 0, 0, 31, 1, 55648, 0, 0, 2, 57),
('Clean Street', 'Palomino Creek', 8, 20058, 'Ne', 'Ne', 2484.47, -26.4594, 28.4453, 180.108, 0, 0, 31, 0, 55648, 0, 0, 2, 58),
('Clean Street', 'Palomino Creek', 9, 20059, 'Ne', 'Ne', 2488.29, 9.71185, 28.4453, 359.651, 0, 0, 31, 1, 55648, 0, 0, 2, 59),
('Palomino Creek Block (1)', 'Red County', 1, 20060, 'Ne', 'Ne', 724.59, -728.052, 1085.02, 358.988, 18225, 0, 36, 0, 5554, 0, 0, 2, 61),
('Palomino Creek Block (1)', 'Red County', 2, 20061, 'Ne', 'Ne', 724.774, -730.265, 1085.02, 177.88, 18225, 0, 36, 0, 5554, 0, 0, 2, 62),
('Palomino Creek Block (1)', 'Red County', 3, 20062, 'Ne', 'Ne', 720.292, -728.051, 1085.02, 0.217606, 18225, 0, 36, 0, 5554, 0, 0, 2, 63),
('Palomino Creek Block (1)', 'Red County', 4, 20063, 'Ne', 'Ne', 720.281, -730.265, 1085.02, 180.048, 18225, 0, 36, 0, 5554, 0, 0, 2, 64),
('Palomino Creek Block (1)', 'Red County', 6, 20065, 'Ne', 'Ne', 710.321, -728.051, 1085.02, 359.881, 18225, 0, 36, 1, 5554, 0, 0, 2, 66),
('Palomino Creek Block (1)', 'Red County', 7, 20066, 'Ne', 'Ne', 710.109, -736.278, 1085.02, 177.206, 18225, 0, 36, 1, 5554, 0, 0, 2, 67),
('Palomino Creek Block (1)', 'Red County', 8, 20067, 'Ne', 'Ne', 724.891, -736.524, 1088.73, 179.713, 18225, 0, 36, 0, 5554, 0, 0, 2, 68),
('Palomino Creek Block (1)', 'Red County', 9, 20068, 'Ne', 'Ne', 725.047, -727.849, 1088.74, 0.17132, 18225, 0, 36, 0, 5554, 0, 0, 2, 69),
('Palomino Creek Block (1)', 'Red County', 10, 20069, 'Ne', 'Ne', 720.292, -727.849, 1088.73, 1.42437, 18225, 0, 36, 1, 5554, 0, 0, 2, 70),
('Palomino Creek Block (1)', 'Red County', 11, 20070, 'Ne', 'Ne', 715.301, -727.849, 1088.73, 1.11118, 18225, 0, 36, 1, 5554, 0, 0, 2, 71),
('Palomino Creek Block (1)', 'Red County', 12, 20071, 'Ne', 'Ne', 710.235, -727.849, 1088.73, 358.918, 18225, 0, 36, 0, 5554, 0, 0, 2, 72),
('Palomino Creek Block (1)', 'Red County', 13, 20072, 'Ne', 'Ne', 709.642, -736.489, 1088.73, 180.339, 18225, 0, 36, 1, 5554, 0, 0, 2, 73),
('Palomino Creek Block (2)', 'Palomino Creek', 1, 20073, 'Ne', 'Ne', 2511.81, 100.689, 1559.27, 179.72, 17044, 0, 36, 0, 6643, 0, 0, 2, 74),
('Palomino Creek Block (2)', 'Palomino Creek', 2, 20074, 'Ne', 'Ne', 2512.67, 105.816, 1559.27, 1.11785, 17044, 0, 36, 0, 6643, 0, 0, 2, 75),
('Palomino Creek Block (2)', 'Palomino Creek', 3, 20075, 'Ne', 'Ne', 2507.81, 105.979, 1559.27, 0.178041, 17044, 0, 36, 1, 6643, 0, 0, 2, 76),
('Palomino Creek Block (2)', 'Palomino Creek', 4, 20076, 'Ne', 'Ne', 2501.8, 105.974, 1559.27, 359.238, 17044, 0, 36, 0, 6643, 0, 0, 2, 77),
('Palomino Creek Block (2)', 'Palomino Creek', 5, 20077, 'Ne', 'Ne', 2500.23, 101.286, 1559.27, 88.5387, 17044, 0, 36, 1, 6643, 0, 0, 2, 78),
('Palomino Creek Block (2)', 'Palomino Creek', 6, 20078, 'Ne', 'Ne', 2512.06, 97.4972, 1562.75, 178.466, 17044, 0, 36, 1, 6643, 0, 0, 2, 79),
('Palomino Creek Block (2)', 'Palomino Creek', 7, 20079, 'Ne', 'Ne', 2513.93, 103.2, 1562.75, 270.587, 17044, 0, 36, 0, 6643, 0, 0, 2, 80),
('Palomino Creek Block (2)', 'Palomino Creek', 8, 20080, 'Ne', 'Ne', 2510.44, 108.799, 1562.75, 1.45441, 17044, 0, 36, 0, 6643, 0, 0, 2, 81),
('Palomino Creek Block (2)', 'Palomino Creek', 9, 20081, 'Ne', 'Ne', 2506.39, 105.111, 1562.75, 89.5019, 17044, 0, 36, 1, 6643, 0, 0, 2, 82),
('Fullum Street', 'Dillimore', 1, 20082, 'Ne', 'Ne', 742.378, -588.955, 17.7874, 271.242, 0, 0, 31, 0, 41854, 0, 0, 2, 83),
('Mayor Street', 'Dillimore', 1, 20083, 'Ne', 'Ne', 744.254, -512.544, 17.8355, 359.728, 0, 0, 31, 1, 41854, 0, 0, 2, 84),
('Mayor Street', 'Dillimore', 2, 20084, 'Ne', 'Ne', 744.027, -553.672, 17.9068, 180.5, 0, 0, 31, 1, 41854, 0, 1549475098, 2, 85),
('Mayor Street', 'Dillimore', 3, 20085, 'Ne', 'Ne', 769.392, -506.713, 17.8303, 358.161, 0, 0, 31, 0, 41854, 0, 0, 2, 86),
('Mayor Street', 'Dillimore', 4, 20086, 'Ne', 'Ne', 765.558, -553.795, 17.9891, 180.187, 0, 0, 31, 1, 41854, 0, 1549381412, 2, 87),
('Mayor Street', 'Dillimore', 5, 20087, 'Ne', 'Ne', 793.162, -509.595, 17.6994, 0.019782, 0, 0, 31, 1, 41854, 0, 0, 2, 88),
('Mayor Street', 'Dillimore', 6, 20088, 'Ne', 'Ne', 819.328, -512.596, 17.802, 0.957975, 0, 0, 31, 1, 41854, 0, 0, 2, 89),
('Larkinson\'s Trailer Park', 'Montgomery', 1, 20089, 'Ne', 'Ne', 1412.25, 310.92, 19.3061, 130.335, 0, 0, 38, 0, 15718, 0, 0, 2, 90),
('Larkinson\'s Trailer Park', 'Montgomery', 2, 20090, 'Ne', 'Ne', 1415.36, 324.041, 18.8438, 322.386, 0, 0, 38, 0, 15718, 0, 0, 2, 91),
('Larkinson\'s Trailer Park', 'Montgomery', 3, 20091, 'Ne', 'Ne', 1403.23, 333.839, 18.9062, 301.393, 0, 0, 38, 0, 15718, 0, 0, 2, 92),
('Larkinson\'s Trailer Park', 'Montgomery', 4, 20092, 'Ne', 'Ne', 1389.62, 339.237, 19.0268, 94.6144, 0, 0, 38, 0, 15718, 0, 0, 2, 93),
('Larkinson\'s Trailer Park', 'Montgomery', 5, 20093, 'Ne', 'Ne', 1389.73, 349.901, 19.323, 85.2143, 0, 0, 38, 0, 15718, 0, 0, 2, 94),
('Larkinson\'s Trailer Park', 'Montgomery', 6, 20094, 'Ne', 'Ne', 1409.07, 346.503, 19.252, 339.283, 0, 0, 38, 0, 15718, 0, 0, 2, 95),
('Larkinson\'s Trailer Park', 'Montgomery', 7, 20095, 'Ne', 'Ne', 1435.28, 334.775, 18.8417, 69.5241, 0, 0, 38, 0, 15718, 0, 0, 2, 96),
('Larkinson\'s Trailer Park', 'Montgomery', 8, 20096, 'Ne', 'Ne', 1435.97, 317.819, 18.8417, 212.092, 0, 0, 38, 0, 15718, 0, 0, 2, 97),
('Larkinson\'s Trailer Park', 'Montgomery', 9, 20097, 'Ne', 'Ne', 1440.06, 320.287, 18.8438, 212.092, 0, 0, 38, 0, 15718, 0, 0, 2, 98),
('Larkinson\'s Trailer Park', 'Red County', 10, 20098, 'Ne', 'Ne', 1453.88, 325.612, 18.8438, 199.245, 0, 0, 38, 0, 15718, 0, 0, 2, 99),
('Larkinson\'s Trailer Park', 'Red County', 11, 20099, 'Ne', 'Ne', 1458.44, 326.567, 18.8438, 197.365, 0, 0, 38, 0, 15718, 0, 0, 2, 100),
('Larkinson\'s Trailer Park', 'Red County', 12, 20100, 'Ne', 'Ne', 1461.23, 341.928, 18.9531, 22.8603, 0, 0, 38, 1, 15718, 0, 0, 2, 101),
('Larkinson\'s Trailer Park', 'Montgomery', 13, 20101, 'Ne', 'Ne', 1447.41, 361.792, 18.9086, 156.968, 0, 0, 38, 0, 15718, 0, 0, 2, 102),
('Larkinson\'s Trailer Park', 'Montgomery', 14, 20102, 'Ne', 'Ne', 1428.41, 356.012, 18.875, 340.583, 0, 0, 38, 0, 15718, 0, 0, 2, 103),
('Larkinson\'s Trailer Park', 'Montgomery', 15, 20103, 'Ne', 'Ne', 1413.7, 362.752, 19.1788, 59.5442, 0, 0, 38, 0, 15718, 0, 0, 2, 104),
('Larkinson\'s Trailer Park', 'Montgomery', 16, 20104, 'Ne', 'Ne', 1419.69, 389.863, 19.2912, 157.618, 0, 0, 38, 0, 15718, 0, 0, 2, 105),
('Larkinson\'s Trailer Park', 'Montgomery', 17, 20105, 'Ne', 'Ne', 1425.7, 400.445, 19.3927, 344.03, 0, 0, 38, 0, 15718, 0, 0, 2, 106),
('Larkinson\'s Trailer Park', 'Montgomery', 18, 20106, 'Ne', 'Ne', 1443.08, 395.019, 19.2656, 332.75, 0, 0, 38, 1, 15718, 0, 0, 2, 107),
('Larkinson\'s Trailer Park', 'Montgomery', 19, 20107, 'Ne', 'Ne', 1451.45, 375.378, 19.4005, 336.487, 0, 0, 38, 0, 15718, 0, 0, 2, 108),
('Larkinson\'s Trailer Park', 'Montgomery', 20, 20108, 'Ne', 'Ne', 1466.18, 364.87, 19.2787, 153.498, 0, 0, 38, 0, 15718, 0, 0, 2, 109),
('Larkinson\'s Trailer Park', 'Montgomery', 21, 20109, 'Ne', 'Ne', 1475.5, 373.129, 19.6562, 160.415, 0, 0, 38, 0, 15718, 0, 0, 2, 110),
('Larkinson\'s Trailer Park', 'Montgomery', 22, 20110, 'Ne', 'Ne', 1487.98, 360.649, 19.4093, 301.417, 0, 0, 38, 0, 15718, 0, 0, 2, 111),
('Larkinson\'s Trailer Park', 'Montgomery', 23, 20111, 'Ne', 'Ne', 1469.35, 351.32, 18.917, 299.537, 0, 0, 38, 1, 15718, 0, 0, 2, 112),
('Monty Gas Station Trailer', 'Montgomery', -2, 20112, 'Ne', 'Ne', 1411.09, 457.453, 20.2176, 270.373, 0, 0, 38, 1, 10890, 0, 1550606815, 2, 113),
('Clinton\'s Trailer Park', 'Montgomery', 1, 20113, 'Ne', 'Ne', 1284.42, 158.677, 20.7934, 103.366, 0, 0, 37, 0, 22978, 0, 0, 2, 114),
('Clinton\'s Trailer Park', 'Montgomery', 2, 20114, 'Ne', 'Ne', 1293.7, 157.293, 20.4609, 288.861, 0, 0, 37, 0, 22978, 0, 0, 2, 115),
('Clinton\'s Trailer Park', 'Montgomery', 3, 20115, 'Ne', 'Ne', 1299.17, 140.856, 20.4072, 179.506, 0, 0, 37, 0, 22978, 0, 0, 2, 116),
('Clinton\'s Trailer Park', 'Montgomery', 4, 20116, 'Ne', 'Ne', 1306.29, 148.767, 20.3498, 73.9352, 0, 0, 37, 0, 22978, 0, 0, 2, 117),
('Clinton\'s Trailer Park', 'Montgomery', 5, 20117, 'Ne', 'Ne', 1307.82, 153.181, 20.3885, 72.9952, 0, 0, 37, 0, 22978, 0, 0, 2, 118),
('Clinton\'s Trailer Park', 'Montgomery', 6, 20118, 'Ne', 'Ne', 1312.02, 170.1, 20.4609, 162.609, 0, 0, 38, 0, 22978, 0, 0, 2, 119),
('Clinton\'s Trailer Park', 'Montgomery', 7, 20119, 'Ne', 'Ne', 1316.33, 180.152, 20.4609, 83.3353, 0, 0, 37, 0, 22978, 0, 0, 2, 120),
('Clinton\'s Trailer Park', 'Montgomery', 8, 20120, 'Ne', 'Ne', 1303.33, 186.457, 20.4609, 213.683, 0, 0, 37, 0, 22978, 0, 0, 2, 121),
('Clinton\'s Trailer Park', 'Montgomery', 9, 20121, 'Ne', 'Ne', 1300.8, 192.783, 20.4609, 31.6346, 0, 0, 37, 0, 22978, 0, 0, 2, 122),
('Clinton\'s Trailer Park', 'Montgomery', 10, 20122, 'Ne', 'Ne', 1296.72, 190.472, 20.4609, 30.6946, 0, 0, 37, 0, 22978, 0, 0, 2, 123),
('Clinton\'s Trailer Park', 'Montgomery', 11, 20123, 'Ne', 'Ne', 1294.87, 174.764, 20.9106, 248.777, 0, 0, 38, 0, 22978, 0, 0, 2, 124),
('Route 48 Shack Alley', 'Red County', 1, 20127, 'Ne', 'Ne', 1176.41, -147.771, 40.8247, 39.1312, 0, 0, 38, 0, 78638, 0, 0, 2, 128),
('Route 48 Shack Alley', 'Red County', 2, 20128, 'Ne', 'Ne', 1155.55, -163.296, 41.6335, 6.85755, 0, 0, 38, 0, 78638, 0, 0, 2, 129),
('?', 'Fern Ridge', 0, 20129, 'Ne', 'Ne', 869.767, -26.2676, 63.8805, 335.861, 0, 0, 18, 1, 0, 0, 1549400952, 2, 130),
('Rumbley Block', 'Blueberry', 1, 20131, 'Ne', 'Ne', 159.226, -112.58, 1.55628, 91.6844, 0, 0, 36, 0, 6038, 0, 0, 2, 132),
('Rumbley Block', 'Blueberry', 2, 20132, 'Ne', 'Ne', 159.02, -102.583, 1.55643, 89.8278, 0, 0, 36, 1, 6038, 0, 0, 2, 133),
('Rumbley Block', 'Blueberry', 3, 20133, 'Ne', 'Ne', 166.27, -95.4967, 1.5549, 359.901, 0, 0, 36, 0, 6038, 0, 0, 2, 134),
('Rumbley Block', 'Blueberry', 6, 20134, 'Ne', 'Ne', 201.472, -95.3509, 1.5549, 359.587, 0, 0, 36, 0, 6038, 0, 0, 2, 135),
('Rumbley Block', 'Blueberry', 9, 20135, 'Ne', 'Ne', 201.384, -119.789, 1.55141, 183.179, 0, 0, 36, 0, 6038, 0, 0, 2, 136),
('Rumbley Block', 'Blueberry', 10, 20136, 'Ne', 'Ne', 189.452, -119.669, 1.5485, 180.673, 0, 0, 36, 0, 6038, 0, 0, 2, 137),
('Rumbley Block', 'Blueberry', 11, 20137, 'Ne', 'Ne', 178.221, -119.402, 1.54906, 182.239, 0, 0, 36, 1, 6038, 0, 0, 2, 138),
('Rumbley Block', 'Blueberry', 12, 20138, 'Ne', 'Ne', 166.228, -119.668, 1.55492, 180.359, 0, 0, 36, 0, 6038, 0, 0, 2, 139),
('Rumbley Block', 'Blueberry', 13, 20139, 'Ne', 'Ne', 178.374, -118.004, 4.89647, 180.044, 0, 0, 36, 0, 6038, 0, 0, 2, 140),
('Rumbley Block', 'Blueberry', 14, 20140, 'Ne', 'Ne', 166.424, -118.234, 4.89647, 180.673, 0, 0, 36, 1, 6038, 0, 0, 2, 141),
('Rumbley Block', 'Blueberry', 15, 20141, 'Ne', 'Ne', 160.631, -112.617, 4.89647, 88.5518, 0, 0, 36, 0, 6038, 0, 0, 2, 142),
('Rumbley Block', 'Blueberry', 16, 20142, 'Ne', 'Ne', 160.631, -102.701, 4.89647, 92.3118, 0, 0, 36, 1, 6038, 0, 0, 2, 143),
('Rumbley Block', 'Blueberry', 17, 20143, 'Ne', 'Ne', 166.2, -96.972, 4.89647, 354.551, 0, 0, 36, 0, 6038, 0, 0, 2, 144),
('Rumbley Block', 'Blueberry', 18, 20144, 'Ne', 'Ne', 178.173, -96.9718, 4.89647, 0.190774, 0, 0, 36, 0, 6038, 0, 0, 2, 145),
('Rumbley Block', 'Blueberry', 19, 20145, 'Ne', 'Ne', 189.509, -96.972, 4.89647, 1.44442, 0, 0, 36, 0, 6038, 0, 0, 2, 146),
('Rumbley Block', 'Blueberry', 20, 20146, 'Ne', 'Ne', 201.501, -96.9726, 4.89647, 357.371, 0, 0, 36, 0, 6038, 0, 1550596416, 2, 147),
('Rumbley Block', 'Blueberry', 21, 20147, 'Ne', 'Ne', 207.076, -112.358, 4.89647, 267.757, 0, 0, 36, 1, 6038, 0, 0, 2, 148),
('Rumbley Block', 'Blueberry', 22, 20148, 'Ne', 'Ne', 201.519, -118.234, 4.89647, 180.336, 0, 0, 36, 0, 6038, 0, 0, 2, 149),
('Main Street', 'Blueberry', 1, 20149, 'Ne', 'Ne', 250.604, -121.262, 3.41966, 268.697, 0, 0, 31, 0, 42338, 0, 0, 2, 150),
('Main Street', 'Blueberry', 2, 20150, 'Ne', 'Ne', 251.082, -92.3187, 3.53906, 269.01, 0, 0, 31, 0, 42338, 0, 0, 2, 151),
('St. James Street', 'Blueberry', 1, 20151, 'Ne', 'Ne', 262.269, -56.2408, 2.77721, 269.95, 0, 0, 31, 1, 42338, 0, 0, 2, 152),
('St. James Street', 'Blueberry', 2, 20152, 'Ne', 'Ne', 293.745, -55.189, 2.62849, 270.263, 0, 0, 31, 0, 42338, 0, 0, 2, 153),
('First Street', 'Blueberry', 1, 20153, 'Ne', 'Ne', 314.878, -92.3272, 3.48472, 91.3484, 0, 0, 31, 0, 42338, 0, 0, 2, 154),
('First Street', 'Blueberry', 2, 20154, 'Ne', 'Ne', 314.697, -121.251, 3.53906, 90.0951, 0, 0, 31, 0, 42338, 0, 0, 2, 155),
('Carrollton Trailer Park', 'Blueberry', 1, 20155, 'Ne', 'Ne', 227.769, -303.508, 1.92618, 268.337, 0, 0, 37, 0, 14508, 0, 0, 2, 156),
('Carrollton Trailer Park', 'Blueberry', 2, 20156, 'Ne', 'Ne', 235.122, -308.942, 1.58358, 180.602, 0, 0, 37, 0, 14508, 0, 0, 2, 157),
('Carrollton Trailer Park', 'Blueberry', 3, 20157, 'Ne', 'Ne', 259.12, -301.829, 1.91837, 230.109, 0, 0, 37, 1, 14508, 0, 0, 2, 158),
('Carrollton Trailer Park', 'Blueberry', 4, 20158, 'Ne', 'Ne', 263.809, -288.49, 1.57812, 270.53, 0, 0, 37, 0, 14508, 0, 0, 2, 159),
('Carrollton Trailer Park', 'Blueberry', 5, 20159, 'Ne', 'Ne', 264.445, -283.837, 1.72643, 270.216, 0, 0, 37, 0, 14508, 0, 0, 2, 160),
('Carrollton Trailer Park', 'Blueberry', 6, 20160, 'Ne', 'Ne', 256.125, -278.477, 1.57812, 120.755, 0, 0, 37, 0, 14508, 0, 0, 2, 161),
('Carrollton Trailer Park', 'Blueberry', 7, 20161, 'Ne', 'Ne', 253.793, -274.287, 1.58358, 121.068, 0, 0, 37, 0, 14508, 0, 0, 2, 162),
('Carrollton Trailer Park', 'Blueberry', 8, 20162, 'Ne', 'Ne', 262.002, -270.032, 1.64049, 308.733, 0, 0, 37, 0, 14508, 0, 0, 2, 163),
('Carrollton Trailer Park', 'Blueberry', 9, 20163, 'Ne', 'Ne', 241.362, -282.191, 1.58358, 233.869, 0, 0, 37, 0, 14508, 0, 0, 2, 164),
('Carrollton Trailer Park', 'Blueberry', 10, 20164, 'Ne', 'Ne', 238.836, -286.314, 1.63268, 238.569, 0, 0, 37, 0, 14508, 0, 0, 2, 165),
('Carrollton Trailer Park', 'Blueberry', 11, 20165, 'Ne', 'Ne', 229.289, -295.31, 1.57812, 3.56727, 0, 0, 37, 0, 14508, 0, 0, 2, 166),
('Carrollton Trailer Park', 'Blueberry', 12, 20166, 'Ne', 'Ne', 242.022, -297.932, 1.57812, 179.326, 0, 0, 37, 1, 14508, 0, 0, 2, 167),
('Carrollton Trailer Park', 'Blueberry', 13, 20167, 'Ne', 'Ne', 252.603, -289.844, 1.57812, 268.626, 0, 0, 37, 0, 14508, 0, 0, 2, 168),
('Trailer Park of Grey God', 'Blueberry', 1, 20168, 'Ne', 'Ne', 248.046, -33.1611, 1.57812, 269.88, 0, 0, 37, 0, 14508, 0, 0, 2, 169),
('Trailer Park of Grey God', 'Blueberry', 2, 20169, 'Ne', 'Ne', 253.266, -22.7106, 1.60781, 359.181, 0, 0, 37, 0, 14508, 0, 0, 2, 170),
('Trailer Park of Grey God', 'Blueberry', 3, 20170, 'Ne', 'Ne', 291.752, 14.7261, 2.78386, 100.388, 0, 0, 37, 0, 14508, 0, 0, 2, 171),
('Trailer Park of Grey God', 'Blueberry', 4, 20171, 'Ne', 'Ne', 285.986, 41.212, 2.54844, 200.656, 0, 0, 37, 0, 14508, 0, 0, 2, 172),
('Trailer Park of Grey God', 'Blueberry', 5, 20172, 'Ne', 'Ne', 309.385, 44.1156, 3.08797, 28.9708, 0, 0, 37, 0, 14508, 0, 0, 2, 173),
('Trailer Park of Grey God', 'Blueberry', 6, 20173, 'Ne', 'Ne', 317.3, 54.929, 3.375, 230.423, 0, 0, 37, 0, 14508, 0, 0, 2, 174),
('Trailer Park of Grey God', 'Blueberry', 7, 20174, 'Ne', 'Ne', 342.49, 62.6703, 3.85872, 304.057, 0, 0, 37, 0, 14508, 0, 0, 2, 175),
('Trailer Park of Grey God', 'Blueberry', 8, 20175, 'Ne', 'Ne', 340.381, 33.974, 6.41314, 133.288, 0, 0, 37, 0, 14508, 0, 0, 2, 176),
('Trailer Park of Grey God', 'Blueberry', 9, 20176, 'Ne', 'Ne', 316.664, 17.4907, 4.51562, 12.6539, 0, 0, 37, 0, 14508, 0, 0, 2, 177),
('North Hampton Barns', 'Hampton Barns', 1, 20177, 'Ne', 'Ne', 748.751, 350.485, 20.4345, 37.4078, 0, 0, 37, 0, 10878, 0, 0, 2, 178),
('North Hampton Barns', 'Red County', 2, 20178, 'Ne', 'Ne', 772.329, 346.941, 20.1527, 10.461, 0, 0, 37, 0, 10878, 0, 0, 2, 179),
('North Hampton Barns', 'Red County', 3, 20179, 'Ne', 'Ne', 783.799, 353.471, 19.5938, 190.919, 0, 0, 37, 0, 10878, 0, 0, 2, 180),
('North Hampton Barns', 'Red County', 4, 20180, 'Ne', 'Ne', 804.378, 359.203, 19.7621, 267.06, 0, 0, 37, 0, 10878, 0, 0, 2, 181),
('North Hampton Barns', 'Red County', 5, 20181, 'Ne', 'Ne', 807.316, 372.327, 19.3997, 263.613, 0, 0, 37, 0, 10878, 0, 0, 2, 182),
('North Hampton Barns', 'Red County', 6, 20182, 'Ne', 'Ne', 787.873, 376.549, 21.1997, 157.102, 0, 0, 37, 0, 10878, 0, 0, 2, 183),
('North Hampton Barns', 'Red County', 7, 20183, 'Ne', 'Ne', 783.371, 378.005, 21.2109, 157.102, 0, 0, 37, 0, 10878, 0, 0, 2, 184),
('North Hampton Barns', 'Red County', 8, 20184, 'Ne', 'Ne', 758.529, 374.965, 23.1962, 281.497, 0, 0, 37, 1, 10878, 0, 0, 2, 185),
('North Hampton Barns', 'Red County', 9, 20185, 'Ne', 'Ne', 752.413, 375.361, 23.2361, 105.112, 0, 0, 37, 1, 10878, 0, 0, 2, 186),
('South Hampton Barns', 'Hampton Barns', 1, 20186, 'Ne', 'Ne', 759.49, 295.929, 20.5201, 184.699, 0, 0, 37, 0, 10878, 0, 0, 2, 187),
('South Hampton Barns', 'Hampton Barns', 2, 20187, 'Ne', 'Ne', 747.459, 305.137, 20.2344, 98.2185, 0, 0, 37, 1, 10878, 0, 0, 2, 188),
('South Hampton Barns', 'Hampton Barns', 3, 20188, 'Ne', 'Ne', 718.802, 300.661, 20.2344, 277.447, 0, 0, 37, 1, 10878, 0, 0, 2, 189),
('South Hampton Barns', 'Hampton Barns', 4, 20189, 'Ne', 'Ne', 705.432, 291.612, 20.4219, 6.09767, 0, 0, 37, 1, 10878, 0, 0, 2, 190),
('South Hampton Barns', 'Hampton Barns', 5, 20190, 'Ne', 'Ne', 723.654, 268.775, 22.4531, 357.638, 0, 0, 37, 1, 10878, 0, 1550699324, 2, 191),
('South Hampton Barns', 'Red County', 6, 20191, 'Ne', 'Ne', 748.032, 258.009, 27.0859, 194.076, 0, 0, 37, 1, 10878, 0, 0, 2, 192),
('South Hampton Barns', 'Hampton Barns', 7, 20192, 'Ne', 'Ne', 748.124, 278.389, 27.2484, 101.979, 0, 0, 37, 0, 10878, 0, 0, 2, 193),
('Route 48 Exit', 'Red County', 1, 20193, 'Ne', 'Ne', 2141.88, 35.7598, 26.368, 176.561, 0, 0, 37, 1, 9668, 0, 0, 2, 194),
('Hacienda Carvajal', 'Red County', 1, 20194, 'Ne', 'Ne', 2878.1, -161.437, 21.2516, 182.215, 0, 0, 35, 0, 145188, 0, 0, 2, 195),
('Hacienda Carvajal', 'Red County', 2, 20196, 'Ne', 'Ne', 2888.44, -189.776, 13.457, 358.576, 0, 0, 35, 0, 133088, 0, 0, 2, 197),
('Hacienda Carvajal', 'Red County', 3, 20197, 'Ne', 'Ne', 2882.25, -227.527, 7.72268, 89.7574, 0, 0, 35, 0, 133088, 0, 0, 2, 198),
('East Highway Mansions', 'Los Angeles', 1, 20198, 'Ne', 'Ne', 2928.8, -783.998, 11.0606, 269.299, 0, 0, 34, 0, 241988, 0, 0, 2, 199),
('East Highway Mansions', 'Red County', 2, 20199, 'Ne', 'Ne', 2930.96, -754.264, 11.58, 257.705, 0, 0, 34, 0, 290388, 0, 0, 2, 200),
('East Highway Mansions', 'Red County', 3, 20200, 'Ne', 'Ne', 2926.27, -733.04, 10.8853, 268.985, 0, 0, 34, 0, 217788, 0, 0, 2, 201),
('East Highway Mansions', 'Red County', 4, 20201, 'Ne', 'Ne', 2932.1, -696.951, 11.4013, 269.612, 0, 0, 35, 0, 483988, 0, 0, 2, 202),
('East Highway Mansions', 'Red County', 5, 20202, 'Ne', 'Ne', 2947.45, -648.891, 10.8805, 269.925, 0, 0, 34, 0, 241988, 0, 0, 2, 203),
('Montgomery Pine Complex', 'Red County', 1, 20203, 'Ne', 'Ne', 724.362, -728.005, 1085.02, 357.084, 15744, 0, 36, 0, 6038, 0, 0, 2, 204),
('Montgomery Pine Complex', 'Red County', 2, 20204, 'Ne', 'Ne', 724.598, -730.265, 1085.02, 181.616, 15744, 0, 36, 0, 6038, 0, 0, 2, 205),
('Montgomery Pine Complex', 'Red County', 3, 20205, 'Ne', 'Ne', 720.238, -728.051, 1085.02, 0.507449, 15744, 0, 36, 0, 6038, 0, 0, 2, 206),
('Montgomery Pine Complex', 'Red County', 4, 20206, 'Ne', 'Ne', 720.352, -730.265, 1085.02, 178.146, 15744, 0, 36, 0, 6038, 0, 0, 2, 207),
('Montgomery Pine Complex', 'Red County', 6, 20207, 'Ne', 'Ne', 710.262, -728.051, 1085.02, 359.231, 15744, 0, 36, 0, 6038, 0, 0, 2, 208),
('Montgomery Pine Complex', 'Red County', 7, 20208, 'Ne', 'Ne', 710.063, -736.466, 1085.02, 178.749, 15744, 0, 36, 0, 6038, 0, 0, 2, 209),
('Montgomery Pine Complex', 'Red County', 8, 20209, 'Ne', 'Ne', 724.943, -736.524, 1088.73, 179.689, 15744, 0, 36, 0, 6038, 0, 0, 2, 210),
('Montgomery Pine Complex', 'Red County', 9, 20210, 'Ne', 'Ne', 724.996, -727.85, 1088.74, 1.11065, 15744, 0, 36, 0, 6038, 0, 0, 2, 211),
('Montgomery Pine Complex', 'Red County', 10, 20211, 'Ne', 'Ne', 720.341, -727.849, 1088.73, 359.231, 15744, 0, 36, 0, 6038, 0, 0, 2, 212),
('Montgomery Pine Complex', 'Red County', 11, 20212, 'Ne', 'Ne', 715.26, -727.849, 1088.73, 358.917, 15744, 0, 36, 0, 6038, 0, 0, 2, 213),
('Montgomery Pine Complex', 'Red County', 12, 20213, 'Ne', 'Ne', 710.311, -727.981, 1088.73, 359.857, 15744, 0, 36, 0, 6038, 0, 0, 2, 214),
('Montgomery Pine Complex', 'Red County', 13, 20214, 'Ne', 'Ne', 709.695, -736.489, 1088.73, 178.459, 15744, 0, 36, 0, 6038, 0, 0, 2, 215),
('Montgomery Birch Complex', 'Palomino Creek', 1, 20215, 'Ne', 'Ne', 2512.65, 105.979, 1559.27, 358.611, 19752, 0, 36, 0, 6038, 0, 0, 2, 216),
('Montgomery Birch Complex', 'Palomino Creek', 2, 20216, 'Ne', 'Ne', 2511.84, 100.687, 1559.27, 184.733, 19752, 0, 36, 0, 6038, 0, 0, 2, 217),
('Montgomery Birch Complex', 'Palomino Creek', 3, 20217, 'Ne', 'Ne', 2507.8, 105.975, 1559.27, 1.43122, 19752, 0, 36, 0, 6038, 0, 0, 2, 218),
('Montgomery Birch Complex', 'Palomino Creek', 4, 20218, 'Ne', 'Ne', 2501.81, 105.979, 1559.27, 1.11785, 19752, 0, 36, 0, 6038, 0, 0, 2, 219),
('Montgomery Birch Complex', 'Palomino Creek', 5, 20219, 'Ne', 'Ne', 2500.23, 101.355, 1559.27, 86.9721, 19752, 0, 36, 0, 6038, 0, 0, 2, 220),
('Montgomery Birch Complex', 'Palomino Creek', 6, 20220, 'Ne', 'Ne', 2512.05, 97.6133, 1562.75, 181.286, 19752, 0, 36, 0, 6038, 0, 0, 2, 221),
('Montgomery Birch Complex', 'Palomino Creek', 7, 20221, 'Ne', 'Ne', 2513.93, 103.173, 1562.75, 269.334, 19752, 0, 36, 0, 6038, 0, 0, 2, 222),
('Montgomery Birch Complex', 'Palomino Creek', 8, 20222, 'Ne', 'Ne', 2510.49, 108.415, 1562.75, 1.45455, 19752, 0, 36, 1, 6038, 0, 0, 2, 223),
('Montgomery Birch Complex', 'Palomino Creek', 9, 20223, 'Ne', 'Ne', 2506.63, 105.141, 1562.75, 90.7554, 19752, 0, 36, 0, 6038, 0, 0, 2, 224),
('Caine Motel Room', 'Garcia', 1, 20224, 'Ne', 'Ne', -2339.84, -95.5049, 1496.86, 359.808, 17349, 0, 23, 0, 61, 1, 0, 2, 225),
('Caine Motel Room', 'Garcia', 2, 20225, 'Ne', 'Ne', -2333.43, -92.2373, 1496.86, 0.434763, 17349, 0, 23, 0, 61, 1, 0, 2, 226),
('Caine Motel Room', 'Garcia', 3, 20226, 'Ne', 'Ne', -2325.6, -96.3953, 1496.86, 267.687, 17349, 0, 23, 0, 61, 1, 0, 2, 227),
('Caine Motel Room', 'Garcia', 4, 20227, 'Ne', 'Ne', -2325.57, -92.8633, 1496.86, 271.761, 17349, 0, 23, 1, 61, 1, 1552418080, 2, 228),
('Caine Motel Room', 'Garcia', 5, 20228, 'Ne', 'Ne', -2327.19, -90.9546, 1496.86, 0.121947, 17349, 0, 23, 0, 61, 1, 0, 2, 229),
('Caine Motel Room', 'Garcia', 6, 20229, 'Ne', 'Ne', -2325.61, -90.2931, 1500.39, 270.507, 17349, 0, 23, 1, 61, 1, 1554557472, 2, 230),
('Caine Motel Room', 'Garcia', 7, 20230, 'Ne', 'Ne', -2325.66, -95.199, 1500.39, 271.134, 17349, 0, 23, 0, 61, 1, 1555259164, 2, 231),
('Caine Motel Room', 'Garcia', 8, 20231, 'Ne', 'Ne', -2327.82, -97.9606, 1500.39, 181.833, 17349, 0, 23, 0, 97, 1, 0, 2, 232),
('Caine Motel Room', 'Garcia', 9, 20232, 'Ne', 'Ne', -2335.38, -95.7855, 1500.39, 357.615, 17349, 0, 23, 0, 61, 1, 1554554791, 2, 233),
('Caine Motel Room', 'Garcia', 10, 20233, 'Ne', 'Ne', -2335.1, -97.9371, 1500.39, 181.52, 17349, 0, 23, 0, 61, 1, 0, 2, 234),
('Caine Motel Room', 'Garcia', 11, 20234, 'Ne', 'Ne', -2339.77, -95.7281, 1500.39, 355.085, 17349, 0, 23, 0, 61, 1, 1553556579, 2, 235),
('Caine Motel Room', 'Garcia', 12, 20235, 'Ne', 'Ne', -2339.57, -97.928, 1500.39, 177.133, 17349, 0, 23, 0, 61, 1, 0, 2, 236),
('Caine Motel Room', 'Garcia', 13, 20236, 'Ne', 'Ne', -2342.58, -96.7464, 1500.39, 90.9658, 17349, 0, 23, 1, 61, 1, 1554557499, 2, 237),
('Caine Motel Room', 'Garcia', 14, 20237, 'Ne', 'Ne', -2320.72, -87.8213, 1503.88, 271.134, 17349, 0, 23, 0, 61, 1, 0, 2, 238),
('Caine Motel Room', 'Garcia', 15, 20238, 'Ne', 'Ne', -2323.06, -89.8854, 1503.88, 92.8459, 17349, 0, 23, 0, 61, 1, 1554138459, 2, 239),
('Caine Motel Room', 'Garcia', 16, 20239, 'Ne', 'Ne', -2320.67, -92.4434, 1503.88, 268.314, 17349, 0, 23, 0, 61, 1, 0, 2, 240),
('Caine Motel Room', 'Garcia', 17, 20240, 'Ne', 'Ne', -2321.81, -94.4861, 1503.88, 179.64, 17349, 0, 23, 0, 61, 1, 0, 2, 241),
('Caine Motel Room', 'Garcia', 18, 20241, 'Ne', 'Ne', -2328.91, -97.38, 1503.88, 1.66507, 17349, 0, 23, 0, 61, 1, 0, 2, 242),
('Caine Motel Room', 'Garcia', 19, 20242, 'Ne', 'Ne', -2329.47, -99.9596, 1503.88, 181.833, 17349, 0, 23, 1, 61, 1, 1555268941, 2, 243),
('Caine Motel Room', 'Garcia', 20, 20243, 'Ne', 'Ne', -2334.02, -97.0932, 1503.88, 353.205, 17349, 0, 23, 0, 61, 1, 0, 2, 244),
('Caine Motel Room', 'Garcia', 21, 20244, 'Ne', 'Ne', -2333.76, -100.3, 1503.88, 181.52, 17349, 0, 23, 0, 61, 1, 0, 2, 245),
('Caine Motel Room', 'Garcia', 22, 20245, 'Ne', 'Ne', -2337.67, -97.1208, 1503.88, 2.29175, 17349, 0, 23, 0, 61, 1, 0, 2, 246),
('Caine Motel Room', 'Garcia', 23, 20246, 'Ne', 'Ne', -2337.59, -100.388, 1503.88, 185.28, 17349, 0, 23, 0, 61, 1, 0, 2, 247),
('Caine Motel Room', 'Garcia', 24, 20247, 'Ne', 'Ne', -2339.98, -98.7101, 1503.88, 90.9658, 17349, 0, 23, 0, 61, 1, 0, 2, 248),
('Fisher Street', 'Fort Carson', 1, 20248, 'Ne', 'Ne', -246.673, 1001.8, 20.7456, 90.8775, 0, 0, 31, 1, 55648, 0, 0, 2, 249),
('Fisher Street', 'Fort Carson', 2, 20249, 'Ne', 'Ne', -278.816, 1003.61, 20.9399, 85.1649, 0, 0, 31, 0, 55648, 0, 0, 2, 250),
('West Street', 'Fort Carson', 1, 20250, 'Ne', 'Ne', -260.155, 1043.63, 20.9399, 359.43, 0, 0, 31, 0, 55648, 0, 0, 2, 251),
('West Street', 'Fort Carson', 2, 20251, 'Ne', 'Ne', -260.872, 1120.51, 20.9399, 178.949, 0, 0, 31, 0, 55648, 0, 0, 2, 252),
('West Street', 'Fort Carson', 3, 20252, 'Ne', 'Ne', -258.91, 1151.48, 20.9399, 179.262, 0, 0, 31, 1, 55648, 0, 1549372199, 2, 253),
('West Street', 'Fort Carson', 4, 20253, 'Ne', 'Ne', -260.129, 1168.38, 20.9399, 359.43, 0, 0, 31, 0, 55648, 0, 0, 2, 254),
('Half Street', 'Fort Carson', 1, 20254, 'Ne', 'Ne', -290.177, 1175.46, 20.9399, 359.117, 0, 0, 31, 0, 55648, 0, 0, 2, 255),
('Half Street', 'Fort Carson', 2, 20255, 'Ne', 'Ne', -323.786, 1163.89, 20.9399, 90.9241, 0, 0, 31, 0, 55648, 0, 0, 2, 256),
('Half Street', 'Fort Carson', 3, 20256, 'Ne', 'Ne', -368.021, 1167.86, 20.2719, 48.3104, 0, 0, 31, 0, 104048, 0, 0, 2, 257),
('Half Street', 'Fort Carson', 4, 20257, 'Ne', 'Ne', -360.231, 1140.12, 20.9399, 358.78, 0, 0, 31, 0, 55648, 0, 0, 2, 258),
('Half Street', 'Fort Carson', 5, 20258, 'Ne', 'Ne', -362.184, 1110.42, 20.9399, 0.034264, 0, 0, 31, 1, 55648, 0, 1549381667, 2, 259),
('Half Street', 'Fort Carson', 6, 20259, 'Ne', 'Ne', -330.097, 1118.52, 20.9399, 358.153, 0, 0, 31, 0, 55648, 0, 0, 2, 260),
('Half Street', 'Fort Carson', 7, 20260, 'Ne', 'Ne', -298.631, 1114.96, 20.9399, 271.069, 0, 0, 31, 0, 55648, 0, 0, 2, 261),
('Home Street', 'Fort Carson', 1, 20261, 'Ne', 'Ne', -257.776, 1083.78, 20.9399, 88.7075, 0, 0, 31, 0, 55648, 0, 0, 2, 262),
('Home Street', 'Fort Carson', 2, 20262, 'Ne', 'Ne', -45.7884, 1083.02, 20.9399, 268.853, 0, 0, 31, 0, 55648, 0, 0, 2, 263),
('Home Street', 'Fort Carson', 3, 20263, 'Ne', 'Ne', -35.3662, 1113.74, 20.9399, 91.5277, 0, 0, 31, 0, 55648, 0, 0, 2, 264),
('Home Street', 'Fort Carson', 4, 20264, 'Ne', 'Ne', -18.4881, 1114.96, 20.9399, 269.816, 0, 0, 31, 1, 55648, 0, 1549314046, 2, 265),
('Home Street', 'Fort Carson', 5, 20265, 'Ne', 'Ne', 12.064, 1113.11, 20.9399, 269.816, 0, 0, 31, 0, 55648, 0, 0, 2, 266),
('Low Street', 'Fort Carson', 1, 20266, 'Ne', 'Ne', 1.1042, 1076.31, 20.9399, 178.949, 0, 0, 31, 0, 55648, 0, 0, 2, 267),
('Low Street', 'Fort Carson', 2, 20267, 'Ne', 'Ne', -32.9583, 1037.97, 20.9399, 269.793, 0, 0, 31, 0, 55648, 0, 0, 2, 268),
('Minion Motel', 'Fort Carson', 1, 20268, 'Ne', 'Ne', 98.963, 1180.09, 18.6636, 271.383, 0, 0, 23, 1, 36, 1, 1554193864, 2, 269),
('Minion Motel', 'Fort Carson', 2, 20269, 'Ne', 'Ne', 99.111, 1177.83, 18.6636, 269.189, 0, 0, 23, 1, 36, 1, 1554129473, 2, 270),
('Minion Motel', 'Fort Carson', 3, 20270, 'Ne', 'Ne', 98.7696, 1171.94, 18.6636, 270.443, 0, 0, 23, 0, 36, 1, 0, 2, 271),
('Minion Motel', 'Fort Carson', 4, 20271, 'Ne', 'Ne', 98.7746, 1169.78, 18.6636, 269.503, 0, 0, 23, 0, 36, 1, 0, 2, 272),
('Minion Motel', 'Fort Carson', 5, 20272, 'Ne', 'Ne', 98.8931, 1164.12, 18.6636, 269.503, 0, 0, 23, 1, 36, 1, 1555353503, 2, 273),
('Minion Motel', 'Fort Carson', 6, 20273, 'Ne', 'Ne', 98.6844, 1161.75, 18.656, 268.876, 0, 0, 23, 1, 36, 1, 1555681224, 2, 274),
('Minion Motel', 'Fort Carson', 7, 20274, 'Ne', 'Ne', 99.0416, 1180, 20.9402, 268.853, 0, 0, 23, 0, 36, 1, 0, 2, 275),
('Minion Motel', 'Fort Carson', 8, 20275, 'Ne', 'Ne', 99.176, 1177.74, 20.9402, 272.613, 0, 0, 23, 0, 36, 1, 0, 2, 276),
('Minion Motel', 'Fort Carson', 9, 20276, 'Ne', 'Ne', 99.0232, 1171.97, 20.9402, 271.673, 0, 0, 23, 0, 36, 1, 0, 2, 277),
('Minion Motel', 'Fort Carson', 10, 20277, 'Ne', 'Ne', 99.0558, 1169.72, 20.9402, 271.36, 0, 0, 23, 0, 36, 1, 0, 2, 278),
('Minion Motel', 'Fort Carson', 11, 20278, 'Ne', 'Ne', 99.0683, 1163.94, 20.9402, 271.36, 0, 0, 23, 0, 36, 1, 0, 2, 279),
('Minion Motel', 'Fort Carson', 12, 20279, 'Ne', 'Ne', 98.9432, 1161.73, 20.9402, 270.42, 0, 0, 23, 0, 36, 1, 0, 2, 280),
('Dwarf Motel', 'Fort Carson', 1, 20280, 'Ne', 'Ne', 86.6348, 1162.18, 18.656, 179.262, 0, 0, 23, 0, 36, 1, 0, 2, 281),
('Dwarf Motel', 'Fort Carson', 2, 20281, 'Ne', 'Ne', 84.2081, 1162.13, 18.656, 182.395, 0, 0, 23, 0, 36, 1, 0, 2, 282),
('Dwarf Motel', 'Fort Carson', 3, 20282, 'Ne', 'Ne', 78.6565, 1162.34, 18.6636, 181.769, 0, 0, 23, 0, 36, 1, 0, 2, 283),
('Dwarf Motel', 'Fort Carson', 4, 20283, 'Ne', 'Ne', 76.3938, 1162.01, 18.6636, 181.142, 0, 0, 23, 0, 36, 1, 0, 2, 284),
('Dwarf Motel', 'Fort Carson', 5, 20284, 'Ne', 'Ne', 70.7557, 1162.19, 18.6636, 181.768, 0, 0, 23, 0, 36, 1, 0, 2, 285),
('Dwarf Motel', 'Fort Carson', 6, 20285, 'Ne', 'Ne', 68.255, 1162.38, 18.6636, 180.828, 0, 0, 23, 0, 36, 1, 0, 2, 286),
('Dwarf Motel', 'Fort Carson', 7, 20286, 'Ne', 'Ne', 86.7269, 1162.09, 20.9402, 180.515, 0, 0, 23, 0, 36, 1, 0, 2, 287),
('Dwarf Motel', 'Fort Carson', 8, 20287, 'Ne', 'Ne', 84.2991, 1161.96, 20.9402, 179.575, 0, 0, 23, 0, 36, 1, 0, 2, 288),
('Dwarf Motel', 'Fort Carson', 9, 20288, 'Ne', 'Ne', 78.5413, 1161.96, 20.9402, 179.892, 0, 0, 23, 0, 36, 1, 0, 2, 289),
('Dwarf Motel', 'Fort Carson', 10, 20289, 'Ne', 'Ne', 76.3282, 1161.96, 20.9402, 179.892, 0, 0, 23, 0, 36, 1, 0, 2, 290),
('Dwarf Motel', 'Fort Carson', 11, 20290, 'Ne', 'Ne', 70.4844, 1161.96, 20.9402, 181.768, 0, 0, 23, 0, 36, 1, 0, 2, 291),
('Dwarf Motel', 'Fort Carson', 12, 20291, 'Ne', 'Ne', 68.3393, 1161.96, 20.9402, 185.529, 0, 0, 23, 0, 36, 1, 0, 2, 292),
('Elegant Rooms', 'Fort Carson', 1, 20292, 'Ne', 'Ne', 25.6313, 1181.45, 19.2621, 271.14, 0, 0, 23, 0, 121, 1, 0, 2, 293),
('Elegant Rooms', 'Fort Carson', 2, 20293, 'Ne', 'Ne', 25.7763, 1174.7, 19.3877, 273.063, 0, 0, 23, 0, 121, 1, 0, 2, 294),
('Elegant Rooms', 'Fort Carson', 3, 20294, 'Ne', 'Ne', 25.4958, 1167.97, 19.5178, 268.363, 0, 0, 23, 0, 121, 1, 0, 2, 295),
('Elegant Rooms', 'Fort Carson', 4, 20295, 'Ne', 'Ne', 25.7851, 1161.16, 19.6383, 271.496, 0, 0, 23, 0, 121, 1, 0, 2, 296),
('Elegant Rooms', 'Fort Carson', 5, 20296, 'Ne', 'Ne', -0.423451, 1165.23, 19.5481, 90.7243, 0, 0, 23, 0, 121, 1, 0, 2, 297),
('Elegant Rooms', 'Fort Carson', 6, 20297, 'Ne', 'Ne', -0.419543, 1172.18, 19.495, 91.351, 0, 0, 23, 0, 121, 1, 0, 2, 298),
('Elegant Rooms', 'Fort Carson', 7, 20298, 'Ne', 'Ne', -0.180765, 1178.93, 19.449, 91.351, 0, 0, 23, 0, 121, 1, 0, 2, 299),
('Elegant Rooms', 'Fort Carson', 8, 20299, 'Ne', 'Ne', -0.389446, 1185.8, 19.4019, 91.0377, 0, 0, 23, 0, 121, 1, 0, 2, 300),
('Gateway Motel', 'Bone County', 1, 20300, 'Ne', 'Ne', 13.1286, 1229.23, 19.342, 271.206, 0, 0, 23, 1, 55, 1, 1554149646, 2, 301),
('Gateway Motel', 'Fort Carson', 2, 20301, 'Ne', 'Ne', 12.7562, 1219.89, 19.3406, 269.952, 0, 0, 23, 0, 55, 1, 0, 2, 302),
('Gateway Motel', 'Fort Carson', 3, 20302, 'Ne', 'Ne', 12.6412, 1210.7, 19.3408, 273.399, 0, 0, 23, 1, 55, 1, 1556027413, 2, 303),
('Gateway Motel', 'Bone County', 4, 20303, 'Ne', 'Ne', 13.7845, 1229.31, 22.5032, 270.266, 0, 0, 23, 1, 55, 1, 1556027096, 2, 304),
('Gateway Motel', 'Fort Carson', 5, 20304, 'Ne', 'Ne', 13.8865, 1219.98, 22.5032, 270.892, 0, 0, 23, 1, 55, 1, 1556027089, 2, 305),
('Gateway Motel', 'Fort Carson', 6, 20305, 'Ne', 'Ne', 13.8883, 1210.7, 22.5032, 269.326, 0, 0, 23, 1, 55, 1, 1556027077, 2, 306),
('Gateway Motel', 'Fort Carson', 7, 20306, 'Ne', 'Ne', -36.045, 1215.11, 19.3519, 1.13298, 0, 0, 23, 0, 55, 1, 0, 2, 307),
('Gateway Motel', 'Fort Carson', 8, 20307, 'Ne', 'Ne', -26.7217, 1215.14, 19.3519, 0.819961, 0, 0, 23, 0, 55, 1, 0, 2, 308),
('Gateway Motel', 'Fort Carson', 9, 20308, 'Ne', 'Ne', -17.4257, 1214.84, 19.3527, 0.819961, 0, 0, 23, 0, 55, 1, 1555100366, 2, 309),
('Gateway Motel', 'Fort Carson', 10, 20309, 'Ne', 'Ne', -17.4324, 1214.95, 22.4648, 1.78345, 0, 0, 23, 1, 55, 1, 1555952950, 2, 310),
('Gateway Motel', 'Fort Carson', 11, 20310, 'Ne', 'Ne', -26.7643, 1215.41, 22.4648, 0.53008, 0, 0, 23, 1, 55, 1, 1555952974, 2, 311),
('Gateway Motel', 'Fort Carson', 12, 20311, 'Ne', 'Ne', -36.1056, 1215.41, 22.4648, 1.47007, 0, 0, 23, 1, 55, 1, 1555952983, 2, 312),
('Hayes\' Home Service Garage', 'Palomino Creek', -2, 20312, 'Ne', 'Ne', 2184.26, -42.6843, 27.4766, 179.417, 0, 0, 55, 0, 0, 0, 1549043927, 2, 316),
('Flint County Bay', 'Red County', 1, 20313, 'Ne', 'Ne', -396.241, -425.468, 16.2031, 353.72, 0, 0, 33, 0, 68958, 0, 0, 2, 318),
('Flint County Bay', 'Red County', 2, 20314, 'Ne', 'Ne', -426.216, -400.898, 16.3802, 270.686, 0, 0, 32, 1, 68958, 0, 1551289349, 2, 319),
('Fort Carson Trailerpark', 'Fort Carson', 1, 20315, 'Ne', 'Ne', -126.808, 974.473, 19.8516, 90.6606, 0, 0, 32, 0, 13298, 0, 0, 2, 321),
('Fort Carson Trailerpark', 'Fort Carson', 2, 20316, 'Ne', 'Ne', -151.22, 933.752, 19.7231, 357.913, 0, 0, 32, 0, 13298, 0, 0, 2, 322),
('Fort Carson Trailerpark', 'Fort Carson', 3, 20317, 'Ne', 'Ne', -153.324, 906.488, 19.3012, 84.7563, 0, 0, 32, 0, 13298, 0, 0, 2, 323),
('Fort Carson Trailerpark', 'Fort Carson', 4, 20318, 'Ne', 'Ne', -151.651, 881.693, 18.4544, 89.6972, 0, 0, 32, 0, 13298, 0, 0, 2, 324),
('Fort Carson Trailerpark', 'Fort Carson', 5, 20319, 'Ne', 'Ne', -121.017, 858.133, 18.5824, 179.312, 0, 0, 32, 0, 13298, 0, 0, 2, 325),
('Fort Carson Trailerpark', 'Fort Carson', 6, 20320, 'Ne', 'Ne', -123.25, 875.344, 18.7309, 179.89, 0, 0, 32, 0, 13298, 0, 0, 2, 326),
('Fort Carson Trailerpark', 'Fort Carson', 7, 20321, 'Ne', 'Ne', -124.061, 917.427, 19.9125, 293.076, 0, 0, 32, 0, 13298, 0, 0, 2, 327),
('Fort Carson Trailerpark', 'Fort Carson', 8, 20322, 'Ne', 'Ne', -92.5944, 970.43, 19.97, 178.418, 0, 0, 32, 0, 13298, 0, 0, 2, 328),
('Fort Carson Trailerpark', 'Fort Carson', 9, 20323, 'Ne', 'Ne', -83.1377, 932.539, 20.704, 354.177, 0, 0, 32, 0, 13298, 0, 0, 2, 329),
('Fort Carson Trailerpark', 'Fort Carson', 10, 20324, 'Ne', 'Ne', -86.9968, 915.742, 21.0886, 267.383, 0, 0, 32, 0, 13298, 0, 0, 2, 330),
('Fort Carson Trailerpark', 'Fort Carson', 11, 20325, 'Ne', 'Ne', -92.5249, 887.556, 21.2543, 236.989, 0, 0, 32, 0, 13298, 0, 0, 2, 331),
('Fort Carson Trailerpark', 'Fort Carson', 12, 20326, 'Ne', 'Ne', -52.9194, 894.86, 22.3871, 180.589, 0, 0, 32, 0, 13298, 0, 0, 2, 332),
('Fort Carson Trailerpark', 'Fort Carson', 13, 20327, 'Ne', 'Ne', -54.5294, 919.302, 22.3715, 269.576, 0, 0, 32, 0, 13298, 0, 0, 2, 333),
('Fort Carson Trailerpark', 'Fort Carson', 14, 20328, 'Ne', 'Ne', -56.71, 935.865, 21.2074, 269.889, 0, 0, 32, 0, 13298, 0, 0, 2, 334),
('Fort Carson Trailerpark', 'Fort Carson', 15, 20329, 'Ne', 'Ne', -67.2568, 971.551, 19.8893, 266.779, 0, 0, 32, 0, 13298, 0, 0, 2, 335),
('Fort Carson Trailerpark', 'Fort Carson', 16, 20330, 'Ne', 'Ne', -37.1497, 962.621, 20.0512, 177.792, 0, 0, 32, 1, 13298, 0, 0, 2, 336),
('Fort Carson Trailerpark', 'Fort Carson', 17, 20331, 'Ne', 'Ne', -12.1591, 974.873, 19.8, 90.9977, 0, 0, 32, 0, 13298, 0, 0, 2, 337),
('Fort Carson Trailerpark', 'Fort Carson', 18, 20332, 'Ne', 'Ne', -4.0825, 951.909, 19.7031, 176.225, 0, 0, 32, 0, 13298, 0, 0, 2, 338),
('Fort Carson Trailerpark', 'Fort Carson', 19, 20333, 'Ne', 'Ne', -15.6348, 933.763, 21.1059, 88.1776, 0, 0, 32, 0, 13298, 0, 0, 2, 339),
('Fort Carson Trailerpark', 'Fort Carson', 20, 20334, 'Ne', 'Ne', 17.7837, 909.385, 23.9339, 186.252, 0, 0, 32, 0, 13298, 0, 0, 2, 340),
('Fort Carson Trailerpark', 'Fort Carson', 21, 20335, 'Ne', 'Ne', 31.3902, 923.935, 23.6008, 101.361, 0, 0, 32, 0, 13298, 0, 0, 2, 341),
('Fort Carson Trailerpark', 'Fort Carson', 22, 20336, 'Ne', 'Ne', 20.372, 949.405, 20.3168, 268.996, 0, 0, 32, 0, 13298, 0, 0, 2, 342),
('Fort Carson Trailerpark', 'Fort Carson', 23, 20337, 'Ne', 'Ne', 22.8489, 968.7, 19.8183, 175.622, 0, 0, 32, 0, 13298, 0, 0, 2, 343),
('Fort Carson Trailerpark', 'Fort Carson', 24, 20338, 'Ne', 'Ne', 70.3057, 973.349, 15.8335, 358.611, 0, 0, 32, 0, 13298, 0, 0, 2, 344),
('Beacon Hill Farm House', 'Beacon Hill', 1, 20339, 'Ne', 'Ne', -349.619, -1034.4, 59.9514, 269.35, 0, 0, 33, 0, 100418, 0, 0, 2, 348),
('Bone County', 'Bone County', 14, 20340, 'Ne', 'Ne', 300.557, 1141.12, 9.13749, 89.6008, 0, 0, 12, 0, 14520, 0, 0, 2, 349),
('Bone County', 'Bone County', 13, 20341, 'Ne', 'Ne', 397.591, 1157.74, 8.34806, 96.4705, 0, 0, 37, 1, 10890, 0, 0, 2, 352),
('Chemical Street', 'Red County', 14, 20342, 'Ne', 'Ne', -914.345, -528.785, 26.078, 262.722, 0, 0, 37, 0, 10000, 0, 0, 2, 355),
('Chemical Street', 'Red County', 88, 20343, 'Ne', 'Ne', -914.345, -533.47, 26.078, 270.242, 0, 0, 49, 1, 10000, 0, 0, 2, 356),
('Chemical Street', 'Red County', 5, 20344, 'Ne', 'Ne', -924.49, -536.156, 25.9536, 206.321, 0, 0, 37, 0, 10000, 0, 0, 2, 357),
('Chemical Street', 'Red County', 6, 20345, 'Ne', 'Ne', -940.093, -536.627, 26.7656, 150.547, 0, 0, 37, 0, 10000, 0, 0, 2, 358),
('Chemical Street', 'Red County', 7, 20346, 'Ne', 'Ne', -950.973, -530.765, 25.9536, 180.291, 0, 0, 37, 0, 10000, 0, 0, 2, 359),
('Chemical Street', 'Red County', 8, 20347, 'Ne', 'Ne', -938.892, -518.135, 25.9536, 312.496, 0, 0, 37, 0, 10000, 0, 0, 2, 360),
('Chemical Street', 'Red County', 9, 20348, 'Ne', 'Ne', -929.232, -519.033, 25.9536, 263.615, 0, 0, 37, 0, 10000, 0, 0, 2, 361),
('Chemical Street', 'Red County', 10, 20349, 'Ne', 'Ne', -960.535, -507.692, 26.2387, 87.8332, 0, 0, 37, 0, 10000, 0, 0, 2, 363),
('Chemical Street', 'Red County', 11, 20350, 'Ne', 'Ne', -940.292, -490.892, 26.3637, 128.857, 0, 0, 37, 0, 10000, 0, 0, 2, 364),
('Chemical Street', 'Red County', 12, 20351, 'Ne', 'Ne', -923.916, -497.248, 26.7656, 73.7823, 0, 0, 37, 0, 10000, 0, 0, 2, 366),
('Devil\'s Hill', 'Red County', 1, 20352, 'Ne', 'Ne', -876.734, -707.191, 106.362, 88.674, 0, 0, 37, 0, 119990, 0, 0, 0, 368);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_house_interiors`
--

CREATE TABLE `gm_house_interiors` (
  `id` int(11) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `A` float NOT NULL,
  `Interior` int(11) NOT NULL,
  `Name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `gm_house_interiors`
--

INSERT INTO `gm_house_interiors` (`id`, `X`, `Y`, `Z`, `A`, `Interior`, `Name`) VALUES
(1, 243.995, 305.011, 999.148, 90.9776, 1, 'Denises Bedroom '),
(2, 2468.84, -1698.26, 1013.51, 269.869, 2, 'Ryders House '),
(3, 2496.02, -1692.69, 1014.74, 1.0496, 3, 'Johnsons House '),
(4, 266.704, 304.992, 999.148, 91.2908, 2, 'Katies Lovenest '),
(5, 1261.17, -785.463, 1091.91, 89.0741, 5, 'Madd Doggs Mansion '),
(6, 422.038, 2536.5, 10, 268.906, 10, 'Abandoned AC Tower '),
(7, 2233.66, -1115.03, 1050.88, 180.882, 5, 'Small Motel Room (SAFEHOUSE G1) '),
(8, 2317.81, -1026.77, 1050.22, 183.365, 9, '2floor Old Luxury House (SH G3) '),
(9, 2259.91, -1135.87, 1050.63, 89.0742, 10, 'Jefferson Motel Room (SF G4) '),
(10, 235.295, 1186.9, 1080.26, 179.315, 3, '2floor house (BH 1) '),
(11, 225.939, 1239.94, 1082.14, 269.219, 2, 'Small House w/o bathroom (BH 2) '),
(12, 223.159, 1287.19, 1082.14, 181.509, 1, 'Small House (BH 3) '),
(13, 226.708, 1114.22, 1080.99, 89.7244, 5, 'Crack Den (BH G4) '),
(14, 295.052, 1472.66, 1080.26, 179.002, 10, 'Mid-Luxury House, 2bedrooms (4 Burglary Houses) '),
(15, 327.949, 1478.32, 1084.44, 179.582, 15, '-Average House (4 Burglary Houses) '),
(16, 309.441, 311.197, 1003.3, 359.053, 0, 'Michelles Lovenest '),
(17, 23.9863, 1340.19, 1084.38, 180.765, 0, '2floor Lux House (BH 14) '),
(18, 344.266, 304.949, 999.148, 87.9938, 0, 'Millies Bedroom '),
(19, 22.8366, 1403.73, 1084.43, 180.741, 0, 'Small Flat Interior (Burglary House X16) '),
(20, 140.213, 1366.54, 1083.86, 179.778, 0, 'Mansion Interior (Burglary House 17) '),
(21, 234.259, 1064.47, 1084.21, 178.188, 0, 'Mansion Interior 2 (Burglary House 18) '),
(22, 2807.68, -1174.46, 1025.57, 177.855, 0, 'Colonel Furhbergers '),
(23, 2217.76, -1076.26, 1050.48, 268.699, 1, 'Modern Motel Room '),
(24, 2237.53, -1081.41, 1049.02, 181.905, 0, 'Luxury Hotel Room (Old Venturas Strip Casino) '),
(25, 2365.25, -1135.15, 1050.88, 177.808, 0, 'Flat Interior (Verdant Bluffs Safehouse) '),
(26, 616.371, 849.872, 3045.07, 0, 0, 'Karavan od CapoNa '),
(27, -276.126, 1579.17, 3073.91, 180, 0, 'Malý dom (gang house) od Armona '),
(28, 2297.65, -1735.86, 559.284, 90, 0, 'Velký, dvojposchodový gang house od TheKloNCZE689 '),
(29, 1328.71, -1216.48, 2611.18, 270, 0, 'Cocaine Underhouse '),
(30, 1181.36, -1317.2, 2606.15, 90, 0, 'Luxury Wooden House '),
(31, 2543.13, -2127.22, 1013.57, 90, 0, 'Kepler Modern House Interior '),
(32, 2489.81, -1830.47, 1013.57, 180, 0, 'Kepler House 1 '),
(33, 2509.12, -1785.64, 1013.57, 270, 0, 'Kepler House 2 '),
(34, 1885.42, 1059.31, 1303.44, 270, 0, 'Luxury House 1 '),
(35, 2055.97, 1294.15, 1658.85, 360, 0, 'Luxury House 2 '),
(36, 724.177, -726.88, 1088.73, 180, 0, 'Flat (gang) '),
(37, 2505.88, -1874.68, 1013.57, 90, 0, 'Karavan 1 '),
(38, 2540.7, -1838.36, 1013.57, 180, 0, 'Karavan 2'),
(39, -308.714, -875.163, 996.703, 1.23527, 0, 'Velky dom (bez nabytku)'),
(40, -184.768, -988.893, 999.398, 89.3061, 0, 'Maly dom w/o kupelna (bez nabytku)'),
(41, -185.578, -829.93, 999.32, 3.78874, 0, 'Maly dom /w kupelna (bez nabytku)'),
(42, -405.513, -1195.35, 996.627, 0.317751, 0, 'Velka vila (bez nabytku)'),
(43, -274.352, -706.485, 1000.64, 358.125, 0, 'Bezny rodinny dom (bez nabytku)'),
(44, -136.035, -712.758, 999.132, 357.209, 0, 'Bezny rodinny dom 2 (bez nabytku)'),
(45, -229.737, -584.81, 997.752, 0.052339, 0, 'Colonel Fuhrbergs (bez nabytku)'),
(46, -63.613, -766.59, 994.7, 92.027, 0, 'Bezny interier domu (bez nabytku)'),
(47, 22.2496, -697.294, 996.055, 179.907, 0, 'Johnsons House (bez nabytku)'),
(48, -152.85, -614.901, 995.387, 182.868, 0, 'Verona Beach (bez nabytku)'),
(49, -908.399, -514.329, 1526.05, 90, 0, 'Karavan interier (bez nabytku)'),
(50, 2495.66, 124.085, 1536.15, 90, 0, 'Gang byt interier (bez nabytku)'),
(51, 2363.8, 133.531, 1534.75, 180, 0, 'Large Wooden House (bez nabytku)'),
(52, 2501.43, 98.775, 1589.05, 0, 0, 'Motorkásrky byt (bez nabytku)'),
(53, 2041.49, 1297.45, 1077.52, 180, 0, 'House Interior 6 (bez nabytku)'),
(54, 2034.63, 1342.56, 1011.91, 90, 0, 'House Interior 5 (bez nabytku)'),
(55, 2231.19, 64.849, 1540.82, 90, 0, 'Berkleys Garage Interior'),
(56, 2231.57, -43.085, 1708.7, 0, 0, 'Palomino Creek House Unfurnished'),
(57, 2159.31, -1765.16, 949.726, 2.228, 0, 'Kepler dom bez nabytku'),
(58, 2156.84, -1757.73, 899.712, 270.801, 60, 'Kepler dom s garazou'),
(59, 1445.92, 784.64, 545.03, 92.29, 0, 'Klon vila');

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_ifactions`
--

CREATE TABLE `gm_ifactions` (
  `ID` int(11) NOT NULL,
  `Name` varchar(64) NOT NULL,
  `Perm_Guns` tinyint(4) NOT NULL,
  `Perm_Drug_Marijuana` tinyint(4) NOT NULL,
  `Perm_Drugs` tinyint(4) NOT NULL,
  `Perm_Graffitis` tinyint(4) NOT NULL,
  `Chat` tinyint(4) NOT NULL,
  `Cash` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `gm_ifactions`
--

INSERT INTO `gm_ifactions` (`ID`, `Name`, `Perm_Guns`, `Perm_Drug_Marijuana`, `Perm_Drugs`, `Perm_Graffitis`, `Chat`, `Cash`) VALUES
(1, 'Varrio Mexican Pride XIII	', 0, 1, 0, 1, 0, 600000),
(2, 'Kneževièevova Spojka	', 1, 0, 0, 0, 0, 89000);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_interiors`
--

CREATE TABLE `gm_interiors` (
  `id` int(11) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `A` float NOT NULL,
  `Interior` int(11) NOT NULL,
  `Name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `gm_interiors`
--

INSERT INTO `gm_interiors` (`id`, `X`, `Y`, `Z`, `A`, `Interior`, `Name`) VALUES
(1, 772.286, -4.90504, 1000.73, 178.964, 5, 'Ganton Gym'),
(2, 834.262, 7.43471, 1004.19, 269.808, 3, 'Inside Tracks Betting'),
(3, 1212.09, -26.1336, 1000.95, 358.146, 0, 'The Big Spread Ranch (Strip Club)'),
(4, 418.649, -84.2942, 1001.8, 178.604, 3, 'Barber Shop'),
(5, 390.16, 173.761, 1008.38, 270.702, 3, 'Planning Department'),
(6, 207.043, -139.917, 1003.51, 179.834, 3, 'Pro Laps (Clothing)'),
(7, -100.366, -24.5884, 1000.72, 179.208, 3, 'Sex Shop'),
(8, -204.363, -44.1384, 1002.27, 179.521, 3, 'Las Venturas Tattoo Parlour'),
(9, -25.8736, -187.754, 1003.55, 180.461, 17, '24/7 - L version (big)'),
(10, 372.332, -133.111, 1001.49, 180.147, 5, 'Pizza Stack'),
(11, 377.124, -192.903, 1000.64, 182.654, 17, 'Rusty Brown Donuts'),
(12, 315.789, -143.275, 999.602, 179.544, 7, 'Ammu Nation (2 floor, strelnica)'),
(13, 226.86, -8.14033, 1002.21, 269.158, 5, 'Victim (Clothing)'),
(14, 246.326, 107.972, 1003.22, 182.363, 10, 'San Fierro Police Department'),
(15, 6.05655, -31.3809, 1003.55, 180.796, 10, '24/7 (kocka) (big)'),
(16, 285.429, -41.2085, 1001.52, 179.521, 1, 'Ammu Nation (strelnica)'),
(17, 203.776, -50.1368, 1001.8, 180.147, 1, 'Sub Urban (Clothing)'),
(18, 1204.78, -13.2608, 1000.92, 179.713, 2, 'The Pig Pen (Strip Club)'),
(19, 2018.86, 1017.77, 996.875, 270.557, 0, 'Four Dragons (Casino)'),
(20, 363.233, -74.8835, 1001.51, 132.689, 10, 'Burger Shot'),
(21, 2233.96, 1714.16, 1012.36, 357.954, 0, 'Caligulas Casino'),
(22, 411.695, -22.7978, 1001.8, 177.809, 2, 'Barber Shop (Reeces)'),
(23, -30.9867, -91.7111, 1003.55, 178.726, 18, '24/7 (kocka) (big)'),
(24, 161.378, -96.4581, 1001.8, 179.98, 18, 'ZIP (Clothing)'),
(25, -2636.75, 1402.99, 906.461, 180.605, 0, 'The Pleasure Domes (Jizzys)'),
(26, -2158.67, 642.798, 1052.38, 358.894, 0, 'Wu Zi Mus (Betting)'),
(27, 204.358, -168.536, 1000.52, 178.099, 14, 'Didier Sachs (Clothing)'),
(28, 1133.1, -14.853, 1000.68, 179.667, 0, 'Redsans West (Casino)'),
(29, 493.398, -24.5414, 1000.68, 178.726, 17, 'Club (Alhambra Club)'),
(30, -959.571, 1953.58, 9, 0.75017, 0, 'Sherman Dam'),
(31, -25.8684, -141.242, 1003.55, 181.522, 16, '24/7 (kocka) (big)'),
(32, 2215.24, -1150.5, 1025.8, 90.0282, 15, 'Jefferson Motel'),
(33, 681.481, -446.389, -25.6098, 359.474, 0, 'The Welcome Pump'),
(34, 207.62, -110.488, 1005.13, 178.993, 15, 'Binco (Clothing)'),
(35, 2305.56, -16.0514, 26.7496, 93.1615, 0, 'Palomino Bank'),
(36, -229.074, 1401.21, 27.7656, 89.0881, 0, 'Lil Probe Inn'),
(37, 285.886, -86.3213, 1001.52, 177.402, 0, 'Ammu Nation L (kocka)'),
(38, 459.654, -88.6332, 999.555, 270.753, 4, 'Jays Diner'),
(39, -27.3724, -30.9359, 1003.56, 179.864, 4, '24/7 (obdlznik, mensi)'),
(40, 412.017, -54.2693, 1001.9, 179.189, 0, 'Barber Shop (modern, big)'),
(41, 774.088, -50.132, 1000.59, 180.755, 0, 'Cobra Gym'),
(42, 246.833, 63.1314, 1003.64, 178.562, 0, 'Los Santos Police Department'),
(43, 1494.47, 1303.58, 1093.29, 180.419, 3, 'Bike School'),
(44, -2240.78, 137.187, 1035.41, 89.8411, 6, 'Zeros RC Shop'),
(45, 296.798, -111.741, 1001.52, 180.685, 6, 'Ammu Nation (small)'),
(46, 316.334, -169.685, 999.601, 179.409, 6, 'Ammu Nation (very small)'),
(47, -27.2958, -57.7677, 1003.55, 179.699, 6, '24/7 (small)'),
(48, 364.861, -11.0238, 1001.85, 180.952, 9, 'Cluckin Bell'),
(49, -2029.74, -119.097, 1035.17, 180.615, 3, 'Driving School'),
(50, 501.992, -67.9631, 998.758, 359.822, 11, 'Bar'),
(51, 322.211, 302.662, 999.148, 180.568, 5, 'Barbaras Small PDHQ'),
(52, 2533.21, -2367.94, 4016.9, 180, 0, 'Putyka Russkogo Brodyagu'),
(53, 1895.61, 166.036, 2299.14, 90, 0, 'Weapon And Drug Factory'),
(54, 1177.63, -1075.11, 2611.24, 270, 0, 'Army Shop'),
(55, 1533.77, -1061.92, 3025.14, 180, 0, 'Starbucks'),
(56, -577.978, -1071.79, 1024.02, 180, 0, 'Ducks Textil Shop'),
(57, -111.997, 1104.14, 3019.82, 90, 0, 'Grocery Shop'),
(58, 2495.1, 1796, 3001.08, 180, 0, 'Trafika'),
(59, -227.266, 1123.11, 1501.17, 0, 0, 'Tourist Center'),
(60, 3846.61, 3424.52, 201.085, 90, 0, 'Cukraren'),
(61, -3955.05, 1228.82, 251.094, 0, 0, 'Masiaren'),
(62, 3952.9, 2882.11, 251.085, 180, 0, 'Bar'),
(63, -173.863, 1028.99, 2001.08, 90, 0, 'Grow Shop'),
(64, 1367.65, 187.157, 1507.38, 0, 0, 'Murrays'),
(65, -2189.38, 658.037, 2001.08, 47.5, 0, 'Outlaws'),
(66, -2206.91, 651.836, 2005.85, 270, 0, 'Outlaws Second Floor'),
(67, -1893.59, 748.851, 1501.35, 90, 0, 'Luxury Restaurant (Mafian)'),
(68, 1382.19, 697.603, 3026.72, 90, 0, 'Palomino Creek Bank'),
(69, 1482.19, -1780.24, 2981.35, 360, 0, 'Palomino Creek Town Hall'),
(70, -2334.94, -98.381, 1496.86, 180, 0, 'Stará bytovka'),
(71, -2335, -98.381, 1496.86, 180, 0, 'Stará ubytovòa'),
(72, 207.864, 1662.14, 3001.17, 90, 0, 'Bytovka stredná vrstva'),
(73, 343.987, 1733.4, 3001.08, 90, 0, 'Bytovka Outlaws'),
(74, -21.376, 1489.25, 2001.08, 90, 0, 'Bytovka Civil Poor'),
(75, 726.598, -729.154, 1085.02, 270, 0, 'ACComplex'),
(76, 126.471, 1903.46, 646.208, 90, 0, 'RCSD HQ'),
(77, 2254.1, -138.731, 1186.18, 90, 0, 'Hardware Store'),
(78, 2332.07, 201.245, 1028.86, 270, 0, 'Stávková kancelária'),
(79, 2105.54, 297.083, 1004.7, 270, 0, 'Small Flat 1_Ghetto'),
(80, 2020.6, -1195.04, 1024.13, 270, 0, 'Red County News HQ'),
(81, 1946.43, 1281.06, 1289.41, 180, 0, 'Watson Automotive'),
(82, 1473.27, 1338.89, 280.906, 270, 0, 'FDHQ Interior'),
(83, 669.668, -646.682, 1516.34, 90, 0, 'CapoN\'s illegal restaurant'),
(84, -1669.85, 426.179, 998.754, 0, 0, 'CapoN\'s Gas Station'),
(85, 1148.18, 1287.89, 3732.63, 0, 0, 'Crippen Memorial'),
(86, 2270.28, -72.655, 78.032, 360, 0, 'New City Hall Interior'),
(87, 2512.98, 103.274, 1559.27, 92.612, 0, 'Bytovka priemerná pre civil'),
(88, 368.719, 1855.43, 1122.16, 180, 0, 'Montgomery Police Dept.'),
(89, 3706.8, 1277.05, 1068.14, 180, 0, 'LAPD v2, prízemie'),
(90, 2698.9, -941.575, 1097.51, 0, 0, 'North Rock Shooting Range'),
(91, 2231.19, 64.849, 1540.82, 90, 0, 'Berkleys Garage Interior'),
(92, 724.074, 834.768, 1015.55, 270, 0, 'Electro Shop'),
(93, 1379.04, -971.011, 2033.21, 180, 0, 'Crvena Zvezda Pub'),
(94, 2630.7, 3121.42, 2048.13, 90, 0, 'BCSO HQ Small'),
(95, 201.415, -39.506, 1205.7, 90, 0, 'Pentagon Club'),
(96, -955.612, -2267.39, 991.286, 0, 0, 'Capon Mine Office'),
(97, 1364.47, 197.424, 1499.69, 270, 0, 'Crippen Memorial Interior'),
(98, 1338.24, 1570.58, 767.45, 270, 0, 'Court Room'),
(99, 784.641, -503.279, -67.315, 0, 0, 'Hells Hole Pub'),
(100, 1358.92, 1545.05, 3627, 270, 0, 'Strelnica interier');

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_ipbans`
--

CREATE TABLE `gm_ipbans` (
  `id` int(11) NOT NULL,
  `Username` text NOT NULL,
  `Master_Acc` text NOT NULL,
  `IP` text,
  `AdminMACC` text NOT NULL,
  `Reason` text NOT NULL,
  `Date` text NOT NULL,
  `UnbanUnix` int(11) NOT NULL,
  `gpci` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_logs`
--

CREATE TABLE `gm_logs` (
  `id` int(11) NOT NULL,
  `Date` datetime NOT NULL,
  `Type` int(11) NOT NULL,
  `Text` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_map_icons`
--

CREATE TABLE `gm_map_icons` (
  `Icon` tinyint(4) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `Style` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `gm_map_icons`
--

INSERT INTO `gm_map_icons` (`Icon`, `X`, `Y`, `Z`, `Style`) VALUES
(34, 2269.61, -74.9616, 26.7724, 0),
(52, 2303.09, -16.112, 26.4909, 0),
(55, 2250.89, 33.0116, 26.4909, 0),
(48, 2305.77, 82.4749, 26.4787, 0),
(45, 2303.66, 30.7514, 26.4909, 0),
(6, 2334.93, 61.9856, 26.4834, 0),
(29, 2334.46, 74.998, 26.4841, 0),
(55, 2449.54, 111.181, 26.4788, 0),
(30, 630.721, -571.67, 16.3359, 0),
(55, 660.32, -571.544, 16.3359, 0),
(10, 664.486, -547.977, 16.3359, 0),
(45, 671.639, -519.96, 16.3359, 0),
(55, 611.787, -518.429, 16.3533, 0),
(55, 613.21, -494.651, 16.3359, 0),
(54, 1360.35, 206.762, 19.5547, 0),
(29, 1364.18, 249.701, 19.5669, 0),
(45, 1356.06, 305.679, 19.5547, 0),
(55, 1403.59, 239.65, 19.5547, 0),
(55, 1382.15, 464.534, 20.2, 0),
(56, -1095.45, -1627.26, 76.3672, 0),
(55, -1935.59, -1788.27, 31.5401, 0),
(45, 273.767, -158.175, 1.57812, 0),
(49, 255.992, -63.6601, 1.57812, 0),
(22, 1243.4, 330.735, 19.5547, 0),
(20, 1204.21, 515.609, 19.7452, 0),
(31, 1274.4, 237.923, 19.5547, 0),
(51, -49.5001, -271.631, 6.63319, 0),
(22, -315.854, 1055.38, 19.7428, 0),
(11, 1902.52, 177.618, 37.1417, 0),
(11, 1548.65, 37.0216, 24.1406, 0),
(11, 1035.67, -361.78, 73.8966, 0),
(11, -380.872, -1059.05, 59.009, 0),
(45, -582.407, -1047.08, 23.748, 0),
(9, 2156.1, -99.5207, 3.27334, 0),
(5, 414.185, 2533.96, 19.1484, 0),
(48, -599.935, -1076.88, 23.6008, 0),
(48, 1401.45, 284.777, 19.5547, 0),
(48, 141.394, -181.537, 1.57812, 0),
(48, -204.084, 1172.12, 19.7422, 0),
(55, 2334.51, -67.2755, 26.4844, 0),
(55, -78.6326, -1169.79, 2.14235, 0);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_menu`
--

CREATE TABLE `gm_menu` (
  `id` int(11) NOT NULL,
  `menu_type` int(11) NOT NULL,
  `text_label` text CHARACTER SET latin1 NOT NULL,
  `text_info` text CHARACTER SET latin1 NOT NULL,
  `pickup_model` int(11) NOT NULL,
  `posX` float NOT NULL,
  `posY` float NOT NULL,
  `posZ` float NOT NULL,
  `virtualWorld` int(11) NOT NULL,
  `interiorID` int(11) NOT NULL,
  `draw_distance` float NOT NULL,
  `storage_GROCERIES` float NOT NULL,
  `storage_CLOTHES` float NOT NULL,
  `storage_ELECTRONICS` float NOT NULL,
  `storage_CAR_PARTS` float NOT NULL,
  `storage_WEAPONS` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_slovak_ci;

--
-- Sťahujem dáta pre tabuľku `gm_menu`
--

INSERT INTO `gm_menu` (`id`, `menu_type`, `text_label`, `text_info`, `pickup_model`, `posX`, `posY`, `posZ`, `virtualWorld`, `interiorID`, `draw_distance`, `storage_GROCERIES`, `storage_CLOTHES`, `storage_ELECTRONICS`, `storage_CAR_PARTS`, `storage_WEAPONS`) VALUES
(4, 7, '/menu', '', 0, 2248.01, 33.5645, 26.4909, 0, 0, 3, 0, 0, 0, 0, 0),
(6, 7, '/menu', '', 0, 2271.66, -77.2106, 26.5815, 0, 0, 3, 0, 0, 0, 0, 0),
(13, 1, 'Welcome', '', 0, 2268.73, -69.169, 79.0674, 19340, 0, 5, 0, 0, 0, 0, 0),
(14, 27, '/menu', '', 0, 1373.3, 697.754, 3026.74, 17898, 0, 8, 0, 0, 0, 0, 0),
(15, 27, '/menu', '', 0, 1372.96, 694.574, 3026.73, 17898, 0, 8, 0, 0, 0, 0, 0),
(16, 27, '/menu', '', 0, 1372.85, 691.625, 3026.73, 17898, 0, 8, 0, 0, 0, 0, 0),
(18, 12, '/predatryby', '', 0, -3958.34, 1226.29, 251.095, 18980, 0, 15, 0, 0, 0, 0, 0),
(27, 3, '/door', '', 0, 2334.1, 6.25597, 26.4846, 0, 0, 3, 0, 0, 0, 0, 0),
(30, 7, '/menu', '', 0, 2326.88, 4.40745, 26.5388, 0, 0, 2, 0, 0, 0, 0, 0),
(31, 7, '/menu', '', 0, 2324.81, 7.84194, 26.5534, 0, 0, 2, 0, 0, 0, 0, 0),
(35, 15, '/buy', '', 0, 2250.39, -132.69, 1186.18, 18882, 0, 15, 0, 0, 0, 0, 0),
(38, 30, '/menu', '', 1239, 2441.19, 113.071, 26.598, 0, 0, 15, 0, 0, 0, 0, 0),
(39, 30, '/menu', '', 1239, 2415.93, 123.06, 26.7692, 0, 0, 15, 0, 0, 0, 0, 0),
(40, 30, '/menu', '', 1239, 2421.18, 122.866, 28.4799, 0, 0, 15, 0, 0, 0, 0, 0),
(41, 11, '/predatryby', '', 1239, 2149.44, -99.3637, 2.70109, 0, 0, 15, 0, 0, 0, 0, 0),
(44, 6, '/rybarit', '', 1239, 2105.85, -101.907, 2.05751, 0, 0, 20, 0, 0, 0, 0, 0),
(51, 7, '/menu', '', 0, 660.552, -568.29, 16.3359, 0, 0, 2, 0, 0, 0, 0, 0),
(54, 19, '/buy', '', 1239, 657.509, -553.754, 16.3359, 0, 0, 15, 0, 0, 0, 0, 0),
(62, 7, '/buy', '', 1239, 657.973, -499.654, 16.3359, 0, 0, 15, 0, 0, 0, 0, 0),
(64, 1, '**NÁPIS**\nVstup za rohem!', '', 0, 691.163, -506.317, 16.3359, 0, 0, 10, 0, 0, 0, 0, 0),
(74, 1, '**NÁPIS**\nPoužijte vchod vlevo, prosím!', '', 0, 1400.9, 230.334, 19.5469, 0, 0, 8, 0, 0, 0, 0, 0),
(79, 8, '**NÁPIS**\nPoužijte vchod vpravo, prosím!', '', 0, 1374.75, 469.196, 20.1843, 0, 0, 8, 0, 0, 0, 0, 0),
(80, 41, '/zosrotovat', '', 1239, -1881.83, -1695.24, 21.7459, 0, 0, 15, 0, 0, 0, 0, 0),
(84, 1, '**NÁPIS**\nPoužijte dolní vchod, prosím.', '', 0, 253.898, -163.971, 5.07861, 0, 0, 6, 0, 0, 0, 0, 0),
(88, 28, '/buycrate', '', 1239, 1921.42, 173.27, 2299.14, 16114, 0, 15, 0, 0, 0, 0, 0),
(89, 1, 'FUCK THE POPULATION', '', 0, -2996.16, 470.54, 4.91406, 0, 0, 15, 0, 0, 0, 0, 0),
(90, 24, '/buy', '', 0, 308.42, -160.059, 999.594, 15643, 6, 15, 0, 0, 0, 0, 0),
(91, 7, '/menu', '', 0, 1151.68, 1300.46, 3732.63, 16238, 0, 3, 0, 0, 0, 0, 0),
(92, 7, '/menu', '', 1239, 1148.22, 1309.13, 3732.63, 16238, 0, 3, 0, 0, 0, 0, 0),
(93, 7, '/menu', '', 1239, 52.8391, 1670.75, 1218, 12298, 0, 6, 0, 0, 0, 0, 0),
(94, 7, '/menu', '', 1239, 41.8291, 1672.45, 1222.09, 12298, 0, 6, 0, 0, 0, 0, 0),
(95, 38, '/buystyle', '', 1239, 36.4365, 1653.57, 1222.22, 12298, 0, 15, 0, 0, 0, 0, 0),
(96, 7, '/menu', '', 1239, 1229.31, 307.696, 19.7578, 0, 0, 6, 0, 0, 0, 0, 0),
(97, 10, '/satna', '', 1239, 1148.52, 1323.83, 3732.63, 16238, 0, 15, 0, 0, 0, 0, 0),
(105, 6, '/rybarit', '', 1239, 3065.39, -774.714, 1.74897, 0, 0, 20, 0, 0, 0, 0, 0),
(106, 6, '/rybarit', '', 1239, 3065.32, -663.531, 1.74897, 0, 0, 20, 0, 0, 0, 0, 0),
(107, 7, '/menu', '', 1239, 708.585, -735.88, 1085.02, 15744, 0, 15, 0, 0, 0, 0, 0),
(112, 69, 'Pohrebná služba\n/pracovat', '', 1239, 2250.74, -52.8871, 26.4936, 0, 0, 10, 0, 0, 0, 0, 0),
(113, 20, '/buy', '', 1239, 1382.87, -973.927, 2033.21, 15378, 0, 15, 0, 0, 0, 0, 0),
(114, 20, '/buy', '', 1239, 3951.95, 2887.13, 251.086, 15237, 0, 15, 0, 0, 0, 0, 0),
(129, 4, '/buy', '', 1239, 143.986, 1907.17, 646.212, 12347, 0, 15, 0, 0, 0, 0, 0),
(130, 8, '/satna', '', 1239, 140.464, 1920.76, 646.212, 12347, 0, 15, 0, 0, 0, 0, 0),
(132, 10, '/satna', '', 1239, 51.2781, 1675.78, 1218, 12298, 0, 10, 0, 0, 0, 0, 0),
(134, 40, '/enter', '', 1239, 136.221, 1932.8, 646.212, 12347, 0, 15, 0, 0, 0, 0, 0),
(135, 40, '/enter', '', 1239, 282.424, -1513.94, 24.9219, 10, 0, 15, 0, 0, 0, 0, 0),
(136, 40, '/enter', '', 1239, 611.027, -584.005, 17.9726, 0, 0, 5, 0, 0, 0, 0, 0),
(138, 8, '/satna', '', 1275, 2626.9, 3115.09, 2048.13, 10867, 0, 5, 0, 0, 0, 0, 0),
(139, 40, '/enter', '', 1239, 618.717, -566.711, 26.1432, 0, 0, 5, 0, 0, 0, 0, 0),
(140, 31, '/buy\n/buyticket\n/moneytree', '', 1239, -103.716, 1104.02, 3019.81, 18252, 0, 15, 0, 0, 0, 0, 0),
(142, 7, '/menu', '', 0, -225.232, 1122.2, 1501.17, 15486, 0, 2, 0, 0, 0, 0, 0),
(144, 2, '/menu', '', 1239, -229.888, 1120.71, 1501.17, 15486, 0, 15, 0, 0, 0, 0, 0),
(145, 7, '/menu', '', 0, -590.085, -1061.97, 23.753, 0, 0, 2, 0, 0, 0, 0, 0),
(146, 16, '/buyclothing', '', 1275, -577.012, -1069.16, 1024.02, 12019, 0, 5, 0, 0, 0, 0, 0),
(147, 7, '/menu', '', 0, -574.936, -1067.05, 1024.02, 12019, 0, 2, 0, 0, 0, 0, 0),
(150, 7, '/menu', '', 0, 725.635, 826.755, 1015.54, 15569, 0, 2, 0, 0, 0, 0, 0),
(152, 36, '/buy', '', 1239, 3951.78, 2886.78, 251.086, 12992, 0, 15, 0, 0, 0, 0, 0),
(153, 43, '/buyweapons', '', 1274, 312.038, -165.844, 999.601, 13068, 6, 15, 0, 0, 0, 0, 0),
(155, 15, '/buyhardware', '', 1274, 318.281, -162.402, 999.594, 13068, 6, 15, 0, 0, 0, 0, 0),
(156, 31, '/buy\n/buyticket\n/moneytree', '', 1274, -103.438, 1103.9, 3019.81, 15948, 0, 15, 0, 0, 0, 0, 0),
(157, 70, '/buyalcohol', '', 1274, -107.688, 1106.94, 3019.81, 15948, 0, 15, 0, 0, 0, 0, 0),
(158, 4, '/buy', '', 1274, 379.272, -190.367, 1000.63, 16768, 17, 15, 0, 0, 0, 0, 0),
(159, 7, '/menu', '', 0, 373.866, -178.93, 1000.63, 16768, 17, 15, 0, 0, 0, 0, 0),
(160, 7, '/menu', '', 0, 378.123, -178.826, 1000.63, 16768, 17, 2, 0, 0, 0, 0, 0),
(161, 7, '/menu', '', 0, 224.535, -190.201, 1.57812, 0, 0, 2, 0, 0, 0, 0, 0),
(163, 43, '/buyweapons', '', 1274, 314.131, -133.842, 999.602, 14302, 7, 15, 0, 0, 0, 0, 0),
(164, 15, '/buyhardware', '', 1274, 303.96, -133.954, 999.602, 14302, 7, 15, 0, 0, 0, 0, 0),
(165, 15, '/buyhardware', '', 1274, 309.996, -131.557, 1004.05, 14302, 7, 15, 0, 0, 0, 0, 0),
(166, 7, '/menu', '', 0, -225.149, 1122.19, 1501.17, 14357, 0, 2, 0, 0, 0, 0, 0),
(167, 9, '/menu', '', 0, 206.347, -119.623, 1.55262, 0, 0, 2, 0, 0, 0, 0, 0),
(170, 36, '/buy', '', 1274, -2220.08, 646.031, 2001.6, 18391, 0, 15, 0, 0, 0, 0, 0),
(171, 37, '/buy', '', 1274, 661.129, -645.457, 1516.34, 13461, 0, 15, 0, 0, 0, 0, 0),
(172, 28, '/buyammo', '', 1239, 1898.82, 179.452, 2299.14, 16114, 0, 15, 0, 0, 0, 0, 0),
(173, 70, '/buyalcohol', '', 1274, 251.746, -56.2795, 1.57031, 0, 0, 15, 0, 0, 0, 0, 0),
(174, 31, '/buy\n/buyticket\n/moneytree', '', 1274, -28.9822, -184.918, 1003.55, 14138, 17, 15, 0, 0, 0, 0, 0),
(175, 16, '/buyclothing', '', 1275, 207.121, -129.178, 1003.51, 16958, 3, 15, 0, 0, 0, 0, 0),
(176, 21, '/menu', '', 1239, -2033.14, -117.549, 1035.17, 16468, 3, 15, 0, 0, 0, 0, 0),
(178, 20, '/buy', '', 1274, 376.461, -67.4357, 1001.51, 13029, 10, 15, 0, 0, 0, 0, 0),
(179, 26, '/buy', '', 1274, 374.739, -119.259, 1001.5, 19053, 5, 15, 0, 0, 0, 0, 0),
(180, 38, '/buystyle', '', 1239, 767.424, 13.0989, 1000.7, 17934, 5, 15, 0, 0, 0, 0, 0),
(181, 16, '/buyclothing', '', 1275, 203.873, -43.3722, 1001.8, 10747, 1, 15, 0, 0, 0, 0, 0),
(184, 31, '/buy\n/buyticket\n/moneytree', '', 1274, -103.394, 1104.21, 3019.81, 18843, 0, 15, 0, 0, 0, 0, 0),
(185, 70, '/buyalcohol', '', 1274, -107.677, 1106.97, 3019.81, 18843, 0, 15, 0, 0, 0, 0, 0),
(186, 4, '/buy', '', 1274, 1531.78, -1059.33, 3025.14, 10823, 0, 15, 0, 0, 0, 0, 0),
(187, 15, '/buyhardware', '', 1274, 2250.44, -132.377, 1186.18, 14533, 0, 15, 0, 0, 0, 0, 0),
(188, 7, '/menu', '', 0, 2249.92, -129.35, 1186.18, 14533, 0, 2, 0, 0, 0, 0, 0),
(189, 36, '/buy', '', 1274, 1382.92, -973.421, 2033.21, 14322, 0, 15, 0, 0, 0, 0, 0),
(190, 7, '/menu', '', 0, 2332.65, 196.7, 1028.87, 10106, 0, 2, 0, 0, 0, 0, 0),
(191, 7, '/menu', '', 0, 1292.79, 278.207, 19.5547, 0, 0, 2, 0, 0, 0, 0, 0),
(192, 16, '/buyclothing', '', 1275, 161.294, -83.732, 1001.8, 13529, 18, 15, 0, 0, 0, 0, 0),
(193, 7, '/menu', '', 0, 1278.58, 372.182, 19.5547, 0, 0, 2, 0, 0, 0, 0, 0),
(194, 31, '/buy\n/buyticket\n/moneytree', '', 1274, -1684.69, 427.603, 998.755, 19690, 0, 15, 0, 0, 0, 0, 0),
(195, 31, '/buy\n/buyticket\n/moneytree', '', 1274, -1684.44, 427.302, 998.755, 15818, 0, 15, 0, 0, 0, 0, 0),
(196, 70, '/buyalcohol', '', 1274, -1678.45, 431.59, 998.755, 19690, 0, 15, 0, 0, 0, 0, 0),
(197, 47, '/buy', '', 1274, -1676.29, 429.268, 998.755, 19690, 0, 15, 0, 0, 0, 0, 0),
(198, 47, '/buy', '', 1274, -1676.47, 429.202, 998.755, 15818, 0, 15, 0, 0, 0, 0, 0),
(199, 7, '/menu', '', 0, 1378.45, 466.612, 20.2038, 0, 0, 2, 0, 0, 0, 0, 0),
(200, 47, '/buy', '', 1274, -1676.25, 429.112, 998.755, 17424, 0, 15, 0, 0, 0, 0, 0),
(201, 70, '/buyalcohol', '', 1274, -1678.41, 431.589, 998.755, 17424, 0, 15, 0, 0, 0, 0, 0),
(202, 31, '/buy\n/buyticket\n/moneytree', '', 1274, -1684.56, 427.141, 998.755, 17424, 0, 15, 0, 0, 0, 0, 0),
(204, 7, '/buy', '', 1274, 379.162, -190.731, 1000.63, 12669, 17, 15, 0, 0, 0, 0, 0),
(206, 7, '/menu', '', 0, 378.299, -178.885, 1000.63, 12669, 17, 2, 0, 0, 0, 0, 0),
(207, 7, '/menu', '', 0, 374.081, -178.931, 1000.63, 12669, 17, 2, 0, 0, 0, 0, 0),
(208, 16, '/buyclothing', '', 1275, -577.122, -1069.03, 1024.02, 10351, 0, 15, 0, 0, 0, 0, 0),
(209, 7, '/menu', '', 0, -575.212, -1067.11, 1024.02, 10351, 0, 2, 0, 0, 0, 0, 0),
(210, 56, '/buy', '', 1274, -105.876, -11.2491, 1000.72, 15571, 3, 15, 0, 0, 0, 0, 0),
(211, 7, '/menu', '', 0, 1381.85, 694.827, 3026.72, 17898, 0, 2, 0, 0, 0, 0, 0),
(212, 7, '/menu', '', 0, 1379.31, 691.687, 3026.72, 17898, 0, 2, 0, 0, 0, 0, 0),
(213, 7, '/menu', '', 0, 1370.71, 703.957, 3026.72, 17898, 0, 2, 0, 0, 0, 0, 0),
(214, 4, '/buy', '', 1274, 2328.23, 6.78681, 26.5292, 0, 0, 15, 0, 0, 0, 0, 0),
(215, 43, '/buyweapons', '', 1274, 312.427, -165.911, 999.601, 15643, 6, 15, 0, 0, 0, 0, 0),
(216, 15, '/buyhardware', '', 1274, 312.378, -162.547, 999.594, 15643, 6, 15, 0, 0, 0, 0, 0),
(217, 32, '/buyelectro', '', 1274, 729.993, 830.005, 1015.54, 12383, 0, 15, 0, 0, 0, 0, 0),
(218, 26, '/buy', '', 1274, 375.478, -119.542, 1001.5, 10821, 5, 15, 0, 0, 0, 0, 0),
(219, 7, '/menu', '', 0, 2436.56, 114.497, 26.598, 0, 0, 2, 0, 0, 0, 0, 0),
(222, 47, '/buy', '', 1274, 1946.55, 1278.81, 1289.41, 12934, 0, 15, 0, 0, 0, 0, 0),
(225, 65, '/tutorial', '', 1239, -588.782, -1069.15, 23.4545, 0, 0, 30, 0, 0, 0, 0, 0),
(228, 71, '/rentbike', '', 1239, -226.555, 1116.83, 1501.17, 15486, 0, 15, 0, 0, 0, 0, 0),
(232, 51, '\n', '', 1239, 2177.49, -47.8203, 27.4766, 0, 0, 45, 0, 0, 0, 61, 0),
(233, 49, '/sklad', '', 1239, -520.448, -501.535, 24.9251, 0, 0, 15, 0, 0, 0, 0, 0),
(234, 49, '/sklad', '', 1239, -529.864, -500.909, 24.9775, 0, 0, 15, 0, 0, 0, 0, 0),
(241, 29, '/buydrugs', '', 1274, -167.464, 1032.26, 2001.09, 11475, 0, 15, 0, 0, 0, 0, 0),
(242, 29, '/buydrugs', '', 1274, -167.515, 1032.16, 2001.09, 13593, 0, 15, 0, 0, 0, 0, 0),
(249, 60, '/rozhlas\n/rozhlasperm', '', 1239, -435.394, -63.2901, 58.875, 0, 0, 5, 0, 0, 0, 0, 0),
(250, 72, '/prace', '', 1239, -436.216, -60.4011, 58.875, 0, 0, 15, 0, 0, 0, 0, 0),
(252, 2, '/menu\n/signcheck\n/kontrakt', '', 1239, 2268.37, -70.587, 82.0723, 19340, 0, 15, 0, 0, 0, 0, 0),
(255, 75, '/export', '', 1239, -557.574, -500.349, 25.0164, 0, 0, 15, 0, 0, 0, 0, 0),
(256, 10, '/satna', '', 1275, 1218.64, 495.735, 20.2345, 0, 0, 15, 0, 0, 0, 0, 0),
(257, 32, '/menu \n /buycredit', '', 1239, -2237.03, 130.212, 1035.41, 15569, 6, 15, 0, 0, 0, 0, 0),
(258, 31, '/menu', '', 1239, -103.742, 1104, 3019.81, 10949, 0, 15, 0, 0, 0, 0, 0),
(259, 32, '/buy\n/buycredit', '', 1274, 730.038, 829.997, 1015.54, 12793, 0, 15, 0, 0, 0, 0, 0),
(262, 70, '/buyalcohol', '', 1274, 193.717, -37.3958, 1201.99, 13972, 0, 15, 0, 0, 0, 0, 0),
(263, 70, '/buyalcohol', '', 1274, 198.067, -46.0712, 1205.7, 13972, 0, 15, 0, 0, 0, 0, 0),
(264, 31, '/buy\n/buyticket\n/moneytree', '', 1274, 2.09465, -29.0145, 1003.55, 14485, 10, 15, 0, 0, 0, 0, 0),
(266, 11, '/predatryby', '', 1239, 2971.44, -702.858, 9.31249, 0, 0, 15, 0, 0, 0, 0, 0),
(267, 32, '/buy\n/buycredit', '', 1274, 730.189, 830.367, 1015.54, 13077, 0, 15, 0, 0, 0, 0, 0),
(268, 32, '/buy\n/buycredit', '', 1274, 730.235, 829.997, 1015.54, 14485, 0, 15, 0, 0, 0, 0, 0),
(269, 31, '/buy\n/buyticket\n/moneytree', '', 1274, -31.0578, -29.0129, 1003.56, 12383, 4, 15, 0, 0, 0, 0, 0),
(273, 32, '/menu\n/buycredit', '', 1239, -2237.19, 130.4, 1035.41, 12383, 6, 15, 0, 0, 0, 0, 0),
(275, 73, '/buy', '', 1274, -436.72, -67.1831, 58.875, 0, 0, 15, 0, 0, 0, 0, 0),
(278, 64, '/selldrugs', '', 1274, 2296.77, 193.393, 25.5111, 0, 0, 15, 0, 0, 0, 0, 0),
(280, 32, '/buyelectro\n/buycredit', '', 1274, 730.382, 829.996, 1015.54, 19692, 0, 15, 0, 0, 0, 0, 0),
(282, 24, '/buy', '', 1274, 313.458, -162.463, 999.594, 13068, 6, 15, 0, 0, 0, 0, 0),
(283, 32, '/buyelectro\n/buycredit', '', 1274, 729.803, 829.999, 1015.54, 13065, 0, 15, 0, 0, 0, 0, 0),
(284, 44, '/live\n/liveperm', '', 1239, 2049.65, -1210.17, 1024.22, 16188, 0, 15, 0, 0, 0, 0, 0),
(285, 70, '/buyalcohol', '', 1274, 498.17, -78.9099, 998.758, 15735, 11, 3, 0, 0, 0, 0, 0),
(286, 42, '/advert', '', 1274, 2263.51, -70.9323, 82.0723, 19340, 0, 15, 0, 0, 0, 0, 0),
(287, 70, '/buyalcohol', '', 1274, -2221.8, 648.603, 2001.6, 18255, 0, 3, 0, 0, 0, 0, 0),
(288, 48, '/fos', '', 0, 1489.13, 1335.16, 284.371, 16988, 0, 3, 0, 0, 0, 0, 0),
(289, 48, '/fos', '', 0, 1489.22, 1343.11, 284.371, 16988, 0, 3, 0, 0, 0, 0, 0),
(290, 48, '/fos', '', 0, 1478.72, 1348.41, 280.908, 16988, 0, 3, 0, 0, 0, 0, 0),
(291, 48, '/fos', '', 0, 1476.37, 1348.35, 280.908, 16988, 0, 3, 0, 0, 0, 0, 0),
(292, 48, '/fos', '', 0, 1475.48, 1344.69, 280.908, 16988, 0, 3, 0, 0, 0, 0, 0),
(294, 70, '/buyalcohol', '', 1274, 1382.77, -971.623, 2033.21, 10322, 0, 3, 0, 0, 0, 0, 0),
(297, 74, '/storage', '', 1239, -448.722, -65.9517, 59.3853, 0, 0, 15, 0, 0, 0, 0, 0),
(298, 1, 'ZÓNA 2', '', 1239, -441.55, -94.5469, 59.232, 0, 0, 25, 0, 0, 0, 0, 0),
(299, 1, 'ZÓNA 1', '', 1239, -476.098, -14.4702, 55.953, 0, 0, 25, 0, 0, 0, 0, 0),
(300, 1, 'ZÓNA 1', '', 1239, -535.625, -16.6402, 61.6465, 0, 0, 25, 0, 0, 0, 0, 0),
(301, 1, 'ZÓNA 3', '', 1239, -435.307, -195.678, 73.7186, 0, 0, 25, 0, 0, 0, 0, 0),
(302, 31, '/buy\n/buyticket\n/moneytree', '', 1274, 2493.13, 1804.45, 3001.09, 15409, 0, 15, 0, 0, 0, 0, 0),
(303, 50, '/sklad', '', 1239, 271.934, 1410.48, 10.4611, 0, 0, 50, 0, 0, 0, 0, 0),
(304, 20, '/buy', '', 1274, 1492.97, 1330.28, 280.908, 16988, 0, 5, 0, 0, 0, 0, 0),
(306, 6, '/rybarit', '', 1239, 3036.17, -771.107, 1.74897, 0, 0, 15, 0, 0, 0, 0, 0),
(308, 8, '/satna', '', 1275, 327.103, 307.224, 999.148, 19786, 5, 15, 0, 0, 0, 0, 0),
(309, 4, '/buy', '', 1239, 321.218, 308.33, 999.148, 19786, 5, 3, 0, 0, 0, 0, 0),
(310, 70, '/buy', '', 1239, 783.368, -500.019, -66.9641, 18255, 0, 15, 0, 0, 0, 0, 0),
(312, 43, '/buyweapons', '', 1274, 1361.46, 1543.5, 3627, 19845, 0, 15, 0, 0, 0, 0, 0),
(319, 37, '/menu', '', 1274, 661.382, -645.483, 1516.34, 16130, 0, 15, 0, 0, 0, 0, 0),
(332, 70, '[ ALKOHOLICKÉ NÁPOJE ]\n/buyalcohol', '', 1274, -1676.99, 431.59, 998.755, 16918, 0, 4, 0, 0, 0, 0, 0),
(333, 47, '[ AUTO-POTREBY ]\n/buy', '', 1274, -1676.33, 429.093, 998.755, 16918, 0, 4, 0, 0, 0, 0, 0),
(334, 31, '[ MISCELLANEOUS ]\n/buy', '', 1274, -1684.39, 427.61, 998.755, 16918, 0, 4, 0, 0, 0, 0, 0),
(335, 4, '[ KÁVA ]\n/buy', '', 1274, -1684.64, 431.153, 998.755, 16918, 0, 4, 0, 0, 0, 0, 0),
(337, 20, '/buy', '', 1274, 450.809, -83.8312, 999.555, 11462, 4, 15, 0, 0, 0, 0, 0),
(339, 24, '/menu', '', 1239, 308.101, -141.464, 999.602, 14302, 7, 15, 0, 0, 0, 0, 0),
(346, 36, '/menu', '', 1274, 3952.06, 2886.56, 251.086, 14702, 0, 15, 0, 0, 0, 0, 0),
(347, 66, '/cisterna', '', 1239, 248.746, 1420.77, 10.5785, 0, 0, 15, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_phonebooths`
--

CREATE TABLE `gm_phonebooths` (
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `RX` float NOT NULL,
  `RY` float NOT NULL,
  `RZ` float NOT NULL,
  `VW` int(11) NOT NULL,
  `Interior` int(11) NOT NULL,
  `Price` float NOT NULL,
  `Code` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_roadsigns`
--

CREATE TABLE `gm_roadsigns` (
  `Street` text NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `RX` float NOT NULL,
  `RY` float NOT NULL,
  `RZ` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_speedcameras`
--

CREATE TABLE `gm_speedcameras` (
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `RX` float NOT NULL,
  `RY` float NOT NULL,
  `RZ` float NOT NULL,
  `SpeedLimit` smallint(6) NOT NULL,
  `BaseFine` smallint(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `gm_speedcameras`
--

INSERT INTO `gm_speedcameras` (`X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `SpeedLimit`, `BaseFine`) VALUES
(817.575, -163.384, 14.562, 0, 0, 85.3972, 75, 250),
(754.523, -168.365, 14.5605, 0, 0, 264.939, 75, 250);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_stats`
--

CREATE TABLE `gm_stats` (
  `lOOC` int(11) NOT NULL,
  `gOOC` int(11) NOT NULL,
  `gm_Lines` int(11) NOT NULL,
  `gm_Version` text NOT NULL,
  `gm_Objects` int(11) NOT NULL,
  `gm_Vehicles` int(11) NOT NULL,
  `gm_Author` text NOT NULL,
  `gm_MaxRPLvl` int(11) NOT NULL,
  `gm_MaxRPLvlN` text NOT NULL,
  `gm_EconomyBoost` float NOT NULL,
  `gm_Commands` int(11) NOT NULL,
  `web_Version` text NOT NULL,
  `web_Announce` text NOT NULL,
  `gm_playRecord` int(11) NOT NULL,
  `Register_Money` int(11) NOT NULL,
  `Register_Golds` int(11) NOT NULL,
  `playt` int(11) NOT NULL,
  `playtN` text NOT NULL,
  `models` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `gm_stats`
--

INSERT INTO `gm_stats` (`lOOC`, `gOOC`, `gm_Lines`, `gm_Version`, `gm_Objects`, `gm_Vehicles`, `gm_Author`, `gm_MaxRPLvl`, `gm_MaxRPLvlN`, `gm_EconomyBoost`, `gm_Commands`, `web_Version`, `web_Announce`, `gm_playRecord`, `Register_Money`, `Register_Golds`, `playt`, `playtN`, `models`) VALUES
(0, 1, 194789, '', 81748, 140, 'bigw3b.', 0, '', 1, 475, '', '', 0, 5000, 0, 0, '', 0);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `gm_weed`
--

CREATE TABLE `gm_weed` (
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `VW` int(11) NOT NULL,
  `Interior` int(11) NOT NULL,
  `UnixPlaced` int(11) NOT NULL,
  `UnixFinish` int(11) NOT NULL,
  `Owner` text NOT NULL,
  `DrugId` int(11) NOT NULL,
  `Hnojivo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `inventory`
--

CREATE TABLE `inventory` (
  `id` int(11) NOT NULL,
  `charid` int(11) NOT NULL,
  `itemid` int(11) NOT NULL,
  `itemtype` int(11) NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `inventory_items`
--

CREATE TABLE `inventory_items` (
  `ID` int(11) NOT NULL,
  `Name` text NOT NULL,
  `Type` int(11) NOT NULL,
  `StockPrice` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `login_history`
--

CREATE TABLE `login_history` (
  `id` int(11) NOT NULL,
  `username` varchar(32) NOT NULL,
  `type` tinyint(4) NOT NULL,
  `timestampdate` bigint(20) NOT NULL,
  `ipaddress` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `maps_names`
--

CREATE TABLE `maps_names` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `createdby` varchar(25) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `maps_names`
--

INSERT INTO `maps_names` (`id`, `name`, `createdby`, `date`) VALUES
(1, 'Montgomery_Gang_Addon', 'Sonny_Lavery', '2018-10-18');

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `maps_objects`
--

CREATE TABLE `maps_objects` (
  `mapid` int(11) NOT NULL,
  `model` mediumint(9) NOT NULL,
  `objectid` mediumint(9) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rx` float NOT NULL,
  `ry` float NOT NULL,
  `rz` float NOT NULL,
  `vw` mediumint(9) NOT NULL,
  `interior` smallint(6) NOT NULL,
  `placedby` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `master_accounts`
--

CREATE TABLE `master_accounts` (
  `id` int(11) NOT NULL,
  `Username` text NOT NULL,
  `Password` text NOT NULL,
  `PassRecovery` int(11) NOT NULL,
  `EMail` varchar(128) NOT NULL,
  `RegIP` varchar(20) NOT NULL,
  `LastIP` varchar(20) NOT NULL,
  `AdminLevel` int(11) DEFAULT '0',
  `DonatorLevel` int(11) NOT NULL,
  `DonatorExpireUnix` int(11) NOT NULL,
  `Starost` text NOT NULL,
  `Activated` int(11) NOT NULL,
  `Activated_IPFrom` text NOT NULL,
  `Activated_Admin` varchar(25) NOT NULL,
  `Activated_Reason` text CHARACTER SET utf8 COLLATE utf8_czech_ci NOT NULL,
  `Assistances` int(11) NOT NULL,
  `Registered` datetime NOT NULL,
  `Kicks` int(11) NOT NULL,
  `Bans` int(11) NOT NULL,
  `Jails` int(11) NOT NULL,
  `isInJail` int(11) NOT NULL,
  `jail_Admin` text NOT NULL,
  `jail_Reason` text NOT NULL,
  `jail_Time_M` int(11) NOT NULL,
  `jail_Time_S` tinyint(4) NOT NULL,
  `opt_WebTD` int(11) NOT NULL,
  `opt_TimeTD` int(11) NOT NULL,
  `opt_PM` tinyint(4) NOT NULL,
  `opt_Sounds` tinyint(4) NOT NULL,
  `opt_VitalTd` tinyint(4) NOT NULL,
  `opt_HungerTd` tinyint(4) NOT NULL,
  `opt_tachometer` tinyint(4) NOT NULL,
  `opt_centy` tinyint(4) NOT NULL,
  `RenameTicket` smallint(6) NOT NULL,
  `SVO` smallint(6) NOT NULL,
  `opt_ChatAnim` tinyint(4) NOT NULL,
  `Mince` int(11) NOT NULL DEFAULT '0',
  `LastChangelog` text NOT NULL,
  `MessagesSent` int(11) NOT NULL,
  `PlayTime` int(11) NOT NULL,
  `avatarUrl` varchar(1024) NOT NULL,
  `ChristmasVoucher` int(11) NOT NULL,
  `WhitelistSent` bigint(20) NOT NULL,
  `WhitelistCount` int(11) NOT NULL DEFAULT '0',
  `opt_HideMaster` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `master_achievements`
--

CREATE TABLE `master_achievements` (
  `id` int(11) NOT NULL,
  `user` varchar(64) NOT NULL,
  `achievementid` int(11) NOT NULL,
  `date` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `phone_contacts`
--

CREATE TABLE `phone_contacts` (
  `Username` text NOT NULL,
  `ContactName` text NOT NULL,
  `ContactNumber` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `phone_list`
--

CREATE TABLE `phone_list` (
  `FromNumber` int(11) NOT NULL,
  `ToNumber` int(11) NOT NULL,
  `Text` text NOT NULL,
  `Date` int(11) NOT NULL,
  `DisplayFor` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `player_weapons`
--

CREATE TABLE `player_weapons` (
  `Username` text NOT NULL,
  `WeaponId` tinyint(4) NOT NULL,
  `Ammo` int(11) NOT NULL,
  `AmmoGiven` int(11) NOT NULL,
  `SerialNumber` bigint(20) NOT NULL,
  `IsPermitted` tinyint(4) NOT NULL,
  `WorkWeapon` tinyint(4) NOT NULL,
  `Origin` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `punishlist`
--

CREATE TABLE `punishlist` (
  `id` int(11) NOT NULL,
  `MasterAcc` text NOT NULL,
  `Username` text NOT NULL,
  `AdminMACC` text NOT NULL,
  `Date` int(11) NOT NULL,
  `Reason` text NOT NULL,
  `Type` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `vehicle_attachable`
--

CREATE TABLE `vehicle_attachable` (
  `ID` int(11) NOT NULL,
  `Name` varchar(48) NOT NULL,
  `Model` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `vehicle_attachable`
--

INSERT INTO `vehicle_attachable` (`ID`, `Name`, `Model`) VALUES
(107, 'Objekt na text', 19479),
(108, 'Vyfuk1', 1022),
(109, 'Vyfuk2', 1021),
(110, 'Vyfuk3', 1020),
(111, 'Vyfuk4', 1019),
(113, 'Vyfuk4', 1104),
(114, 'Vyfuk5', 1105),
(116, 'Vyfuk6', 1018),
(117, 'Vyfuk7', 1089),
(118, 'Vyfuk8', 1135),
(119, 'Vyfuk9', 1104),
(120, 'Vyfuk10', 1092),
(121, 'Vyfuk11', 1136),
(122, 'Vyfuk12', 1132),
(123, 'Vyfuk13', 1129),
(124, 'Vyfuk14', 1127),
(125, 'Vyfuk15', 1126),
(126, 'Vyfuk16', 1114),
(127, 'Vyfuk17', 1028),
(128, 'Vyfuk18', 1105),
(129, 'Vyfuk19', 1113),
(130, 'Vyfuk20', 1021),
(131, 'Vyfuk21', 1045),
(132, 'Vyfuk22', 1034),
(133, 'Vyfuk23', 1037),
(134, 'Vyfuk24', 1043),
(135, 'Vyfuk25', 1044),
(136, 'Vyfuk26', 1029),
(137, 'Vyfuk27', 1046),
(138, 'Vyfuk28', 1059),
(139, 'Vyfuk29', 1064),
(140, 'Vyfuk30', 1065),
(142, 'Vyfuk31', 1066),
(143, 'PNaraznik1', 1117),
(144, 'PNaraznik2', 1182),
(145, 'PNaraznik3', 1174),
(147, 'PNaraznik4', 1175),
(148, 'PNaraznik5', 1176),
(149, 'PNaraznik6', 1177),
(150, 'PNaraznik7', 1178),
(151, 'PNaraznik8', 1179),
(152, 'PNaraznik9', 1180),
(153, 'PNaraznik10', 1181),
(154, 'PNaraznik11', 1183),
(155, 'PNaraznik12', 1172),
(156, 'PNaraznik13', 1184),
(157, 'PNaraznik14', 1185),
(158, 'PNaraznik15', 1186),
(159, 'PNaraznik16', 1187),
(160, 'PNaraznik17', 1188),
(161, 'PNaraznik18', 1189),
(162, 'PNaraznik19', 1190),
(163, 'PNaraznik20', 1191),
(164, 'PNaraznik21', 1192),
(165, 'PNaraznik22', 1173),
(166, 'PNaraznik23', 1171),
(167, 'PNaraznik24', 1140),
(168, 'PNaraznik25', 1155),
(169, 'PNaraznik26', 1141),
(170, 'PNaraznik27', 1148),
(171, 'PNaraznik28', 1149),
(172, 'PNaraznik29', 1150),
(173, 'PNaraznik30', 1151),
(174, 'PNaraznik31', 1152),
(175, 'PNaraznik32', 1153),
(176, 'PNaraznik33', 1154),
(177, 'PNaraznik34', 1156),
(178, 'PNaraznik35', 1170),
(179, 'PNaraznik36', 1157),
(180, 'PNaraznik37', 1159),
(181, 'PNaraznik38', 1160),
(182, 'PNaraznik39', 1161),
(183, 'PNaraznik40', 1165),
(184, 'PNaraznik41', 1166),
(185, 'PNaraznik42', 1167),
(186, 'PNaraznik43', 1168),
(187, 'PNaraznik44', 1169),
(188, 'PNaraznik45', 1193),
(189, 'Spoiler1', 1000),
(190, 'Spoiler2', 1001),
(191, 'Spoiler3', 1146),
(192, 'Spoiler4', 1002),
(193, 'Spoiler5', 1003),
(194, 'Spoiler6', 1014),
(195, 'Spoiler7', 1015),
(196, 'Spoiler8', 1016),
(197, 'Spoiler9', 1023),
(198, 'Spoiler10', 1049),
(199, 'Spoiler11', 1050),
(200, 'Spoiler12', 1058),
(201, 'Spoiler13', 1060),
(202, 'Spoiler14', 1138),
(203, 'Spoiler15', 1139),
(204, 'Spoiler16', 1147),
(205, 'Spoiler17', 1158),
(206, 'Spoiler18', 1162),
(207, 'Spoiler19', 1163),
(208, 'Spoiler20', 1164),
(209, 'Socha1', 1112),
(210, 'Socha2', 1111),
(211, 'Nitro1', 1009),
(212, 'Nitro2', 1010),
(213, 'Nitro3', 1008),
(214, 'Maska1', 1116),
(215, 'Maska2', 1115),
(216, 'Svetla1', 1024),
(217, 'Svetla2', 1013),
(218, 'Strecha1', 1130),
(219, 'Strecha2', 1131),
(220, 'Strecha3', 1128),
(221, 'ZadnyChrom', 1109),
(222, 'Pruduchy1', 1007),
(223, 'Pruduchy2', 1017),
(224, 'Pruduchy3', 1006),
(225, 'Pruduchy4', 1142),
(226, 'Pruduchy5', 1143),
(227, 'Pruduchy6', 1144),
(228, 'Pruduchy7', 1145),
(229, 'Pruduchy8', 1004),
(230, 'Pruduchy9', 1011),
(231, 'Pruduchy10', 1005),
(232, 'Pruduchy11', 1012),
(233, 'Kola Offroad', 1025),
(234, 'Kola Shadow', 1073),
(236, 'Kola Rimshine', 1075),
(237, 'Kola Mega', 1074),
(238, 'Kola Wires', 1076),
(239, 'Kola Classic', 1077),
(241, 'Kola Twist', 1078),
(242, 'Kola Cutter', 1079),
(243, 'Kola Switch', 1080),
(244, 'Kola Grove', 1081),
(245, 'Kola Import', 1082),
(246, 'Kola Dollar', 1083),
(247, 'Kola Trance', 1084),
(248, 'Kola Atomic', 1085),
(249, 'Kola Ahab', 1096),
(250, 'Kola Virtual', 1097),
(251, 'Kola Access', 1098),
(252, 'Taxi1', 19308),
(253, 'Taxi2', 19309),
(254, 'Taxi3', 19310),
(255, 'Taxi4', 19311),
(256, 'sirena', 11702);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `vehicle_objects`
--

CREATE TABLE `vehicle_objects` (
  `SPZ` varchar(32) NOT NULL,
  `Slot` tinyint(4) NOT NULL,
  `Name` text NOT NULL,
  `Model` int(11) NOT NULL,
  `X` float NOT NULL,
  `Y` float NOT NULL,
  `Z` float NOT NULL,
  `RX` float NOT NULL,
  `RY` float NOT NULL,
  `RZ` float NOT NULL,
  `ColorArray` text,
  `TextArray` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `voucher_main`
--

CREATE TABLE `voucher_main` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `unixto` bigint(20) NOT NULL,
  `active` tinyint(4) NOT NULL,
  `Money` int(11) NOT NULL,
  `Golds` int(11) NOT NULL,
  `Vehicle` int(11) NOT NULL,
  `DonatorLevel` int(11) NOT NULL,
  `DonatorTime` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `voucher_main`
--

INSERT INTO `voucher_main` (`id`, `name`, `unixto`, `active`, `Money`, `Golds`, `Vehicle`, `DonatorLevel`, `DonatorTime`) VALUES
(1, 'Vianocny bonus', 0, 1, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `voucher_player`
--

CREATE TABLE `voucher_player` (
  `id` int(11) NOT NULL,
  `type` tinyint(4) NOT NULL COMMENT '0 master 1 char',
  `name` text NOT NULL,
  `voucherid` int(11) NOT NULL,
  `redeemed` tinyint(4) NOT NULL,
  `redeemeddate` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Sťahujem dáta pre tabuľku `voucher_player`
--

INSERT INTO `voucher_player` (`id`, `type`, `name`, `voucherid`, `redeemed`, `redeemeddate`) VALUES
(1, 0, 'bigw3b', 1, 0, 0),
(2, 0, 'DaNNy', 1, 0, 0),
(3, 0, 'Mett', 1, 0, 0),
(4, 0, 'bobby', 1, 0, 0),
(5, 0, 'Eric', 1, 0, 0),
(6, 0, 'Marc', 1, 0, 0),
(7, 0, 'Persi', 1, 0, 0),
(8, 0, 'Lukyss', 1, 0, 0),
(9, 0, 'MATYES', 1, 0, 0),
(10, 0, 'Daemino', 1, 0, 0),
(11, 0, 'Zeintar', 1, 0, 0),
(12, 0, 'Cyrex', 1, 0, 0),
(13, 0, 'fil0', 1, 0, 0),
(14, 0, 'AkelGP', 1, 0, 0),
(15, 0, 'DavaDavaCizek', 1, 0, 0),
(16, 0, 'Codeyn', 1, 0, 0),
(17, 0, 'ralfovopipik', 1, 0, 0),
(18, 0, 'TilaS', 1, 0, 0);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `weapon_db`
--

CREATE TABLE `weapon_db` (
  `WeaponId` tinyint(4) NOT NULL,
  `Holder` text NOT NULL,
  `GivenAmmo` int(11) NOT NULL,
  `SerialNumber` int(11) NOT NULL,
  `Type` int(11) NOT NULL,
  `Origin` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `weapon_log`
--

CREATE TABLE `weapon_log` (
  `id` int(11) NOT NULL,
  `username` text NOT NULL,
  `date` int(11) NOT NULL,
  `text` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Kľúče pre exportované tabuľky
--

--
-- Indexy pre tabuľku `anawalt_kontrakt`
--
ALTER TABLE `anawalt_kontrakt`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `bazar_log`
--
ALTER TABLE `bazar_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `cctv`
--
ALTER TABLE `cctv`
  ADD PRIMARY KEY (`ID`);

--
-- Indexy pre tabuľku `char_inventory`
--
ALTER TABLE `char_inventory`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `char_main`
--
ALTER TABLE `char_main`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `char_stats`
--
ALTER TABLE `char_stats`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `char_vehicles`
--
ALTER TABLE `char_vehicles`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `faction_vehicles`
--
ALTER TABLE `faction_vehicles`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `gm_arrows`
--
ALTER TABLE `gm_arrows`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `gm_bankaccs`
--
ALTER TABLE `gm_bankaccs`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `gm_calls`
--
ALTER TABLE `gm_calls`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `gm_crates`
--
ALTER TABLE `gm_crates`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `gm_factions`
--
ALTER TABLE `gm_factions`
  ADD PRIMARY KEY (`nid`);

--
-- Indexy pre tabuľku `gm_garages`
--
ALTER TABLE `gm_garages`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `gm_garage_interiors`
--
ALTER TABLE `gm_garage_interiors`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `gm_houses`
--
ALTER TABLE `gm_houses`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `gm_house_interiors`
--
ALTER TABLE `gm_house_interiors`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `gm_ipbans`
--
ALTER TABLE `gm_ipbans`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `gm_logs`
--
ALTER TABLE `gm_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `gm_menu`
--
ALTER TABLE `gm_menu`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `inventory_items`
--
ALTER TABLE `inventory_items`
  ADD UNIQUE KEY `ID` (`ID`);

--
-- Indexy pre tabuľku `login_history`
--
ALTER TABLE `login_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `maps_names`
--
ALTER TABLE `maps_names`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `master_accounts`
--
ALTER TABLE `master_accounts`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `master_achievements`
--
ALTER TABLE `master_achievements`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `punishlist`
--
ALTER TABLE `punishlist`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `vehicle_attachable`
--
ALTER TABLE `vehicle_attachable`
  ADD PRIMARY KEY (`ID`);

--
-- Indexy pre tabuľku `voucher_main`
--
ALTER TABLE `voucher_main`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `voucher_player`
--
ALTER TABLE `voucher_player`
  ADD PRIMARY KEY (`id`);

--
-- Indexy pre tabuľku `weapon_log`
--
ALTER TABLE `weapon_log`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pre exportované tabuľky
--

--
-- AUTO_INCREMENT pre tabuľku `anawalt_kontrakt`
--
ALTER TABLE `anawalt_kontrakt`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pre tabuľku `bazar_log`
--
ALTER TABLE `bazar_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pre tabuľku `cctv`
--
ALTER TABLE `cctv`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pre tabuľku `char_inventory`
--
ALTER TABLE `char_inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pre tabuľku `char_main`
--
ALTER TABLE `char_main`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pre tabuľku `char_stats`
--
ALTER TABLE `char_stats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pre tabuľku `char_vehicles`
--
ALTER TABLE `char_vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pre tabuľku `faction_vehicles`
--
ALTER TABLE `faction_vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pre tabuľku `gm_arrows`
--
ALTER TABLE `gm_arrows`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT pre tabuľku `gm_bankaccs`
--
ALTER TABLE `gm_bankaccs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=306;

--
-- AUTO_INCREMENT pre tabuľku `gm_calls`
--
ALTER TABLE `gm_calls`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pre tabuľku `gm_crates`
--
ALTER TABLE `gm_crates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pre tabuľku `gm_factions`
--
ALTER TABLE `gm_factions`
  MODIFY `nid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT pre tabuľku `gm_garages`
--
ALTER TABLE `gm_garages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=114;

--
-- AUTO_INCREMENT pre tabuľku `gm_garage_interiors`
--
ALTER TABLE `gm_garage_interiors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pre tabuľku `gm_houses`
--
ALTER TABLE `gm_houses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=369;

--
-- AUTO_INCREMENT pre tabuľku `gm_house_interiors`
--
ALTER TABLE `gm_house_interiors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT pre tabuľku `gm_ipbans`
--
ALTER TABLE `gm_ipbans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pre tabuľku `gm_logs`
--
ALTER TABLE `gm_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pre tabuľku `gm_menu`
--
ALTER TABLE `gm_menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=348;

--
-- AUTO_INCREMENT pre tabuľku `inventory`
--
ALTER TABLE `inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pre tabuľku `login_history`
--
ALTER TABLE `login_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pre tabuľku `maps_names`
--
ALTER TABLE `maps_names`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pre tabuľku `master_accounts`
--
ALTER TABLE `master_accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pre tabuľku `master_achievements`
--
ALTER TABLE `master_achievements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pre tabuľku `punishlist`
--
ALTER TABLE `punishlist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pre tabuľku `vehicle_attachable`
--
ALTER TABLE `vehicle_attachable`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=257;

--
-- AUTO_INCREMENT pre tabuľku `voucher_main`
--
ALTER TABLE `voucher_main`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pre tabuľku `voucher_player`
--
ALTER TABLE `voucher_player`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT pre tabuľku `weapon_log`
--
ALTER TABLE `weapon_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
