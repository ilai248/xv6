
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	addi	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
      return 1;
  3c:	4505                	li	a0,1
  return 0;
}
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	addi	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  if(re[0] == '\0')
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  5c:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	0005c683          	lbu	a3,0(a1)
  return 0;
  76:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  return 0;
  82:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
}
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret
    return matchstar(re[0], re+2, text);
  90:	862e                	mv	a2,a1
  92:	00250593          	addi	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  return 0;
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b8:	0585                	addi	a1,a1,1
  ba:	00178513          	addi	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
    return 1;
  c8:	4505                	li	a0,1
}
  ca:	8082                	ret

00000000000000cc <match>:
{
  cc:	1101                	addi	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	addi	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  if(re[0] == '^')
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
    if(matchhere(re, text))
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  }while(*text++ != '\0');
  f6:	0485                	addi	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
    return matchhere(re+1, text);
 100:	0505                	addi	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
      return 1;
 10c:	4505                	li	a0,1
}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	addi	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
{
 11a:	711d                	addi	sp,sp,-96
 11c:	ec86                	sd	ra,88(sp)
 11e:	e8a2                	sd	s0,80(sp)
 120:	e4a6                	sd	s1,72(sp)
 122:	e0ca                	sd	s2,64(sp)
 124:	fc4e                	sd	s3,56(sp)
 126:	f852                	sd	s4,48(sp)
 128:	f456                	sd	s5,40(sp)
 12a:	f05a                	sd	s6,32(sp)
 12c:	ec5e                	sd	s7,24(sp)
 12e:	e862                	sd	s8,16(sp)
 130:	e466                	sd	s9,8(sp)
 132:	e06a                	sd	s10,0(sp)
 134:	1080                	addi	s0,sp,96
 136:	8aaa                	mv	s5,a0
 138:	8cae                	mv	s9,a1
  m = 0;
 13a:	4b01                	li	s6,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 13c:	3ff00d13          	li	s10,1023
 140:	00002b97          	auipc	s7,0x2
 144:	ed0b8b93          	addi	s7,s7,-304 # 2010 <buf>
    while((q = strchr(p, '\n')) != 0){
 148:	49a9                	li	s3,10
        write(1, p, q+1 - p);
 14a:	4c05                	li	s8,1
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 14c:	a099                	j	192 <grep+0x78>
      p = q+1;
 14e:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 152:	85ce                	mv	a1,s3
 154:	854a                	mv	a0,s2
 156:	00000097          	auipc	ra,0x0
 15a:	21a080e7          	jalr	538(ra) # 370 <strchr>
 15e:	84aa                	mv	s1,a0
 160:	c51d                	beqz	a0,18e <grep+0x74>
      *q = 0;
 162:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 166:	85ca                	mv	a1,s2
 168:	8556                	mv	a0,s5
 16a:	00000097          	auipc	ra,0x0
 16e:	f62080e7          	jalr	-158(ra) # cc <match>
 172:	dd71                	beqz	a0,14e <grep+0x34>
        *q = '\n';
 174:	01348023          	sb	s3,0(s1)
        write(1, p, q+1 - p);
 178:	00148613          	addi	a2,s1,1
 17c:	4126063b          	subw	a2,a2,s2
 180:	85ca                	mv	a1,s2
 182:	8562                	mv	a0,s8
 184:	00000097          	auipc	ra,0x0
 188:	408080e7          	jalr	1032(ra) # 58c <write>
 18c:	b7c9                	j	14e <grep+0x34>
    if(m > 0){
 18e:	03604663          	bgtz	s6,1ba <grep+0xa0>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 192:	416d063b          	subw	a2,s10,s6
 196:	016b85b3          	add	a1,s7,s6
 19a:	8566                	mv	a0,s9
 19c:	00000097          	auipc	ra,0x0
 1a0:	3e8080e7          	jalr	1000(ra) # 584 <read>
 1a4:	02a05a63          	blez	a0,1d8 <grep+0xbe>
    m += n;
 1a8:	00ab0a3b          	addw	s4,s6,a0
 1ac:	8b52                	mv	s6,s4
    buf[m] = '\0';
 1ae:	014b87b3          	add	a5,s7,s4
 1b2:	00078023          	sb	zero,0(a5)
    p = buf;
 1b6:	895e                	mv	s2,s7
    while((q = strchr(p, '\n')) != 0){
 1b8:	bf69                	j	152 <grep+0x38>
      m -= p - buf;
 1ba:	00002517          	auipc	a0,0x2
 1be:	e5650513          	addi	a0,a0,-426 # 2010 <buf>
 1c2:	40a907b3          	sub	a5,s2,a0
 1c6:	40fa063b          	subw	a2,s4,a5
 1ca:	8b32                	mv	s6,a2
      memmove(buf, p, m);
 1cc:	85ca                	mv	a1,s2
 1ce:	00000097          	auipc	ra,0x0
 1d2:	2e4080e7          	jalr	740(ra) # 4b2 <memmove>
 1d6:	bf75                	j	192 <grep+0x78>
}
 1d8:	60e6                	ld	ra,88(sp)
 1da:	6446                	ld	s0,80(sp)
 1dc:	64a6                	ld	s1,72(sp)
 1de:	6906                	ld	s2,64(sp)
 1e0:	79e2                	ld	s3,56(sp)
 1e2:	7a42                	ld	s4,48(sp)
 1e4:	7aa2                	ld	s5,40(sp)
 1e6:	7b02                	ld	s6,32(sp)
 1e8:	6be2                	ld	s7,24(sp)
 1ea:	6c42                	ld	s8,16(sp)
 1ec:	6ca2                	ld	s9,8(sp)
 1ee:	6d02                	ld	s10,0(sp)
 1f0:	6125                	addi	sp,sp,96
 1f2:	8082                	ret

00000000000001f4 <main>:
{
 1f4:	7179                	addi	sp,sp,-48
 1f6:	f406                	sd	ra,40(sp)
 1f8:	f022                	sd	s0,32(sp)
 1fa:	ec26                	sd	s1,24(sp)
 1fc:	e84a                	sd	s2,16(sp)
 1fe:	e44e                	sd	s3,8(sp)
 200:	e052                	sd	s4,0(sp)
 202:	1800                	addi	s0,sp,48
  if(argc <= 1){
 204:	4785                	li	a5,1
 206:	04a7de63          	bge	a5,a0,262 <main+0x6e>
  pattern = argv[1];
 20a:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 20e:	4789                	li	a5,2
 210:	06a7d763          	bge	a5,a0,27e <main+0x8a>
 214:	01058913          	addi	s2,a1,16
 218:	ffd5099b          	addiw	s3,a0,-3
 21c:	02099793          	slli	a5,s3,0x20
 220:	01d7d993          	srli	s3,a5,0x1d
 224:	05e1                	addi	a1,a1,24
 226:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
 228:	4581                	li	a1,0
 22a:	00093503          	ld	a0,0(s2)
 22e:	00000097          	auipc	ra,0x0
 232:	37e080e7          	jalr	894(ra) # 5ac <open>
 236:	84aa                	mv	s1,a0
 238:	04054e63          	bltz	a0,294 <main+0xa0>
    grep(pattern, fd);
 23c:	85aa                	mv	a1,a0
 23e:	8552                	mv	a0,s4
 240:	00000097          	auipc	ra,0x0
 244:	eda080e7          	jalr	-294(ra) # 11a <grep>
    close(fd);
 248:	8526                	mv	a0,s1
 24a:	00000097          	auipc	ra,0x0
 24e:	34a080e7          	jalr	842(ra) # 594 <close>
  for(i = 2; i < argc; i++){
 252:	0921                	addi	s2,s2,8
 254:	fd391ae3          	bne	s2,s3,228 <main+0x34>
  exit(0);
 258:	4501                	li	a0,0
 25a:	00000097          	auipc	ra,0x0
 25e:	312080e7          	jalr	786(ra) # 56c <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 262:	00001597          	auipc	a1,0x1
 266:	92e58593          	addi	a1,a1,-1746 # b90 <malloc+0x106>
 26a:	4509                	li	a0,2
 26c:	00000097          	auipc	ra,0x0
 270:	734080e7          	jalr	1844(ra) # 9a0 <fprintf>
    exit(1);
 274:	4505                	li	a0,1
 276:	00000097          	auipc	ra,0x0
 27a:	2f6080e7          	jalr	758(ra) # 56c <exit>
    grep(pattern, 0);
 27e:	4581                	li	a1,0
 280:	8552                	mv	a0,s4
 282:	00000097          	auipc	ra,0x0
 286:	e98080e7          	jalr	-360(ra) # 11a <grep>
    exit(0);
 28a:	4501                	li	a0,0
 28c:	00000097          	auipc	ra,0x0
 290:	2e0080e7          	jalr	736(ra) # 56c <exit>
      printf("grep: cannot open %s\n", argv[i]);
 294:	00093583          	ld	a1,0(s2)
 298:	00001517          	auipc	a0,0x1
 29c:	91850513          	addi	a0,a0,-1768 # bb0 <malloc+0x126>
 2a0:	00000097          	auipc	ra,0x0
 2a4:	72e080e7          	jalr	1838(ra) # 9ce <printf>
      exit(1);
 2a8:	4505                	li	a0,1
 2aa:	00000097          	auipc	ra,0x0
 2ae:	2c2080e7          	jalr	706(ra) # 56c <exit>

00000000000002b2 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e406                	sd	ra,8(sp)
 2b6:	e022                	sd	s0,0(sp)
 2b8:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2ba:	00000097          	auipc	ra,0x0
 2be:	f3a080e7          	jalr	-198(ra) # 1f4 <main>
  exit(0);
 2c2:	4501                	li	a0,0
 2c4:	00000097          	auipc	ra,0x0
 2c8:	2a8080e7          	jalr	680(ra) # 56c <exit>

00000000000002cc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e406                	sd	ra,8(sp)
 2d0:	e022                	sd	s0,0(sp)
 2d2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2d4:	87aa                	mv	a5,a0
 2d6:	0585                	addi	a1,a1,1
 2d8:	0785                	addi	a5,a5,1
 2da:	fff5c703          	lbu	a4,-1(a1)
 2de:	fee78fa3          	sb	a4,-1(a5)
 2e2:	fb75                	bnez	a4,2d6 <strcpy+0xa>
    ;
  return os;
}
 2e4:	60a2                	ld	ra,8(sp)
 2e6:	6402                	ld	s0,0(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e406                	sd	ra,8(sp)
 2f0:	e022                	sd	s0,0(sp)
 2f2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2f4:	00054783          	lbu	a5,0(a0)
 2f8:	cb91                	beqz	a5,30c <strcmp+0x20>
 2fa:	0005c703          	lbu	a4,0(a1)
 2fe:	00f71763          	bne	a4,a5,30c <strcmp+0x20>
    p++, q++;
 302:	0505                	addi	a0,a0,1
 304:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 306:	00054783          	lbu	a5,0(a0)
 30a:	fbe5                	bnez	a5,2fa <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 30c:	0005c503          	lbu	a0,0(a1)
}
 310:	40a7853b          	subw	a0,a5,a0
 314:	60a2                	ld	ra,8(sp)
 316:	6402                	ld	s0,0(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret

000000000000031c <strlen>:

uint
strlen(const char *s)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e406                	sd	ra,8(sp)
 320:	e022                	sd	s0,0(sp)
 322:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 324:	00054783          	lbu	a5,0(a0)
 328:	cf99                	beqz	a5,346 <strlen+0x2a>
 32a:	0505                	addi	a0,a0,1
 32c:	87aa                	mv	a5,a0
 32e:	86be                	mv	a3,a5
 330:	0785                	addi	a5,a5,1
 332:	fff7c703          	lbu	a4,-1(a5)
 336:	ff65                	bnez	a4,32e <strlen+0x12>
 338:	40a6853b          	subw	a0,a3,a0
 33c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 33e:	60a2                	ld	ra,8(sp)
 340:	6402                	ld	s0,0(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret
  for(n = 0; s[n]; n++)
 346:	4501                	li	a0,0
 348:	bfdd                	j	33e <strlen+0x22>

000000000000034a <memset>:

void*
memset(void *dst, int c, uint n)
{
 34a:	1141                	addi	sp,sp,-16
 34c:	e406                	sd	ra,8(sp)
 34e:	e022                	sd	s0,0(sp)
 350:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 352:	ca19                	beqz	a2,368 <memset+0x1e>
 354:	87aa                	mv	a5,a0
 356:	1602                	slli	a2,a2,0x20
 358:	9201                	srli	a2,a2,0x20
 35a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 35e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 362:	0785                	addi	a5,a5,1
 364:	fee79de3          	bne	a5,a4,35e <memset+0x14>
  }
  return dst;
}
 368:	60a2                	ld	ra,8(sp)
 36a:	6402                	ld	s0,0(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret

0000000000000370 <strchr>:

char*
strchr(const char *s, char c)
{
 370:	1141                	addi	sp,sp,-16
 372:	e406                	sd	ra,8(sp)
 374:	e022                	sd	s0,0(sp)
 376:	0800                	addi	s0,sp,16
  for(; *s; s++)
 378:	00054783          	lbu	a5,0(a0)
 37c:	cf81                	beqz	a5,394 <strchr+0x24>
    if(*s == c)
 37e:	00f58763          	beq	a1,a5,38c <strchr+0x1c>
  for(; *s; s++)
 382:	0505                	addi	a0,a0,1
 384:	00054783          	lbu	a5,0(a0)
 388:	fbfd                	bnez	a5,37e <strchr+0xe>
      return (char*)s;
  return 0;
 38a:	4501                	li	a0,0
}
 38c:	60a2                	ld	ra,8(sp)
 38e:	6402                	ld	s0,0(sp)
 390:	0141                	addi	sp,sp,16
 392:	8082                	ret
  return 0;
 394:	4501                	li	a0,0
 396:	bfdd                	j	38c <strchr+0x1c>

0000000000000398 <gets>:

char*
gets(char *buf, int max)
{
 398:	7159                	addi	sp,sp,-112
 39a:	f486                	sd	ra,104(sp)
 39c:	f0a2                	sd	s0,96(sp)
 39e:	eca6                	sd	s1,88(sp)
 3a0:	e8ca                	sd	s2,80(sp)
 3a2:	e4ce                	sd	s3,72(sp)
 3a4:	e0d2                	sd	s4,64(sp)
 3a6:	fc56                	sd	s5,56(sp)
 3a8:	f85a                	sd	s6,48(sp)
 3aa:	f45e                	sd	s7,40(sp)
 3ac:	f062                	sd	s8,32(sp)
 3ae:	ec66                	sd	s9,24(sp)
 3b0:	e86a                	sd	s10,16(sp)
 3b2:	1880                	addi	s0,sp,112
 3b4:	8caa                	mv	s9,a0
 3b6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b8:	892a                	mv	s2,a0
 3ba:	4481                	li	s1,0
    cc = read(0, &c, 1);
 3bc:	f9f40b13          	addi	s6,s0,-97
 3c0:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3c2:	4ba9                	li	s7,10
 3c4:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 3c6:	8d26                	mv	s10,s1
 3c8:	0014899b          	addiw	s3,s1,1
 3cc:	84ce                	mv	s1,s3
 3ce:	0349d763          	bge	s3,s4,3fc <gets+0x64>
    cc = read(0, &c, 1);
 3d2:	8656                	mv	a2,s5
 3d4:	85da                	mv	a1,s6
 3d6:	4501                	li	a0,0
 3d8:	00000097          	auipc	ra,0x0
 3dc:	1ac080e7          	jalr	428(ra) # 584 <read>
    if(cc < 1)
 3e0:	00a05e63          	blez	a0,3fc <gets+0x64>
    buf[i++] = c;
 3e4:	f9f44783          	lbu	a5,-97(s0)
 3e8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3ec:	01778763          	beq	a5,s7,3fa <gets+0x62>
 3f0:	0905                	addi	s2,s2,1
 3f2:	fd879ae3          	bne	a5,s8,3c6 <gets+0x2e>
    buf[i++] = c;
 3f6:	8d4e                	mv	s10,s3
 3f8:	a011                	j	3fc <gets+0x64>
 3fa:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 3fc:	9d66                	add	s10,s10,s9
 3fe:	000d0023          	sb	zero,0(s10)
  return buf;
}
 402:	8566                	mv	a0,s9
 404:	70a6                	ld	ra,104(sp)
 406:	7406                	ld	s0,96(sp)
 408:	64e6                	ld	s1,88(sp)
 40a:	6946                	ld	s2,80(sp)
 40c:	69a6                	ld	s3,72(sp)
 40e:	6a06                	ld	s4,64(sp)
 410:	7ae2                	ld	s5,56(sp)
 412:	7b42                	ld	s6,48(sp)
 414:	7ba2                	ld	s7,40(sp)
 416:	7c02                	ld	s8,32(sp)
 418:	6ce2                	ld	s9,24(sp)
 41a:	6d42                	ld	s10,16(sp)
 41c:	6165                	addi	sp,sp,112
 41e:	8082                	ret

0000000000000420 <stat>:

int
stat(const char *n, struct stat *st)
{
 420:	1101                	addi	sp,sp,-32
 422:	ec06                	sd	ra,24(sp)
 424:	e822                	sd	s0,16(sp)
 426:	e04a                	sd	s2,0(sp)
 428:	1000                	addi	s0,sp,32
 42a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 42c:	4581                	li	a1,0
 42e:	00000097          	auipc	ra,0x0
 432:	17e080e7          	jalr	382(ra) # 5ac <open>
  if(fd < 0)
 436:	02054663          	bltz	a0,462 <stat+0x42>
 43a:	e426                	sd	s1,8(sp)
 43c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 43e:	85ca                	mv	a1,s2
 440:	00000097          	auipc	ra,0x0
 444:	184080e7          	jalr	388(ra) # 5c4 <fstat>
 448:	892a                	mv	s2,a0
  close(fd);
 44a:	8526                	mv	a0,s1
 44c:	00000097          	auipc	ra,0x0
 450:	148080e7          	jalr	328(ra) # 594 <close>
  return r;
 454:	64a2                	ld	s1,8(sp)
}
 456:	854a                	mv	a0,s2
 458:	60e2                	ld	ra,24(sp)
 45a:	6442                	ld	s0,16(sp)
 45c:	6902                	ld	s2,0(sp)
 45e:	6105                	addi	sp,sp,32
 460:	8082                	ret
    return -1;
 462:	597d                	li	s2,-1
 464:	bfcd                	j	456 <stat+0x36>

0000000000000466 <atoi>:

int
atoi(const char *s)
{
 466:	1141                	addi	sp,sp,-16
 468:	e406                	sd	ra,8(sp)
 46a:	e022                	sd	s0,0(sp)
 46c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 46e:	00054683          	lbu	a3,0(a0)
 472:	fd06879b          	addiw	a5,a3,-48
 476:	0ff7f793          	zext.b	a5,a5
 47a:	4625                	li	a2,9
 47c:	02f66963          	bltu	a2,a5,4ae <atoi+0x48>
 480:	872a                	mv	a4,a0
  n = 0;
 482:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 484:	0705                	addi	a4,a4,1
 486:	0025179b          	slliw	a5,a0,0x2
 48a:	9fa9                	addw	a5,a5,a0
 48c:	0017979b          	slliw	a5,a5,0x1
 490:	9fb5                	addw	a5,a5,a3
 492:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 496:	00074683          	lbu	a3,0(a4)
 49a:	fd06879b          	addiw	a5,a3,-48
 49e:	0ff7f793          	zext.b	a5,a5
 4a2:	fef671e3          	bgeu	a2,a5,484 <atoi+0x1e>
  return n;
}
 4a6:	60a2                	ld	ra,8(sp)
 4a8:	6402                	ld	s0,0(sp)
 4aa:	0141                	addi	sp,sp,16
 4ac:	8082                	ret
  n = 0;
 4ae:	4501                	li	a0,0
 4b0:	bfdd                	j	4a6 <atoi+0x40>

00000000000004b2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4b2:	1141                	addi	sp,sp,-16
 4b4:	e406                	sd	ra,8(sp)
 4b6:	e022                	sd	s0,0(sp)
 4b8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4ba:	02b57563          	bgeu	a0,a1,4e4 <memmove+0x32>
    while(n-- > 0)
 4be:	00c05f63          	blez	a2,4dc <memmove+0x2a>
 4c2:	1602                	slli	a2,a2,0x20
 4c4:	9201                	srli	a2,a2,0x20
 4c6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4ca:	872a                	mv	a4,a0
      *dst++ = *src++;
 4cc:	0585                	addi	a1,a1,1
 4ce:	0705                	addi	a4,a4,1
 4d0:	fff5c683          	lbu	a3,-1(a1)
 4d4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4d8:	fee79ae3          	bne	a5,a4,4cc <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4dc:	60a2                	ld	ra,8(sp)
 4de:	6402                	ld	s0,0(sp)
 4e0:	0141                	addi	sp,sp,16
 4e2:	8082                	ret
    dst += n;
 4e4:	00c50733          	add	a4,a0,a2
    src += n;
 4e8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4ea:	fec059e3          	blez	a2,4dc <memmove+0x2a>
 4ee:	fff6079b          	addiw	a5,a2,-1
 4f2:	1782                	slli	a5,a5,0x20
 4f4:	9381                	srli	a5,a5,0x20
 4f6:	fff7c793          	not	a5,a5
 4fa:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4fc:	15fd                	addi	a1,a1,-1
 4fe:	177d                	addi	a4,a4,-1
 500:	0005c683          	lbu	a3,0(a1)
 504:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 508:	fef71ae3          	bne	a4,a5,4fc <memmove+0x4a>
 50c:	bfc1                	j	4dc <memmove+0x2a>

000000000000050e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 50e:	1141                	addi	sp,sp,-16
 510:	e406                	sd	ra,8(sp)
 512:	e022                	sd	s0,0(sp)
 514:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 516:	ca0d                	beqz	a2,548 <memcmp+0x3a>
 518:	fff6069b          	addiw	a3,a2,-1
 51c:	1682                	slli	a3,a3,0x20
 51e:	9281                	srli	a3,a3,0x20
 520:	0685                	addi	a3,a3,1
 522:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 524:	00054783          	lbu	a5,0(a0)
 528:	0005c703          	lbu	a4,0(a1)
 52c:	00e79863          	bne	a5,a4,53c <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 530:	0505                	addi	a0,a0,1
    p2++;
 532:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 534:	fed518e3          	bne	a0,a3,524 <memcmp+0x16>
  }
  return 0;
 538:	4501                	li	a0,0
 53a:	a019                	j	540 <memcmp+0x32>
      return *p1 - *p2;
 53c:	40e7853b          	subw	a0,a5,a4
}
 540:	60a2                	ld	ra,8(sp)
 542:	6402                	ld	s0,0(sp)
 544:	0141                	addi	sp,sp,16
 546:	8082                	ret
  return 0;
 548:	4501                	li	a0,0
 54a:	bfdd                	j	540 <memcmp+0x32>

000000000000054c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 54c:	1141                	addi	sp,sp,-16
 54e:	e406                	sd	ra,8(sp)
 550:	e022                	sd	s0,0(sp)
 552:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 554:	00000097          	auipc	ra,0x0
 558:	f5e080e7          	jalr	-162(ra) # 4b2 <memmove>
}
 55c:	60a2                	ld	ra,8(sp)
 55e:	6402                	ld	s0,0(sp)
 560:	0141                	addi	sp,sp,16
 562:	8082                	ret

0000000000000564 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 564:	4885                	li	a7,1
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <exit>:
.global exit
exit:
 li a7, SYS_exit
 56c:	4889                	li	a7,2
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <wait>:
.global wait
wait:
 li a7, SYS_wait
 574:	488d                	li	a7,3
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 57c:	4891                	li	a7,4
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <read>:
.global read
read:
 li a7, SYS_read
 584:	4895                	li	a7,5
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <write>:
.global write
write:
 li a7, SYS_write
 58c:	48c1                	li	a7,16
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <close>:
.global close
close:
 li a7, SYS_close
 594:	48d5                	li	a7,21
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <kill>:
.global kill
kill:
 li a7, SYS_kill
 59c:	4899                	li	a7,6
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5a4:	489d                	li	a7,7
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <open>:
.global open
open:
 li a7, SYS_open
 5ac:	48bd                	li	a7,15
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5b4:	48c5                	li	a7,17
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5bc:	48c9                	li	a7,18
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5c4:	48a1                	li	a7,8
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <link>:
.global link
link:
 li a7, SYS_link
 5cc:	48cd                	li	a7,19
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5d4:	48d1                	li	a7,20
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5dc:	48a5                	li	a7,9
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5e4:	48a9                	li	a7,10
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5ec:	48ad                	li	a7,11
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5f4:	48b1                	li	a7,12
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5fc:	48b5                	li	a7,13
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 604:	48b9                	li	a7,14
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <trace>:
.global trace
trace:
 li a7, SYS_trace
 60c:	48d9                	li	a7,22
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 614:	48dd                	li	a7,23
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 61c:	1101                	addi	sp,sp,-32
 61e:	ec06                	sd	ra,24(sp)
 620:	e822                	sd	s0,16(sp)
 622:	1000                	addi	s0,sp,32
 624:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 628:	4605                	li	a2,1
 62a:	fef40593          	addi	a1,s0,-17
 62e:	00000097          	auipc	ra,0x0
 632:	f5e080e7          	jalr	-162(ra) # 58c <write>
}
 636:	60e2                	ld	ra,24(sp)
 638:	6442                	ld	s0,16(sp)
 63a:	6105                	addi	sp,sp,32
 63c:	8082                	ret

000000000000063e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 63e:	7139                	addi	sp,sp,-64
 640:	fc06                	sd	ra,56(sp)
 642:	f822                	sd	s0,48(sp)
 644:	f426                	sd	s1,40(sp)
 646:	f04a                	sd	s2,32(sp)
 648:	ec4e                	sd	s3,24(sp)
 64a:	0080                	addi	s0,sp,64
 64c:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 64e:	c299                	beqz	a3,654 <printint+0x16>
 650:	0805c063          	bltz	a1,6d0 <printint+0x92>
  neg = 0;
 654:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 656:	fc040313          	addi	t1,s0,-64
  neg = 0;
 65a:	869a                	mv	a3,t1
  i = 0;
 65c:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 65e:	00000817          	auipc	a6,0x0
 662:	57280813          	addi	a6,a6,1394 # bd0 <digits>
 666:	88be                	mv	a7,a5
 668:	0017851b          	addiw	a0,a5,1
 66c:	87aa                	mv	a5,a0
 66e:	02c5f73b          	remuw	a4,a1,a2
 672:	1702                	slli	a4,a4,0x20
 674:	9301                	srli	a4,a4,0x20
 676:	9742                	add	a4,a4,a6
 678:	00074703          	lbu	a4,0(a4)
 67c:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 680:	872e                	mv	a4,a1
 682:	02c5d5bb          	divuw	a1,a1,a2
 686:	0685                	addi	a3,a3,1
 688:	fcc77fe3          	bgeu	a4,a2,666 <printint+0x28>
  if(neg)
 68c:	000e0c63          	beqz	t3,6a4 <printint+0x66>
    buf[i++] = '-';
 690:	fd050793          	addi	a5,a0,-48
 694:	00878533          	add	a0,a5,s0
 698:	02d00793          	li	a5,45
 69c:	fef50823          	sb	a5,-16(a0)
 6a0:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 6a4:	fff7899b          	addiw	s3,a5,-1
 6a8:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 6ac:	fff4c583          	lbu	a1,-1(s1)
 6b0:	854a                	mv	a0,s2
 6b2:	00000097          	auipc	ra,0x0
 6b6:	f6a080e7          	jalr	-150(ra) # 61c <putc>
  while(--i >= 0)
 6ba:	39fd                	addiw	s3,s3,-1
 6bc:	14fd                	addi	s1,s1,-1
 6be:	fe09d7e3          	bgez	s3,6ac <printint+0x6e>
}
 6c2:	70e2                	ld	ra,56(sp)
 6c4:	7442                	ld	s0,48(sp)
 6c6:	74a2                	ld	s1,40(sp)
 6c8:	7902                	ld	s2,32(sp)
 6ca:	69e2                	ld	s3,24(sp)
 6cc:	6121                	addi	sp,sp,64
 6ce:	8082                	ret
    x = -xx;
 6d0:	40b005bb          	negw	a1,a1
    neg = 1;
 6d4:	4e05                	li	t3,1
    x = -xx;
 6d6:	b741                	j	656 <printint+0x18>

00000000000006d8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6d8:	711d                	addi	sp,sp,-96
 6da:	ec86                	sd	ra,88(sp)
 6dc:	e8a2                	sd	s0,80(sp)
 6de:	e4a6                	sd	s1,72(sp)
 6e0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6e2:	0005c483          	lbu	s1,0(a1)
 6e6:	2a048863          	beqz	s1,996 <vprintf+0x2be>
 6ea:	e0ca                	sd	s2,64(sp)
 6ec:	fc4e                	sd	s3,56(sp)
 6ee:	f852                	sd	s4,48(sp)
 6f0:	f456                	sd	s5,40(sp)
 6f2:	f05a                	sd	s6,32(sp)
 6f4:	ec5e                	sd	s7,24(sp)
 6f6:	e862                	sd	s8,16(sp)
 6f8:	e466                	sd	s9,8(sp)
 6fa:	8b2a                	mv	s6,a0
 6fc:	8a2e                	mv	s4,a1
 6fe:	8bb2                	mv	s7,a2
  state = 0;
 700:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 702:	4901                	li	s2,0
 704:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 706:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 70a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 70e:	06c00c93          	li	s9,108
 712:	a01d                	j	738 <vprintf+0x60>
        putc(fd, c0);
 714:	85a6                	mv	a1,s1
 716:	855a                	mv	a0,s6
 718:	00000097          	auipc	ra,0x0
 71c:	f04080e7          	jalr	-252(ra) # 61c <putc>
 720:	a019                	j	726 <vprintf+0x4e>
    } else if(state == '%'){
 722:	03598363          	beq	s3,s5,748 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 726:	0019079b          	addiw	a5,s2,1
 72a:	893e                	mv	s2,a5
 72c:	873e                	mv	a4,a5
 72e:	97d2                	add	a5,a5,s4
 730:	0007c483          	lbu	s1,0(a5)
 734:	24048963          	beqz	s1,986 <vprintf+0x2ae>
    c0 = fmt[i] & 0xff;
 738:	0004879b          	sext.w	a5,s1
    if(state == 0){
 73c:	fe0993e3          	bnez	s3,722 <vprintf+0x4a>
      if(c0 == '%'){
 740:	fd579ae3          	bne	a5,s5,714 <vprintf+0x3c>
        state = '%';
 744:	89be                	mv	s3,a5
 746:	b7c5                	j	726 <vprintf+0x4e>
      if(c0) c1 = fmt[i+1] & 0xff;
 748:	00ea06b3          	add	a3,s4,a4
 74c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 750:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 752:	c681                	beqz	a3,75a <vprintf+0x82>
 754:	9752                	add	a4,a4,s4
 756:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 75a:	05878063          	beq	a5,s8,79a <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 75e:	05978c63          	beq	a5,s9,7b6 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 762:	07500713          	li	a4,117
 766:	10e78063          	beq	a5,a4,866 <vprintf+0x18e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 76a:	07800713          	li	a4,120
 76e:	14e78863          	beq	a5,a4,8be <vprintf+0x1e6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 772:	07000713          	li	a4,112
 776:	18e78163          	beq	a5,a4,8f8 <vprintf+0x220>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 77a:	07300713          	li	a4,115
 77e:	1ce78663          	beq	a5,a4,94a <vprintf+0x272>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 782:	02500713          	li	a4,37
 786:	04e79863          	bne	a5,a4,7d6 <vprintf+0xfe>
        putc(fd, '%');
 78a:	85ba                	mv	a1,a4
 78c:	855a                	mv	a0,s6
 78e:	00000097          	auipc	ra,0x0
 792:	e8e080e7          	jalr	-370(ra) # 61c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 796:	4981                	li	s3,0
 798:	b779                	j	726 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 1);
 79a:	008b8493          	addi	s1,s7,8
 79e:	4685                	li	a3,1
 7a0:	4629                	li	a2,10
 7a2:	000ba583          	lw	a1,0(s7)
 7a6:	855a                	mv	a0,s6
 7a8:	00000097          	auipc	ra,0x0
 7ac:	e96080e7          	jalr	-362(ra) # 63e <printint>
 7b0:	8ba6                	mv	s7,s1
      state = 0;
 7b2:	4981                	li	s3,0
 7b4:	bf8d                	j	726 <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'd'){
 7b6:	06400793          	li	a5,100
 7ba:	02f68d63          	beq	a3,a5,7f4 <vprintf+0x11c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7be:	06c00793          	li	a5,108
 7c2:	04f68863          	beq	a3,a5,812 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'u'){
 7c6:	07500793          	li	a5,117
 7ca:	0af68c63          	beq	a3,a5,882 <vprintf+0x1aa>
      } else if(c0 == 'l' && c1 == 'x'){
 7ce:	07800793          	li	a5,120
 7d2:	10f68463          	beq	a3,a5,8da <vprintf+0x202>
        putc(fd, '%');
 7d6:	02500593          	li	a1,37
 7da:	855a                	mv	a0,s6
 7dc:	00000097          	auipc	ra,0x0
 7e0:	e40080e7          	jalr	-448(ra) # 61c <putc>
        putc(fd, c0);
 7e4:	85a6                	mv	a1,s1
 7e6:	855a                	mv	a0,s6
 7e8:	00000097          	auipc	ra,0x0
 7ec:	e34080e7          	jalr	-460(ra) # 61c <putc>
      state = 0;
 7f0:	4981                	li	s3,0
 7f2:	bf15                	j	726 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7f4:	008b8493          	addi	s1,s7,8
 7f8:	4685                	li	a3,1
 7fa:	4629                	li	a2,10
 7fc:	000ba583          	lw	a1,0(s7)
 800:	855a                	mv	a0,s6
 802:	00000097          	auipc	ra,0x0
 806:	e3c080e7          	jalr	-452(ra) # 63e <printint>
        i += 1;
 80a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 80c:	8ba6                	mv	s7,s1
      state = 0;
 80e:	4981                	li	s3,0
        i += 1;
 810:	bf19                	j	726 <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 812:	06400793          	li	a5,100
 816:	02f60963          	beq	a2,a5,848 <vprintf+0x170>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 81a:	07500793          	li	a5,117
 81e:	08f60163          	beq	a2,a5,8a0 <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 822:	07800793          	li	a5,120
 826:	faf618e3          	bne	a2,a5,7d6 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 82a:	008b8493          	addi	s1,s7,8
 82e:	4681                	li	a3,0
 830:	4641                	li	a2,16
 832:	000ba583          	lw	a1,0(s7)
 836:	855a                	mv	a0,s6
 838:	00000097          	auipc	ra,0x0
 83c:	e06080e7          	jalr	-506(ra) # 63e <printint>
        i += 2;
 840:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 842:	8ba6                	mv	s7,s1
      state = 0;
 844:	4981                	li	s3,0
        i += 2;
 846:	b5c5                	j	726 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 848:	008b8493          	addi	s1,s7,8
 84c:	4685                	li	a3,1
 84e:	4629                	li	a2,10
 850:	000ba583          	lw	a1,0(s7)
 854:	855a                	mv	a0,s6
 856:	00000097          	auipc	ra,0x0
 85a:	de8080e7          	jalr	-536(ra) # 63e <printint>
        i += 2;
 85e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 860:	8ba6                	mv	s7,s1
      state = 0;
 862:	4981                	li	s3,0
        i += 2;
 864:	b5c9                	j	726 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 0);
 866:	008b8493          	addi	s1,s7,8
 86a:	4681                	li	a3,0
 86c:	4629                	li	a2,10
 86e:	000ba583          	lw	a1,0(s7)
 872:	855a                	mv	a0,s6
 874:	00000097          	auipc	ra,0x0
 878:	dca080e7          	jalr	-566(ra) # 63e <printint>
 87c:	8ba6                	mv	s7,s1
      state = 0;
 87e:	4981                	li	s3,0
 880:	b55d                	j	726 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
 882:	008b8493          	addi	s1,s7,8
 886:	4681                	li	a3,0
 888:	4629                	li	a2,10
 88a:	000ba583          	lw	a1,0(s7)
 88e:	855a                	mv	a0,s6
 890:	00000097          	auipc	ra,0x0
 894:	dae080e7          	jalr	-594(ra) # 63e <printint>
        i += 1;
 898:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 89a:	8ba6                	mv	s7,s1
      state = 0;
 89c:	4981                	li	s3,0
        i += 1;
 89e:	b561                	j	726 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8a0:	008b8493          	addi	s1,s7,8
 8a4:	4681                	li	a3,0
 8a6:	4629                	li	a2,10
 8a8:	000ba583          	lw	a1,0(s7)
 8ac:	855a                	mv	a0,s6
 8ae:	00000097          	auipc	ra,0x0
 8b2:	d90080e7          	jalr	-624(ra) # 63e <printint>
        i += 2;
 8b6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8b8:	8ba6                	mv	s7,s1
      state = 0;
 8ba:	4981                	li	s3,0
        i += 2;
 8bc:	b5ad                	j	726 <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 16, 0);
 8be:	008b8493          	addi	s1,s7,8
 8c2:	4681                	li	a3,0
 8c4:	4641                	li	a2,16
 8c6:	000ba583          	lw	a1,0(s7)
 8ca:	855a                	mv	a0,s6
 8cc:	00000097          	auipc	ra,0x0
 8d0:	d72080e7          	jalr	-654(ra) # 63e <printint>
 8d4:	8ba6                	mv	s7,s1
      state = 0;
 8d6:	4981                	li	s3,0
 8d8:	b5b9                	j	726 <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8da:	008b8493          	addi	s1,s7,8
 8de:	4681                	li	a3,0
 8e0:	4641                	li	a2,16
 8e2:	000ba583          	lw	a1,0(s7)
 8e6:	855a                	mv	a0,s6
 8e8:	00000097          	auipc	ra,0x0
 8ec:	d56080e7          	jalr	-682(ra) # 63e <printint>
        i += 1;
 8f0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 8f2:	8ba6                	mv	s7,s1
      state = 0;
 8f4:	4981                	li	s3,0
        i += 1;
 8f6:	bd05                	j	726 <vprintf+0x4e>
 8f8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 8fa:	008b8d13          	addi	s10,s7,8
 8fe:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 902:	03000593          	li	a1,48
 906:	855a                	mv	a0,s6
 908:	00000097          	auipc	ra,0x0
 90c:	d14080e7          	jalr	-748(ra) # 61c <putc>
  putc(fd, 'x');
 910:	07800593          	li	a1,120
 914:	855a                	mv	a0,s6
 916:	00000097          	auipc	ra,0x0
 91a:	d06080e7          	jalr	-762(ra) # 61c <putc>
 91e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 920:	00000b97          	auipc	s7,0x0
 924:	2b0b8b93          	addi	s7,s7,688 # bd0 <digits>
 928:	03c9d793          	srli	a5,s3,0x3c
 92c:	97de                	add	a5,a5,s7
 92e:	0007c583          	lbu	a1,0(a5)
 932:	855a                	mv	a0,s6
 934:	00000097          	auipc	ra,0x0
 938:	ce8080e7          	jalr	-792(ra) # 61c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 93c:	0992                	slli	s3,s3,0x4
 93e:	34fd                	addiw	s1,s1,-1
 940:	f4e5                	bnez	s1,928 <vprintf+0x250>
        printptr(fd, va_arg(ap, uint64));
 942:	8bea                	mv	s7,s10
      state = 0;
 944:	4981                	li	s3,0
 946:	6d02                	ld	s10,0(sp)
 948:	bbf9                	j	726 <vprintf+0x4e>
        if((s = va_arg(ap, char*)) == 0)
 94a:	008b8993          	addi	s3,s7,8
 94e:	000bb483          	ld	s1,0(s7)
 952:	c085                	beqz	s1,972 <vprintf+0x29a>
        for(; *s; s++)
 954:	0004c583          	lbu	a1,0(s1)
 958:	c585                	beqz	a1,980 <vprintf+0x2a8>
          putc(fd, *s);
 95a:	855a                	mv	a0,s6
 95c:	00000097          	auipc	ra,0x0
 960:	cc0080e7          	jalr	-832(ra) # 61c <putc>
        for(; *s; s++)
 964:	0485                	addi	s1,s1,1
 966:	0004c583          	lbu	a1,0(s1)
 96a:	f9e5                	bnez	a1,95a <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
 96c:	8bce                	mv	s7,s3
      state = 0;
 96e:	4981                	li	s3,0
 970:	bb5d                	j	726 <vprintf+0x4e>
          s = "(null)";
 972:	00000497          	auipc	s1,0x0
 976:	25648493          	addi	s1,s1,598 # bc8 <malloc+0x13e>
        for(; *s; s++)
 97a:	02800593          	li	a1,40
 97e:	bff1                	j	95a <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
 980:	8bce                	mv	s7,s3
      state = 0;
 982:	4981                	li	s3,0
 984:	b34d                	j	726 <vprintf+0x4e>
 986:	6906                	ld	s2,64(sp)
 988:	79e2                	ld	s3,56(sp)
 98a:	7a42                	ld	s4,48(sp)
 98c:	7aa2                	ld	s5,40(sp)
 98e:	7b02                	ld	s6,32(sp)
 990:	6be2                	ld	s7,24(sp)
 992:	6c42                	ld	s8,16(sp)
 994:	6ca2                	ld	s9,8(sp)
    }
  }
}
 996:	60e6                	ld	ra,88(sp)
 998:	6446                	ld	s0,80(sp)
 99a:	64a6                	ld	s1,72(sp)
 99c:	6125                	addi	sp,sp,96
 99e:	8082                	ret

