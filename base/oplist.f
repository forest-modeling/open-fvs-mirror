      SUBROUTINE OPLIST (LFIRST,NPLT,MGMID,ITITLE)
      IMPLICIT NONE
C----------
C BASE $Id$
C----------
C
C     OPTION PROCESSING ROUTINE - NL CROOKSTON - JAN 1981 - MOSCOW
C
C     OPLIST WRITES A SUMMARY OF THE ACTIVITIES.
C     IF LFIRST IS TRUE, THE INITIAL ACTIVITY SCHEDULE IS WRITTEN;
C     AND IF LFIRST IS FALSE, THE FINAL SCHEDULE, INCLUDING THE
C     DISPOSITION OF ACTIVITIES, IS WRITTEN.
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'OPCOM.F77'
C
C
      INCLUDE 'KEYCOM.F77'
C
C
COMMONS
C
      INTEGER NTRSLT,I1,I,ICY,I2,II,IACTK,IDT,KEY,LOC,J1,J2,J,ID,K
      CHARACTER*26 NPLT
      CHARACTER*4  MGMID
      CHARACTER*72 ITITLE
      CHARACTER*20 IDISPO(2)
      LOGICAL LINE,LFIRST
      CHARACTER*8 KEYWRD,UNKNOW,TITL,SCHED,SUMMR
      CHARACTER*4 TAB2(17)
      PARAMETER (NTRSLT=148)
      INTEGER ITRSL1(NTRSLT),ITRSL2(NTRSLT)
      INTEGER IOPCYHLD(MAXACT)             ! Used for temp hold of IOPCYC array
      DATA ITRSL1/
     >       33,   80,   81,   82,   90,   91,   92,   93,   94,   95,
     >       96,   97,   98,   99,  100,  101,  102,  110,  111,  120,
     >      198,  199,  200,  201,  202,  203,  204,  205,  206,  215,
     >      216,  217,  218,  222,  223,  224,  225,  226,  227,  228,
     >      229,  230,  231,  232,  233,  234,  235,  236,  237,  248,
     >      249,  250,  260,  427,  428,  429,  430,  431,  432,  440,
     >      442,  443,  444,  450,  490,  491,  492,  493,  555,  810,  
     >      811,  900, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 
     >     1009, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 
     >     2150, 2151, 2152, 2153, 2154, 2155, 2156, 2157, 2158, 2159, 
     >     2160, 2208, 2209, 2210, 2320, 2401, 2402, 2403, 2414, 2415, 
     >     2416, 2417, 2430, 2431, 2432, 2433, 2501, 2505, 2506, 2507, 
     >     2512, 2520, 2521, 2522, 2523, 2525, 2529, 2530, 2538, 2539, 
     >     2548, 2549, 2550, 2553, 2554, 2605, 2606, 2607, 2608, 2609, 
     >     2701, 2702, 2703, 2704, 2801, 2802, 2803, 2804/
C
      DATA ITRSL2/
     >       33,   17,   96,  102,    3,   58,   62,   70,   59,  207,
     >       45,   88,  110,  111,  118,  616,  603,   38,   37,  138,
     >      135,   92,   48,   49,   71,  103,  107,  120,  144,   41,
     >       42,   43,   44,   23,   24,   25,   26,   27,   28,   29,
     >       30,  112,  115,   35,  122,  124,  129,  136,  141,  128,
     >      108,   78,   34,  216,  211,  212,  202,  203,  229,  213,
     >      215,   93,  145,  226,  203,  204,  230,  205,  406,  306,  
     >      336,  512,  901,  902,  903,  904,  905,  906,  910,  911,  
     >      916, 1001, 1004, 1005, 1002, 1007, 1010, 1011, 1023, 1024, 
     >     1114, 1108, 1114, 1109, 1116, 1114, 1114, 1124, 1114, 1124, 
     >     1114, 1208, 1209, 1210, 1320, 1401, 1402, 1403, 1414, 1415, 
     >     1416, 1417, 1430, 1431, 1432, 1433, 1501, 1505, 1506, 1507, 
     >     1512, 1520, 1521, 1522, 1523, 1525, 1533, 1534, 1538, 1539, 
     >     1548, 1549, 1550, 1553, 1554, 1601, 1602, 1603, 1604, 1605, 
     >     1301, 1302, 1303, 1304,  703,  704,  705,  706/
