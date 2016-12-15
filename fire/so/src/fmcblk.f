      BLOCK DATA FMCBLK
      IMPLICIT NONE
C----------
C   **FMCBLK--FIRE-SO  DATE OF LAST REVISION:   08/15/06
C----------
COMMONS
C
      INCLUDE 'PRGPRM.F77'
      INCLUDE 'FMPROP.F77'

      INTEGER J

C     GROUPING FOR THE JENKINS BIOMASS EQUATIONS FOR C REPORTING
C     SOFTWOODS
C       1=CEDAR/LARCH
C       2=DOUGLAS-FIR
C       3=TRUE FIR/HEMLOCK
C       4=PINE
C       5=SPRUCE
C     HARDWOODS
C       6=ASPEN/ALDER/COTTONWOOD/WILLOW
C       7=SOFT MAPLE/BIRCH
C       8=MIXED HARDWOOD
C       9=HARD MAPLE/OAK/HICKORY/BEECH
C      10=WOODLAND JUNIPER/OAK/MESQUITE

      DATA BIOGRP/
     & 4, 4, 2, 3, 3,
     & 1, 4, 5, 3, 4, ! 10
     & 1, 3, 3, 3, 3,
     & 4, 1, 1, 3, 3, ! 20
     & 6, 6, 7, 6, 6,
     & 8, 9, 6, 8,10, ! 30
     &10, 2, 8/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = PWE;sw;all
C SubRegion index I = 1
C  DataType index K = 1 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 1 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 1 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,1,1,1), J= 1,101) /
     & 0.6367,0.6012,0.5694,0.5413,0.5162,0.4937,0.4731,0.4543,0.4366,
     & 0.4202,0.4053,0.3919,0.3800,0.3693,0.3597,0.3508,0.3426,0.3350,
     & 0.3279,0.3211,0.3147,0.3086,0.3029,0.2974,0.2922,0.2871,0.2822,
     & 0.2775,0.2730,0.2686,0.2643,0.2601,0.2561,0.2522,0.2484,0.2447,
     & 0.2411,0.2376,0.2342,0.2309,0.2277,0.2245,0.2214,0.2184,0.2155,
     & 0.2126,0.2098,0.2071,0.2044,0.2018,0.1992,0.1967,0.1943,0.1919,
     & 0.1895,0.1872,0.1849,0.1827,0.1805,0.1784,0.1763,0.1743,0.1722,
     & 0.1703,0.1683,0.1664,0.1645,0.1627,0.1609,0.1591,0.1574,0.1556,
     & 0.1540,0.1523,0.1507,0.1490,0.1475,0.1459,0.1444,0.1428,0.1414,
     & 0.1399,0.1385,0.1370,0.1356,0.1342,0.1329,0.1315,0.1302,0.1289,
     & 0.1276,0.1264,0.1251,0.1239,0.1227,0.1215,0.1203,0.1191,0.1180,
     & 0.1169,0.1157/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = PWE;sw;all
C SubRegion index I = 1
C  DataType index K = 2 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 1 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 1 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,2,1,1), J= 1,101) /
     & 0.0000,0.0161,0.0306,0.0434,0.0548,0.0650,0.0743,0.0826,0.0904,
     & 0.0976,0.1041,0.1098,0.1149,0.1195,0.1237,0.1275,0.1310,0.1342,
     & 0.1372,0.1400,0.1427,0.1452,0.1475,0.1497,0.1519,0.1539,0.1558,
     & 0.1577,0.1595,0.1612,0.1628,0.1644,0.1660,0.1675,0.1689,0.1703,
     & 0.1717,0.1730,0.1743,0.1756,0.1768,0.1780,0.1791,0.1803,0.1814,
     & 0.1825,0.1835,0.1846,0.1856,0.1866,0.1875,0.1885,0.1894,0.1903,
     & 0.1912,0.1921,0.1930,0.1938,0.1947,0.1955,0.1963,0.1971,0.1979,
     & 0.1986,0.1994,0.2002,0.2009,0.2016,0.2023,0.2031,0.2038,0.2044,
     & 0.2051,0.2058,0.2064,0.2071,0.2077,0.2084,0.2090,0.2096,0.2102,
     & 0.2108,0.2114,0.2120,0.2126,0.2132,0.2138,0.2143,0.2149,0.2154,
     & 0.2160,0.2165,0.2170,0.2176,0.2181,0.2186,0.2191,0.2196,0.2201,
     & 0.2206,0.2211/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = PWE;sw;all
