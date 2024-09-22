
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <handle_parent>:

/*
Handle the case where the current process is the parent process -
send byte to child (who has the given pid), then receive a byte from the child.
*/
void handle_parent(int child_fd[], int parent_fd[], int child_pid) {
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	0080                	addi	s0,sp,64
   c:	892a                	mv	s2,a0
   e:	84ae                	mv	s1,a1
  10:	fcc42623          	sw	a2,-52(s0)
    char buff[SINGLE_BYTE+1] = {0};
  14:	fc041c23          	sh	zero,-40(s0)

    // No nead to read from the child pipe or write to the parent pipe so we close those ports.
    close(child_fd[PIPE_READ]);
  18:	4108                	lw	a0,0(a0)
  1a:	00000097          	auipc	ra,0x0
  1e:	49e080e7          	jalr	1182(ra) # 4b8 <close>
    close(parent_fd[PIPE_WRITE]);
  22:	40c8                	lw	a0,4(s1)
  24:	00000097          	auipc	ra,0x0
  28:	494080e7          	jalr	1172(ra) # 4b8 <close>

    // Ping the child process with a single byte.
    write(child_fd[PIPE_WRITE], ".", SINGLE_BYTE);
  2c:	4605                	li	a2,1
  2e:	00001597          	auipc	a1,0x1
  32:	a8258593          	addi	a1,a1,-1406 # ab0 <malloc+0x102>
  36:	00492503          	lw	a0,4(s2)
  3a:	00000097          	auipc	ra,0x0
  3e:	476080e7          	jalr	1142(ra) # 4b0 <write>
    int bytesRead = read(parent_fd[PIPE_READ], buff, SINGLE_BYTE);
  42:	4605                	li	a2,1
  44:	fd840593          	addi	a1,s0,-40
  48:	4088                	lw	a0,0(s1)
  4a:	00000097          	auipc	ra,0x0
  4e:	45e080e7          	jalr	1118(ra) # 4a8 <read>
  52:	84aa                	mv	s1,a0
    
    // Wait a bit in order to sync the child's printf with the parent's prints.
    wait(&child_pid);
  54:	fcc40513          	addi	a0,s0,-52
  58:	00000097          	auipc	ra,0x0
  5c:	440080e7          	jalr	1088(ra) # 498 <wait>
    
    // Check the case where no bytes were read.
    if (bytesRead <= 0) {
  60:	02905463          	blez	s1,88 <handle_parent+0x88>

    // Print some info about the received byte if we are in debug mode
#ifdef DEBUG
    printf("\nParent Received (%d): '%s'\n", bytesRead, buff);
#endif
    printf("%d: received pong\n", getpid());
  64:	00000097          	auipc	ra,0x0
  68:	4ac080e7          	jalr	1196(ra) # 510 <getpid>
  6c:	85aa                	mv	a1,a0
  6e:	00001517          	auipc	a0,0x1
  72:	a7250513          	addi	a0,a0,-1422 # ae0 <malloc+0x132>
  76:	00001097          	auipc	ra,0x1
  7a:	87c080e7          	jalr	-1924(ra) # 8f2 <printf>
    exit(SUCCESS);
  7e:	4501                	li	a0,0
  80:	00000097          	auipc	ra,0x0
  84:	410080e7          	jalr	1040(ra) # 490 <exit>
        printf("Error reading received bytes (Parent)\n");
  88:	00001517          	auipc	a0,0x1
  8c:	a3050513          	addi	a0,a0,-1488 # ab8 <malloc+0x10a>
  90:	00001097          	auipc	ra,0x1
  94:	862080e7          	jalr	-1950(ra) # 8f2 <printf>
        exit(ERROR);
  98:	4505                	li	a0,1
  9a:	00000097          	auipc	ra,0x0
  9e:	3f6080e7          	jalr	1014(ra) # 490 <exit>

00000000000000a2 <handle_child>:

/*
Handle the case where the current process is the child process -
Receive a byte from the parent and send one in return.
*/
void handle_child(int child_fd[], int parent_fd[]) {
  a2:	7179                	addi	sp,sp,-48
  a4:	f406                	sd	ra,40(sp)
  a6:	f022                	sd	s0,32(sp)
  a8:	ec26                	sd	s1,24(sp)
  aa:	e84a                	sd	s2,16(sp)
  ac:	1800                	addi	s0,sp,48
  ae:	84aa                	mv	s1,a0
  b0:	892e                	mv	s2,a1
    char buff[SINGLE_BYTE+1] = {0};
  b2:	fc041c23          	sh	zero,-40(s0)

    // No nead to read from the parent pipe or write to the child pipe so we close those ports.
    close(parent_fd[PIPE_READ]);
  b6:	4188                	lw	a0,0(a1)
  b8:	00000097          	auipc	ra,0x0
  bc:	400080e7          	jalr	1024(ra) # 4b8 <close>
    close(child_fd[PIPE_WRITE]);
  c0:	40c8                	lw	a0,4(s1)
  c2:	00000097          	auipc	ra,0x0
  c6:	3f6080e7          	jalr	1014(ra) # 4b8 <close>

    // Receive a byte from the parent.
    int bytesRead = read(child_fd[PIPE_READ], buff, SINGLE_BYTE);
  ca:	4605                	li	a2,1
  cc:	fd840593          	addi	a1,s0,-40
  d0:	4088                	lw	a0,0(s1)
  d2:	00000097          	auipc	ra,0x0
  d6:	3d6080e7          	jalr	982(ra) # 4a8 <read>

    // Check the case where no bytes were read.
    if (bytesRead <= 0) {
  da:	02a05f63          	blez	a0,118 <handle_child+0x76>

    // Print some info about the received byte if we are in debug mode
#ifdef DEBUG
    printf("Child Received (%d): '%s'\n", bytesRead, buff);
#endif
    printf("%d: received ping\n", getpid());
  de:	00000097          	auipc	ra,0x0
  e2:	432080e7          	jalr	1074(ra) # 510 <getpid>
  e6:	85aa                	mv	a1,a0
  e8:	00001517          	auipc	a0,0x1
  ec:	a3850513          	addi	a0,a0,-1480 # b20 <malloc+0x172>
  f0:	00001097          	auipc	ra,0x1
  f4:	802080e7          	jalr	-2046(ra) # 8f2 <printf>

    // Write a byte back to the parent.
    write(parent_fd[PIPE_WRITE], ".", SINGLE_BYTE);
  f8:	4605                	li	a2,1
  fa:	00001597          	auipc	a1,0x1
  fe:	9b658593          	addi	a1,a1,-1610 # ab0 <malloc+0x102>
 102:	00492503          	lw	a0,4(s2)
 106:	00000097          	auipc	ra,0x0
 10a:	3aa080e7          	jalr	938(ra) # 4b0 <write>
    exit(SUCCESS);
 10e:	4501                	li	a0,0
 110:	00000097          	auipc	ra,0x0
 114:	380080e7          	jalr	896(ra) # 490 <exit>
        printf("Error reading received bytes (Child)\n");
 118:	00001517          	auipc	a0,0x1
 11c:	9e050513          	addi	a0,a0,-1568 # af8 <malloc+0x14a>
 120:	00000097          	auipc	ra,0x0
 124:	7d2080e7          	jalr	2002(ra) # 8f2 <printf>
        exit(ERROR);
 128:	4505                	li	a0,1
 12a:	00000097          	auipc	ra,0x0
 12e:	366080e7          	jalr	870(ra) # 490 <exit>

0000000000000132 <main>:
}

int main(int argc, char *argv[])
{
 132:	1101                	addi	sp,sp,-32
 134:	ec06                	sd	ra,24(sp)
 136:	e822                	sd	s0,16(sp)
 138:	1000                	addi	s0,sp,32
    int child_fd[PIPE_SIZE], parent_fd[PIPE_SIZE];

    // Attempt to create the child pipe.
    if (pipe(child_fd) != 0) {
 13a:	fe840513          	addi	a0,s0,-24
 13e:	00000097          	auipc	ra,0x0
 142:	362080e7          	jalr	866(ra) # 4a0 <pipe>
 146:	cd11                	beqz	a0,162 <main+0x30>
        printf("Error creating child pipe\n");
 148:	00001517          	auipc	a0,0x1
 14c:	9f050513          	addi	a0,a0,-1552 # b38 <malloc+0x18a>
 150:	00000097          	auipc	ra,0x0
 154:	7a2080e7          	jalr	1954(ra) # 8f2 <printf>
        exit(ERROR);
 158:	4505                	li	a0,1
 15a:	00000097          	auipc	ra,0x0
 15e:	336080e7          	jalr	822(ra) # 490 <exit>
    }

    // Attempt to create the parent pipe.
    if (pipe(parent_fd) != 0) {
 162:	fe040513          	addi	a0,s0,-32
 166:	00000097          	auipc	ra,0x0
 16a:	33a080e7          	jalr	826(ra) # 4a0 <pipe>
 16e:	cd11                	beqz	a0,18a <main+0x58>
        printf("Error creating parent pipe\n");
 170:	00001517          	auipc	a0,0x1
 174:	9e850513          	addi	a0,a0,-1560 # b58 <malloc+0x1aa>
 178:	00000097          	auipc	ra,0x0
 17c:	77a080e7          	jalr	1914(ra) # 8f2 <printf>
        exit(ERROR);
 180:	4505                	li	a0,1
 182:	00000097          	auipc	ra,0x0
 186:	30e080e7          	jalr	782(ra) # 490 <exit>
    }

    int pid = fork();
 18a:	00000097          	auipc	ra,0x0
 18e:	2fe080e7          	jalr	766(ra) # 488 <fork>
    // Check for fork error.
    if (pid < 0) {
 192:	00054d63          	bltz	a0,1ac <main+0x7a>
        printf("Error forking process\n");
        exit(ERROR);
    } else if (pid > 0) handle_parent(child_fd, parent_fd, pid);
 196:	02a05863          	blez	a0,1c6 <main+0x94>
 19a:	862a                	mv	a2,a0
 19c:	fe040593          	addi	a1,s0,-32
 1a0:	fe840513          	addi	a0,s0,-24
 1a4:	00000097          	auipc	ra,0x0
 1a8:	e5c080e7          	jalr	-420(ra) # 0 <handle_parent>
        printf("Error forking process\n");
 1ac:	00001517          	auipc	a0,0x1
 1b0:	9cc50513          	addi	a0,a0,-1588 # b78 <malloc+0x1ca>
 1b4:	00000097          	auipc	ra,0x0
 1b8:	73e080e7          	jalr	1854(ra) # 8f2 <printf>
        exit(ERROR);
 1bc:	4505                	li	a0,1
 1be:	00000097          	auipc	ra,0x0
 1c2:	2d2080e7          	jalr	722(ra) # 490 <exit>
    else handle_child(child_fd, parent_fd);
 1c6:	fe040593          	addi	a1,s0,-32
 1ca:	fe840513          	addi	a0,s0,-24
 1ce:	00000097          	auipc	ra,0x0
 1d2:	ed4080e7          	jalr	-300(ra) # a2 <handle_child>

00000000000001d6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1d6:	1141                	addi	sp,sp,-16
 1d8:	e406                	sd	ra,8(sp)
 1da:	e022                	sd	s0,0(sp)
 1dc:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1de:	00000097          	auipc	ra,0x0
 1e2:	f54080e7          	jalr	-172(ra) # 132 <main>
  exit(0);
 1e6:	4501                	li	a0,0
 1e8:	00000097          	auipc	ra,0x0
 1ec:	2a8080e7          	jalr	680(ra) # 490 <exit>

00000000000001f0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e406                	sd	ra,8(sp)
 1f4:	e022                	sd	s0,0(sp)
 1f6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1f8:	87aa                	mv	a5,a0
 1fa:	0585                	addi	a1,a1,1
 1fc:	0785                	addi	a5,a5,1
 1fe:	fff5c703          	lbu	a4,-1(a1)
 202:	fee78fa3          	sb	a4,-1(a5)
 206:	fb75                	bnez	a4,1fa <strcpy+0xa>
    ;
  return os;
}
 208:	60a2                	ld	ra,8(sp)
 20a:	6402                	ld	s0,0(sp)
 20c:	0141                	addi	sp,sp,16
 20e:	8082                	ret

0000000000000210 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 210:	1141                	addi	sp,sp,-16
 212:	e406                	sd	ra,8(sp)
 214:	e022                	sd	s0,0(sp)
 216:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 218:	00054783          	lbu	a5,0(a0)
 21c:	cb91                	beqz	a5,230 <strcmp+0x20>
 21e:	0005c703          	lbu	a4,0(a1)
 222:	00f71763          	bne	a4,a5,230 <strcmp+0x20>
    p++, q++;
 226:	0505                	addi	a0,a0,1
 228:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 22a:	00054783          	lbu	a5,0(a0)
 22e:	fbe5                	bnez	a5,21e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 230:	0005c503          	lbu	a0,0(a1)
}
 234:	40a7853b          	subw	a0,a5,a0
 238:	60a2                	ld	ra,8(sp)
 23a:	6402                	ld	s0,0(sp)
 23c:	0141                	addi	sp,sp,16
 23e:	8082                	ret

0000000000000240 <strlen>:

uint
strlen(const char *s)
{
 240:	1141                	addi	sp,sp,-16
 242:	e406                	sd	ra,8(sp)
 244:	e022                	sd	s0,0(sp)
 246:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 248:	00054783          	lbu	a5,0(a0)
 24c:	cf99                	beqz	a5,26a <strlen+0x2a>
 24e:	0505                	addi	a0,a0,1
 250:	87aa                	mv	a5,a0
 252:	86be                	mv	a3,a5
 254:	0785                	addi	a5,a5,1
 256:	fff7c703          	lbu	a4,-1(a5)
 25a:	ff65                	bnez	a4,252 <strlen+0x12>
 25c:	40a6853b          	subw	a0,a3,a0
 260:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 262:	60a2                	ld	ra,8(sp)
 264:	6402                	ld	s0,0(sp)
 266:	0141                	addi	sp,sp,16
 268:	8082                	ret
  for(n = 0; s[n]; n++)
 26a:	4501                	li	a0,0
 26c:	bfdd                	j	262 <strlen+0x22>

000000000000026e <memset>:

void*
memset(void *dst, int c, uint n)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e406                	sd	ra,8(sp)
 272:	e022                	sd	s0,0(sp)
 274:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 276:	ca19                	beqz	a2,28c <memset+0x1e>
 278:	87aa                	mv	a5,a0
 27a:	1602                	slli	a2,a2,0x20
 27c:	9201                	srli	a2,a2,0x20
 27e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 282:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 286:	0785                	addi	a5,a5,1
 288:	fee79de3          	bne	a5,a4,282 <memset+0x14>
  }
  return dst;
}
 28c:	60a2                	ld	ra,8(sp)
 28e:	6402                	ld	s0,0(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret

0000000000000294 <strchr>:

char*
strchr(const char *s, char c)
{
 294:	1141                	addi	sp,sp,-16
 296:	e406                	sd	ra,8(sp)
 298:	e022                	sd	s0,0(sp)
 29a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	cf81                	beqz	a5,2b8 <strchr+0x24>
    if(*s == c)
 2a2:	00f58763          	beq	a1,a5,2b0 <strchr+0x1c>
  for(; *s; s++)
 2a6:	0505                	addi	a0,a0,1
 2a8:	00054783          	lbu	a5,0(a0)
 2ac:	fbfd                	bnez	a5,2a2 <strchr+0xe>
      return (char*)s;
  return 0;
 2ae:	4501                	li	a0,0
}
 2b0:	60a2                	ld	ra,8(sp)
 2b2:	6402                	ld	s0,0(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret
  return 0;
 2b8:	4501                	li	a0,0
 2ba:	bfdd                	j	2b0 <strchr+0x1c>

00000000000002bc <gets>:

char*
gets(char *buf, int max)
{
 2bc:	7159                	addi	sp,sp,-112
 2be:	f486                	sd	ra,104(sp)
 2c0:	f0a2                	sd	s0,96(sp)
 2c2:	eca6                	sd	s1,88(sp)
 2c4:	e8ca                	sd	s2,80(sp)
 2c6:	e4ce                	sd	s3,72(sp)
 2c8:	e0d2                	sd	s4,64(sp)
 2ca:	fc56                	sd	s5,56(sp)
 2cc:	f85a                	sd	s6,48(sp)
 2ce:	f45e                	sd	s7,40(sp)
 2d0:	f062                	sd	s8,32(sp)
 2d2:	ec66                	sd	s9,24(sp)
 2d4:	e86a                	sd	s10,16(sp)
 2d6:	1880                	addi	s0,sp,112
 2d8:	8caa                	mv	s9,a0
 2da:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2dc:	892a                	mv	s2,a0
 2de:	4481                	li	s1,0
    cc = read(0, &c, 1);
 2e0:	f9f40b13          	addi	s6,s0,-97
 2e4:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2e6:	4ba9                	li	s7,10
 2e8:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 2ea:	8d26                	mv	s10,s1
 2ec:	0014899b          	addiw	s3,s1,1
 2f0:	84ce                	mv	s1,s3
 2f2:	0349d763          	bge	s3,s4,320 <gets+0x64>
    cc = read(0, &c, 1);
 2f6:	8656                	mv	a2,s5
 2f8:	85da                	mv	a1,s6
 2fa:	4501                	li	a0,0
 2fc:	00000097          	auipc	ra,0x0
 300:	1ac080e7          	jalr	428(ra) # 4a8 <read>
    if(cc < 1)
 304:	00a05e63          	blez	a0,320 <gets+0x64>
    buf[i++] = c;
 308:	f9f44783          	lbu	a5,-97(s0)
 30c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 310:	01778763          	beq	a5,s7,31e <gets+0x62>
 314:	0905                	addi	s2,s2,1
 316:	fd879ae3          	bne	a5,s8,2ea <gets+0x2e>
    buf[i++] = c;
 31a:	8d4e                	mv	s10,s3
 31c:	a011                	j	320 <gets+0x64>
 31e:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 320:	9d66                	add	s10,s10,s9
 322:	000d0023          	sb	zero,0(s10)
  return buf;
}
 326:	8566                	mv	a0,s9
 328:	70a6                	ld	ra,104(sp)
 32a:	7406                	ld	s0,96(sp)
 32c:	64e6                	ld	s1,88(sp)
 32e:	6946                	ld	s2,80(sp)
 330:	69a6                	ld	s3,72(sp)
 332:	6a06                	ld	s4,64(sp)
 334:	7ae2                	ld	s5,56(sp)
 336:	7b42                	ld	s6,48(sp)
 338:	7ba2                	ld	s7,40(sp)
 33a:	7c02                	ld	s8,32(sp)
 33c:	6ce2                	ld	s9,24(sp)
 33e:	6d42                	ld	s10,16(sp)
 340:	6165                	addi	sp,sp,112
 342:	8082                	ret

0000000000000344 <stat>:

int
stat(const char *n, struct stat *st)
{
 344:	1101                	addi	sp,sp,-32
 346:	ec06                	sd	ra,24(sp)
 348:	e822                	sd	s0,16(sp)
 34a:	e04a                	sd	s2,0(sp)
 34c:	1000                	addi	s0,sp,32
 34e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 350:	4581                	li	a1,0
 352:	00000097          	auipc	ra,0x0
 356:	17e080e7          	jalr	382(ra) # 4d0 <open>
  if(fd < 0)
 35a:	02054663          	bltz	a0,386 <stat+0x42>
 35e:	e426                	sd	s1,8(sp)
 360:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 362:	85ca                	mv	a1,s2
 364:	00000097          	auipc	ra,0x0
 368:	184080e7          	jalr	388(ra) # 4e8 <fstat>
 36c:	892a                	mv	s2,a0
  close(fd);
 36e:	8526                	mv	a0,s1
 370:	00000097          	auipc	ra,0x0
 374:	148080e7          	jalr	328(ra) # 4b8 <close>
  return r;
 378:	64a2                	ld	s1,8(sp)
}
 37a:	854a                	mv	a0,s2
 37c:	60e2                	ld	ra,24(sp)
 37e:	6442                	ld	s0,16(sp)
 380:	6902                	ld	s2,0(sp)
 382:	6105                	addi	sp,sp,32
 384:	8082                	ret
    return -1;
 386:	597d                	li	s2,-1
 388:	bfcd                	j	37a <stat+0x36>

000000000000038a <atoi>:

int
atoi(const char *s)
{
 38a:	1141                	addi	sp,sp,-16
 38c:	e406                	sd	ra,8(sp)
 38e:	e022                	sd	s0,0(sp)
 390:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 392:	00054683          	lbu	a3,0(a0)
 396:	fd06879b          	addiw	a5,a3,-48
 39a:	0ff7f793          	zext.b	a5,a5
 39e:	4625                	li	a2,9
 3a0:	02f66963          	bltu	a2,a5,3d2 <atoi+0x48>
 3a4:	872a                	mv	a4,a0
  n = 0;
 3a6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3a8:	0705                	addi	a4,a4,1
 3aa:	0025179b          	slliw	a5,a0,0x2
 3ae:	9fa9                	addw	a5,a5,a0
 3b0:	0017979b          	slliw	a5,a5,0x1
 3b4:	9fb5                	addw	a5,a5,a3
 3b6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3ba:	00074683          	lbu	a3,0(a4)
 3be:	fd06879b          	addiw	a5,a3,-48
 3c2:	0ff7f793          	zext.b	a5,a5
 3c6:	fef671e3          	bgeu	a2,a5,3a8 <atoi+0x1e>
  return n;
}
 3ca:	60a2                	ld	ra,8(sp)
 3cc:	6402                	ld	s0,0(sp)
 3ce:	0141                	addi	sp,sp,16
 3d0:	8082                	ret
  n = 0;
 3d2:	4501                	li	a0,0
 3d4:	bfdd                	j	3ca <atoi+0x40>

00000000000003d6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d6:	1141                	addi	sp,sp,-16
 3d8:	e406                	sd	ra,8(sp)
 3da:	e022                	sd	s0,0(sp)
 3dc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3de:	02b57563          	bgeu	a0,a1,408 <memmove+0x32>
    while(n-- > 0)
 3e2:	00c05f63          	blez	a2,400 <memmove+0x2a>
 3e6:	1602                	slli	a2,a2,0x20
 3e8:	9201                	srli	a2,a2,0x20
 3ea:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3ee:	872a                	mv	a4,a0
      *dst++ = *src++;
 3f0:	0585                	addi	a1,a1,1
 3f2:	0705                	addi	a4,a4,1
 3f4:	fff5c683          	lbu	a3,-1(a1)
 3f8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3fc:	fee79ae3          	bne	a5,a4,3f0 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 400:	60a2                	ld	ra,8(sp)
 402:	6402                	ld	s0,0(sp)
 404:	0141                	addi	sp,sp,16
 406:	8082                	ret
    dst += n;
 408:	00c50733          	add	a4,a0,a2
    src += n;
 40c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 40e:	fec059e3          	blez	a2,400 <memmove+0x2a>
 412:	fff6079b          	addiw	a5,a2,-1
 416:	1782                	slli	a5,a5,0x20
 418:	9381                	srli	a5,a5,0x20
 41a:	fff7c793          	not	a5,a5
 41e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 420:	15fd                	addi	a1,a1,-1
 422:	177d                	addi	a4,a4,-1
 424:	0005c683          	lbu	a3,0(a1)
 428:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 42c:	fef71ae3          	bne	a4,a5,420 <memmove+0x4a>
 430:	bfc1                	j	400 <memmove+0x2a>

0000000000000432 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 432:	1141                	addi	sp,sp,-16
 434:	e406                	sd	ra,8(sp)
 436:	e022                	sd	s0,0(sp)
 438:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 43a:	ca0d                	beqz	a2,46c <memcmp+0x3a>
 43c:	fff6069b          	addiw	a3,a2,-1
 440:	1682                	slli	a3,a3,0x20
 442:	9281                	srli	a3,a3,0x20
 444:	0685                	addi	a3,a3,1
 446:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 448:	00054783          	lbu	a5,0(a0)
 44c:	0005c703          	lbu	a4,0(a1)
 450:	00e79863          	bne	a5,a4,460 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 454:	0505                	addi	a0,a0,1
    p2++;
 456:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 458:	fed518e3          	bne	a0,a3,448 <memcmp+0x16>
  }
  return 0;
 45c:	4501                	li	a0,0
 45e:	a019                	j	464 <memcmp+0x32>
      return *p1 - *p2;
 460:	40e7853b          	subw	a0,a5,a4
}
 464:	60a2                	ld	ra,8(sp)
 466:	6402                	ld	s0,0(sp)
 468:	0141                	addi	sp,sp,16
 46a:	8082                	ret
  return 0;
 46c:	4501                	li	a0,0
 46e:	bfdd                	j	464 <memcmp+0x32>

0000000000000470 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 470:	1141                	addi	sp,sp,-16
 472:	e406                	sd	ra,8(sp)
 474:	e022                	sd	s0,0(sp)
 476:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 478:	00000097          	auipc	ra,0x0
 47c:	f5e080e7          	jalr	-162(ra) # 3d6 <memmove>
}
 480:	60a2                	ld	ra,8(sp)
 482:	6402                	ld	s0,0(sp)
 484:	0141                	addi	sp,sp,16
 486:	8082                	ret