C
      DATA TAB2/'CMPU','BASE','ESTB','DFTM','MPB', 'COVR',
     >          'DBS ','CLIM','    ','RUST','MIST','WSBE','DFB',
     >          'WPBM','RDIS','FIRE','ECON'/
      DATA UNKNOW/'*UNKNOWN'/,SCHED/'SCHEDULE'/,SUMMR/'SUMMARY '/
      DATA IDISPO/'DELETED OR CANCELED ',
     >            'NOT DONE            '/
C
C     ITRSL1= TRANSLATION TABLE, PART ONE. CONTAINS AN ORDERED LIST
C             OF VALID ACTIVITY CODES.
C     ITRSL2= TRANSLATION TABLE, PART TWO. CONTAINS A SUBSCRIPT TO
C             THE POSITION IN THE KEYWORD TABLES THAT CONTAINS THE
C             KEYWORD CORRESPONDING TO THE ACTIVITY.
C             IF THE SUBSCRIPT IS UNDER 200, THEN THE KEYWORD IS
C             PART OF THE BASE AND FOUND IN 'TABLE'.  IF IT IS OVER
C             199, THEN THE KEYWORD IS FROM AS EXTENSION AND NUMBERED
C             AS FOLLOWS:
C                     200-299  ESTAB
C                     300-399  DFTM
C                     400-499  MPB
C                     500-599  COVER
C                     600-699  DBS  (DATABASE KEYWORDS)
C                     700-799  CLIMATE-FVS
C                     800-899  ** free spot **
C                     900-999  BRUST
C                    1000-1099 MIST
C                    1100-1199 WSBWE (GenDefol)
C                    1200-1299 DFB
C                    1300-1399 WPBM--STAND LEVEL ACTIVITIES.
C                    1400-1499 WRD VER. 3.0
C                    1500-1599 FIRE
C                    1600-1699 ECON
C
C     NTRSLT= THE LENGTH OF THE TRANSLATION TABLES.
C
C     IF THERE ARE NO ACTIVITIES, AND THIS IS THE SECOND CALL,
C     DO NOT PRINT THE ACTIVITY SCHEDULE.
C
      IF (.NOT.LFIRST  .AND. IMGL.EQ.1) RETURN