C SubRegion index I = 1
C  DataType index K = 3 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 1 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 1 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,3,1,1), J= 1,101) /
     & 0.1969,0.2067,0.2154,0.2232,0.2300,0.2361,0.2416,0.2467,0.2515,
     & 0.2559,0.2599,0.2635,0.2666,0.2693,0.2718,0.2739,0.2759,0.2778,
     & 0.2795,0.2811,0.2826,0.2840,0.2854,0.2866,0.2878,0.2889,0.2900,
     & 0.2910,0.2920,0.2930,0.2939,0.2947,0.2956,0.2964,0.2972,0.2979,
     & 0.2986,0.2993,0.3000,0.3006,0.3012,0.3018,0.3023,0.3029,0.3034,
     & 0.3039,0.3043,0.3048,0.3052,0.3056,0.3060,0.3064,0.3067,0.3071,
     & 0.3074,0.3077,0.3080,0.3083,0.3085,0.3088,0.3090,0.3093,0.3095,
     & 0.3097,0.3099,0.3100,0.3102,0.3104,0.3105,0.3107,0.3108,0.3109,
     & 0.3110,0.3111,0.3112,0.3113,0.3114,0.3114,0.3115,0.3116,0.3116,
     & 0.3116,0.3117,0.3117,0.3117,0.3117,0.3118,0.3118,0.3118,0.3118,
     & 0.3118,0.3118,0.3118,0.3118,0.3118,0.3118,0.3118,0.3118,0.3118,
     & 0.3118,0.3118/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = PWE;sw;all
C SubRegion index I = 1
C  DataType index K = 1 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 2 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 1 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,1,2,1), J= 1,101) /
     & 0.6367,0.6012,0.5694,0.5413,0.5162,0.4937,0.4731,0.4543,0.4366,
     & 0.4202,0.4053,0.3919,0.3800,0.3693,0.3597,0.3508,0.3426,0.3350,
     & 0.3279,0.3211,0.3147,0.3086,0.3029,0.2974,0.2922,0.2871,0.2822,
     & 0.2775,0.2730,0.2686,0.2643,0.2601,0.2561,0.2522,0.2484,0.2447,
     & 0.2411,0.2376,0.2342,0.2309,0.2277,0.2245,0.2214,0.2184,0.2155,
     & 0.2126,0.2098,0.2071,0.2044,0.2018,0.1992,0.1967,0.1943,0.1919,
     & 0.1895,0.1872,0.1849,0.1827,0.1805,0.1784,0.1763,0.1743,0.1722,
     & 0.1703,0.1683,0.1664,0.1645,0.1627,0.1609,0.1591,0.1574,0.1556,
     & 0.1540,0.1523,0.1507,0.1490,0.1475,0.1459,0.1444,0.1428,0.1414,
     & 0.1399,0.1385,0.1370,0.1356,0.1342,0.1329,0.1315,0.1302,0.1289,
     & 0.1276,0.1264,0.1251,0.1239,0.1227,0.1215,0.1203,0.1191,0.1180,
     & 0.1169,0.1157/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = PWE;sw;all
C SubRegion index I = 1
C  DataType index K = 2 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 2 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 1 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,2,2,1), J= 1,101) /
     & 0.0000,0.0161,0.0306,0.0434,0.0548,0.0650,0.0743,0.0826,0.0904,
     & 0.0976,0.1041,0.1098,0.1149,0.1195,0.1237,0.1275,0.1310,0.1342,
     & 0.1372,0.1400,0.1427,0.1452,0.1475,0.1497,0.1519,0.1539,0.1558,
     & 0.1577,0.1595,0.1612,0.1628,0.1644,0.1660,0.1675,0.1689,0.1703,
     & 0.1717,0.1730,0.1743,0.1756,0.1768,0.1780,0.1791,0.1803,0.1814,
     & 0.1825,0.1835,0.1846,0.1856,0.1866,0.1875,0.1885,0.1894,0.1903,
     & 0.1912,0.1921,0.1930,0.1938,0.1947,0.1955,0.1963,0.1971,0.1979,
     & 0.1986,0.1994,0.2002,0.2009,0.2016,0.2023,0.2031,0.2038,0.2044,
     & 0.2051,0.2058,0.2064,0.2071,0.2077,0.2084,0.2090,0.2096,0.2102,
     & 0.2108,0.2114,0.2120,0.2126,0.2132,0.2138,0.2143,0.2149,0.2154,
     & 0.2160,0.2165,0.2170,0.2176,0.2181,0.2186,0.2191,0.2196,0.2201,
     & 0.2206,0.2211/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = PWE;sw;all
