      SUBROUTINE EVMON (IPH,IPPCL)
      IMPLICIT NONE
C----------
C BASE $Id$
C----------
C
C     CALLED FROM TREGRO.
C     TASKS:
C     1) AGES EVENTS.
C     2) MAINTAINS TEST VARIABLE TABLES.
C     3) DETERMINES WHICH EVENTS OCCUR.
C     4) POSTS THE DATE EVENTS OCCUR.
C     5) SCHEDULES THE ACTIVITIES WHICH ARE TO FOLLOW AN EVENT.
C
C     EVENT MONITOR ROUTINE - NL CROOKSTON - AUG 1982 - MOSCOW, ID
C     MAJOR REWRITE IN JAN 1987 - NL CROOKSTON - MOSCOW.
C
C     IPH   = THE PROJECTION PHASE NUMBER...USED TO SET IPHASE.
C     IPPCL = FLAG CONTROLLING ACTIVITY GROUP PROCESSING.
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'OPCOM.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
COMMONS
C
C     MAE   = LENGTH OF MAELNK.
C     MAELNK= LIST OF ACTIVITY GROUPS THAT ARE ASSOCIATED WITH
C             AN EVENT THAT HAS MORE THAN ONE ACTIVITY GROUP
C             ASSOCIATED WITH IT.
C             (1,.)= POINTS TO THE ENTRY IN IEVACT, AGLSET, & LENAGL
C             (2,.)= POINTS TO THE ENTRY IN IEVNTS
C
C     IEVLST= A LIST OF EVENTS THAT OCCURRED THIS CYCLE.
C             (1,.)= THE EVENT NUMBER (A ROW IN IEVNTS)
C             (2,.)= FIRST ACTIVITY GROUP (A ROW IN IEVACT)
C             (3,.)= NUMBER OF ACTIVITY GROUPS (ROWS IN IEVACT)
C
      INTEGER IPPCL,IPH,MXPASS,MAELNK(2,50),IEVLST(3,25),MAE,IPASS
      INTEGER IALNK,NGRPS,I,J1,J2,J,IDEL,INOCC,JEVNT,II,NSCHDS
      INTEGER KODE,LENWRK,ISCHDS,NOCCRD,IEN,IRC,ACTF,CCCT
      PARAMETER (MXPASS=50)
      LOGICAL LDEB,LDEB2
C
C     SEE IF WE NEED WRITE DEBUG.
C
      CALL DBCHK (LDEB,'EVMON',5,ICYC)
C
      IPHASE=IPH
C
C     WRITE DEBUG OUTPUT, IF DESIRED.
C
      IF (LDEB) WRITE (JOSTND,5) IEVT,IPHASE,ICYC
    5 FORMAT (/' IN EVMON, IEVT=',I5,'; IPHASE=',I3,'; ICYC=',I3)
      CALL DBCHK (LDEB2,'ALGEVL',6,ICYC)
C
C     LOAD TEST VARIABLE TABLES
C
      IF (LEVUSE) CALL EVTSTV (0)
      MAE=0
C
C     IF NO EVENT MONITORING IS REQUESTED; THEN: RETURN.
C
      IF (IEVT.LE.1) GOTO 300
C
C     IF THIS IS A PHASE 2 CALL OR IF FIRST CYCLE; THEN: SKIP EVENT
C     AGEING.
C
      IF (.NOT.(IPHASE.GT.1 .OR. ICYC.EQ.1)) CALL EVAGE (IY(ICYC))
C     
C     LOOP THRU ALL OF THE EVENTS AND FIND OUT WHICH ONES OCCURRED.
C     LET NOCCRD BE THE NUMBER OF EVENTS THAT OCCURRED.
C
      IPASS=0
    6 CONTINUE
      NOCCRD=0
      DO 20 IEN=1,(IEVT-1)
C
C     IF THE EVENT STATUS CODE INDICATES THAT THE EVENT HAS ALREADY
C     OCCURRED, THEN SKIP THIS EVENT.
C

      IF (IEVNTS(IEN,2).GT.-1) GOTO 20
