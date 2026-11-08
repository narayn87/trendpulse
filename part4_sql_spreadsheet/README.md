# Part 4: SQL and Spreadsheets

## Prepare the CSV tables

The raw GB, IN, and US trending files and `categories.csv` are stored in this
Part's `data/` folder. From the repository root, run:

```bash
python -m pip install -r part4_sql_spreadsheet/requirements.txt
python part4_sql_spreadsheet/prepare_data.py
```

The Pandas script prepares three import-ready tables in the same folder:

- `categories_clean.csv`: distinct category IDs and names, sorted by ID.
- `videos.csv`: one row per unique `video_id`, containing video metadata and
  `category_id`.
- `trending_records.csv`: one row per video, country, and trending date,
  containing views, likes, dislikes, and comment counts.

The script concatenates the three country files with a `country` column,
removes duplicate `(country, video_id, trending_date)` rows, excludes records
flagged as removed or erroneous, and checks that every video category has a
category-table entry. Video metadata is consistent across country records for
the same video ID; the script keeps one deterministic copy. Dates in
`trending_records.csv` are converted from `yy.dd.mm` to ISO `YYYY-MM-DD`.
Missing likes and comment counts remain missing rather than being replaced
with zero.

The prepared tables contain 17 categories, 14,688 videos, and 45,908 trending
records. The script can be rerun to regenerate them from the raw CSVs.

## MySQL schema

Run [`schema.sql`](./schema.sql) in MySQL Workbench to create the
`trendpulse_analytics` database, tables, load the prepared CSVs, and run
`SELECT COUNT(*)` for each table. The `LOAD DATA LOCAL INFILE` paths in the
script match this checkout; update the repository path if needed. If MySQL
rejects local file loading, enable `LOCAL INFILE` in the MySQL server and
Workbench connection settings, or import each CSV with Workbench's Table Data
Import Wizard in this order: `categories_clean.csv` → `categories`, `videos.csv`
→ `videos`, and `trending_records.csv` → `trending_records`.

The loader maps empty likes and comment counts to SQL `NULL`; it accepts
boolean values as either `True`/`False` or `0`/`1`, and converts UTC publish
timestamps into MySQL `DATETIME`.
The SQL file's count queries should return **17 categories**, **14,688 videos**,
and **45,908 trending records** after loading. Run the file against an empty
schema (or clear existing rows first) to avoid primary-key or unique-key
conflicts on repeat imports.

## Basic queries

Run [`basic_queries.sql`](./basic_queries.sql) in MySQL Workbench after loading
the tables. It demonstrates `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`, `DISTINCT`,
column aliases, joins, `GROUP BY`, aggregate functions, and `HAVING`. The first
query returns the top 10 most-viewed GB trending records; the second lists
distinct country/category pairs. The grouped queries return categories whose
average views exceed 1,000,000 and channels with at least five distinct
trending videos.

The same file includes an `INNER JOIN` across trending records, videos, and
categories; a `LEFT JOIN` to find categories with no videos; and a `RIGHT JOIN`
integrity check that preserves all trending records while searching for
missing video metadata. The right-join audit should return no rows when the
foreign-key relationship is intact.


Outputs of all the queries in basic_queries.sql file

Installed mysql work bench in my laptop and created trendpulse_analytics schema. cleaned up data using python script and then loaded it using the SQL queries that are there in schema.sql file.

In mysql workbench GUI was unable to load data and hence used the load queries in terminal window by establihing the connection using the sommand 

mysql --local-infile=1 -u my_username -p

After which used the required basic sql queries to fetch and show the data. 

Query 1
'RdqSDDng84n','Lena Ortiz - Monsoon (Live)','Music','2018-01-05',360760164
'QYwpwP6y0Eb','The Hollow Pines - Phones (Official Video) WATCH','Music','2018-01-27',343297002
'RdqSDDng84n','Lena Ortiz - Monsoon (Live)','Music','2018-01-04',286714357
'QYwpwP6y0Eb','The Hollow Pines - Phones (Official Video) WATCH','Music','2018-01-26',282812154
'WQEWsMmimzZ','Rook & Vale - Phones (Official Video) WATCH','Music','2017-12-24',255362869
'RdqSDDng84n','Lena Ortiz - Monsoon (Live)','Music','2018-01-03',236275528
'QYwpwP6y0Eb','The Hollow Pines - Phones (Official Video) WATCH','Music','2018-01-25',230704137
'RdqSDDng84n','Lena Ortiz - Monsoon (Live)','Music','2018-01-02',210747294
'WQEWsMmimzZ','Rook & Vale - Phones (Official Video) WATCH','Music','2017-12-23',200444300
'QYwpwP6y0Eb','The Hollow Pines - Phones (Official Video) WATCH','Music','2018-01-24',181785943