C SubRegion index I = 1
C  DataType index K = 3 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 2 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 1 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,3,2,1), J= 1,101) /
     & 0.1969,0.2067,0.2154,0.2232,0.2300,0.2361,0.2416,0.2467,0.2515,
     & 0.2559,0.2599,0.2635,0.2666,0.2693,0.2718,0.2739,0.2759,0.2778,
     & 0.2795,0.2811,0.2826,0.2840,0.2854,0.2866,0.2878,0.2889,0.2900,
     & 0.2910,0.2920,0.2930,0.2939,0.2947,0.2956,0.2964,0.2972,0.2979,
     & 0.2986,0.2993,0.3000,0.3006,0.3012,0.3018,0.3023,0.3029,0.3034,
     & 0.3039,0.3043,0.3048,0.3052,0.3056,0.3060,0.3064,0.3067,0.3071,
     & 0.3074,0.3077,0.3080,0.3083,0.3085,0.3088,0.3090,0.3093,0.3095,
     & 0.3097,0.3099,0.3100,0.3102,0.3104,0.3105,0.3107,0.3108,0.3109,
     & 0.3110,0.3111,0.3112,0.3113,0.3114,0.3114,0.3115,0.3116,0.3116,
     & 0.3116,0.3117,0.3117,0.3117,0.3117,0.3118,0.3118,0.3118,0.3118,
     & 0.3118,0.3118,0.3118,0.3118,0.3118,0.3118,0.3118,0.3118,0.3118,
     & 0.3118,0.3118/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = W;hw;all
C SubRegion index I = 1
C  DataType index K = 1 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 1 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 2 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,1,1,2), J= 1,101) /
     & 0.5676,0.5288,0.4945,0.4639,0.4366,0.4122,0.3897,0.3691,0.3498,
     & 0.3319,0.3156,0.3010,0.2879,0.2762,0.2656,0.2559,0.2470,0.2387,
     & 0.2310,0.2236,0.2167,0.2103,0.2042,0.1984,0.1930,0.1877,0.1827,
     & 0.1779,0.1733,0.1689,0.1646,0.1605,0.1566,0.1528,0.1491,0.1456,
     & 0.1422,0.1390,0.1358,0.1328,0.1298,0.1270,0.1242,0.1215,0.1190,
     & 0.1165,0.1140,0.1117,0.1094,0.1072,0.1051,0.1030,0.1010,0.0991,
     & 0.0972,0.0953,0.0935,0.0918,0.0901,0.0885,0.0869,0.0853,0.0838,
     & 0.0823,0.0809,0.0795,0.0781,0.0768,0.0755,0.0742,0.0730,0.0718,
     & 0.0706,0.0695,0.0683,0.0673,0.0662,0.0651,0.0641,0.0631,0.0621,
     & 0.0612,0.0603,0.0594,0.0585,0.0576,0.0567,0.0559,0.0551,0.0543,
     & 0.0535,0.0527,0.0520,0.0512,0.0505,0.0498,0.0491,0.0484,0.0478,
     & 0.0471,0.0465/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = W;hw;all
C SubRegion index I = 1
C  DataType index K = 2 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 1 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 2 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,2,1,2), J= 1,101) /
     & 0.0000,0.0181,0.0342,0.0484,0.0612,0.0726,0.0830,0.0924,0.1011,
     & 0.1091,0.1163,0.1228,0.1285,0.1337,0.1383,0.1425,0.1464,0.1499,
     & 0.1532,0.1563,0.1591,0.1617,0.1642,0.1665,0.1687,0.1707,0.1726,
     & 0.1745,0.1762,0.1778,0.1794,0.1809,0.1823,0.1836,0.1849,0.1861,
     & 0.1873,0.1884,0.1895,0.1905,0.1915,0.1925,0.1934,0.1943,0.1951,
     & 0.1959,0.1967,0.1975,0.1982,0.1989,0.1996,0.2002,0.2009,0.2015,
     & 0.2021,0.2027,0.2033,0.2038,0.2043,0.2049,0.2054,0.2059,0.2063,
     & 0.2068,0.2073,0.2077,0.2082,0.2086,0.2090,0.2094,0.2098,0.2102,
     & 0.2106,0.2110,0.2113,0.2117,0.2120,0.2124,0.2127,0.2131,0.2134,
     & 0.2137,0.2140,0.2144,0.2147,0.2150,0.2153,0.2155,0.2158,0.2161,
     & 0.2164,0.2167,0.2169,0.2172,0.2174,0.2177,0.2180,0.2182,0.2184,
     & 0.2187,0.2189/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = W;hw;all
C SubRegion index I = 1
C  DataType index K = 3 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 1 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 2 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,3,1,2), J= 1,101) /
     & 0.2559,0.2668,0.2768,0.2858,0.2938,0.3009,0.3075,0.3135,0.3193,
     & 0.3246,0.3295,0.3338,0.3377,0.3411,0.3442,0.3470,0.3495,0.3519,
     & 0.3541,0.3563,0.3583,0.3601,0.3619,0.3636,0.3651,0.3667,0.3681,
     & 0.3695,0.3709,0.3721,0.3734,0.3746,0.3757,0.3768,0.3779,0.3789,
     & 0.3799,0.3808,0.3817,0.3826,0.3834,0.3842,0.3850,0.3858,0.3865,
     & 0.3872,0.3878,0.3885,0.3891,0.3897,0.3902,0.3908,0.3913,0.3918,
     & 0.3923,0.3927,0.3932,0.3936,0.3940,0.3944,0.3948,0.3951,0.3955,
     & 0.3958,0.3961,0.3964,0.3967,0.3970,0.3972,0.3975,0.3977,0.3980,
     & 0.3982,0.3984,0.3986,0.3988,0.3990,0.3991,0.3993,0.3994,0.3996,
     & 0.3997,0.3998,0.4000,0.4001,0.4002,0.4003,0.4004,0.4005,0.4005,
     & 0.4006,0.4007,0.4008,0.4008,0.4009,0.4009,0.4010,0.4010,0.4010,
     & 0.4011,0.4011/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = W;hw;all
