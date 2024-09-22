
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
   c:	00001097          	auipc	ra,0x1
  10:	ab2080e7          	jalr	-1358(ra) # abe <malloc>
  14:	84aa                	mv	s1,a0

    // Attempt to create the child pipe.
    if (pipe(fd) != 0) {
  16:	00000097          	auipc	ra,0x0
  1a:	59a080e7          	jalr	1434(ra) # 5b0 <pipe>
  1e:	e519                	bnez	a0,2c <new_pipe+0x2c>
        printf("Error creating child pipe\n");
        exit(ERROR);
    }
    return fd;
}
  20:	8526                	mv	a0,s1
  22:	60e2                	ld	ra,24(sp)
  24:	6442                	ld	s0,16(sp)
  26:	64a2                	ld	s1,8(sp)
  28:	6105                	addi	sp,sp,32
  2a:	8082                	ret
        printf("Error creating child pipe\n");
  2c:	00001517          	auipc	a0,0x1
  30:	b9450513          	addi	a0,a0,-1132 # bc0 <malloc+0x102>
  34:	00001097          	auipc	ra,0x1
  38:	9ce080e7          	jalr	-1586(ra) # a02 <printf>
        exit(ERROR);
  3c:	4505                	li	a0,1
  3e:	00000097          	auipc	ra,0x0
  42:	562080e7          	jalr	1378(ra) # 5a0 <exit>

0000000000000046 <handle_parent>:

void handle_parent(int* first_fd, int child_pid) {
  46:	711d                	addi	sp,sp,-96
  48:	ec86                	sd	ra,88(sp)
  4a:	e8a2                	sd	s0,80(sp)
  4c:	e4a6                	sd	s1,72(sp)
  4e:	e0ca                	sd	s2,64(sp)
  50:	fc4e                	sd	s3,56(sp)
  52:	f852                	sd	s4,48(sp)
  54:	f456                	sd	s5,40(sp)
  56:	f05a                	sd	s6,32(sp)
  58:	1080                	addi	s0,sp,96
  5a:	892a                	mv	s2,a0
  5c:	fab42623          	sw	a1,-84(s0)
    close(first_fd[PIPE_READ]);
  60:	4108                	lw	a0,0(a0)
  62:	00000097          	auipc	ra,0x0
  66:	566080e7          	jalr	1382(ra) # 5c8 <close>

    // Send the next process's number to it.
    send_num(MIN_PIPELINE_VAL, first_fd);
  6a:	4489                	li	s1,2
  6c:	fa942e23          	sw	s1,-68(s0)
    write(fd_array[PIPE_WRITE], &num, sizeof(int));
  70:	4611                	li	a2,4
  72:	fbc40593          	addi	a1,s0,-68
  76:	00492503          	lw	a0,4(s2)
  7a:	00000097          	auipc	ra,0x0
  7e:	546080e7          	jalr	1350(ra) # 5c0 <write>
  82:	fbc40b13          	addi	s6,s0,-68
  86:	4a91                	li	s5,4

    // Write all numbers from 2 to 35 to the pipeline.
    for (int i = MIN_PIPELINE_VAL; i <= MAX_PIPELINE_VAL; i++) {
        send_num(i, first_fd);
        sleep(SLEEP_DELAY_BETWEEN_NUMS);
  88:	4a05                	li	s4,1
    for (int i = MIN_PIPELINE_VAL; i <= MAX_PIPELINE_VAL; i++) {
  8a:	02400993          	li	s3,36
        send_num(i, first_fd);
  8e:	fa942e23          	sw	s1,-68(s0)
    write(fd_array[PIPE_WRITE], &num, sizeof(int));
  92:	8656                	mv	a2,s5
  94:	85da                	mv	a1,s6
  96:	00492503          	lw	a0,4(s2)
  9a:	00000097          	auipc	ra,0x0
  9e:	526080e7          	jalr	1318(ra) # 5c0 <write>
        sleep(SLEEP_DELAY_BETWEEN_NUMS);
  a2:	8552                	mv	a0,s4
  a4:	00000097          	auipc	ra,0x0
  a8:	58c080e7          	jalr	1420(ra) # 630 <sleep>
    for (int i = MIN_PIPELINE_VAL; i <= MAX_PIPELINE_VAL; i++) {
  ac:	2485                	addiw	s1,s1,1
  ae:	ff3490e3          	bne	s1,s3,8e <handle_parent+0x48>
    }

    // Send shutdown signal to the child.
    send_num(EXIT_SIGNAL, first_fd);
  b2:	57fd                	li	a5,-1
  b4:	faf42e23          	sw	a5,-68(s0)
    write(fd_array[PIPE_WRITE], &num, sizeof(int));
  b8:	4611                	li	a2,4
  ba:	fbc40593          	addi	a1,s0,-68
  be:	00492503          	lw	a0,4(s2)
  c2:	00000097          	auipc	ra,0x0
  c6:	4fe080e7          	jalr	1278(ra) # 5c0 <write>

    // Wait for the child to exit.
    wait(&child_pid);
  ca:	fac40513          	addi	a0,s0,-84
  ce:	00000097          	auipc	ra,0x0
  d2:	4da080e7          	jalr	1242(ra) # 5a8 <wait>

    // Close the pipe.
    close(first_fd[PIPE_WRITE]);
  d6:	00492503          	lw	a0,4(s2)
  da:	00000097          	auipc	ra,0x0
  de:	4ee080e7          	jalr	1262(ra) # 5c8 <close>
    free(first_fd);
  e2:	854a                	mv	a0,s2
  e4:	00001097          	auipc	ra,0x1
  e8:	954080e7          	jalr	-1708(ra) # a38 <free>
    exit(SUCCESS);
  ec:	4501                	li	a0,0
  ee:	00000097          	auipc	ra,0x0
  f2:	4b2080e7          	jalr	1202(ra) # 5a0 <exit>

00000000000000f6 <handle_child>:
}

void handle_child(int* parent_fd) __attribute__((noreturn));
void handle_child(int* parent_fd) {
  f6:	715d                	addi	sp,sp,-80
  f8:	e486                	sd	ra,72(sp)
  fa:	e0a2                	sd	s0,64(sp)
  fc:	f44e                	sd	s3,40(sp)
  fe:	0880                	addi	s0,sp,80
 100:	89aa                	mv	s3,a0
    int recv_num = 0;
 102:	fa042e23          	sw	zero,-68(s0)
    int* next_fd = NULL;
    int my_num = 0;
 106:	fa042c23          	sw	zero,-72(s0)
    int new_pid = -1;
 10a:	57fd                	li	a5,-1
 10c:	faf42a23          	sw	a5,-76(s0)

    close(parent_fd[PIPE_WRITE]);
 110:	4148                	lw	a0,4(a0)
 112:	00000097          	auipc	ra,0x0
 116:	4b6080e7          	jalr	1206(ra) # 5c8 <close>

    // Attempt to read the current num (and check the case where no bytes were read).
    if (read(parent_fd[PIPE_READ], &my_num, sizeof(int)) <= 0) {
 11a:	4611                	li	a2,4
 11c:	fb840593          	addi	a1,s0,-72
 120:	0009a503          	lw	a0,0(s3)
 124:	00000097          	auipc	ra,0x0
 128:	494080e7          	jalr	1172(ra) # 5b8 <read>
 12c:	02a05963          	blez	a0,15e <handle_child+0x68>
 130:	fc26                	sd	s1,56(sp)
 132:	f84a                	sd	s2,48(sp)
 134:	f052                	sd	s4,32(sp)
 136:	ec56                	sd	s5,24(sp)
 138:	e85a                	sd	s6,16(sp)
        printf("Error reading received bytes\n");
        exit(ERROR);
    }
    printf("prime %d\n", my_num);
 13a:	fb842583          	lw	a1,-72(s0)
 13e:	00001517          	auipc	a0,0x1
 142:	ac250513          	addi	a0,a0,-1342 # c00 <malloc+0x142>
 146:	00001097          	auipc	ra,0x1
 14a:	8bc080e7          	jalr	-1860(ra) # a02 <printf>
    int* next_fd = NULL;
 14e:	4481                	li	s1,0

    // Handle received numbers and check if the current number divides them.
    while (true) {
        // Attempt to read the current num (and check the case where no bytes were read).
        if (read(parent_fd[PIPE_READ], &recv_num, sizeof(int)) <= 0) {
 150:	fbc40a13          	addi	s4,s0,-68
 154:	4911                	li	s2,4
            printf("Error reading received bytes\n");
            exit(ERROR);
        }

        // Exit if the current number is the EXIT_SIGNAL.
        if (recv_num == EXIT_SIGNAL) break;
 156:	5afd                	li	s5,-1
    write(fd_array[PIPE_WRITE], &num, sizeof(int));
 158:	fb040b13          	addi	s6,s0,-80
 15c:	a889                	j	1ae <handle_child+0xb8>
 15e:	fc26                	sd	s1,56(sp)
 160:	f84a                	sd	s2,48(sp)
 162:	f052                	sd	s4,32(sp)
 164:	ec56                	sd	s5,24(sp)
 166:	e85a                	sd	s6,16(sp)
        printf("Error reading received bytes\n");
 168:	00001517          	auipc	a0,0x1
 16c:	a7850513          	addi	a0,a0,-1416 # be0 <malloc+0x122>
 170:	00001097          	auipc	ra,0x1
 174:	892080e7          	jalr	-1902(ra) # a02 <printf>
        exit(ERROR);
 178:	4505                	li	a0,1
 17a:	00000097          	auipc	ra,0x0
 17e:	426080e7          	jalr	1062(ra) # 5a0 <exit>
            printf("Error reading received bytes\n");
 182:	00001517          	auipc	a0,0x1
 186:	a5e50513          	addi	a0,a0,-1442 # be0 <malloc+0x122>
 18a:	00001097          	auipc	ra,0x1
 18e:	878080e7          	jalr	-1928(ra) # a02 <printf>
            exit(ERROR);
 192:	4505                	li	a0,1
 194:	00000097          	auipc	ra,0x0
 198:	40c080e7          	jalr	1036(ra) # 5a0 <exit>
        if (recv_num % my_num == 0) continue;

        // If this process already has a child, send the number to it.
        if (next_fd != NULL) {
            send_num(recv_num, next_fd);
 19c:	fae42823          	sw	a4,-80(s0)
    write(fd_array[PIPE_WRITE], &num, sizeof(int));
 1a0:	864a                	mv	a2,s2
 1a2:	85da                	mv	a1,s6
 1a4:	40c8                	lw	a0,4(s1)
 1a6:	00000097          	auipc	ra,0x0
 1aa:	41a080e7          	jalr	1050(ra) # 5c0 <write>
        if (read(parent_fd[PIPE_READ], &recv_num, sizeof(int)) <= 0) {
 1ae:	864a                	mv	a2,s2
 1b0:	85d2                	mv	a1,s4
 1b2:	0009a503          	lw	a0,0(s3)
 1b6:	00000097          	auipc	ra,0x0
 1ba:	402080e7          	jalr	1026(ra) # 5b8 <read>
 1be:	fca052e3          	blez	a0,182 <handle_child+0x8c>
        if (recv_num == EXIT_SIGNAL) break;
 1c2:	fbc42703          	lw	a4,-68(s0)
 1c6:	07570a63          	beq	a4,s5,23a <handle_child+0x144>
        if (recv_num % my_num == 0) continue;
 1ca:	fb842783          	lw	a5,-72(s0)
 1ce:	02f767bb          	remw	a5,a4,a5
 1d2:	dff1                	beqz	a5,1ae <handle_child+0xb8>
        if (next_fd != NULL) {
 1d4:	f4e1                	bnez	s1,19c <handle_child+0xa6>
            continue;
        }

        // Create a child for the process if one doesn't already exist.
        next_fd = new_pipe();
 1d6:	00000097          	auipc	ra,0x0
 1da:	e2a080e7          	jalr	-470(ra) # 0 <new_pipe>
 1de:	84aa                	mv	s1,a0
        new_pid = fork();
 1e0:	00000097          	auipc	ra,0x0
 1e4:	3b8080e7          	jalr	952(ra) # 598 <fork>
 1e8:	faa42a23          	sw	a0,-76(s0)
        if (new_pid < 0) {
 1ec:	02054563          	bltz	a0,216 <handle_child+0x120>
            printf("Error forking process\n");
            exit(ERROR);
        } else if (new_pid > 0) {
 1f0:	04a05063          	blez	a0,230 <handle_child+0x13a>
            // Close the reading part of the child's fd and send the number to it.
            close(next_fd[PIPE_READ]);
 1f4:	4088                	lw	a0,0(s1)
 1f6:	00000097          	auipc	ra,0x0
 1fa:	3d2080e7          	jalr	978(ra) # 5c8 <close>
            send_num(recv_num, next_fd);
 1fe:	fbc42783          	lw	a5,-68(s0)
 202:	faf42823          	sw	a5,-80(s0)
    write(fd_array[PIPE_WRITE], &num, sizeof(int));
 206:	864a                	mv	a2,s2
 208:	85da                	mv	a1,s6
 20a:	40c8                	lw	a0,4(s1)
 20c:	00000097          	auipc	ra,0x0
 210:	3b4080e7          	jalr	948(ra) # 5c0 <write>
 214:	bf69                	j	1ae <handle_child+0xb8>
            printf("Error forking process\n");
 216:	00001517          	auipc	a0,0x1
 21a:	9fa50513          	addi	a0,a0,-1542 # c10 <malloc+0x152>
 21e:	00000097          	auipc	ra,0x0
 222:	7e4080e7          	jalr	2020(ra) # a02 <printf>
            exit(ERROR);
 226:	4505                	li	a0,1
 228:	00000097          	auipc	ra,0x0
 22c:	378080e7          	jalr	888(ra) # 5a0 <exit>
        }
        else handle_child(next_fd);
 230:	8526                	mv	a0,s1
 232:	00000097          	auipc	ra,0x0
 236:	ec4080e7          	jalr	-316(ra) # f6 <handle_child>
    }

    // Shutdown the child if one exists.
    if (next_fd != NULL) {
 23a:	cc85                	beqz	s1,272 <handle_child+0x17c>
        send_num(EXIT_SIGNAL, next_fd);
 23c:	57fd                	li	a5,-1
 23e:	faf42823          	sw	a5,-80(s0)
    write(fd_array[PIPE_WRITE], &num, sizeof(int));
 242:	4611                	li	a2,4
 244:	fb040593          	addi	a1,s0,-80
 248:	40c8                	lw	a0,4(s1)
 24a:	00000097          	auipc	ra,0x0
 24e:	376080e7          	jalr	886(ra) # 5c0 <write>
        wait(&new_pid);
 252:	fb440513          	addi	a0,s0,-76
 256:	00000097          	auipc	ra,0x0
 25a:	352080e7          	jalr	850(ra) # 5a8 <wait>
        
        // Release the fds this process uses.
        close(next_fd[PIPE_WRITE]);
 25e:	40c8                	lw	a0,4(s1)
 260:	00000097          	auipc	ra,0x0
 264:	368080e7          	jalr	872(ra) # 5c8 <close>
        free(next_fd);
 268:	8526                	mv	a0,s1
 26a:	00000097          	auipc	ra,0x0
 26e:	7ce080e7          	jalr	1998(ra) # a38 <free>
    }

    // CLose the reading hand of the parent's pipe.
    close(parent_fd[PIPE_READ]);
 272:	0009a503          	lw	a0,0(s3)
 276:	00000097          	auipc	ra,0x0
 27a:	352080e7          	jalr	850(ra) # 5c8 <close>
    free(parent_fd);
 27e:	854e                	mv	a0,s3
 280:	00000097          	auipc	ra,0x0
 284:	7b8080e7          	jalr	1976(ra) # a38 <free>
    exit(SUCCESS);
 288:	4501                	li	a0,0
 28a:	00000097          	auipc	ra,0x0
 28e:	316080e7          	jalr	790(ra) # 5a0 <exit>

0000000000000292 <main>:
}

int main(int argc, char *argv[])
{
 292:	1101                	addi	sp,sp,-32
 294:	ec06                	sd	ra,24(sp)
 296:	e822                	sd	s0,16(sp)
 298:	e426                	sd	s1,8(sp)
 29a:	1000                	addi	s0,sp,32
    int* first_fd = new_pipe();
 29c:	00000097          	auipc	ra,0x0
 2a0:	d64080e7          	jalr	-668(ra) # 0 <new_pipe>
 2a4:	84aa                	mv	s1,a0
    int pid = fork();
 2a6:	00000097          	auipc	ra,0x0
 2aa:	2f2080e7          	jalr	754(ra) # 598 <fork>

    // Check for fork error.
    if (pid < 0) {
 2ae:	00054a63          	bltz	a0,2c2 <main+0x30>
        printf("Error forking process\n");
        exit(ERROR);
    } else if (pid > 0) handle_parent(first_fd, pid);
 2b2:	02a05563          	blez	a0,2dc <main+0x4a>
 2b6:	85aa                	mv	a1,a0
 2b8:	8526                	mv	a0,s1
 2ba:	00000097          	auipc	ra,0x0
 2be:	d8c080e7          	jalr	-628(ra) # 46 <handle_parent>
        printf("Error forking process\n");
 2c2:	00001517          	auipc	a0,0x1
 2c6:	94e50513          	addi	a0,a0,-1714 # c10 <malloc+0x152>
 2ca:	00000097          	auipc	ra,0x0
 2ce:	738080e7          	jalr	1848(ra) # a02 <printf>
        exit(ERROR);
 2d2:	4505                	li	a0,1
 2d4:	00000097          	auipc	ra,0x0
 2d8:	2cc080e7          	jalr	716(ra) # 5a0 <exit>
    else handle_child(first_fd);
 2dc:	8526                	mv	a0,s1
 2de:	00000097          	auipc	ra,0x0
 2e2:	e18080e7          	jalr	-488(ra) # f6 <handle_child>

00000000000002e6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2ee:	00000097          	auipc	ra,0x0
 2f2:	fa4080e7          	jalr	-92(ra) # 292 <main>
  exit(0);
 2f6:	4501                	li	a0,0
 2f8:	00000097          	auipc	ra,0x0
 2fc:	2a8080e7          	jalr	680(ra) # 5a0 <exit>

0000000000000300 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 300:	1141                	addi	sp,sp,-16
 302:	e406                	sd	ra,8(sp)
 304:	e022                	sd	s0,0(sp)
 306:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 308:	87aa                	mv	a5,a0
 30a:	0585                	addi	a1,a1,1
 30c:	0785                	addi	a5,a5,1
 30e:	fff5c703          	lbu	a4,-1(a1)
 312:	fee78fa3          	sb	a4,-1(a5)
 316:	fb75                	bnez	a4,30a <strcpy+0xa>
    ;
  return os;
}
 318:	60a2                	ld	ra,8(sp)
 31a:	6402                	ld	s0,0(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret

0000000000000320 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 320:	1141                	addi	sp,sp,-16
 322:	e406                	sd	ra,8(sp)
 324:	e022                	sd	s0,0(sp)
 326:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 328:	00054783          	lbu	a5,0(a0)
 32c:	cb91                	beqz	a5,340 <strcmp+0x20>
 32e:	0005c703          	lbu	a4,0(a1)
 332:	00f71763          	bne	a4,a5,340 <strcmp+0x20>
    p++, q++;
 336:	0505                	addi	a0,a0,1
 338:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 33a:	00054783          	lbu	a5,0(a0)
 33e:	fbe5                	bnez	a5,32e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 340:	0005c503          	lbu	a0,0(a1)
}
 344:	40a7853b          	subw	a0,a5,a0
 348:	60a2                	ld	ra,8(sp)
 34a:	6402                	ld	s0,0(sp)
 34c:	0141                	addi	sp,sp,16
 34e:	8082                	ret

0000000000000350 <strlen>:

uint
strlen(const char *s)
{
 350:	1141                	addi	sp,sp,-16
 352:	e406                	sd	ra,8(sp)
 354:	e022                	sd	s0,0(sp)
 356:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 358:	00054783          	lbu	a5,0(a0)
 35c:	cf99                	beqz	a5,37a <strlen+0x2a>
 35e:	0505                	addi	a0,a0,1
 360:	87aa                	mv	a5,a0
 362:	86be                	mv	a3,a5
 364:	0785                	addi	a5,a5,1
 366:	fff7c703          	lbu	a4,-1(a5)
 36a:	ff65                	bnez	a4,362 <strlen+0x12>
 36c:	40a6853b          	subw	a0,a3,a0
 370:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 372:	60a2                	ld	ra,8(sp)
 374:	6402                	ld	s0,0(sp)
 376:	0141                	addi	sp,sp,16
 378:	8082                	ret
  for(n = 0; s[n]; n++)
 37a:	4501                	li	a0,0
 37c:	bfdd                	j	372 <strlen+0x22>

000000000000037e <memset>:

void*
memset(void *dst, int c, uint n)
{
 37e:	1141                	addi	sp,sp,-16
 380:	e406                	sd	ra,8(sp)
 382:	e022                	sd	s0,0(sp)
 384:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 386:	ca19                	beqz	a2,39c <memset+0x1e>
 388:	87aa                	mv	a5,a0
 38a:	1602                	slli	a2,a2,0x20
 38c:	9201                	srli	a2,a2,0x20
 38e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 392:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 396:	0785                	addi	a5,a5,1
 398:	fee79de3          	bne	a5,a4,392 <memset+0x14>
  }
  return dst;
}
 39c:	60a2                	ld	ra,8(sp)
 39e:	6402                	ld	s0,0(sp)
 3a0:	0141                	addi	sp,sp,16
 3a2:	8082                	ret

00000000000003a4 <strchr>:

char*
strchr(const char *s, char c)
{
 3a4:	1141                	addi	sp,sp,-16
 3a6:	e406                	sd	ra,8(sp)
 3a8:	e022                	sd	s0,0(sp)
 3aa:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3ac:	00054783          	lbu	a5,0(a0)
 3b0:	cf81                	beqz	a5,3c8 <strchr+0x24>
    if(*s == c)
 3b2:	00f58763          	beq	a1,a5,3c0 <strchr+0x1c>
  for(; *s; s++)
 3b6:	0505                	addi	a0,a0,1
 3b8:	00054783          	lbu	a5,0(a0)
 3bc:	fbfd                	bnez	a5,3b2 <strchr+0xe>
      return (char*)s;
  return 0;
 3be:	4501                	li	a0,0
}
 3c0:	60a2                	ld	ra,8(sp)
 3c2:	6402                	ld	s0,0(sp)
 3c4:	0141                	addi	sp,sp,16
 3c6:	8082                	ret
  return 0;
 3c8:	4501                	li	a0,0
 3ca:	bfdd                	j	3c0 <strchr+0x1c>

00000000000003cc <gets>:

char*
gets(char *buf, int max)
{
 3cc:	7159                	addi	sp,sp,-112
 3ce:	f486                	sd	ra,104(sp)
 3d0:	f0a2                	sd	s0,96(sp)
 3d2:	eca6                	sd	s1,88(sp)
 3d4:	e8ca                	sd	s2,80(sp)
 3d6:	e4ce                	sd	s3,72(sp)
 3d8:	e0d2                	sd	s4,64(sp)
 3da:	fc56                	sd	s5,56(sp)
 3dc:	f85a                	sd	s6,48(sp)
 3de:	f45e                	sd	s7,40(sp)
 3e0:	f062                	sd	s8,32(sp)
 3e2:	ec66                	sd	s9,24(sp)
 3e4:	e86a                	sd	s10,16(sp)
 3e6:	1880                	addi	s0,sp,112
 3e8:	8caa                	mv	s9,a0
 3ea:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ec:	892a                	mv	s2,a0
 3ee:	4481                	li	s1,0
    cc = read(0, &c, 1);
 3f0:	f9f40b13          	addi	s6,s0,-97
 3f4:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3f6:	4ba9                	li	s7,10
 3f8:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 3fa:	8d26                	mv	s10,s1
 3fc:	0014899b          	addiw	s3,s1,1
 400:	84ce                	mv	s1,s3
 402:	0349d763          	bge	s3,s4,430 <gets+0x64>
    cc = read(0, &c, 1);
 406:	8656                	mv	a2,s5
 408:	85da                	mv	a1,s6
 40a:	4501                	li	a0,0
 40c:	00000097          	auipc	ra,0x0
 410:	1ac080e7          	jalr	428(ra) # 5b8 <read>
    if(cc < 1)
 414:	00a05e63          	blez	a0,430 <gets+0x64>
    buf[i++] = c;
 418:	f9f44783          	lbu	a5,-97(s0)
 41c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 420:	01778763          	beq	a5,s7,42e <gets+0x62>
 424:	0905                	addi	s2,s2,1
 426:	fd879ae3          	bne	a5,s8,3fa <gets+0x2e>
    buf[i++] = c;
 42a:	8d4e                	mv	s10,s3
 42c:	a011                	j	430 <gets+0x64>
 42e:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 430:	9d66                	add	s10,s10,s9
 432:	000d0023          	sb	zero,0(s10)
  return buf;
}
 436:	8566                	mv	a0,s9
 438:	70a6                	ld	ra,104(sp)
 43a:	7406                	ld	s0,96(sp)
 43c:	64e6                	ld	s1,88(sp)
 43e:	6946                	ld	s2,80(sp)
 440:	69a6                	ld	s3,72(sp)
 442:	6a06                	ld	s4,64(sp)
 444:	7ae2                	ld	s5,56(sp)
 446:	7b42                	ld	s6,48(sp)
 448:	7ba2                	ld	s7,40(sp)
 44a:	7c02                	ld	s8,32(sp)
 44c:	6ce2                	ld	s9,24(sp)
 44e:	6d42                	ld	s10,16(sp)
 450:	6165                	addi	sp,sp,112
 452:	8082                	ret

0000000000000454 <stat>:

int
stat(const char *n, struct stat *st)
{
 454:	1101                	addi	sp,sp,-32
 456:	ec06                	sd	ra,24(sp)
 458:	e822                	sd	s0,16(sp)
 45a:	e04a                	sd	s2,0(sp)
 45c:	1000                	addi	s0,sp,32
 45e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 460:	4581                	li	a1,0
 462:	00000097          	auipc	ra,0x0
 466:	17e080e7          	jalr	382(ra) # 5e0 <open>
  if(fd < 0)
 46a:	02054663          	bltz	a0,496 <stat+0x42>
 46e:	e426                	sd	s1,8(sp)
 470:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 472:	85ca                	mv	a1,s2
 474:	00000097          	auipc	ra,0x0
 478:	184080e7          	jalr	388(ra) # 5f8 <fstat>
 47c:	892a                	mv	s2,a0
  close(fd);
 47e:	8526                	mv	a0,s1
 480:	00000097          	auipc	ra,0x0
 484:	148080e7          	jalr	328(ra) # 5c8 <close>
  return r;
 488:	64a2                	ld	s1,8(sp)
}
 48a:	854a                	mv	a0,s2
 48c:	60e2                	ld	ra,24(sp)
 48e:	6442                	ld	s0,16(sp)
 490:	6902                	ld	s2,0(sp)
 492:	6105                	addi	sp,sp,32
 494:	8082                	ret
    return -1;
 496:	597d                	li	s2,-1
 498:	bfcd                	j	48a <stat+0x36>

000000000000049a <atoi>:

int
atoi(const char *s)
{
 49a:	1141                	addi	sp,sp,-16
 49c:	e406                	sd	ra,8(sp)
 49e:	e022                	sd	s0,0(sp)
 4a0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4a2:	00054683          	lbu	a3,0(a0)
 4a6:	fd06879b          	addiw	a5,a3,-48
 4aa:	0ff7f793          	zext.b	a5,a5
 4ae:	4625                	li	a2,9
 4b0:	02f66963          	bltu	a2,a5,4e2 <atoi+0x48>
 4b4:	872a                	mv	a4,a0
  n = 0;
 4b6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 4b8:	0705                	addi	a4,a4,1
 4ba:	0025179b          	slliw	a5,a0,0x2
 4be:	9fa9                	addw	a5,a5,a0
 4c0:	0017979b          	slliw	a5,a5,0x1
 4c4:	9fb5                	addw	a5,a5,a3
 4c6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4ca:	00074683          	lbu	a3,0(a4)
 4ce:	fd06879b          	addiw	a5,a3,-48
 4d2:	0ff7f793          	zext.b	a5,a5
 4d6:	fef671e3          	bgeu	a2,a5,4b8 <atoi+0x1e>
  return n;
}
 4da:	60a2                	ld	ra,8(sp)
 4dc:	6402                	ld	s0,0(sp)
 4de:	0141                	addi	sp,sp,16
 4e0:	8082                	ret
  n = 0;
 4e2:	4501                	li	a0,0
 4e4:	bfdd                	j	4da <atoi+0x40>

00000000000004e6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4e6:	1141                	addi	sp,sp,-16
 4e8:	e406                	sd	ra,8(sp)
 4ea:	e022                	sd	s0,0(sp)
 4ec:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4ee:	02b57563          	bgeu	a0,a1,518 <memmove+0x32>
    while(n-- > 0)
 4f2:	00c05f63          	blez	a2,510 <memmove+0x2a>
 4f6:	1602                	slli	a2,a2,0x20
 4f8:	9201                	srli	a2,a2,0x20
 4fa:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4fe:	872a                	mv	a4,a0
      *dst++ = *src++;
 500:	0585                	addi	a1,a1,1
 502:	0705                	addi	a4,a4,1
 504:	fff5c683          	lbu	a3,-1(a1)
 508:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 50c:	fee79ae3          	bne	a5,a4,500 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 510:	60a2                	ld	ra,8(sp)
 512:	6402                	ld	s0,0(sp)
 514:	0141                	addi	sp,sp,16
 516:	8082                	ret
    dst += n;
 518:	00c50733          	add	a4,a0,a2
    src += n;
 51c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 51e:	fec059e3          	blez	a2,510 <memmove+0x2a>
 522:	fff6079b          	addiw	a5,a2,-1
 526:	1782                	slli	a5,a5,0x20
 528:	9381                	srli	a5,a5,0x20
 52a:	fff7c793          	not	a5,a5
 52e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 530:	15fd                	addi	a1,a1,-1
 532:	177d                	addi	a4,a4,-1
 534:	0005c683          	lbu	a3,0(a1)
 538:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 53c:	fef71ae3          	bne	a4,a5,530 <memmove+0x4a>
 540:	bfc1                	j	510 <memmove+0x2a>

0000000000000542 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 542:	1141                	addi	sp,sp,-16
 544:	e406                	sd	ra,8(sp)
 546:	e022                	sd	s0,0(sp)
 548:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 54a:	ca0d                	beqz	a2,57c <memcmp+0x3a>
 54c:	fff6069b          	addiw	a3,a2,-1
 550:	1682                	slli	a3,a3,0x20
 552:	9281                	srli	a3,a3,0x20
 554:	0685                	addi	a3,a3,1
 556:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 558:	00054783          	lbu	a5,0(a0)
 55c:	0005c703          	lbu	a4,0(a1)
 560:	00e79863          	bne	a5,a4,570 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 564:	0505                	addi	a0,a0,1
    p2++;
 566:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 568:	fed518e3          	bne	a0,a3,558 <memcmp+0x16>
  }
  return 0;
 56c:	4501                	li	a0,0
 56e:	a019                	j	574 <memcmp+0x32>
      return *p1 - *p2;
 570:	40e7853b          	subw	a0,a5,a4
}
 574:	60a2                	ld	ra,8(sp)
 576:	6402                	ld	s0,0(sp)
 578:	0141                	addi	sp,sp,16
 57a:	8082                	ret
  return 0;
 57c:	4501                	li	a0,0
 57e:	bfdd                	j	574 <memcmp+0x32>

0000000000000580 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 580:	1141                	addi	sp,sp,-16
 582:	e406                	sd	ra,8(sp)
 584:	e022                	sd	s0,0(sp)
 586:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 588:	00000097          	auipc	ra,0x0
 58c:	f5e080e7          	jalr	-162(ra) # 4e6 <memmove>
}
 590:	60a2                	ld	ra,8(sp)
 592:	6402                	ld	s0,0(sp)
 594:	0141                	addi	sp,sp,16
 596:	8082                	ret

0000000000000598 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 598:	4885                	li	a7,1
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5a0:	4889                	li	a7,2
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5a8:	488d                	li	a7,3
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5b0:	4891                	li	a7,4
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <read>:
.global read
read:
 li a7, SYS_read
 5b8:	4895                	li	a7,5
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <write>:
.global write
write:
 li a7, SYS_write
 5c0:	48c1                	li	a7,16
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <close>:
.global close
close:
 li a7, SYS_close
 5c8:	48d5                	li	a7,21
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5d0:	4899                	li	a7,6
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5d8:	489d                	li	a7,7
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <open>:
.global open
open:
 li a7, SYS_open
 5e0:	48bd                	li	a7,15
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5e8:	48c5                	li	a7,17
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5f0:	48c9                	li	a7,18
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5f8:	48a1                	li	a7,8
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <link>:
.global link
link:
 li a7, SYS_link
 600:	48cd                	li	a7,19
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 608:	48d1                	li	a7,20
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 610:	48a5                	li	a7,9
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <dup>:
.global dup
dup:
 li a7, SYS_dup
 618:	48a9                	li	a7,10
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 620:	48ad                	li	a7,11
 ecall
 622:	00000073          	ecall
 ret
 626:	8082                	ret

0000000000000628 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 628:	48b1                	li	a7,12
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 630:	48b5                	li	a7,13
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 638:	48b9                	li	a7,14
 ecall
 63a:	00000073          	ecall
 ret
 63e:	8082                	ret

0000000000000640 <trace>:
.global trace
trace:
 li a7, SYS_trace
 640:	48d9                	li	a7,22
 ecall
 642:	00000073          	ecall
 ret
 646:	8082                	ret

0000000000000648 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 648:	48dd                	li	a7,23
 ecall
 64a:	00000073          	ecall
 ret
 64e:	8082                	ret

0000000000000650 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 650:	1101                	addi	sp,sp,-32
 652:	ec06                	sd	ra,24(sp)
 654:	e822                	sd	s0,16(sp)
 656:	1000                	addi	s0,sp,32
 658:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 65c:	4605                	li	a2,1
 65e:	fef40593          	addi	a1,s0,-17
 662:	00000097          	auipc	ra,0x0
 666:	f5e080e7          	jalr	-162(ra) # 5c0 <write>
}
 66a:	60e2                	ld	ra,24(sp)
 66c:	6442                	ld	s0,16(sp)
 66e:	6105                	addi	sp,sp,32
 670:	8082                	ret

