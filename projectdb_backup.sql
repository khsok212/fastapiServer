--
-- PostgreSQL database dump
--

-- Dumped from database version 17.3
-- Dumped by pg_dump version 17.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: blacklist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blacklist (
    ip_address character varying(45) NOT NULL,
    user_id character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.blacklist OWNER TO postgres;

--
-- Name: roles_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_role_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_role_id_seq OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    role_id integer DEFAULT nextval('public.roles_role_id_seq'::regclass) NOT NULL,
    role_name character varying(10) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: user_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_history (
    history_id integer NOT NULL,
    user_id character varying(50),
    login_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    login_ip character varying(45) NOT NULL,
    request_path character varying(100) NOT NULL,
    memo character varying(200) DEFAULT ''::character varying
);


ALTER TABLE public.user_history OWNER TO postgres;

--
-- Name: user_history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_history_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_history_history_id_seq OWNER TO postgres;

--
-- Name: user_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_history_history_id_seq OWNED BY public.user_history.history_id;


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    user_role_id integer NOT NULL,
    user_id character varying(50) NOT NULL,
    role_id integer NOT NULL
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- Name: user_roles_user_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_roles_user_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_roles_user_role_id_seq OWNER TO postgres;

--
-- Name: user_roles_user_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_roles_user_role_id_seq OWNED BY public.user_roles.user_role_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id character varying(50) NOT NULL,
    name character varying(50) NOT NULL,
    email character varying(150) NOT NULL,
    password character varying(100) NOT NULL,
    phone character varying(20),
    approval_status character(1) DEFAULT 'N'::bpchar,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    address1 character varying(150),
    address2 character varying(150)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: user_history history_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_history ALTER COLUMN history_id SET DEFAULT nextval('public.user_history_history_id_seq'::regclass);


--
-- Name: user_roles user_role_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles ALTER COLUMN user_role_id SET DEFAULT nextval('public.user_roles_user_role_id_seq'::regclass);


--
-- Data for Name: blacklist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.blacklist (ip_address, user_id, created_at) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (role_id, role_name) FROM stdin;
0	슈퍼관리자
1	관리자
2	일반사용자
\.


--
-- Data for Name: user_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_history (history_id, user_id, login_time, login_ip, request_path, memo) FROM stdin;
1	admin	2025-03-10 11:10:19.408946	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
2	admin	2025-03-10 11:10:19.900366	127.0.0.1	POST /logout	로그아웃 성공
3	admin	2025-03-10 11:10:24.127495	127.0.0.1	POST /login/	로그인 성공
4	admin	2025-03-10 11:10:25.853722	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
5	admin	2025-03-10 11:10:26.920556	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
6	admin	2025-03-10 11:10:27.512058	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
7	admin	2025-03-10 11:10:27.599927	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
8	admin	2025-03-10 11:10:28.164387	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
9	admin	2025-03-10 11:10:36.247403	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
10	admin	2025-03-10 11:10:37.196755	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
11	admin	2025-03-10 11:10:37.314546	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
12	admin	2025-03-10 11:10:41.659113	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
13	admin	2025-03-10 11:10:42.246868	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
14	admin	2025-03-10 11:10:42.374109	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
15	admin	2025-03-10 11:10:48.697887	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
16	admin	2025-03-10 11:10:51.47217	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
17	admin	2025-03-10 11:10:52.907102	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
18	admin	2025-03-10 11:10:57.36311	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
19	admin	2025-03-10 11:10:57.935294	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
20	admin	2025-03-10 11:10:58.02792	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
21	admin	2025-03-10 11:10:58.486431	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
22	admin	2025-03-10 11:10:58.976669	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
23	admin	2025-03-10 11:10:59.38586	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
24	admin	2025-03-10 11:10:59.483005	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
25	admin	2025-03-10 11:10:59.920702	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
26	admin	2025-03-10 11:11:00.421022	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
27	admin	2025-03-10 11:11:01.011154	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
28	admin	2025-03-10 11:11:01.119737	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
29	admin	2025-03-10 11:11:23.936769	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
30	admin	2025-03-10 11:11:24.03463	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
31	admin	2025-03-10 11:11:25.163225	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
32	admin	2025-03-10 11:11:25.278663	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
33	admin	2025-03-10 11:11:27.313804	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
34	admin	2025-03-10 11:11:27.40221	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
35	admin	2025-03-10 11:11:28.775462	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
36	admin	2025-03-10 11:11:28.886556	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
37	admin	2025-03-10 11:14:30.899296	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
38	admin	2025-03-10 11:17:41.396771	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
39	admin	2025-03-10 11:14:58.445035	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
40	admin	2025-03-10 11:17:41.61534	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
41	admin	2025-03-10 11:17:43.768798	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
42	admin	2025-03-10 11:17:43.892614	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
43	admin	2025-03-10 11:17:44.823009	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
44	admin	2025-03-10 11:17:44.931837	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
45	admin	2025-03-10 11:17:45.645768	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
46	admin	2025-03-10 11:17:45.749319	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
47	admin	2025-03-10 11:17:46.395365	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
48	admin	2025-03-10 11:17:46.509131	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
49	admin	2025-03-10 11:17:48.371063	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
50	admin	2025-03-10 11:17:48.523364	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
51	admin	2025-03-10 11:17:49.454349	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
52	admin	2025-03-10 11:17:49.600681	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
53	admin	2025-03-10 11:19:24.450523	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
54	admin	2025-03-10 11:19:27.396222	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
55	admin	2025-03-10 11:19:28.657396	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
56	admin	2025-03-10 11:19:29.514343	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
57	admin	2025-03-10 11:19:30.379307	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
58	admin	2025-03-10 11:19:31.165368	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
59	admin	2025-03-10 11:19:31.907988	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
60	admin	2025-03-10 11:19:32.646273	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
61	admin	2025-03-10 11:19:33.355922	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
62	admin	2025-03-10 11:19:41.731114	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
63	admin	2025-03-10 11:19:44.506207	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
64	admin	2025-03-10 11:20:01.291135	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
67	admin	2025-03-10 11:25:29.841552	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
68	admin	2025-03-10 11:25:31.015935	127.0.0.1	GET /api/excelDownload	엑셀 다운로드 - 접속 이력 다운로드 성공
71	admin	2025-03-10 11:25:45.632186	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
74	admin	2025-03-10 11:25:46.695989	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
77	admin	2025-03-10 11:25:48.673934	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
80	admin	2025-03-10 11:25:50.678102	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
81	admin	2025-03-10 11:25:59.145221	127.0.0.1	POST /api/users/approve	사용자 승인 성공: test9
85	admin	2025-03-10 11:26:07.486539	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
88	admin	2025-03-10 11:50:51.390671	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
91	admin	2025-03-10 11:50:58.020067	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
92	admin	2025-03-10 11:51:00.81612	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
65	admin	2025-03-10 11:24:41.247002	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
69	admin	2025-03-10 11:25:40.212328	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
72	admin	2025-03-10 11:25:46.000013	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
75	admin	2025-03-10 11:25:47.765957	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
78	admin	2025-03-10 11:25:49.295711	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
82	admin	2025-03-10 11:25:59.245718	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
83	admin	2025-03-10 11:26:04.475741	127.0.0.1	DELETE /api/users/	사용자 삭제 성공: test9
86	admin	2025-03-10 11:26:11.40565	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
89	admin	2025-03-10 11:50:53.901438	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
66	admin	2025-03-10 11:25:26.441298	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
70	admin	2025-03-10 11:25:41.254647	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
73	admin	2025-03-10 11:25:46.285479	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
76	admin	2025-03-10 11:25:48.211869	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
79	admin	2025-03-10 11:25:49.660663	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
84	admin	2025-03-10 11:26:04.583549	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
87	admin	2025-03-10 11:50:50.22601	127.0.0.1	POST /login/	로그인 성공
90	admin	2025-03-10 11:50:55.323039	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
93	admin	2025-03-10 11:54:52.979433	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
94	admin	2025-03-10 11:54:54.187321	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
95	admin	2025-03-10 11:54:55.369067	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
96	admin	2025-03-10 11:54:56.774823	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
97	admin	2025-03-10 11:54:57.276273	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
98	admin	2025-03-10 11:54:58.619298	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
99	admin	2025-03-10 11:54:59.330236	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
100	admin	2025-03-10 11:55:00.602155	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
101	admin	2025-03-10 11:55:02.029694	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
102	admin	2025-03-10 11:55:02.636801	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
103	admin	2025-03-10 11:55:03.209314	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
104	admin	2025-03-10 11:55:03.566022	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
105	admin	2025-03-10 11:55:04.003377	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
106	admin	2025-03-10 11:55:04.100677	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
107	admin	2025-03-10 11:55:04.554033	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
108	admin	2025-03-10 11:55:04.945276	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
109	admin	2025-03-10 11:55:04.971583	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
110	admin	2025-03-10 11:55:05.433202	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
111	admin	2025-03-10 11:55:05.839624	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
112	admin	2025-03-10 11:55:05.952324	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
113	admin	2025-03-10 11:55:06.249985	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
114	admin	2025-03-10 11:55:06.638031	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
115	admin	2025-03-10 11:55:06.970501	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
116	admin	2025-03-10 11:55:07.080183	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
117	admin	2025-03-10 11:55:07.501093	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
118	admin	2025-03-10 11:55:07.972183	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
119	admin	2025-03-10 11:55:08.02538	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
120	admin	2025-03-10 11:55:08.413813	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
121	admin	2025-03-10 11:55:08.836004	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
122	admin	2025-03-10 11:55:09.116619	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
123	admin	2025-03-10 11:55:09.927574	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
124	admin	2025-03-10 11:55:10.705767	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
125	admin	2025-03-10 11:55:11.514825	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
126	admin	2025-03-10 11:55:12.337805	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
127	admin	2025-03-10 11:55:13.142592	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
128	admin	2025-03-10 11:55:13.980868	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
129	admin	2025-03-10 11:55:14.799883	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
130	admin	2025-03-10 11:55:16.982958	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
131	admin	2025-03-10 11:55:17.919783	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
132	admin	2025-03-10 11:55:19.284416	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
133	admin	2025-03-10 11:55:19.984449	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
134	admin	2025-03-10 11:55:21.269337	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
135	admin	2025-03-10 11:55:24.815052	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
136	admin	2025-03-10 11:55:25.525659	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
137	admin	2025-03-10 11:55:26.054581	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
138	admin	2025-03-10 11:55:26.253722	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
139	admin	2025-03-10 11:55:26.421685	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
140	admin	2025-03-10 11:55:26.596429	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
141	admin	2025-03-10 11:55:26.746453	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
142	admin	2025-03-10 11:55:26.923058	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
143	admin	2025-03-10 11:55:27.071947	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
144	admin	2025-03-10 11:55:27.243624	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
145	admin	2025-03-10 11:55:27.404937	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
146	admin	2025-03-10 11:55:27.588206	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
147	admin	2025-03-10 11:55:27.747331	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
150	admin	2025-03-10 11:55:28.240601	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
153	admin	2025-03-10 11:55:28.707214	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
156	admin	2025-03-10 11:55:29.173799	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
159	admin	2025-03-10 11:55:29.658053	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
162	admin	2025-03-10 11:55:31.041343	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
165	admin	2025-03-10 11:55:31.602745	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
168	admin	2025-03-10 11:55:34.628781	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
171	admin	2025-03-10 11:55:35.167728	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
174	admin	2025-03-10 11:55:36.948697	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
177	admin	2025-03-10 11:55:37.930919	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
180	admin	2025-03-10 11:55:38.455956	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
183	admin	2025-03-10 11:55:38.967335	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
186	admin	2025-03-10 11:55:39.443453	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
189	admin	2025-03-10 11:55:39.956707	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
192	admin	2025-03-10 11:55:40.455283	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
195	admin	2025-03-10 11:55:41.004196	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
198	admin	2025-03-10 11:55:41.53363	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
201	admin	2025-03-10 11:55:42.107251	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
204	admin	2025-03-10 11:55:42.602716	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
207	admin	2025-03-10 11:55:43.138789	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
210	admin	2025-03-10 11:55:43.67253	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
213	admin	2025-03-10 11:55:44.213609	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
216	admin	2025-03-10 11:55:44.719345	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
219	admin	2025-03-10 11:55:45.234494	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
222	admin	2025-03-10 11:55:45.750077	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
225	admin	2025-03-10 11:55:46.247947	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
228	admin	2025-03-10 11:55:46.721332	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
231	admin	2025-03-10 11:55:47.186675	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
234	admin	2025-03-10 11:55:47.66339	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
237	admin	2025-03-10 11:55:48.14996	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
240	admin	2025-03-10 11:55:48.650746	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
243	admin	2025-03-10 11:55:49.157341	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
246	admin	2025-03-10 11:55:49.649926	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
249	admin	2025-03-10 11:55:50.154186	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
252	admin	2025-03-10 11:55:50.670827	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
255	admin	2025-03-10 11:55:51.156822	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
258	admin	2025-03-10 11:55:51.656938	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
261	admin	2025-03-10 11:55:52.166144	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
264	admin	2025-03-10 11:55:52.665651	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
267	admin	2025-03-10 11:55:53.169291	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
270	admin	2025-03-10 11:55:53.677188	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
273	admin	2025-03-10 11:55:54.19393	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
276	admin	2025-03-10 11:55:54.704485	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
279	admin	2025-03-10 11:55:55.212893	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
282	admin	2025-03-10 11:55:55.728654	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
285	admin	2025-03-10 11:55:56.243054	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
288	admin	2025-03-10 11:55:56.751359	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
291	admin	2025-03-10 11:55:57.286753	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
294	admin	2025-03-10 11:55:57.822015	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
297	admin	2025-03-10 11:55:58.337922	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
300	admin	2025-03-10 11:55:58.857469	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
303	admin	2025-03-10 11:55:59.380672	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
306	admin	2025-03-10 11:56:00.328821	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
309	admin	2025-03-10 11:56:00.858458	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
310	admin	2025-03-10 11:56:02.941953	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
313	admin	2025-03-10 11:56:16.237887	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
148	admin	2025-03-10 11:55:27.900466	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
151	admin	2025-03-10 11:55:28.399993	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
154	admin	2025-03-10 11:55:28.852189	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
157	admin	2025-03-10 11:55:29.324928	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
160	admin	2025-03-10 11:55:29.818144	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
163	admin	2025-03-10 11:55:31.24588	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
166	admin	2025-03-10 11:55:31.761968	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
169	admin	2025-03-10 11:55:34.814268	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
172	admin	2025-03-10 11:55:36.57521	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
175	admin	2025-03-10 11:55:37.101021	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
178	admin	2025-03-10 11:55:38.105389	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
181	admin	2025-03-10 11:55:38.626668	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
184	admin	2025-03-10 11:55:39.131342	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
187	admin	2025-03-10 11:55:39.620641	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
190	admin	2025-03-10 11:55:40.108357	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
193	admin	2025-03-10 11:55:40.643279	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
196	admin	2025-03-10 11:55:41.178963	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
199	admin	2025-03-10 11:55:41.719614	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
202	admin	2025-03-10 11:55:42.248579	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
205	admin	2025-03-10 11:55:42.776832	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
208	admin	2025-03-10 11:55:43.309947	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
211	admin	2025-03-10 11:55:43.853805	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
214	admin	2025-03-10 11:55:44.386108	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
217	admin	2025-03-10 11:55:44.895176	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
220	admin	2025-03-10 11:55:45.406645	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
223	admin	2025-03-10 11:55:45.926014	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
226	admin	2025-03-10 11:55:46.410692	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
229	admin	2025-03-10 11:55:46.878494	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
232	admin	2025-03-10 11:55:47.347491	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
235	admin	2025-03-10 11:55:47.84194	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
238	admin	2025-03-10 11:55:48.318275	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
241	admin	2025-03-10 11:55:48.82313	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
244	admin	2025-03-10 11:55:49.318743	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
247	admin	2025-03-10 11:55:49.823278	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
250	admin	2025-03-10 11:55:50.317728	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
253	admin	2025-03-10 11:55:50.829173	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
256	admin	2025-03-10 11:55:51.335285	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
259	admin	2025-03-10 11:55:51.829949	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
262	admin	2025-03-10 11:55:52.343262	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
265	admin	2025-03-10 11:55:52.833581	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
268	admin	2025-03-10 11:55:53.336162	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
271	admin	2025-03-10 11:55:53.855077	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
274	admin	2025-03-10 11:55:54.371924	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
277	admin	2025-03-10 11:55:54.872628	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
280	admin	2025-03-10 11:55:55.383646	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
283	admin	2025-03-10 11:55:55.900174	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
286	admin	2025-03-10 11:55:56.406327	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
289	admin	2025-03-10 11:55:56.941979	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
292	admin	2025-03-10 11:55:57.462883	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
295	admin	2025-03-10 11:55:58.012844	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
298	admin	2025-03-10 11:55:58.51735	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
301	admin	2025-03-10 11:55:59.025605	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
304	admin	2025-03-10 11:55:59.549057	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
307	admin	2025-03-10 11:56:00.493013	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
311	admin	2025-03-10 11:56:09.222597	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
149	admin	2025-03-10 11:55:28.081584	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
152	admin	2025-03-10 11:55:28.538706	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
155	admin	2025-03-10 11:55:28.997442	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
158	admin	2025-03-10 11:55:29.486305	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
161	admin	2025-03-10 11:55:30.289892	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
164	admin	2025-03-10 11:55:31.429782	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
167	admin	2025-03-10 11:55:34.421447	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
170	admin	2025-03-10 11:55:35.003846	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
173	admin	2025-03-10 11:55:36.813943	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
176	admin	2025-03-10 11:55:37.593954	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
179	admin	2025-03-10 11:55:38.289674	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
182	admin	2025-03-10 11:55:38.801318	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
185	admin	2025-03-10 11:55:39.287516	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
188	admin	2025-03-10 11:55:39.789956	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
191	admin	2025-03-10 11:55:40.295905	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
194	admin	2025-03-10 11:55:40.826051	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
197	admin	2025-03-10 11:55:41.364465	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
200	admin	2025-03-10 11:55:41.885886	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
203	admin	2025-03-10 11:55:42.435273	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
206	admin	2025-03-10 11:55:42.955254	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
209	admin	2025-03-10 11:55:43.490985	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
212	admin	2025-03-10 11:55:44.029812	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
215	admin	2025-03-10 11:55:44.532006	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
218	admin	2025-03-10 11:55:45.052761	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
221	admin	2025-03-10 11:55:45.569096	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
224	admin	2025-03-10 11:55:46.087376	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
227	admin	2025-03-10 11:55:46.577193	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
230	admin	2025-03-10 11:55:47.025665	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
233	admin	2025-03-10 11:55:47.505484	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
236	admin	2025-03-10 11:55:47.986082	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
239	admin	2025-03-10 11:55:48.488511	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
242	admin	2025-03-10 11:55:48.993292	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
245	admin	2025-03-10 11:55:49.483523	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
248	admin	2025-03-10 11:55:49.9954	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
251	admin	2025-03-10 11:55:50.483707	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
254	admin	2025-03-10 11:55:50.994347	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
257	admin	2025-03-10 11:55:51.495914	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
260	admin	2025-03-10 11:55:51.994453	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
263	admin	2025-03-10 11:55:52.50332	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
266	admin	2025-03-10 11:55:52.997014	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
269	admin	2025-03-10 11:55:53.511202	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
272	admin	2025-03-10 11:55:54.024076	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
275	admin	2025-03-10 11:55:54.539685	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
278	admin	2025-03-10 11:55:55.044143	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
281	admin	2025-03-10 11:55:55.556345	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
284	admin	2025-03-10 11:55:56.077056	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
287	admin	2025-03-10 11:55:56.577618	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
290	admin	2025-03-10 11:55:57.096801	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
293	admin	2025-03-10 11:55:57.637159	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
296	admin	2025-03-10 11:55:58.193053	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
299	admin	2025-03-10 11:55:58.681763	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
302	admin	2025-03-10 11:55:59.219985	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
305	admin	2025-03-10 11:56:00.124271	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
308	admin	2025-03-10 11:56:00.676282	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
312	admin	2025-03-10 11:56:13.276997	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
314	admin	2025-03-10 11:56:19.936171	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
315	admin	2025-03-10 11:56:22.544629	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
316	admin	2025-03-10 13:45:03.085027	127.0.0.1	POST /login/	로그인 성공
317	admin	2025-03-10 13:45:03.149493	127.0.0.1	POST /logout	로그아웃 성공
318	admin	2025-03-10 13:45:20.965793	127.0.0.1	POST /login/	로그인 성공
319	admin	2025-03-10 13:45:21.012271	127.0.0.1	POST /logout	로그아웃 성공
320	admin	2025-03-10 13:46:17.537216	127.0.0.1	POST /login/	로그인 성공
321	admin	2025-03-10 13:46:17.593108	127.0.0.1	POST /logout	로그아웃 성공
322	admin	2025-03-10 13:47:15.196583	127.0.0.1	POST /login/	로그인 성공
323	admin	2025-03-10 13:47:15.263034	127.0.0.1	POST /logout	로그아웃 성공
324	admin	2025-03-10 13:48:16.551056	127.0.0.1	POST /login/	로그인 성공
325	admin	2025-03-10 13:48:16.594011	127.0.0.1	POST /logout	로그아웃 성공
326	admin	2025-03-10 14:04:59.171609	127.0.0.1	POST /login/	로그인 성공
327	admin	2025-03-10 14:04:59.22544	127.0.0.1	POST /logout	로그아웃 성공
328	admin	2025-03-10 14:11:13.094597	127.0.0.1	POST /login/	로그인 성공
329	admin	2025-03-10 14:11:13.144614	127.0.0.1	POST /logout	로그아웃 성공
330	admin	2025-03-10 14:12:08.15667	127.0.0.1	POST /login/	로그인 성공
331	admin	2025-03-10 14:12:08.192762	127.0.0.1	POST /logout	로그아웃 성공
332	admin	2025-03-10 14:14:47.865099	127.0.0.1	POST /login/	로그인 성공
333	admin	2025-03-10 14:14:56.55091	127.0.0.1	POST /logout	로그아웃 성공
334	admin	2025-03-10 14:14:59.672239	127.0.0.1	POST /login/	로그인 성공
335	admin	2025-03-10 14:15:13.061619	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
336	admin	2025-03-10 14:16:37.666542	127.0.0.1	POST /logout	로그아웃 성공
337	admin	2025-03-10 14:16:41.647322	127.0.0.1	POST /login/	로그인 성공
338	admin	2025-03-10 14:18:51.545284	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
339	admin	2025-03-10 14:18:52.800448	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
340	admin	2025-03-10 14:18:53.475821	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
341	admin	2025-03-10 14:18:54.239871	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
342	admin	2025-03-10 14:18:55.03999	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
343	admin	2025-03-10 14:18:55.696351	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
344	admin	2025-03-10 14:18:56.672663	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
345	admin	2025-03-10 14:18:57.427015	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
346	admin	2025-03-10 14:18:57.521736	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
347	admin	2025-03-10 14:18:58.18014	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
348	admin	2025-03-10 14:18:59.102662	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
349	admin	2025-03-10 14:19:00.263712	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
350	admin	2025-03-10 14:19:09.276725	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
351	admin	2025-03-10 14:19:10.638684	127.0.0.1	GET /api/userHistory	접속 이력 - 접속 이력 조회 성공
352	admin	2025-03-10 14:19:13.308418	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
353	admin	2025-03-10 14:19:15.964268	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
354	admin	2025-03-10 14:19:17.066921	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
355	admin	2025-03-10 14:19:18.163675	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
356	admin	2025-03-10 14:19:18.90009	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
357	admin	2025-03-10 14:20:37.703077	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
358	admin	2025-03-10 14:20:38.421447	127.0.0.1	POST /logout	로그아웃 성공
359	admin	2025-03-10 14:20:42.11368	127.0.0.1	POST /login/	로그인 성공
360	admin	2025-03-10 14:31:13.120923	127.0.0.1	POST /login/	로그인 성공
361	admin	2025-03-10 14:32:07.441017	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
362	admin	2025-03-10 14:32:10.007922	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
363	admin	2025-03-10 14:33:40.504557	127.0.0.1	POST /login/	로그인 성공
364	admin	2025-03-10 14:33:46.769684	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
365	admin	2025-03-10 14:33:47.942177	127.0.0.1	GET /api/users/	회원 관리 - 회원 조회 성공
366	admin	2025-03-10 14:33:49.346012	127.0.0.1	GET /api/newUserHistory	접속 이력 - 접속 이력 조회 성공
367	admin	2025-03-10 14:35:25.586442	127.0.0.1	POST /login/	로그인 성공
368	admin	2025-03-10 14:39:13.171202	127.0.0.1	POST /login/	로그인 성공
369	admin	2025-03-10 14:40:08.222798	127.0.0.1	POST /logout	로그아웃 성공
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (user_role_id, user_id, role_id) FROM stdin;
1	admin	0
2	test3	2
3	test4	2
4	test2	2
5	test6	2
6	test7	2
7	test8	2
9	test5	2
10	admin	1
11	admin	2
12	test2	2
13	test	2
14	user	1
15	123	0
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, name, email, password, phone, approval_status, created_at, address1, address2) FROM stdin;
admin	슈퍼관리자	admin@naver.com	$2b$12$AvhZVjUcfVaTAzr8V3chDuanLHtIzpGCJPBdzJp39X1T1CG83O9cO	010-1111-1111	Y	2025-02-27 15:15:58.649938	대전 동구 가양남로 1	123
test2	test2	test@naver.com	$2b$12$KBS.O8nfAkUC5rQBRUiAYux79xgMZ0V8j4odYFXC9rxmvzWg7I9hq	010-1111-1112	Y	2025-02-27 15:48:34.171127	대전 동구 가양남로 1	123
test3	test3	test@naver.com	$2b$12$KBS.O8nfAkUC5rQBRUiAYux79xgMZ0V8j4odYFXC9rxmvzWg7I9hq	010-1111-1112	Y	2025-02-27 15:48:34.171127	대전 동구 가양남로 1	123
test4	test4	test@naver.com	$2b$12$KBS.O8nfAkUC5rQBRUiAYux79xgMZ0V8j4odYFXC9rxmvzWg7I9hq	010-1111-1112	Y	2025-02-27 15:48:34.171127	대전 동구 가양남로 1	123
test5	test5	test@naver.com	$2b$12$KBS.O8nfAkUC5rQBRUiAYux79xgMZ0V8j4odYFXC9rxmvzWg7I9hq	010-1111-1112	Y	2025-02-27 15:48:34.171127	대전 동구 가양남로 1	123
test6	test6	test@naver.com	$2b$12$KBS.O8nfAkUC5rQBRUiAYux79xgMZ0V8j4odYFXC9rxmvzWg7I9hq	010-1111-1112	Y	2025-02-27 15:48:34.171127	대전 동구 가양남로 1	123
test7	test7	test@naver.com	$2b$12$KBS.O8nfAkUC5rQBRUiAYux79xgMZ0V8j4odYFXC9rxmvzWg7I9hq	010-1111-1112	Y	2025-02-27 15:48:34.171127	대전 동구 가양남로 1	123
test8	test8	test@naver.com	$2b$12$KBS.O8nfAkUC5rQBRUiAYux79xgMZ0V8j4odYFXC9rxmvzWg7I9hq	010-1111-1112	N	2025-02-27 15:48:34.171127	대전 동구 가양남로 1	123
test	테스트	test@naver.com	$2b$12$rP1cl9ubs0t7w4j8reFSUOz1J/0L4sXVY4BDg4mlzxPjWUPbdJJ.q	010-1111-2222	Y	2025-02-27 16:05:23.874116	대전 동구 가양남로 1	111
user	user	user@naver.com	$2b$12$FSykbGv9JjiWqdXp/jXdOuq9GzMys1cC0taDrzoZcpF3JyD8hvlfa	010-2222-1111	Y	2025-02-27 16:07:03.966573	대전 동구 가양남로 1	123
123	123	123@naver.com	$2b$12$hOu4TqDgZmUXWd9dMVQ4geo2YtLYradCmx1ykOKiZ9QfKwQnW3ABW	010-2007-1567	Y	2025-03-04 09:25:17.439404	대전 동구 가양남로 1	123
\.