C SubRegion index I = 1
C  DataType index K = 1 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 2 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 2 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,1,2,2), J= 1,101) /
     & 0.5676,0.5288,0.4945,0.4639,0.4366,0.4122,0.3897,0.3691,0.3498,
     & 0.3319,0.3156,0.3010,0.2879,0.2762,0.2656,0.2559,0.2470,0.2387,
     & 0.2310,0.2236,0.2167,0.2103,0.2042,0.1984,0.1930,0.1877,0.1827,
     & 0.1779,0.1733,0.1689,0.1646,0.1605,0.1566,0.1528,0.1491,0.1456,
     & 0.1422,0.1390,0.1358,0.1328,0.1298,0.1270,0.1242,0.1215,0.1190,
     & 0.1165,0.1140,0.1117,0.1094,0.1072,0.1051,0.1030,0.1010,0.0991,
     & 0.0972,0.0953,0.0935,0.0918,0.0901,0.0885,0.0869,0.0853,0.0838,
     & 0.0823,0.0809,0.0795,0.0781,0.0768,0.0755,0.0742,0.0730,0.0718,
     & 0.0706,0.0695,0.0683,0.0673,0.0662,0.0651,0.0641,0.0631,0.0621,
     & 0.0612,0.0603,0.0594,0.0585,0.0576,0.0567,0.0559,0.0551,0.0543,
     & 0.0535,0.0527,0.0520,0.0512,0.0505,0.0498,0.0491,0.0484,0.0478,
     & 0.0471,0.0465/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = W;hw;all
C SubRegion index I = 1
C  DataType index K = 2 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 2 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 2 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,2,2,2), J= 1,101) /
     & 0.0000,0.0181,0.0342,0.0484,0.0612,0.0726,0.0830,0.0924,0.1011,
     & 0.1091,0.1163,0.1228,0.1285,0.1337,0.1383,0.1425,0.1464,0.1499,
     & 0.1532,0.1563,0.1591,0.1617,0.1642,0.1665,0.1687,0.1707,0.1726,
     & 0.1745,0.1762,0.1778,0.1794,0.1809,0.1823,0.1836,0.1849,0.1861,
     & 0.1873,0.1884,0.1895,0.1905,0.1915,0.1925,0.1934,0.1943,0.1951,
     & 0.1959,0.1967,0.1975,0.1982,0.1989,0.1996,0.2002,0.2009,0.2015,
     & 0.2021,0.2027,0.2033,0.2038,0.2043,0.2049,0.2054,0.2059,0.2063,
     & 0.2068,0.2073,0.2077,0.2082,0.2086,0.2090,0.2094,0.2098,0.2102,
     & 0.2106,0.2110,0.2113,0.2117,0.2120,0.2124,0.2127,0.2131,0.2134,
     & 0.2137,0.2140,0.2144,0.2147,0.2150,0.2153,0.2155,0.2158,0.2161,
     & 0.2164,0.2167,0.2169,0.2172,0.2174,0.2177,0.2180,0.2182,0.2184,
     & 0.2187,0.2189/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = W;hw;all
C SubRegion index I = 1
C  DataType index K = 3 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 2 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 2 (1=Soft;  2=Hard)

      DATA (FAPROP(1,J,3,2,2), J= 1,101) /
     & 0.2559,0.2668,0.2768,0.2858,0.2938,0.3009,0.3075,0.3135,0.3193,
     & 0.3246,0.3295,0.3338,0.3377,0.3411,0.3442,0.3470,0.3495,0.3519,
     & 0.3541,0.3563,0.3583,0.3601,0.3619,0.3636,0.3651,0.3667,0.3681,
     & 0.3695,0.3709,0.3721,0.3734,0.3746,0.3757,0.3768,0.3779,0.3789,
     & 0.3799,0.3808,0.3817,0.3826,0.3834,0.3842,0.3850,0.3858,0.3865,
     & 0.3872,0.3878,0.3885,0.3891,0.3897,0.3902,0.3908,0.3913,0.3918,
     & 0.3923,0.3927,0.3932,0.3936,0.3940,0.3944,0.3948,0.3951,0.3955,
     & 0.3958,0.3961,0.3964,0.3967,0.3970,0.3972,0.3975,0.3977,0.3980,
     & 0.3982,0.3984,0.3986,0.3988,0.3990,0.3991,0.3993,0.3994,0.3996,
     & 0.3997,0.3998,0.4000,0.4001,0.4002,0.4003,0.4004,0.4005,0.4005,
     & 0.4006,0.4007,0.4008,0.4008,0.4009,0.4009,0.4010,0.4010,0.4010,
     & 0.4011,0.4011/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = PSW;sw;all