Query 2:
'GB','Autos & Vehicles'
'GB','Comedy'
'GB','Education'
'GB','Entertainment'
'GB','Film & Animation'
'GB','Gaming'
'GB','Howto & Style'
'GB','Music'
'GB','News & Politics'
'GB','People & Blogs'
'GB','Pets & Animals'
'GB','Science & Technology'
'GB','Sports'
'GB','Travel & Events'
'IN','Autos & Vehicles'
'IN','Comedy'
'IN','Education'
'IN','Entertainment'
'IN','Film & Animation'
'IN','Gaming'
'IN','Howto & Style'
'IN','Music'
'IN','News & Politics'
'IN','People & Blogs'
'IN','Pets & Animals'
'IN','Science & Technology'
'IN','Sports'
'IN','Travel & Events'
'US','Autos & Vehicles'
'US','Comedy'
'US','Education'
'US','Entertainment'
'US','Film & Animation'
'US','Gaming'
'US','Howto & Style'
'US','Music'
'US','News & Politics'
'US','People & Blogs'
'US','Pets & Animals'
'US','Science & Technology'
'US','Sports'
'US','Travel & Events'

Query 3
'Music',10286,'3193066.33'

Query 4
'UltimateUnboxing65',522,1423
'QuietChallenge75',466,2448
'OfficialReview41',457,1575
'InsaneReaction46',321,1223
'Brand NewChallenge45',302,1169
'UltimateSpeech20',292,766
'CrazyTrailer91',283,1010
'WildHighlights7',245,682
'UltimateVlog96',233,561
'SurprisingChallenge82',216,381
'CrazyRecipe67',202,600
'Brand NewSecret51',188,679
'SurprisingTutorial85',184,402
'QuietPrank55',178,309
'FinalBreakdown11',164,641
'FinalTrailer17',161,902
'PerfectVlog13',158,453
'AmazingSpeech11',154,484
'FinalUpdate79',147,499
'Brand NewReview23',146,518
'FinalTutorial50',141,345
'HonestUnboxing82',141,465
'PerfectRecipe71',135,318
'QuietSpeech10',128,331
'SurprisingHighlights41',123,648
'Brand NewUnboxing21',113,480
'PerfectInterview40',110,262
'AmazingSecret45',106,375
'HonestTrailer16',105,381
'HonestInterview4',104,301
'EpicReaction91',102,235
'FinalReview90',101,252
'PerfectTutorial78',98,537
'PerfectFinale81',97,306
'UltimateTrailer12',97,168
'IncredibleSpeech28',95,256
'IncredibleMystery54',93,226
'AmazingSpeech54',88,297
'QuietInterview9',88,564
'WildUnboxing75',85,216
'WildVlog44',85,276
'InsaneVlog84',84,147
'EpicBreakdown36',83,280
'FinalUpdate28',81,197
'UltimateSecret44',80,248
'InsaneSpeech93',79,177
'HonestMystery15',78,146
'IncredibleUpdate56',78,231
'EpicTutorial97',77,214
'SurprisingUnboxing42',76,229
'WildVlog97',74,273
'SurprisingReaction10',73,179
'UltimateReview56',73,302
'HonestInterview42',72,234
'AmazingTutorial48',71,247
'IncredibleTrailer23',71,172
'PerfectFinale2',71,284
'ShockingPrank71',71,251
'HonestUnboxing57',70,174
'OfficialSecret61',70,301
'QuietHighlights95',70,215
'FinalHighlights33',68,259
'IncredibleUnboxing68',68,227
'ShockingMystery18',67,421
'HonestSpeech62',66,174
'PerfectTrailer65',66,339
'SurprisingTrailer62',65,140
'SurprisingUnboxing83',65,148
'InsaneFinale7',62,174
'PerfectReaction36',56,296
'ShockingHighlights32',56,113
'WildUnboxing39',56,394
'HonestChallenge48',55,96
'CrazyHighlights46',54,156
'EpicPrank75',54,113
'AmazingReaction49',52,149
'SurprisingChallenge68',49,119
'Brand NewSecret47',45,261
'UltimateReview24',45,96
'Brand NewHighlights8',44,127
'PerfectUpdate53',44,271
'QuietSecret61',44,253
'ShockingBreakdown15',44,66
'AmazingChallenge55',43,133
'ShockingTutorial48',43,107
'Brand NewRecipe36',42,122
'ShockingTutorial88',42,122
'UltimateUnboxing57',42,113
'CrazyChallenge53',41,128
'IncrediblePrank4',41,109
'IncredibleChallenge41',40,61
'OfficialSpeech63',40,101
'InsaneHighlights15',39,202
'SurprisingSpeech65',39,92
'QuietReview27',38,225
'IncredibleVlog15',37,66
'InsaneHighlights31',37,103
'AmazingSecret86',35,56
'CrazyChallenge46',35,160
'CrazyUpdate20',35,87
'FinalPrank44',35,71
'FinalSpeech81',34,185
'Brand NewInterview13',33,53
'WildTutorial42',33,188
'Brand NewReview96',32,70
'IncredibleUpdate91',32,49
'PerfectPrank45',32,88
'UltimateBreakdown61',31,82
'PerfectBreakdown66',30,57
'ShockingVlog29',30,74
'UltimateHighlights96',30,92
'FinalVlog76',29,83
'IncredibleTutorial67',29,82
'PerfectTutorial1',29,72
'QuietVlog89',29,63
'CrazyFinale83',28,38
'CrazyHighlights64',28,155
'CrazyReview12',28,58
'EpicMystery11',28,73
'FinalReview6',28,83
'OfficialUnboxing6',28,65
'UltimateSecret82',28,62
'EpicFinale29',27,72
'ShockingFinale49',27,60
'SurprisingReaction12',27,44
'WildRecipe33',27,162
'AmazingTrailer42',26,54
'PerfectHighlights53',26,50
'UltimateVlog58',26,159
'Brand NewSpeech75',25,47
'CrazyBreakdown94',25,58
'CrazyChallenge13',25,64
'EpicBreakdown90',25,110
'EpicVlog36',25,74
'PerfectInterview27',25,42
'PerfectUnboxing66',25,49
'AmazingSecret61',24,55
'HonestUnboxing68',24,89
'OfficialInterview56',24,69
'UltimateTrailer50',24,53
'Brand NewVlog69',23,64
'CrazySpeech62',23,63
'PerfectHighlights13',23,51
'QuietBreakdown41',23,43
'ShockingPrank43',23,49
'SurprisingRecipe27',23,48
'UltimateUnboxing18',23,83
'CrazyUpdate32',22,59
'CrazyUpdate53',22,62
'CrazyVlog44',22,34
'FinalTrailer97',22,50
'HonestBreakdown45',22,124
'IncredibleMystery9',22,33
'InsaneTutorial77',22,65
'OfficialBreakdown54',22,59
'OfficialRecipe78',22,58
'QuietReaction79',22,64
'UltimateUnboxing71',22,57
'WildFinale60',22,41
'WildUnboxing95',22,91
'CrazyMystery34',21,57
'FinalUpdate46',21,51
'IncredibleUnboxing7',21,37
'InsanePrank79',21,97
'InsaneVlog80',21,49
'QuietSecret84',21,61
'WildTrailer7',21,78
'CrazyHighlights83',20,34
'EpicInterview58',20,44
'FinalTutorial37',20,77
'IncredibleUnboxing19',20,33
'OfficialBreakdown58',20,61
'ShockingReview10',20,33
'UltimatePrank50',20,70
'UltimatePrank78',20,38
'AmazingMystery22',19,107
'Brand NewFinale5',19,61
'Brand NewSpeech10',19,48
'CrazyTutorial82',19,90
'EpicBreakdown59',19,121
'FinalUpdate63',19,29
'HonestReaction49',19,32
'IncredibleUnboxing73',19,40
'ShockingUnboxing61',19,36
'WildInterview5',19,53
'EpicPrank58',18,98
'FinalMystery25',18,38
'HonestBreakdown33',18,50
'HonestTutorial2',18,50
'HonestVlog95',18,46
'IncredibleFinale71',18,53
'IncredibleRecipe28',18,47
'InsaneSpeech26',18,50
'InsaneTutorial39',18,27
'PerfectHighlights79',18,66
'ShockingReview77',18,47
'Brand NewTrailer92',17,36
'EpicUpdate1',17,49
'QuietSecret29',17,55
'ShockingPrank44',17,25
'ShockingUnboxing32',17,41
'SurprisingUpdate52',17,105
'SurprisingUpdate8',17,45
'FinalMystery79',16,25
'HonestTutorial65',16,35
'SurprisingChallenge37',16,32
'UltimateUnboxing12',16,37
'HonestReview83',15,30
'OfficialInterview86',15,27
'QuietTutorial93',15,42
'ShockingChallenge29',15,46
'ShockingInterview30',15,117
'ShockingMystery71',15,33
'CrazyChallenge57',14,78
'CrazyHighlights24',14,24
'HonestBreakdown24',14,41
'IncredibleInterview70',14,34
'IncredibleTutorial15',14,34
'PerfectTrailer43',14,30
'QuietSpeech12',14,34
'ShockingChallenge49',14,38
'ShockingSecret98',14,68
'SurprisingReview75',14,40
'Brand NewChallenge76',13,27
'FinalTutorial80',13,29
'HonestReview78',13,45
'HonestSpeech90',13,35
'IncredibleSpeech40',13,41
'InsaneMystery57',13,21
'InsaneTutorial20',13,38
'OfficialTutorial15',13,40
'QuietFinale86',13,31
'WildReaction71',13,23
'WildTutorial71',13,38
'AmazingVlog77',12,36
'Brand NewVlog13',12,35
'CrazyFinale50',12,40
'CrazySpeech11',12,36
'EpicReview1',12,30
'EpicTrailer58',12,51
'FinalFinale16',12,32
'FinalMystery75',12,38
'HonestTutorial53',12,26
'HonestVlog91',12,32
'QuietReaction34',12,35
'QuietRecipe72',12,22
'ShockingRecipe83',12,18
'ShockingVlog86',12,29
'SurprisingHighlights87',12,23
'UltimateInterview90',12,29
'FinalFinale22',11,32
'InsaneChallenge84',11,27
'ShockingReaction24',11,28
'ShockingUpdate4',11,28
'UltimateReview48',11,16
'Brand NewFinale59',10,32
'Brand NewUpdate50',10,27
'CrazyPrank10',10,21
'CrazyTrailer65',10,25
'EpicPrank20',10,19
'IncredibleSpeech31',10,22
'InsaneBreakdown65',10,31
'PerfectInterview47',10,38
'PerfectMystery19',10,27
'ShockingInterview29',10,23
'ShockingUpdate48',10,26
'UltimatePrank91',10,26
'UltimateReview84',10,28
'UltimateSpeech66',10,31
'AmazingSpeech95',9,13
'Brand NewTutorial12',9,29
'Brand NewUnboxing51',9,17
'CrazyChallenge28',9,34
'FinalTutorial46',9,28
'InsaneMystery41',9,24
'InsanePrank76',9,20
'OfficialBreakdown92',9,26
'OfficialReview13',9,34
'PerfectInterview29',9,16
'QuietUnboxing84',9,37
'ShockingTrailer20',9,25
'SurprisingBreakdown11',9,32
'SurprisingInterview51',9,21
'UltimatePrank3',9,19
'UltimateReview54',9,34
'AmazingMystery1',8,24
'AmazingSecret66',8,22
'Brand NewVlog97',8,22
'EpicUnboxing84',8,24
'FinalUnboxing3',8,26
'IncredibleRecipe66',8,19
'InsaneRecipe86',8,29
'ShockingChallenge57',8,24
'ShockingMystery66',8,24
'UltimateRecipe74',8,16
'UltimateSpeech88',8,19
'WildRecipe59',8,12
'WildSecret73',8,31
'AmazingChallenge43',7,18
'AmazingReview10',7,13
'Brand NewSecret74',7,20
'Brand NewSpeech76',7,16
'CrazyInterview83',7,15
'HonestBreakdown49',7,28
'IncredibleTrailer3',7,20
'IncredibleUpdate38',7,19
'OfficialReview24',7,15
'OfficialSecret57',7,11
'PerfectInterview50',7,11
'QuietBreakdown86',7,16
'QuietReaction19',7,15
'ShockingSecret25',7,13
'ShockingSpeech90',7,17
'SurprisingReview3',7,21
'UltimateRecipe14',7,14
'AmazingMystery37',6,17
'AmazingUpdate68',6,16
'AmazingVlog18',6,12
'Brand NewBreakdown94',6,10
'Brand NewPrank14',6,17
'CrazyFinale73',6,22
'CrazyUnboxing40',6,11
'EpicFinale63',6,17
'FinalTrailer48',6,12
'FinalUnboxing6',6,13
'HonestBreakdown77',6,12
'HonestPrank31',6,20
'IncredibleHighlights50',6,21
'IncredibleRecipe75',6,15
'OfficialFinale44',6,21
'OfficialTrailer78',6,22
'QuietUnboxing73',6,9
'ShockingChallenge59',6,10
'ShockingChallenge9',6,12
'ShockingFinale36',6,19
'ShockingTutorial28',6,19
'ShockingUpdate46',6,15
'UltimateSpeech50',6,20
'WildChallenge55',6,10
'WildSecret67',6,16
'AmazingReaction28',5,14
'AmazingUpdate73',5,14
'Brand NewVlog88',5,12
'CrazySpeech74',5,11
'EpicReaction68',5,11
'EpicVlog17',5,13
'HonestFinale15',5,31
'HonestReaction26',5,7
'HonestUpdate25',5,15
'IncredibleReview59',5,18
'InsaneReaction83',5,19
'InsaneRecipe54',5,14
'InsaneSpeech61',5,11
'PerfectHighlights68',5,10
'PerfectInterview63',5,12
'QuietBreakdown79',5,7
'QuietInterview39',5,15
'SurprisingPrank77',5,16
'UltimateHighlights98',5,14
'UltimateUpdate75',5,15
'UltimateVlog72',5,14
'WildUpdate43',5,7