0000000000000488 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 488:	4885                	li	a7,1
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <exit>:
.global exit
exit:
 li a7, SYS_exit
 490:	4889                	li	a7,2
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <wait>:
.global wait
wait:
 li a7, SYS_wait
 498:	488d                	li	a7,3
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4a0:	4891                	li	a7,4
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <read>:
.global read
read:
 li a7, SYS_read
 4a8:	4895                	li	a7,5
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <write>:
.global write
write:
 li a7, SYS_write
 4b0:	48c1                	li	a7,16
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <close>:
.global close
close:
 li a7, SYS_close
 4b8:	48d5                	li	a7,21
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4c0:	4899                	li	a7,6
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4c8:	489d                	li	a7,7
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <open>:
.global open
open:
 li a7, SYS_open
 4d0:	48bd                	li	a7,15
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4d8:	48c5                	li	a7,17
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4e0:	48c9                	li	a7,18
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4e8:	48a1                	li	a7,8
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <link>:
.global link
link:
 li a7, SYS_link
 4f0:	48cd                	li	a7,19
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4f8:	48d1                	li	a7,20
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 500:	48a5                	li	a7,9
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <dup>:
.global dup
dup:
 li a7, SYS_dup
 508:	48a9                	li	a7,10
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 510:	48ad                	li	a7,11
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 518:	48b1                	li	a7,12
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 520:	48b5                	li	a7,13
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 528:	48b9                	li	a7,14
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <trace>:
.global trace
trace:
 li a7, SYS_trace
 530:	48d9                	li	a7,22
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 538:	48dd                	li	a7,23
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 540:	1101                	addi	sp,sp,-32
 542:	ec06                	sd	ra,24(sp)
 544:	e822                	sd	s0,16(sp)
 546:	1000                	addi	s0,sp,32
 548:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 54c:	4605                	li	a2,1
 54e:	fef40593          	addi	a1,s0,-17
 552:	00000097          	auipc	ra,0x0
 556:	f5e080e7          	jalr	-162(ra) # 4b0 <write>
}
 55a:	60e2                	ld	ra,24(sp)
 55c:	6442                	ld	s0,16(sp)
 55e:	6105                	addi	sp,sp,32
 560:	8082                	ret

