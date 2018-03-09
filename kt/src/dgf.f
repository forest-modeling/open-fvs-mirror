      SUBROUTINE DGF(DIAM)
      IMPLICIT NONE
C----------
C KT $Id: dgf.f 0000 2018-02-14 00:00:00Z gedixon $
C----------
C  THIS SUBROUTINE COMPUTES THE VALUE OF DDS (CHANGE IN SQUARED
C  DIAMETER) FOR EACH TREE RECORD, AND LOADS IT INTO THE ARRAY
C  WK2.  DDS IS PREDICTED FROM HABITAT TYPE, LOCATION, SLOPE,
C  ASPECT, ELEVATION, DBH, CROWN RATIO, BASAL AREA IN LARGER TREES,
C  AND CCF.  THE SET OF TREE DIAMETERS TO BE USED IS PASSED AS THE
C  ARGUEMENT DIAM.  THE PROGRAM THUS HAS THE FLEXIBILITY TO
C  PROCESS DIFFERENT CALIBRATION OPTIONS.  THIS ROUTINE IS CALLED
C  BY **DGDRIV** DURING CALIBRATION AND WHILE CYCLING FOR GROWTH
C  PREDICTION.  ENTRY **DGCONS** IS CALLED BY **RCON** TO LOAD SITE
C  DEPENDENT COEFFICIENTS THAT NEED ONLY BE RESOLVED ONCE.
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'CALCOM.F77'
C
C
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'COEFFS.F77'
C
C
      INCLUDE 'PDEN.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'KOTCOM.F77'