0000000000000672 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 672:	7139                	addi	sp,sp,-64
 674:	fc06                	sd	ra,56(sp)
 676:	f822                	sd	s0,48(sp)
 678:	f426                	sd	s1,40(sp)
 67a:	f04a                	sd	s2,32(sp)
 67c:	ec4e                	sd	s3,24(sp)
 67e:	0080                	addi	s0,sp,64
 680:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 682:	c299                	beqz	a3,688 <printint+0x16>
 684:	0805c063          	bltz	a1,704 <printint+0x92>
  neg = 0;
 688:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 68a:	fc040313          	addi	t1,s0,-64
  neg = 0;
 68e:	869a                	mv	a3,t1
  i = 0;
 690:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 692:	00000817          	auipc	a6,0x0
 696:	59e80813          	addi	a6,a6,1438 # c30 <digits>
 69a:	88be                	mv	a7,a5
 69c:	0017851b          	addiw	a0,a5,1
 6a0:	87aa                	mv	a5,a0
 6a2:	02c5f73b          	remuw	a4,a1,a2
 6a6:	1702                	slli	a4,a4,0x20
 6a8:	9301                	srli	a4,a4,0x20
 6aa:	9742                	add	a4,a4,a6
 6ac:	00074703          	lbu	a4,0(a4)
 6b0:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 6b4:	872e                	mv	a4,a1
 6b6:	02c5d5bb          	divuw	a1,a1,a2
 6ba:	0685                	addi	a3,a3,1
 6bc:	fcc77fe3          	bgeu	a4,a2,69a <printint+0x28>
  if(neg)
 6c0:	000e0c63          	beqz	t3,6d8 <printint+0x66>
    buf[i++] = '-';
 6c4:	fd050793          	addi	a5,a0,-48
 6c8:	00878533          	add	a0,a5,s0
 6cc:	02d00793          	li	a5,45
 6d0:	fef50823          	sb	a5,-16(a0)
 6d4:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 6d8:	fff7899b          	addiw	s3,a5,-1
 6dc:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 6e0:	fff4c583          	lbu	a1,-1(s1)
 6e4:	854a                	mv	a0,s2
 6e6:	00000097          	auipc	ra,0x0
 6ea:	f6a080e7          	jalr	-150(ra) # 650 <putc>
  while(--i >= 0)
 6ee:	39fd                	addiw	s3,s3,-1
 6f0:	14fd                	addi	s1,s1,-1
 6f2:	fe09d7e3          	bgez	s3,6e0 <printint+0x6e>
}
 6f6:	70e2                	ld	ra,56(sp)
 6f8:	7442                	ld	s0,48(sp)
 6fa:	74a2                	ld	s1,40(sp)
 6fc:	7902                	ld	s2,32(sp)
 6fe:	69e2                	ld	s3,24(sp)
 700:	6121                	addi	sp,sp,64
 702:	8082                	ret
    x = -xx;
 704:	40b005bb          	negw	a1,a1
    neg = 1;
 708:	4e05                	li	t3,1
    x = -xx;
 70a:	b741                	j	68a <printint+0x18>