C SubRegion index I = 2
C  DataType index K = 1 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 1 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 1 (1=Soft;  2=Hard)

      DATA (FAPROP(2,J,1,1,1), J= 1,101) /
     & 0.6745,0.6365,0.6024,0.5721,0.5449,0.5205,0.4981,0.4776,0.4582,
     & 0.4402,0.4238,0.4091,0.3959,0.3840,0.3732,0.3633,0.3541,0.3455,
     & 0.3375,0.3298,0.3226,0.3158,0.3093,0.3032,0.2973,0.2916,0.2862,
     & 0.2810,0.2759,0.2710,0.2663,0.2617,0.2573,0.2531,0.2489,0.2449,
     & 0.2410,0.2372,0.2335,0.2300,0.2265,0.2231,0.2198,0.2166,0.2135,
     & 0.2104,0.2075,0.2046,0.2018,0.1990,0.1963,0.1937,0.1912,0.1887,
     & 0.1862,0.1838,0.1815,0.1792,0.1769,0.1747,0.1726,0.1705,0.1684,
     & 0.1664,0.1644,0.1625,0.1606,0.1587,0.1569,0.1551,0.1533,0.1515,
     & 0.1498,0.1482,0.1465,0.1449,0.1433,0.1417,0.1402,0.1387,0.1372,
     & 0.1357,0.1343,0.1329,0.1315,0.1301,0.1288,0.1274,0.1261,0.1248,
     & 0.1235,0.1223,0.1211,0.1198,0.1186,0.1175,0.1163,0.1151,0.1140,
     & 0.1129,0.1118/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = PSW;sw;all
C SubRegion index I = 2
C  DataType index K = 2 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 1 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 1 (1=Soft;  2=Hard)

      DATA (FAPROP(2,J,2,1,1), J= 1,101) /
     & 0.0000,0.0177,0.0337,0.0479,0.0606,0.0720,0.0824,0.0919,0.1007,
     & 0.1087,0.1160,0.1226,0.1285,0.1338,0.1386,0.1430,0.1470,0.1507,
     & 0.1542,0.1575,0.1605,0.1634,0.1661,0.1686,0.1710,0.1733,0.1755,
     & 0.1776,0.1796,0.1816,0.1834,0.1852,0.1869,0.1885,0.1901,0.1916,
     & 0.1931,0.1945,0.1959,0.1972,0.1985,0.1997,0.2010,0.2021,0.2033,
     & 0.2044,0.2055,0.2066,0.2076,0.2086,0.2096,0.2106,0.2115,0.2124,
     & 0.2133,0.2142,0.2151,0.2160,0.2168,0.2176,0.2184,0.2192,0.2200,
     & 0.2207,0.2215,0.2222,0.2230,0.2237,0.2244,0.2251,0.2258,0.2264,
     & 0.2271,0.2277,0.2284,0.2290,0.2296,0.2303,0.2309,0.2315,0.2321,
     & 0.2327,0.2332,0.2338,0.2344,0.2349,0.2355,0.2360,0.2366,0.2371,
     & 0.2376,0.2382,0.2387,0.2392,0.2397,0.2402,0.2407,0.2411,0.2416,
     & 0.2421,0.2426/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = PSW;sw;all
C SubRegion index I = 2
C  DataType index K = 3 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 1 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 1 (1=Soft;  2=Hard)

      DATA (FAPROP(2,J,3,1,1), J= 1,101) /
     & 0.1698,0.1798,0.1888,0.1967,0.2038,0.2101,0.2159,0.2212,0.2263,
     & 0.2310,0.2352,0.2390,0.2424,0.2453,0.2480,0.2505,0.2527,0.2548,
     & 0.2567,0.2586,0.2603,0.2619,0.2634,0.2649,0.2663,0.2676,0.2688,
     & 0.2701,0.2712,0.2723,0.2734,0.2744,0.2754,0.2764,0.2773,0.2782,
     & 0.2790,0.2798,0.2806,0.2814,0.2821,0.2828,0.2835,0.2841,0.2847,
     & 0.2853,0.2859,0.2864,0.2869,0.2874,0.2879,0.2884,0.2888,0.2893,
     & 0.2897,0.2900,0.2904,0.2908,0.2911,0.2914,0.2918,0.2921,0.2923,
     & 0.2926,0.2929,0.2931,0.2933,0.2936,0.2938,0.2940,0.2942,0.2943,
     & 0.2945,0.2947,0.2948,0.2950,0.2951,0.2952,0.2953,0.2954,0.2955,
     & 0.2956,0.2957,0.2958,0.2959,0.2959,0.2960,0.2960,0.2961,0.2961,
     & 0.2962,0.2962,0.2962,0.2962,0.2962,0.2962,0.2962,0.2962,0.2962,
     & 0.2962,0.2962/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = PSW;sw;all
