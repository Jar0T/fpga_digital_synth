--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.common_pkg.all;

package osc_pkg is

    constant PHASE_WIDTH : integer := 32;
    constant SAMPLE_WIDTH : integer := 16;
    constant SAMPLE_ADDR_WIDTH : integer := 9;
    
    type t_phase_step_array is array(0 to N_CHANNELS - 1) of unsigned(PHASE_WIDTH - 1 downto 0);
    type t_sample_array is array(0 to N_CHANNELS - 1) of signed(SAMPLE_WIDTH - 1 downto 0);
    
    type t_wave_lut is array(0 to 2**SAMPLE_ADDR_WIDTH - 1) of signed(SAMPLE_WIDTH - 1 downto 0);
    
    constant SINE_WAVE_INIT : t_wave_lut;

end osc_pkg;

package body osc_pkg is

    constant SINE_WAVE_INIT : t_wave_lut := (
        0 => to_signed(0, SAMPLE_WIDTH),
        1 => to_signed(402, SAMPLE_WIDTH),
        2 => to_signed(804, SAMPLE_WIDTH),
        3 => to_signed(1206, SAMPLE_WIDTH),
        4 => to_signed(1607, SAMPLE_WIDTH),
        5 => to_signed(2009, SAMPLE_WIDTH),
        6 => to_signed(2410, SAMPLE_WIDTH),
        7 => to_signed(2811, SAMPLE_WIDTH),
        8 => to_signed(3211, SAMPLE_WIDTH),
        9 => to_signed(3611, SAMPLE_WIDTH),
        10 => to_signed(4011, SAMPLE_WIDTH),
        11 => to_signed(4409, SAMPLE_WIDTH),
        12 => to_signed(4807, SAMPLE_WIDTH),
        13 => to_signed(5205, SAMPLE_WIDTH),
        14 => to_signed(5601, SAMPLE_WIDTH),
        15 => to_signed(5997, SAMPLE_WIDTH),
        16 => to_signed(6392, SAMPLE_WIDTH),
        17 => to_signed(6786, SAMPLE_WIDTH),
        18 => to_signed(7179, SAMPLE_WIDTH),
        19 => to_signed(7571, SAMPLE_WIDTH),
        20 => to_signed(7961, SAMPLE_WIDTH),
        21 => to_signed(8351, SAMPLE_WIDTH),
        22 => to_signed(8739, SAMPLE_WIDTH),
        23 => to_signed(9126, SAMPLE_WIDTH),
        24 => to_signed(9511, SAMPLE_WIDTH),
        25 => to_signed(9895, SAMPLE_WIDTH),
        26 => to_signed(10278, SAMPLE_WIDTH),
        27 => to_signed(10659, SAMPLE_WIDTH),
        28 => to_signed(11038, SAMPLE_WIDTH),
        29 => to_signed(11416, SAMPLE_WIDTH),
        30 => to_signed(11792, SAMPLE_WIDTH),
        31 => to_signed(12166, SAMPLE_WIDTH),
        32 => to_signed(12539, SAMPLE_WIDTH),
        33 => to_signed(12909, SAMPLE_WIDTH),
        34 => to_signed(13278, SAMPLE_WIDTH),
        35 => to_signed(13645, SAMPLE_WIDTH),
        36 => to_signed(14009, SAMPLE_WIDTH),
        37 => to_signed(14372, SAMPLE_WIDTH),
        38 => to_signed(14732, SAMPLE_WIDTH),
        39 => to_signed(15090, SAMPLE_WIDTH),
        40 => to_signed(15446, SAMPLE_WIDTH),
        41 => to_signed(15799, SAMPLE_WIDTH),
        42 => to_signed(16150, SAMPLE_WIDTH),
        43 => to_signed(16499, SAMPLE_WIDTH),
        44 => to_signed(16845, SAMPLE_WIDTH),
        45 => to_signed(17189, SAMPLE_WIDTH),
        46 => to_signed(17530, SAMPLE_WIDTH),
        47 => to_signed(17868, SAMPLE_WIDTH),
        48 => to_signed(18204, SAMPLE_WIDTH),
        49 => to_signed(18537, SAMPLE_WIDTH),
        50 => to_signed(18867, SAMPLE_WIDTH),
        51 => to_signed(19194, SAMPLE_WIDTH),
        52 => to_signed(19519, SAMPLE_WIDTH),
        53 => to_signed(19840, SAMPLE_WIDTH),
        54 => to_signed(20159, SAMPLE_WIDTH),
        55 => to_signed(20474, SAMPLE_WIDTH),
        56 => to_signed(20787, SAMPLE_WIDTH),
        57 => to_signed(21096, SAMPLE_WIDTH),
        58 => to_signed(21402, SAMPLE_WIDTH),
        59 => to_signed(21705, SAMPLE_WIDTH),
        60 => to_signed(22004, SAMPLE_WIDTH),
        61 => to_signed(22301, SAMPLE_WIDTH),
        62 => to_signed(22594, SAMPLE_WIDTH),
        63 => to_signed(22883, SAMPLE_WIDTH),
        64 => to_signed(23169, SAMPLE_WIDTH),
        65 => to_signed(23452, SAMPLE_WIDTH),
        66 => to_signed(23731, SAMPLE_WIDTH),
        67 => to_signed(24006, SAMPLE_WIDTH),
        68 => to_signed(24278, SAMPLE_WIDTH),
        69 => to_signed(24546, SAMPLE_WIDTH),
        70 => to_signed(24811, SAMPLE_WIDTH),
        71 => to_signed(25072, SAMPLE_WIDTH),
        72 => to_signed(25329, SAMPLE_WIDTH),
        73 => to_signed(25582, SAMPLE_WIDTH),
        74 => to_signed(25831, SAMPLE_WIDTH),
        75 => to_signed(26077, SAMPLE_WIDTH),
        76 => to_signed(26318, SAMPLE_WIDTH),
        77 => to_signed(26556, SAMPLE_WIDTH),
        78 => to_signed(26789, SAMPLE_WIDTH),
        79 => to_signed(27019, SAMPLE_WIDTH),
        80 => to_signed(27244, SAMPLE_WIDTH),
        81 => to_signed(27466, SAMPLE_WIDTH),
        82 => to_signed(27683, SAMPLE_WIDTH),
        83 => to_signed(27896, SAMPLE_WIDTH),
        84 => to_signed(28105, SAMPLE_WIDTH),
        85 => to_signed(28309, SAMPLE_WIDTH),
        86 => to_signed(28510, SAMPLE_WIDTH),
        87 => to_signed(28706, SAMPLE_WIDTH),
        88 => to_signed(28897, SAMPLE_WIDTH),
        89 => to_signed(29085, SAMPLE_WIDTH),
        90 => to_signed(29268, SAMPLE_WIDTH),
        91 => to_signed(29446, SAMPLE_WIDTH),
        92 => to_signed(29621, SAMPLE_WIDTH),
        93 => to_signed(29790, SAMPLE_WIDTH),
        94 => to_signed(29955, SAMPLE_WIDTH),
        95 => to_signed(30116, SAMPLE_WIDTH),
        96 => to_signed(30272, SAMPLE_WIDTH),
        97 => to_signed(30424, SAMPLE_WIDTH),
        98 => to_signed(30571, SAMPLE_WIDTH),
        99 => to_signed(30713, SAMPLE_WIDTH),
        100 => to_signed(30851, SAMPLE_WIDTH),
        101 => to_signed(30984, SAMPLE_WIDTH),
        102 => to_signed(31113, SAMPLE_WIDTH),
        103 => to_signed(31236, SAMPLE_WIDTH),
        104 => to_signed(31356, SAMPLE_WIDTH),
        105 => to_signed(31470, SAMPLE_WIDTH),
        106 => to_signed(31580, SAMPLE_WIDTH),
        107 => to_signed(31684, SAMPLE_WIDTH),
        108 => to_signed(31785, SAMPLE_WIDTH),
        109 => to_signed(31880, SAMPLE_WIDTH),
        110 => to_signed(31970, SAMPLE_WIDTH),
        111 => to_signed(32056, SAMPLE_WIDTH),
        112 => to_signed(32137, SAMPLE_WIDTH),
        113 => to_signed(32213, SAMPLE_WIDTH),
        114 => to_signed(32284, SAMPLE_WIDTH),
        115 => to_signed(32350, SAMPLE_WIDTH),
        116 => to_signed(32412, SAMPLE_WIDTH),
        117 => to_signed(32468, SAMPLE_WIDTH),
        118 => to_signed(32520, SAMPLE_WIDTH),
        119 => to_signed(32567, SAMPLE_WIDTH),
        120 => to_signed(32609, SAMPLE_WIDTH),
        121 => to_signed(32646, SAMPLE_WIDTH),
        122 => to_signed(32678, SAMPLE_WIDTH),
        123 => to_signed(32705, SAMPLE_WIDTH),
        124 => to_signed(32727, SAMPLE_WIDTH),
        125 => to_signed(32744, SAMPLE_WIDTH),
        126 => to_signed(32757, SAMPLE_WIDTH),
        127 => to_signed(32764, SAMPLE_WIDTH),
        128 => to_signed(32767, SAMPLE_WIDTH),
        129 => to_signed(32764, SAMPLE_WIDTH),
        130 => to_signed(32757, SAMPLE_WIDTH),
        131 => to_signed(32744, SAMPLE_WIDTH),
        132 => to_signed(32727, SAMPLE_WIDTH),
        133 => to_signed(32705, SAMPLE_WIDTH),
        134 => to_signed(32678, SAMPLE_WIDTH),
        135 => to_signed(32646, SAMPLE_WIDTH),
        136 => to_signed(32609, SAMPLE_WIDTH),
        137 => to_signed(32567, SAMPLE_WIDTH),
        138 => to_signed(32520, SAMPLE_WIDTH),
        139 => to_signed(32468, SAMPLE_WIDTH),
        140 => to_signed(32412, SAMPLE_WIDTH),
        141 => to_signed(32350, SAMPLE_WIDTH),
        142 => to_signed(32284, SAMPLE_WIDTH),
        143 => to_signed(32213, SAMPLE_WIDTH),
        144 => to_signed(32137, SAMPLE_WIDTH),
        145 => to_signed(32056, SAMPLE_WIDTH),
        146 => to_signed(31970, SAMPLE_WIDTH),
        147 => to_signed(31880, SAMPLE_WIDTH),
        148 => to_signed(31785, SAMPLE_WIDTH),
        149 => to_signed(31684, SAMPLE_WIDTH),
        150 => to_signed(31580, SAMPLE_WIDTH),
        151 => to_signed(31470, SAMPLE_WIDTH),
        152 => to_signed(31356, SAMPLE_WIDTH),
        153 => to_signed(31236, SAMPLE_WIDTH),
        154 => to_signed(31113, SAMPLE_WIDTH),
        155 => to_signed(30984, SAMPLE_WIDTH),
        156 => to_signed(30851, SAMPLE_WIDTH),
        157 => to_signed(30713, SAMPLE_WIDTH),
        158 => to_signed(30571, SAMPLE_WIDTH),
        159 => to_signed(30424, SAMPLE_WIDTH),
        160 => to_signed(30272, SAMPLE_WIDTH),
        161 => to_signed(30116, SAMPLE_WIDTH),
        162 => to_signed(29955, SAMPLE_WIDTH),
        163 => to_signed(29790, SAMPLE_WIDTH),
        164 => to_signed(29621, SAMPLE_WIDTH),
        165 => to_signed(29446, SAMPLE_WIDTH),
        166 => to_signed(29268, SAMPLE_WIDTH),
        167 => to_signed(29085, SAMPLE_WIDTH),
        168 => to_signed(28897, SAMPLE_WIDTH),
        169 => to_signed(28706, SAMPLE_WIDTH),
        170 => to_signed(28510, SAMPLE_WIDTH),
        171 => to_signed(28309, SAMPLE_WIDTH),
        172 => to_signed(28105, SAMPLE_WIDTH),
        173 => to_signed(27896, SAMPLE_WIDTH),
        174 => to_signed(27683, SAMPLE_WIDTH),
        175 => to_signed(27466, SAMPLE_WIDTH),
        176 => to_signed(27244, SAMPLE_WIDTH),
        177 => to_signed(27019, SAMPLE_WIDTH),
        178 => to_signed(26789, SAMPLE_WIDTH),
        179 => to_signed(26556, SAMPLE_WIDTH),
        180 => to_signed(26318, SAMPLE_WIDTH),
        181 => to_signed(26077, SAMPLE_WIDTH),
        182 => to_signed(25831, SAMPLE_WIDTH),
        183 => to_signed(25582, SAMPLE_WIDTH),
        184 => to_signed(25329, SAMPLE_WIDTH),
        185 => to_signed(25072, SAMPLE_WIDTH),
        186 => to_signed(24811, SAMPLE_WIDTH),
        187 => to_signed(24546, SAMPLE_WIDTH),
        188 => to_signed(24278, SAMPLE_WIDTH),
        189 => to_signed(24006, SAMPLE_WIDTH),
        190 => to_signed(23731, SAMPLE_WIDTH),
        191 => to_signed(23452, SAMPLE_WIDTH),
        192 => to_signed(23169, SAMPLE_WIDTH),
        193 => to_signed(22883, SAMPLE_WIDTH),
        194 => to_signed(22594, SAMPLE_WIDTH),
        195 => to_signed(22301, SAMPLE_WIDTH),
        196 => to_signed(22004, SAMPLE_WIDTH),
        197 => to_signed(21705, SAMPLE_WIDTH),
        198 => to_signed(21402, SAMPLE_WIDTH),
        199 => to_signed(21096, SAMPLE_WIDTH),
        200 => to_signed(20787, SAMPLE_WIDTH),
        201 => to_signed(20474, SAMPLE_WIDTH),
        202 => to_signed(20159, SAMPLE_WIDTH),
        203 => to_signed(19840, SAMPLE_WIDTH),
        204 => to_signed(19519, SAMPLE_WIDTH),
        205 => to_signed(19194, SAMPLE_WIDTH),
        206 => to_signed(18867, SAMPLE_WIDTH),
        207 => to_signed(18537, SAMPLE_WIDTH),
        208 => to_signed(18204, SAMPLE_WIDTH),
        209 => to_signed(17868, SAMPLE_WIDTH),
        210 => to_signed(17530, SAMPLE_WIDTH),
        211 => to_signed(17189, SAMPLE_WIDTH),
        212 => to_signed(16845, SAMPLE_WIDTH),
        213 => to_signed(16499, SAMPLE_WIDTH),
        214 => to_signed(16150, SAMPLE_WIDTH),
        215 => to_signed(15799, SAMPLE_WIDTH),
        216 => to_signed(15446, SAMPLE_WIDTH),
        217 => to_signed(15090, SAMPLE_WIDTH),
        218 => to_signed(14732, SAMPLE_WIDTH),
        219 => to_signed(14372, SAMPLE_WIDTH),
        220 => to_signed(14009, SAMPLE_WIDTH),
        221 => to_signed(13645, SAMPLE_WIDTH),
        222 => to_signed(13278, SAMPLE_WIDTH),
        223 => to_signed(12909, SAMPLE_WIDTH),
        224 => to_signed(12539, SAMPLE_WIDTH),
        225 => to_signed(12166, SAMPLE_WIDTH),
        226 => to_signed(11792, SAMPLE_WIDTH),
        227 => to_signed(11416, SAMPLE_WIDTH),
        228 => to_signed(11038, SAMPLE_WIDTH),
        229 => to_signed(10659, SAMPLE_WIDTH),
        230 => to_signed(10278, SAMPLE_WIDTH),
        231 => to_signed(9895, SAMPLE_WIDTH),
        232 => to_signed(9511, SAMPLE_WIDTH),
        233 => to_signed(9126, SAMPLE_WIDTH),
        234 => to_signed(8739, SAMPLE_WIDTH),
        235 => to_signed(8351, SAMPLE_WIDTH),
        236 => to_signed(7961, SAMPLE_WIDTH),
        237 => to_signed(7571, SAMPLE_WIDTH),
        238 => to_signed(7179, SAMPLE_WIDTH),
        239 => to_signed(6786, SAMPLE_WIDTH),
        240 => to_signed(6392, SAMPLE_WIDTH),
        241 => to_signed(5997, SAMPLE_WIDTH),
        242 => to_signed(5601, SAMPLE_WIDTH),
        243 => to_signed(5205, SAMPLE_WIDTH),
        244 => to_signed(4807, SAMPLE_WIDTH),
        245 => to_signed(4409, SAMPLE_WIDTH),
        246 => to_signed(4011, SAMPLE_WIDTH),
        247 => to_signed(3611, SAMPLE_WIDTH),
        248 => to_signed(3211, SAMPLE_WIDTH),
        249 => to_signed(2811, SAMPLE_WIDTH),
        250 => to_signed(2410, SAMPLE_WIDTH),
        251 => to_signed(2009, SAMPLE_WIDTH),
        252 => to_signed(1607, SAMPLE_WIDTH),
        253 => to_signed(1206, SAMPLE_WIDTH),
        254 => to_signed(804, SAMPLE_WIDTH),
        255 => to_signed(402, SAMPLE_WIDTH),
        256 => to_signed(0, SAMPLE_WIDTH),
        257 => to_signed(-402, SAMPLE_WIDTH),
        258 => to_signed(-804, SAMPLE_WIDTH),
        259 => to_signed(-1206, SAMPLE_WIDTH),
        260 => to_signed(-1607, SAMPLE_WIDTH),
        261 => to_signed(-2009, SAMPLE_WIDTH),
        262 => to_signed(-2410, SAMPLE_WIDTH),
        263 => to_signed(-2811, SAMPLE_WIDTH),
        264 => to_signed(-3211, SAMPLE_WIDTH),
        265 => to_signed(-3611, SAMPLE_WIDTH),
        266 => to_signed(-4011, SAMPLE_WIDTH),
        267 => to_signed(-4409, SAMPLE_WIDTH),
        268 => to_signed(-4807, SAMPLE_WIDTH),
        269 => to_signed(-5205, SAMPLE_WIDTH),
        270 => to_signed(-5601, SAMPLE_WIDTH),
        271 => to_signed(-5997, SAMPLE_WIDTH),
        272 => to_signed(-6392, SAMPLE_WIDTH),
        273 => to_signed(-6786, SAMPLE_WIDTH),
        274 => to_signed(-7179, SAMPLE_WIDTH),
        275 => to_signed(-7571, SAMPLE_WIDTH),
        276 => to_signed(-7961, SAMPLE_WIDTH),
        277 => to_signed(-8351, SAMPLE_WIDTH),
        278 => to_signed(-8739, SAMPLE_WIDTH),
        279 => to_signed(-9126, SAMPLE_WIDTH),
        280 => to_signed(-9511, SAMPLE_WIDTH),
        281 => to_signed(-9895, SAMPLE_WIDTH),
        282 => to_signed(-10278, SAMPLE_WIDTH),
        283 => to_signed(-10659, SAMPLE_WIDTH),
        284 => to_signed(-11038, SAMPLE_WIDTH),
        285 => to_signed(-11416, SAMPLE_WIDTH),
        286 => to_signed(-11792, SAMPLE_WIDTH),
        287 => to_signed(-12166, SAMPLE_WIDTH),
        288 => to_signed(-12539, SAMPLE_WIDTH),
        289 => to_signed(-12909, SAMPLE_WIDTH),
        290 => to_signed(-13278, SAMPLE_WIDTH),
        291 => to_signed(-13645, SAMPLE_WIDTH),
        292 => to_signed(-14009, SAMPLE_WIDTH),
        293 => to_signed(-14372, SAMPLE_WIDTH),
        294 => to_signed(-14732, SAMPLE_WIDTH),
        295 => to_signed(-15090, SAMPLE_WIDTH),
        296 => to_signed(-15446, SAMPLE_WIDTH),
        297 => to_signed(-15799, SAMPLE_WIDTH),
        298 => to_signed(-16150, SAMPLE_WIDTH),
        299 => to_signed(-16499, SAMPLE_WIDTH),
        300 => to_signed(-16845, SAMPLE_WIDTH),
        301 => to_signed(-17189, SAMPLE_WIDTH),
        302 => to_signed(-17530, SAMPLE_WIDTH),
        303 => to_signed(-17868, SAMPLE_WIDTH),
        304 => to_signed(-18204, SAMPLE_WIDTH),
        305 => to_signed(-18537, SAMPLE_WIDTH),
        306 => to_signed(-18867, SAMPLE_WIDTH),
        307 => to_signed(-19194, SAMPLE_WIDTH),
        308 => to_signed(-19519, SAMPLE_WIDTH),
        309 => to_signed(-19840, SAMPLE_WIDTH),
        310 => to_signed(-20159, SAMPLE_WIDTH),
        311 => to_signed(-20474, SAMPLE_WIDTH),
        312 => to_signed(-20787, SAMPLE_WIDTH),
        313 => to_signed(-21096, SAMPLE_WIDTH),
        314 => to_signed(-21402, SAMPLE_WIDTH),
        315 => to_signed(-21705, SAMPLE_WIDTH),
        316 => to_signed(-22004, SAMPLE_WIDTH),
        317 => to_signed(-22301, SAMPLE_WIDTH),
        318 => to_signed(-22594, SAMPLE_WIDTH),
        319 => to_signed(-22883, SAMPLE_WIDTH),
        320 => to_signed(-23169, SAMPLE_WIDTH),
        321 => to_signed(-23452, SAMPLE_WIDTH),
        322 => to_signed(-23731, SAMPLE_WIDTH),
        323 => to_signed(-24006, SAMPLE_WIDTH),
        324 => to_signed(-24278, SAMPLE_WIDTH),
        325 => to_signed(-24546, SAMPLE_WIDTH),
        326 => to_signed(-24811, SAMPLE_WIDTH),
        327 => to_signed(-25072, SAMPLE_WIDTH),
        328 => to_signed(-25329, SAMPLE_WIDTH),
        329 => to_signed(-25582, SAMPLE_WIDTH),
        330 => to_signed(-25831, SAMPLE_WIDTH),
        331 => to_signed(-26077, SAMPLE_WIDTH),
        332 => to_signed(-26318, SAMPLE_WIDTH),
        333 => to_signed(-26556, SAMPLE_WIDTH),
        334 => to_signed(-26789, SAMPLE_WIDTH),
        335 => to_signed(-27019, SAMPLE_WIDTH),
        336 => to_signed(-27244, SAMPLE_WIDTH),
        337 => to_signed(-27466, SAMPLE_WIDTH),
        338 => to_signed(-27683, SAMPLE_WIDTH),
        339 => to_signed(-27896, SAMPLE_WIDTH),
        340 => to_signed(-28105, SAMPLE_WIDTH),
        341 => to_signed(-28309, SAMPLE_WIDTH),
        342 => to_signed(-28510, SAMPLE_WIDTH),
        343 => to_signed(-28706, SAMPLE_WIDTH),
        344 => to_signed(-28897, SAMPLE_WIDTH),
        345 => to_signed(-29085, SAMPLE_WIDTH),
        346 => to_signed(-29268, SAMPLE_WIDTH),
        347 => to_signed(-29446, SAMPLE_WIDTH),
        348 => to_signed(-29621, SAMPLE_WIDTH),
        349 => to_signed(-29790, SAMPLE_WIDTH),
        350 => to_signed(-29955, SAMPLE_WIDTH),
        351 => to_signed(-30116, SAMPLE_WIDTH),
        352 => to_signed(-30272, SAMPLE_WIDTH),
        353 => to_signed(-30424, SAMPLE_WIDTH),
        354 => to_signed(-30571, SAMPLE_WIDTH),
        355 => to_signed(-30713, SAMPLE_WIDTH),
        356 => to_signed(-30851, SAMPLE_WIDTH),
        357 => to_signed(-30984, SAMPLE_WIDTH),
        358 => to_signed(-31113, SAMPLE_WIDTH),
        359 => to_signed(-31236, SAMPLE_WIDTH),
        360 => to_signed(-31356, SAMPLE_WIDTH),
        361 => to_signed(-31470, SAMPLE_WIDTH),
        362 => to_signed(-31580, SAMPLE_WIDTH),
        363 => to_signed(-31684, SAMPLE_WIDTH),
        364 => to_signed(-31785, SAMPLE_WIDTH),
        365 => to_signed(-31880, SAMPLE_WIDTH),
        366 => to_signed(-31970, SAMPLE_WIDTH),
        367 => to_signed(-32056, SAMPLE_WIDTH),
        368 => to_signed(-32137, SAMPLE_WIDTH),
        369 => to_signed(-32213, SAMPLE_WIDTH),
        370 => to_signed(-32284, SAMPLE_WIDTH),
        371 => to_signed(-32350, SAMPLE_WIDTH),
        372 => to_signed(-32412, SAMPLE_WIDTH),
        373 => to_signed(-32468, SAMPLE_WIDTH),
        374 => to_signed(-32520, SAMPLE_WIDTH),
        375 => to_signed(-32567, SAMPLE_WIDTH),
        376 => to_signed(-32609, SAMPLE_WIDTH),
        377 => to_signed(-32646, SAMPLE_WIDTH),
        378 => to_signed(-32678, SAMPLE_WIDTH),
        379 => to_signed(-32705, SAMPLE_WIDTH),
        380 => to_signed(-32727, SAMPLE_WIDTH),
        381 => to_signed(-32744, SAMPLE_WIDTH),
        382 => to_signed(-32757, SAMPLE_WIDTH),
        383 => to_signed(-32764, SAMPLE_WIDTH),
        384 => to_signed(-32767, SAMPLE_WIDTH),
        385 => to_signed(-32764, SAMPLE_WIDTH),
        386 => to_signed(-32757, SAMPLE_WIDTH),
        387 => to_signed(-32744, SAMPLE_WIDTH),
        388 => to_signed(-32727, SAMPLE_WIDTH),
        389 => to_signed(-32705, SAMPLE_WIDTH),
        390 => to_signed(-32678, SAMPLE_WIDTH),
        391 => to_signed(-32646, SAMPLE_WIDTH),
        392 => to_signed(-32609, SAMPLE_WIDTH),
        393 => to_signed(-32567, SAMPLE_WIDTH),
        394 => to_signed(-32520, SAMPLE_WIDTH),
        395 => to_signed(-32468, SAMPLE_WIDTH),
        396 => to_signed(-32412, SAMPLE_WIDTH),
        397 => to_signed(-32350, SAMPLE_WIDTH),
        398 => to_signed(-32284, SAMPLE_WIDTH),
        399 => to_signed(-32213, SAMPLE_WIDTH),
        400 => to_signed(-32137, SAMPLE_WIDTH),
        401 => to_signed(-32056, SAMPLE_WIDTH),
        402 => to_signed(-31970, SAMPLE_WIDTH),
        403 => to_signed(-31880, SAMPLE_WIDTH),
        404 => to_signed(-31785, SAMPLE_WIDTH),
        405 => to_signed(-31684, SAMPLE_WIDTH),
        406 => to_signed(-31580, SAMPLE_WIDTH),
        407 => to_signed(-31470, SAMPLE_WIDTH),
        408 => to_signed(-31356, SAMPLE_WIDTH),
        409 => to_signed(-31236, SAMPLE_WIDTH),
        410 => to_signed(-31113, SAMPLE_WIDTH),
        411 => to_signed(-30984, SAMPLE_WIDTH),
        412 => to_signed(-30851, SAMPLE_WIDTH),
        413 => to_signed(-30713, SAMPLE_WIDTH),
        414 => to_signed(-30571, SAMPLE_WIDTH),
        415 => to_signed(-30424, SAMPLE_WIDTH),
        416 => to_signed(-30272, SAMPLE_WIDTH),
        417 => to_signed(-30116, SAMPLE_WIDTH),
        418 => to_signed(-29955, SAMPLE_WIDTH),
        419 => to_signed(-29790, SAMPLE_WIDTH),
        420 => to_signed(-29621, SAMPLE_WIDTH),
        421 => to_signed(-29446, SAMPLE_WIDTH),
        422 => to_signed(-29268, SAMPLE_WIDTH),
        423 => to_signed(-29085, SAMPLE_WIDTH),
        424 => to_signed(-28897, SAMPLE_WIDTH),
        425 => to_signed(-28706, SAMPLE_WIDTH),
        426 => to_signed(-28510, SAMPLE_WIDTH),
        427 => to_signed(-28309, SAMPLE_WIDTH),
        428 => to_signed(-28105, SAMPLE_WIDTH),
        429 => to_signed(-27896, SAMPLE_WIDTH),
        430 => to_signed(-27683, SAMPLE_WIDTH),
        431 => to_signed(-27466, SAMPLE_WIDTH),
        432 => to_signed(-27244, SAMPLE_WIDTH),
        433 => to_signed(-27019, SAMPLE_WIDTH),
        434 => to_signed(-26789, SAMPLE_WIDTH),
        435 => to_signed(-26556, SAMPLE_WIDTH),
        436 => to_signed(-26318, SAMPLE_WIDTH),
        437 => to_signed(-26077, SAMPLE_WIDTH),
        438 => to_signed(-25831, SAMPLE_WIDTH),
        439 => to_signed(-25582, SAMPLE_WIDTH),
        440 => to_signed(-25329, SAMPLE_WIDTH),
        441 => to_signed(-25072, SAMPLE_WIDTH),
        442 => to_signed(-24811, SAMPLE_WIDTH),
        443 => to_signed(-24546, SAMPLE_WIDTH),
        444 => to_signed(-24278, SAMPLE_WIDTH),
        445 => to_signed(-24006, SAMPLE_WIDTH),
        446 => to_signed(-23731, SAMPLE_WIDTH),
        447 => to_signed(-23452, SAMPLE_WIDTH),
        448 => to_signed(-23169, SAMPLE_WIDTH),
        449 => to_signed(-22883, SAMPLE_WIDTH),
        450 => to_signed(-22594, SAMPLE_WIDTH),
        451 => to_signed(-22301, SAMPLE_WIDTH),
        452 => to_signed(-22004, SAMPLE_WIDTH),
        453 => to_signed(-21705, SAMPLE_WIDTH),
        454 => to_signed(-21402, SAMPLE_WIDTH),
        455 => to_signed(-21096, SAMPLE_WIDTH),
        456 => to_signed(-20787, SAMPLE_WIDTH),
        457 => to_signed(-20474, SAMPLE_WIDTH),
        458 => to_signed(-20159, SAMPLE_WIDTH),
        459 => to_signed(-19840, SAMPLE_WIDTH),
        460 => to_signed(-19519, SAMPLE_WIDTH),
        461 => to_signed(-19194, SAMPLE_WIDTH),
        462 => to_signed(-18867, SAMPLE_WIDTH),
        463 => to_signed(-18537, SAMPLE_WIDTH),
        464 => to_signed(-18204, SAMPLE_WIDTH),
        465 => to_signed(-17868, SAMPLE_WIDTH),
        466 => to_signed(-17530, SAMPLE_WIDTH),
        467 => to_signed(-17189, SAMPLE_WIDTH),
        468 => to_signed(-16845, SAMPLE_WIDTH),
        469 => to_signed(-16499, SAMPLE_WIDTH),
        470 => to_signed(-16150, SAMPLE_WIDTH),
        471 => to_signed(-15799, SAMPLE_WIDTH),
        472 => to_signed(-15446, SAMPLE_WIDTH),
        473 => to_signed(-15090, SAMPLE_WIDTH),
        474 => to_signed(-14732, SAMPLE_WIDTH),
        475 => to_signed(-14372, SAMPLE_WIDTH),
        476 => to_signed(-14009, SAMPLE_WIDTH),
        477 => to_signed(-13645, SAMPLE_WIDTH),
        478 => to_signed(-13278, SAMPLE_WIDTH),
        479 => to_signed(-12909, SAMPLE_WIDTH),
        480 => to_signed(-12539, SAMPLE_WIDTH),
        481 => to_signed(-12166, SAMPLE_WIDTH),
        482 => to_signed(-11792, SAMPLE_WIDTH),
        483 => to_signed(-11416, SAMPLE_WIDTH),
        484 => to_signed(-11038, SAMPLE_WIDTH),
        485 => to_signed(-10659, SAMPLE_WIDTH),
        486 => to_signed(-10278, SAMPLE_WIDTH),
        487 => to_signed(-9895, SAMPLE_WIDTH),
        488 => to_signed(-9511, SAMPLE_WIDTH),
        489 => to_signed(-9126, SAMPLE_WIDTH),
        490 => to_signed(-8739, SAMPLE_WIDTH),
        491 => to_signed(-8351, SAMPLE_WIDTH),
        492 => to_signed(-7961, SAMPLE_WIDTH),
        493 => to_signed(-7571, SAMPLE_WIDTH),
        494 => to_signed(-7179, SAMPLE_WIDTH),
        495 => to_signed(-6786, SAMPLE_WIDTH),
        496 => to_signed(-6392, SAMPLE_WIDTH),
        497 => to_signed(-5997, SAMPLE_WIDTH),
        498 => to_signed(-5601, SAMPLE_WIDTH),
        499 => to_signed(-5205, SAMPLE_WIDTH),
        500 => to_signed(-4807, SAMPLE_WIDTH),
        501 => to_signed(-4409, SAMPLE_WIDTH),
        502 => to_signed(-4011, SAMPLE_WIDTH),
        503 => to_signed(-3611, SAMPLE_WIDTH),
        504 => to_signed(-3211, SAMPLE_WIDTH),
        505 => to_signed(-2811, SAMPLE_WIDTH),
        506 => to_signed(-2410, SAMPLE_WIDTH),
        507 => to_signed(-2009, SAMPLE_WIDTH),
        508 => to_signed(-1607, SAMPLE_WIDTH),
        509 => to_signed(-1206, SAMPLE_WIDTH),
        510 => to_signed(-804, SAMPLE_WIDTH),
        511 => to_signed(-402, SAMPLE_WIDTH)
    );
 
end osc_pkg;