000000000000070c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 70c:	711d                	addi	sp,sp,-96
 70e:	ec86                	sd	ra,88(sp)
 710:	e8a2                	sd	s0,80(sp)
 712:	e4a6                	sd	s1,72(sp)
 714:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 716:	0005c483          	lbu	s1,0(a1)
 71a:	2a048863          	beqz	s1,9ca <vprintf+0x2be>
 71e:	e0ca                	sd	s2,64(sp)
 720:	fc4e                	sd	s3,56(sp)
 722:	f852                	sd	s4,48(sp)
 724:	f456                	sd	s5,40(sp)
 726:	f05a                	sd	s6,32(sp)
 728:	ec5e                	sd	s7,24(sp)
 72a:	e862                	sd	s8,16(sp)
 72c:	e466                	sd	s9,8(sp)
 72e:	8b2a                	mv	s6,a0
 730:	8a2e                	mv	s4,a1
 732:	8bb2                	mv	s7,a2
  state = 0;
 734:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 736:	4901                	li	s2,0
 738:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 73a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 73e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 742:	06c00c93          	li	s9,108
 746:	a01d                	j	76c <vprintf+0x60>
        putc(fd, c0);
 748:	85a6                	mv	a1,s1
 74a:	855a                	mv	a0,s6
 74c:	00000097          	auipc	ra,0x0
 750:	f04080e7          	jalr	-252(ra) # 650 <putc>
 754:	a019                	j	75a <vprintf+0x4e>
    } else if(state == '%'){
 756:	03598363          	beq	s3,s5,77c <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 75a:	0019079b          	addiw	a5,s2,1
 75e:	893e                	mv	s2,a5
 760:	873e                	mv	a4,a5
 762:	97d2                	add	a5,a5,s4
 764:	0007c483          	lbu	s1,0(a5)
 768:	24048963          	beqz	s1,9ba <vprintf+0x2ae>
    c0 = fmt[i] & 0xff;
 76c:	0004879b          	sext.w	a5,s1
    if(state == 0){
 770:	fe0993e3          	bnez	s3,756 <vprintf+0x4a>
      if(c0 == '%'){
 774:	fd579ae3          	bne	a5,s5,748 <vprintf+0x3c>
        state = '%';
 778:	89be                	mv	s3,a5
 77a:	b7c5                	j	75a <vprintf+0x4e>
      if(c0) c1 = fmt[i+1] & 0xff;
 77c:	00ea06b3          	add	a3,s4,a4
 780:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 784:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 786:	c681                	beqz	a3,78e <vprintf+0x82>
 788:	9752                	add	a4,a4,s4
 78a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 78e:	05878063          	beq	a5,s8,7ce <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 792:	05978c63          	beq	a5,s9,7ea <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 796:	07500713          	li	a4,117
 79a:	10e78063          	beq	a5,a4,89a <vprintf+0x18e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 79e:	07800713          	li	a4,120
 7a2:	14e78863          	beq	a5,a4,8f2 <vprintf+0x1e6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 7a6:	07000713          	li	a4,112
 7aa:	18e78163          	beq	a5,a4,92c <vprintf+0x220>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 7ae:	07300713          	li	a4,115
 7b2:	1ce78663          	beq	a5,a4,97e <vprintf+0x272>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 7b6:	02500713          	li	a4,37
 7ba:	04e79863          	bne	a5,a4,80a <vprintf+0xfe>
        putc(fd, '%');
 7be:	85ba                	mv	a1,a4
 7c0:	855a                	mv	a0,s6
 7c2:	00000097          	auipc	ra,0x0
 7c6:	e8e080e7          	jalr	-370(ra) # 650 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 7ca:	4981                	li	s3,0
 7cc:	b779                	j	75a <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 1);
 7ce:	008b8493          	addi	s1,s7,8
 7d2:	4685                	li	a3,1
 7d4:	4629                	li	a2,10
 7d6:	000ba583          	lw	a1,0(s7)
 7da:	855a                	mv	a0,s6
 7dc:	00000097          	auipc	ra,0x0
 7e0:	e96080e7          	jalr	-362(ra) # 672 <printint>
 7e4:	8ba6                	mv	s7,s1
      state = 0;
 7e6:	4981                	li	s3,0
 7e8:	bf8d                	j	75a <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'd'){
 7ea:	06400793          	li	a5,100
 7ee:	02f68d63          	beq	a3,a5,828 <vprintf+0x11c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7f2:	06c00793          	li	a5,108
 7f6:	04f68863          	beq	a3,a5,846 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'u'){
 7fa:	07500793          	li	a5,117
 7fe:	0af68c63          	beq	a3,a5,8b6 <vprintf+0x1aa>
      } else if(c0 == 'l' && c1 == 'x'){
 802:	07800793          	li	a5,120
 806:	10f68463          	beq	a3,a5,90e <vprintf+0x202>
        putc(fd, '%');
 80a:	02500593          	li	a1,37
 80e:	855a                	mv	a0,s6
 810:	00000097          	auipc	ra,0x0
 814:	e40080e7          	jalr	-448(ra) # 650 <putc>
        putc(fd, c0);
 818:	85a6                	mv	a1,s1
 81a:	855a                	mv	a0,s6
 81c:	00000097          	auipc	ra,0x0
 820:	e34080e7          	jalr	-460(ra) # 650 <putc>
      state = 0;
 824:	4981                	li	s3,0
 826:	bf15                	j	75a <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 828:	008b8493          	addi	s1,s7,8
 82c:	4685                	li	a3,1
 82e:	4629                	li	a2,10
 830:	000ba583          	lw	a1,0(s7)
 834:	855a                	mv	a0,s6
 836:	00000097          	auipc	ra,0x0
 83a:	e3c080e7          	jalr	-452(ra) # 672 <printint>
        i += 1;
 83e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 840:	8ba6                	mv	s7,s1
      state = 0;
 842:	4981                	li	s3,0
        i += 1;
 844:	bf19                	j	75a <vprintf+0x4e>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 846:	06400793          	li	a5,100
 84a:	02f60963          	beq	a2,a5,87c <vprintf+0x170>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 84e:	07500793          	li	a5,117
 852:	08f60163          	beq	a2,a5,8d4 <vprintf+0x1c8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 856:	07800793          	li	a5,120
 85a:	faf618e3          	bne	a2,a5,80a <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 85e:	008b8493          	addi	s1,s7,8
 862:	4681                	li	a3,0
 864:	4641                	li	a2,16
 866:	000ba583          	lw	a1,0(s7)
 86a:	855a                	mv	a0,s6
 86c:	00000097          	auipc	ra,0x0
 870:	e06080e7          	jalr	-506(ra) # 672 <printint>
        i += 2;
 874:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 876:	8ba6                	mv	s7,s1
      state = 0;
 878:	4981                	li	s3,0
        i += 2;
 87a:	b5c5                	j	75a <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 1);
 87c:	008b8493          	addi	s1,s7,8
 880:	4685                	li	a3,1
 882:	4629                	li	a2,10
 884:	000ba583          	lw	a1,0(s7)
 888:	855a                	mv	a0,s6
 88a:	00000097          	auipc	ra,0x0
 88e:	de8080e7          	jalr	-536(ra) # 672 <printint>
        i += 2;
 892:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 894:	8ba6                	mv	s7,s1
      state = 0;
 896:	4981                	li	s3,0
        i += 2;
 898:	b5c9                	j	75a <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 10, 0);
 89a:	008b8493          	addi	s1,s7,8
 89e:	4681                	li	a3,0
 8a0:	4629                	li	a2,10
 8a2:	000ba583          	lw	a1,0(s7)
 8a6:	855a                	mv	a0,s6
 8a8:	00000097          	auipc	ra,0x0
 8ac:	dca080e7          	jalr	-566(ra) # 672 <printint>
 8b0:	8ba6                	mv	s7,s1
      state = 0;
 8b2:	4981                	li	s3,0
 8b4:	b55d                	j	75a <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8b6:	008b8493          	addi	s1,s7,8
 8ba:	4681                	li	a3,0
 8bc:	4629                	li	a2,10
 8be:	000ba583          	lw	a1,0(s7)
 8c2:	855a                	mv	a0,s6
 8c4:	00000097          	auipc	ra,0x0
 8c8:	dae080e7          	jalr	-594(ra) # 672 <printint>
        i += 1;
 8cc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 8ce:	8ba6                	mv	s7,s1
      state = 0;
 8d0:	4981                	li	s3,0
        i += 1;
 8d2:	b561                	j	75a <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8d4:	008b8493          	addi	s1,s7,8
 8d8:	4681                	li	a3,0
 8da:	4629                	li	a2,10
 8dc:	000ba583          	lw	a1,0(s7)
 8e0:	855a                	mv	a0,s6
 8e2:	00000097          	auipc	ra,0x0
 8e6:	d90080e7          	jalr	-624(ra) # 672 <printint>
        i += 2;
 8ea:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8ec:	8ba6                	mv	s7,s1
      state = 0;
 8ee:	4981                	li	s3,0
        i += 2;
 8f0:	b5ad                	j	75a <vprintf+0x4e>
        printint(fd, va_arg(ap, int), 16, 0);
 8f2:	008b8493          	addi	s1,s7,8
 8f6:	4681                	li	a3,0
 8f8:	4641                	li	a2,16
 8fa:	000ba583          	lw	a1,0(s7)
 8fe:	855a                	mv	a0,s6
 900:	00000097          	auipc	ra,0x0
 904:	d72080e7          	jalr	-654(ra) # 672 <printint>
 908:	8ba6                	mv	s7,s1
      state = 0;
 90a:	4981                	li	s3,0
 90c:	b5b9                	j	75a <vprintf+0x4e>
        printint(fd, va_arg(ap, uint64), 16, 0);
 90e:	008b8493          	addi	s1,s7,8
 912:	4681                	li	a3,0
 914:	4641                	li	a2,16
 916:	000ba583          	lw	a1,0(s7)
 91a:	855a                	mv	a0,s6
 91c:	00000097          	auipc	ra,0x0
 920:	d56080e7          	jalr	-682(ra) # 672 <printint>
        i += 1;
 924:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 926:	8ba6                	mv	s7,s1
      state = 0;
 928:	4981                	li	s3,0
        i += 1;
 92a:	bd05                	j	75a <vprintf+0x4e>
 92c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 92e:	008b8d13          	addi	s10,s7,8
 932:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 936:	03000593          	li	a1,48
 93a:	855a                	mv	a0,s6
 93c:	00000097          	auipc	ra,0x0
 940:	d14080e7          	jalr	-748(ra) # 650 <putc>
  putc(fd, 'x');
 944:	07800593          	li	a1,120
 948:	855a                	mv	a0,s6
 94a:	00000097          	auipc	ra,0x0
 94e:	d06080e7          	jalr	-762(ra) # 650 <putc>
 952:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 954:	00000b97          	auipc	s7,0x0
 958:	2dcb8b93          	addi	s7,s7,732 # c30 <digits>
 95c:	03c9d793          	srli	a5,s3,0x3c
 960:	97de                	add	a5,a5,s7
 962:	0007c583          	lbu	a1,0(a5)
 966:	855a                	mv	a0,s6
 968:	00000097          	auipc	ra,0x0
 96c:	ce8080e7          	jalr	-792(ra) # 650 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 970:	0992                	slli	s3,s3,0x4
 972:	34fd                	addiw	s1,s1,-1
 974:	f4e5                	bnez	s1,95c <vprintf+0x250>
        printptr(fd, va_arg(ap, uint64));
 976:	8bea                	mv	s7,s10
      state = 0;
 978:	4981                	li	s3,0
 97a:	6d02                	ld	s10,0(sp)
 97c:	bbf9                	j	75a <vprintf+0x4e>
        if((s = va_arg(ap, char*)) == 0)
 97e:	008b8993          	addi	s3,s7,8
 982:	000bb483          	ld	s1,0(s7)
 986:	c085                	beqz	s1,9a6 <vprintf+0x29a>
        for(; *s; s++)
 988:	0004c583          	lbu	a1,0(s1)
 98c:	c585                	beqz	a1,9b4 <vprintf+0x2a8>
          putc(fd, *s);
 98e:	855a                	mv	a0,s6
 990:	00000097          	auipc	ra,0x0
 994:	cc0080e7          	jalr	-832(ra) # 650 <putc>
        for(; *s; s++)
 998:	0485                	addi	s1,s1,1
 99a:	0004c583          	lbu	a1,0(s1)
 99e:	f9e5                	bnez	a1,98e <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
 9a0:	8bce                	mv	s7,s3
      state = 0;
 9a2:	4981                	li	s3,0
 9a4:	bb5d                	j	75a <vprintf+0x4e>
          s = "(null)";
 9a6:	00000497          	auipc	s1,0x0
 9aa:	28248493          	addi	s1,s1,642 # c28 <malloc+0x16a>
        for(; *s; s++)
 9ae:	02800593          	li	a1,40
 9b2:	bff1                	j	98e <vprintf+0x282>
        if((s = va_arg(ap, char*)) == 0)
 9b4:	8bce                	mv	s7,s3
      state = 0;
 9b6:	4981                	li	s3,0
 9b8:	b34d                	j	75a <vprintf+0x4e>
 9ba:	6906                	ld	s2,64(sp)
 9bc:	79e2                	ld	s3,56(sp)
 9be:	7a42                	ld	s4,48(sp)
 9c0:	7aa2                	ld	s5,40(sp)
 9c2:	7b02                	ld	s6,32(sp)
 9c4:	6be2                	ld	s7,24(sp)
 9c6:	6c42                	ld	s8,16(sp)
 9c8:	6ca2                	ld	s9,8(sp)
    }
  }
}
 9ca:	60e6                	ld	ra,88(sp)
 9cc:	6446                	ld	s0,80(sp)
 9ce:	64a6                	ld	s1,72(sp)
 9d0:	6125                	addi	sp,sp,96
 9d2:	8082                	ret

