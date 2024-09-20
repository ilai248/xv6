
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	fe2d8d93          	addi	s11,s11,-30 # 1010 <buf>
  36:	20000d13          	li	s10,512
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  3a:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  3c:	00001a17          	auipc	s4,0x1
  40:	974a0a13          	addi	s4,s4,-1676 # 9b0 <malloc+0xf4>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  44:	a035                	j	70 <wc+0x70>
      if(strchr(" \r\t\n\v", buf[i]))
  46:	8552                	mv	a0,s4
  48:	1ca000ef          	jal	212 <strchr>
  4c:	c919                	beqz	a0,62 <wc+0x62>
        inword = 0;
  4e:	4901                	li	s2,0
    for(i=0; i<n; i++){
  50:	0485                	addi	s1,s1,1
  52:	01348d63          	beq	s1,s3,6c <wc+0x6c>
      if(buf[i] == '\n')
  56:	0004c583          	lbu	a1,0(s1)
  5a:	ff5596e3          	bne	a1,s5,46 <wc+0x46>
        l++;
  5e:	2b85                	addiw	s7,s7,1
  60:	b7dd                	j	46 <wc+0x46>
      else if(!inword){
  62:	fe0917e3          	bnez	s2,50 <wc+0x50>
        w++;
  66:	2c05                	addiw	s8,s8,1
        inword = 1;
  68:	4905                	li	s2,1
  6a:	b7dd                	j	50 <wc+0x50>
  6c:	019b0cbb          	addw	s9,s6,s9
  while((n = read(fd, buf, sizeof(buf))) > 0){
  70:	866a                	mv	a2,s10
  72:	85ee                	mv	a1,s11
  74:	f8843503          	ld	a0,-120(s0)
  78:	39a000ef          	jal	412 <read>
  7c:	8b2a                	mv	s6,a0
  7e:	00a05963          	blez	a0,90 <wc+0x90>
  82:	00001497          	auipc	s1,0x1
  86:	f8e48493          	addi	s1,s1,-114 # 1010 <buf>
  8a:	009b09b3          	add	s3,s6,s1
  8e:	b7e1                	j	56 <wc+0x56>
      }
    }
  }
  if(n < 0){
  90:	02054c63          	bltz	a0,c8 <wc+0xc8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  94:	f8043703          	ld	a4,-128(s0)
  98:	86e6                	mv	a3,s9
  9a:	8662                	mv	a2,s8
  9c:	85de                	mv	a1,s7
  9e:	00001517          	auipc	a0,0x1
  a2:	93250513          	addi	a0,a0,-1742 # 9d0 <malloc+0x114>
  a6:	75e000ef          	jal	804 <printf>
}
  aa:	70e6                	ld	ra,120(sp)
  ac:	7446                	ld	s0,112(sp)
  ae:	74a6                	ld	s1,104(sp)
  b0:	7906                	ld	s2,96(sp)
  b2:	69e6                	ld	s3,88(sp)
  b4:	6a46                	ld	s4,80(sp)
  b6:	6aa6                	ld	s5,72(sp)
  b8:	6b06                	ld	s6,64(sp)
  ba:	7be2                	ld	s7,56(sp)
  bc:	7c42                	ld	s8,48(sp)
  be:	7ca2                	ld	s9,40(sp)
  c0:	7d02                	ld	s10,32(sp)
  c2:	6de2                	ld	s11,24(sp)
  c4:	6109                	addi	sp,sp,128
  c6:	8082                	ret
    printf("wc: read error\n");
  c8:	00001517          	auipc	a0,0x1
  cc:	8f850513          	addi	a0,a0,-1800 # 9c0 <malloc+0x104>
  d0:	734000ef          	jal	804 <printf>
    exit(1);
  d4:	4505                	li	a0,1
  d6:	324000ef          	jal	3fa <exit>

00000000000000da <main>:

int
main(int argc, char *argv[])
{
  da:	7179                	addi	sp,sp,-48
  dc:	f406                	sd	ra,40(sp)
  de:	f022                	sd	s0,32(sp)
  e0:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  e2:	4785                	li	a5,1
  e4:	04a7d463          	bge	a5,a0,12c <main+0x52>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
  ee:	00858913          	addi	s2,a1,8
  f2:	ffe5099b          	addiw	s3,a0,-2
  f6:	02099793          	slli	a5,s3,0x20
  fa:	01d7d993          	srli	s3,a5,0x1d
  fe:	05c1                	addi	a1,a1,16
 100:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 102:	4581                	li	a1,0
 104:	00093503          	ld	a0,0(s2)
 108:	332000ef          	jal	43a <open>
 10c:	84aa                	mv	s1,a0
 10e:	02054c63          	bltz	a0,146 <main+0x6c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 112:	00093583          	ld	a1,0(s2)
 116:	eebff0ef          	jal	0 <wc>
    close(fd);
 11a:	8526                	mv	a0,s1
 11c:	306000ef          	jal	422 <close>
  for(i = 1; i < argc; i++){
 120:	0921                	addi	s2,s2,8
 122:	ff3910e3          	bne	s2,s3,102 <main+0x28>
  }
  exit(0);
 126:	4501                	li	a0,0
 128:	2d2000ef          	jal	3fa <exit>
 12c:	ec26                	sd	s1,24(sp)
 12e:	e84a                	sd	s2,16(sp)
 130:	e44e                	sd	s3,8(sp)
    wc(0, "");
 132:	00001597          	auipc	a1,0x1
 136:	88658593          	addi	a1,a1,-1914 # 9b8 <malloc+0xfc>
 13a:	4501                	li	a0,0
 13c:	ec5ff0ef          	jal	0 <wc>
    exit(0);
 140:	4501                	li	a0,0
 142:	2b8000ef          	jal	3fa <exit>
      printf("wc: cannot open %s\n", argv[i]);
 146:	00093583          	ld	a1,0(s2)
 14a:	00001517          	auipc	a0,0x1
 14e:	89650513          	addi	a0,a0,-1898 # 9e0 <malloc+0x124>
 152:	6b2000ef          	jal	804 <printf>
      exit(1);
 156:	4505                	li	a0,1
 158:	2a2000ef          	jal	3fa <exit>

000000000000015c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  extern int main();
  main();
 164:	f77ff0ef          	jal	da <main>
  exit(0);
 168:	4501                	li	a0,0
 16a:	290000ef          	jal	3fa <exit>

000000000000016e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e406                	sd	ra,8(sp)
 172:	e022                	sd	s0,0(sp)
 174:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 176:	87aa                	mv	a5,a0
 178:	0585                	addi	a1,a1,1
 17a:	0785                	addi	a5,a5,1
 17c:	fff5c703          	lbu	a4,-1(a1)
 180:	fee78fa3          	sb	a4,-1(a5)
 184:	fb75                	bnez	a4,178 <strcpy+0xa>
    ;
  return os;
}
 186:	60a2                	ld	ra,8(sp)
 188:	6402                	ld	s0,0(sp)
 18a:	0141                	addi	sp,sp,16
 18c:	8082                	ret