C
C
COMMONS
C
C  DIMENSIONS FOR INTERNAL VARIABLES.
C
C     DIAM -- ARRAY LOADED WITH TREE DIAMETERS (PASSED AS AN
C             ARGUEMENT).
C     DGLD -- ARRAY CONTAINING COEFFICIENTS FOR THE LOG(DIAMETER)
C             TERM IN THE DDS MODEL (ONE COEFFICIENT FOR EACH
C             SPECIES).
C     DGCR -- ARRAY CONTAINING THE COEFFICIENTS FOR THE CROWN
C             RATIO TERM IN THE DDS MODEL (ONE COEFFICIENT FOR
C             EACH SPECIES).
C   DGCRSQ -- ARRAY CONTAINING THE COEFFICIENTS FOR THE CROWN
C             RATIO SQUARED TERM IN THE DDS MODEL (ONE
C             COEFFICIENT FOR EACH SPECIES).
C    DGBAL -- ARRAY CONTAINING COEFFICIENTS FOR THE BASAL AREA IN
C             LARGER TREES TERM IN THE DDS MODEL. NOT USED IN THIS
C             VARIANT (ONE COEFFICIENT FOR EACH SPECIES).
C   DGDBAL -- ARRAY CONTAINING COEFFICIENTS FOR THE INTERACTION
C             BETWEEN BASAL AREA IN LARGER TREES AND LN(DBH) (ONE
C             COEFFICIENT PER SPECIES).
C    DGCCF -- ARRAY CONTAINING THE COEFFICIENTS FOR THE CROWN
C             COMPETITION FACTOR TERM IN THE DDS MODEL (ONE
C             COEFFICIENT FOR EACH SPECIES, LOADED IN RCON).
C    DGLBA -- ARRAY CONTAINING COEFFICIENTS FOR THE LOG(BASAL AREA)
C             TERM IN THE DDS MODEL (ONE COEFFICIENT FOR EACH SPECIES).
C    DGPCC1 - ARRAY CONTAINING THE POINT CROWN COMPETITION FACTOR
C             FOR MANAGED STANDS (ONE COEFFICIENT FOR EACH SPECIES).
C    DGPCC2 - ARRAY CONTAINING THE POINT CROWN COMPETITION FACTOR
C             FOR UNMANAGED STANDS (ONE COEFFICIENT FOR EACH SPECIES).
C    DGCCFSQ- ARRAY CONTAINING THE COEFFICIENTS FOR THE CROWN
C             COMPETITION FACTOR SQUARED TERM IN THE DDS MODEL (ONE
C             COEFFICIENT FOR EACH SPECIES).
C    DBHCH -- ARRAY FOR THE DIAMETER LIMIT UNTIL CROWN RATIO IS LIMITED
C    ICRLIM - MAXIMUM CROWN RATIO ALLOWED FOR TREES WITH DIAMETER
C             GREATER THAN OR EQUAL TO DBHCH
C----------
      LOGICAL DEBUG
      REAL DIAM(MAXTRE),DGLD(MAXSP),DGCR(MAXSP),DBHCH(MAXSP)
      REAL DGCRSQ(MAXSP),DGDBAL(MAXSP),DGHAB(9,MAXSP),DGFOR(7,MAXSP)
      REAL DGDS(MAXSP),DGEL(MAXSP),DGEL2(MAXSP),DGSASP(MAXSP)
      REAL DGCASP(MAXSP),DGSLOP(MAXSP),DGSLSQ(MAXSP)
      REAL DGLBA(MAXSP),DGPCC1(MAXSP),DGPCC2(MAXSP),CCFSQ(MAXSP)
      REAL DGCCFA(MAXSP),DGD2,CRMAX
      INTEGER ICRLIM(MAXSP),MAPHAB(175,MAXSP),MAPLOC(10,MAXSP)
      INTEGER OBSERV(9,MAXSP)
      INTEGER ISPC,I1,I2,I3,I,IPCCF
      REAL CONSPP,DGLDS,DGCRS,DGCRS2,DGDBLS,DGCCF2,DGLBAS,D,DUM1,DUM2
      REAL DGPC1,DGPC2,PCCF1,CCF2,ALD,CR,BAL,DDS,PPCCF,XPPDDS
      DATA DGLD/
     &   0.89068, 0.71363, 0.91484, 1.24554, 1.03000, 1.00243,
     &   0.90678, 0.98560, 1.06324, 0.85286, 0.89778/
      DATA DGCR/
     &   1.33383, 1.57307, 2.32586, 1.21753, 1.04060, 1.62559,
     &   1.79329, 1.35330, 0.75412, 2.71069, 1.28403/
      DATA DGCRSQ/
     &  -0.46964,-0.56399,-1.02799, 0.00000, 0.00000,-0.25015,
     &  -0.40740,-0.18967, 0.46269,-1.27309,0.000000/
      DATA DGDBAL/
     &  -0.00706,-0.01026,-0.00697,-0.00483,-0.00404,-0.00430,
     &  -0.00479,-0.00614,-0.00443,-0.00527,-0.66110/
      DATA CCFSQ/
     &   0.000000, 0.000008, 0.000007, 0.000003, 0.000000, 0.000006,
     &   0.000000, 0.000004, 0.000006, 0.000000, 0.000000/
      DATA DGPCC1/
     &   0.000072, 0.000000,-0.000413,-0.001050,-0.000558,-0.001027,
     &   0.000770,-0.000565,-0.000050,-0.000113, 0.000000/
      DATA DGPCC2/
     &  -0.000810, 0.000000,-0.001173,-0.001232,-0.000925,-0.000958,
     &  -0.000697,-0.001045,-0.001134,-0.000981, 0.000000/
      DATA DGLBA/
     &  -0.26312, 0.00000, 0.00000, 0.00000,-0.00308, 0.09764,-0.07759,
     &  -0.14396,-0.11870,-0.07669, 0.00000/
      DATA DBHCH/
     &   6*25.0,20.0,3*25.0,99.0/
      DATA ICRLIM/
     &   7,6,8,8,8,8,7,9,9,7,9/
      DATA  OBSERV/
     &     82,   758,  3280,   322,     0,     0,     0,     0,     0,
     &   7811,  5028,  2546,  3735,  5002, 15814,  3443,     0,     0,
     &     69,  3306,  5075, 10390,  4735,  3137,  1543,     0,     0,
     &   6744,  1428,   483,    54,     0,     0,     0,     0,     0,
     &   1019,   145,  6295,     0,     0,     0,     0,     0,     0,
     &   2990,   345,  1664,  1398,  3085,     0,     0,     0,     0,
     &    939,  4622,  2717,  8448, 16688,  2869,  6849,  4891,   676,
     &    224,  3217,   759,  4674,  3538,   192,   145,  3031,  4189,
     &    926,  5333,  2140,  6219,   298,  9150,     0,     0,     0,
     &   1188,  1558,  2721,   486,  1719,   405,     0,     0,     0,
     &     55,   880,     0,     0,     0,     0,     0,     0,     0/
