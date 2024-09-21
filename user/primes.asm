
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <new_pipe>:
        exit(ERROR);
    }
    return num;
}

int* new_pipe() {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
    int* fd = (int*)malloc(sizeof(int) * PIPE_SIZE);
   a:	4521                	li	a0,8
   c:	19b000ef          	jal	9a6 <malloc>
  10:	84aa                	mv	s1,a0

    // Attempt to create the child pipe.
    if (pipe(fd) != 0) {
  12:	4da000ef          	jal	4ec <pipe>
  16:	e519                	bnez	a0,24 <new_pipe+0x24>
        printf("Error creating child pipe\n");
        exit(ERROR);
    }
    return fd;
}
  18:	8526                	mv	a0,s1
  1a:	60e2                	ld	ra,24(sp)
  1c:	6442                	ld	s0,16(sp)
  1e:	64a2                	ld	s1,8(sp)
  20:	6105                	addi	sp,sp,32
  22:	8082                	ret
        printf("Error creating child pipe\n");
  24:	00001517          	auipc	a0,0x1
  28:	a7c50513          	addi	a0,a0,-1412 # aa0 <malloc+0xfa>
  2c:	0c3000ef          	jal	8ee <printf>
        exit(ERROR);
  30:	4505                	li	a0,1
  32:	4aa000ef          	jal	4dc <exit>

0000000000000036 <handle_parent>:

void handle_parent(int* first_fd, int child_pid) {
  36:	711d                	addi	sp,sp,-96
  38:	ec86                	sd	ra,88(sp)
  3a:	e8a2                	sd	s0,80(sp)
  3c:	e4a6                	sd	s1,72(sp)
  3e:	e0ca                	sd	s2,64(sp)
  40:	fc4e                	sd	s3,56(sp)
  42:	f852                	sd	s4,48(sp)
  44:	f456                	sd	s5,40(sp)
  46:	f05a                	sd	s6,32(sp)
  48:	1080                	addi	s0,sp,96
  4a:	892a                	mv	s2,a0
  4c:	fab42623          	sw	a1,-84(s0)
    close(first_fd[PIPE_READ]);
  50:	4108                	lw	a0,0(a0)
  52:	4b2000ef          	jal	504 <close>

    // Send the next process's number to it.
    send_num(MIN_PIPELINE_VAL, first_fd);
  56:	4489                	li	s1,2
  58:	fa942e23          	sw	s1,-68(s0)
    write(fd_array[PIPE_WRITE], &num, sizeof(int));
  5c:	4611                	li	a2,4
  5e:	fbc40593          	addi	a1,s0,-68
  62:	00492503          	lw	a0,4(s2)
  66:	496000ef          	jal	4fc <write>
  6a:	fbc40b13          	addi	s6,s0,-68
  6e:	4a91                	li	s5,4

    // Write all numbers from 2 to 35 to the pipeline.
    for (int i = MIN_PIPELINE_VAL; i <= MAX_PIPELINE_VAL; i++) {
        send_num(i, first_fd);
        sleep(SLEEP_DELAY_BETWEEN_NUMS);
  70:	4a05                	li	s4,1
    for (int i = MIN_PIPELINE_VAL; i <= MAX_PIPELINE_VAL; i++) {
  72:	02400993          	li	s3,36
        send_num(i, first_fd);
  76:	fa942e23          	sw	s1,-68(s0)
    write(fd_array[PIPE_WRITE], &num, sizeof(int));
  7a:	8656                	mv	a2,s5
  7c:	85da                	mv	a1,s6
  7e:	00492503          	lw	a0,4(s2)
  82:	47a000ef          	jal	4fc <write>
        sleep(SLEEP_DELAY_BETWEEN_NUMS);
  86:	8552                	mv	a0,s4
  88:	4e4000ef          	jal	56c <sleep>
    for (int i = MIN_PIPELINE_VAL; i <= MAX_PIPELINE_VAL; i++) {
  8c:	2485                	addiw	s1,s1,1
  8e:	ff3494e3          	bne	s1,s3,76 <handle_parent+0x40>
    }

    // Send shutdown signal to the child.
    send_num(EXIT_SIGNAL, first_fd);
  92:	57fd                	li	a5,-1
  94:	faf42e23          	sw	a5,-68(s0)
    write(fd_array[PIPE_WRITE], &num, sizeof(int));
  98:	4611                	li	a2,4
  9a:	fbc40593          	addi	a1,s0,-68
  9e:	00492503          	lw	a0,4(s2)
  a2:	45a000ef          	jal	4fc <write>

    // Wait for the child to exit.
    wait(&child_pid);
  a6:	fac40513          	addi	a0,s0,-84
  aa:	43a000ef          	jal	4e4 <wait>

    // Close the pipe.
    close(first_fd[PIPE_WRITE]);
  ae:	00492503          	lw	a0,4(s2)
  b2:	452000ef          	jal	504 <close>
    free(first_fd);
  b6:	854a                	mv	a0,s2
  b8:	069000ef          	jal	920 <free>
    exit(SUCCESS);
  bc:	4501                	li	a0,0
  be:	41e000ef          	jal	4dc <exit>

00000000000000c2 <handle_child>:
}

void handle_child(int* parent_fd) __attribute__((noreturn));
void handle_child(int* parent_fd) {
  c2:	715d                	addi	sp,sp,-80
  c4:	e486                	sd	ra,72(sp)
  c6:	e0a2                	sd	s0,64(sp)
  c8:	f44e                	sd	s3,40(sp)
  ca:	0880                	addi	s0,sp,80
  cc:	89aa                	mv	s3,a0
    int recv_num = 0;
  ce:	fa042e23          	sw	zero,-68(s0)
    int* next_fd = NULL;
    int my_num = 0;
  d2:	fa042c23          	sw	zero,-72(s0)
    int new_pid = -1;
  d6:	57fd                	li	a5,-1
  d8:	faf42a23          	sw	a5,-76(s0)

    close(parent_fd[PIPE_WRITE]);
  dc:	4148                	lw	a0,4(a0)
  de:	426000ef          	jal	504 <close>

    // Attempt to read the current num (and check the case where no bytes were read).
    if (read(parent_fd[PIPE_READ], &my_num, sizeof(int)) <= 0) {
  e2:	4611                	li	a2,4
  e4:	fb840593          	addi	a1,s0,-72
  e8:	0009a503          	lw	a0,0(s3)
  ec:	408000ef          	jal	4f4 <read>
  f0:	02a05763          	blez	a0,11e <handle_child+0x5c>
  f4:	fc26                	sd	s1,56(sp)
  f6:	f84a                	sd	s2,48(sp)
  f8:	f052                	sd	s4,32(sp)
  fa:	ec56                	sd	s5,24(sp)
  fc:	e85a                	sd	s6,16(sp)
        printf("Error reading received bytes\n");
        exit(ERROR);
    }
    printf("prime %d\n", my_num);
  fe:	fb842583          	lw	a1,-72(s0)
 102:	00001517          	auipc	a0,0x1
 106:	9de50513          	addi	a0,a0,-1570 # ae0 <malloc+0x13a>
 10a:	7e4000ef          	jal	8ee <printf>
    int* next_fd = NULL;
 10e:	4481                	li	s1,0

    // Handle received numbers and check if the current number divides them.
    while (true) {
        // Attempt to read the current num (and check the case where no bytes were read).
        if (read(parent_fd[PIPE_READ], &recv_num, sizeof(int)) <= 0) {
 110:	fbc40a13          	addi	s4,s0,-68
 114:	4911                	li	s2,4
            printf("Error reading received bytes\n");
            exit(ERROR);
        }

        // Exit if the current number is the EXIT_SIGNAL.
        if (recv_num == EXIT_SIGNAL) break;
 116:	5afd                	li	s5,-1
    write(fd_array[PIPE_WRITE], &num, sizeof(int));
 118:	fb040b13          	addi	s6,s0,-80
 11c:	a83d                	j	15a <handle_child+0x98>
 11e:	fc26                	sd	s1,56(sp)
 120:	f84a                	sd	s2,48(sp)
 122:	f052                	sd	s4,32(sp)
 124:	ec56                	sd	s5,24(sp)
 126:	e85a                	sd	s6,16(sp)
        printf("Error reading received bytes\n");
 128:	00001517          	auipc	a0,0x1
 12c:	99850513          	addi	a0,a0,-1640 # ac0 <malloc+0x11a>
 130:	7be000ef          	jal	8ee <printf>
        exit(ERROR);
 134:	4505                	li	a0,1
 136:	3a6000ef          	jal	4dc <exit>
            printf("Error reading received bytes\n");
 13a:	00001517          	auipc	a0,0x1
 13e:	98650513          	addi	a0,a0,-1658 # ac0 <malloc+0x11a>
 142:	7ac000ef          	jal	8ee <printf>
            exit(ERROR);
 146:	4505                	li	a0,1
 148:	394000ef          	jal	4dc <exit>
        if (recv_num % my_num == 0) continue;

        // If this process already has a child, send the number to it.
        if (next_fd != NULL) {
            send_num(recv_num, next_fd);
 14c:	fae42823          	sw	a4,-80(s0)
    write(fd_array[PIPE_WRITE], &num, sizeof(int));
 150:	864a                	mv	a2,s2
 152:	85da                	mv	a1,s6
 154:	40c8                	lw	a0,4(s1)
 156:	3a6000ef          	jal	4fc <write>
        if (read(parent_fd[PIPE_READ], &recv_num, sizeof(int)) <= 0) {
 15a:	864a                	mv	a2,s2
 15c:	85d2                	mv	a1,s4
 15e:	0009a503          	lw	a0,0(s3)
 162:	392000ef          	jal	4f4 <read>
 166:	fca05ae3          	blez	a0,13a <handle_child+0x78>
        if (recv_num == EXIT_SIGNAL) break;
 16a:	fbc42703          	lw	a4,-68(s0)
 16e:	05570c63          	beq	a4,s5,1c6 <handle_child+0x104>
        if (recv_num % my_num == 0) continue;
 172:	fb842783          	lw	a5,-72(s0)
 176:	02f767bb          	remw	a5,a4,a5
 17a:	d3e5                	beqz	a5,15a <handle_child+0x98>
        if (next_fd != NULL) {
 17c:	f8e1                	bnez	s1,14c <handle_child+0x8a>
            continue;
        }

        // Create a child for the process if one doesn't already exist.
        next_fd = new_pipe();
 17e:	e83ff0ef          	jal	0 <new_pipe>
 182:	84aa                	mv	s1,a0
        new_pid = fork();
 184:	350000ef          	jal	4d4 <fork>
 188:	faa42a23          	sw	a0,-76(s0)
        if (new_pid < 0) {
 18c:	02054163          	bltz	a0,1ae <handle_child+0xec>
            printf("Error forking process\n");
            exit(ERROR);
        } else if (new_pid > 0) {
 190:	02a05863          	blez	a0,1c0 <handle_child+0xfe>
            // Close the reading part of the child's fd and send the number to it.
            close(next_fd[PIPE_READ]);
 194:	4088                	lw	a0,0(s1)
 196:	36e000ef          	jal	504 <close>
            send_num(recv_num, next_fd);
 19a:	fbc42783          	lw	a5,-68(s0)
 19e:	faf42823          	sw	a5,-80(s0)
    write(fd_array[PIPE_WRITE], &num, sizeof(int));
 1a2:	864a                	mv	a2,s2
 1a4:	85da                	mv	a1,s6
 1a6:	40c8                	lw	a0,4(s1)
 1a8:	354000ef          	jal	4fc <write>
 1ac:	b77d                	j	15a <handle_child+0x98>
            printf("Error forking process\n");
 1ae:	00001517          	auipc	a0,0x1
 1b2:	94250513          	addi	a0,a0,-1726 # af0 <malloc+0x14a>
 1b6:	738000ef          	jal	8ee <printf>
            exit(ERROR);
 1ba:	4505                	li	a0,1
 1bc:	320000ef          	jal	4dc <exit>
        }
        else handle_child(next_fd);
 1c0:	8526                	mv	a0,s1
 1c2:	f01ff0ef          	jal	c2 <handle_child>
    }

    // Shutdown the child if one exists.
    if (next_fd != NULL) {
 1c6:	c485                	beqz	s1,1ee <handle_child+0x12c>
        send_num(EXIT_SIGNAL, next_fd);
 1c8:	57fd                	li	a5,-1
 1ca:	faf42823          	sw	a5,-80(s0)
    write(fd_array[PIPE_WRITE], &num, sizeof(int));
 1ce:	4611                	li	a2,4
 1d0:	fb040593          	addi	a1,s0,-80
 1d4:	40c8                	lw	a0,4(s1)
 1d6:	326000ef          	jal	4fc <write>
        wait(&new_pid);
 1da:	fb440513          	addi	a0,s0,-76
 1de:	306000ef          	jal	4e4 <wait>
        
        // Release the fds this process uses.
        close(next_fd[PIPE_WRITE]);
 1e2:	40c8                	lw	a0,4(s1)
 1e4:	320000ef          	jal	504 <close>
        free(next_fd);
 1e8:	8526                	mv	a0,s1
 1ea:	736000ef          	jal	920 <free>
    }

    // CLose the reading hand of the parent's pipe.
    close(parent_fd[PIPE_READ]);
 1ee:	0009a503          	lw	a0,0(s3)
 1f2:	312000ef          	jal	504 <close>
    free(parent_fd);
 1f6:	854e                	mv	a0,s3
 1f8:	728000ef          	jal	920 <free>
    exit(SUCCESS);
 1fc:	4501                	li	a0,0
 1fe:	2de000ef          	jal	4dc <exit>

0000000000000202 <main>:
}

int main(int argc, char *argv[])
{
 202:	1101                	addi	sp,sp,-32
 204:	ec06                	sd	ra,24(sp)
 206:	e822                	sd	s0,16(sp)
 208:	e426                	sd	s1,8(sp)
 20a:	1000                	addi	s0,sp,32
    int* first_fd = new_pipe();
 20c:	df5ff0ef          	jal	0 <new_pipe>
 210:	84aa                	mv	s1,a0
    int pid = fork();
 212:	2c2000ef          	jal	4d4 <fork>

    // Check for fork error.
    if (pid < 0) {
 216:	00054863          	bltz	a0,226 <main+0x24>
        printf("Error forking process\n");
        exit(ERROR);
    } else if (pid > 0) handle_parent(first_fd, pid);
 21a:	00a05f63          	blez	a0,238 <main+0x36>
 21e:	85aa                	mv	a1,a0
 220:	8526                	mv	a0,s1
 222:	e15ff0ef          	jal	36 <handle_parent>
        printf("Error forking process\n");
 226:	00001517          	auipc	a0,0x1
 22a:	8ca50513          	addi	a0,a0,-1846 # af0 <malloc+0x14a>
 22e:	6c0000ef          	jal	8ee <printf>
        exit(ERROR);
 232:	4505                	li	a0,1
 234:	2a8000ef          	jal	4dc <exit>
    else handle_child(first_fd);
 238:	8526                	mv	a0,s1
 23a:	e89ff0ef          	jal	c2 <handle_child>

000000000000023e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 23e:	1141                	addi	sp,sp,-16
 240:	e406                	sd	ra,8(sp)
 242:	e022                	sd	s0,0(sp)
 244:	0800                	addi	s0,sp,16
  extern int main();
  main();
 246:	fbdff0ef          	jal	202 <main>
  exit(0);
 24a:	4501                	li	a0,0
 24c:	290000ef          	jal	4dc <exit>

0000000000000250 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 250:	1141                	addi	sp,sp,-16
 252:	e406                	sd	ra,8(sp)
 254:	e022                	sd	s0,0(sp)
 256:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 258:	87aa                	mv	a5,a0
 25a:	0585                	addi	a1,a1,1
 25c:	0785                	addi	a5,a5,1
 25e:	fff5c703          	lbu	a4,-1(a1)
 262:	fee78fa3          	sb	a4,-1(a5)
 266:	fb75                	bnez	a4,25a <strcpy+0xa>
    ;
  return os;
}
 268:	60a2                	ld	ra,8(sp)
 26a:	6402                	ld	s0,0(sp)
 26c:	0141                	addi	sp,sp,16
 26e:	8082                	ret

0000000000000270 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 270:	1141                	addi	sp,sp,-16
 272:	e406                	sd	ra,8(sp)
 274:	e022                	sd	s0,0(sp)
 276:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 278:	00054783          	lbu	a5,0(a0)
 27c:	cb91                	beqz	a5,290 <strcmp+0x20>
 27e:	0005c703          	lbu	a4,0(a1)
 282:	00f71763          	bne	a4,a5,290 <strcmp+0x20>
    p++, q++;
 286:	0505                	addi	a0,a0,1
 288:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 28a:	00054783          	lbu	a5,0(a0)
 28e:	fbe5                	bnez	a5,27e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 290:	0005c503          	lbu	a0,0(a1)
}
 294:	40a7853b          	subw	a0,a5,a0
 298:	60a2                	ld	ra,8(sp)
 29a:	6402                	ld	s0,0(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret

00000000000002a0 <strlen>:

uint
strlen(const char *s)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e406                	sd	ra,8(sp)
 2a4:	e022                	sd	s0,0(sp)
 2a6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2a8:	00054783          	lbu	a5,0(a0)
 2ac:	cf99                	beqz	a5,2ca <strlen+0x2a>
 2ae:	0505                	addi	a0,a0,1
 2b0:	87aa                	mv	a5,a0
 2b2:	86be                	mv	a3,a5
 2b4:	0785                	addi	a5,a5,1
 2b6:	fff7c703          	lbu	a4,-1(a5)
 2ba:	ff65                	bnez	a4,2b2 <strlen+0x12>
 2bc:	40a6853b          	subw	a0,a3,a0
 2c0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2c2:	60a2                	ld	ra,8(sp)
 2c4:	6402                	ld	s0,0(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
  for(n = 0; s[n]; n++)
 2ca:	4501                	li	a0,0
 2cc:	bfdd                	j	2c2 <strlen+0x22>

00000000000002ce <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2d6:	ca19                	beqz	a2,2ec <memset+0x1e>
 2d8:	87aa                	mv	a5,a0
 2da:	1602                	slli	a2,a2,0x20
 2dc:	9201                	srli	a2,a2,0x20
 2de:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2e2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2e6:	0785                	addi	a5,a5,1
 2e8:	fee79de3          	bne	a5,a4,2e2 <memset+0x14>
  }
  return dst;
}
 2ec:	60a2                	ld	ra,8(sp)
 2ee:	6402                	ld	s0,0(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret

00000000000002f4 <strchr>:

char*
strchr(const char *s, char c)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e406                	sd	ra,8(sp)
 2f8:	e022                	sd	s0,0(sp)
 2fa:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2fc:	00054783          	lbu	a5,0(a0)
 300:	cf81                	beqz	a5,318 <strchr+0x24>
    if(*s == c)
 302:	00f58763          	beq	a1,a5,310 <strchr+0x1c>
  for(; *s; s++)
 306:	0505                	addi	a0,a0,1
 308:	00054783          	lbu	a5,0(a0)
 30c:	fbfd                	bnez	a5,302 <strchr+0xe>
      return (char*)s;
  return 0;
 30e:	4501                	li	a0,0
}
 310:	60a2                	ld	ra,8(sp)
 312:	6402                	ld	s0,0(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret
  return 0;
 318:	4501                	li	a0,0
 31a:	bfdd                	j	310 <strchr+0x1c>

000000000000031c <gets>:

char*
gets(char *buf, int max)
{
 31c:	7159                	addi	sp,sp,-112
 31e:	f486                	sd	ra,104(sp)
 320:	f0a2                	sd	s0,96(sp)
 322:	eca6                	sd	s1,88(sp)
 324:	e8ca                	sd	s2,80(sp)
 326:	e4ce                	sd	s3,72(sp)
 328:	e0d2                	sd	s4,64(sp)
 32a:	fc56                	sd	s5,56(sp)
 32c:	f85a                	sd	s6,48(sp)
 32e:	f45e                	sd	s7,40(sp)
 330:	f062                	sd	s8,32(sp)
 332:	ec66                	sd	s9,24(sp)
 334:	e86a                	sd	s10,16(sp)
 336:	1880                	addi	s0,sp,112
 338:	8caa                	mv	s9,a0
 33a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 33c:	892a                	mv	s2,a0
 33e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 340:	f9f40b13          	addi	s6,s0,-97
 344:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 346:	4ba9                	li	s7,10
 348:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 34a:	8d26                	mv	s10,s1
 34c:	0014899b          	addiw	s3,s1,1
 350:	84ce                	mv	s1,s3
 352:	0349d563          	bge	s3,s4,37c <gets+0x60>
    cc = read(0, &c, 1);
 356:	8656                	mv	a2,s5
 358:	85da                	mv	a1,s6
 35a:	4501                	li	a0,0
 35c:	198000ef          	jal	4f4 <read>
    if(cc < 1)
 360:	00a05e63          	blez	a0,37c <gets+0x60>
    buf[i++] = c;
 364:	f9f44783          	lbu	a5,-97(s0)
 368:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 36c:	01778763          	beq	a5,s7,37a <gets+0x5e>
 370:	0905                	addi	s2,s2,1
 372:	fd879ce3          	bne	a5,s8,34a <gets+0x2e>
    buf[i++] = c;
 376:	8d4e                	mv	s10,s3
 378:	a011                	j	37c <gets+0x60>
 37a:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 37c:	9d66                	add	s10,s10,s9
 37e:	000d0023          	sb	zero,0(s10)
  return buf;
}
 382:	8566                	mv	a0,s9
 384:	70a6                	ld	ra,104(sp)
 386:	7406                	ld	s0,96(sp)
 388:	64e6                	ld	s1,88(sp)
 38a:	6946                	ld	s2,80(sp)
 38c:	69a6                	ld	s3,72(sp)
 38e:	6a06                	ld	s4,64(sp)
 390:	7ae2                	ld	s5,56(sp)
 392:	7b42                	ld	s6,48(sp)
 394:	7ba2                	ld	s7,40(sp)
 396:	7c02                	ld	s8,32(sp)
 398:	6ce2                	ld	s9,24(sp)
 39a:	6d42                	ld	s10,16(sp)
 39c:	6165                	addi	sp,sp,112
 39e:	8082                	ret

00000000000003a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3a0:	1101                	addi	sp,sp,-32
 3a2:	ec06                	sd	ra,24(sp)
 3a4:	e822                	sd	s0,16(sp)
 3a6:	e04a                	sd	s2,0(sp)
 3a8:	1000                	addi	s0,sp,32
 3aa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ac:	4581                	li	a1,0
 3ae:	16e000ef          	jal	51c <open>
  if(fd < 0)
 3b2:	02054263          	bltz	a0,3d6 <stat+0x36>
 3b6:	e426                	sd	s1,8(sp)
 3b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3ba:	85ca                	mv	a1,s2
 3bc:	178000ef          	jal	534 <fstat>
 3c0:	892a                	mv	s2,a0
  close(fd);
 3c2:	8526                	mv	a0,s1
 3c4:	140000ef          	jal	504 <close>
  return r;
 3c8:	64a2                	ld	s1,8(sp)
}
 3ca:	854a                	mv	a0,s2
 3cc:	60e2                	ld	ra,24(sp)
 3ce:	6442                	ld	s0,16(sp)
 3d0:	6902                	ld	s2,0(sp)
 3d2:	6105                	addi	sp,sp,32
 3d4:	8082                	ret
    return -1;
 3d6:	597d                	li	s2,-1
 3d8:	bfcd                	j	3ca <stat+0x2a>

00000000000003da <atoi>:

int
atoi(const char *s)
{
 3da:	1141                	addi	sp,sp,-16
 3dc:	e406                	sd	ra,8(sp)
 3de:	e022                	sd	s0,0(sp)
 3e0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e2:	00054683          	lbu	a3,0(a0)
 3e6:	fd06879b          	addiw	a5,a3,-48
 3ea:	0ff7f793          	zext.b	a5,a5
 3ee:	4625                	li	a2,9
 3f0:	02f66963          	bltu	a2,a5,422 <atoi+0x48>
 3f4:	872a                	mv	a4,a0
  n = 0;
 3f6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3f8:	0705                	addi	a4,a4,1
 3fa:	0025179b          	slliw	a5,a0,0x2
 3fe:	9fa9                	addw	a5,a5,a0
 400:	0017979b          	slliw	a5,a5,0x1
 404:	9fb5                	addw	a5,a5,a3
 406:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 40a:	00074683          	lbu	a3,0(a4)
 40e:	fd06879b          	addiw	a5,a3,-48
 412:	0ff7f793          	zext.b	a5,a5
 416:	fef671e3          	bgeu	a2,a5,3f8 <atoi+0x1e>
  return n;
}
 41a:	60a2                	ld	ra,8(sp)
 41c:	6402                	ld	s0,0(sp)
 41e:	0141                	addi	sp,sp,16
 420:	8082                	ret
  n = 0;
 422:	4501                	li	a0,0
 424:	bfdd                	j	41a <atoi+0x40>

0000000000000426 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 426:	1141                	addi	sp,sp,-16
 428:	e406                	sd	ra,8(sp)
 42a:	e022                	sd	s0,0(sp)
 42c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 42e:	02b57563          	bgeu	a0,a1,458 <memmove+0x32>
    while(n-- > 0)
 432:	00c05f63          	blez	a2,450 <memmove+0x2a>
 436:	1602                	slli	a2,a2,0x20
 438:	9201                	srli	a2,a2,0x20
 43a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 43e:	872a                	mv	a4,a0
      *dst++ = *src++;
 440:	0585                	addi	a1,a1,1
 442:	0705                	addi	a4,a4,1
 444:	fff5c683          	lbu	a3,-1(a1)
 448:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 44c:	fee79ae3          	bne	a5,a4,440 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 450:	60a2                	ld	ra,8(sp)
 452:	6402                	ld	s0,0(sp)
 454:	0141                	addi	sp,sp,16
 456:	8082                	ret
    dst += n;
 458:	00c50733          	add	a4,a0,a2
    src += n;
 45c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 45e:	fec059e3          	blez	a2,450 <memmove+0x2a>
 462:	fff6079b          	addiw	a5,a2,-1
 466:	1782                	slli	a5,a5,0x20
 468:	9381                	srli	a5,a5,0x20
 46a:	fff7c793          	not	a5,a5
 46e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 470:	15fd                	addi	a1,a1,-1
 472:	177d                	addi	a4,a4,-1
 474:	0005c683          	lbu	a3,0(a1)
 478:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 47c:	fef71ae3          	bne	a4,a5,470 <memmove+0x4a>
 480:	bfc1                	j	450 <memmove+0x2a>

0000000000000482 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 482:	1141                	addi	sp,sp,-16
 484:	e406                	sd	ra,8(sp)
 486:	e022                	sd	s0,0(sp)
 488:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 48a:	ca0d                	beqz	a2,4bc <memcmp+0x3a>
 48c:	fff6069b          	addiw	a3,a2,-1
 490:	1682                	slli	a3,a3,0x20
 492:	9281                	srli	a3,a3,0x20
 494:	0685                	addi	a3,a3,1
 496:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 498:	00054783          	lbu	a5,0(a0)
 49c:	0005c703          	lbu	a4,0(a1)
 4a0:	00e79863          	bne	a5,a4,4b0 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 4a4:	0505                	addi	a0,a0,1
    p2++;
 4a6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4a8:	fed518e3          	bne	a0,a3,498 <memcmp+0x16>
  }
  return 0;
 4ac:	4501                	li	a0,0
 4ae:	a019                	j	4b4 <memcmp+0x32>
      return *p1 - *p2;
 4b0:	40e7853b          	subw	a0,a5,a4
}
 4b4:	60a2                	ld	ra,8(sp)
 4b6:	6402                	ld	s0,0(sp)
 4b8:	0141                	addi	sp,sp,16
 4ba:	8082                	ret
  return 0;
 4bc:	4501                	li	a0,0
 4be:	bfdd                	j	4b4 <memcmp+0x32>

00000000000004c0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4c0:	1141                	addi	sp,sp,-16
 4c2:	e406                	sd	ra,8(sp)
 4c4:	e022                	sd	s0,0(sp)
 4c6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4c8:	f5fff0ef          	jal	426 <memmove>
}
 4cc:	60a2                	ld	ra,8(sp)
 4ce:	6402                	ld	s0,0(sp)
 4d0:	0141                	addi	sp,sp,16
 4d2:	8082                	ret