00000000000009d4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9d4:	715d                	addi	sp,sp,-80
 9d6:	ec06                	sd	ra,24(sp)
 9d8:	e822                	sd	s0,16(sp)
 9da:	1000                	addi	s0,sp,32
 9dc:	e010                	sd	a2,0(s0)
 9de:	e414                	sd	a3,8(s0)
 9e0:	e818                	sd	a4,16(s0)
 9e2:	ec1c                	sd	a5,24(s0)
 9e4:	03043023          	sd	a6,32(s0)
 9e8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9ec:	8622                	mv	a2,s0
 9ee:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9f2:	00000097          	auipc	ra,0x0
 9f6:	d1a080e7          	jalr	-742(ra) # 70c <vprintf>
}
 9fa:	60e2                	ld	ra,24(sp)
 9fc:	6442                	ld	s0,16(sp)
 9fe:	6161                	addi	sp,sp,80
 a00:	8082                	ret

0000000000000a02 <printf>:

void
printf(const char *fmt, ...)
{
 a02:	711d                	addi	sp,sp,-96
 a04:	ec06                	sd	ra,24(sp)
 a06:	e822                	sd	s0,16(sp)
 a08:	1000                	addi	s0,sp,32
 a0a:	e40c                	sd	a1,8(s0)
 a0c:	e810                	sd	a2,16(s0)
 a0e:	ec14                	sd	a3,24(s0)
 a10:	f018                	sd	a4,32(s0)
 a12:	f41c                	sd	a5,40(s0)
 a14:	03043823          	sd	a6,48(s0)
 a18:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a1c:	00840613          	addi	a2,s0,8
 a20:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a24:	85aa                	mv	a1,a0
 a26:	4505                	li	a0,1
 a28:	00000097          	auipc	ra,0x0
 a2c:	ce4080e7          	jalr	-796(ra) # 70c <vprintf>
}
 a30:	60e2                	ld	ra,24(sp)
 a32:	6442                	ld	s0,16(sp)
 a34:	6125                	addi	sp,sp,96
 a36:	8082                	ret