C----------
C  DGHAB IS AN ARRAY THAT CONTAINS HABITAT CLASS INTERCEPTS FOR
C  EACH SPECIES.  MAPHAB IS INDEXED BY ITYPE TO MAP HABITAT
C  TYPES ONTO HABITAT CLASSES.
C----------
      DATA MAPHAB/
     &  23*1,2,3*1,3*2,3*1,2,5*1,2*2,4*1,2,2*1,2,22*1,4*2,1,2*2,1,
     &      4*2,2*1,7*2,1,2*2,3*3,2,3,2,1,3,2,3,1,4*3,4,2*3,2*4,1,
     &      3,3*1,3,6*1,3,2*1,2*3,2*4,3*1,2*3,4,3,3*1,4,1,4,1,4,4*1,
     &      4,21*1,
     &  11*1,2,1,2,2*1,2,7*1,2,1,2,2*1,2*2,1,2*2,3*1,2,3*1,2*2,4*1,
     &      2*2,1,2,2*1,2*2,1,2,2*1,4,1,7,6,2*1,7,1,2*4,2*1,2*3,2*1,2*3,
     &      4,1,5,2*3,1,3,1,3*5,4,1,3,2*4,3,5,3*6,5,3,4,2*1,5,2*1,3*3,
     &      2*4,6,7,4,6,4,7,3*1,7,5*1,4,6,2*1,6,7,1,7,2*1,6,4,7,2*6,3*1,
     &      4,1,6,4,6,2*1,2*4,9*1,6,2*1,4,9*1,
     &  11*1,2,1,2,2*1,2,2*1,2,3*1,2,3,1,2,4,2*3,2,3,5,2,3,2,2*3,2*5,
     &      2*3,5,3,1,2,3,2*5,4,3,5,3,2*2,4*1,4,3*6,7,1,2,1,4,6,1,4,2,1,
     &      9*4,2,18*4,1,2*4,1,2*4,2,4,2*6,4,6,4,3*6,1,6,7,6,2*1,7,6,
     &      2*1,7,1,2*7,6,7,6,2*7,6,1,3*6,2*4,1,6,1,2*6,4,2*7,1,6,2*7,
     &      5*1,7,4*1,7,6,8*1,
     &  23*1,2,2*1,3*2,1,4*2,1,2*2,2*1,2*2,4*1,3*2,23*1,3,2,6*1,2,6*1,3,
     &      3*1,2*3,1,4,3*1,2*2,1,2,1,2,5*1,2,1,6*2,4*1,2,8*1,5*2,41*1,
     &  72*1,3,21*1,2,6*3,1,3*2,70*1,
     &  11*1,2,11*1,4,3*1,2*2,3*4,1,4,3*2,1,3*4,1,2*4,1,2,1,2*4,2,10*1,
     &      2,1,2,5*1,2,2*1,2*3,4*2,1,6*2,1,3,4,7*3,2*1,5,2*4,5,3*4,5,
     &      2*1,11*3,2*1,2*3,2*1,2*3,4*1,5*3,3*1,7,1,2,5,2,2*1,5,2*1,
     &      3*5,2*1,2*5,6*1,5,14*1,
     &  13*1,2,2*1,3,6*1,4,2,1,2,2*3,2*4,3,5*2,4,2*2,2*3,2*4,1,2*3,2*2,
     &      3,4,1,4,2*2,1,2,2*1,4*4,5,1,4,5,3*4,1,3*6,1,6,5,6,1,2*6,7,
     &      5,6,1,6,2*7,5,2*7,5,1,7,5,7,5,7,6,2*5,1,2*5,2*1,6,7,5,2*4,8,
     &      5,4*4,2*1,2*4,2*1,5,8,2*4,5,1,2*4,5,8,5,3*1,3*4,2*5,4,1,2*4,
     &      5,4,9,2*1,2*5,4,5,5*1,5,2*1,2,4,9*1,4,
     &  27*1,2*3,1,3,2*1,2*2,2*3,2,2*1,3,2*1,2,1,2,1,2,3,10*1,2*3,3*2,1,
     &      2,1,2*3,2*1,2*5,3*1,2,2*1,2,4,2,2*4,1,3,5,3,2*5,4*6,5,2*4,5,
     &      2*4,5,3*4,2*1,2*2,4,7,5,8,5,2*9,2,5,1,7,2*5,2*1,7,2*1,7,8,1,
     &      9,5,9,8,9,2*8,5,7,9,2*2,9,2,1,5,7,5,8,9,2*8,1,2*2,6*1,8,1,9,
     &      2*1,2,2*9,7*1,
     &  27*1,2*2,2*3,4,3,2,3*3,2,3,2*2,1,3,2,1,2,5*3,3*1,2,1,3,2*1,4*2,
     &      2*1,2,1,2*2,2*1,2,4,3*1,4,2*1,2*4,3,4,2*1,4*2,3*5,1,5,10*4,
     &      2*1,3*3,5,2,6,2,2*4,2*2,1,5,4,2,2*1,5,3,2*1,4,1,3,2*6,3,6,1,
     &      2,6,2*4,1,2*6,4,1,5,1,2*3,1,2*3,1,4,6,6*1,3,3*1,5,2,5,4,5*1,
     &      4,1,
     &  13*1,2,1,2*2,2*1,2,2*1,2,2*4,1,4,5,1,2*3,5,4*2,2*3,2*2,5,3*2,1,
     &      3,4,2,3,4,2,2*1,2,5,6*1,2*3,5*1,3,1,2*6,5,6,1,3*6,1,5*5,1,
     &      3*6,5*1,6,1,4*5,3*1,5,3*1,3*3,1,6*3,4*1,3,8*1,5*3,5*1,3*3,
     &      2*1,3,1,2*3,4*1,2*3,21*1,
     &  133*2,5*1,37*2/
      DATA DGHAB/
     &  0.00000, 0.46877, 0.36827, 0.25380, 0.00000, 0.00000, 0.00000,
     &           0.00000, 0.00000,
     &  0.00000,-0.14413, 0.09463, 0.25452, 0.09901, 0.15839, 0.18736,
     &           0.00000, 0.00000,
     &  0.00000, 0.32102, 0.26245, 0.36975, 0.20189, 0.41958, 0.21150,
     &           0.00000, 0.00000,
     &  0.00000, 0.04934,-0.02840, 0.30154, 0.00000, 0.00000, 0.00000,
     &           0.00000, 0.00000,
     &  0.00000,-0.18536,-0.03054, 0.00000, 0.00000, 0.00000, 0.00000,
     &           0.00000, 0.00000,
     &  0.00000, 0.22308, 0.05241,-0.03541,-0.14473, 0.00000, 0.00000,
     &           0.00000, 0.00000,
     &  0.00000,-0.02517, 0.14033, 0.09364, 0.06392, 0.17607, 0.12434,
     &           0.03253,-0.04246,
     &  0.00000, 0.25430, 0.35826, 0.26282, 0.33856, 0.66511, 0.47824,
     &           0.08994, 0.14762,
     &  0.00000, 0.19307,-0.02105, 0.13296, 0.33120, 0.03795, 0.00000,
     &           0.00000, 0.00000,
     &  0.00000,-0.11238,-0.02699,-.266678, .0483982,.1757643,0.00000,
     &           0.00000, 0.00000,
     & -1.68033,-1.52111, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000,
     &           0.00000, 0.00000/
