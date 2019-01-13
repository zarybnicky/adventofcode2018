#! /usr/bin/env nix-shell
<?php
#! nix-shell -i php -p php

$guards = [];

$input = explode("\n", file_get_contents('day4.txt'));

usort($input, function ($a, $b) {
    $a = strtotime(substr($a, 1, 16));
    $b = strtotime(substr($b, 1, 16));
    return ($a < $b) ? -1 : (($a > $b) ? 1 : 0);
});

$currentGuard = null;
$currentStart = null;
foreach ($input as $line) {
    list($minute, $action) = explode('] ', substr($line, 15));
    if (strpos($action, 'Guard #') === 0) {
        $currentGuard = (int) substr($action, 7);
    } elseif (strpos($action, 'falls asleep') === 0) {
        $currentStart = $minute;
    } elseif (strpos($action, 'wakes up') === 0) {
        if (!isset($guards[$currentGuard])) {
            $guards[$currentGuard] = [];
        }
        foreach (range($currentStart, $minute - 1) as $step) {
            if (!isset($guards[$currentGuard][$step])) {
                $guards[$currentGuard][$step] = 0;
            }
            $guards[$currentGuard][$step] += 1;
        }
    } else {
        echo $line, "\n";
    }
}

ksort($guards);
$mostSleepy = [0, 0];
foreach ($guards as $key => $item) {
    $sum = array_sum($item);
    if ($sum > $mostSleepy[1]) {
        $mostSleepy = [$key, $sum];
    }
}

ksort($guards[$mostSleepy[0]]);
$bestMinute = [0, 0];
foreach ($guards[$mostSleepy[0]] as $minute => $count) {
    if ($count > $bestMinute[1]) {
        $bestMinute = [$minute, $count];
    }
}

echo "Part 1: \n";
echo "Guard ID: ", $mostSleepy[0], "\n";
echo "Most sleepy minute: ", $bestMinute[0], "\n";
echo "Answer: ", $bestMinute[0] * $mostSleepy[0], "\n\n";


$bestMinute = [0, 0, 0];
foreach ($guards as $guardId => $guard) {
    foreach ($guard as $minute => $count) {
        if ($count > $bestMinute[2]) {
            $bestMinute = [$guardId, $minute, $count];
        }
    }
}
echo "Part 2: \n";
echo "Guard ID: ", $bestMinute[0], "\n";
echo "Minute: ", $bestMinute[1], "\n";
echo "Answer: ", $bestMinute[0] * $bestMinute[1], "\n";
