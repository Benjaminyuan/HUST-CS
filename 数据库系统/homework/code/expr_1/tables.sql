CREATE TABLE Station (
                         SID int auto_increment,
                         SName char(20),
                         CityName char(20),
                         PRIMARY KEY(SID)
)engine=innodb,charset=utf8mb4;

-- Station SID发生变化的时候级联操作
CREATE TABLE Train (
                       TID int auto_increment,
                       SDate date NOT NULL,
                       TName char(20) NOT NULL,
                       SStationID int NOT NULL,
                       AStationID int NOT NULL,
                       STime datetime NOT NULL,
                       ATime datetime NOT NULL,
                       PRIMARY KEY(TID),
                       FOREIGN KEY(SStationID) REFERENCES Station(SID)
                           ON UPDATE CASCADE
                           ON DELETE CASCADE,
                       FOREIGN KEY(AStationID) REFERENCES Station(SID)
                           ON UPDATE CASCADE
                           ON DELETE CASCADE,
                       INDEX idx_sdate(SDate),
                       INDEX idx_tname(TName)
)engine=innodb,charset=utf8mb4;
-- alter table Train modify COLUMN  TName char(20) NOT NULL ;
-- create index idx_tname on Train(TName);
-- alter TABLE Train MODIFY COLUMN SDate date NOT NULL;
-- alter TABLE Train ADD UNIQUE
-- ALTER TABLE Train MODIFY COLUMN STime datetime NOT NULL;
-- ALTER TABLE Train MODIFY COLUMN ATime datetime NOT NULL;
-- ALTER TABLE Train MODIFY COLUMN SStationID int NOT NULL;
-- ALTER TABLE Train MODIFY COLUMN AStationID int NOT NULL;
-- ALTER TABLE Train ADD CONSTRAINT fro_AStationID
-- FOREIGN KEY(AStationID) REFERENCES Station(SID) ;
-- ALTER TABLE Persons ADD CHECK (Age>=18) show INDEX FROM Train;
CREATE TABLE TrainPass (
                           TID int NOT NULL  auto_increment comment '列车流水号',
                           SNo smallint NOT NULL comment '序号',
                           SID int NOT NULL  comment '站点',
                           STime datetime NOT NULL comment '到达时间',
                           ATime datetime NOT NULL comment '出发时间',
                           PRIMARY KEY(TID,SNo),
                           FOREIGN KEY(SID) REFERENCES Station(SID)
)engine=innodb,charset=utf8mb4;

CREATE TABLE Passenger (
                           PCardID char(18) NOT NULL,
                           PName char(20) NOT NULL ,
                           Sex bit NOT NULL,
                           Age smallint CONSTRAINT c_age CHECK (Age > 0 AND Age < 150),
                           PRIMARY KEY(PCardID),
                           INDEX idx_pname(PName)
)engine=innodb,charset=utf8mb4;

CREATE TABLE TakeTrainRecord (
                                 RID int auto_increment,
                                 PCardID char(18) NOT NULL,
                                 TID int NOT NULL,
                                 SStationID int NOT NULL,
                                 AStationID int NOT NULL,
                                 CarrigeID smallint DEFAULT NULL,
                                 SeatRow smallint,
                                 SeatNo char(1) CONSTRAINT c1 CHECK (SeatNo IN ('A','B','C','D','E','F') OR SeatNo = NULL),
                                 SStatus int CONSTRAINT c2 CHECK (SStatus BETWEEN 0 AND 2),
                                 PRIMARY KEY(RID),
                                 FOREIGN KEY(PCardID) REFERENCES Passenger(PCardID) ON UPDATE CASCADE
                                     ON DELETE CASCADE,
                                 FOREIGN KEY(TID) REFERENCES Train(TID) on UPDATE CASCADE ON DELETE CASCADE,
                                 FOREIGN KEY(SStationID) REFERENCES Station(SID) ON UPDATE CASCADE ON DELETE CASCADE,
                                 FOREIGN KEY(AStationID) REFERENCES Station(SID) ON UPDATE CASCADE ON DELETE CASCADE
)engine=innodb,charset=utf8mb4;