C----------
C  DGCCFA CONTAINS COEFFICIENTS FOR THE CCF TERM BY SPECIES
C----------
      DATA DGCCFA/
     &  0.00250,-0.00270,-0.00178,-0.00047, 00000.0,
     & -0.00225, 0.00000, 0.00000,-0.00055,0.000000,-0.10744/
C----------
C  DGFOR CONTAINS LOCATION CLASS CONSTANTS FOR EACH SPECIES.  MAPLOC
C  IS AN ARRAY WHICH MAPS GEOGRAPHIC ARES ONTO A LOCATION CLASS.
C----------
      DATA MAPLOC/
     & 1,1,1,1,1,1,1,1,1,1,
     & 1,2,2,3,2,2,3,4,5,3,
     & 1,1,2,3,2,4,2,5,6,7,
     & 1,2,2,2,2,1,1,3,4,1,
     & 1,1,1,2,1,1,1,3,1,1,
     & 1,1,2,3,4,5,6,5,5,5,
     & 1,2,2,3,2,1,4,5,1,4,
     & 1,1,1,2,3,1,3,4,1,1,
     & 1,1,2,1,2,2,2,3,4,4,
     & 1,2,2,2,2,1,2,2,1,2,
     & 1,1,1,1,1,1,1,1,1,1/
      DATA DGFOR/
     & 1.76061 ,    0.0,     0.0,     0.0,     0.0,     0.0,     0.0,
     & 0.90538, 1.05703, 0.92987, 1.21864, 0.85925,     0.0,     0.0,
     & 0.28515, 0.47449, 0.22243, 0.38244, 0.77000, 0.25263, 0.41726,
     &-0.16279, 0.01201, 0.21551,-0.45254,     0.0,     0.0,     0.0,
     & 0.58335, 0.05082, 0.76325,     0.0,     0.0,     0.0,     0.0,
     & 0.60677, 0.25734, 0.41586, 0.84058, 0.87222, 0.51366,     0.0,
     & 0.73315, 0.80566, 0.68869, 0.78334, 1.00490,     0.0,     0.0,
     & 0.73648, 0.63397, 0.86675, 1.01332,     0.0,     0.0,     0.0,
     & 0.28606, 0.42202, 0.59260, 0.35594,     0.0,     0.0,     0.0,
     & 1.27975, 1.46166,     0.0,     0.0,     0.0,     0.0,     0.0,
     &     0.0,     0.0,     0.0,     0.0,     0.0,     0.0,     0.0/