00000000000004d4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4d4:	4885                	li	a7,1
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <exit>:
.global exit
exit:
 li a7, SYS_exit
 4dc:	4889                	li	a7,2
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4e4:	488d                	li	a7,3
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4ec:	4891                	li	a7,4
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <read>:
.global read
read:
 li a7, SYS_read
 4f4:	4895                	li	a7,5
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <write>:
.global write
write:
 li a7, SYS_write
 4fc:	48c1                	li	a7,16
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <close>:
.global close
close:
 li a7, SYS_close
 504:	48d5                	li	a7,21
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <kill>:
.global kill
kill:
 li a7, SYS_kill
 50c:	4899                	li	a7,6
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <exec>:
.global exec
exec:
 li a7, SYS_exec
 514:	489d                	li	a7,7
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <open>:
.global open
open:
 li a7, SYS_open
 51c:	48bd                	li	a7,15
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 524:	48c5                	li	a7,17
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 52c:	48c9                	li	a7,18
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 534:	48a1                	li	a7,8
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <link>:
.global link
link:
 li a7, SYS_link
 53c:	48cd                	li	a7,19
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 544:	48d1                	li	a7,20
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 54c:	48a5                	li	a7,9
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <dup>:
.global dup
dup:
 li a7, SYS_dup
 554:	48a9                	li	a7,10
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 55c:	48ad                	li	a7,11
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 564:	48b1                	li	a7,12
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 56c:	48b5                	li	a7,13
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 574:	48b9                	li	a7,14
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <trace>:
.global trace
trace:
 li a7, SYS_trace
 57c:	48d9                	li	a7,22
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 584:	48dd                	li	a7,23
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 58c:	1101                	addi	sp,sp,-32
 58e:	ec06                	sd	ra,24(sp)
 590:	e822                	sd	s0,16(sp)
 592:	1000                	addi	s0,sp,32
 594:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 598:	4605                	li	a2,1
 59a:	fef40593          	addi	a1,s0,-17
 59e:	f5fff0ef          	jal	4fc <write>
}
 5a2:	60e2                	ld	ra,24(sp)
 5a4:	6442                	ld	s0,16(sp)
 5a6:	6105                	addi	sp,sp,32
 5a8:	8082                	ret