000000000000018e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e406                	sd	ra,8(sp)
 192:	e022                	sd	s0,0(sp)
 194:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 196:	00054783          	lbu	a5,0(a0)
 19a:	cb91                	beqz	a5,1ae <strcmp+0x20>
 19c:	0005c703          	lbu	a4,0(a1)
 1a0:	00f71763          	bne	a4,a5,1ae <strcmp+0x20>
    p++, q++;
 1a4:	0505                	addi	a0,a0,1
 1a6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a8:	00054783          	lbu	a5,0(a0)
 1ac:	fbe5                	bnez	a5,19c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1ae:	0005c503          	lbu	a0,0(a1)
}
 1b2:	40a7853b          	subw	a0,a5,a0
 1b6:	60a2                	ld	ra,8(sp)
 1b8:	6402                	ld	s0,0(sp)
 1ba:	0141                	addi	sp,sp,16
 1bc:	8082                	ret

00000000000001be <strlen>:

uint
strlen(const char *s)
{
 1be:	1141                	addi	sp,sp,-16
 1c0:	e406                	sd	ra,8(sp)
 1c2:	e022                	sd	s0,0(sp)
 1c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1c6:	00054783          	lbu	a5,0(a0)
 1ca:	cf99                	beqz	a5,1e8 <strlen+0x2a>
 1cc:	0505                	addi	a0,a0,1
 1ce:	87aa                	mv	a5,a0
 1d0:	86be                	mv	a3,a5
 1d2:	0785                	addi	a5,a5,1
 1d4:	fff7c703          	lbu	a4,-1(a5)
 1d8:	ff65                	bnez	a4,1d0 <strlen+0x12>
 1da:	40a6853b          	subw	a0,a3,a0
 1de:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1e0:	60a2                	ld	ra,8(sp)
 1e2:	6402                	ld	s0,0(sp)
 1e4:	0141                	addi	sp,sp,16
 1e6:	8082                	ret
  for(n = 0; s[n]; n++)
 1e8:	4501                	li	a0,0
 1ea:	bfdd                	j	1e0 <strlen+0x22>

00000000000001ec <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e406                	sd	ra,8(sp)
 1f0:	e022                	sd	s0,0(sp)
 1f2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1f4:	ca19                	beqz	a2,20a <memset+0x1e>
 1f6:	87aa                	mv	a5,a0
 1f8:	1602                	slli	a2,a2,0x20
 1fa:	9201                	srli	a2,a2,0x20
 1fc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 200:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 204:	0785                	addi	a5,a5,1
 206:	fee79de3          	bne	a5,a4,200 <memset+0x14>
  }
  return dst;
}
 20a:	60a2                	ld	ra,8(sp)
 20c:	6402                	ld	s0,0(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret

0000000000000212 <strchr>:

char*
strchr(const char *s, char c)
{
 212:	1141                	addi	sp,sp,-16
 214:	e406                	sd	ra,8(sp)
 216:	e022                	sd	s0,0(sp)
 218:	0800                	addi	s0,sp,16
  for(; *s; s++)
 21a:	00054783          	lbu	a5,0(a0)
 21e:	cf81                	beqz	a5,236 <strchr+0x24>
    if(*s == c)
 220:	00f58763          	beq	a1,a5,22e <strchr+0x1c>
  for(; *s; s++)
 224:	0505                	addi	a0,a0,1
 226:	00054783          	lbu	a5,0(a0)
 22a:	fbfd                	bnez	a5,220 <strchr+0xe>
      return (char*)s;
  return 0;
 22c:	4501                	li	a0,0
}
 22e:	60a2                	ld	ra,8(sp)
 230:	6402                	ld	s0,0(sp)
 232:	0141                	addi	sp,sp,16
 234:	8082                	ret
  return 0;
 236:	4501                	li	a0,0
 238:	bfdd                	j	22e <strchr+0x1c>

000000000000023a <gets>:

char*
gets(char *buf, int max)
{
 23a:	7159                	addi	sp,sp,-112
 23c:	f486                	sd	ra,104(sp)
 23e:	f0a2                	sd	s0,96(sp)
 240:	eca6                	sd	s1,88(sp)
 242:	e8ca                	sd	s2,80(sp)
 244:	e4ce                	sd	s3,72(sp)
 246:	e0d2                	sd	s4,64(sp)
 248:	fc56                	sd	s5,56(sp)
 24a:	f85a                	sd	s6,48(sp)
 24c:	f45e                	sd	s7,40(sp)
 24e:	f062                	sd	s8,32(sp)
 250:	ec66                	sd	s9,24(sp)
 252:	e86a                	sd	s10,16(sp)
 254:	1880                	addi	s0,sp,112
 256:	8caa                	mv	s9,a0
 258:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25a:	892a                	mv	s2,a0
 25c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 25e:	f9f40b13          	addi	s6,s0,-97
 262:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 264:	4ba9                	li	s7,10
 266:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 268:	8d26                	mv	s10,s1
 26a:	0014899b          	addiw	s3,s1,1
 26e:	84ce                	mv	s1,s3
 270:	0349d563          	bge	s3,s4,29a <gets+0x60>
    cc = read(0, &c, 1);
 274:	8656                	mv	a2,s5
 276:	85da                	mv	a1,s6
 278:	4501                	li	a0,0
 27a:	198000ef          	jal	412 <read>
    if(cc < 1)
 27e:	00a05e63          	blez	a0,29a <gets+0x60>
    buf[i++] = c;
 282:	f9f44783          	lbu	a5,-97(s0)
 286:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 28a:	01778763          	beq	a5,s7,298 <gets+0x5e>
 28e:	0905                	addi	s2,s2,1
 290:	fd879ce3          	bne	a5,s8,268 <gets+0x2e>
    buf[i++] = c;
 294:	8d4e                	mv	s10,s3
 296:	a011                	j	29a <gets+0x60>
 298:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 29a:	9d66                	add	s10,s10,s9
 29c:	000d0023          	sb	zero,0(s10)
  return buf;
}
 2a0:	8566                	mv	a0,s9
 2a2:	70a6                	ld	ra,104(sp)
 2a4:	7406                	ld	s0,96(sp)
 2a6:	64e6                	ld	s1,88(sp)
 2a8:	6946                	ld	s2,80(sp)
 2aa:	69a6                	ld	s3,72(sp)
 2ac:	6a06                	ld	s4,64(sp)
 2ae:	7ae2                	ld	s5,56(sp)
 2b0:	7b42                	ld	s6,48(sp)
 2b2:	7ba2                	ld	s7,40(sp)
 2b4:	7c02                	ld	s8,32(sp)
 2b6:	6ce2                	ld	s9,24(sp)
 2b8:	6d42                	ld	s10,16(sp)
 2ba:	6165                	addi	sp,sp,112
 2bc:	8082                	ret

00000000000002be <stat>:

int
stat(const char *n, struct stat *st)
{
 2be:	1101                	addi	sp,sp,-32
 2c0:	ec06                	sd	ra,24(sp)
 2c2:	e822                	sd	s0,16(sp)
 2c4:	e04a                	sd	s2,0(sp)
 2c6:	1000                	addi	s0,sp,32
 2c8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ca:	4581                	li	a1,0
 2cc:	16e000ef          	jal	43a <open>
  if(fd < 0)
 2d0:	02054263          	bltz	a0,2f4 <stat+0x36>
 2d4:	e426                	sd	s1,8(sp)
 2d6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2d8:	85ca                	mv	a1,s2
 2da:	178000ef          	jal	452 <fstat>
 2de:	892a                	mv	s2,a0
  close(fd);
 2e0:	8526                	mv	a0,s1
 2e2:	140000ef          	jal	422 <close>
  return r;
 2e6:	64a2                	ld	s1,8(sp)
}
 2e8:	854a                	mv	a0,s2
 2ea:	60e2                	ld	ra,24(sp)
 2ec:	6442                	ld	s0,16(sp)
 2ee:	6902                	ld	s2,0(sp)
 2f0:	6105                	addi	sp,sp,32
 2f2:	8082                	ret
    return -1;
 2f4:	597d                	li	s2,-1
 2f6:	bfcd                	j	2e8 <stat+0x2a>

00000000000002f8 <atoi>:

int
atoi(const char *s)
{
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e406                	sd	ra,8(sp)
 2fc:	e022                	sd	s0,0(sp)
 2fe:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 300:	00054683          	lbu	a3,0(a0)
 304:	fd06879b          	addiw	a5,a3,-48
 308:	0ff7f793          	zext.b	a5,a5
 30c:	4625                	li	a2,9
 30e:	02f66963          	bltu	a2,a5,340 <atoi+0x48>
 312:	872a                	mv	a4,a0
  n = 0;
 314:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 316:	0705                	addi	a4,a4,1
 318:	0025179b          	slliw	a5,a0,0x2
 31c:	9fa9                	addw	a5,a5,a0
 31e:	0017979b          	slliw	a5,a5,0x1
 322:	9fb5                	addw	a5,a5,a3
 324:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 328:	00074683          	lbu	a3,0(a4)
 32c:	fd06879b          	addiw	a5,a3,-48
 330:	0ff7f793          	zext.b	a5,a5
 334:	fef671e3          	bgeu	a2,a5,316 <atoi+0x1e>
  return n;
}
 338:	60a2                	ld	ra,8(sp)
 33a:	6402                	ld	s0,0(sp)
 33c:	0141                	addi	sp,sp,16
 33e:	8082                	ret
  n = 0;
 340:	4501                	li	a0,0
 342:	bfdd                	j	338 <atoi+0x40>

0000000000000344 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 344:	1141                	addi	sp,sp,-16
 346:	e406                	sd	ra,8(sp)
 348:	e022                	sd	s0,0(sp)
 34a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 34c:	02b57563          	bgeu	a0,a1,376 <memmove+0x32>
    while(n-- > 0)
 350:	00c05f63          	blez	a2,36e <memmove+0x2a>
 354:	1602                	slli	a2,a2,0x20
 356:	9201                	srli	a2,a2,0x20
 358:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 35c:	872a                	mv	a4,a0
      *dst++ = *src++;
 35e:	0585                	addi	a1,a1,1
 360:	0705                	addi	a4,a4,1
 362:	fff5c683          	lbu	a3,-1(a1)
 366:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 36a:	fee79ae3          	bne	a5,a4,35e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 36e:	60a2                	ld	ra,8(sp)
 370:	6402                	ld	s0,0(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret
    dst += n;
 376:	00c50733          	add	a4,a0,a2
    src += n;
 37a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 37c:	fec059e3          	blez	a2,36e <memmove+0x2a>
 380:	fff6079b          	addiw	a5,a2,-1
 384:	1782                	slli	a5,a5,0x20
 386:	9381                	srli	a5,a5,0x20
 388:	fff7c793          	not	a5,a5
 38c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 38e:	15fd                	addi	a1,a1,-1
 390:	177d                	addi	a4,a4,-1
 392:	0005c683          	lbu	a3,0(a1)
 396:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 39a:	fef71ae3          	bne	a4,a5,38e <memmove+0x4a>
 39e:	bfc1                	j	36e <memmove+0x2a>

00000000000003a0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3a0:	1141                	addi	sp,sp,-16
 3a2:	e406                	sd	ra,8(sp)
 3a4:	e022                	sd	s0,0(sp)
 3a6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3a8:	ca0d                	beqz	a2,3da <memcmp+0x3a>
 3aa:	fff6069b          	addiw	a3,a2,-1
 3ae:	1682                	slli	a3,a3,0x20
 3b0:	9281                	srli	a3,a3,0x20
 3b2:	0685                	addi	a3,a3,1
 3b4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3b6:	00054783          	lbu	a5,0(a0)
 3ba:	0005c703          	lbu	a4,0(a1)
 3be:	00e79863          	bne	a5,a4,3ce <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 3c2:	0505                	addi	a0,a0,1
    p2++;
 3c4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3c6:	fed518e3          	bne	a0,a3,3b6 <memcmp+0x16>
  }
  return 0;
 3ca:	4501                	li	a0,0
 3cc:	a019                	j	3d2 <memcmp+0x32>
      return *p1 - *p2;
 3ce:	40e7853b          	subw	a0,a5,a4
}
 3d2:	60a2                	ld	ra,8(sp)
 3d4:	6402                	ld	s0,0(sp)
 3d6:	0141                	addi	sp,sp,16
 3d8:	8082                	ret
  return 0;
 3da:	4501                	li	a0,0
 3dc:	bfdd                	j	3d2 <memcmp+0x32>