C
C     EVALUATE THE EXPRESSION.
C
      CALL ALGEVL (LREG,MXLREG,XREG,MXXREG,IEVCOD(IEVNTS(IEN,1)),
     >     MAXCOD-IEVNTS(IEN,1)+1,IY(1),IY(ICYC),LDEB2,JOSTND,IRC)
C
      IF (IRC.GT.1) CALL ERRGRO (.TRUE.,21)
      IF (LDEB) WRITE (JOSTND,10) IEN,IEVNTS(IEN,1),LREG(1),IRC
   10 FORMAT (' IN EVMON: IEN=',I3,' IEVNTS(IEN,1)=',I5,
     >        ' LREG(1),IRC=',L2,I4)
C
C     IF THE EVENT HAPPENED, LREG(1) BE TRUE AND THE RETURN CODE
C     WILL BE ZERO.
C
      IF (LREG(1) .AND. IRC.EQ.0) THEN
C
C        CALL EVPOST TO POST THE EVENT AND COUNT THE NUMBER OF
C        ACTIVITY GROUPS THAT FOLLOW THE EVENT.
C
         CALL EVPOST (JOSTND,IEN,IY(ICYC),NGRPS,IALNK)
C
C        BUILD AN ENTRY IN IEVLST
C
         NOCCRD=NOCCRD+1
         IEVLST(1,NOCCRD)=IEN
         IEVLST(2,NOCCRD)=IALNK
         IEVLST(3,NOCCRD)=NGRPS
C
C        WRITE DEBUG, IF REQUESTED.
C
         IF (LDEB) WRITE (JOSTND,15) NOCCRD,IEN,IALNK,NGRPS
   15    FORMAT (' IN EVMON: NOCCRD,IEN,IALNK,NGRPS=',4I5)
      ENDIF
   20 CONTINUE
      IF (LDEB) WRITE (JOSTND,'(/'' IN EVMON: NOCCRD='',I5)') NOCCRD
C
C     IF NO EVENTS OCCURRED, THEN BRANCH TO EXIT.
C
      IF (NOCCRD.EQ.0) GOTO 300
C
C     COUNT UP THE NUMBER OF ACTIVITY GROUPS THAT FOLLOW EVENTS THAT
C     HAVE MORE THAN ONE ACTIVITY GROUP ASSOCIATED WITH THEM.
C
      DO 40 I=1,NOCCRD
      IF (IEVLST(3,I).GT.1) THEN
         J1=IEVLST(2,I)
         J2=IEVLST(3,I)+J1-1
         DO 30 J=J1,J2
         MAE=MAE+1
         MAELNK(1,MAE)=J
         MAELNK(2,MAE)=IEVLST(1,I)
   30    CONTINUE
      ENDIF
   40 CONTINUE
C
C     WRITE SOME DEBUG.
C
      IF (LDEB) WRITE (JOSTND,'(/'' IN EVMON: NOCCRD,MAE= '',2I5)')
     >                NOCCRD,MAE
C
C     IF THERE ARE NONE, THEN BRANCH PAST LOGIC THAT ATTEMPTS TO
C     DELETE THEM.
C
      IF (MAE.LE.0) GOTO 100
C
C     WRITE SOME MORE DEBUG.
C
      IF (LDEB) WRITE (JOSTND,50) (I,MAELNK(1,I),MAELNK(2,I),I=1,MAE)
   50 FORMAT (' IN EVMON(50): MAELNK(1&2,',I3,')= ',2I5)
C
C     IF LABEL PROCESSING IS BEING USED, TRIM THE LIST USING THE
C     LABEL LOGIC.
C
      IF (LBSETS) THEN
         IF (LDEB) WRITE (JOSTND,60)  LENSLS,SLSET(1:LENSLS),
     >      (I,MAELNK(1,I),MAELNK(2,I),AGLSET(MAELNK(1,I))
     >      (1:LENAGL(MAELNK(1,I))),I=1,MAE)
  60     FORMAT (' IN EVMON, BEFORE LBTRIM, LENSLS=',I4,' SLSET= '/T12,
     >          A/((T12,'MAELNK(1:2,',I2,')= ',2I5,' AGLSET='/,T12,A)))
         CALL LBTRIM (MAE,MAELNK)