00000000000009a0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9a0:	715d                	addi	sp,sp,-80
 9a2:	ec06                	sd	ra,24(sp)
 9a4:	e822                	sd	s0,16(sp)
 9a6:	1000                	addi	s0,sp,32
 9a8:	e010                	sd	a2,0(s0)
 9aa:	e414                	sd	a3,8(s0)
 9ac:	e818                	sd	a4,16(s0)
 9ae:	ec1c                	sd	a5,24(s0)
 9b0:	03043023          	sd	a6,32(s0)
 9b4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9b8:	8622                	mv	a2,s0
 9ba:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9be:	00000097          	auipc	ra,0x0
 9c2:	d1a080e7          	jalr	-742(ra) # 6d8 <vprintf>
}
 9c6:	60e2                	ld	ra,24(sp)
 9c8:	6442                	ld	s0,16(sp)
 9ca:	6161                	addi	sp,sp,80
 9cc:	8082                	ret

00000000000009ce <printf>:

void
printf(const char *fmt, ...)
{
 9ce:	711d                	addi	sp,sp,-96
 9d0:	ec06                	sd	ra,24(sp)
 9d2:	e822                	sd	s0,16(sp)
 9d4:	1000                	addi	s0,sp,32
 9d6:	e40c                	sd	a1,8(s0)
 9d8:	e810                	sd	a2,16(s0)
 9da:	ec14                	sd	a3,24(s0)
 9dc:	f018                	sd	a4,32(s0)
 9de:	f41c                	sd	a5,40(s0)
 9e0:	03043823          	sd	a6,48(s0)
 9e4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9e8:	00840613          	addi	a2,s0,8
 9ec:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9f0:	85aa                	mv	a1,a0
 9f2:	4505                	li	a0,1
 9f4:	00000097          	auipc	ra,0x0
 9f8:	ce4080e7          	jalr	-796(ra) # 6d8 <vprintf>
}
 9fc:	60e2                	ld	ra,24(sp)
 9fe:	6442                	ld	s0,16(sp)
 a00:	6125                	addi	sp,sp,96
 a02:	8082                	ret