00000000000003de <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3de:	1141                	addi	sp,sp,-16
 3e0:	e406                	sd	ra,8(sp)
 3e2:	e022                	sd	s0,0(sp)
 3e4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3e6:	f5fff0ef          	jal	344 <memmove>
}
 3ea:	60a2                	ld	ra,8(sp)
 3ec:	6402                	ld	s0,0(sp)
 3ee:	0141                	addi	sp,sp,16
 3f0:	8082                	ret

00000000000003f2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3f2:	4885                	li	a7,1
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <exit>:
.global exit
exit:
 li a7, SYS_exit
 3fa:	4889                	li	a7,2
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <wait>:
.global wait
wait:
 li a7, SYS_wait
 402:	488d                	li	a7,3
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 40a:	4891                	li	a7,4
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <read>:
.global read
read:
 li a7, SYS_read
 412:	4895                	li	a7,5
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <write>:
.global write
write:
 li a7, SYS_write
 41a:	48c1                	li	a7,16
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <close>:
.global close
close:
 li a7, SYS_close
 422:	48d5                	li	a7,21
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <kill>:
.global kill
kill:
 li a7, SYS_kill
 42a:	4899                	li	a7,6
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <exec>:
.global exec
exec:
 li a7, SYS_exec
 432:	489d                	li	a7,7
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <open>:
.global open
open:
 li a7, SYS_open
 43a:	48bd                	li	a7,15
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 442:	48c5                	li	a7,17
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 44a:	48c9                	li	a7,18
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 452:	48a1                	li	a7,8
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <link>:
.global link
link:
 li a7, SYS_link
 45a:	48cd                	li	a7,19
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 462:	48d1                	li	a7,20
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 46a:	48a5                	li	a7,9
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <dup>:
.global dup
dup:
 li a7, SYS_dup
 472:	48a9                	li	a7,10
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 47a:	48ad                	li	a7,11
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 482:	48b1                	li	a7,12
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 48a:	48b5                	li	a7,13
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 492:	48b9                	li	a7,14
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <trace>:
.global trace
trace:
 li a7, SYS_trace
 49a:	48d9                	li	a7,22
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4a2:	1101                	addi	sp,sp,-32
 4a4:	ec06                	sd	ra,24(sp)
 4a6:	e822                	sd	s0,16(sp)
 4a8:	1000                	addi	s0,sp,32
 4aa:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ae:	4605                	li	a2,1
 4b0:	fef40593          	addi	a1,s0,-17
 4b4:	f67ff0ef          	jal	41a <write>
}
 4b8:	60e2                	ld	ra,24(sp)
 4ba:	6442                	ld	s0,16(sp)
 4bc:	6105                	addi	sp,sp,32
 4be:	8082                	ret