CREATE TABLE DiagnoseRecord(
                               DID int auto_increment,
                               PCardID char(18),
                               DDay date comment '诊断日期',
                               DStatus smallint CONSTRAINT c3 CHECK(DStatus BETWEEN 1 AND 3),
                               FDay date comment '发病日期',
                               PRIMARY KEY(DID),
                               FOREIGN KEY(PCardID)  REFERENCES Passenger(PCardID) ON DELETE CASCADE ON UPDATE CASCADE
)engine=innodb,charset=utf8mb4;

CREATE TABLE TrainContactor(
                               CDate date,
                               CCardID char(18),
                               DStatus smallint,
                               PCardID char(18),
                               FOREIGN KEY(CCardID) REFERENCES Passenger(PCardID) ON UPDATE CASCADE ON DELETE CASCADE,
                               FOREIGN KEY(PCardID) REFERENCES Passenger(PCardID) ON UPDATE CASCADE ON DELETE CASCADE
)engine=innodb,charset=utf8mb4;

INSERT INTO Station(SName, CityName) VALUES ('武汉站','武汉');
INSERT INTO Station(SName, CityName) VALUES ('郑州南站','郑州');
INSERT INTO Station(SName, CityName) VALUES ('石家庄北站','石家庄');
INSERT INTO Station(SName, CityName) VALUES ('保定站','保定');
INSERT INTO Station(SName, CityName) VALUES ('北京南站','北京');
INSERT INTO Station(SName, CityName) VALUES ('广州南站','广州');
INSERT INTO Station(SName, CityName) VALUES ('衡阳南站','衡阳');
INSERT INTO Station(SName, CityName) VALUES ('株洲南站','株洲');
# 广州出发的列车
INSERT INTO Train values(null,'2020-1-20','广州一号',8,7,'2020-1-20 09:00:00','2020-1-20 20:00:00');
#广州
INSERT INTO TrainPass values(1,1,8,'2020-1-20 08:55:00','2020-1-20 09:00:00');
# 衡阳
INSERT INTO TrainPass values(1,2,9,'2020-1-20 10:00:00','2020-1-20 10:05:00');
# 郴州
INSERT INTO TrainPass values(1,3,1,'2020-1-20 10:50:00','2020-1-20 10:55:00');
#长沙
INSERT INTO TrainPass values(1,4,2,'2020-1-20 12:55:00','2020-1-20 13:00:00');
#武汉
INSERT INTO TrainPass values(1,5,3,'2020-1-20 14:40:00','2020-1-20 14:45:00');
#石家庄
INSERT INTO TrainPass values(1,6,5,'2020-1-20 17:40:00','2020-1-20 17:50:00');
#北京
INSERT INTO TrainPass values(1,7,7,'2020-1-20 20:00:00','2020-1-20 20:00:00');


INSERT INTO Train values(null,'2020-1-22','广州一号',8,7,'2020-1-22 09:00:00','2020-1-22 20:00:00');
#广州
INSERT INTO TrainPass values(2,1,8,'2020-1-22 08:55:00','2020-1-22 09:00:00');
# 衡阳
INSERT INTO TrainPass values(2,2,9,'2020-1-22 10:00:00','2020-1-22 10:05:00');
# 郴州
INSERT INTO TrainPass values(2,3,1,'2020-1-22 10:50:00','2020-1-22 10:55:00');
#长沙
INSERT INTO TrainPass values(2,4,2,'2020-1-22 12:55:00','2020-1-22 13:00:00');
#武汉
INSERT INTO TrainPass values(2,5,3,'2020-1-22 14:40:00','2020-1-22 14:45:00');
#石家庄
INSERT INTO TrainPass values(2,6,5,'2020-1-22 17:40:00','2020-1-22 17:50:00');
#北京
INSERT INTO TrainPass values(2,7,7,'2020-1-22 20:00:00','2020-1-22 20:00:00');

INSERT INTO Train values(null,'2020-1-22','衡阳一号',9,7,'2020-1-22 09:00:00','2020-1-22 19:00:00');
# 衡阳
INSERT INTO TrainPass values(3,1,9,'2020-1-22 08:55:00','2020-1-22 09:00:00');
# 郴州
INSERT INTO TrainPass values(3,2,1,'2020-1-22 10:00:00','2020-1-22 10:05:00');
#长沙
INSERT INTO TrainPass values(3,3,2,'2020-1-22 12:05:00','2020-1-22 12:15:00');
#武汉
INSERT INTO TrainPass values(3,4,3,'2020-1-22 15:55:00','2020-1-22 16:05:00');
#石家庄
INSERT INTO TrainPass values(3,5,5,'2020-1-22 18:00:00','2020-1-22 18:05:00');
#北京
INSERT INTO TrainPass values(3,6,7,'2020-1-22 19:00:00','2020-1-22 19:00:00');


