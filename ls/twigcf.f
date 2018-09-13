      SUBROUTINE TWIGCF(ISPC,H,D,VN,VM,I)
      IMPLICIT NONE
C----------
C LS $Id$
C----------
C THIS ROUTINE CALCULATES TOTAL CUBIC FOOT VOLUME AND MERCH
C CUBIC FOOT VOLUME FOR A TREE.  CORRECTIONS FOR TOP KILL AND
C DEFECT ARE STILL CALCULATED IN VOLS.
C------------------------------------------------------------------
C  LAKE STATES ACCEPTABLE TREE CLASS VOLUME EQUATION:
C  --RAILE, GERHARD K., W.B. SMITH, C.A.WEIST. 1982. A NET VOLUME
C    EQUATION FOR MICHIGAN'S UPPER AND LOWER PENINSULAS. 12 P.
C    USDA FOREST SERVICE GEN TECH REPORT NC-80.
C
C         V = A*SI**B*[1-EXP(-C*DBH)]**D
C
C  WHERE:
C      V = VOLUME
C     SI = SITE INDEX
C    DBH = DIAMETER BREAST HEIGHT
C    A-D = SPECIES SPECIFIC COEFFICIENTS
C
C  UNDESIRABLE TREE VOLUME IS CALCULATED WITH THE SAME EQUATION BUT
C  VOLUME IS REDUCED BY A REDUCTION FACTOR.
C----------
COMMONS
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'VOLSTD.F77'
C
C
COMMONS
C----------
C  DIMENSION STATEMENT FOR INTERNAL ARRAYS.
C----------
      REAL B1(MAXSP),B2(MAXSP),B3(MAXSP),B4(MAXSP),
     & A1(MAXSP),A2(MAXSP),A3(MAXSP),A4(MAXSP),C1(MAXSP)
      INTEGER I,ISPC
      REAL VM,VN,D,H
      REAL RDANUW
C----------
C  COEFFICIENTS FOR NET CUBIC FOOT VOLUME FOR ACCEPTABLE TREES
C  (TREE CLASS 1 & 2)
C----------
      DATA A1/
     &  2*43.247485,2*208.32365,7116253.8,2*794.19003,5907203.2,
     &  23975164.,
     &  43.505403,829653.86,7702181.2,2*43.247485,2*26920.19,7257392.8,
     &  3*84.104919,3*139.7892,4117941.8,220.79399,3*500.41063,26920.19,
     &  7*226.02403,3*14.440272,3*157.68489,7256.1098,
     &  25*14.440272/
      DATA A2/
     &  2*.24941515,2*.10151272,.24602412,2*.086980381,.21263512,
     &  .1483895,
     &  .000000,.05521671,.30586654,2*.24941515,2*.14046086,1.0162752,
     &  3*.13854827,3*.43870753,.29139894,.12195831,3*.0074206334,
     &  .14046086,7*.060183087,3*.33868853,3*.21360547,.1099344,
     &  25*.33868853/
      DATA A3/
     &  2*.063376007,2*.043477233,.00051614952,2*.024685442,
     &  .00055610656,
     &  .00035627913,.16016055,.0006650422,.00027449826,2*.063376007,
     &  2*.0031300326,.0001747494,3*.057639827,3*.019136939,
     &  .00021053854,
     &  .035924765,3*.028252482,.0031300326,7*.040777352,3*.11816693,
     &  3*.031542612,.0036265833,25*.11816693/
      DATA A4/
     &  2*3.3981105,2*3.2804598,2.7798709,2*3.0336154,2.7160711,
     &  2.6940649,
     &  5.6227874,2.339424,2.5641204,2*3.3981105,2*2.4281485,2.8369659,
     &  3*3.1838326,3*2.5388324,2.3009231,2.9439603,3*2.7577068,
     &  2.4281485,
     &  7*3.0682442,3*4.4887831,3*2.7168275,2.0925534,
     &  25*4.4887831/
C----------
C  COEFFICIENTS TO CALCULATE NET MERCHANTABLE CUBIC FOOT VOLUME
C  FOR ACCEPTABLE TREES (TREE CLASS 1 & 2)
C----------
      DATA B1/
     &  2*8.9466691,2*172.73418,27973496.,2*764.85471,349.63623,
     &  13205354.,
     &  11.845142,329.29724,13741.625,2*8.9466691,2*2361292.2,9227411.1,
     &  3*34.254409,3*315785.92,232.73999,32.535858,3*115.72444,
     &  2361292.2,
     &  7*92.097232,3*2361292.2,4*35.518497,25*115.72444/
      DATA B2/
     &  2*.53395855,2*.13296097,.15544995,2*.026436619,.39521623,
     &  .028683905,
     &  .22306358,.045490132,.093237867,2*.53395855,2*.081937656,
     &  .62754931,
     &  3*.18167758,3*.63848181,.18111402,.23507649,3*.0,.081937656,
     &  7*.000,3*.081937656,4*.25512529,25*.000/
      DATA B3/
     &  2*.085485402,2*.041905919,.00034307498,2*.027726162,
     &  .024435399,.0008993865,.29331203,.031842406,.0050556151,
     &  2*.085485402,2*.00048471246,.00017030448,3*.14024847,
     &  3*.000099734065,
     &  .02859564,.13247401,3*.097135794,.00048471246,7*.11297551,
     &  3*.00048471246,4*.089551607,25*.097135794/
      DATA B4/
     &  2*4.2155052,2*3.1660669,2.7757982,2*3.1681185,3.5026299,
     &  3.0467575,20.22362,3.1317028,2.6433358,2*4.2155052,2*2.3999128,
     &  2.6055323,3*8.5515876,3*1.8863520,2.9713878,8.2301993,
     &  3*5.752438,2.3999128,7*6.7209282,3*2.3999128,4*4.7270033,
     &  25*5.7524381/
C----------
C  NET CUBIC FOOT REDUCTION FACTOR FOR ACCEPTABLE TREES (TREE CLASS 2).
C----------
      DATA C1/
     &  2*.822,2*.888,.834,2*.883,.889,.879,.832,.828,.751,2*.780,
     &  2*.798,.803,.832,2*.832,3*.868,.803,.860,3*.823,.822,4*.860,
     & .856,2*.893,3*.848,.793,2*.782,.857,5*.790,20*.832/
C----------
C  DUMMY ARGUMENT NOT USED WARNING SUPPRESSION SECTION
C----------
      RDANUW = H
C----------
C  CALCULATE NET CUBIC FOOT VOLUME (VN)
C----------
       VN = A1(ISPC)*SITEAR(ISPC)**A2(ISPC)*(1-EXP(-1.0*A3(ISPC)
     &           *D))**A4(ISPC)
C----------
C  REDUCE SOUND VOLUME IF TREE IS UNDESIREABLE
C----------
       IF (IMC(I) .EQ. 2) VN = C1(ISPC)*VN
C----------
C  CALCULATE MERCHANTABLE CUBIC FOOT VOLUME (VM)
C----------
       IF ((IMC(I) .GT. 1) .OR. (D .LT. BFMIND(ISPC))) GOTO 100
       VM = B1(ISPC)*SITEAR(ISPC)**B2(ISPC)*(1-EXP(-1.0*B3(ISPC)*D
     &        ))**B4(ISPC)
  100  CONTINUE
       RETURN
       END                                    