00000000000004c0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c0:	7139                	addi	sp,sp,-64
 4c2:	fc06                	sd	ra,56(sp)
 4c4:	f822                	sd	s0,48(sp)
 4c6:	f426                	sd	s1,40(sp)
 4c8:	f04a                	sd	s2,32(sp)
 4ca:	ec4e                	sd	s3,24(sp)
 4cc:	0080                	addi	s0,sp,64
 4ce:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4d0:	c299                	beqz	a3,4d6 <printint+0x16>
 4d2:	0605ce63          	bltz	a1,54e <printint+0x8e>
  neg = 0;
 4d6:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4d8:	fc040313          	addi	t1,s0,-64
  neg = 0;
 4dc:	869a                	mv	a3,t1
  i = 0;
 4de:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4e0:	00000817          	auipc	a6,0x0
 4e4:	52080813          	addi	a6,a6,1312 # a00 <digits>
 4e8:	88be                	mv	a7,a5
 4ea:	0017851b          	addiw	a0,a5,1
 4ee:	87aa                	mv	a5,a0
 4f0:	02c5f73b          	remuw	a4,a1,a2
 4f4:	1702                	slli	a4,a4,0x20
 4f6:	9301                	srli	a4,a4,0x20
 4f8:	9742                	add	a4,a4,a6
 4fa:	00074703          	lbu	a4,0(a4)
 4fe:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 502:	872e                	mv	a4,a1
 504:	02c5d5bb          	divuw	a1,a1,a2
 508:	0685                	addi	a3,a3,1
 50a:	fcc77fe3          	bgeu	a4,a2,4e8 <printint+0x28>
  if(neg)
 50e:	000e0c63          	beqz	t3,526 <printint+0x66>
    buf[i++] = '-';
 512:	fd050793          	addi	a5,a0,-48
 516:	00878533          	add	a0,a5,s0
 51a:	02d00793          	li	a5,45
 51e:	fef50823          	sb	a5,-16(a0)
 522:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 526:	fff7899b          	addiw	s3,a5,-1
 52a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 52e:	fff4c583          	lbu	a1,-1(s1)
 532:	854a                	mv	a0,s2
 534:	f6fff0ef          	jal	4a2 <putc>
  while(--i >= 0)
 538:	39fd                	addiw	s3,s3,-1
 53a:	14fd                	addi	s1,s1,-1
 53c:	fe09d9e3          	bgez	s3,52e <printint+0x6e>
}
 540:	70e2                	ld	ra,56(sp)
 542:	7442                	ld	s0,48(sp)
 544:	74a2                	ld	s1,40(sp)
 546:	7902                	ld	s2,32(sp)
 548:	69e2                	ld	s3,24(sp)
 54a:	6121                	addi	sp,sp,64
 54c:	8082                	ret
    x = -xx;
 54e:	40b005bb          	negw	a1,a1
    neg = 1;
 552:	4e05                	li	t3,1
    x = -xx;
 554:	b751                	j	4d8 <printint+0x18>