--
-- Name: roles_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_role_id_seq', 0, false);


--
-- Name: user_history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_history_history_id_seq', 369, true);


--
-- Name: user_roles_user_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_roles_user_role_id_seq', 15, true);


--
-- Name: blacklist blacklist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blacklist
    ADD CONSTRAINT blacklist_pkey PRIMARY KEY (ip_address);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- Name: user_history user_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_history
    ADD CONSTRAINT user_history_pkey PRIMARY KEY (history_id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_role_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: idx_user_history_login_ip_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_history_login_ip_gin ON public.user_history USING gin (login_ip public.gin_trgm_ops);


--
-- Name: idx_user_history_login_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_history_login_time ON public.user_history USING btree (login_time DESC);


--
-- Name: idx_user_history_memo_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_history_memo_gin ON public.user_history USING gin (memo public.gin_trgm_ops);


--
-- Name: idx_user_history_request_path_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_history_request_path_gin ON public.user_history USING gin (request_path public.gin_trgm_ops);


--
-- Name: idx_user_history_user_id_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_history_user_id_gin ON public.user_history USING gin (user_id public.gin_trgm_ops);


--
-- Name: idx_users_email_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email_gin ON public.users USING gin (email public.gin_trgm_ops);


--
-- Name: idx_users_name_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_name_gin ON public.users USING gin (name public.gin_trgm_ops);


--
-- Name: idx_users_phone_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_phone_gin ON public.users USING gin (phone public.gin_trgm_ops);


--
-- Name: blacklist blacklist_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blacklist
    ADD CONSTRAINT blacklist_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: user_history fk_user_history_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_history
    ADD CONSTRAINT fk_user_history_users FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

