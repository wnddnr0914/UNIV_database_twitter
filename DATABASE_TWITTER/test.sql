USE twitter_DB;

-- 1. 내 아이디 (로그인용)
INSERT INTO USER (idUSER, NAME, GENDER, BIRTH, PASSWORD) 
VALUES ('test1', '홍길동', 1, '1999-01-01', '1234');

-- 2. 유명인 데이터 (검색 테스트용)
INSERT INTO USER (idUSER, NAME, GENDER, BIRTH, PASSWORD) 
VALUES ('iu_official', '아이유', 2, '1993-05-16', '1234');

INSERT INTO USER (idUSER, NAME, GENDER, BIRTH, PASSWORD) 
VALUES ('elon_musk', '일론머스크', 1, '1971-06-28', '1234');

INSERT INTO USER (idUSER, NAME, GENDER, BIRTH, PASSWORD) 
VALUES ('faker', '이상혁', 1, '1996-05-07', '1234');

INSERT INTO USER (idUSER, NAME, GENDER, BIRTH, PASSWORD) 
VALUES ('newjeans_hanni', '하니', 2, '2004-10-06', '1234');

-- 3. 개발자 친구들 (검색어: java, dev 등 테스트)
INSERT INTO USER (idUSER, NAME, GENDER, BIRTH, PASSWORD) 
VALUES ('java_king', '자바고수', 1, '1995-12-25', '1234');

INSERT INTO USER (idUSER, NAME, GENDER, BIRTH, PASSWORD) 
VALUES ('db_master', '디비조아', 1, '1990-03-01', '1234');

INSERT INTO USER (idUSER, NAME, GENDER, BIRTH, PASSWORD) 
VALUES ('spring_love', '스프링', 2, '2000-01-01', '1234');

INSERT INTO USER (idUSER, NAME, GENDER, BIRTH, PASSWORD) 
VALUES ('react_pro', '프론트엔드', 1, '2002-08-15', '1234');

-- 4. 기타 유저 (페이지 넘김 테스트용)
INSERT INTO USER (idUSER, NAME, GENDER, BIRTH, PASSWORD) 
VALUES ('user100', '김철수', 1, '1988-04-20', '1234');

INSERT INTO USER (idUSER, NAME, GENDER, BIRTH, PASSWORD) 
VALUES ('user200', '이영희', 2, '1992-11-11', '1234');

INSERT INTO USER (idUSER, NAME, GENDER, BIRTH, PASSWORD) 
VALUES ('guest_user', '게스트', 1, '2023-01-01', '1234');

-- 5. 데이터 저장 확정
COMMIT;

-- 6. 잘 들어갔는지 확인
SELECT * FROM USER;

USE twitter_DB;

-- 1. 기존 데이터 깨끗하게 비우기 (순서 중요: 자식 테이블부터 삭제)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE REPLYCOMMENTLIKE;
TRUNCATE TABLE COMMENT_LIKE;
TRUNCATE TABLE REPLY_COMMENT;
TRUNCATE TABLE POST_COMMENT;
TRUNCATE TABLE POST_LIKE;
TRUNCATE TABLE FOLLOW;
TRUNCATE TABLE POST;
TRUNCATE TABLE USER;
SET FOREIGN_KEY_CHECKS = 1;

-- ---------------------------------------------------------
-- 2. 사용자 데이터 (USER) - 15명 생성
-- 비번은 모두 '1234'로 통일
-- ---------------------------------------------------------
INSERT INTO USER (idUSER, NAME, GENDER, BIRTH, PASSWORD) VALUES 
('test1', '홍길동', 1, '1999-01-01', '1234'),
('iu_official', '아이유', 2, '1993-05-16', '1234'),
('faker', '이상혁', 1, '1996-05-07', '1234'),
('elon_musk', 'Elon Musk', 1, '1971-06-28', '1234'),
('newjeans_hanni', '하니', 2, '2004-10-06', '1234'),
('son_hm7', '손흥민', 1, '1992-07-08', '1234'),
('karina_aespa', '카리나', 2, '2000-04-11', '1234'),
('gd_official', 'G-DRAGON', 1, '1988-08-18', '1234'),
('java_king', '자바고수', 1, '1990-12-25', '1234'),
('db_master', 'DB깎는노인', 1, '1985-03-01', '1234'),
('mark_zuckerberg', 'Mark', 1, '1984-05-14', '1234'),
('winter_aespa', '윈터', 2, '2001-01-01', '1234'),
('coding_bot', '코딩봇', 1, '2024-01-01', '1234'),
('designer_kim', '김디자인', 2, '1995-09-09', '1234'),
('react_lover', '리액트조아', 1, '2000-02-20', '1234');