INSERT INTO Train values(null,'2020-1-21','衡阳一号',9,7,'2020-1-21 09:00:00','2020-1-21 19:00:00');
# 衡阳
INSERT INTO TrainPass values(4,1,9,'2020-1-21 08:55:00','2020-1-21 09:00:00');
# 郴州
INSERT INTO TrainPass values(4,2,1,'2020-1-21 10:00:00','2020-1-21 10:05:00');
#长沙
INSERT INTO TrainPass values(4,3,2,'2020-1-21 12:05:00','2020-1-21 12:15:00');
#武汉
INSERT INTO TrainPass values(4,4,3,'2020-1-21 15:55:00','2020-1-21 16:05:00');
#石家庄
INSERT INTO TrainPass values(4,5,5,'2020-1-21 18:00:00','2020-1-21 18:05:00');
#北京
INSERT INTO TrainPass values(4,6,7,'2020-1-21 19:00:00','2020-1-21 19:00:00');

INSERT INTO Train values(null,'2020-1-22','武汉一号',3,7,'2020-1-22 09:00:00','2020-1-22 14:30:00');
#武汉
INSERT INTO TrainPass values(5,1,3,'2020-1-22 08:55:00','2020-1-22 09:00:00');
#郑州
INSERT INTO TrainPass values(5,2,4,'2020-1-22 11:05:00','2020-1-22 11:10:00');
#石家庄
INSERT INTO TrainPass values(5,3,5,'2020-1-22 12:35:00','2020-1-22 12:45:00');
#保定
INSERT INTO TrainPass values(5,4,6,'2020-1-22 13:25:00','2020-1-22 13:30:00');
#北京
INSERT INTO TrainPass values(5,5,7,'2020-1-22 14:30:00','2020-1-22 14:30:00');


INSERT INTO Train values(null,'2020-1-20','武汉一号',3,7,'2020-1-20 09:00:00','2020-1-20 14:30:00');
#武汉
INSERT INTO TrainPass values(6,1,3,'2020-1-20 08:55:00','2020-1-20 09:00:00');
#郑州
INSERT INTO TrainPass values(6,2,4,'2020-1-20 11:05:00','2020-1-20 11:10:00');
#石家庄
INSERT INTO TrainPass values(6,3,5,'2020-1-20 12:35:00','2020-1-20 12:45:00');
#保定
INSERT INTO TrainPass values(6,4,6,'2020-1-20 13:25:00','2020-1-20 13:30:00');
#北京
INSERT INTO TrainPass values(6,5,7,'2020-1-20 14:30:00','2020-1-20 14:30:00');

INSERT INTO Train values(null,'2020-1-20','广州一号',8,3,'2020-1-20 09:00:00','2020-1-20 20:00:00');

INSERT INTO Passenger values('431081198905103354','张三',1,31);
INSERT INTO Passenger values('420081199907233126','朱佳琪',0,21);
INSERT INTO Passenger values('434081199503248335','王五',1,25);
INSERT INTO Passenger values('411081199905103294','李小胖',1,30);
INSERT INTO Passenger values('432081199905106363','陈丽丽',0,21);
INSERT INTO Passenger values('431081199905106363','陈一一',1,21);
INSERT INTO Passenger values('437081199905106163','李二二',0,21);
INSERT INTO Passenger values('439081199905106060','范三三',1,21);
INSERT INTO Passenger values('419081199905106062','许涛',1,21);
INSERT INTO Passenger values('459081199905106064','赵六六',0,21);
INSERT INTO Passenger values('420081199905106064','李七七',1,21);
INSERT INTO Passenger values('410081199905106362','朱八八',1,21);

INSERT INTO TakeTrainRecord VALUES (null,411081199905103294,1,8,7,14,5,'F',1);
INSERT INTO TakeTrainRecord VALUES (null,411081199905103294,5,3,7,13,6,'E',1);
INSERT INTO TakeTrainRecord VALUES (null,411081199905103294,2,8,6,11,1,'A',1);
INSERT INTO TakeTrainRecord VALUES (null,432081199905106363,5,3,7,7,5,'D',1);
INSERT INTO TakeTrainRecord VALUES (null,434081199503248335,5,3,7,6,4,'C',2);
# 乘车表的CURD
INSERT INTO TakeTrainRecord VALUES (null,420081199907233126,3,1,7,11,1,'B',0);