C
C        IF ALL OF THE ACTIVITY GROUPS HAVE BEEN DELETED, THEN
C        BRANCH PAST THE OPSAME CHECK.
C
         IF (MAE.LE.0) GOTO 100
         IF (LDEB) WRITE (JOSTND,70) (I,MAELNK(1,I),
     >                                  MAELNK(2,I),I=1,MAE)
   70    FORMAT (' IN EVMON(70): MAELNK(1:2,',I2,')= ',2I5)
      ENDIF
C
C     TRIM THE LIST FURTHER BY DELETING DUPLICATE GROUPS OF ACTIVITIES
C
      CALL OPSAME (MAE,MAELNK,JOSTND,LDEB)
C
  100 CONTINUE
C
C     IF IPPCL IS EQUAL TO 2,
C     THEN GO THROUGH THE LIST OF EVENTS THAT HAVE MORE THAN
C     ONE ACTIVITY GROUP.  IF THE EVENT IS NO LONGER LISTED
C     IN MAELNK, THEN DELETE THE ENTRY IN IEVLST. IF THE EVENT
C     IS IN MAELNK, SET THE ENTRY IN IEVLST TO THE FIRST
C     ACTIVITY GROUP AND SET THE NUMBER OF GROUPS TO ONE.
C
      IF (IPPCL.EQ.2) THEN
         IDEL=0
         DO 140 INOCC=1,NOCCRD
         IF (IEVLST(3,INOCC).EQ.1) GOTO 140
         JEVNT=IEVLST(1,INOCC)
         J1=0
         IF (MAE.EQ.0) GOTO 130
         DO 120 II=1,MAE
         IF (MAELNK(2,INOCC).EQ.JEVNT) THEN
            J1=II
            GOTO 130
         ENDIF
  120    CONTINUE
  130    CONTINUE
         IF (J1.EQ.0) THEN
            IDEL=IDEL+1
            IEVLST(1,INOCC)=0
         ELSE
C
C           SET THE ACTIVITY CODE NEGITIVE THEREBY SIGNALING THAT
C           LABEL PROCESSING, ETC, FOR THIS OPTION IS DONE.
C
            IEVLST(2,INOCC)=-MAELNK(1,J1)
            IEVLST(3,INOCC)=1
         ENDIF
  140    CONTINUE
C
C        DELETE ENTRIES IN IEVLST, IF NECESSARY
C
         IF (IDEL.GT.0) THEN
            IF (IDEL.EQ.NOCCRD) THEN
               NOCCRD=0
            ELSE
               IDEL=NOCCRD+1
               DO 160 INOCC=1,NOCCRD
               IF (IEVLST(1,INOCC).EQ.0) THEN
                  IDEL=IDEL-1
                  DO 150 J1=1,3
                  IEVLST(J1,INOCC)=IEVLST(J1,IDEL)
  150             CONTINUE
               ENDIF
  160          CONTINUE
               NOCCRD=IDEL
            ENDIF
         ENDIF
      ENDIF
C
C     INITIALIZE THE NUMBER OF ACTIVITY GROUPS THAT HAVE BEEN
C     SCHEDULED AND LOOP THRU ALL OF THE EVENTS THAT OCCURRED.
C
      NSCHDS=0
      IF (NOCCRD.EQ.0) GOTO 210
      DO 200 INOCC=1,NOCCRD
      IF (LDEB) WRITE (JOSTND,170) INOCC,(IEVLST(I,INOCC),I=1,3)
  170 FORMAT (' IN EVMON: IEVLST(1:3,',I3,')= ',3I4)
C
C     IF THE ACTIVITY GROUP NUMBER IN IEVLST IS NEG, SET IT POSITIVE
C     AND BRANCH TO SCHEDULE ACTIVITIES
C
      IF (IEVLST(2,INOCC).LT.0) THEN
         IEVLST(2,INOCC)=-IEVLST(2,INOCC)
         IALNK=IEVLST(2,INOCC)
         GOTO 190
      ENDIF
      IALNK=IEVLST(2,INOCC)