C----------
C  DGDS CONTAINS COEFFICIENTS FOR THE DIAMETER SQUARED TERMS
C  IN THE DIAMETER INCREMENT MODELS.
C----------
      DATA DGDS/
     & -0.000358,-0.000553,-0.000818,-0.000983,
     & -0.000546,-0.000252,-0.001237,-0.000551,
     & -0.001140,-0.000711,-0.000484/
C----------
C  DGEL CONTAINS THE COEFFICIENTS FOR THE ELEVATION TERM IN THE
C  DIAMETER GROWTH EQUATION.  DGEL2 CONTAINS THE COEFFICIENTS FOR
C  THE ELEVATION SQUARED TERM IN THE DIAMETER GROWTH EQUATION.
C  DGSASP CONTAINS THE COEFFICIENTS FOR THE SIN(ASPECT)*SLOPE
C  TERM IN THE DIAMETER GROWTH EQUATION.  DGCASP CONTAINS THE
C  COEFFICIENTS FOR THE COS(ASPECT)*SLOPE TERM IN THE DIAMETER
C  GROWTH EQUATION.  DGSLOP CONTAINS THE COEFFICIENTS FOR THE
C  SLOPE TERM IN THE DIAMETER GROWTH EQUATION.  DGSLSQ CONTAINS
C  COEFFICIENTS FOR THE (SLOPE)**2 TERM IN THE DIAMETER GROWTH MODELS.
C  ALL OF THESE ARRAYS ARE SUBSCRIPTED BY SPECIES.
C----------
      DATA DGCASP/
     &  -0.06355,-0.13645,-0.02412,-0.01643,-0.03073, 0.00779,
     &  -0.07271,-0.18211,-0.10512,-0.18077, 0.17935/
      DATA DGSASP/
     &  -0.02975,-0.02172, 0.06558, 0.05178,-0.00462, 0.00659,
     &   0.06870, 0.07099,-0.01060,-0.00704, 0.13363/
      DATA DGSLOP/
     &   0.05705, 0.15248, 0.03603, 0.17354,-0.02011,-0.05252,
     &  -0.31034, 0.22033, 0.26053,-0.61544, 0.07628/
      DATA DGSLSQ/
     &  -0.30165,-0.40132,-0.50543,-0.35182, 0.16420, 0.18516,
     &   0.00000,-0.45491,-0.47935, 0.00000,0.000000/
      DATA DGEL/
     &  -0.00600,-0.00740,-0.00563, 0.00159,-0.00430,-0.02275,
     &   0.00281, 0.00634, 0.01539,-0.00515, 0.08518/
      DATA DGEL2/
     &   0.000000, 0.000069, 0.000000, 0.000000, 0.000000, 0.000281,
     &  -0.000112,-0.000106,-0.000214,-0.000120,-0.000943/
C-----------
C  SEE IF WE NEED TO DO SOME DEBUG.
C-----------
      CALL DBCHK (DEBUG,'DGF',3,ICYC)