INSERT INTO TakeTrainRecord VALUES (null,419081199905106062,2,1,7,11,1,'B',1);
INSERT INTO TakeTrainRecord VALUES (null,420081199907233126,3,3,7,11,1,'C',1);
INSERT INTO TakeTrainRecord VALUES (null,420081199907233126,4,1,7,11,1,'D',1);
INSERT INTO TakeTrainRecord VALUES (null,420081199907233126,5,3,7,11,1,'F',1);

INSERT INTO TakeTrainRecord VALUES (null,420081199905106064,2,3,7,11,1,'F',1);
INSERT INTO TakeTrainRecord VALUES (null,419081199905106062,3,3,7,9,2,'A',1);
INSERT INTO TakeTrainRecord VALUES (null,420081199905106064,5,3,7,8,3,'C',1);
update TakeTrainRecord set AStationID=5 where PCardID=420081199905106064;
INSERT INTO TakeTrainRecord VALUES (null,459081199905106064,2,3,7,9,2,'D',1);
INSERT INTO TakeTrainRecord VALUES (null,459081199905106064,1,8,7,1,5,'F',1);
INSERT INTO TakeTrainRecord VALUES (null,431081198905103354,4,9,7,12,5,'E',1);
INSERT INTO TakeTrainRecord VALUES (null,410081199905106362,2,3,6,13,2,'E',1);
INSERT INTO TakeTrainRecord VALUES (null,410081199905106362,1,3,6,13,2,'D',1);
INSERT INTO TakeTrainRecord VALUES (null,410081199905106362,2,1,3,13,2,'D',1);

INSERT INTO DiagnoseRecord VALUES (null,'459081199905106064','2020-1-22',1,'2020-1-18');
INSERT INTO DiagnoseRecord VALUES (null,'420081199905106064','2020-1-20',1,'2020-1-17');
INSERT INTO DiagnoseRecord VALUES (null,'431081198905103354','2020-1-20',1,'2020-1-17');
UPDATE DiagnoseRecord set DDay='2020-1-27',FDay='2020-1-24' where PCardID = '431081198905103354';
UPDATE TakeTrainRecord SET SeatNo='F' WHERE PCardID = 411081199905103294 AND SStationID=8 AND AStationID=7;
DELETE from TakeTrainRecord where RID = 6;


SELECT * from TakeTrainRecord where SStationID=3;
# 批处理操作
INSERT INTO WH_TakeTrainRecord SELECT * from TakeTrainRecord where SStationID=3;

select * from WH_TakeTrainRecord;

# dump数据
#  mysqldump -uroot -p123456 > ./test.sql;
#  use database;
#  source test.sql;
CREATE VIEW  patient_train_record AS
SELECT ttr.PCardID as 'PCardID',p.PName as 'Name',
       p.Age as 'Age', ttr.TID as 'TID',t.SDate as 'SDate',
       ttr.CarriageID,ttr.SeatRow,ttr.SeatNo
from TakeTrainRecord as ttr,DiagnoseRecord as dr,Passenger as p,Train as t
where ttr.PCardID = dr.PCardID
  AND dr.DStatus = 1
  AND p.PCardID = ttr.PCardID
  AND ttr.TID = t.TID
  AND ttr.SStatus = 1 ORDER BY ttr.PCardID ASC ,SDate DESC;
select * from patient_train_record;

CREATE TRIGGER diagnose_trigger AFTER  INSERT ON DiagnoseRecord FOR EACH ROW
BEGIN
    INSERT INTO TrainContactor
    SELECT Train.SDate,ttr.PCardID,2, patient_train_record.PCardID from
                                                                       TakeTrainRecord as ttr,Train,(SELECT * from TakeTrainRecord
                                                                                                     where
                                                                                                             TakeTrainRecord.PCardID = NEW.PCardID)
            as patient_train_record
                                                                       #同一车次
    where patient_train_record.TID = ttr.TID
      AND  patient_train_record.TID = Train.TID
      # 14天之内
      AND  DATEDIFF(NEW.FDay,Train.SDate) <= 14
      # 同一车厢
      AND patient_train_record.CarriageID = ttr.CarriageID
      #排除自己本身
      AND  ttr.PCardID != patient_train_record.PCardID
      #上车了
      AND ttr.SStatus = 1
      # 同排或者前后
      AND (patient_train_record.SeatRow = ttr.SeatRow
        OR patient_train_record.SeatRow -1 = ttr.SeatRow
        OR  patient_train_record.SeatRow + 1 = ttr.SeatRow );
    UPDATE TrainContactor set DStatus = 1 WHERE PCardID = NEW.PCardID;