00000000000005aa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5aa:	7139                	addi	sp,sp,-64
 5ac:	fc06                	sd	ra,56(sp)
 5ae:	f822                	sd	s0,48(sp)
 5b0:	f426                	sd	s1,40(sp)
 5b2:	f04a                	sd	s2,32(sp)
 5b4:	ec4e                	sd	s3,24(sp)
 5b6:	0080                	addi	s0,sp,64
 5b8:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5ba:	c299                	beqz	a3,5c0 <printint+0x16>
 5bc:	0605ce63          	bltz	a1,638 <printint+0x8e>
  neg = 0;
 5c0:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 5c2:	fc040313          	addi	t1,s0,-64
  neg = 0;
 5c6:	869a                	mv	a3,t1
  i = 0;
 5c8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 5ca:	00000817          	auipc	a6,0x0
 5ce:	54680813          	addi	a6,a6,1350 # b10 <digits>
 5d2:	88be                	mv	a7,a5
 5d4:	0017851b          	addiw	a0,a5,1
 5d8:	87aa                	mv	a5,a0
 5da:	02c5f73b          	remuw	a4,a1,a2
 5de:	1702                	slli	a4,a4,0x20
 5e0:	9301                	srli	a4,a4,0x20
 5e2:	9742                	add	a4,a4,a6
 5e4:	00074703          	lbu	a4,0(a4)
 5e8:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 5ec:	872e                	mv	a4,a1
 5ee:	02c5d5bb          	divuw	a1,a1,a2
 5f2:	0685                	addi	a3,a3,1
 5f4:	fcc77fe3          	bgeu	a4,a2,5d2 <printint+0x28>
  if(neg)
 5f8:	000e0c63          	beqz	t3,610 <printint+0x66>
    buf[i++] = '-';
 5fc:	fd050793          	addi	a5,a0,-48
 600:	00878533          	add	a0,a5,s0
 604:	02d00793          	li	a5,45
 608:	fef50823          	sb	a5,-16(a0)
 60c:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 610:	fff7899b          	addiw	s3,a5,-1
 614:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 618:	fff4c583          	lbu	a1,-1(s1)
 61c:	854a                	mv	a0,s2
 61e:	f6fff0ef          	jal	58c <putc>
  while(--i >= 0)
 622:	39fd                	addiw	s3,s3,-1
 624:	14fd                	addi	s1,s1,-1
 626:	fe09d9e3          	bgez	s3,618 <printint+0x6e>
}
 62a:	70e2                	ld	ra,56(sp)
 62c:	7442                	ld	s0,48(sp)
 62e:	74a2                	ld	s1,40(sp)
 630:	7902                	ld	s2,32(sp)
 632:	69e2                	ld	s3,24(sp)
 634:	6121                	addi	sp,sp,64
 636:	8082                	ret
    x = -xx;
 638:	40b005bb          	negw	a1,a1
    neg = 1;
 63c:	4e05                	li	t3,1
    x = -xx;
 63e:	b751                	j	5c2 <printint+0x18>

