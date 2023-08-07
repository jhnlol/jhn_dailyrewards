CREATE TABLE `daily_rewards` (
  `id` int(11) NOT NULL,
  `identifier` varchar(46) DEFAULT NULL,
  `last_reward_day` int(11) NOT NULL,
  `num_rewards` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `daily_rewards`
--
ALTER TABLE `daily_rewards`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `daily_rewards`
--
ALTER TABLE `daily_rewards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;
COMMIT;