C
C     IF LABEL PROCESSING IS TURNED ON, THEN PROCESS LABELS TO
C     DETERMINE IF THE ACTIVITIES WILL BE SCHEDULED.
C
      IF (LBSETS) THEN
         IF (LDEB) WRITE (JOSTND,'(/'' IN EVMON: LENSLS='',I5,
     >                    '' SLSET= '',A)') LENSLS,SLSET(:LENSLS)
C
C        IF THE ACTIVITY GROUP LABEL WAS SET (LENAGL>-1), THEN
C        COMPUTE THE INTERSECTION OF THE ACTIVITY GROUP LABEL AND THE
C        STAND LABEL.
C
         IF (LENAGL(IALNK).GT.-1) THEN
            IF (LDEB) WRITE (JOSTND,180) IALNK,
     >                      AGLSET(IALNK)(1:LENAGL(IALNK))
  180       FORMAT (' IN EVMON: IALNK=',I3,' AGLSET=',A)
            CALL LBINTR (LENAGL(IALNK),AGLSET(IALNK),LENSLS,SLSET,
     >                   LENWRK,WKSTR1,KODE)
C
C           IF THE RESULT IS THE NULL SET, DO NOT SCHEDULE THE
C           ACTIVITY GROUP.
C
            IF (LENWRK.EQ.0) GOTO 200
          ENDIF
      ENDIF
  190 CONTINUE
C
C     SCHEDULE THE ACTIVITY GROUP.
C
      CALL OPSCHD (IY(ICYC),IEVACT(IALNK,4),IEVACT(IALNK,5),
     >             ISCHDS,KODE)
      IF (LDEB) WRITE (JOSTND,195) ICYC,IY(ICYC),IALNK,IEVACT(IALNK,4),
     >          IEVACT(IALNK,5),ISCHDS,KODE
  195 FORMAT (/' IN EVMON: ICYC=',I3,' IY(ICYC)=',I5,' IALNK=',I5,
     >         ' IEVACT(IALNK,4:5)=',2I5,' ISCHDS=',I4,' KODE=',I3)

      IF (KODE.GE.2) THEN
C
C        FLAG THE ACTIVITY GROUP THAT AN ATTEMPT TO SCHEDULE HAS
C        FAILED, AND DELETE THE EVENT.
C
         IEVACT(IALNK,2)=-1
         IEVNTS(IEVLST(1,INOCC),3)=-1
         CALL ERRGRO (.TRUE.,18)
         GOTO 210
      ENDIF
C
C     SET THE SCHEDULING CODE FOR THIS ACTIVITY GROUP
C
      IEVACT(IALNK,2)=2
C
C     COUNT THE NUMBER OF ALTERNATIVES ACTUALLY SCHEDULED.
C
      NSCHDS=NSCHDS+ISCHDS
  200 CONTINUE
  210 CONTINUE
      IF (LDEB) WRITE (JOSTND,'(/'' IN EVMON: NSCHDS='',I5)') NSCHDS
C
C     IF ONE OR MORE ACTIVITIES WERE SCHEDULED, INCORPORATE THEM INTO
C     THE ACTIVITY ARRAYS AND RECALL EVTSTV TO RECOMPUTE USER DEFINED
C     VARIABLES.
C
      IF (NSCHDS.GT.0) THEN
         CALL OPINCR (IY,ICYC,NCYC)
         CALL EVTSTV (1)
         IPASS = IPASS+1
         IF (LDEB) WRITE (JOSTND,'('' IN EVMON: IPASS='',I5)') IPASS
         IF (IPASS.LE.MXPASS) GOTO 6
      ENDIF
C
  300 CONTINUE
C      
C     IF CCADJ IS CONDITIONALLY SCHEDULED, CALL SSTAGE FROM HERE
C
      CCCT=0  
      DO ACTF=1,MAXACT
        IF((IACT(ACTF,1).EQ.444))THEN
          CCCT=CCCT+1  
        ENDIF
      END DO                  
      IF(CCCT.GE.1)CALL SSTAGE(1,ICYC,.TRUE.)         
C           
      RETURN
      END