0000000000000a38 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a38:	1141                	addi	sp,sp,-16
 a3a:	e406                	sd	ra,8(sp)
 a3c:	e022                	sd	s0,0(sp)
 a3e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a40:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a44:	00001797          	auipc	a5,0x1
 a48:	5bc7b783          	ld	a5,1468(a5) # 2000 <freep>
 a4c:	a02d                	j	a76 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a4e:	4618                	lw	a4,8(a2)
 a50:	9f2d                	addw	a4,a4,a1
 a52:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a56:	6398                	ld	a4,0(a5)
 a58:	6310                	ld	a2,0(a4)
 a5a:	a83d                	j	a98 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a5c:	ff852703          	lw	a4,-8(a0)
 a60:	9f31                	addw	a4,a4,a2
 a62:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a64:	ff053683          	ld	a3,-16(a0)
 a68:	a091                	j	aac <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a6a:	6398                	ld	a4,0(a5)
 a6c:	00e7e463          	bltu	a5,a4,a74 <free+0x3c>
 a70:	00e6ea63          	bltu	a3,a4,a84 <free+0x4c>
{
 a74:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a76:	fed7fae3          	bgeu	a5,a3,a6a <free+0x32>
 a7a:	6398                	ld	a4,0(a5)
 a7c:	00e6e463          	bltu	a3,a4,a84 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a80:	fee7eae3          	bltu	a5,a4,a74 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 a84:	ff852583          	lw	a1,-8(a0)
 a88:	6390                	ld	a2,0(a5)
 a8a:	02059813          	slli	a6,a1,0x20
 a8e:	01c85713          	srli	a4,a6,0x1c
 a92:	9736                	add	a4,a4,a3
 a94:	fae60de3          	beq	a2,a4,a4e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 a98:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a9c:	4790                	lw	a2,8(a5)
 a9e:	02061593          	slli	a1,a2,0x20
 aa2:	01c5d713          	srli	a4,a1,0x1c
 aa6:	973e                	add	a4,a4,a5
 aa8:	fae68ae3          	beq	a3,a4,a5c <free+0x24>
    p->s.ptr = bp->s.ptr;
 aac:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 aae:	00001717          	auipc	a4,0x1
 ab2:	54f73923          	sd	a5,1362(a4) # 2000 <freep>
}
 ab6:	60a2                	ld	ra,8(sp)
 ab8:	6402                	ld	s0,0(sp)
 aba:	0141                	addi	sp,sp,16
 abc:	8082                	ret