0000000000000562 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 562:	7139                	addi	sp,sp,-64
 564:	fc06                	sd	ra,56(sp)
 566:	f822                	sd	s0,48(sp)
 568:	f426                	sd	s1,40(sp)
 56a:	f04a                	sd	s2,32(sp)
 56c:	ec4e                	sd	s3,24(sp)
 56e:	0080                	addi	s0,sp,64
 570:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 572:	c299                	beqz	a3,578 <printint+0x16>
 574:	0805c063          	bltz	a1,5f4 <printint+0x92>
  neg = 0;
 578:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 57a:	fc040313          	addi	t1,s0,-64
  neg = 0;
 57e:	869a                	mv	a3,t1
  i = 0;
 580:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 582:	00000817          	auipc	a6,0x0
 586:	61680813          	addi	a6,a6,1558 # b98 <digits>
 58a:	88be                	mv	a7,a5
 58c:	0017851b          	addiw	a0,a5,1
 590:	87aa                	mv	a5,a0
 592:	02c5f73b          	remuw	a4,a1,a2
 596:	1702                	slli	a4,a4,0x20
 598:	9301                	srli	a4,a4,0x20
 59a:	9742                	add	a4,a4,a6
 59c:	00074703          	lbu	a4,0(a4)
 5a0:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 5a4:	872e                	mv	a4,a1
 5a6:	02c5d5bb          	divuw	a1,a1,a2
 5aa:	0685                	addi	a3,a3,1
 5ac:	fcc77fe3          	bgeu	a4,a2,58a <printint+0x28>
  if(neg)
 5b0:	000e0c63          	beqz	t3,5c8 <printint+0x66>
    buf[i++] = '-';
 5b4:	fd050793          	addi	a5,a0,-48
 5b8:	00878533          	add	a0,a5,s0
 5bc:	02d00793          	li	a5,45
 5c0:	fef50823          	sb	a5,-16(a0)
 5c4:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 5c8:	fff7899b          	addiw	s3,a5,-1
 5cc:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 5d0:	fff4c583          	lbu	a1,-1(s1)
 5d4:	854a                	mv	a0,s2
 5d6:	00000097          	auipc	ra,0x0
 5da:	f6a080e7          	jalr	-150(ra) # 540 <putc>
  while(--i >= 0)
 5de:	39fd                	addiw	s3,s3,-1
 5e0:	14fd                	addi	s1,s1,-1
 5e2:	fe09d7e3          	bgez	s3,5d0 <printint+0x6e>
}
 5e6:	70e2                	ld	ra,56(sp)
 5e8:	7442                	ld	s0,48(sp)
 5ea:	74a2                	ld	s1,40(sp)
 5ec:	7902                	ld	s2,32(sp)
 5ee:	69e2                	ld	s3,24(sp)
 5f0:	6121                	addi	sp,sp,64
 5f2:	8082                	ret
    x = -xx;
 5f4:	40b005bb          	negw	a1,a1
    neg = 1;
 5f8:	4e05                	li	t3,1
    x = -xx;
 5fa:	b741                	j	57a <printint+0x18>