C
C     WRITE HEADING
C
      IF (.NOT.LFIRST) WRITE (JOSTND,15)
      IF (.NOT.LFIRST) WRITE (JOSTND,15)
      TITL=SUMMR
      IF (LFIRST) TITL=SCHED
      WRITE (JOSTND,10) TITL,NPLT,MGMID,ITITLE
   10 FORMAT (//T54,'ACTIVITY ',A8//'STAND ID= ',A26,
     >        '    MGMT ID= ',A4,4X,A72//130('-'))
      IF (LFIRST) WRITE (JOSTND,11)
   11 FORMAT(/'CYCLE  DATE  EXTENSION  KEYWORD   DATE  PARAMETERS:'/
     >        '-----  ----  ---------  --------  ----  ',90('-'))
      IF (.NOT.LFIRST) WRITE (JOSTND,12)
   12 FORMAT(/'CYCLE  DATE  EXTENSION  KEYWORD   DATE  ',
     >        'ACTIVITY DISPOSITION  PARAMETERS:'/
     >        '-----  ----  ---------  --------  ----  ',20('-'),
     >      2X,68('-'))
C
C     IF THIS THE SECOND CALL (LFIRST=FALSE) MAKE SURE THAT THE DATE
C     AN ACTIVITY WAS ACCOMPLISHED IS USED TO ASSIGN THE ACTIVITY
C     TO THE CYCLE RATHER THAN THE DATE THE ACTIVITY WAS SCHEDULED.
C
C     (1) SAVE THE DATE ARRAY (IDATE) IN IOPCYC AND LOAD IDATE WITH
C         THE DATE THE ACTIVITY WAS ACCOMPLISHED.
C
      IF (LFIRST) GOTO 16
      I1=IMGL-1
      DO 13 I=1,I1
      IOPCYHLD(I)=IOPCYC(I) 
      IOPCYC(I)=IDATE(I) 

      IF(IACT(I,4).GT.0) IDATE(I)=IACT(I,4)
   13 CONTINUE
C
C     (2) REESTABLISH THE ASSIGNMENT OF ACTIVITIES TO CYCLES.
C
      CALL OPSORT(I1,IDATE,ISEQ,IOPSRT,.TRUE.)
      CALL OPCYCL(NCYC,IY)
C
C     CREATE AND POPULATE COMPUTE DATABASE TABLE IF REQUIRED
C
      CALL DBSCMPU
C
C     (3) RETURN THE VALUES OF IDATE
C
      DO 14 I=1,I1
      IDATE(I)=IOPCYC(I)
      IOPCYC(I)=IOPCYHLD(I)
   14 CONTINUE
   16 CONTINUE
C
C     DO FOR ALL CYCLES
C
      LINE=.TRUE.
      DO 160 ICY=1,NCYC
      I1=IMGPTS(ICY,1)
      IF (I1.GT.0) GOTO 30
      IF (LINE) WRITE (JOSTND,15)
   15 FORMAT ()
      LINE=.FALSE.
      WRITE (JOSTND,20) ICY,IY(ICY)
   20 FORMAT (I4,I7)
      GOTO 160
   30 CONTINUE
      LINE=.TRUE.
      WRITE (JOSTND,35) ICY,IY(ICY)
   35 FORMAT (/I4,I7)
C
C     IF THERE ARE NO ACTIVITIES DURING THE CYCLE;
C     THEN: BRANCH TO END CYCLE.
C
      I2=IMGPTS(ICY,2)
C
C     DO FOR ALL ACTIVITIES WITHIN THE CYCLE.
C
      DO 150 II=I1,I2
      I=IOPSRT(II)
      IACTK=IACT(I,1)
      IDT=IDATE(I)
C
C     FIND THE ACTIVITY KODE (IACTK) IN THE TRANSLTAION TABLE.
C
      CALL OPBISR (NTRSLT,ITRSL1,IACTK,KEY)
C
C     IF THE ACTIVITY KODE IS NOT IN THE TRANSLATION TABLE;
C     THEN: LOAD THE KEYWRD WITH '*UNKNOWN' AND BRANCH TO WRITE.
C
      IF (KEY.LE.0) GOTO 36
      KEY=ITRSL2(KEY)
      GOTO 40
   36 CONTINUE
      KEYWRD=UNKNOW
      LOC=2
      GOTO 59
   40 CONTINUE
C
C     ELSE: LOAD KEYWRD WITH THE ACTUAL KEYWORD AND LOC WITH LOCATION
C     POINTER.
C
      LOC=(KEY/100)+1
      IF (KEY .LT. 200) THEN
        KEY=MOD(KEY,200)
      ELSE
        KEY=MOD(KEY,100)
      ENDIF
      GOTO (42,42,43,44,45,46,47,48,49,52,53,54,55,56,57,58,59),LOC
   42 CONTINUE
C
C     IF THE ACTIVITY CODE IS FOR A COMPUTE, THEN SET THE KEYWORD UP
C     TO BE THE VARIABLE NAME.
C
      IF (IACTK.EQ.33) THEN
         LOC=IFIX(PARMS(IACT(I,2)+1))
         IF (LOC.GT.500) LOC=LOC-500
         KEYWRD=CTSTV5(LOC)
         LOC=1
      ELSE
         KEYWRD=TABLE(KEY)
         LOC=2
      ENDIF
      GOTO 61
   43 CONTINUE
      CALL ESKEY(KEY,KEYWRD)
      GOTO 61
   44 CONTINUE
      CALL TMKEY(KEY,KEYWRD)
      GOTO 61
   45 CONTINUE
      CALL MPKEY(KEY,KEYWRD)
      GOTO 61
   46 CONTINUE
      CALL CVKEY(KEY,KEYWRD)
      GOTO 61
   47 CONTINUE
      CALL DBSKEY(KEY,KEYWRD)
      GOTO 61
   48 CONTINUE
      CALL CLKEY(KEY,KEYWRD)
      GO TO 61
   49 CONTINUE
C  ** free spot **
      GO TO 61
   52 CONTINUE
      CALL BRKEY (KEY,KEYWRD)
      GO TO 61
   53 CONTINUE
      CALL MISKEY (KEY,KEYWRD)
      GO TO 61
   54 CONTINUE
      CALL BWEKEY (KEY,KEYWRD)
      GO TO 61
   55 CONTINUE
      CALL DFBKEY (KEY,KEYWRD)
      GO TO 61
   56 CONTINUE
      CALL BMKEY (KEY,KEYWRD)
      GO TO 61
   57 CONTINUE
      CALL RDKEY (KEY,KEYWRD)
      GO TO 61
   58 CONTINUE
      CALL FMKEY (KEY,KEYWRD)
      GOTO 61
   59 CONTINUE
      CALL ECKEY (KEY,KEYWRD)
   61 CONTINUE
      J1=IACT(I,2)
C
C     IF THIS IS THE SECOND CALL (LFIRST=FALSE), BRANCH ALTERNATIVE
C     LOGIC TO WRITE ACTIVITY DISPOSITION.
C
      IF (.NOT.LFIRST) GOTO 100
C
C     J1 AND J2 POINT TO THE PARAMETERS FOR THE ACTIVITY.
C     IF THERE ARE PARAMETERS;
C     THEN: WRITE THE PARAMETERS ALONG WITH THE KEYWORD.
C
      IF (J1.LE.0) GOTO 90
      J2=IACT(I,3)
C
C     IF WRITTING THE COMPUTE'S, THEN ONLY WRITE 1 PARM.
C
      IF (LOC.EQ.1) J2=J1
      WRITE (JOSTND,60) TAB2(LOC),KEYWRD,IDT,(PARMS(J),J=J1,J2)
   60 FORMAT (T16,A4,T25,A8,I6,((T41,8F11.4)))
      GOTO 150
   90 CONTINUE
C
C     ELSE: WRITE WITHOUT THE PARAMETERS.
C
      WRITE (JOSTND,60) TAB2(LOC),KEYWRD,IDT
      GOTO 150
  100 CONTINUE
C
C     WRITE DISPOSITION ALONG WITH ACTIVITY.
C
      ID=IACT(I,4)
      K=0
      IF(ID.LE.0) K=ID+2
      IF(J1.LE.0) GOTO 95
      J2=IACT(I,3)
      IF (LOC.EQ.1) J2=J1
      IF(K.EQ.0) WRITE(JOSTND,91) TAB2(LOC),KEYWRD,IDT,ID,
     >           (PARMS(J),J=J1,J2)
   91 FORMAT (T16,A4,T25,A8,I6,'  DONE IN',I5,((T63,6F11.4)))
      IF(K.GT.0) WRITE(JOSTND,92) TAB2(LOC),KEYWRD,IDT,
     >           IDISPO(K),(PARMS(J),J=J1,J2)
   92 FORMAT (T16,A4,T25,A8,I6,2X,A20,((T63,6F11.4)))
      GOTO 140
   95 CONTINUE
      IF(K.EQ.0) WRITE(JOSTND,91) TAB2(LOC),KEYWRD,IDT,ID
      IF(K.GT.0) WRITE(JOSTND,92) TAB2(LOC),KEYWRD,IDT,
     >           IDISPO(K)
  140 CONTINUE
C
C     WRITE OUTPUT FOR CHEAPO
C
      CALL ECOPLS (KEYWRD,IACT(I,4),PARMS,J1,J2)
  150 CONTINUE
  160 CONTINUE
C
C     WRITE END-OF-TABLE
C
      WRITE (JOSTND,180)
  180 FORMAT (130('-'))
      RETURN
      END