-- ---------------------------------------------------------
-- 3. 게시글 데이터 (POST) - 30개 정도 생성
-- ---------------------------------------------------------
INSERT INTO POST (USER_idUSER, detail, DATE) VALUES 
('iu_official', '오늘 날씨가 너무 좋네요! 다들 좋은 하루 보내세요 ☀️', NOW() - INTERVAL 5 HOUR),
('iu_official', '콘서트 준비 중... 기대해주세요! 🎤', NOW() - INTERVAL 1 DAY),
('faker', '오늘 경기도 화이팅. T1 WIN 🏆', NOW() - INTERVAL 2 HOUR),
('faker', '점심 뭐 먹지?', NOW() - INTERVAL 3 HOUR),
('elon_musk', 'Mars is waiting.', NOW() - INTERVAL 10 HOUR),
('elon_musk', 'Tesla AI Day coming soon.', NOW() - INTERVAL 2 DAY),
('newjeans_hanni', '버니즈 보고싶어요 🐰💙', NOW() - INTERVAL 30 MINUTE),
('son_hm7', 'A huge win today! Thank you fans! ⚽️', NOW() - INTERVAL 6 HOUR),
('karina_aespa', '연습 끝나고 퇴근길 🌙', NOW() - INTERVAL 8 HOUR),
('gd_official', 'Still Life.', NOW() - INTERVAL 5 DAY),
('java_king', 'NullPointerException은 정말... 하...', NOW() - INTERVAL 1 HOUR),
('java_king', 'JSP로 트위터 만드는 중인데 재밌다 ㅋㅋ', NOW() - INTERVAL 10 MINUTE),
('db_master', '정규화가 왜 필요한지 아시나요? 데이터 무결성 때문입니다.', NOW() - INTERVAL 20 HOUR),
('mark_zuckerberg', 'Metaverse is the future.', NOW() - INTERVAL 3 DAY),
('winter_aespa', '오늘 뭐 먹었게?', NOW() - INTERVAL 4 HOUR),
('coding_bot', 'Hello World!', NOW() - INTERVAL 1 WEEK),
('designer_kim', '피그마 업데이트 되었네? 기능 짱이다', NOW() - INTERVAL 2 HOUR),
('react_lover', '리액트 훅 너무 어렵다 ㅠㅠ 자바스크립트 공부 다시 해야지', NOW() - INTERVAL 15 MINUTE),
('test1', '첫 게시글입니다! 반갑습니다~', NOW() - INTERVAL 1 MONTH),
('test1', '개발 공부 시작한지 3일차... 화이팅!', NOW() - INTERVAL 20 DAY),
('iu_official', '좋은 꿈 꾸세요 🌙', NOW() - INTERVAL 12 HOUR),
('son_hm7', 'Training hard everyday.', NOW() - INTERVAL 2 DAY),
('faker', '...', NOW() - INTERVAL 4 DAY),
('newjeans_hanni', 'Super Shy ~ 🎶', NOW() - INTERVAL 5 HOUR),
('java_king', '오늘 밤샘 코딩 각이다', NOW() - INTERVAL 50 MINUTE),
('db_master', 'SELECT * FROM LIFE WHERE HAPPINESS = TRUE;', NOW() - INTERVAL 2 HOUR);