0000000000000556 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 556:	711d                	addi	sp,sp,-96
 558:	ec86                	sd	ra,88(sp)
 55a:	e8a2                	sd	s0,80(sp)
 55c:	e4a6                	sd	s1,72(sp)
 55e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 560:	0005c483          	lbu	s1,0(a1)
 564:	26048663          	beqz	s1,7d0 <vprintf+0x27a>
 568:	e0ca                	sd	s2,64(sp)
 56a:	fc4e                	sd	s3,56(sp)
 56c:	f852                	sd	s4,48(sp)
 56e:	f456                	sd	s5,40(sp)
 570:	f05a                	sd	s6,32(sp)
 572:	ec5e                	sd	s7,24(sp)
 574:	e862                	sd	s8,16(sp)
 576:	e466                	sd	s9,8(sp)
 578:	8b2a                	mv	s6,a0
 57a:	8a2e                	mv	s4,a1
 57c:	8bb2                	mv	s7,a2
  state = 0;
 57e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 580:	4901                	li	s2,0
 582:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 584:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 588:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 58c:	06c00c93          	li	s9,108
 590:	a00d                	j	5b2 <vprintf+0x5c>
        putc(fd, c0);
 592:	85a6                	mv	a1,s1
 594:	855a                	mv	a0,s6
 596:	f0dff0ef          	jal	4a2 <putc>
 59a:	a019                	j	5a0 <vprintf+0x4a>
    } else if(state == '%'){
 59c:	03598363          	beq	s3,s5,5c2 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 5a0:	0019079b          	addiw	a5,s2,1
 5a4:	893e                	mv	s2,a5
 5a6:	873e                	mv	a4,a5
 5a8:	97d2                	add	a5,a5,s4
 5aa:	0007c483          	lbu	s1,0(a5)
 5ae:	20048963          	beqz	s1,7c0 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 5b2:	0004879b          	sext.w	a5,s1
    if(state == 0){
 5b6:	fe0993e3          	bnez	s3,59c <vprintf+0x46>
      if(c0 == '%'){
 5ba:	fd579ce3          	bne	a5,s5,592 <vprintf+0x3c>
        state = '%';
 5be:	89be                	mv	s3,a5
 5c0:	b7c5                	j	5a0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5c2:	00ea06b3          	add	a3,s4,a4
 5c6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5ca:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5cc:	c681                	beqz	a3,5d4 <vprintf+0x7e>
 5ce:	9752                	add	a4,a4,s4
 5d0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5d4:	03878e63          	beq	a5,s8,610 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5d8:	05978863          	beq	a5,s9,628 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5dc:	07500713          	li	a4,117
 5e0:	0ee78263          	beq	a5,a4,6c4 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5e4:	07800713          	li	a4,120
 5e8:	12e78463          	beq	a5,a4,710 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5ec:	07000713          	li	a4,112
 5f0:	14e78963          	beq	a5,a4,742 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5f4:	07300713          	li	a4,115
 5f8:	18e78863          	beq	a5,a4,788 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5fc:	02500713          	li	a4,37
 600:	04e79463          	bne	a5,a4,648 <vprintf+0xf2>
        putc(fd, '%');
 604:	85ba                	mv	a1,a4
 606:	855a                	mv	a0,s6
 608:	e9bff0ef          	jal	4a2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 60c:	4981                	li	s3,0
 60e:	bf49                	j	5a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 610:	008b8493          	addi	s1,s7,8
 614:	4685                	li	a3,1
 616:	4629                	li	a2,10
 618:	000ba583          	lw	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	ea3ff0ef          	jal	4c0 <printint>
 622:	8ba6                	mv	s7,s1
      state = 0;
 624:	4981                	li	s3,0
 626:	bfad                	j	5a0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 628:	06400793          	li	a5,100
 62c:	02f68963          	beq	a3,a5,65e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 630:	06c00793          	li	a5,108
 634:	04f68263          	beq	a3,a5,678 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 638:	07500793          	li	a5,117
 63c:	0af68063          	beq	a3,a5,6dc <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 640:	07800793          	li	a5,120
 644:	0ef68263          	beq	a3,a5,728 <vprintf+0x1d2>
        putc(fd, '%');
 648:	02500593          	li	a1,37
 64c:	855a                	mv	a0,s6
 64e:	e55ff0ef          	jal	4a2 <putc>
        putc(fd, c0);
 652:	85a6                	mv	a1,s1
 654:	855a                	mv	a0,s6
 656:	e4dff0ef          	jal	4a2 <putc>
      state = 0;
 65a:	4981                	li	s3,0
 65c:	b791                	j	5a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 65e:	008b8493          	addi	s1,s7,8
 662:	4685                	li	a3,1
 664:	4629                	li	a2,10
 666:	000ba583          	lw	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	e55ff0ef          	jal	4c0 <printint>
        i += 1;
 670:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 672:	8ba6                	mv	s7,s1
      state = 0;
 674:	4981                	li	s3,0
        i += 1;
 676:	b72d                	j	5a0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 678:	06400793          	li	a5,100
 67c:	02f60763          	beq	a2,a5,6aa <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 680:	07500793          	li	a5,117
 684:	06f60963          	beq	a2,a5,6f6 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 688:	07800793          	li	a5,120
 68c:	faf61ee3          	bne	a2,a5,648 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 690:	008b8493          	addi	s1,s7,8
 694:	4681                	li	a3,0
 696:	4641                	li	a2,16
 698:	000ba583          	lw	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	e23ff0ef          	jal	4c0 <printint>
        i += 2;
 6a2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a4:	8ba6                	mv	s7,s1
      state = 0;
 6a6:	4981                	li	s3,0
        i += 2;
 6a8:	bde5                	j	5a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6aa:	008b8493          	addi	s1,s7,8
 6ae:	4685                	li	a3,1
 6b0:	4629                	li	a2,10
 6b2:	000ba583          	lw	a1,0(s7)
 6b6:	855a                	mv	a0,s6
 6b8:	e09ff0ef          	jal	4c0 <printint>
        i += 2;
 6bc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6be:	8ba6                	mv	s7,s1
      state = 0;
 6c0:	4981                	li	s3,0
        i += 2;
 6c2:	bdf9                	j	5a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 6c4:	008b8493          	addi	s1,s7,8
 6c8:	4681                	li	a3,0
 6ca:	4629                	li	a2,10
 6cc:	000ba583          	lw	a1,0(s7)
 6d0:	855a                	mv	a0,s6
 6d2:	defff0ef          	jal	4c0 <printint>
 6d6:	8ba6                	mv	s7,s1
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	b5d9                	j	5a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6dc:	008b8493          	addi	s1,s7,8
 6e0:	4681                	li	a3,0
 6e2:	4629                	li	a2,10
 6e4:	000ba583          	lw	a1,0(s7)
 6e8:	855a                	mv	a0,s6
 6ea:	dd7ff0ef          	jal	4c0 <printint>
        i += 1;
 6ee:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f0:	8ba6                	mv	s7,s1
      state = 0;
 6f2:	4981                	li	s3,0
        i += 1;
 6f4:	b575                	j	5a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f6:	008b8493          	addi	s1,s7,8
 6fa:	4681                	li	a3,0
 6fc:	4629                	li	a2,10
 6fe:	000ba583          	lw	a1,0(s7)
 702:	855a                	mv	a0,s6
 704:	dbdff0ef          	jal	4c0 <printint>
        i += 2;
 708:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 70a:	8ba6                	mv	s7,s1
      state = 0;
 70c:	4981                	li	s3,0
        i += 2;
 70e:	bd49                	j	5a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 710:	008b8493          	addi	s1,s7,8
 714:	4681                	li	a3,0
 716:	4641                	li	a2,16
 718:	000ba583          	lw	a1,0(s7)
 71c:	855a                	mv	a0,s6
 71e:	da3ff0ef          	jal	4c0 <printint>
 722:	8ba6                	mv	s7,s1
      state = 0;
 724:	4981                	li	s3,0
 726:	bdad                	j	5a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 728:	008b8493          	addi	s1,s7,8
 72c:	4681                	li	a3,0
 72e:	4641                	li	a2,16
 730:	000ba583          	lw	a1,0(s7)
 734:	855a                	mv	a0,s6
 736:	d8bff0ef          	jal	4c0 <printint>
        i += 1;
 73a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 73c:	8ba6                	mv	s7,s1
      state = 0;
 73e:	4981                	li	s3,0
        i += 1;
 740:	b585                	j	5a0 <vprintf+0x4a>
 742:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 744:	008b8d13          	addi	s10,s7,8
 748:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 74c:	03000593          	li	a1,48
 750:	855a                	mv	a0,s6
 752:	d51ff0ef          	jal	4a2 <putc>
  putc(fd, 'x');
 756:	07800593          	li	a1,120
 75a:	855a                	mv	a0,s6
 75c:	d47ff0ef          	jal	4a2 <putc>
 760:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 762:	00000b97          	auipc	s7,0x0
 766:	29eb8b93          	addi	s7,s7,670 # a00 <digits>
 76a:	03c9d793          	srli	a5,s3,0x3c
 76e:	97de                	add	a5,a5,s7
 770:	0007c583          	lbu	a1,0(a5)
 774:	855a                	mv	a0,s6
 776:	d2dff0ef          	jal	4a2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 77a:	0992                	slli	s3,s3,0x4
 77c:	34fd                	addiw	s1,s1,-1
 77e:	f4f5                	bnez	s1,76a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 780:	8bea                	mv	s7,s10
      state = 0;
 782:	4981                	li	s3,0
 784:	6d02                	ld	s10,0(sp)
 786:	bd29                	j	5a0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 788:	008b8993          	addi	s3,s7,8
 78c:	000bb483          	ld	s1,0(s7)
 790:	cc91                	beqz	s1,7ac <vprintf+0x256>
        for(; *s; s++)
 792:	0004c583          	lbu	a1,0(s1)
 796:	c195                	beqz	a1,7ba <vprintf+0x264>
          putc(fd, *s);
 798:	855a                	mv	a0,s6
 79a:	d09ff0ef          	jal	4a2 <putc>
        for(; *s; s++)
 79e:	0485                	addi	s1,s1,1
 7a0:	0004c583          	lbu	a1,0(s1)
 7a4:	f9f5                	bnez	a1,798 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 7a6:	8bce                	mv	s7,s3
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	bbdd                	j	5a0 <vprintf+0x4a>
          s = "(null)";
 7ac:	00000497          	auipc	s1,0x0
 7b0:	24c48493          	addi	s1,s1,588 # 9f8 <malloc+0x13c>
        for(; *s; s++)
 7b4:	02800593          	li	a1,40
 7b8:	b7c5                	j	798 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 7ba:	8bce                	mv	s7,s3
      state = 0;
 7bc:	4981                	li	s3,0
 7be:	b3cd                	j	5a0 <vprintf+0x4a>
 7c0:	6906                	ld	s2,64(sp)
 7c2:	79e2                	ld	s3,56(sp)
 7c4:	7a42                	ld	s4,48(sp)
 7c6:	7aa2                	ld	s5,40(sp)
 7c8:	7b02                	ld	s6,32(sp)
 7ca:	6be2                	ld	s7,24(sp)
 7cc:	6c42                	ld	s8,16(sp)
 7ce:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7d0:	60e6                	ld	ra,88(sp)
 7d2:	6446                	ld	s0,80(sp)
 7d4:	64a6                	ld	s1,72(sp)
 7d6:	6125                	addi	sp,sp,96
 7d8:	8082                	ret

00000000000007da <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7da:	715d                	addi	sp,sp,-80
 7dc:	ec06                	sd	ra,24(sp)
 7de:	e822                	sd	s0,16(sp)
 7e0:	1000                	addi	s0,sp,32
 7e2:	e010                	sd	a2,0(s0)
 7e4:	e414                	sd	a3,8(s0)
 7e6:	e818                	sd	a4,16(s0)
 7e8:	ec1c                	sd	a5,24(s0)
 7ea:	03043023          	sd	a6,32(s0)
 7ee:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7f2:	8622                	mv	a2,s0
 7f4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7f8:	d5fff0ef          	jal	556 <vprintf>
}
 7fc:	60e2                	ld	ra,24(sp)
 7fe:	6442                	ld	s0,16(sp)
 800:	6161                	addi	sp,sp,80
 802:	8082                	ret

0000000000000804 <printf>:

void
printf(const char *fmt, ...)
{
 804:	711d                	addi	sp,sp,-96
 806:	ec06                	sd	ra,24(sp)
 808:	e822                	sd	s0,16(sp)
 80a:	1000                	addi	s0,sp,32
 80c:	e40c                	sd	a1,8(s0)
 80e:	e810                	sd	a2,16(s0)
 810:	ec14                	sd	a3,24(s0)
 812:	f018                	sd	a4,32(s0)
 814:	f41c                	sd	a5,40(s0)
 816:	03043823          	sd	a6,48(s0)
 81a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 81e:	00840613          	addi	a2,s0,8
 822:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 826:	85aa                	mv	a1,a0
 828:	4505                	li	a0,1
 82a:	d2dff0ef          	jal	556 <vprintf>
}
 82e:	60e2                	ld	ra,24(sp)
 830:	6442                	ld	s0,16(sp)
 832:	6125                	addi	sp,sp,96
 834:	8082                	ret

0000000000000836 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 836:	1141                	addi	sp,sp,-16
 838:	e406                	sd	ra,8(sp)
 83a:	e022                	sd	s0,0(sp)
 83c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 83e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 842:	00000797          	auipc	a5,0x0
 846:	7be7b783          	ld	a5,1982(a5) # 1000 <freep>
 84a:	a02d                	j	874 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 84c:	4618                	lw	a4,8(a2)
 84e:	9f2d                	addw	a4,a4,a1
 850:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 854:	6398                	ld	a4,0(a5)
 856:	6310                	ld	a2,0(a4)
 858:	a83d                	j	896 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 85a:	ff852703          	lw	a4,-8(a0)
 85e:	9f31                	addw	a4,a4,a2
 860:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 862:	ff053683          	ld	a3,-16(a0)
 866:	a091                	j	8aa <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 868:	6398                	ld	a4,0(a5)
 86a:	00e7e463          	bltu	a5,a4,872 <free+0x3c>
 86e:	00e6ea63          	bltu	a3,a4,882 <free+0x4c>
{
 872:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 874:	fed7fae3          	bgeu	a5,a3,868 <free+0x32>
 878:	6398                	ld	a4,0(a5)
 87a:	00e6e463          	bltu	a3,a4,882 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 87e:	fee7eae3          	bltu	a5,a4,872 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 882:	ff852583          	lw	a1,-8(a0)
 886:	6390                	ld	a2,0(a5)
 888:	02059813          	slli	a6,a1,0x20
 88c:	01c85713          	srli	a4,a6,0x1c
 890:	9736                	add	a4,a4,a3
 892:	fae60de3          	beq	a2,a4,84c <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 896:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 89a:	4790                	lw	a2,8(a5)
 89c:	02061593          	slli	a1,a2,0x20
 8a0:	01c5d713          	srli	a4,a1,0x1c
 8a4:	973e                	add	a4,a4,a5
 8a6:	fae68ae3          	beq	a3,a4,85a <free+0x24>
    p->s.ptr = bp->s.ptr;
 8aa:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8ac:	00000717          	auipc	a4,0x0
 8b0:	74f73a23          	sd	a5,1876(a4) # 1000 <freep>
}
 8b4:	60a2                	ld	ra,8(sp)
 8b6:	6402                	ld	s0,0(sp)
 8b8:	0141                	addi	sp,sp,16
 8ba:	8082                	ret

00000000000008bc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8bc:	7139                	addi	sp,sp,-64
 8be:	fc06                	sd	ra,56(sp)
 8c0:	f822                	sd	s0,48(sp)
 8c2:	f04a                	sd	s2,32(sp)
 8c4:	ec4e                	sd	s3,24(sp)
 8c6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c8:	02051993          	slli	s3,a0,0x20
 8cc:	0209d993          	srli	s3,s3,0x20
 8d0:	09bd                	addi	s3,s3,15
 8d2:	0049d993          	srli	s3,s3,0x4
 8d6:	2985                	addiw	s3,s3,1
 8d8:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8da:	00000517          	auipc	a0,0x0
 8de:	72653503          	ld	a0,1830(a0) # 1000 <freep>
 8e2:	c905                	beqz	a0,912 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e6:	4798                	lw	a4,8(a5)
 8e8:	09377663          	bgeu	a4,s3,974 <malloc+0xb8>
 8ec:	f426                	sd	s1,40(sp)
 8ee:	e852                	sd	s4,16(sp)
 8f0:	e456                	sd	s5,8(sp)
 8f2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8f4:	8a4e                	mv	s4,s3
 8f6:	6705                	lui	a4,0x1
 8f8:	00e9f363          	bgeu	s3,a4,8fe <malloc+0x42>
 8fc:	6a05                	lui	s4,0x1
 8fe:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 902:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 906:	00000497          	auipc	s1,0x0
 90a:	6fa48493          	addi	s1,s1,1786 # 1000 <freep>
  if(p == (char*)-1)
 90e:	5afd                	li	s5,-1
 910:	a83d                	j	94e <malloc+0x92>
 912:	f426                	sd	s1,40(sp)
 914:	e852                	sd	s4,16(sp)
 916:	e456                	sd	s5,8(sp)
 918:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 91a:	00001797          	auipc	a5,0x1
 91e:	8f678793          	addi	a5,a5,-1802 # 1210 <base>
 922:	00000717          	auipc	a4,0x0
 926:	6cf73f23          	sd	a5,1758(a4) # 1000 <freep>
 92a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 92c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 930:	b7d1                	j	8f4 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 932:	6398                	ld	a4,0(a5)
 934:	e118                	sd	a4,0(a0)
 936:	a899                	j	98c <malloc+0xd0>
  hp->s.size = nu;
 938:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 93c:	0541                	addi	a0,a0,16
 93e:	ef9ff0ef          	jal	836 <free>
  return freep;
 942:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 944:	c125                	beqz	a0,9a4 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 946:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 948:	4798                	lw	a4,8(a5)
 94a:	03277163          	bgeu	a4,s2,96c <malloc+0xb0>
    if(p == freep)
 94e:	6098                	ld	a4,0(s1)
 950:	853e                	mv	a0,a5
 952:	fef71ae3          	bne	a4,a5,946 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 956:	8552                	mv	a0,s4
 958:	b2bff0ef          	jal	482 <sbrk>
  if(p == (char*)-1)
 95c:	fd551ee3          	bne	a0,s5,938 <malloc+0x7c>
        return 0;
 960:	4501                	li	a0,0
 962:	74a2                	ld	s1,40(sp)
 964:	6a42                	ld	s4,16(sp)
 966:	6aa2                	ld	s5,8(sp)
 968:	6b02                	ld	s6,0(sp)
 96a:	a03d                	j	998 <malloc+0xdc>
 96c:	74a2                	ld	s1,40(sp)
 96e:	6a42                	ld	s4,16(sp)
 970:	6aa2                	ld	s5,8(sp)
 972:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 974:	fae90fe3          	beq	s2,a4,932 <malloc+0x76>
        p->s.size -= nunits;
 978:	4137073b          	subw	a4,a4,s3
 97c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 97e:	02071693          	slli	a3,a4,0x20
 982:	01c6d713          	srli	a4,a3,0x1c
 986:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 988:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 98c:	00000717          	auipc	a4,0x0
 990:	66a73a23          	sd	a0,1652(a4) # 1000 <freep>
      return (void*)(p + 1);
 994:	01078513          	addi	a0,a5,16
  }
}
 998:	70e2                	ld	ra,56(sp)
 99a:	7442                	ld	s0,48(sp)
 99c:	7902                	ld	s2,32(sp)
 99e:	69e2                	ld	s3,24(sp)
 9a0:	6121                	addi	sp,sp,64
 9a2:	8082                	ret
 9a4:	74a2                	ld	s1,40(sp)
 9a6:	6a42                	ld	s4,16(sp)
 9a8:	6aa2                	ld	s5,8(sp)
 9aa:	6b02                	ld	s6,0(sp)
 9ac:	b7f5                	j	998 <malloc+0xdc>