00000000000005fc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5fc:	711d                	addi	sp,sp,-96
 5fe:	ec86                	sd	ra,88(sp)
 600:	e8a2                	sd	s0,80(sp)
 602:	e4a6                	sd	s1,72(sp)
 604:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 606:	0005c483          	lbu	s1,0(a1)
 60a:	2a048863          	beqz	s1,8ba <vprintf+0x2be>
 60e:	e0ca                	sd	s2,64(sp)
 610:	fc4e                	sd	s3,56(sp)
 612:	f852                	sd	s4,48(sp)
 614:	f456                	sd	s5,40(sp)
 616:	f05a                	sd	s6,32(sp)
 618:	ec5e                	sd	s7,24(sp)
 61a:	e862                	sd	s8,16(sp)
 61c:	e466                	sd	s9,8(sp)
 61e:	8b2a                	mv	s6,a0
 620:	8a2e                	mv	s4,a1
 622:	8bb2                	mv	s7,a2
  state = 0;
 624:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 626:	4901                	li	s2,0
 628:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 62a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 62e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 632:	06c00c93          	li	s9,108
 636:	a01d                	j	65c <vprintf+0x60>
        putc(fd, c0);
 638:	85a6                	mv	a1,s1
 63a:	855a                	mv	a0,s6
 63c:	00000097          	auipc	ra,0x0
 640:	f04080e7          	jalr	-252(ra) # 540 <putc>
 644:	a019                	j	64a <vprintf+0x4e>
    } else if(state == '%'){
 646:	03598363          	beq	s3,s5,66c <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 64a:	0019079b          	addiw	a5,s2,1
 64e:	893e                	mv	s2,a5
 650:	873e                	mv	a4,a5
 652:	97d2                	add	a5,a5,s4
 654:	0007c483          	lbu	s1,0(a5)
 658:	24048963          	beqz	s1,8aa <vprintf+0x2ae>
    c0 = fmt[i] & 0xff;
 65c:	0004879b          	sext.w	a5,s1
    if(state == 0){
 660:	fe0993e3          	bnez	s3,646 <vprintf+0x4a>
      if(c0 == '%'){
 664:	fd579ae3          	bne	a5,s5,638 <vprintf+0x3c>
        state = '%';
 668:	89be                	mv	s3,a5
 66a:	b7c5                	j	64a <vprintf+0x4e>
      if(c0) c1 = fmt[i+1] & 0xff;
 66c:	00ea06b3          	add	a3,s4,a4
 670:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 674:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 676:	c681                	beqz	a3,67e <vprintf+0x82>
 678:	9752                	add	a4,a4,s4
 67a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 67e:	05878063          	beq	a5,s8,6be <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 682:	05978c63          	beq	a5,s9,6da <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 686:	07500713          	li	a4,117
 68a:	10e78063          	beq	a5,a4,78a <vprintf+0x18e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 68e:	07800713          	li	a4,120
 692:	14e78863          	beq	a5,a4,7e2 <vprintf+0x1e6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 696:	07000713          	li	a4,112
 69a:	18e78163          	beq	a5,a4,81c <vprintf+0x220>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 69e:	07300713          	li	a4,115
 6a2:	1ce78663          	beq	a5,a4,86e <vprintf+0x272>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6a6:	02500713          	li	a4,37
 6aa:	04e79863          	bne	a5,a4,6fa <vprintf+0xfe>
        putc(fd, '%');
 6ae:	85ba                	mv	a1,a4
 6b0:	855a                	mv	a0,s6
 6b2:	00000097          	auipc	ra,0x0
 6b6:	e8e080e7          	jalr	-370(ra) # 540 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	b779                	j	64a <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 1);
 6be:	008b8493          	addi	s1,s7,8
 6c2:	4685                	li	a3,1
 6c4:	4629                	li	a2,10
 6c6:	000ba583          	lw	a1,0(s7)
 6ca:	855a                	mv	a0,s6
 6cc:	00000097          	auipc	ra,0x0
 6d0:	e96080e7          	jalr	-362(ra) # 562 <printint>
 6d4:	8ba6                	mv	s7,s1
      state = 0;
 6d6:	4981                	li	s3,0
 6d8:	bf8d                	j	64a <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'd'){
 6da:	06400793          	li	a5,100
 6de:	02f68d63          	beq	a3,a5,718 <vprintf+0x11c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6e2:	06c00793          	li	a5,108
 6e6:	04f68863          	beq	a3,a5,736 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'u'){
 6ea:	07500793          	li	a5,117
 6ee:	0af68c63          	beq	a3,a5,7a6 <vprintf+0x1aa>
      } else if(c0 == 'l' && c1 == 'x'){
 6f2:	07800793          	li	a5,120
 6f6:	10f68463          	beq	a3,a5,7fe <vprintf+0x202>
        putc(fd, '%');
 6fa:	02500593          	li	a1,37
 6fe:	855a                	mv	a0,s6
 700:	00000097          	auipc	ra,0x0
 704:	e40080e7          	jalr	-448(ra) # 540 <putc>
        putc(fd, c0);
 708:	85a6                	mv	a1,s1
 70a:	855a                	mv	a0,s6
 70c:	00000097          	auipc	ra,0x0
 710:	e34080e7          	jalr	-460(ra) # 540 <putc>
      state = 0;
 714:	4981                	li	s3,0
 716:	bf15                	j	64a <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 718:	008b8493          	addi	s1,s7,8
 71c:	4685                	li	a3,1
 71e:	4629                	li	a2,10
 720:	000ba583          	lw	a1,0(s7)
 724:	855a                	mv	a0,s6
 726:	00000097          	auipc	ra,0x0
 72a:	e3c080e7          	jalr	-452(ra) # 562 <printint>
        i += 1;
 72e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 730:	8ba6                	mv	s7,s1
      state = 0;
 732:	4981                	li	s3,0
        i += 1;
 734:	bf19                	j	64a <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 736:	06400793          	li	a5,100
 73a:	02f60963          	beq	a2,a5,76c <vprintf+0x170>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 73e:	07500793          	li	a5,117
 742:	08f60163          	beq	a2,a5,7c4 <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 746:	07800793          	li	a5,120
 74a:	faf618e3          	bne	a2,a5,6fa <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 74e:	008b8493          	addi	s1,s7,8
 752:	4681                	li	a3,0
 754:	4641                	li	a2,16
 756:	000ba583          	lw	a1,0(s7)
 75a:	855a                	mv	a0,s6
 75c:	00000097          	auipc	ra,0x0
 760:	e06080e7          	jalr	-506(ra) # 562 <printint>
        i += 2;
 764:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 766:	8ba6                	mv	s7,s1
      state = 0;
 768:	4981                	li	s3,0
        i += 2;
 76a:	b5c5                	j	64a <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 76c:	008b8493          	addi	s1,s7,8
 770:	4685                	li	a3,1
 772:	4629                	li	a2,10
 774:	000ba583          	lw	a1,0(s7)
 778:	855a                	mv	a0,s6
 77a:	00000097          	auipc	ra,0x0
 77e:	de8080e7          	jalr	-536(ra) # 562 <printint>
        i += 2;
 782:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 784:	8ba6                	mv	s7,s1
      state = 0;
 786:	4981                	li	s3,0
        i += 2;
 788:	b5c9                	j	64a <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 0);
 78a:	008b8493          	addi	s1,s7,8
 78e:	4681                	li	a3,0
 790:	4629                	li	a2,10
 792:	000ba583          	lw	a1,0(s7)
 796:	855a                	mv	a0,s6
 798:	00000097          	auipc	ra,0x0
 79c:	dca080e7          	jalr	-566(ra) # 562 <printint>
 7a0:	8ba6                	mv	s7,s1
      state = 0;
 7a2:	4981                	li	s3,0
 7a4:	b55d                	j	64a <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a6:	008b8493          	addi	s1,s7,8
 7aa:	4681                	li	a3,0
 7ac:	4629                	li	a2,10
 7ae:	000ba583          	lw	a1,0(s7)
 7b2:	855a                	mv	a0,s6
 7b4:	00000097          	auipc	ra,0x0
 7b8:	dae080e7          	jalr	-594(ra) # 562 <printint>
        i += 1;
 7bc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7be:	8ba6                	mv	s7,s1
      state = 0;
 7c0:	4981                	li	s3,0
        i += 1;
 7c2:	b561                	j	64a <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c4:	008b8493          	addi	s1,s7,8
 7c8:	4681                	li	a3,0
 7ca:	4629                	li	a2,10
 7cc:	000ba583          	lw	a1,0(s7)
 7d0:	855a                	mv	a0,s6
 7d2:	00000097          	auipc	ra,0x0
 7d6:	d90080e7          	jalr	-624(ra) # 562 <printint>
        i += 2;
 7da:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7dc:	8ba6                	mv	s7,s1
      state = 0;
 7de:	4981                	li	s3,0
        i += 2;
 7e0:	b5ad                	j	64a <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 16, 0);
 7e2:	008b8493          	addi	s1,s7,8
 7e6:	4681                	li	a3,0
 7e8:	4641                	li	a2,16
 7ea:	000ba583          	lw	a1,0(s7)
 7ee:	855a                	mv	a0,s6
 7f0:	00000097          	auipc	ra,0x0
 7f4:	d72080e7          	jalr	-654(ra) # 562 <printint>
 7f8:	8ba6                	mv	s7,s1
      state = 0;
 7fa:	4981                	li	s3,0
 7fc:	b5b9                	j	64a <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7fe:	008b8493          	addi	s1,s7,8
 802:	4681                	li	a3,0
 804:	4641                	li	a2,16
 806:	000ba583          	lw	a1,0(s7)
 80a:	855a                	mv	a0,s6
 80c:	00000097          	auipc	ra,0x0
 810:	d56080e7          	jalr	-682(ra) # 562 <printint>
        i += 1;
 814:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 816:	8ba6                	mv	s7,s1
      state = 0;
 818:	4981                	li	s3,0
        i += 1;
 81a:	bd05                	j	64a <vprintf+0x4e>
 81c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 81e:	008b8d13          	addi	s10,s7,8
 822:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 826:	03000593          	li	a1,48
 82a:	855a                	mv	a0,s6
 82c:	00000097          	auipc	ra,0x0
 830:	d14080e7          	jalr	-748(ra) # 540 <putc>
  putc(fd, 'x');
 834:	07800593          	li	a1,120
 838:	855a                	mv	a0,s6
 83a:	00000097          	auipc	ra,0x0
 83e:	d06080e7          	jalr	-762(ra) # 540 <putc>
 842:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 844:	00000b97          	auipc	s7,0x0
 848:	354b8b93          	addi	s7,s7,852 # b98 <digits>
 84c:	03c9d793          	srli	a5,s3,0x3c
 850:	97de                	add	a5,a5,s7
 852:	0007c583          	lbu	a1,0(a5)
 856:	855a                	mv	a0,s6
 858:	00000097          	auipc	ra,0x0
 85c:	ce8080e7          	jalr	-792(ra) # 540 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 860:	0992                	slli	s3,s3,0x4
 862:	34fd                	addiw	s1,s1,-1
 864:	f4e5                	bnez	s1,84c <vprintf+0x250>
        printptr(fd, va_arg(ap, uint64));
 866:	8bea                	mv	s7,s10
      state = 0;
 868:	4981                	li	s3,0
 86a:	6d02                	ld	s10,0(sp)
 86c:	bbf9                	j	64a <vprintf+0x4e>
        if((s = va_arg(ap, char*)) == 0)
 86e:	008b8993          	addi	s3,s7,8
 872:	000bb483          	ld	s1,0(s7)
 876:	c085                	beqz	s1,896 <vprintf+0x29a>
        for(; *s; s++)
 878:	0004c583          	lbu	a1,0(s1)
 87c:	c585                	beqz	a1,8a4 <vprintf+0x2a8>
          putc(fd, *s);
 87e:	855a                	mv	a0,s6
 880:	00000097          	auipc	ra,0x0
 884:	cc0080e7          	jalr	-832(ra) # 540 <putc>
        for(; *s; s++)
 888:	0485                	addi	s1,s1,1
 88a:	0004c583          	lbu	a1,0(s1)
 88e:	f9e5                	bnez	a1,87e <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
 890:	8bce                	mv	s7,s3
      state = 0;
 892:	4981                	li	s3,0
 894:	bb5d                	j	64a <vprintf+0x4e>
          s = "(null)";
 896:	00000497          	auipc	s1,0x0
 89a:	2fa48493          	addi	s1,s1,762 # b90 <malloc+0x1e2>
        for(; *s; s++)
 89e:	02800593          	li	a1,40
 8a2:	bff1                	j	87e <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
 8a4:	8bce                	mv	s7,s3
      state = 0;
 8a6:	4981                	li	s3,0
 8a8:	b34d                	j	64a <vprintf+0x4e>
 8aa:	6906                	ld	s2,64(sp)
 8ac:	79e2                	ld	s3,56(sp)
 8ae:	7a42                	ld	s4,48(sp)
 8b0:	7aa2                	ld	s5,40(sp)
 8b2:	7b02                	ld	s6,32(sp)
 8b4:	6be2                	ld	s7,24(sp)
 8b6:	6c42                	ld	s8,16(sp)
 8b8:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8ba:	60e6                	ld	ra,88(sp)
 8bc:	6446                	ld	s0,80(sp)
 8be:	64a6                	ld	s1,72(sp)
 8c0:	6125                	addi	sp,sp,96
 8c2:	8082                	ret

00000000000008c4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8c4:	715d                	addi	sp,sp,-80
 8c6:	ec06                	sd	ra,24(sp)
 8c8:	e822                	sd	s0,16(sp)
 8ca:	1000                	addi	s0,sp,32
 8cc:	e010                	sd	a2,0(s0)
 8ce:	e414                	sd	a3,8(s0)
 8d0:	e818                	sd	a4,16(s0)
 8d2:	ec1c                	sd	a5,24(s0)
 8d4:	03043023          	sd	a6,32(s0)
 8d8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8dc:	8622                	mv	a2,s0
 8de:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8e2:	00000097          	auipc	ra,0x0
 8e6:	d1a080e7          	jalr	-742(ra) # 5fc <vprintf>
}
 8ea:	60e2                	ld	ra,24(sp)
 8ec:	6442                	ld	s0,16(sp)
 8ee:	6161                	addi	sp,sp,80
 8f0:	8082                	ret