C----------
C  DEBUG OUTPUT: MODEL COEFFICIENTS.
C----------
      IF(DEBUG)
     & WRITE(JOSTND,9000) DGCON,DGLD,DGCR,DGCRSQ,DGCCF
 9000 FORMAT(/11(1X,F10.5))
C----------
C  BEGIN SPECIES LOOP.  ASSIGN VARIABLES WHICH ARE SPECIES DEPENDENT
C----------
      DO 20 ISPC=1,MAXSP
      I1=ISCT(ISPC,1)
      IF(I1.EQ.0) GO TO 20
      I2=ISCT(ISPC,2)
      IF(DEBUG)WRITE(JOSTND,*)' DGCON=',DGCON(ISPC),' COR=',COR(ISPC),
     &    'DGCCF=',DGCCF(ISPC),' RELDEN=',RELDEN
      CONSPP= DGCON(ISPC) + COR(ISPC) + DGCCF(ISPC)*RELDEN
      IF(ISPC.EQ.11) CONSPP=DGCON(ISPC)+COR(ISPC)+.01*DGCCF(ISPC)*RELDEN
      DGLDS= DGLD(ISPC)
      DGCRS= DGCR(ISPC)
      DGCRS2=DGCRSQ(ISPC)
      DGDBLS=DGDBAL(ISPC)
      DGCCF2=CCFSQ(ISPC)
      DGLBAS=DGLBA(ISPC)
      DGD2=DGDS(ISPC)
      CRMAX =(ICRLIM(ISPC)*10.0-5.0)/100
C----------
C  BEGIN TREE LOOP WITHIN SPECIES ISPC.
C----------
      DO 10 I3=I1,I2
      I=IND1(I3)
      D=DIAM(I)
C----------
C  THE FOLLOWING CODE SEGMENT THROUGH ENDIF SETS DUM1 TO UNITY FOR A
C  MANAGED STAND WITH DUM2 ZERO.  VICE VERSA FOR AN UNMANAGED STAND.
C----------
      DUM1 = 0.0
      DUM2 = 1.0
      IF(MANAGD .EQ. 1) THEN
         DUM1 = 1.0
         DUM2 = 0.0
      ENDIF
      DGPC1 =DGPCC1(ISPC)*DUM1
      DGPC2 =DGPCC2(ISPC)*DUM2
      IPCCF=ITRE(I)
      PCCF1=PCCF(IPCCF)
      CCF2=RELDEN*RELDEN
      IF (D.LE.0.0) GOTO 10
      ALD=ALOG(D)
      CR=ICR(I)*0.01
C----------
C  IF TREES DBH IS GREATER THAN OR EQUAL TO DBHCH, CHECK TREES CROWN
C  RATIO.  IF CROWN RATIO IS GREATER THAN ICRLIM, SET CROWN RATIO TO
C  CRLIM FOR THE COMPUTATION OF DIAMETER GROWTH.  THIS BOUNDING OF
C  CROWN RATIO IS DUE TO THE DIAMETER GROWTH EQUATION BEING HIGHLY
C  DEPENDENT UPON CROWN RATIO. LARGE TREES WITH LARGE CROWNS WERE
C  GROWING TOO MUCH.
C----------
c     IF (D .GT. DBHCH(ISPC)) THEN
c        IF(CR .GT. CRMAX) CR=CRMAX
c     ENDIF
      BAL = (1.0 - (PCT(I)/100.)) * BA
      IF(ISPC .EQ. 11)BAL=(1.0-(PCT(I)/100.))*BA/100
      DDS=CONSPP + DGLDS*ALD + CR*(DGCRS+CR*DGCRS2)
     &    + DGDBLS*BAL/(ALOG(D+1.0))+DGCCF2*CCF2+DGD2*D*D+
     &     DGLBAS*ALOG(BA) + DGPC1*PCCF1 + DGPC2*PCCF1
C---------
C     CALL PPDGF TO GET A MODIFICATION VALUE FOR DDS THAT ACCOUNTS
C     FOR THE DENSITY OF NEIGHBORING STANDS.
C
      PPCCF=DGCCF(ISPC)
      IF(ISPC.EQ.11)PPCCF=DGCCF(11)*.01
      XPPDDS=0.
      CALL PPDGF (XPPDDS,BAL,RELDEN,BA,D,PPCCF,DGCCF2,
     &            DGDBLS,DGLBAS,ISPC)