-- ---------------------------------------------------------
-- 4. 팔로우 데이터 (FOLLOW) - 관계 형성
-- 규칙: FOLLOWING(나) -> FOLLOWER(상대) (사용자님 DAO 로직 기준)
-- ---------------------------------------------------------
INSERT INTO FOLLOW (FOLLOWING, FOLLOWER) VALUES 
-- test1이 유명인들을 팔로우함
('test1', 'iu_official'),
('test1', 'faker'),
('test1', 'elon_musk'),
('test1', 'son_hm7'),
('test1', 'java_king'),

-- 유명인들끼리 팔로우
('iu_official', 'newjeans_hanni'),
('iu_official', 'karina_aespa'),
('newjeans_hanni', 'iu_official'),
('faker', 'son_hm7'),
('son_hm7', 'faker'),
('elon_musk', 'mark_zuckerberg'),

-- 개발자들끼리 팔로우
('java_king', 'db_master'),
('db_master', 'java_king'),
('react_lover', 'java_king'),
('react_lover', 'designer_kim'),

-- test1을 팔로우하는 사람들 (내 팔로워)
('java_king', 'test1'),
('db_master', 'test1'),
('react_lover', 'test1');


-- ---------------------------------------------------------
-- 5. 게시글 좋아요 (POST_LIKE)
-- ---------------------------------------------------------
-- test1이 여기저기 좋아요 누름
INSERT INTO POST_LIKE (POST_idPOST, USER_idUSER) VALUES 
(1, 'test1'), (3, 'test1'), (5, 'test1'), (7, 'test1'), (11, 'test1'),
(1, 'java_king'), (1, 'faker'), (1, 'newjeans_hanni'), -- 아이유 글에 좋아요 많음
(3, 'son_hm7'), (3, 'java_king'), -- 페이커 글에 좋아요
(11, 'db_master'), (11, 'react_lover'), -- 자바고수 글에 개발자들 좋아요
(12, 'test1'), (12, 'db_master');


-- ---------------------------------------------------------
-- 6. 댓글 데이터 (POST_COMMENT)
-- ---------------------------------------------------------
-- 아이유 글(1번)에 댓글
INSERT INTO POST_COMMENT (POST_idPOST, USER_idUSER, DETAIL, DATE) VALUES 
(1, 'newjeans_hanni', '선배님 너무 예뻐요!! 💖', NOW()),
(1, 'test1', '오늘도 화이팅입니다!', NOW()),
(1, 'karina_aespa', '노래 항상 잘 듣고 있어요 ㅎㅎ', NOW());

-- 자바고수 글(11번)에 댓글
INSERT INTO POST_COMMENT (POST_idPOST, USER_idUSER, DETAIL, DATE) VALUES 
(11, 'db_master', '로그를 잘 찍어보세요.', NOW()),
(11, 'react_lover', '저도 어제 그걸로 3시간 날림 ㅠㅠ', NOW()),
(11, 'test1', '힘내세요..!', NOW());

-- 페이커 글(3번)에 댓글
INSERT INTO POST_COMMENT (POST_idPOST, USER_idUSER, DETAIL, DATE) VALUES 
(3, 'son_hm7', 'Lets go!! 🔥', NOW());


-- ---------------------------------------------------------
-- 7. 대댓글 데이터 (REPLY_COMMENT)
-- 구조가 바뀌어서 USER_idUSER 포함
-- ---------------------------------------------------------
-- 하니 댓글(1번 댓글)에 아이유가 답글
INSERT INTO REPLY_COMMENT (POSTCOMMENT_SEQ_POST, USER_idUSER, DETAIL, DATE) VALUES 
(1, 'iu_official', '하니 고마워~ 다음에 밥 먹자!', NOW());

-- 자바고수 글의 DB마스터 댓글(4번 댓글)에 자바고수가 답글
INSERT INTO REPLY_COMMENT (POSTCOMMENT_SEQ_POST, USER_idUSER, DETAIL, DATE) VALUES 
(4, 'java_king', '감사합니다 해결했어요!', NOW());

-- 리액트러버 댓글(5번 댓글)에 답글
INSERT INTO REPLY_COMMENT (POSTCOMMENT_SEQ_POST, USER_idUSER, DETAIL, DATE) VALUES 
(5, 'java_king', '우리 존재 화이팅...', NOW());

COMMIT;