00000000000008f2 <printf>:

void
printf(const char *fmt, ...)
{
 8f2:	711d                	addi	sp,sp,-96
 8f4:	ec06                	sd	ra,24(sp)
 8f6:	e822                	sd	s0,16(sp)
 8f8:	1000                	addi	s0,sp,32
 8fa:	e40c                	sd	a1,8(s0)
 8fc:	e810                	sd	a2,16(s0)
 8fe:	ec14                	sd	a3,24(s0)
 900:	f018                	sd	a4,32(s0)
 902:	f41c                	sd	a5,40(s0)
 904:	03043823          	sd	a6,48(s0)
 908:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 90c:	00840613          	addi	a2,s0,8
 910:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 914:	85aa                	mv	a1,a0
 916:	4505                	li	a0,1
 918:	00000097          	auipc	ra,0x0
 91c:	ce4080e7          	jalr	-796(ra) # 5fc <vprintf>
}
 920:	60e2                	ld	ra,24(sp)
 922:	6442                	ld	s0,16(sp)
 924:	6125                	addi	sp,sp,96
 926:	8082                	ret

0000000000000928 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 928:	1141                	addi	sp,sp,-16
 92a:	e406                	sd	ra,8(sp)
 92c:	e022                	sd	s0,0(sp)
 92e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 930:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 934:	00000797          	auipc	a5,0x0
 938:	6cc7b783          	ld	a5,1740(a5) # 1000 <freep>
 93c:	a02d                	j	966 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 93e:	4618                	lw	a4,8(a2)
 940:	9f2d                	addw	a4,a4,a1
 942:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 946:	6398                	ld	a4,0(a5)
 948:	6310                	ld	a2,0(a4)
 94a:	a83d                	j	988 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 94c:	ff852703          	lw	a4,-8(a0)
 950:	9f31                	addw	a4,a4,a2
 952:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 954:	ff053683          	ld	a3,-16(a0)
 958:	a091                	j	99c <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 95a:	6398                	ld	a4,0(a5)
 95c:	00e7e463          	bltu	a5,a4,964 <free+0x3c>
 960:	00e6ea63          	bltu	a3,a4,974 <free+0x4c>
{
 964:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 966:	fed7fae3          	bgeu	a5,a3,95a <free+0x32>
 96a:	6398                	ld	a4,0(a5)
 96c:	00e6e463          	bltu	a3,a4,974 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 970:	fee7eae3          	bltu	a5,a4,964 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 974:	ff852583          	lw	a1,-8(a0)
 978:	6390                	ld	a2,0(a5)
 97a:	02059813          	slli	a6,a1,0x20
 97e:	01c85713          	srli	a4,a6,0x1c
 982:	9736                	add	a4,a4,a3
 984:	fae60de3          	beq	a2,a4,93e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 988:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 98c:	4790                	lw	a2,8(a5)
 98e:	02061593          	slli	a1,a2,0x20
 992:	01c5d713          	srli	a4,a1,0x1c
 996:	973e                	add	a4,a4,a5
 998:	fae68ae3          	beq	a3,a4,94c <free+0x24>
    p->s.ptr = bp->s.ptr;
 99c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 99e:	00000717          	auipc	a4,0x0
 9a2:	66f73123          	sd	a5,1634(a4) # 1000 <freep>
}
 9a6:	60a2                	ld	ra,8(sp)
 9a8:	6402                	ld	s0,0(sp)
 9aa:	0141                	addi	sp,sp,16
 9ac:	8082                	ret