C SubRegion index I = 2
C  DataType index K = 1 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 2 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 1 (1=Soft;  2=Hard)

      DATA (FAPROP(2,J,1,2,1), J= 1,101) /
     & 0.6745,0.6365,0.6024,0.5721,0.5449,0.5205,0.4981,0.4776,0.4582,
     & 0.4402,0.4238,0.4091,0.3959,0.3840,0.3732,0.3633,0.3541,0.3455,
     & 0.3375,0.3298,0.3226,0.3158,0.3093,0.3032,0.2973,0.2916,0.2862,
     & 0.2810,0.2759,0.2710,0.2663,0.2617,0.2573,0.2531,0.2489,0.2449,
     & 0.2410,0.2372,0.2335,0.2300,0.2265,0.2231,0.2198,0.2166,0.2135,
     & 0.2104,0.2075,0.2046,0.2018,0.1990,0.1963,0.1937,0.1912,0.1887,
     & 0.1862,0.1838,0.1815,0.1792,0.1769,0.1747,0.1726,0.1705,0.1684,
     & 0.1664,0.1644,0.1625,0.1606,0.1587,0.1569,0.1551,0.1533,0.1515,
     & 0.1498,0.1482,0.1465,0.1449,0.1433,0.1417,0.1402,0.1387,0.1372,
     & 0.1357,0.1343,0.1329,0.1315,0.1301,0.1288,0.1274,0.1261,0.1248,
     & 0.1235,0.1223,0.1211,0.1198,0.1186,0.1175,0.1163,0.1151,0.1140,
     & 0.1129,0.1118/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = PSW;sw;all
C SubRegion index I = 2
C  DataType index K = 2 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 2 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 1 (1=Soft;  2=Hard)

      DATA (FAPROP(2,J,2,2,1), J= 1,101) /
     & 0.0000,0.0177,0.0337,0.0479,0.0606,0.0720,0.0824,0.0919,0.1007,
     & 0.1087,0.1160,0.1226,0.1285,0.1338,0.1386,0.1430,0.1470,0.1507,
     & 0.1542,0.1575,0.1605,0.1634,0.1661,0.1686,0.1710,0.1733,0.1755,
     & 0.1776,0.1796,0.1816,0.1834,0.1852,0.1869,0.1885,0.1901,0.1916,
     & 0.1931,0.1945,0.1959,0.1972,0.1985,0.1997,0.2010,0.2021,0.2033,
     & 0.2044,0.2055,0.2066,0.2076,0.2086,0.2096,0.2106,0.2115,0.2124,
     & 0.2133,0.2142,0.2151,0.2160,0.2168,0.2176,0.2184,0.2192,0.2200,
     & 0.2207,0.2215,0.2222,0.2230,0.2237,0.2244,0.2251,0.2258,0.2264,
     & 0.2271,0.2277,0.2284,0.2290,0.2296,0.2303,0.2309,0.2315,0.2321,
     & 0.2327,0.2332,0.2338,0.2344,0.2349,0.2355,0.2360,0.2366,0.2371,
     & 0.2376,0.2382,0.2387,0.2392,0.2397,0.2402,0.2407,0.2411,0.2416,
     & 0.2421,0.2426/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = PSW;sw;all
C SubRegion index I = 2
C  DataType index K = 3 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 2 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 1 (1=Soft;  2=Hard)

      DATA (FAPROP(2,J,3,2,1), J= 1,101) /
     & 0.1698,0.1798,0.1888,0.1967,0.2038,0.2101,0.2159,0.2212,0.2263,
     & 0.2310,0.2352,0.2390,0.2424,0.2453,0.2480,0.2505,0.2527,0.2548,
     & 0.2567,0.2586,0.2603,0.2619,0.2634,0.2649,0.2663,0.2676,0.2688,
     & 0.2701,0.2712,0.2723,0.2734,0.2744,0.2754,0.2764,0.2773,0.2782,
     & 0.2790,0.2798,0.2806,0.2814,0.2821,0.2828,0.2835,0.2841,0.2847,
     & 0.2853,0.2859,0.2864,0.2869,0.2874,0.2879,0.2884,0.2888,0.2893,
     & 0.2897,0.2900,0.2904,0.2908,0.2911,0.2914,0.2918,0.2921,0.2923,
     & 0.2926,0.2929,0.2931,0.2933,0.2936,0.2938,0.2940,0.2942,0.2943,
     & 0.2945,0.2947,0.2948,0.2950,0.2951,0.2952,0.2953,0.2954,0.2955,
     & 0.2956,0.2957,0.2958,0.2959,0.2959,0.2960,0.2960,0.2961,0.2961,
     & 0.2962,0.2962,0.2962,0.2962,0.2962,0.2962,0.2962,0.2962,0.2962,
     & 0.2962,0.2962/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = W;hw;all
