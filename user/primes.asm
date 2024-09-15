
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
   c:	18b000ef          	jal	996 <malloc>
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
  28:	a6c50513          	addi	a0,a0,-1428 # a90 <malloc+0xfa>
  2c:	0b3000ef          	jal	8de <printf>
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
  b8:	059000ef          	jal	910 <free>
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
 106:	9ce50513          	addi	a0,a0,-1586 # ad0 <malloc+0x13a>
 10a:	7d4000ef          	jal	8de <printf>
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
 12c:	98850513          	addi	a0,a0,-1656 # ab0 <malloc+0x11a>
 130:	7ae000ef          	jal	8de <printf>
        exit(ERROR);
 134:	4505                	li	a0,1
 136:	3a6000ef          	jal	4dc <exit>
            printf("Error reading received bytes\n");
 13a:	00001517          	auipc	a0,0x1
 13e:	97650513          	addi	a0,a0,-1674 # ab0 <malloc+0x11a>
 142:	79c000ef          	jal	8de <printf>
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
 1b2:	93250513          	addi	a0,a0,-1742 # ae0 <malloc+0x14a>
 1b6:	728000ef          	jal	8de <printf>
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
 1ea:	726000ef          	jal	910 <free>
    }

    // CLose the reading hand of the parent's pipe.
    close(parent_fd[PIPE_READ]);
 1ee:	0009a503          	lw	a0,0(s3)
 1f2:	312000ef          	jal	504 <close>
    free(parent_fd);
 1f6:	854e                	mv	a0,s3
 1f8:	718000ef          	jal	910 <free>
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
 22a:	8ba50513          	addi	a0,a0,-1862 # ae0 <malloc+0x14a>
 22e:	6b0000ef          	jal	8de <printf>
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

000000000000057c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 57c:	1101                	addi	sp,sp,-32
 57e:	ec06                	sd	ra,24(sp)
 580:	e822                	sd	s0,16(sp)
 582:	1000                	addi	s0,sp,32
 584:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 588:	4605                	li	a2,1
 58a:	fef40593          	addi	a1,s0,-17
 58e:	f6fff0ef          	jal	4fc <write>
}
 592:	60e2                	ld	ra,24(sp)
 594:	6442                	ld	s0,16(sp)
 596:	6105                	addi	sp,sp,32
 598:	8082                	ret

000000000000059a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 59a:	7139                	addi	sp,sp,-64
 59c:	fc06                	sd	ra,56(sp)
 59e:	f822                	sd	s0,48(sp)
 5a0:	f426                	sd	s1,40(sp)
 5a2:	f04a                	sd	s2,32(sp)
 5a4:	ec4e                	sd	s3,24(sp)
 5a6:	0080                	addi	s0,sp,64
 5a8:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5aa:	c299                	beqz	a3,5b0 <printint+0x16>
 5ac:	0605ce63          	bltz	a1,628 <printint+0x8e>
  neg = 0;
 5b0:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 5b2:	fc040313          	addi	t1,s0,-64
  neg = 0;
 5b6:	869a                	mv	a3,t1
  i = 0;
 5b8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 5ba:	00000817          	auipc	a6,0x0
 5be:	54680813          	addi	a6,a6,1350 # b00 <digits>
 5c2:	88be                	mv	a7,a5
 5c4:	0017851b          	addiw	a0,a5,1
 5c8:	87aa                	mv	a5,a0
 5ca:	02c5f73b          	remuw	a4,a1,a2
 5ce:	1702                	slli	a4,a4,0x20
 5d0:	9301                	srli	a4,a4,0x20
 5d2:	9742                	add	a4,a4,a6
 5d4:	00074703          	lbu	a4,0(a4)
 5d8:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 5dc:	872e                	mv	a4,a1
 5de:	02c5d5bb          	divuw	a1,a1,a2
 5e2:	0685                	addi	a3,a3,1
 5e4:	fcc77fe3          	bgeu	a4,a2,5c2 <printint+0x28>
  if(neg)
 5e8:	000e0c63          	beqz	t3,600 <printint+0x66>
    buf[i++] = '-';
 5ec:	fd050793          	addi	a5,a0,-48
 5f0:	00878533          	add	a0,a5,s0
 5f4:	02d00793          	li	a5,45
 5f8:	fef50823          	sb	a5,-16(a0)
 5fc:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 600:	fff7899b          	addiw	s3,a5,-1
 604:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 608:	fff4c583          	lbu	a1,-1(s1)
 60c:	854a                	mv	a0,s2
 60e:	f6fff0ef          	jal	57c <putc>
  while(--i >= 0)
 612:	39fd                	addiw	s3,s3,-1
 614:	14fd                	addi	s1,s1,-1
 616:	fe09d9e3          	bgez	s3,608 <printint+0x6e>
}
 61a:	70e2                	ld	ra,56(sp)
 61c:	7442                	ld	s0,48(sp)
 61e:	74a2                	ld	s1,40(sp)
 620:	7902                	ld	s2,32(sp)
 622:	69e2                	ld	s3,24(sp)
 624:	6121                	addi	sp,sp,64
 626:	8082                	ret
    x = -xx;
 628:	40b005bb          	negw	a1,a1
    neg = 1;
 62c:	4e05                	li	t3,1
    x = -xx;
 62e:	b751                	j	5b2 <printint+0x18>