Query 5
10466,'GB','2018-01-05','Lena Ortiz - Monsoon (Live)','Music',360760164
14863,'GB','2018-01-27','The Hollow Pines - Phones (Official Video) WATCH','Music',343297002
10270,'GB','2018-01-04','Lena Ortiz - Monsoon (Live)','Music',286714357
14662,'GB','2018-01-26','The Hollow Pines - Phones (Official Video) WATCH','Music',282812154
8105,'GB','2017-12-24','Rook & Vale - Phones (Official Video) WATCH','Music',255362869
10066,'GB','2018-01-03','Lena Ortiz - Monsoon (Live)','Music',236275528
14458,'GB','2018-01-25','The Hollow Pines - Phones (Official Video) WATCH','Music',230704137
9865,'GB','2018-01-02','Lena Ortiz - Monsoon (Live)','Music',210747294
7905,'GB','2017-12-23','Rook & Vale - Phones (Official Video) WATCH','Music',200444300
14252,'GB','2018-01-24','The Hollow Pines - Phones (Official Video) WATCH','Music',181785943
9668,'GB','2018-01-01','Lena Ortiz - Monsoon (Live)','Music',169181540
4322,'GB','2017-12-05','Rook & Vale - Guitar (Live)','Music',168760418
7702,'GB','2017-12-22','Rook & Vale - Phones (Official Video) WATCH','Music',159635918
14054,'GB','2018-01-23','The Hollow Pines - Phones (Official Video) WATCH','Music',154605665
9463,'GB','2017-12-31','Lena Ortiz - Monsoon (Live)','Music',143310059
4123,'GB','2017-12-04','Rook & Vale - Guitar (Live)','Music',136633806
7502,'GB','2017-12-21','Rook & Vale - Phones (Official Video) WATCH','Music',133165741
13857,'GB','2018-01-22','The Hollow Pines - Phones (Official Video) WATCH','Music',130336838
41575,'US','2018-01-11','Lena Ortiz - Guitar (Official Video)!','Music',129229245
20508,'IN','2017-12-11','The Hollow Pines - Cricket (Official Video) FINALE','Music',123208090

Query 6
29,'Nonprofits & Activism'
30,'Movies'
43,'Shows'