end;
# 三查询
#查询确诊者“张三”的在发病前14天内的乘车记录;
SELECT Passenger.PCardID,DDay from DiagnoseRecord , Passenger WHERE
        DiagnoseRecord.PCardID = Passenger.PCardID AND  Passenger.PName='张三';

SELECT * from TakeTrainRecord , ( SELECT Passenger.PCardID,FDay from DiagnoseRecord , Passenger WHERE
        DiagnoseRecord.PCardID = Passenger.PCardID AND  Passenger.PName='张三') as t1, Train
WHERE  t1.PCardID = TakeTrainRecord.PCardID
  AND TakeTrainRecord.TID =  Train.TID
  AND TakeTrainRecord.SStatus = 1
  AND DATEDIFF(t1.FDay,Train.SDate) >= 0 AND DATEDIFF(t1.FDay,Train.SDate) <= 14;

#查询所有从城市“武汉”出发的乘客乘列车所到达的城市名；
SELECT DISTINCT CityName from Station,(SELECT AStationID from TakeTrainRecord, Station WHERE Station.CityName='武汉' AND Station.SID = TakeTrainRecord.SStationID) AS t1
WHERE t1.AStationID = SID;

# 计算每位新冠患者从发病到确诊的时间间隔（天数）及患者身份信息，并将结果按照发病时间天数的降序排列；
SELECT DATEDIFF(DDay,FDay) as days FROM  DiagnoseRecord order by days DESC ;
# 4）查询“2020-01-22”从“武汉”发出的所有列车；

SELECT TID,TName from Train,Station where SStationID = SID AND CityName = '武汉' AND Train.SDate = '2020-01-22';
# 查询“2020-01-22”途经“武汉”的所有列车；
SELECT Train.TID,TName from Train join (SELECT TID,Station.SID from TrainPass,Station where  TrainPass.SID = Station.SID AND CityName = '武汉' AND DATEDIFF(TrainPass.STime,'2020-01-22') = 0 )
    AS T1 ON T1.TID = Train.TID  WHERE Train.SStationID != T1.SID ;

#先找从武汉坐车去其他地方的人，然后再查询其中是2020-1-22 到过武汉的列车
SELECT TID,SID,PCardID FROM TakeTrainRecord,Station where TakeTrainRecord.SStationID = Station.SID AND CityName='武汉';

SELECT Station.CityName,count(*) as person FROM  TrainPass,Passenger,Station,
                                                 (SELECT TID,SID,PCardID,AStationID FROM TakeTrainRecord,Station
                                                  where TakeTrainRecord.SStationID = Station.SID
                                                    AND TakeTrainRecord.SStatus = 1
                                                    AND CityName='武汉') as t1
where TrainPass.TID = t1.TID
  AND t1.SID = TrainPass.SID
  AND  DATEDIFF('2020-1-22',TrainPass.STime) = 0
  AND t1.PCardID = Passenger.PCardID
  AND t1.AStationID = Station.SID
group by Station.CityName;
# 查询2020年1月到达武汉的所有人员；
SELECT DISTINCT Passenger.PCardID,Passenger.PName,Passenger.Age,Passenger.Sex
FROM Passenger,(SELECT PCardID from TakeTrainRecord,Station,TrainPass
                where TakeTrainRecord.AStationID = Station.SID
                  AND CityName='武汉'
                  AND TrainPass.TID = TakeTrainRecord.TID
                  AND TakeTrainRecord.SStatus = 1
                  AND datediff(TrainPass.ATime,'2020-01-01') >= 0
                  AND datediff(TrainPass.ATime,'2020-01-31') <=0) as t1
