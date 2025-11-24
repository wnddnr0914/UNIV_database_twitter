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