0000000000000640 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 640:	711d                	addi	sp,sp,-96
 642:	ec86                	sd	ra,88(sp)
 644:	e8a2                	sd	s0,80(sp)
 646:	e4a6                	sd	s1,72(sp)
 648:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 64a:	0005c483          	lbu	s1,0(a1)
 64e:	26048663          	beqz	s1,8ba <vprintf+0x27a>
 652:	e0ca                	sd	s2,64(sp)
 654:	fc4e                	sd	s3,56(sp)
 656:	f852                	sd	s4,48(sp)
 658:	f456                	sd	s5,40(sp)
 65a:	f05a                	sd	s6,32(sp)
 65c:	ec5e                	sd	s7,24(sp)
 65e:	e862                	sd	s8,16(sp)
 660:	e466                	sd	s9,8(sp)
 662:	8b2a                	mv	s6,a0
 664:	8a2e                	mv	s4,a1
 666:	8bb2                	mv	s7,a2
  state = 0;
 668:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 66a:	4901                	li	s2,0
 66c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 66e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 672:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 676:	06c00c93          	li	s9,108
 67a:	a00d                	j	69c <vprintf+0x5c>
        putc(fd, c0);
 67c:	85a6                	mv	a1,s1
 67e:	855a                	mv	a0,s6
 680:	f0dff0ef          	jal	58c <putc>
 684:	a019                	j	68a <vprintf+0x4a>
    } else if(state == '%'){
 686:	03598363          	beq	s3,s5,6ac <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 68a:	0019079b          	addiw	a5,s2,1
 68e:	893e                	mv	s2,a5
 690:	873e                	mv	a4,a5
 692:	97d2                	add	a5,a5,s4
 694:	0007c483          	lbu	s1,0(a5)
 698:	20048963          	beqz	s1,8aa <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 69c:	0004879b          	sext.w	a5,s1
    if(state == 0){
 6a0:	fe0993e3          	bnez	s3,686 <vprintf+0x46>
      if(c0 == '%'){
 6a4:	fd579ce3          	bne	a5,s5,67c <vprintf+0x3c>
        state = '%';
 6a8:	89be                	mv	s3,a5
 6aa:	b7c5                	j	68a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6ac:	00ea06b3          	add	a3,s4,a4
 6b0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6b4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6b6:	c681                	beqz	a3,6be <vprintf+0x7e>
 6b8:	9752                	add	a4,a4,s4
 6ba:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6be:	03878e63          	beq	a5,s8,6fa <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 6c2:	05978863          	beq	a5,s9,712 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6c6:	07500713          	li	a4,117
 6ca:	0ee78263          	beq	a5,a4,7ae <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6ce:	07800713          	li	a4,120
 6d2:	12e78463          	beq	a5,a4,7fa <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6d6:	07000713          	li	a4,112
 6da:	14e78963          	beq	a5,a4,82c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6de:	07300713          	li	a4,115
 6e2:	18e78863          	beq	a5,a4,872 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6e6:	02500713          	li	a4,37
 6ea:	04e79463          	bne	a5,a4,732 <vprintf+0xf2>
        putc(fd, '%');
 6ee:	85ba                	mv	a1,a4
 6f0:	855a                	mv	a0,s6
 6f2:	e9bff0ef          	jal	58c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	bf49                	j	68a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6fa:	008b8493          	addi	s1,s7,8
 6fe:	4685                	li	a3,1
 700:	4629                	li	a2,10
 702:	000ba583          	lw	a1,0(s7)
 706:	855a                	mv	a0,s6
 708:	ea3ff0ef          	jal	5aa <printint>
 70c:	8ba6                	mv	s7,s1
      state = 0;
 70e:	4981                	li	s3,0
 710:	bfad                	j	68a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 712:	06400793          	li	a5,100
 716:	02f68963          	beq	a3,a5,748 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 71a:	06c00793          	li	a5,108
 71e:	04f68263          	beq	a3,a5,762 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 722:	07500793          	li	a5,117
 726:	0af68063          	beq	a3,a5,7c6 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 72a:	07800793          	li	a5,120
 72e:	0ef68263          	beq	a3,a5,812 <vprintf+0x1d2>
        putc(fd, '%');
 732:	02500593          	li	a1,37
 736:	855a                	mv	a0,s6
 738:	e55ff0ef          	jal	58c <putc>
        putc(fd, c0);
 73c:	85a6                	mv	a1,s1
 73e:	855a                	mv	a0,s6
 740:	e4dff0ef          	jal	58c <putc>
      state = 0;
 744:	4981                	li	s3,0
 746:	b791                	j	68a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 748:	008b8493          	addi	s1,s7,8
 74c:	4685                	li	a3,1
 74e:	4629                	li	a2,10
 750:	000ba583          	lw	a1,0(s7)
 754:	855a                	mv	a0,s6
 756:	e55ff0ef          	jal	5aa <printint>
        i += 1;
 75a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 75c:	8ba6                	mv	s7,s1
      state = 0;
 75e:	4981                	li	s3,0
        i += 1;
 760:	b72d                	j	68a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 762:	06400793          	li	a5,100
 766:	02f60763          	beq	a2,a5,794 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 76a:	07500793          	li	a5,117
 76e:	06f60963          	beq	a2,a5,7e0 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 772:	07800793          	li	a5,120
 776:	faf61ee3          	bne	a2,a5,732 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 77a:	008b8493          	addi	s1,s7,8
 77e:	4681                	li	a3,0
 780:	4641                	li	a2,16
 782:	000ba583          	lw	a1,0(s7)
 786:	855a                	mv	a0,s6
 788:	e23ff0ef          	jal	5aa <printint>
        i += 2;
 78c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 78e:	8ba6                	mv	s7,s1
      state = 0;
 790:	4981                	li	s3,0
        i += 2;
 792:	bde5                	j	68a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 794:	008b8493          	addi	s1,s7,8
 798:	4685                	li	a3,1
 79a:	4629                	li	a2,10
 79c:	000ba583          	lw	a1,0(s7)
 7a0:	855a                	mv	a0,s6
 7a2:	e09ff0ef          	jal	5aa <printint>
        i += 2;
 7a6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7a8:	8ba6                	mv	s7,s1
      state = 0;
 7aa:	4981                	li	s3,0
        i += 2;
 7ac:	bdf9                	j	68a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7ae:	008b8493          	addi	s1,s7,8
 7b2:	4681                	li	a3,0
 7b4:	4629                	li	a2,10
 7b6:	000ba583          	lw	a1,0(s7)
 7ba:	855a                	mv	a0,s6
 7bc:	defff0ef          	jal	5aa <printint>
 7c0:	8ba6                	mv	s7,s1
      state = 0;
 7c2:	4981                	li	s3,0
 7c4:	b5d9                	j	68a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c6:	008b8493          	addi	s1,s7,8
 7ca:	4681                	li	a3,0
 7cc:	4629                	li	a2,10
 7ce:	000ba583          	lw	a1,0(s7)
 7d2:	855a                	mv	a0,s6
 7d4:	dd7ff0ef          	jal	5aa <printint>
        i += 1;
 7d8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7da:	8ba6                	mv	s7,s1
      state = 0;
 7dc:	4981                	li	s3,0
        i += 1;
 7de:	b575                	j	68a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e0:	008b8493          	addi	s1,s7,8
 7e4:	4681                	li	a3,0
 7e6:	4629                	li	a2,10
 7e8:	000ba583          	lw	a1,0(s7)
 7ec:	855a                	mv	a0,s6
 7ee:	dbdff0ef          	jal	5aa <printint>
        i += 2;
 7f2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f4:	8ba6                	mv	s7,s1
      state = 0;
 7f6:	4981                	li	s3,0
        i += 2;
 7f8:	bd49                	j	68a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7fa:	008b8493          	addi	s1,s7,8
 7fe:	4681                	li	a3,0
 800:	4641                	li	a2,16
 802:	000ba583          	lw	a1,0(s7)
 806:	855a                	mv	a0,s6
 808:	da3ff0ef          	jal	5aa <printint>
 80c:	8ba6                	mv	s7,s1
      state = 0;
 80e:	4981                	li	s3,0
 810:	bdad                	j	68a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 812:	008b8493          	addi	s1,s7,8
 816:	4681                	li	a3,0
 818:	4641                	li	a2,16
 81a:	000ba583          	lw	a1,0(s7)
 81e:	855a                	mv	a0,s6
 820:	d8bff0ef          	jal	5aa <printint>
        i += 1;
 824:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 826:	8ba6                	mv	s7,s1
      state = 0;
 828:	4981                	li	s3,0
        i += 1;
 82a:	b585                	j	68a <vprintf+0x4a>
 82c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 82e:	008b8d13          	addi	s10,s7,8
 832:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 836:	03000593          	li	a1,48
 83a:	855a                	mv	a0,s6
 83c:	d51ff0ef          	jal	58c <putc>
  putc(fd, 'x');
 840:	07800593          	li	a1,120
 844:	855a                	mv	a0,s6
 846:	d47ff0ef          	jal	58c <putc>
 84a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 84c:	00000b97          	auipc	s7,0x0
 850:	2c4b8b93          	addi	s7,s7,708 # b10 <digits>
 854:	03c9d793          	srli	a5,s3,0x3c
 858:	97de                	add	a5,a5,s7
 85a:	0007c583          	lbu	a1,0(a5)
 85e:	855a                	mv	a0,s6
 860:	d2dff0ef          	jal	58c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 864:	0992                	slli	s3,s3,0x4
 866:	34fd                	addiw	s1,s1,-1
 868:	f4f5                	bnez	s1,854 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 86a:	8bea                	mv	s7,s10
      state = 0;
 86c:	4981                	li	s3,0
 86e:	6d02                	ld	s10,0(sp)
 870:	bd29                	j	68a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 872:	008b8993          	addi	s3,s7,8
 876:	000bb483          	ld	s1,0(s7)
 87a:	cc91                	beqz	s1,896 <vprintf+0x256>
        for(; *s; s++)
 87c:	0004c583          	lbu	a1,0(s1)
 880:	c195                	beqz	a1,8a4 <vprintf+0x264>
          putc(fd, *s);
 882:	855a                	mv	a0,s6
 884:	d09ff0ef          	jal	58c <putc>
        for(; *s; s++)
 888:	0485                	addi	s1,s1,1
 88a:	0004c583          	lbu	a1,0(s1)
 88e:	f9f5                	bnez	a1,882 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 890:	8bce                	mv	s7,s3
      state = 0;
 892:	4981                	li	s3,0
 894:	bbdd                	j	68a <vprintf+0x4a>
          s = "(null)";
 896:	00000497          	auipc	s1,0x0
 89a:	27248493          	addi	s1,s1,626 # b08 <malloc+0x162>
        for(; *s; s++)
 89e:	02800593          	li	a1,40
 8a2:	b7c5                	j	882 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 8a4:	8bce                	mv	s7,s3
      state = 0;
 8a6:	4981                	li	s3,0
 8a8:	b3cd                	j	68a <vprintf+0x4a>
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
 8e2:	d5fff0ef          	jal	640 <vprintf>
}
 8e6:	60e2                	ld	ra,24(sp)
 8e8:	6442                	ld	s0,16(sp)
 8ea:	6161                	addi	sp,sp,80
 8ec:	8082                	ret

00000000000008ee <printf>:

void
printf(const char *fmt, ...)
{
 8ee:	711d                	addi	sp,sp,-96
 8f0:	ec06                	sd	ra,24(sp)
 8f2:	e822                	sd	s0,16(sp)
 8f4:	1000                	addi	s0,sp,32
 8f6:	e40c                	sd	a1,8(s0)
 8f8:	e810                	sd	a2,16(s0)
 8fa:	ec14                	sd	a3,24(s0)
 8fc:	f018                	sd	a4,32(s0)
 8fe:	f41c                	sd	a5,40(s0)
 900:	03043823          	sd	a6,48(s0)
 904:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 908:	00840613          	addi	a2,s0,8
 90c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 910:	85aa                	mv	a1,a0
 912:	4505                	li	a0,1
 914:	d2dff0ef          	jal	640 <vprintf>
}
 918:	60e2                	ld	ra,24(sp)
 91a:	6442                	ld	s0,16(sp)
 91c:	6125                	addi	sp,sp,96
 91e:	8082                	ret

0000000000000920 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 920:	1141                	addi	sp,sp,-16
 922:	e406                	sd	ra,8(sp)
 924:	e022                	sd	s0,0(sp)
 926:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 928:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 92c:	00000797          	auipc	a5,0x0
 930:	6d47b783          	ld	a5,1748(a5) # 1000 <freep>
 934:	a02d                	j	95e <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 936:	4618                	lw	a4,8(a2)
 938:	9f2d                	addw	a4,a4,a1
 93a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 93e:	6398                	ld	a4,0(a5)
 940:	6310                	ld	a2,0(a4)
 942:	a83d                	j	980 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 944:	ff852703          	lw	a4,-8(a0)
 948:	9f31                	addw	a4,a4,a2
 94a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 94c:	ff053683          	ld	a3,-16(a0)
 950:	a091                	j	994 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 952:	6398                	ld	a4,0(a5)
 954:	00e7e463          	bltu	a5,a4,95c <free+0x3c>
 958:	00e6ea63          	bltu	a3,a4,96c <free+0x4c>
{
 95c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 95e:	fed7fae3          	bgeu	a5,a3,952 <free+0x32>
 962:	6398                	ld	a4,0(a5)
 964:	00e6e463          	bltu	a3,a4,96c <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 968:	fee7eae3          	bltu	a5,a4,95c <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 96c:	ff852583          	lw	a1,-8(a0)
 970:	6390                	ld	a2,0(a5)
 972:	02059813          	slli	a6,a1,0x20
 976:	01c85713          	srli	a4,a6,0x1c
 97a:	9736                	add	a4,a4,a3
 97c:	fae60de3          	beq	a2,a4,936 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 980:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 984:	4790                	lw	a2,8(a5)
 986:	02061593          	slli	a1,a2,0x20
 98a:	01c5d713          	srli	a4,a1,0x1c
 98e:	973e                	add	a4,a4,a5
 990:	fae68ae3          	beq	a3,a4,944 <free+0x24>
    p->s.ptr = bp->s.ptr;
 994:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 996:	00000717          	auipc	a4,0x0
 99a:	66f73523          	sd	a5,1642(a4) # 1000 <freep>
}
 99e:	60a2                	ld	ra,8(sp)
 9a0:	6402                	ld	s0,0(sp)
 9a2:	0141                	addi	sp,sp,16
 9a4:	8082                	ret

00000000000009a6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9a6:	7139                	addi	sp,sp,-64
 9a8:	fc06                	sd	ra,56(sp)
 9aa:	f822                	sd	s0,48(sp)
 9ac:	f04a                	sd	s2,32(sp)
 9ae:	ec4e                	sd	s3,24(sp)
 9b0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9b2:	02051993          	slli	s3,a0,0x20
 9b6:	0209d993          	srli	s3,s3,0x20
 9ba:	09bd                	addi	s3,s3,15
 9bc:	0049d993          	srli	s3,s3,0x4
 9c0:	2985                	addiw	s3,s3,1
 9c2:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 9c4:	00000517          	auipc	a0,0x0
 9c8:	63c53503          	ld	a0,1596(a0) # 1000 <freep>
 9cc:	c905                	beqz	a0,9fc <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d0:	4798                	lw	a4,8(a5)
 9d2:	09377663          	bgeu	a4,s3,a5e <malloc+0xb8>
 9d6:	f426                	sd	s1,40(sp)
 9d8:	e852                	sd	s4,16(sp)
 9da:	e456                	sd	s5,8(sp)
 9dc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9de:	8a4e                	mv	s4,s3
 9e0:	6705                	lui	a4,0x1
 9e2:	00e9f363          	bgeu	s3,a4,9e8 <malloc+0x42>
 9e6:	6a05                	lui	s4,0x1
 9e8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9ec:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9f0:	00000497          	auipc	s1,0x0
 9f4:	61048493          	addi	s1,s1,1552 # 1000 <freep>
  if(p == (char*)-1)
 9f8:	5afd                	li	s5,-1
 9fa:	a83d                	j	a38 <malloc+0x92>
 9fc:	f426                	sd	s1,40(sp)
 9fe:	e852                	sd	s4,16(sp)
 a00:	e456                	sd	s5,8(sp)
 a02:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a04:	00000797          	auipc	a5,0x0
 a08:	60c78793          	addi	a5,a5,1548 # 1010 <base>
 a0c:	00000717          	auipc	a4,0x0
 a10:	5ef73a23          	sd	a5,1524(a4) # 1000 <freep>
 a14:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a16:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a1a:	b7d1                	j	9de <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a1c:	6398                	ld	a4,0(a5)
 a1e:	e118                	sd	a4,0(a0)
 a20:	a899                	j	a76 <malloc+0xd0>
  hp->s.size = nu;
 a22:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a26:	0541                	addi	a0,a0,16
 a28:	ef9ff0ef          	jal	920 <free>
  return freep;
 a2c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a2e:	c125                	beqz	a0,a8e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a30:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a32:	4798                	lw	a4,8(a5)
 a34:	03277163          	bgeu	a4,s2,a56 <malloc+0xb0>
    if(p == freep)
 a38:	6098                	ld	a4,0(s1)
 a3a:	853e                	mv	a0,a5
 a3c:	fef71ae3          	bne	a4,a5,a30 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a40:	8552                	mv	a0,s4
 a42:	b23ff0ef          	jal	564 <sbrk>
  if(p == (char*)-1)
 a46:	fd551ee3          	bne	a0,s5,a22 <malloc+0x7c>
        return 0;
 a4a:	4501                	li	a0,0
 a4c:	74a2                	ld	s1,40(sp)
 a4e:	6a42                	ld	s4,16(sp)
 a50:	6aa2                	ld	s5,8(sp)
 a52:	6b02                	ld	s6,0(sp)
 a54:	a03d                	j	a82 <malloc+0xdc>
 a56:	74a2                	ld	s1,40(sp)
 a58:	6a42                	ld	s4,16(sp)
 a5a:	6aa2                	ld	s5,8(sp)
 a5c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a5e:	fae90fe3          	beq	s2,a4,a1c <malloc+0x76>
        p->s.size -= nunits;
 a62:	4137073b          	subw	a4,a4,s3
 a66:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a68:	02071693          	slli	a3,a4,0x20
 a6c:	01c6d713          	srli	a4,a3,0x1c
 a70:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a72:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a76:	00000717          	auipc	a4,0x0
 a7a:	58a73523          	sd	a0,1418(a4) # 1000 <freep>
      return (void*)(p + 1);
 a7e:	01078513          	addi	a0,a5,16
  }
}
 a82:	70e2                	ld	ra,56(sp)
 a84:	7442                	ld	s0,48(sp)
 a86:	7902                	ld	s2,32(sp)
 a88:	69e2                	ld	s3,24(sp)
 a8a:	6121                	addi	sp,sp,64
 a8c:	8082                	ret
 a8e:	74a2                	ld	s1,40(sp)
 a90:	6a42                	ld	s4,16(sp)
 a92:	6aa2                	ld	s5,8(sp)
 a94:	6b02                	ld	s6,0(sp)
 a96:	b7f5                	j	a82 <malloc+0xdc>