0000000000000a04 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a04:	1141                	addi	sp,sp,-16
 a06:	e406                	sd	ra,8(sp)
 a08:	e022                	sd	s0,0(sp)
 a0a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a0c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a10:	00001797          	auipc	a5,0x1
 a14:	5f07b783          	ld	a5,1520(a5) # 2000 <freep>
 a18:	a02d                	j	a42 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a1a:	4618                	lw	a4,8(a2)
 a1c:	9f2d                	addw	a4,a4,a1
 a1e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a22:	6398                	ld	a4,0(a5)
 a24:	6310                	ld	a2,0(a4)
 a26:	a83d                	j	a64 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a28:	ff852703          	lw	a4,-8(a0)
 a2c:	9f31                	addw	a4,a4,a2
 a2e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a30:	ff053683          	ld	a3,-16(a0)
 a34:	a091                	j	a78 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a36:	6398                	ld	a4,0(a5)
 a38:	00e7e463          	bltu	a5,a4,a40 <free+0x3c>
 a3c:	00e6ea63          	bltu	a3,a4,a50 <free+0x4c>
{
 a40:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a42:	fed7fae3          	bgeu	a5,a3,a36 <free+0x32>
 a46:	6398                	ld	a4,0(a5)
 a48:	00e6e463          	bltu	a3,a4,a50 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a4c:	fee7eae3          	bltu	a5,a4,a40 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 a50:	ff852583          	lw	a1,-8(a0)
 a54:	6390                	ld	a2,0(a5)
 a56:	02059813          	slli	a6,a1,0x20
 a5a:	01c85713          	srli	a4,a6,0x1c
 a5e:	9736                	add	a4,a4,a3
 a60:	fae60de3          	beq	a2,a4,a1a <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 a64:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a68:	4790                	lw	a2,8(a5)
 a6a:	02061593          	slli	a1,a2,0x20
 a6e:	01c5d713          	srli	a4,a1,0x1c
 a72:	973e                	add	a4,a4,a5
 a74:	fae68ae3          	beq	a3,a4,a28 <free+0x24>
    p->s.ptr = bp->s.ptr;
 a78:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a7a:	00001717          	auipc	a4,0x1
 a7e:	58f73323          	sd	a5,1414(a4) # 2000 <freep>
}
 a82:	60a2                	ld	ra,8(sp)
 a84:	6402                	ld	s0,0(sp)
 a86:	0141                	addi	sp,sp,16
 a88:	8082                	ret