00000000000009ae <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ae:	7139                	addi	sp,sp,-64
 9b0:	fc06                	sd	ra,56(sp)
 9b2:	f822                	sd	s0,48(sp)
 9b4:	f04a                	sd	s2,32(sp)
 9b6:	ec4e                	sd	s3,24(sp)
 9b8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9ba:	02051993          	slli	s3,a0,0x20
 9be:	0209d993          	srli	s3,s3,0x20
 9c2:	09bd                	addi	s3,s3,15
 9c4:	0049d993          	srli	s3,s3,0x4
 9c8:	2985                	addiw	s3,s3,1
 9ca:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 9cc:	00000517          	auipc	a0,0x0
 9d0:	63453503          	ld	a0,1588(a0) # 1000 <freep>
 9d4:	c905                	beqz	a0,a04 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d8:	4798                	lw	a4,8(a5)
 9da:	09377a63          	bgeu	a4,s3,a6e <malloc+0xc0>
 9de:	f426                	sd	s1,40(sp)
 9e0:	e852                	sd	s4,16(sp)
 9e2:	e456                	sd	s5,8(sp)
 9e4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9e6:	8a4e                	mv	s4,s3
 9e8:	6705                	lui	a4,0x1
 9ea:	00e9f363          	bgeu	s3,a4,9f0 <malloc+0x42>
 9ee:	6a05                	lui	s4,0x1
 9f0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9f4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9f8:	00000497          	auipc	s1,0x0
 9fc:	60848493          	addi	s1,s1,1544 # 1000 <freep>
  if(p == (char*)-1)
 a00:	5afd                	li	s5,-1
 a02:	a089                	j	a44 <malloc+0x96>
 a04:	f426                	sd	s1,40(sp)
 a06:	e852                	sd	s4,16(sp)
 a08:	e456                	sd	s5,8(sp)
 a0a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a0c:	00000797          	auipc	a5,0x0
 a10:	60478793          	addi	a5,a5,1540 # 1010 <base>
 a14:	00000717          	auipc	a4,0x0
 a18:	5ef73623          	sd	a5,1516(a4) # 1000 <freep>
 a1c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a1e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a22:	b7d1                	j	9e6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a24:	6398                	ld	a4,0(a5)
 a26:	e118                	sd	a4,0(a0)
 a28:	a8b9                	j	a86 <malloc+0xd8>
  hp->s.size = nu;
 a2a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a2e:	0541                	addi	a0,a0,16
 a30:	00000097          	auipc	ra,0x0
 a34:	ef8080e7          	jalr	-264(ra) # 928 <free>
  return freep;
 a38:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a3a:	c135                	beqz	a0,a9e <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a3c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a3e:	4798                	lw	a4,8(a5)
 a40:	03277363          	bgeu	a4,s2,a66 <malloc+0xb8>
    if(p == freep)
 a44:	6098                	ld	a4,0(s1)
 a46:	853e                	mv	a0,a5
 a48:	fef71ae3          	bne	a4,a5,a3c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a4c:	8552                	mv	a0,s4
 a4e:	00000097          	auipc	ra,0x0
 a52:	aca080e7          	jalr	-1334(ra) # 518 <sbrk>
  if(p == (char*)-1)
 a56:	fd551ae3          	bne	a0,s5,a2a <malloc+0x7c>
        return 0;
 a5a:	4501                	li	a0,0
 a5c:	74a2                	ld	s1,40(sp)
 a5e:	6a42                	ld	s4,16(sp)
 a60:	6aa2                	ld	s5,8(sp)
 a62:	6b02                	ld	s6,0(sp)
 a64:	a03d                	j	a92 <malloc+0xe4>
 a66:	74a2                	ld	s1,40(sp)
 a68:	6a42                	ld	s4,16(sp)
 a6a:	6aa2                	ld	s5,8(sp)
 a6c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a6e:	fae90be3          	beq	s2,a4,a24 <malloc+0x76>
        p->s.size -= nunits;
 a72:	4137073b          	subw	a4,a4,s3
 a76:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a78:	02071693          	slli	a3,a4,0x20
 a7c:	01c6d713          	srli	a4,a3,0x1c
 a80:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a82:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a86:	00000717          	auipc	a4,0x0
 a8a:	56a73d23          	sd	a0,1402(a4) # 1000 <freep>
      return (void*)(p + 1);
 a8e:	01078513          	addi	a0,a5,16
  }
}
 a92:	70e2                	ld	ra,56(sp)
 a94:	7442                	ld	s0,48(sp)
 a96:	7902                	ld	s2,32(sp)
 a98:	69e2                	ld	s3,24(sp)
 a9a:	6121                	addi	sp,sp,64
 a9c:	8082                	ret
 a9e:	74a2                	ld	s1,40(sp)
 aa0:	6a42                	ld	s4,16(sp)
 aa2:	6aa2                	ld	s5,8(sp)
 aa4:	6b02                	ld	s6,0(sp)
 aa6:	b7f5                	j	a92 <malloc+0xe4>