C SubRegion index I = 2
C  DataType index K = 1 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 1 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 2 (1=Soft;  2=Hard)

      DATA (FAPROP(2,J,1,1,2), J= 1,101) /
     & 0.5676,0.5288,0.4945,0.4639,0.4366,0.4122,0.3897,0.3691,0.3498,
     & 0.3319,0.3156,0.3010,0.2879,0.2762,0.2656,0.2559,0.2470,0.2387,
     & 0.2310,0.2236,0.2167,0.2103,0.2042,0.1984,0.1930,0.1877,0.1827,
     & 0.1779,0.1733,0.1689,0.1646,0.1605,0.1566,0.1528,0.1491,0.1456,
     & 0.1422,0.1390,0.1358,0.1328,0.1298,0.1270,0.1242,0.1215,0.1190,
     & 0.1165,0.1140,0.1117,0.1094,0.1072,0.1051,0.1030,0.1010,0.0991,
     & 0.0972,0.0953,0.0935,0.0918,0.0901,0.0885,0.0869,0.0853,0.0838,
     & 0.0823,0.0809,0.0795,0.0781,0.0768,0.0755,0.0742,0.0730,0.0718,
     & 0.0706,0.0695,0.0683,0.0673,0.0662,0.0651,0.0641,0.0631,0.0621,
     & 0.0612,0.0603,0.0594,0.0585,0.0576,0.0567,0.0559,0.0551,0.0543,
     & 0.0535,0.0527,0.0520,0.0512,0.0505,0.0498,0.0491,0.0484,0.0478,
     & 0.0471,0.0465/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = W;hw;all
C SubRegion index I = 2
C  DataType index K = 2 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 1 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 2 (1=Soft;  2=Hard)

      DATA (FAPROP(2,J,2,1,2), J= 1,101) /
     & 0.0000,0.0181,0.0342,0.0484,0.0612,0.0726,0.0830,0.0924,0.1011,
     & 0.1091,0.1163,0.1228,0.1285,0.1337,0.1383,0.1425,0.1464,0.1499,
     & 0.1532,0.1563,0.1591,0.1617,0.1642,0.1665,0.1687,0.1707,0.1726,
     & 0.1745,0.1762,0.1778,0.1794,0.1809,0.1823,0.1836,0.1849,0.1861,
     & 0.1873,0.1884,0.1895,0.1905,0.1915,0.1925,0.1934,0.1943,0.1951,
     & 0.1959,0.1967,0.1975,0.1982,0.1989,0.1996,0.2002,0.2009,0.2015,
     & 0.2021,0.2027,0.2033,0.2038,0.2043,0.2049,0.2054,0.2059,0.2063,
     & 0.2068,0.2073,0.2077,0.2082,0.2086,0.2090,0.2094,0.2098,0.2102,
     & 0.2106,0.2110,0.2113,0.2117,0.2120,0.2124,0.2127,0.2131,0.2134,
     & 0.2137,0.2140,0.2144,0.2147,0.2150,0.2153,0.2155,0.2158,0.2161,
     & 0.2164,0.2167,0.2169,0.2172,0.2174,0.2177,0.2180,0.2182,0.2184,
     & 0.2187,0.2189/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = W;hw;all
C SubRegion index I = 2
C  DataType index K = 3 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 1 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 2 (1=Soft;  2=Hard)

      DATA (FAPROP(2,J,3,1,2), J= 1,101) /
     & 0.2559,0.2668,0.2768,0.2858,0.2938,0.3009,0.3075,0.3135,0.3193,
     & 0.3246,0.3295,0.3338,0.3377,0.3411,0.3442,0.3470,0.3495,0.3519,
     & 0.3541,0.3563,0.3583,0.3601,0.3619,0.3636,0.3651,0.3667,0.3681,
     & 0.3695,0.3709,0.3721,0.3734,0.3746,0.3757,0.3768,0.3779,0.3789,
     & 0.3799,0.3808,0.3817,0.3826,0.3834,0.3842,0.3850,0.3858,0.3865,
     & 0.3872,0.3878,0.3885,0.3891,0.3897,0.3902,0.3908,0.3913,0.3918,
     & 0.3923,0.3927,0.3932,0.3936,0.3940,0.3944,0.3948,0.3951,0.3955,
     & 0.3958,0.3961,0.3964,0.3967,0.3970,0.3972,0.3975,0.3977,0.3980,
     & 0.3982,0.3984,0.3986,0.3988,0.3990,0.3991,0.3993,0.3994,0.3996,
     & 0.3997,0.3998,0.4000,0.4001,0.4002,0.4003,0.4004,0.4005,0.4005,
     & 0.4006,0.4007,0.4008,0.4008,0.4009,0.4009,0.4010,0.4010,0.4010,
     & 0.4011,0.4011/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = W;hw;all