C
      DDS=DDS+XPPDDS
C---------
      IF(DDS.LT.-9.21) DDS=-9.21
      WK2(I)=DDS
      IF(DEBUG)WRITE(JOSTND,*)' I=',I,' XPPDDS=',XPPDDS
      IF(DEBUG)WRITE(JOSTND,*)' CONSPP=',CONSPP,' DGLDS=',DGLDS,
     &   ' ALD=',ALD,' D=',D,' CR=',CR,' DGCRS=',DGCRS,
     &   ' DGCRS2=',DGCRS2,' DGDBLS=',DGDBLS,' BAL=',BAL,' DGCCF2=',
     &   DGCCF2,' CCF2=',CCF2,' DGD2=',DGD2,' DGLBAS=',DGLBAS,' BA=',
     &   BA,' DGPC1=',DGPC1,' PCCF1=',PCCF1,' DGPC2=',DGPC2,' DDS=',DDS
C----------
C  END OF TREE LOOP.  PRINT DEBUG INFO IF DESIRED.
C----------
      IF(.NOT.DEBUG) GO TO 10
      WRITE(JOSTND,9001) I,ISPC,D,BAL,CR,RELDEN,BA,DDS
 9001 FORMAT(' IN DGF, I=',I4,',  ISPC=',I3,',  DBH=',F7.2,
     &      ',  BAL=',F7.2,',  CR=',F7.4/
     &      '          CCF=',F9.3,',  BA=',F9.3,',   LN(DDS)=',F7.4)
      WRITE(JOSTND,*)' CONSPP=',CONSPP,' PCT=',PCT(I),
     &      ' DGDBLS=',DGDBLS,' DGCCF2=',DGCCF2,
     &      ' DGPC1=',DGPC1,' DGPC2=',DGPC2,'CRMAX=',CRMAX,
     &      ' DBHCH=',DBHCH(ISPC)
   10 CONTINUE
C----------
C  END OF SPECIES LOOP.
C----------
   20 CONTINUE
      RETURN
      ENTRY DGCONS
C----------
C  ENTRY POINT FOR LOADING COEFFICIENTS OF THE DIAMETER INCREMENT
C  MODEL THAT ARE SITE SPECIFIC AND NEED ONLY BE RESOLVED ONCE.
C  ITYPE IS THE HABITAT TYPE INDEX AS COMPUTED IN **HABTYP**.
C  ASPECT IS STAND ASPECT IN RADIANS.  OBSERV CONTAINS THE NUMBER OF
C  OBSERVATIONS BY HABITAT CLASS BY SPECIES FOR THE UNDERLYING
C  MODEL (THIS DATA IS ACTUALLY USED BY **DGDRIV** FOR CALIBRATION).
C----------
C----------
C  ENTER LOOP TO LOAD SPECIES DEPENDENT VECTORS.
C----------
      DO 30 ISPC=1,MAXSP
      ISPHAB=MAPHAB(KKTYPE,ISPC)
      ISPFOR=MAPLOC(KOTFOR,ISPC)
      DGCCF(ISPC)=DGCCFA(ISPC)
      DGCON(ISPC)= DGHAB(ISPHAB,ISPC)
     &                 + DGFOR(ISPFOR,ISPC)
     &                 + DGEL(ISPC) * ELEV
     &                 + DGEL2(ISPC) * ELEV * ELEV
     &                 +(DGSASP(ISPC) * SIN(ASPECT)
     &                 + DGCASP(ISPC) * COS(ASPECT)
     &                 + DGSLOP(ISPC)) * SLOPE
     &                 + DGSLSQ(ISPC) * SLOPE * SLOPE
      ATTEN(ISPC)=OBSERV(ISPHAB,ISPC)
      SMCON(ISPC)=0.
C----------
C  IF READCORD OR REUSCORD WAS SPECIFIED (LDCOR2 IS TRUE) ADD
C  LN(COR2) TO THE BAI MODEL CONSTANT TERM (DGCON).  COR2 IS
C  INITIALIZED TO 1.0 IN BLKDATA.
C----------
      IF (LDCOR2.AND.COR2(ISPC).GT.0.0) DGCON(ISPC)=DGCON(ISPC)
     &  + ALOG(COR2(ISPC))
   30 CONTINUE
      RETURN
      END