0000000000000630 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 630:	711d                	addi	sp,sp,-96
 632:	ec86                	sd	ra,88(sp)
 634:	e8a2                	sd	s0,80(sp)
 636:	e4a6                	sd	s1,72(sp)
 638:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 63a:	0005c483          	lbu	s1,0(a1)
 63e:	26048663          	beqz	s1,8aa <vprintf+0x27a>
 642:	e0ca                	sd	s2,64(sp)
 644:	fc4e                	sd	s3,56(sp)
 646:	f852                	sd	s4,48(sp)
 648:	f456                	sd	s5,40(sp)
 64a:	f05a                	sd	s6,32(sp)
 64c:	ec5e                	sd	s7,24(sp)
 64e:	e862                	sd	s8,16(sp)
 650:	e466                	sd	s9,8(sp)
 652:	8b2a                	mv	s6,a0
 654:	8a2e                	mv	s4,a1
 656:	8bb2                	mv	s7,a2
  state = 0;
 658:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 65a:	4901                	li	s2,0
 65c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 65e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 662:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 666:	06c00c93          	li	s9,108
 66a:	a00d                	j	68c <vprintf+0x5c>
        putc(fd, c0);
 66c:	85a6                	mv	a1,s1
 66e:	855a                	mv	a0,s6
 670:	f0dff0ef          	jal	57c <putc>
 674:	a019                	j	67a <vprintf+0x4a>
    } else if(state == '%'){
 676:	03598363          	beq	s3,s5,69c <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 67a:	0019079b          	addiw	a5,s2,1
 67e:	893e                	mv	s2,a5
 680:	873e                	mv	a4,a5
 682:	97d2                	add	a5,a5,s4
 684:	0007c483          	lbu	s1,0(a5)
 688:	20048963          	beqz	s1,89a <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 68c:	0004879b          	sext.w	a5,s1
    if(state == 0){
 690:	fe0993e3          	bnez	s3,676 <vprintf+0x46>
      if(c0 == '%'){
 694:	fd579ce3          	bne	a5,s5,66c <vprintf+0x3c>
        state = '%';
 698:	89be                	mv	s3,a5
 69a:	b7c5                	j	67a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 69c:	00ea06b3          	add	a3,s4,a4
 6a0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6a4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6a6:	c681                	beqz	a3,6ae <vprintf+0x7e>
 6a8:	9752                	add	a4,a4,s4
 6aa:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6ae:	03878e63          	beq	a5,s8,6ea <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 6b2:	05978863          	beq	a5,s9,702 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6b6:	07500713          	li	a4,117
 6ba:	0ee78263          	beq	a5,a4,79e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6be:	07800713          	li	a4,120
 6c2:	12e78463          	beq	a5,a4,7ea <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6c6:	07000713          	li	a4,112
 6ca:	14e78963          	beq	a5,a4,81c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6ce:	07300713          	li	a4,115
 6d2:	18e78863          	beq	a5,a4,862 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6d6:	02500713          	li	a4,37
 6da:	04e79463          	bne	a5,a4,722 <vprintf+0xf2>
        putc(fd, '%');
 6de:	85ba                	mv	a1,a4
 6e0:	855a                	mv	a0,s6
 6e2:	e9bff0ef          	jal	57c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	bf49                	j	67a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6ea:	008b8493          	addi	s1,s7,8
 6ee:	4685                	li	a3,1
 6f0:	4629                	li	a2,10
 6f2:	000ba583          	lw	a1,0(s7)
 6f6:	855a                	mv	a0,s6
 6f8:	ea3ff0ef          	jal	59a <printint>
 6fc:	8ba6                	mv	s7,s1
      state = 0;
 6fe:	4981                	li	s3,0
 700:	bfad                	j	67a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 702:	06400793          	li	a5,100
 706:	02f68963          	beq	a3,a5,738 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 70a:	06c00793          	li	a5,108
 70e:	04f68263          	beq	a3,a5,752 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 712:	07500793          	li	a5,117
 716:	0af68063          	beq	a3,a5,7b6 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 71a:	07800793          	li	a5,120
 71e:	0ef68263          	beq	a3,a5,802 <vprintf+0x1d2>
        putc(fd, '%');
 722:	02500593          	li	a1,37
 726:	855a                	mv	a0,s6
 728:	e55ff0ef          	jal	57c <putc>
        putc(fd, c0);
 72c:	85a6                	mv	a1,s1
 72e:	855a                	mv	a0,s6
 730:	e4dff0ef          	jal	57c <putc>
      state = 0;
 734:	4981                	li	s3,0
 736:	b791                	j	67a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 738:	008b8493          	addi	s1,s7,8
 73c:	4685                	li	a3,1
 73e:	4629                	li	a2,10
 740:	000ba583          	lw	a1,0(s7)
 744:	855a                	mv	a0,s6
 746:	e55ff0ef          	jal	59a <printint>
        i += 1;
 74a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 74c:	8ba6                	mv	s7,s1
      state = 0;
 74e:	4981                	li	s3,0
        i += 1;
 750:	b72d                	j	67a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 752:	06400793          	li	a5,100
 756:	02f60763          	beq	a2,a5,784 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 75a:	07500793          	li	a5,117
 75e:	06f60963          	beq	a2,a5,7d0 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 762:	07800793          	li	a5,120
 766:	faf61ee3          	bne	a2,a5,722 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 76a:	008b8493          	addi	s1,s7,8
 76e:	4681                	li	a3,0
 770:	4641                	li	a2,16
 772:	000ba583          	lw	a1,0(s7)
 776:	855a                	mv	a0,s6
 778:	e23ff0ef          	jal	59a <printint>
        i += 2;
 77c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 77e:	8ba6                	mv	s7,s1
      state = 0;
 780:	4981                	li	s3,0
        i += 2;
 782:	bde5                	j	67a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 784:	008b8493          	addi	s1,s7,8
 788:	4685                	li	a3,1
 78a:	4629                	li	a2,10
 78c:	000ba583          	lw	a1,0(s7)
 790:	855a                	mv	a0,s6
 792:	e09ff0ef          	jal	59a <printint>
        i += 2;
 796:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 798:	8ba6                	mv	s7,s1
      state = 0;
 79a:	4981                	li	s3,0
        i += 2;
 79c:	bdf9                	j	67a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 79e:	008b8493          	addi	s1,s7,8
 7a2:	4681                	li	a3,0
 7a4:	4629                	li	a2,10
 7a6:	000ba583          	lw	a1,0(s7)
 7aa:	855a                	mv	a0,s6
 7ac:	defff0ef          	jal	59a <printint>
 7b0:	8ba6                	mv	s7,s1
      state = 0;
 7b2:	4981                	li	s3,0
 7b4:	b5d9                	j	67a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b6:	008b8493          	addi	s1,s7,8
 7ba:	4681                	li	a3,0
 7bc:	4629                	li	a2,10
 7be:	000ba583          	lw	a1,0(s7)
 7c2:	855a                	mv	a0,s6
 7c4:	dd7ff0ef          	jal	59a <printint>
        i += 1;
 7c8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ca:	8ba6                	mv	s7,s1
      state = 0;
 7cc:	4981                	li	s3,0
        i += 1;
 7ce:	b575                	j	67a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d0:	008b8493          	addi	s1,s7,8
 7d4:	4681                	li	a3,0
 7d6:	4629                	li	a2,10
 7d8:	000ba583          	lw	a1,0(s7)
 7dc:	855a                	mv	a0,s6
 7de:	dbdff0ef          	jal	59a <printint>
        i += 2;
 7e2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e4:	8ba6                	mv	s7,s1
      state = 0;
 7e6:	4981                	li	s3,0
        i += 2;
 7e8:	bd49                	j	67a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7ea:	008b8493          	addi	s1,s7,8
 7ee:	4681                	li	a3,0
 7f0:	4641                	li	a2,16
 7f2:	000ba583          	lw	a1,0(s7)
 7f6:	855a                	mv	a0,s6
 7f8:	da3ff0ef          	jal	59a <printint>
 7fc:	8ba6                	mv	s7,s1
      state = 0;
 7fe:	4981                	li	s3,0
 800:	bdad                	j	67a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 802:	008b8493          	addi	s1,s7,8
 806:	4681                	li	a3,0
 808:	4641                	li	a2,16
 80a:	000ba583          	lw	a1,0(s7)
 80e:	855a                	mv	a0,s6
 810:	d8bff0ef          	jal	59a <printint>
        i += 1;
 814:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 816:	8ba6                	mv	s7,s1
      state = 0;
 818:	4981                	li	s3,0
        i += 1;
 81a:	b585                	j	67a <vprintf+0x4a>
 81c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 81e:	008b8d13          	addi	s10,s7,8
 822:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 826:	03000593          	li	a1,48
 82a:	855a                	mv	a0,s6
 82c:	d51ff0ef          	jal	57c <putc>
  putc(fd, 'x');
 830:	07800593          	li	a1,120
 834:	855a                	mv	a0,s6
 836:	d47ff0ef          	jal	57c <putc>
 83a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 83c:	00000b97          	auipc	s7,0x0
 840:	2c4b8b93          	addi	s7,s7,708 # b00 <digits>
 844:	03c9d793          	srli	a5,s3,0x3c
 848:	97de                	add	a5,a5,s7
 84a:	0007c583          	lbu	a1,0(a5)
 84e:	855a                	mv	a0,s6
 850:	d2dff0ef          	jal	57c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 854:	0992                	slli	s3,s3,0x4
 856:	34fd                	addiw	s1,s1,-1
 858:	f4f5                	bnez	s1,844 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 85a:	8bea                	mv	s7,s10
      state = 0;
 85c:	4981                	li	s3,0
 85e:	6d02                	ld	s10,0(sp)
 860:	bd29                	j	67a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 862:	008b8993          	addi	s3,s7,8
 866:	000bb483          	ld	s1,0(s7)
 86a:	cc91                	beqz	s1,886 <vprintf+0x256>
        for(; *s; s++)
 86c:	0004c583          	lbu	a1,0(s1)
 870:	c195                	beqz	a1,894 <vprintf+0x264>
          putc(fd, *s);
 872:	855a                	mv	a0,s6
 874:	d09ff0ef          	jal	57c <putc>
        for(; *s; s++)
 878:	0485                	addi	s1,s1,1
 87a:	0004c583          	lbu	a1,0(s1)
 87e:	f9f5                	bnez	a1,872 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 880:	8bce                	mv	s7,s3
      state = 0;
 882:	4981                	li	s3,0
 884:	bbdd                	j	67a <vprintf+0x4a>
          s = "(null)";
 886:	00000497          	auipc	s1,0x0
 88a:	27248493          	addi	s1,s1,626 # af8 <malloc+0x162>
        for(; *s; s++)
 88e:	02800593          	li	a1,40
 892:	b7c5                	j	872 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 894:	8bce                	mv	s7,s3
      state = 0;
 896:	4981                	li	s3,0
 898:	b3cd                	j	67a <vprintf+0x4a>
 89a:	6906                	ld	s2,64(sp)
 89c:	79e2                	ld	s3,56(sp)
 89e:	7a42                	ld	s4,48(sp)
 8a0:	7aa2                	ld	s5,40(sp)
 8a2:	7b02                	ld	s6,32(sp)
 8a4:	6be2                	ld	s7,24(sp)
 8a6:	6c42                	ld	s8,16(sp)
 8a8:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8aa:	60e6                	ld	ra,88(sp)
 8ac:	6446                	ld	s0,80(sp)
 8ae:	64a6                	ld	s1,72(sp)
 8b0:	6125                	addi	sp,sp,96
 8b2:	8082                	ret

00000000000008b4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8b4:	715d                	addi	sp,sp,-80
 8b6:	ec06                	sd	ra,24(sp)
 8b8:	e822                	sd	s0,16(sp)
 8ba:	1000                	addi	s0,sp,32
 8bc:	e010                	sd	a2,0(s0)
 8be:	e414                	sd	a3,8(s0)
 8c0:	e818                	sd	a4,16(s0)
 8c2:	ec1c                	sd	a5,24(s0)
 8c4:	03043023          	sd	a6,32(s0)
 8c8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8cc:	8622                	mv	a2,s0
 8ce:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8d2:	d5fff0ef          	jal	630 <vprintf>
}
 8d6:	60e2                	ld	ra,24(sp)
 8d8:	6442                	ld	s0,16(sp)
 8da:	6161                	addi	sp,sp,80
 8dc:	8082                	ret

00000000000008de <printf>:

void
printf(const char *fmt, ...)
{
 8de:	711d                	addi	sp,sp,-96
 8e0:	ec06                	sd	ra,24(sp)
 8e2:	e822                	sd	s0,16(sp)
 8e4:	1000                	addi	s0,sp,32
 8e6:	e40c                	sd	a1,8(s0)
 8e8:	e810                	sd	a2,16(s0)
 8ea:	ec14                	sd	a3,24(s0)
 8ec:	f018                	sd	a4,32(s0)
 8ee:	f41c                	sd	a5,40(s0)
 8f0:	03043823          	sd	a6,48(s0)
 8f4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8f8:	00840613          	addi	a2,s0,8
 8fc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 900:	85aa                	mv	a1,a0
 902:	4505                	li	a0,1
 904:	d2dff0ef          	jal	630 <vprintf>
}
 908:	60e2                	ld	ra,24(sp)
 90a:	6442                	ld	s0,16(sp)
 90c:	6125                	addi	sp,sp,96
 90e:	8082                	ret

0000000000000910 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 910:	1141                	addi	sp,sp,-16
 912:	e406                	sd	ra,8(sp)
 914:	e022                	sd	s0,0(sp)
 916:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 918:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91c:	00000797          	auipc	a5,0x0
 920:	6e47b783          	ld	a5,1764(a5) # 1000 <freep>
 924:	a02d                	j	94e <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 926:	4618                	lw	a4,8(a2)
 928:	9f2d                	addw	a4,a4,a1
 92a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 92e:	6398                	ld	a4,0(a5)
 930:	6310                	ld	a2,0(a4)
 932:	a83d                	j	970 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 934:	ff852703          	lw	a4,-8(a0)
 938:	9f31                	addw	a4,a4,a2
 93a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 93c:	ff053683          	ld	a3,-16(a0)
 940:	a091                	j	984 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 942:	6398                	ld	a4,0(a5)
 944:	00e7e463          	bltu	a5,a4,94c <free+0x3c>
 948:	00e6ea63          	bltu	a3,a4,95c <free+0x4c>
{
 94c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 94e:	fed7fae3          	bgeu	a5,a3,942 <free+0x32>
 952:	6398                	ld	a4,0(a5)
 954:	00e6e463          	bltu	a3,a4,95c <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 958:	fee7eae3          	bltu	a5,a4,94c <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 95c:	ff852583          	lw	a1,-8(a0)
 960:	6390                	ld	a2,0(a5)
 962:	02059813          	slli	a6,a1,0x20
 966:	01c85713          	srli	a4,a6,0x1c
 96a:	9736                	add	a4,a4,a3
 96c:	fae60de3          	beq	a2,a4,926 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 970:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 974:	4790                	lw	a2,8(a5)
 976:	02061593          	slli	a1,a2,0x20
 97a:	01c5d713          	srli	a4,a1,0x1c
 97e:	973e                	add	a4,a4,a5
 980:	fae68ae3          	beq	a3,a4,934 <free+0x24>
    p->s.ptr = bp->s.ptr;
 984:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 986:	00000717          	auipc	a4,0x0
 98a:	66f73d23          	sd	a5,1658(a4) # 1000 <freep>
}
 98e:	60a2                	ld	ra,8(sp)
 990:	6402                	ld	s0,0(sp)
 992:	0141                	addi	sp,sp,16
 994:	8082                	ret

0000000000000996 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 996:	7139                	addi	sp,sp,-64
 998:	fc06                	sd	ra,56(sp)
 99a:	f822                	sd	s0,48(sp)
 99c:	f04a                	sd	s2,32(sp)
 99e:	ec4e                	sd	s3,24(sp)
 9a0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9a2:	02051993          	slli	s3,a0,0x20
 9a6:	0209d993          	srli	s3,s3,0x20
 9aa:	09bd                	addi	s3,s3,15
 9ac:	0049d993          	srli	s3,s3,0x4
 9b0:	2985                	addiw	s3,s3,1
 9b2:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 9b4:	00000517          	auipc	a0,0x0
 9b8:	64c53503          	ld	a0,1612(a0) # 1000 <freep>
 9bc:	c905                	beqz	a0,9ec <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9c0:	4798                	lw	a4,8(a5)
 9c2:	09377663          	bgeu	a4,s3,a4e <malloc+0xb8>
 9c6:	f426                	sd	s1,40(sp)
 9c8:	e852                	sd	s4,16(sp)
 9ca:	e456                	sd	s5,8(sp)
 9cc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9ce:	8a4e                	mv	s4,s3
 9d0:	6705                	lui	a4,0x1
 9d2:	00e9f363          	bgeu	s3,a4,9d8 <malloc+0x42>
 9d6:	6a05                	lui	s4,0x1
 9d8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9dc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9e0:	00000497          	auipc	s1,0x0
 9e4:	62048493          	addi	s1,s1,1568 # 1000 <freep>
  if(p == (char*)-1)
 9e8:	5afd                	li	s5,-1
 9ea:	a83d                	j	a28 <malloc+0x92>
 9ec:	f426                	sd	s1,40(sp)
 9ee:	e852                	sd	s4,16(sp)
 9f0:	e456                	sd	s5,8(sp)
 9f2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9f4:	00000797          	auipc	a5,0x0
 9f8:	61c78793          	addi	a5,a5,1564 # 1010 <base>
 9fc:	00000717          	auipc	a4,0x0
 a00:	60f73223          	sd	a5,1540(a4) # 1000 <freep>
 a04:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a06:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a0a:	b7d1                	j	9ce <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a0c:	6398                	ld	a4,0(a5)
 a0e:	e118                	sd	a4,0(a0)
 a10:	a899                	j	a66 <malloc+0xd0>
  hp->s.size = nu;
 a12:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a16:	0541                	addi	a0,a0,16
 a18:	ef9ff0ef          	jal	910 <free>
  return freep;
 a1c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a1e:	c125                	beqz	a0,a7e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a20:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a22:	4798                	lw	a4,8(a5)
 a24:	03277163          	bgeu	a4,s2,a46 <malloc+0xb0>
    if(p == freep)
 a28:	6098                	ld	a4,0(s1)
 a2a:	853e                	mv	a0,a5
 a2c:	fef71ae3          	bne	a4,a5,a20 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a30:	8552                	mv	a0,s4
 a32:	b33ff0ef          	jal	564 <sbrk>
  if(p == (char*)-1)
 a36:	fd551ee3          	bne	a0,s5,a12 <malloc+0x7c>
        return 0;
 a3a:	4501                	li	a0,0
 a3c:	74a2                	ld	s1,40(sp)
 a3e:	6a42                	ld	s4,16(sp)
 a40:	6aa2                	ld	s5,8(sp)
 a42:	6b02                	ld	s6,0(sp)
 a44:	a03d                	j	a72 <malloc+0xdc>
 a46:	74a2                	ld	s1,40(sp)
 a48:	6a42                	ld	s4,16(sp)
 a4a:	6aa2                	ld	s5,8(sp)
 a4c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a4e:	fae90fe3          	beq	s2,a4,a0c <malloc+0x76>
        p->s.size -= nunits;
 a52:	4137073b          	subw	a4,a4,s3
 a56:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a58:	02071693          	slli	a3,a4,0x20
 a5c:	01c6d713          	srli	a4,a3,0x1c
 a60:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a62:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a66:	00000717          	auipc	a4,0x0
 a6a:	58a73d23          	sd	a0,1434(a4) # 1000 <freep>
      return (void*)(p + 1);
 a6e:	01078513          	addi	a0,a5,16
  }
}
 a72:	70e2                	ld	ra,56(sp)
 a74:	7442                	ld	s0,48(sp)
 a76:	7902                	ld	s2,32(sp)
 a78:	69e2                	ld	s3,24(sp)
 a7a:	6121                	addi	sp,sp,64
 a7c:	8082                	ret
 a7e:	74a2                	ld	s1,40(sp)
 a80:	6a42                	ld	s4,16(sp)
 a82:	6aa2                	ld	s5,8(sp)
 a84:	6b02                	ld	s6,0(sp)
 a86:	b7f5                	j	a72 <malloc+0xdc>