C SubRegion index I = 2
C  DataType index K = 1 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 2 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 2 (1=Soft;  2=Hard)

      DATA (FAPROP(2,J,1,2,2), J= 1,101) /
     & 0.5676,0.5288,0.4945,0.4639,0.4366,0.4122,0.3897,0.3691,0.3498,
     & 0.3319,0.3156,0.3010,0.2879,0.2762,0.2656,0.2559,0.2470,0.2387,
     & 0.2310,0.2236,0.2167,0.2103,0.2042,0.1984,0.1930,0.1877,0.1827,
     & 0.1779,0.1733,0.1689,0.1646,0.1605,0.1566,0.1528,0.1491,0.1456,
     & 0.1422,0.1390,0.1358,0.1328,0.1298,0.1270,0.1242,0.1215,0.1190,
     & 0.1165,0.1140,0.1117,0.1094,0.1072,0.1051,0.1030,0.1010,0.0991,
     & 0.0972,0.0953,0.0935,0.0918,0.0901,0.0885,0.0869,0.0853,0.0838,
     & 0.0823,0.0809,0.0795,0.0781,0.0768,0.0755,0.0742,0.0730,0.0718,
     & 0.0706,0.0695,0.0683,0.0673,0.0662,0.0651,0.0641,0.0631,0.0621,
     & 0.0612,0.0603,0.0594,0.0585,0.0576,0.0567,0.0559,0.0551,0.0543,
     & 0.0535,0.0527,0.0520,0.0512,0.0505,0.0498,0.0491,0.0484,0.0478,
     & 0.0471,0.0465/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = W;hw;all
C SubRegion index I = 2
C  DataType index K = 2 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 2 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 2 (1=Soft;  2=Hard)

      DATA (FAPROP(2,J,2,2,2), J= 1,101) /
     & 0.0000,0.0181,0.0342,0.0484,0.0612,0.0726,0.0830,0.0924,0.1011,
     & 0.1091,0.1163,0.1228,0.1285,0.1337,0.1383,0.1425,0.1464,0.1499,
     & 0.1532,0.1563,0.1591,0.1617,0.1642,0.1665,0.1687,0.1707,0.1726,
     & 0.1745,0.1762,0.1778,0.1794,0.1809,0.1823,0.1836,0.1849,0.1861,
     & 0.1873,0.1884,0.1895,0.1905,0.1915,0.1925,0.1934,0.1943,0.1951,
     & 0.1959,0.1967,0.1975,0.1982,0.1989,0.1996,0.2002,0.2009,0.2015,
     & 0.2021,0.2027,0.2033,0.2038,0.2043,0.2049,0.2054,0.2059,0.2063,
     & 0.2068,0.2073,0.2077,0.2082,0.2086,0.2090,0.2094,0.2098,0.2102,
     & 0.2106,0.2110,0.2113,0.2117,0.2120,0.2124,0.2127,0.2131,0.2134,
     & 0.2137,0.2140,0.2144,0.2147,0.2150,0.2153,0.2155,0.2158,0.2161,
     & 0.2164,0.2167,0.2169,0.2172,0.2174,0.2177,0.2180,0.2182,0.2184,
     & 0.2187,0.2189/

C DATA Statement Debug Information
C         Variant   = SO
C        Interval   = 1 yrs
C      Field tags   = W;hw;all
C SubRegion index I = 2
C  DataType index K = 3 (1=InUse; 2=Landfill; 3=Energy)
C  Pulp/Saw index M = 2 (1=Pulp;  2=Saw)
C     Sw/Hw index N = 2 (1=Soft;  2=Hard)

      DATA (FAPROP(2,J,3,2,2), J= 1,101) /
     & 0.2559,0.2668,0.2768,0.2858,0.2938,0.3009,0.3075,0.3135,0.3193,
     & 0.3246,0.3295,0.3338,0.3377,0.3411,0.3442,0.3470,0.3495,0.3519,
     & 0.3541,0.3563,0.3583,0.3601,0.3619,0.3636,0.3651,0.3667,0.3681,
     & 0.3695,0.3709,0.3721,0.3734,0.3746,0.3757,0.3768,0.3779,0.3789,
     & 0.3799,0.3808,0.3817,0.3826,0.3834,0.3842,0.3850,0.3858,0.3865,
     & 0.3872,0.3878,0.3885,0.3891,0.3897,0.3902,0.3908,0.3913,0.3918,
     & 0.3923,0.3927,0.3932,0.3936,0.3940,0.3944,0.3948,0.3951,0.3955,
     & 0.3958,0.3961,0.3964,0.3967,0.3970,0.3972,0.3975,0.3977,0.3980,
     & 0.3982,0.3984,0.3986,0.3988,0.3990,0.3991,0.3993,0.3994,0.3996,
     & 0.3997,0.3998,0.4000,0.4001,0.4002,0.4003,0.4004,0.4005,0.4005,
     & 0.4006,0.4007,0.4008,0.4008,0.4009,0.4009,0.4010,0.4010,0.4010,
     & 0.4011,0.4011/

      END