0000000000000a8a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a8a:	7139                	addi	sp,sp,-64
 a8c:	fc06                	sd	ra,56(sp)
 a8e:	f822                	sd	s0,48(sp)
 a90:	f04a                	sd	s2,32(sp)
 a92:	ec4e                	sd	s3,24(sp)
 a94:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a96:	02051993          	slli	s3,a0,0x20
 a9a:	0209d993          	srli	s3,s3,0x20
 a9e:	09bd                	addi	s3,s3,15
 aa0:	0049d993          	srli	s3,s3,0x4
 aa4:	2985                	addiw	s3,s3,1
 aa6:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 aa8:	00001517          	auipc	a0,0x1
 aac:	55853503          	ld	a0,1368(a0) # 2000 <freep>
 ab0:	c905                	beqz	a0,ae0 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ab4:	4798                	lw	a4,8(a5)
 ab6:	09377a63          	bgeu	a4,s3,b4a <malloc+0xc0>
 aba:	f426                	sd	s1,40(sp)
 abc:	e852                	sd	s4,16(sp)
 abe:	e456                	sd	s5,8(sp)
 ac0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 ac2:	8a4e                	mv	s4,s3
 ac4:	6705                	lui	a4,0x1
 ac6:	00e9f363          	bgeu	s3,a4,acc <malloc+0x42>
 aca:	6a05                	lui	s4,0x1
 acc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ad0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ad4:	00001497          	auipc	s1,0x1
 ad8:	52c48493          	addi	s1,s1,1324 # 2000 <freep>
  if(p == (char*)-1)
 adc:	5afd                	li	s5,-1
 ade:	a089                	j	b20 <malloc+0x96>
 ae0:	f426                	sd	s1,40(sp)
 ae2:	e852                	sd	s4,16(sp)
 ae4:	e456                	sd	s5,8(sp)
 ae6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 ae8:	00002797          	auipc	a5,0x2
 aec:	92878793          	addi	a5,a5,-1752 # 2410 <base>
 af0:	00001717          	auipc	a4,0x1
 af4:	50f73823          	sd	a5,1296(a4) # 2000 <freep>
 af8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 afa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 afe:	b7d1                	j	ac2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 b00:	6398                	ld	a4,0(a5)
 b02:	e118                	sd	a4,0(a0)
 b04:	a8b9                	j	b62 <malloc+0xd8>
  hp->s.size = nu;
 b06:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b0a:	0541                	addi	a0,a0,16
 b0c:	00000097          	auipc	ra,0x0
 b10:	ef8080e7          	jalr	-264(ra) # a04 <free>
  return freep;
 b14:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 b16:	c135                	beqz	a0,b7a <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b18:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b1a:	4798                	lw	a4,8(a5)
 b1c:	03277363          	bgeu	a4,s2,b42 <malloc+0xb8>
    if(p == freep)
 b20:	6098                	ld	a4,0(s1)
 b22:	853e                	mv	a0,a5
 b24:	fef71ae3          	bne	a4,a5,b18 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 b28:	8552                	mv	a0,s4
 b2a:	00000097          	auipc	ra,0x0
 b2e:	aca080e7          	jalr	-1334(ra) # 5f4 <sbrk>
  if(p == (char*)-1)
 b32:	fd551ae3          	bne	a0,s5,b06 <malloc+0x7c>
        return 0;
 b36:	4501                	li	a0,0
 b38:	74a2                	ld	s1,40(sp)
 b3a:	6a42                	ld	s4,16(sp)
 b3c:	6aa2                	ld	s5,8(sp)
 b3e:	6b02                	ld	s6,0(sp)
 b40:	a03d                	j	b6e <malloc+0xe4>
 b42:	74a2                	ld	s1,40(sp)
 b44:	6a42                	ld	s4,16(sp)
 b46:	6aa2                	ld	s5,8(sp)
 b48:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b4a:	fae90be3          	beq	s2,a4,b00 <malloc+0x76>
        p->s.size -= nunits;
 b4e:	4137073b          	subw	a4,a4,s3
 b52:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b54:	02071693          	slli	a3,a4,0x20
 b58:	01c6d713          	srli	a4,a3,0x1c
 b5c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b5e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b62:	00001717          	auipc	a4,0x1
 b66:	48a73f23          	sd	a0,1182(a4) # 2000 <freep>
      return (void*)(p + 1);
 b6a:	01078513          	addi	a0,a5,16
  }
}
 b6e:	70e2                	ld	ra,56(sp)
 b70:	7442                	ld	s0,48(sp)
 b72:	7902                	ld	s2,32(sp)
 b74:	69e2                	ld	s3,24(sp)
 b76:	6121                	addi	sp,sp,64
 b78:	8082                	ret
 b7a:	74a2                	ld	s1,40(sp)
 b7c:	6a42                	ld	s4,16(sp)
 b7e:	6aa2                	ld	s5,8(sp)
 b80:	6b02                	ld	s6,0(sp)
 b82:	b7f5                	j	b6e <malloc+0xe4>