0000000000000abe <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 abe:	7139                	addi	sp,sp,-64
 ac0:	fc06                	sd	ra,56(sp)
 ac2:	f822                	sd	s0,48(sp)
 ac4:	f04a                	sd	s2,32(sp)
 ac6:	ec4e                	sd	s3,24(sp)
 ac8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 aca:	02051993          	slli	s3,a0,0x20
 ace:	0209d993          	srli	s3,s3,0x20
 ad2:	09bd                	addi	s3,s3,15
 ad4:	0049d993          	srli	s3,s3,0x4
 ad8:	2985                	addiw	s3,s3,1
 ada:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 adc:	00001517          	auipc	a0,0x1
 ae0:	52453503          	ld	a0,1316(a0) # 2000 <freep>
 ae4:	c905                	beqz	a0,b14 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ae6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ae8:	4798                	lw	a4,8(a5)
 aea:	09377a63          	bgeu	a4,s3,b7e <malloc+0xc0>
 aee:	f426                	sd	s1,40(sp)
 af0:	e852                	sd	s4,16(sp)
 af2:	e456                	sd	s5,8(sp)
 af4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 af6:	8a4e                	mv	s4,s3
 af8:	6705                	lui	a4,0x1
 afa:	00e9f363          	bgeu	s3,a4,b00 <malloc+0x42>
 afe:	6a05                	lui	s4,0x1
 b00:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b04:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b08:	00001497          	auipc	s1,0x1
 b0c:	4f848493          	addi	s1,s1,1272 # 2000 <freep>
  if(p == (char*)-1)
 b10:	5afd                	li	s5,-1
 b12:	a089                	j	b54 <malloc+0x96>
 b14:	f426                	sd	s1,40(sp)
 b16:	e852                	sd	s4,16(sp)
 b18:	e456                	sd	s5,8(sp)
 b1a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b1c:	00001797          	auipc	a5,0x1
 b20:	4f478793          	addi	a5,a5,1268 # 2010 <base>
 b24:	00001717          	auipc	a4,0x1
 b28:	4cf73e23          	sd	a5,1244(a4) # 2000 <freep>
 b2c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b2e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b32:	b7d1                	j	af6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 b34:	6398                	ld	a4,0(a5)
 b36:	e118                	sd	a4,0(a0)
 b38:	a8b9                	j	b96 <malloc+0xd8>
  hp->s.size = nu;
 b3a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b3e:	0541                	addi	a0,a0,16
 b40:	00000097          	auipc	ra,0x0
 b44:	ef8080e7          	jalr	-264(ra) # a38 <free>
  return freep;
 b48:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 b4a:	c135                	beqz	a0,bae <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b4c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b4e:	4798                	lw	a4,8(a5)
 b50:	03277363          	bgeu	a4,s2,b76 <malloc+0xb8>
    if(p == freep)
 b54:	6098                	ld	a4,0(s1)
 b56:	853e                	mv	a0,a5
 b58:	fef71ae3          	bne	a4,a5,b4c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 b5c:	8552                	mv	a0,s4
 b5e:	00000097          	auipc	ra,0x0
 b62:	aca080e7          	jalr	-1334(ra) # 628 <sbrk>
  if(p == (char*)-1)
 b66:	fd551ae3          	bne	a0,s5,b3a <malloc+0x7c>
        return 0;
 b6a:	4501                	li	a0,0
 b6c:	74a2                	ld	s1,40(sp)
 b6e:	6a42                	ld	s4,16(sp)
 b70:	6aa2                	ld	s5,8(sp)
 b72:	6b02                	ld	s6,0(sp)
 b74:	a03d                	j	ba2 <malloc+0xe4>
 b76:	74a2                	ld	s1,40(sp)
 b78:	6a42                	ld	s4,16(sp)
 b7a:	6aa2                	ld	s5,8(sp)
 b7c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b7e:	fae90be3          	beq	s2,a4,b34 <malloc+0x76>
        p->s.size -= nunits;
 b82:	4137073b          	subw	a4,a4,s3
 b86:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b88:	02071693          	slli	a3,a4,0x20
 b8c:	01c6d713          	srli	a4,a3,0x1c
 b90:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b92:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b96:	00001717          	auipc	a4,0x1
 b9a:	46a73523          	sd	a0,1130(a4) # 2000 <freep>
      return (void*)(p + 1);
 b9e:	01078513          	addi	a0,a5,16
  }
}
 ba2:	70e2                	ld	ra,56(sp)
 ba4:	7442                	ld	s0,48(sp)
 ba6:	7902                	ld	s2,32(sp)
 ba8:	69e2                	ld	s3,24(sp)
 baa:	6121                	addi	sp,sp,64
 bac:	8082                	ret
 bae:	74a2                	ld	s1,40(sp)
 bb0:	6a42                	ld	s4,16(sp)
 bb2:	6aa2                	ld	s5,8(sp)
 bb4:	6b02                	ld	s6,0(sp)
 bb6:	b7f5                	j	ba2 <malloc+0xe4>