WHERE t1.PCardID = Passenger.PCardID;
# 查询2020年1月乘车途径武汉的外地人员（身份证非“420”开头）；
SELECT DISTINCT Passenger.PCardID,Passenger.PName from Passenger,
                                                       (SELECT PCardID FROM TakeTrainRecord as t1,Station,TrainPass
                                                        WHERE
                                                          # 武汉
                                                                TrainPass.TID = t1.TID
                                                          AND TrainPass.SID = Station.SID
                                                          AND Station.CityName = '武汉'
                                                          AND TrainPass.SNo != 1
                                                          AND TrainPass.SNo > (SELECT SNo FROM TrainPass WHERE t1.TID = TrainPass.TID AND t1.SStationID = TrainPass.SID)
                                                          AND TrainPass.SNo < (SELECT SNo FROM TrainPass WHERE t1.TID = TrainPass.TID AND t1.AStationID = TrainPass.SID)
                                                          AND datediff(TrainPass.ATime,'2020-01-01') >= 0
                                                          AND datediff(TrainPass.ATime,'2020-01-31') <=0
                                                       ) as t1
WHERE t1.PCardID = Passenger.PCardID  AND t1.PCardID NOT LIKE '420%'
;
# 10）统计“2020-01-22”乘坐过‘G007’号列车的新冠患者在火车上的密切接触乘客人数（每位新冠患者的同车厢人员都算同车密切接触）。
SELECT count(t2.PCardID) from DiagnoseRecord,TakeTrainRecord,Train,TakeTrainRecord as t2
where DiagnoseRecord.PCardID = TakeTrainRecord.PCardID
  AND Train.TName = 'G007'
  AND Train.TID = TakeTrainRecord.TID
  AND datediff(Train.SDate,'2020-01-22') = 0
  AND t2.TID = Train.TID
  AND TakeTrainRecord.CarriageID = t2.CarriageID;

# 11）查询一趟列车的一节车厢中有3人及以上乘客被确认患上新冠的列车名、出发日期，车厢号；
SELECT TName,SDate,CarriageID from Train,(SELECT TID,CarriageID,COUNT(*) as 'diagnose_num' from TakeTrainRecord,DiagnoseRecord
                                          WHERE DiagnoseRecord.PCardID = TakeTrainRecord.PCardID
                                          group by TakeTrainRecord.TID,TakeTrainRecord.CarriageID) as t1
WHERE Train.TID = t1.TID;

#）查询没有感染任何周边乘客的新冠乘客的身份证号、姓名、乘车日期；
SELECT Passenger.PCardID,Passenger.PName,Train.SDate from DiagnoseRecord,TakeTrainRecord,Passenger,Train
                                                          # 新冠肺炎患者
WHERE DiagnoseRecord.PCardID = TakeTrainRecord.PCardID
  # 被接触的同时确诊的
  AND  DiagnoseRecord.PCardID not in (SELECT DISTINCT PCardID from TrainContactor where TrainContactor.DStatus = '1')
  AND Passenger.PCardID = TakeTrainRecord.PCardID
  AND Train.SDate;

# 查询到达 “北京”、或“上海”，或“广州”（即终点站）的列车名，要求where子句中除了连接条件只能有一个条件表达式；
select distinct Train.TName from Train,Station
WHERE Train.AStationID = Station.SID
  AND Station.CityName IN ('北京','上海','广州');

select distinct a1.PCardID,a1.TID
from TakeTrainRecord a1,TakeTrainRecord a2,Train b1,Train b2,Station c1,Station c2
where a1.TID=a2.TID and a1.TID=b1.TID  and a2.TID=b2.TID and a1.SStationID=c1.SID and a2.SStationID=c2.SID
  and c1.SName='武汉' and c2.SName!='武汉' and DATEDIFF(b1.STime,'2020-01-22')=0
  and DATEDIFF(b2.STime,'2020-01-22')=0
order by a1.TID;

select a.PCardID,b.PName,c.TName,c.STime
from DiagnoseRecord a,Passenger b,Train c,TakeTrainRecord d
where a.PCardID=b.PCardID and a.PCardID=d.PCardID and d.TID=c.TID
  and YEAR(c.STime) - YEAR('2020')=0;

SELECT DiagnoseRecord.FDay,DiagnoseRecord.DDay,count(DiagnoseRecord.DDay) as 'person_nums'
FROM DiagnoseRecord
GROUP BY  DiagnoseRecord.DDay,DiagnoseRecord.FDay
ORDER BY DiagnoseRecord.DDay DESC