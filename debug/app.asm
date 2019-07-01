
bin/app.elf:     file format elf32-littlearm


Disassembly of section .text:

c0d00000 <main>:
  END_TRY_L(exit);
}

/* -------------------------------------------------------------- */

__attribute__((section(".boot"))) int main(void) {
c0d00000:	b5b0      	push	{r4, r5, r7, lr}
c0d00002:	b08c      	sub	sp, #48	; 0x30
  // exit critical section
  __asm volatile("cpsie i");
c0d00004:	b662      	cpsie	i


  // ensure exception will work as planned
  os_boot();
c0d00006:	f003 fcd9 	bl	c0d039bc <os_boot>
c0d0000a:	4c11      	ldr	r4, [pc, #68]	; (c0d00050 <main+0x50>)
c0d0000c:	2100      	movs	r1, #0
c0d0000e:	22b0      	movs	r2, #176	; 0xb0
  for(;;) {
    UX_INIT();
c0d00010:	4620      	mov	r0, r4
c0d00012:	f003 fdb5 	bl	c0d03b80 <os_memset>
c0d00016:	ad01      	add	r5, sp, #4

    BEGIN_TRY {
      TRY {
c0d00018:	4628      	mov	r0, r5
c0d0001a:	f006 fcc7 	bl	c0d069ac <setjmp>
c0d0001e:	8528      	strh	r0, [r5, #40]	; 0x28
c0d00020:	b280      	uxth	r0, r0
c0d00022:	2800      	cmp	r0, #0
c0d00024:	d006      	beq.n	c0d00034 <main+0x34>
c0d00026:	2810      	cmp	r0, #16
c0d00028:	d0f0      	beq.n	c0d0000c <main+0xc>
      FINALLY {
      }
    }
    END_TRY;
  }
  app_exit();
c0d0002a:	f002 fbab 	bl	c0d02784 <app_exit>
c0d0002e:	2000      	movs	r0, #0
}
c0d00030:	b00c      	add	sp, #48	; 0x30
c0d00032:	bdb0      	pop	{r4, r5, r7, pc}
c0d00034:	a801      	add	r0, sp, #4
  os_boot();
  for(;;) {
    UX_INIT();

    BEGIN_TRY {
      TRY {
c0d00036:	f003 fcc4 	bl	c0d039c2 <try_context_set>
      
        //start communication with MCU
        io_seproxyhal_init();
c0d0003a:	f003 ffaf 	bl	c0d03f9c <io_seproxyhal_init>
c0d0003e:	2001      	movs	r0, #1

        USB_power(1);
c0d00040:	f006 f9c0 	bl	c0d063c4 <USB_power>
        io_usb_ccid_set_card_inserted(1);
        #endif
  

        //set up
        monero_init();
c0d00044:	f001 f922 	bl	c0d0128c <monero_init>
  
        //set up initial screen
        ui_init();
c0d00048:	f003 fca4 	bl	c0d03994 <ui_init>
        //start the application
        //the first exchange will:
        // - display the  initial screen
        // - send the ATR
        // - receive the first command
        monero_main();
c0d0004c:	f002 f84e 	bl	c0d020ec <monero_main>
c0d00050:	20001880 	.word	0x20001880

c0d00054 <monero_apdu_blind>:
#include "monero_vars.h"

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_blind() {
c0d00054:	b5b0      	push	{r4, r5, r7, lr}
c0d00056:	b098      	sub	sp, #96	; 0x60
c0d00058:	4668      	mov	r0, sp
c0d0005a:	2420      	movs	r4, #32
    unsigned char v[32];
    unsigned char k[32];
    unsigned char AKout[32];

    monero_io_fetch_decrypt(AKout,32);
c0d0005c:	4621      	mov	r1, r4
c0d0005e:	f001 faef 	bl	c0d01640 <monero_io_fetch_decrypt>
c0d00062:	a808      	add	r0, sp, #32
    monero_io_fetch(k,32);
c0d00064:	4621      	mov	r1, r4
c0d00066:	f001 facf 	bl	c0d01608 <monero_io_fetch>
c0d0006a:	a810      	add	r0, sp, #64	; 0x40
    monero_io_fetch(v,32);
c0d0006c:	4621      	mov	r1, r4
c0d0006e:	f001 facb 	bl	c0d01608 <monero_io_fetch>
c0d00072:	2001      	movs	r0, #1

    monero_io_discard(1);
c0d00074:	f001 fa32 	bl	c0d014dc <monero_io_discard>
c0d00078:	204f      	movs	r0, #79	; 0x4f
c0d0007a:	0080      	lsls	r0, r0, #2

    if ((G_monero_vstate.options&0x03)==2) {
c0d0007c:	491e      	ldr	r1, [pc, #120]	; (c0d000f8 <monero_apdu_blind+0xa4>)
c0d0007e:	5808      	ldr	r0, [r1, r0]
c0d00080:	2103      	movs	r1, #3
c0d00082:	4001      	ands	r1, r0
c0d00084:	2902      	cmp	r1, #2
c0d00086:	d113      	bne.n	c0d000b0 <monero_apdu_blind+0x5c>
c0d00088:	a808      	add	r0, sp, #32
c0d0008a:	2400      	movs	r4, #0
c0d0008c:	2220      	movs	r2, #32
        os_memset(k,0,32);
c0d0008e:	4621      	mov	r1, r4
c0d00090:	f003 fd76 	bl	c0d03b80 <os_memset>
c0d00094:	4668      	mov	r0, sp
        monero_ecdhHash(AKout, AKout);
c0d00096:	4601      	mov	r1, r0
c0d00098:	f000 fe34 	bl	c0d00d04 <monero_ecdhHash>
c0d0009c:	a810      	add	r0, sp, #64	; 0x40
        for (int i = 0; i<8; i++){
            v[i] = v[i] ^ AKout[i];
c0d0009e:	5d01      	ldrb	r1, [r0, r4]
c0d000a0:	466a      	mov	r2, sp
c0d000a2:	5d12      	ldrb	r2, [r2, r4]
c0d000a4:	404a      	eors	r2, r1
c0d000a6:	5502      	strb	r2, [r0, r4]
    monero_io_discard(1);

    if ((G_monero_vstate.options&0x03)==2) {
        os_memset(k,0,32);
        monero_ecdhHash(AKout, AKout);
        for (int i = 0; i<8; i++){
c0d000a8:	1c64      	adds	r4, r4, #1
c0d000aa:	2c08      	cmp	r4, #8
c0d000ac:	d1f6      	bne.n	c0d0009c <monero_apdu_blind+0x48>
c0d000ae:	e015      	b.n	c0d000dc <monero_apdu_blind+0x88>
c0d000b0:	466c      	mov	r4, sp
c0d000b2:	2520      	movs	r5, #32
            v[i] = v[i] ^ AKout[i];
        }
    } else {
        //blind mask
        monero_hash_to_scalar(AKout, AKout, 32);
c0d000b4:	4620      	mov	r0, r4
c0d000b6:	4621      	mov	r1, r4
c0d000b8:	462a      	mov	r2, r5
c0d000ba:	f000 f941 	bl	c0d00340 <monero_hash_to_scalar>
c0d000be:	a808      	add	r0, sp, #32
        monero_addm(k,k,AKout);
c0d000c0:	4601      	mov	r1, r0
c0d000c2:	4622      	mov	r2, r4
c0d000c4:	f000 fc44 	bl	c0d00950 <monero_addm>
        //blind value
        monero_hash_to_scalar(AKout, AKout, 32);
c0d000c8:	4620      	mov	r0, r4
c0d000ca:	4621      	mov	r1, r4
c0d000cc:	462a      	mov	r2, r5
c0d000ce:	f000 f937 	bl	c0d00340 <monero_hash_to_scalar>
c0d000d2:	a810      	add	r0, sp, #64	; 0x40
        monero_addm(v,v,AKout);
c0d000d4:	4601      	mov	r1, r0
c0d000d6:	4622      	mov	r2, r4
c0d000d8:	f000 fc3a 	bl	c0d00950 <monero_addm>
c0d000dc:	a810      	add	r0, sp, #64	; 0x40
c0d000de:	2420      	movs	r4, #32
    }
    //ret all
    monero_io_insert(v,32);
c0d000e0:	4621      	mov	r1, r4
c0d000e2:	f001 fa27 	bl	c0d01534 <monero_io_insert>
c0d000e6:	a808      	add	r0, sp, #32
    monero_io_insert(k,32);
c0d000e8:	4621      	mov	r1, r4
c0d000ea:	f001 fa23 	bl	c0d01534 <monero_io_insert>
c0d000ee:	2009      	movs	r0, #9
c0d000f0:	0300      	lsls	r0, r0, #12

    return SW_OK;
c0d000f2:	b018      	add	sp, #96	; 0x60
c0d000f4:	bdb0      	pop	{r4, r5, r7, pc}
c0d000f6:	46c0      	nop			; (mov r8, r8)
c0d000f8:	20001930 	.word	0x20001930

c0d000fc <monero_unblind>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_unblind(unsigned char *v, unsigned char *k, unsigned char *AKout, unsigned int short_amount) {
c0d000fc:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d000fe:	b081      	sub	sp, #4
c0d00100:	4614      	mov	r4, r2
c0d00102:	460e      	mov	r6, r1
c0d00104:	4605      	mov	r5, r0
    if (short_amount==2) {
c0d00106:	2b02      	cmp	r3, #2
c0d00108:	d110      	bne.n	c0d0012c <monero_unblind+0x30>
        monero_genCommitmentMask(k,AKout);
c0d0010a:	4630      	mov	r0, r6
c0d0010c:	4621      	mov	r1, r4
c0d0010e:	f000 fe27 	bl	c0d00d60 <monero_genCommitmentMask>
        monero_ecdhHash(AKout, AKout);
c0d00112:	4620      	mov	r0, r4
c0d00114:	4621      	mov	r1, r4
c0d00116:	f000 fdf5 	bl	c0d00d04 <monero_ecdhHash>
c0d0011a:	2000      	movs	r0, #0
        for (int i = 0; i<8; i++) {
            v[i] = v[i] ^ AKout[i];
c0d0011c:	5c29      	ldrb	r1, [r5, r0]
c0d0011e:	5c22      	ldrb	r2, [r4, r0]
c0d00120:	404a      	eors	r2, r1
c0d00122:	542a      	strb	r2, [r5, r0]
/* ----------------------------------------------------------------------- */
int monero_unblind(unsigned char *v, unsigned char *k, unsigned char *AKout, unsigned int short_amount) {
    if (short_amount==2) {
        monero_genCommitmentMask(k,AKout);
        monero_ecdhHash(AKout, AKout);
        for (int i = 0; i<8; i++) {
c0d00124:	1c40      	adds	r0, r0, #1
c0d00126:	2808      	cmp	r0, #8
c0d00128:	d1f8      	bne.n	c0d0011c <monero_unblind+0x20>
c0d0012a:	e014      	b.n	c0d00156 <monero_unblind+0x5a>
c0d0012c:	2720      	movs	r7, #32
            v[i] = v[i] ^ AKout[i];
        }
    } else {
        //unblind mask
        monero_hash_to_scalar(AKout, AKout, 32);
c0d0012e:	4620      	mov	r0, r4
c0d00130:	4621      	mov	r1, r4
c0d00132:	463a      	mov	r2, r7
c0d00134:	f000 f904 	bl	c0d00340 <monero_hash_to_scalar>
        monero_subm(k,k,AKout);
c0d00138:	4630      	mov	r0, r6
c0d0013a:	4631      	mov	r1, r6
c0d0013c:	4622      	mov	r2, r4
c0d0013e:	f000 fe29 	bl	c0d00d94 <monero_subm>
        //unblind value
        monero_hash_to_scalar(AKout, AKout, 32);
c0d00142:	4620      	mov	r0, r4
c0d00144:	4621      	mov	r1, r4
c0d00146:	463a      	mov	r2, r7
c0d00148:	f000 f8fa 	bl	c0d00340 <monero_hash_to_scalar>
        monero_subm(v,v,AKout);
c0d0014c:	4628      	mov	r0, r5
c0d0014e:	4629      	mov	r1, r5
c0d00150:	4622      	mov	r2, r4
c0d00152:	f000 fe1f 	bl	c0d00d94 <monero_subm>
c0d00156:	2000      	movs	r0, #0
    }
    return 0;
c0d00158:	b001      	add	sp, #4
c0d0015a:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d0015c <monero_apdu_unblind>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_unblind() {
c0d0015c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0015e:	b099      	sub	sp, #100	; 0x64
c0d00160:	ae01      	add	r6, sp, #4
c0d00162:	2420      	movs	r4, #32
    unsigned char v[32];
    unsigned char k[32];
    unsigned char AKout[32];

    monero_io_fetch_decrypt(AKout,32);
c0d00164:	4630      	mov	r0, r6
c0d00166:	4621      	mov	r1, r4
c0d00168:	f001 fa6a 	bl	c0d01640 <monero_io_fetch_decrypt>
c0d0016c:	ad09      	add	r5, sp, #36	; 0x24
    monero_io_fetch(k,32);
c0d0016e:	4628      	mov	r0, r5
c0d00170:	4621      	mov	r1, r4
c0d00172:	f001 fa49 	bl	c0d01608 <monero_io_fetch>
c0d00176:	af11      	add	r7, sp, #68	; 0x44
    monero_io_fetch(v,32);
c0d00178:	4638      	mov	r0, r7
c0d0017a:	4621      	mov	r1, r4
c0d0017c:	f001 fa44 	bl	c0d01608 <monero_io_fetch>
c0d00180:	2001      	movs	r0, #1

    monero_io_discard(1);
c0d00182:	f001 f9ab 	bl	c0d014dc <monero_io_discard>
c0d00186:	204f      	movs	r0, #79	; 0x4f
c0d00188:	0080      	lsls	r0, r0, #2

    monero_unblind(v, k, AKout, G_monero_vstate.options&0x03);
c0d0018a:	490a      	ldr	r1, [pc, #40]	; (c0d001b4 <monero_apdu_unblind+0x58>)
c0d0018c:	5808      	ldr	r0, [r1, r0]
c0d0018e:	2303      	movs	r3, #3
c0d00190:	4003      	ands	r3, r0
c0d00192:	4638      	mov	r0, r7
c0d00194:	4629      	mov	r1, r5
c0d00196:	4632      	mov	r2, r6
c0d00198:	f7ff ffb0 	bl	c0d000fc <monero_unblind>

    //ret all
    monero_io_insert(v,32);
c0d0019c:	4638      	mov	r0, r7
c0d0019e:	4621      	mov	r1, r4
c0d001a0:	f001 f9c8 	bl	c0d01534 <monero_io_insert>
    monero_io_insert(k,32);
c0d001a4:	4628      	mov	r0, r5
c0d001a6:	4621      	mov	r1, r4
c0d001a8:	f001 f9c4 	bl	c0d01534 <monero_io_insert>
c0d001ac:	2009      	movs	r0, #9
c0d001ae:	0300      	lsls	r0, r0, #12

    return SW_OK;
c0d001b0:	b019      	add	sp, #100	; 0x64
c0d001b2:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d001b4:	20001930 	.word	0x20001930

c0d001b8 <monero_apdu_gen_commitment_mask>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_gen_commitment_mask() {
c0d001b8:	b570      	push	{r4, r5, r6, lr}
c0d001ba:	b090      	sub	sp, #64	; 0x40
c0d001bc:	466d      	mov	r5, sp
c0d001be:	2420      	movs	r4, #32
    unsigned char k[32];
    unsigned char AKout[32];

    monero_io_fetch_decrypt(AKout,32);
c0d001c0:	4628      	mov	r0, r5
c0d001c2:	4621      	mov	r1, r4
c0d001c4:	f001 fa3c 	bl	c0d01640 <monero_io_fetch_decrypt>
c0d001c8:	2001      	movs	r0, #1
    monero_io_discard(1);
c0d001ca:	f001 f987 	bl	c0d014dc <monero_io_discard>
c0d001ce:	ae08      	add	r6, sp, #32
    monero_genCommitmentMask(k,AKout);
c0d001d0:	4630      	mov	r0, r6
c0d001d2:	4629      	mov	r1, r5
c0d001d4:	f000 fdc4 	bl	c0d00d60 <monero_genCommitmentMask>

    //ret all
    monero_io_insert(k,32);
c0d001d8:	4630      	mov	r0, r6
c0d001da:	4621      	mov	r1, r4
c0d001dc:	f001 f9aa 	bl	c0d01534 <monero_io_insert>
c0d001e0:	2009      	movs	r0, #9
c0d001e2:	0300      	lsls	r0, r0, #12

    return SW_OK;
c0d001e4:	b010      	add	sp, #64	; 0x40
c0d001e6:	bd70      	pop	{r4, r5, r6, pc}

c0d001e8 <monero_aes_derive>:
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08};

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_aes_derive(cx_aes_key_t *sk, unsigned char* seed32, unsigned char *a, unsigned char *b) {
c0d001e8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d001ea:	b091      	sub	sp, #68	; 0x44
c0d001ec:	9305      	str	r3, [sp, #20]
c0d001ee:	9203      	str	r2, [sp, #12]
c0d001f0:	460c      	mov	r4, r1
c0d001f2:	9008      	str	r0, [sp, #32]
c0d001f4:	207b      	movs	r0, #123	; 0x7b
c0d001f6:	00c0      	lsls	r0, r0, #3
void monero_hash_init_sha256(cx_hash_t * hasher) {
    cx_sha256_init((cx_sha256_t *)hasher);
}

void monero_hash_init_keccak(cx_hash_t * hasher) {
    cx_keccak_init((cx_sha3_t *)hasher, 256);
c0d001f8:	9007      	str	r0, [sp, #28]
c0d001fa:	4923      	ldr	r1, [pc, #140]	; (c0d00288 <_nvram_data_size+0x8>)
c0d001fc:	180d      	adds	r5, r1, r0
c0d001fe:	2001      	movs	r0, #1
c0d00200:	9004      	str	r0, [sp, #16]
c0d00202:	0201      	lsls	r1, r0, #8
c0d00204:	9106      	str	r1, [sp, #24]
c0d00206:	4628      	mov	r0, r5
c0d00208:	f004 fc52 	bl	c0d04ab0 <cx_keccak_init>
c0d0020c:	2700      	movs	r7, #0

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_hash_update(cx_hash_t * hasher, unsigned char* buf, unsigned int len) {
    cx_hash(hasher, 0, buf, len, NULL, 0);
c0d0020e:	4668      	mov	r0, sp
c0d00210:	6007      	str	r7, [r0, #0]
c0d00212:	6047      	str	r7, [r0, #4]
c0d00214:	2620      	movs	r6, #32
c0d00216:	4628      	mov	r0, r5
c0d00218:	4639      	mov	r1, r7
c0d0021a:	4622      	mov	r2, r4
c0d0021c:	4633      	mov	r3, r6
c0d0021e:	f004 fc15 	bl	c0d04a4c <cx_hash>
c0d00222:	4668      	mov	r0, sp
c0d00224:	6007      	str	r7, [r0, #0]
c0d00226:	6047      	str	r7, [r0, #4]
c0d00228:	4628      	mov	r0, r5
c0d0022a:	4639      	mov	r1, r7
c0d0022c:	9a03      	ldr	r2, [sp, #12]
c0d0022e:	4633      	mov	r3, r6
c0d00230:	f004 fc0c 	bl	c0d04a4c <cx_hash>
c0d00234:	4668      	mov	r0, sp
c0d00236:	6007      	str	r7, [r0, #0]
c0d00238:	6047      	str	r7, [r0, #4]
c0d0023a:	4628      	mov	r0, r5
c0d0023c:	4639      	mov	r1, r7
c0d0023e:	9a05      	ldr	r2, [sp, #20]
c0d00240:	4633      	mov	r3, r6
c0d00242:	f004 fc03 	bl	c0d04a4c <cx_hash>

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_hash_final(cx_hash_t * hasher, unsigned char* out) {
    return cx_hash(hasher, CX_LAST, NULL, 0, out, 32);
c0d00246:	4668      	mov	r0, sp
c0d00248:	6046      	str	r6, [r0, #4]
c0d0024a:	ac09      	add	r4, sp, #36	; 0x24
c0d0024c:	6004      	str	r4, [r0, #0]
c0d0024e:	4628      	mov	r0, r5
c0d00250:	9904      	ldr	r1, [sp, #16]
c0d00252:	463a      	mov	r2, r7
c0d00254:	463b      	mov	r3, r7
c0d00256:	f004 fbf9 	bl	c0d04a4c <cx_hash>
c0d0025a:	2006      	movs	r0, #6

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_hash(unsigned int algo, cx_hash_t * hasher, unsigned char* buf, unsigned int len, unsigned char* out) {
    hasher->algo = algo;
c0d0025c:	490a      	ldr	r1, [pc, #40]	; (c0d00288 <_nvram_data_size+0x8>)
c0d0025e:	9a07      	ldr	r2, [sp, #28]
c0d00260:	5488      	strb	r0, [r1, r2]
    if (algo == CX_SHA256) {
         cx_sha256_init((cx_sha256_t *)hasher);
    } else {
        cx_keccak_init((cx_sha3_t *)hasher, 256);
c0d00262:	4628      	mov	r0, r5
c0d00264:	9906      	ldr	r1, [sp, #24]
c0d00266:	f004 fc23 	bl	c0d04ab0 <cx_keccak_init>
    }
    return cx_hash(hasher, CX_LAST|CX_NO_REINIT, buf, len, out, 32);
c0d0026a:	4668      	mov	r0, sp
c0d0026c:	c050      	stmia	r0!, {r4, r6}
c0d0026e:	4907      	ldr	r1, [pc, #28]	; (c0d0028c <_nvram_data_size+0xc>)
c0d00270:	4628      	mov	r0, r5
c0d00272:	4622      	mov	r2, r4
c0d00274:	4633      	mov	r3, r6
c0d00276:	f004 fbe9 	bl	c0d04a4c <cx_hash>
c0d0027a:	2110      	movs	r1, #16
    monero_keccak_update_H(b, 32);
    monero_keccak_final_H(h1);

    monero_keccak_H(h1,32,h1);

    cx_aes_init_key(h1,16,sk);
c0d0027c:	4620      	mov	r0, r4
c0d0027e:	9a08      	ldr	r2, [sp, #32]

c0d00280 <_nvram_data_size>:
c0d00280:	f004 fc2e 	bl	c0d04ae0 <cx_aes_init_key>
}
c0d00284:	b011      	add	sp, #68	; 0x44
c0d00286:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00288:	20001930 	.word	0x20001930
c0d0028c:	00008001 	.word	0x00008001

c0d00290 <monero_hash_init_keccak>:
/* ----------------------------------------------------------------------- */
void monero_hash_init_sha256(cx_hash_t * hasher) {
    cx_sha256_init((cx_sha256_t *)hasher);
}

void monero_hash_init_keccak(cx_hash_t * hasher) {
c0d00290:	b580      	push	{r7, lr}
c0d00292:	2101      	movs	r1, #1
c0d00294:	0209      	lsls	r1, r1, #8
    cx_keccak_init((cx_sha3_t *)hasher, 256);
c0d00296:	f004 fc0b 	bl	c0d04ab0 <cx_keccak_init>
}
c0d0029a:	bd80      	pop	{r7, pc}

c0d0029c <monero_hash_update>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_hash_update(cx_hash_t * hasher, unsigned char* buf, unsigned int len) {
c0d0029c:	b510      	push	{r4, lr}
c0d0029e:	b082      	sub	sp, #8
c0d002a0:	4613      	mov	r3, r2
c0d002a2:	460a      	mov	r2, r1
c0d002a4:	2100      	movs	r1, #0
    cx_hash(hasher, 0, buf, len, NULL, 0);
c0d002a6:	466c      	mov	r4, sp
c0d002a8:	6021      	str	r1, [r4, #0]
c0d002aa:	6061      	str	r1, [r4, #4]
c0d002ac:	f004 fbce 	bl	c0d04a4c <cx_hash>
}
c0d002b0:	b002      	add	sp, #8
c0d002b2:	bd10      	pop	{r4, pc}

c0d002b4 <monero_hash_final>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_hash_final(cx_hash_t * hasher, unsigned char* out) {
c0d002b4:	b580      	push	{r7, lr}
c0d002b6:	b082      	sub	sp, #8
c0d002b8:	2220      	movs	r2, #32
    return cx_hash(hasher, CX_LAST, NULL, 0, out, 32);
c0d002ba:	466b      	mov	r3, sp
c0d002bc:	c306      	stmia	r3!, {r1, r2}
c0d002be:	2101      	movs	r1, #1
c0d002c0:	2200      	movs	r2, #0
c0d002c2:	4613      	mov	r3, r2
c0d002c4:	f004 fbc2 	bl	c0d04a4c <cx_hash>
c0d002c8:	b002      	add	sp, #8
c0d002ca:	bd80      	pop	{r7, pc}

c0d002cc <monero_hash>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_hash(unsigned int algo, cx_hash_t * hasher, unsigned char* buf, unsigned int len, unsigned char* out) {
c0d002cc:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d002ce:	b083      	sub	sp, #12
c0d002d0:	461c      	mov	r4, r3
c0d002d2:	4615      	mov	r5, r2
c0d002d4:	460e      	mov	r6, r1
    hasher->algo = algo;
c0d002d6:	7008      	strb	r0, [r1, #0]
c0d002d8:	9f08      	ldr	r7, [sp, #32]
    if (algo == CX_SHA256) {
c0d002da:	2803      	cmp	r0, #3
c0d002dc:	d103      	bne.n	c0d002e6 <monero_hash+0x1a>
         cx_sha256_init((cx_sha256_t *)hasher);
c0d002de:	4630      	mov	r0, r6
c0d002e0:	f004 fbd0 	bl	c0d04a84 <cx_sha256_init>
c0d002e4:	e004      	b.n	c0d002f0 <monero_hash+0x24>
c0d002e6:	2001      	movs	r0, #1
c0d002e8:	0201      	lsls	r1, r0, #8
    } else {
        cx_keccak_init((cx_sha3_t *)hasher, 256);
c0d002ea:	4630      	mov	r0, r6
c0d002ec:	f004 fbe0 	bl	c0d04ab0 <cx_keccak_init>
c0d002f0:	2020      	movs	r0, #32
    }
    return cx_hash(hasher, CX_LAST|CX_NO_REINIT, buf, len, out, 32);
c0d002f2:	4669      	mov	r1, sp
c0d002f4:	600f      	str	r7, [r1, #0]
c0d002f6:	6048      	str	r0, [r1, #4]
c0d002f8:	4903      	ldr	r1, [pc, #12]	; (c0d00308 <monero_hash+0x3c>)
c0d002fa:	4630      	mov	r0, r6
c0d002fc:	462a      	mov	r2, r5
c0d002fe:	4623      	mov	r3, r4
c0d00300:	f004 fba4 	bl	c0d04a4c <cx_hash>
c0d00304:	b003      	add	sp, #12
c0d00306:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00308:	00008001 	.word	0x00008001

c0d0030c <monero_rng>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */

void monero_rng(unsigned char *r,  int len) {
c0d0030c:	b580      	push	{r7, lr}
    cx_rng(r,len);
c0d0030e:	f004 fb85 	bl	c0d04a1c <cx_rng>
}
c0d00312:	bd80      	pop	{r7, pc}

c0d00314 <monero_encode_varint>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
unsigned int monero_encode_varint(unsigned char varint[8], unsigned int out_idx) {
c0d00314:	b510      	push	{r4, lr}
c0d00316:	2200      	movs	r2, #0
    unsigned int len;
    len = 0;
    while(out_idx >= 0x80) {
c0d00318:	2980      	cmp	r1, #128	; 0x80
c0d0031a:	d309      	bcc.n	c0d00330 <monero_encode_varint+0x1c>
c0d0031c:	2200      	movs	r2, #0
c0d0031e:	460b      	mov	r3, r1
c0d00320:	2480      	movs	r4, #128	; 0x80
        varint[len] = (out_idx & 0x7F) | 0x80;
c0d00322:	430c      	orrs	r4, r1
c0d00324:	5484      	strb	r4, [r0, r2]
        out_idx = out_idx>>7;
c0d00326:	09d9      	lsrs	r1, r3, #7
        len++;
c0d00328:	1c52      	adds	r2, r2, #1
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
unsigned int monero_encode_varint(unsigned char varint[8], unsigned int out_idx) {
    unsigned int len;
    len = 0;
    while(out_idx >= 0x80) {
c0d0032a:	0b9b      	lsrs	r3, r3, #14
c0d0032c:	460b      	mov	r3, r1
c0d0032e:	d1f7      	bne.n	c0d00320 <monero_encode_varint+0xc>
        varint[len] = (out_idx & 0x7F) | 0x80;
        out_idx = out_idx>>7;
        len++;
    }
    varint[len] = out_idx;
c0d00330:	5481      	strb	r1, [r0, r2]
    len++;
c0d00332:	1c50      	adds	r0, r2, #1
    return len;
c0d00334:	bd10      	pop	{r4, pc}

c0d00336 <monero_hash_init_sha256>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_hash_init_sha256(cx_hash_t * hasher) {
c0d00336:	b580      	push	{r7, lr}
    cx_sha256_init((cx_sha256_t *)hasher);
c0d00338:	f004 fba4 	bl	c0d04a84 <cx_sha256_init>
}
c0d0033c:	bd80      	pop	{r7, pc}
	...

c0d00340 <monero_hash_to_scalar>:
/* ======================================================================= */

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_hash_to_scalar(unsigned char *scalar, unsigned char *raw, unsigned int raw_len) {
c0d00340:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00342:	b083      	sub	sp, #12
c0d00344:	4615      	mov	r5, r2
c0d00346:	460e      	mov	r6, r1
c0d00348:	4604      	mov	r4, r0
c0d0034a:	2023      	movs	r0, #35	; 0x23
c0d0034c:	0100      	lsls	r0, r0, #4

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_hash(unsigned int algo, cx_hash_t * hasher, unsigned char* buf, unsigned int len, unsigned char* out) {
    hasher->algo = algo;
c0d0034e:	490c      	ldr	r1, [pc, #48]	; (c0d00380 <monero_hash_to_scalar+0x40>)
c0d00350:	2206      	movs	r2, #6
c0d00352:	540a      	strb	r2, [r1, r0]
c0d00354:	180f      	adds	r7, r1, r0
c0d00356:	2001      	movs	r0, #1
c0d00358:	0201      	lsls	r1, r0, #8
    if (algo == CX_SHA256) {
         cx_sha256_init((cx_sha256_t *)hasher);
    } else {
        cx_keccak_init((cx_sha3_t *)hasher, 256);
c0d0035a:	4638      	mov	r0, r7
c0d0035c:	f004 fba8 	bl	c0d04ab0 <cx_keccak_init>
c0d00360:	2020      	movs	r0, #32
    }
    return cx_hash(hasher, CX_LAST|CX_NO_REINIT, buf, len, out, 32);
c0d00362:	4669      	mov	r1, sp
c0d00364:	600c      	str	r4, [r1, #0]
c0d00366:	6048      	str	r0, [r1, #4]
c0d00368:	4906      	ldr	r1, [pc, #24]	; (c0d00384 <monero_hash_to_scalar+0x44>)
c0d0036a:	4638      	mov	r0, r7
c0d0036c:	4632      	mov	r2, r6
c0d0036e:	462b      	mov	r3, r5
c0d00370:	f004 fb6c 	bl	c0d04a4c <cx_hash>
/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_hash_to_scalar(unsigned char *scalar, unsigned char *raw, unsigned int raw_len) {
    monero_keccak_F(raw,raw_len,scalar);
    monero_reduce(scalar, scalar);
c0d00374:	4620      	mov	r0, r4
c0d00376:	4621      	mov	r1, r4
c0d00378:	f000 f806 	bl	c0d00388 <monero_reduce>
}
c0d0037c:	b003      	add	sp, #12
c0d0037e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00380:	20001930 	.word	0x20001930
c0d00384:	00008001 	.word	0x00008001

c0d00388 <monero_reduce>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reduce(unsigned char *r, unsigned char *a) {
c0d00388:	b570      	push	{r4, r5, r6, lr}
c0d0038a:	b088      	sub	sp, #32
c0d0038c:	4604      	mov	r4, r0
c0d0038e:	2000      	movs	r0, #0
c0d00390:	221f      	movs	r2, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00392:	5c0b      	ldrb	r3, [r1, r0]
        rscal[i]    = scal [31-i];
c0d00394:	5c8d      	ldrb	r5, [r1, r2]
c0d00396:	466e      	mov	r6, sp
c0d00398:	5435      	strb	r5, [r6, r0]
        rscal[31-i] = x;
c0d0039a:	54b3      	strb	r3, [r6, r2]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d0039c:	1e52      	subs	r2, r2, #1
c0d0039e:	1c40      	adds	r0, r0, #1
c0d003a0:	2810      	cmp	r0, #16
c0d003a2:	d1f6      	bne.n	c0d00392 <monero_reduce+0xa>
c0d003a4:	4668      	mov	r0, sp
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reduce(unsigned char *r, unsigned char *a) {
    unsigned char ra[32];
    monero_reverse32(ra,a);
    cx_math_modm(ra, 32, (unsigned char *)C_ED25519_ORDER, 32);
c0d003a6:	4a09      	ldr	r2, [pc, #36]	; (c0d003cc <monero_reduce+0x44>)
c0d003a8:	447a      	add	r2, pc
c0d003aa:	2120      	movs	r1, #32
c0d003ac:	460b      	mov	r3, r1
c0d003ae:	f004 fcbd 	bl	c0d04d2c <cx_math_modm>
c0d003b2:	2000      	movs	r0, #0
c0d003b4:	211f      	movs	r1, #31
c0d003b6:	466a      	mov	r2, sp
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d003b8:	5c13      	ldrb	r3, [r2, r0]
        rscal[i]    = scal [31-i];
c0d003ba:	5c52      	ldrb	r2, [r2, r1]
c0d003bc:	5422      	strb	r2, [r4, r0]
        rscal[31-i] = x;
c0d003be:	5463      	strb	r3, [r4, r1]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d003c0:	1e49      	subs	r1, r1, #1
c0d003c2:	1c40      	adds	r0, r0, #1
c0d003c4:	2810      	cmp	r0, #16
c0d003c6:	d1f6      	bne.n	c0d003b6 <monero_reduce+0x2e>
void monero_reduce(unsigned char *r, unsigned char *a) {
    unsigned char ra[32];
    monero_reverse32(ra,a);
    cx_math_modm(ra, 32, (unsigned char *)C_ED25519_ORDER, 32);
    monero_reverse32(r,ra);
}
c0d003c8:	b008      	add	sp, #32
c0d003ca:	bd70      	pop	{r4, r5, r6, pc}
c0d003cc:	0000670c 	.word	0x0000670c

c0d003d0 <monero_hash_to_ec>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_hash_to_ec(unsigned char *ec, unsigned char *ec_pub) {
c0d003d0:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d003d2:	b09d      	sub	sp, #116	; 0x74
c0d003d4:	460d      	mov	r5, r1
c0d003d6:	4604      	mov	r4, r0
c0d003d8:	2023      	movs	r0, #35	; 0x23
c0d003da:	0100      	lsls	r0, r0, #4

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_hash(unsigned int algo, cx_hash_t * hasher, unsigned char* buf, unsigned int len, unsigned char* out) {
    hasher->algo = algo;
c0d003dc:	4fe1      	ldr	r7, [pc, #900]	; (c0d00764 <monero_hash_to_ec+0x394>)
c0d003de:	2106      	movs	r1, #6
c0d003e0:	5439      	strb	r1, [r7, r0]
c0d003e2:	183e      	adds	r6, r7, r0
c0d003e4:	2001      	movs	r0, #1
c0d003e6:	0201      	lsls	r1, r0, #8
    if (algo == CX_SHA256) {
         cx_sha256_init((cx_sha256_t *)hasher);
    } else {
        cx_keccak_init((cx_sha3_t *)hasher, 256);
c0d003e8:	4630      	mov	r0, r6
c0d003ea:	f004 fb61 	bl	c0d04ab0 <cx_keccak_init>
c0d003ee:	2220      	movs	r2, #32
    }
    return cx_hash(hasher, CX_LAST|CX_NO_REINIT, buf, len, out, 32);
c0d003f0:	4668      	mov	r0, sp
c0d003f2:	6004      	str	r4, [r0, #0]
c0d003f4:	6042      	str	r2, [r0, #4]
c0d003f6:	49dc      	ldr	r1, [pc, #880]	; (c0d00768 <monero_hash_to_ec+0x398>)
c0d003f8:	4630      	mov	r0, r6
c0d003fa:	4616      	mov	r6, r2
c0d003fc:	462a      	mov	r2, r5
c0d003fe:	4633      	mov	r3, r6
c0d00400:	f004 fb24 	bl	c0d04a4c <cx_hash>
c0d00404:	2000      	movs	r0, #0
c0d00406:	211f      	movs	r1, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00408:	5c22      	ldrb	r2, [r4, r0]
        rscal[i]    = scal [31-i];
c0d0040a:	5c63      	ldrb	r3, [r4, r1]
c0d0040c:	183d      	adds	r5, r7, r0
c0d0040e:	73ab      	strb	r3, [r5, #14]
        rscal[31-i] = x;
c0d00410:	187b      	adds	r3, r7, r1
c0d00412:	739a      	strb	r2, [r3, #14]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00414:	1e49      	subs	r1, r1, #1
c0d00416:	1c40      	adds	r0, r0, #1
c0d00418:	290f      	cmp	r1, #15
c0d0041a:	d1f5      	bne.n	c0d00408 <monero_hash_to_ec+0x38>

    unsigned char sign;

    //cx works in BE
    monero_reverse32(u,bytes);
    cx_math_modm(u, 32, (unsigned char *)C_ED25519_FIELD, 32);
c0d0041c:	463d      	mov	r5, r7
c0d0041e:	350e      	adds	r5, #14
c0d00420:	4ad2      	ldr	r2, [pc, #840]	; (c0d0076c <monero_hash_to_ec+0x39c>)
c0d00422:	447a      	add	r2, pc
c0d00424:	920a      	str	r2, [sp, #40]	; 0x28
c0d00426:	4628      	mov	r0, r5
c0d00428:	4631      	mov	r1, r6
c0d0042a:	4633      	mov	r3, r6
c0d0042c:	f004 fc7e 	bl	c0d04d2c <cx_math_modm>

    //go on
    cx_math_multm(v, u, u, MOD);                           /* 2 * u^2 */
c0d00430:	4668      	mov	r0, sp
c0d00432:	6006      	str	r6, [r0, #0]
c0d00434:	960b      	str	r6, [sp, #44]	; 0x2c
c0d00436:	463e      	mov	r6, r7
c0d00438:	362e      	adds	r6, #46	; 0x2e
c0d0043a:	4630      	mov	r0, r6
c0d0043c:	4629      	mov	r1, r5
c0d0043e:	9506      	str	r5, [sp, #24]
c0d00440:	462a      	mov	r2, r5
c0d00442:	9d0a      	ldr	r5, [sp, #40]	; 0x28
c0d00444:	462b      	mov	r3, r5
c0d00446:	f004 fc3f 	bl	c0d04cc8 <cx_math_multm>
    cx_math_addm (v,  v, v, MOD);
c0d0044a:	4668      	mov	r0, sp
c0d0044c:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d0044e:	6001      	str	r1, [r0, #0]
c0d00450:	4630      	mov	r0, r6
c0d00452:	4631      	mov	r1, r6
c0d00454:	4632      	mov	r2, r6
c0d00456:	462b      	mov	r3, r5
c0d00458:	f004 fc06 	bl	c0d04c68 <cx_math_addm>

    os_memset    (w, 0, 32); w[31] = 1;                   /* w = 1 */
c0d0045c:	463d      	mov	r5, r7
c0d0045e:	354e      	adds	r5, #78	; 0x4e
c0d00460:	9508      	str	r5, [sp, #32]
c0d00462:	2100      	movs	r1, #0
c0d00464:	4628      	mov	r0, r5
c0d00466:	9a0b      	ldr	r2, [sp, #44]	; 0x2c
c0d00468:	f003 fb8a 	bl	c0d03b80 <os_memset>
c0d0046c:	206d      	movs	r0, #109	; 0x6d
c0d0046e:	2101      	movs	r1, #1
c0d00470:	9104      	str	r1, [sp, #16]
c0d00472:	5439      	strb	r1, [r7, r0]
    cx_math_addm (w, v, w,MOD );                          /* w = 2 * u^2 + 1 */
c0d00474:	4668      	mov	r0, sp
c0d00476:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d00478:	6001      	str	r1, [r0, #0]
c0d0047a:	4628      	mov	r0, r5
c0d0047c:	4631      	mov	r1, r6
c0d0047e:	462a      	mov	r2, r5
c0d00480:	9b0a      	ldr	r3, [sp, #40]	; 0x28
c0d00482:	f004 fbf1 	bl	c0d04c68 <cx_math_addm>
    cx_math_multm(x, w, w, MOD);                          /* w^2 */
c0d00486:	4668      	mov	r0, sp
c0d00488:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d0048a:	6001      	str	r1, [r0, #0]
c0d0048c:	4638      	mov	r0, r7
c0d0048e:	306e      	adds	r0, #110	; 0x6e
c0d00490:	9009      	str	r0, [sp, #36]	; 0x24
c0d00492:	4629      	mov	r1, r5
c0d00494:	462a      	mov	r2, r5
c0d00496:	9d0a      	ldr	r5, [sp, #40]	; 0x28
c0d00498:	462b      	mov	r3, r5
c0d0049a:	f004 fc15 	bl	c0d04cc8 <cx_math_multm>
    cx_math_multm(y, (unsigned char *)C_fe_ma2, v, MOD);  /* -2 * A^2 * u^2 */
c0d0049e:	4668      	mov	r0, sp
c0d004a0:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d004a2:	6001      	str	r1, [r0, #0]
c0d004a4:	4638      	mov	r0, r7
c0d004a6:	308e      	adds	r0, #142	; 0x8e
c0d004a8:	9005      	str	r0, [sp, #20]
c0d004aa:	49b1      	ldr	r1, [pc, #708]	; (c0d00770 <monero_hash_to_ec+0x3a0>)
c0d004ac:	4479      	add	r1, pc
c0d004ae:	9603      	str	r6, [sp, #12]
c0d004b0:	4632      	mov	r2, r6
c0d004b2:	462b      	mov	r3, r5
c0d004b4:	f004 fc08 	bl	c0d04cc8 <cx_math_multm>
    cx_math_addm (x, x, y, MOD);                          /* x = w^2 - 2 * A^2 * u^2 */
c0d004b8:	4668      	mov	r0, sp
c0d004ba:	9e0b      	ldr	r6, [sp, #44]	; 0x2c
c0d004bc:	6006      	str	r6, [r0, #0]
c0d004be:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d004c0:	4601      	mov	r1, r0
c0d004c2:	9a05      	ldr	r2, [sp, #20]
c0d004c4:	462b      	mov	r3, r5
c0d004c6:	f004 fbcf 	bl	c0d04c68 <cx_math_addm>

    //inline fe_divpowm1(r->X, w, x);     // (w / x)^(m + 1) => fe_divpowm1(r,u,v)
    #define _u w
    #define _v x
    cx_math_multm(v3, _v,   _v, MOD);
c0d004ca:	4668      	mov	r0, sp
c0d004cc:	6006      	str	r6, [r0, #0]
c0d004ce:	ad0c      	add	r5, sp, #48	; 0x30
c0d004d0:	4628      	mov	r0, r5
c0d004d2:	3020      	adds	r0, #32
c0d004d4:	9007      	str	r0, [sp, #28]
c0d004d6:	9909      	ldr	r1, [sp, #36]	; 0x24
c0d004d8:	460a      	mov	r2, r1
c0d004da:	9e0a      	ldr	r6, [sp, #40]	; 0x28
c0d004dc:	4633      	mov	r3, r6
c0d004de:	f004 fbf3 	bl	c0d04cc8 <cx_math_multm>
    cx_math_multm(v3,  v3,  _v, MOD);                       /* v3 = v^3 */
c0d004e2:	4668      	mov	r0, sp
c0d004e4:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d004e6:	6001      	str	r1, [r0, #0]
c0d004e8:	9807      	ldr	r0, [sp, #28]
c0d004ea:	4601      	mov	r1, r0
c0d004ec:	9a09      	ldr	r2, [sp, #36]	; 0x24
c0d004ee:	4633      	mov	r3, r6
c0d004f0:	f004 fbea 	bl	c0d04cc8 <cx_math_multm>
    cx_math_multm(uv7, v3,  v3, MOD);
c0d004f4:	4668      	mov	r0, sp
c0d004f6:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d004f8:	6001      	str	r1, [r0, #0]
c0d004fa:	4628      	mov	r0, r5
c0d004fc:	9907      	ldr	r1, [sp, #28]
c0d004fe:	460a      	mov	r2, r1
c0d00500:	4633      	mov	r3, r6
c0d00502:	f004 fbe1 	bl	c0d04cc8 <cx_math_multm>
    cx_math_multm(uv7, uv7, _v, MOD);
c0d00506:	4668      	mov	r0, sp
c0d00508:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d0050a:	6001      	str	r1, [r0, #0]
c0d0050c:	4628      	mov	r0, r5
c0d0050e:	4629      	mov	r1, r5
c0d00510:	9a09      	ldr	r2, [sp, #36]	; 0x24
c0d00512:	4633      	mov	r3, r6
c0d00514:	f004 fbd8 	bl	c0d04cc8 <cx_math_multm>
    cx_math_multm(uv7, uv7, _u, MOD);                     /* uv7 = uv^7 */
c0d00518:	4668      	mov	r0, sp
c0d0051a:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d0051c:	6001      	str	r1, [r0, #0]
c0d0051e:	4628      	mov	r0, r5
c0d00520:	4629      	mov	r1, r5
c0d00522:	9a08      	ldr	r2, [sp, #32]
c0d00524:	4633      	mov	r3, r6
c0d00526:	f004 fbcf 	bl	c0d04cc8 <cx_math_multm>
    cx_math_powm (uv7, uv7, (unsigned char *)C_fe_qm5div8, 32, MOD); /* (uv^7)^((q-5)/8)*/
c0d0052a:	4668      	mov	r0, sp
c0d0052c:	6006      	str	r6, [r0, #0]
c0d0052e:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d00530:	6041      	str	r1, [r0, #4]
c0d00532:	4a90      	ldr	r2, [pc, #576]	; (c0d00774 <monero_hash_to_ec+0x3a4>)
c0d00534:	447a      	add	r2, pc
c0d00536:	4628      	mov	r0, r5
c0d00538:	4629      	mov	r1, r5
c0d0053a:	9b0b      	ldr	r3, [sp, #44]	; 0x2c
c0d0053c:	f004 fbdc 	bl	c0d04cf8 <cx_math_powm>
    cx_math_multm(uv7, uv7, v3, MOD);
c0d00540:	4668      	mov	r0, sp
c0d00542:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d00544:	6001      	str	r1, [r0, #0]
c0d00546:	4628      	mov	r0, r5
c0d00548:	4629      	mov	r1, r5
c0d0054a:	9a07      	ldr	r2, [sp, #28]
c0d0054c:	9b0a      	ldr	r3, [sp, #40]	; 0x28
c0d0054e:	f004 fbbb 	bl	c0d04cc8 <cx_math_multm>
    cx_math_multm(rX,  uv7, w, MOD);                      /* u^(m+1)v^(-(m+1)) */
c0d00552:	4668      	mov	r0, sp
c0d00554:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d00556:	6001      	str	r1, [r0, #0]
c0d00558:	463e      	mov	r6, r7
c0d0055a:	36ce      	adds	r6, #206	; 0xce
c0d0055c:	4630      	mov	r0, r6
c0d0055e:	4629      	mov	r1, r5
c0d00560:	9a08      	ldr	r2, [sp, #32]
c0d00562:	9b0a      	ldr	r3, [sp, #40]	; 0x28
c0d00564:	f004 fbb0 	bl	c0d04cc8 <cx_math_multm>
    #undef _u
    #undef _v

    cx_math_multm(y, rX,rX, MOD);
c0d00568:	4668      	mov	r0, sp
c0d0056a:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d0056c:	6001      	str	r1, [r0, #0]
c0d0056e:	9d05      	ldr	r5, [sp, #20]
c0d00570:	4628      	mov	r0, r5
c0d00572:	4631      	mov	r1, r6
c0d00574:	9607      	str	r6, [sp, #28]
c0d00576:	4632      	mov	r2, r6
c0d00578:	9e0a      	ldr	r6, [sp, #40]	; 0x28
c0d0057a:	4633      	mov	r3, r6
c0d0057c:	f004 fba4 	bl	c0d04cc8 <cx_math_multm>
    cx_math_multm(x, y, x, MOD);
c0d00580:	4668      	mov	r0, sp
c0d00582:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d00584:	6001      	str	r1, [r0, #0]
c0d00586:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d00588:	4629      	mov	r1, r5
c0d0058a:	4602      	mov	r2, r0
c0d0058c:	4633      	mov	r3, r6
c0d0058e:	f004 fb9b 	bl	c0d04cc8 <cx_math_multm>
    cx_math_subm(y, w, x, MOD);
c0d00592:	4668      	mov	r0, sp
c0d00594:	9e0b      	ldr	r6, [sp, #44]	; 0x2c
c0d00596:	6006      	str	r6, [r0, #0]
c0d00598:	4628      	mov	r0, r5
c0d0059a:	ab08      	add	r3, sp, #32
c0d0059c:	cb0e      	ldmia	r3, {r1, r2, r3}
c0d0059e:	f004 fb7b 	bl	c0d04c98 <cx_math_subm>
    os_memmove(z, C_fe_ma, 32);
c0d005a2:	4638      	mov	r0, r7
c0d005a4:	30ae      	adds	r0, #174	; 0xae
c0d005a6:	4974      	ldr	r1, [pc, #464]	; (c0d00778 <monero_hash_to_ec+0x3a8>)
c0d005a8:	4479      	add	r1, pc
c0d005aa:	900a      	str	r0, [sp, #40]	; 0x28
c0d005ac:	4632      	mov	r2, r6
c0d005ae:	f003 faf0 	bl	c0d03b92 <os_memmove>

    if (!cx_math_is_zero(y,32)) {
c0d005b2:	4628      	mov	r0, r5
c0d005b4:	4631      	mov	r1, r6
c0d005b6:	f004 fb27 	bl	c0d04c08 <cx_math_is_zero>
c0d005ba:	2800      	cmp	r0, #0
c0d005bc:	d006      	beq.n	c0d005cc <monero_hash_to_ec+0x1fc>
       goto negative;
     } else {
      cx_math_multm(rX, rX, (unsigned char *)C_fe_fffb1, MOD);
     }
   } else {
     cx_math_multm(rX, rX, (unsigned char *)C_fe_fffb2, MOD);
c0d005be:	4668      	mov	r0, sp
c0d005c0:	6006      	str	r6, [r0, #0]
c0d005c2:	4638      	mov	r0, r7
c0d005c4:	30ce      	adds	r0, #206	; 0xce
c0d005c6:	4a6f      	ldr	r2, [pc, #444]	; (c0d00784 <monero_hash_to_ec+0x3b4>)
c0d005c8:	447a      	add	r2, pc
c0d005ca:	e016      	b.n	c0d005fa <monero_hash_to_ec+0x22a>
    cx_math_multm(x, y, x, MOD);
    cx_math_subm(y, w, x, MOD);
    os_memmove(z, C_fe_ma, 32);

    if (!cx_math_is_zero(y,32)) {
     cx_math_addm(y, w, x, MOD);
c0d005cc:	4668      	mov	r0, sp
c0d005ce:	6006      	str	r6, [r0, #0]
c0d005d0:	463a      	mov	r2, r7
c0d005d2:	326e      	adds	r2, #110	; 0x6e
c0d005d4:	4b69      	ldr	r3, [pc, #420]	; (c0d0077c <monero_hash_to_ec+0x3ac>)
c0d005d6:	447b      	add	r3, pc
c0d005d8:	9d05      	ldr	r5, [sp, #20]
c0d005da:	4628      	mov	r0, r5
c0d005dc:	9908      	ldr	r1, [sp, #32]
c0d005de:	f004 fb43 	bl	c0d04c68 <cx_math_addm>
     if (!cx_math_is_zero(y,32)) {
c0d005e2:	4628      	mov	r0, r5
c0d005e4:	4631      	mov	r1, r6
c0d005e6:	f004 fb0f 	bl	c0d04c08 <cx_math_is_zero>
c0d005ea:	2800      	cmp	r0, #0
c0d005ec:	d07b      	beq.n	c0d006e6 <monero_hash_to_ec+0x316>
       goto negative;
     } else {
      cx_math_multm(rX, rX, (unsigned char *)C_fe_fffb1, MOD);
c0d005ee:	4668      	mov	r0, sp
c0d005f0:	6006      	str	r6, [r0, #0]
c0d005f2:	4638      	mov	r0, r7
c0d005f4:	30ce      	adds	r0, #206	; 0xce
c0d005f6:	4a62      	ldr	r2, [pc, #392]	; (c0d00780 <monero_hash_to_ec+0x3b0>)
c0d005f8:	447a      	add	r2, pc
c0d005fa:	4b63      	ldr	r3, [pc, #396]	; (c0d00788 <monero_hash_to_ec+0x3b8>)
c0d005fc:	447b      	add	r3, pc
c0d005fe:	4601      	mov	r1, r0
c0d00600:	f004 fb62 	bl	c0d04cc8 <cx_math_multm>
     }
   } else {
     cx_math_multm(rX, rX, (unsigned char *)C_fe_fffb2, MOD);
   }
   cx_math_multm(rX, rX, u, MOD);  // u * sqrt(2 * A * (A + 2) * w / x)
c0d00604:	4668      	mov	r0, sp
c0d00606:	6006      	str	r6, [r0, #0]
c0d00608:	463a      	mov	r2, r7
c0d0060a:	320e      	adds	r2, #14
c0d0060c:	4d5f      	ldr	r5, [pc, #380]	; (c0d0078c <monero_hash_to_ec+0x3bc>)
c0d0060e:	447d      	add	r5, pc
c0d00610:	9807      	ldr	r0, [sp, #28]
c0d00612:	4601      	mov	r1, r0
c0d00614:	462b      	mov	r3, r5
c0d00616:	f004 fb57 	bl	c0d04cc8 <cx_math_multm>
   cx_math_multm(z, z, v, MOD);        // -2 * A * u^2
c0d0061a:	4668      	mov	r0, sp
c0d0061c:	6006      	str	r6, [r0, #0]
c0d0061e:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d00620:	4601      	mov	r1, r0
c0d00622:	9a03      	ldr	r2, [sp, #12]
c0d00624:	462b      	mov	r3, r5
c0d00626:	f004 fb4f 	bl	c0d04cc8 <cx_math_multm>
c0d0062a:	2000      	movs	r0, #0
c0d0062c:	21ed      	movs	r1, #237	; 0xed
   // r->X = sqrt(A * (A + 2) * w / x)
   // z = -A
   sign = 1;

 setsign:
   if (fe_isnegative(rX) != sign) {
c0d0062e:	5c79      	ldrb	r1, [r7, r1]
c0d00630:	9a04      	ldr	r2, [sp, #16]
c0d00632:	4011      	ands	r1, r2
c0d00634:	4288      	cmp	r0, r1
c0d00636:	d006      	beq.n	c0d00646 <monero_hash_to_ec+0x276>
     //fe_neg(r->X, r->X);
    cx_math_sub(rX, (unsigned char *)C_ED25519_FIELD, rX, 32);
c0d00638:	495b      	ldr	r1, [pc, #364]	; (c0d007a8 <monero_hash_to_ec+0x3d8>)
c0d0063a:	4479      	add	r1, pc
c0d0063c:	2320      	movs	r3, #32
c0d0063e:	9807      	ldr	r0, [sp, #28]
c0d00640:	4602      	mov	r2, r0
c0d00642:	f004 faf9 	bl	c0d04c38 <cx_math_sub>
   }
   cx_math_addm(rZ, z, w, MOD);
c0d00646:	4668      	mov	r0, sp
c0d00648:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d0064a:	6001      	str	r1, [r0, #0]
c0d0064c:	2087      	movs	r0, #135	; 0x87
c0d0064e:	0040      	lsls	r0, r0, #1
c0d00650:	1838      	adds	r0, r7, r0
c0d00652:	9009      	str	r0, [sp, #36]	; 0x24
c0d00654:	463e      	mov	r6, r7
c0d00656:	364e      	adds	r6, #78	; 0x4e
c0d00658:	4d54      	ldr	r5, [pc, #336]	; (c0d007ac <monero_hash_to_ec+0x3dc>)
c0d0065a:	447d      	add	r5, pc
c0d0065c:	9508      	str	r5, [sp, #32]
c0d0065e:	990a      	ldr	r1, [sp, #40]	; 0x28
c0d00660:	4632      	mov	r2, r6
c0d00662:	462b      	mov	r3, r5
c0d00664:	f004 fb00 	bl	c0d04c68 <cx_math_addm>
   cx_math_subm(rY, z, w, MOD);
c0d00668:	4668      	mov	r0, sp
c0d0066a:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d0066c:	6001      	str	r1, [r0, #0]
c0d0066e:	37ee      	adds	r7, #238	; 0xee
c0d00670:	4638      	mov	r0, r7
c0d00672:	990a      	ldr	r1, [sp, #40]	; 0x28
c0d00674:	4632      	mov	r2, r6
c0d00676:	462b      	mov	r3, r5
c0d00678:	f004 fb0e 	bl	c0d04c98 <cx_math_subm>
   cx_math_multm(rX, rX, rZ, MOD);
c0d0067c:	4668      	mov	r0, sp
c0d0067e:	9e0b      	ldr	r6, [sp, #44]	; 0x2c
c0d00680:	6006      	str	r6, [r0, #0]
c0d00682:	9807      	ldr	r0, [sp, #28]
c0d00684:	4601      	mov	r1, r0
c0d00686:	9a09      	ldr	r2, [sp, #36]	; 0x24
c0d00688:	462b      	mov	r3, r5
c0d0068a:	f004 fb1d 	bl	c0d04cc8 <cx_math_multm>

   //back to monero y-affine
   cx_math_invprimem(u, rZ, MOD);
c0d0068e:	9806      	ldr	r0, [sp, #24]
c0d00690:	9909      	ldr	r1, [sp, #36]	; 0x24
c0d00692:	462a      	mov	r2, r5
c0d00694:	4633      	mov	r3, r6
c0d00696:	4635      	mov	r5, r6
c0d00698:	f004 fb5e 	bl	c0d04d58 <cx_math_invprimem>
c0d0069c:	ae0c      	add	r6, sp, #48	; 0x30
c0d0069e:	2004      	movs	r0, #4
   Pxy[0] = 0x04;
c0d006a0:	7030      	strb	r0, [r6, #0]
   cx_math_multm(&Pxy[1],    rX, u, MOD);
c0d006a2:	4668      	mov	r0, sp
c0d006a4:	6005      	str	r5, [r0, #0]
c0d006a6:	1c70      	adds	r0, r6, #1
c0d006a8:	900a      	str	r0, [sp, #40]	; 0x28
c0d006aa:	9907      	ldr	r1, [sp, #28]
c0d006ac:	9a06      	ldr	r2, [sp, #24]
c0d006ae:	9b08      	ldr	r3, [sp, #32]
c0d006b0:	f004 fb0a 	bl	c0d04cc8 <cx_math_multm>
   cx_math_multm(&Pxy[1+32], rY, u, MOD);
c0d006b4:	4668      	mov	r0, sp
c0d006b6:	6005      	str	r5, [r0, #0]
c0d006b8:	4630      	mov	r0, r6
c0d006ba:	3021      	adds	r0, #33	; 0x21
c0d006bc:	4639      	mov	r1, r7
c0d006be:	9a06      	ldr	r2, [sp, #24]
c0d006c0:	9b08      	ldr	r3, [sp, #32]
c0d006c2:	f004 fb01 	bl	c0d04cc8 <cx_math_multm>
c0d006c6:	2041      	movs	r0, #65	; 0x41
   cx_edward_compress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d006c8:	4631      	mov	r1, r6
c0d006ca:	4602      	mov	r2, r0
c0d006cc:	f004 fa70 	bl	c0d04bb0 <cx_edward_compress_point>
   os_memmove(ge, &Pxy[1], 32);
c0d006d0:	4620      	mov	r0, r4
c0d006d2:	990a      	ldr	r1, [sp, #40]	; 0x28
c0d006d4:	462a      	mov	r2, r5
c0d006d6:	f003 fa5c 	bl	c0d03b92 <os_memmove>
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_hash_to_ec(unsigned char *ec, unsigned char *ec_pub) {
    monero_keccak_F(ec_pub, 32, ec);
    monero_ge_fromfe_frombytes(ec, ec);
    monero_ecmul_8(ec, ec);
c0d006da:	4620      	mov	r0, r4
c0d006dc:	4621      	mov	r1, r4
c0d006de:	f000 f867 	bl	c0d007b0 <monero_ecmul_8>
}
c0d006e2:	b01d      	add	sp, #116	; 0x74
c0d006e4:	bdf0      	pop	{r4, r5, r6, r7, pc}
   sign = 0;

   goto setsign;

  negative:
   cx_math_multm(x, x, (unsigned char *)C_fe_sqrtm1, MOD);
c0d006e6:	4668      	mov	r0, sp
c0d006e8:	6006      	str	r6, [r0, #0]
c0d006ea:	463d      	mov	r5, r7
c0d006ec:	356e      	adds	r5, #110	; 0x6e
c0d006ee:	4a28      	ldr	r2, [pc, #160]	; (c0d00790 <monero_hash_to_ec+0x3c0>)
c0d006f0:	447a      	add	r2, pc
c0d006f2:	4b28      	ldr	r3, [pc, #160]	; (c0d00794 <monero_hash_to_ec+0x3c4>)
c0d006f4:	447b      	add	r3, pc
c0d006f6:	9309      	str	r3, [sp, #36]	; 0x24
c0d006f8:	4628      	mov	r0, r5
c0d006fa:	4629      	mov	r1, r5
c0d006fc:	f004 fae4 	bl	c0d04cc8 <cx_math_multm>
   cx_math_subm(y, w, x, MOD);
c0d00700:	4668      	mov	r0, sp
c0d00702:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d00704:	6001      	str	r1, [r0, #0]
c0d00706:	9e05      	ldr	r6, [sp, #20]
c0d00708:	4630      	mov	r0, r6
c0d0070a:	9908      	ldr	r1, [sp, #32]
c0d0070c:	462a      	mov	r2, r5
c0d0070e:	9b09      	ldr	r3, [sp, #36]	; 0x24
c0d00710:	9d0b      	ldr	r5, [sp, #44]	; 0x2c
c0d00712:	f004 fac1 	bl	c0d04c98 <cx_math_subm>
   if (!cx_math_is_zero(y,32)) {
c0d00716:	4630      	mov	r0, r6
c0d00718:	4629      	mov	r1, r5
c0d0071a:	f004 fa75 	bl	c0d04c08 <cx_math_is_zero>
c0d0071e:	2800      	cmp	r0, #0
c0d00720:	d009      	beq.n	c0d00736 <monero_hash_to_ec+0x366>
     cx_math_addm(y, w, x, MOD);
     cx_math_multm(rX, rX, (unsigned char *)C_fe_fffb3, MOD);
   } else {
     cx_math_multm(rX, rX, (unsigned char *)C_fe_fffb4, MOD);
c0d00722:	4668      	mov	r0, sp
c0d00724:	6005      	str	r5, [r0, #0]
c0d00726:	4638      	mov	r0, r7
c0d00728:	30ce      	adds	r0, #206	; 0xce
c0d0072a:	4a1d      	ldr	r2, [pc, #116]	; (c0d007a0 <monero_hash_to_ec+0x3d0>)
c0d0072c:	447a      	add	r2, pc
c0d0072e:	4b1d      	ldr	r3, [pc, #116]	; (c0d007a4 <monero_hash_to_ec+0x3d4>)
c0d00730:	447b      	add	r3, pc
c0d00732:	4601      	mov	r1, r0
c0d00734:	e012      	b.n	c0d0075c <monero_hash_to_ec+0x38c>

  negative:
   cx_math_multm(x, x, (unsigned char *)C_fe_sqrtm1, MOD);
   cx_math_subm(y, w, x, MOD);
   if (!cx_math_is_zero(y,32)) {
     cx_math_addm(y, w, x, MOD);
c0d00736:	4668      	mov	r0, sp
c0d00738:	6005      	str	r5, [r0, #0]
c0d0073a:	463a      	mov	r2, r7
c0d0073c:	326e      	adds	r2, #110	; 0x6e
c0d0073e:	4e16      	ldr	r6, [pc, #88]	; (c0d00798 <monero_hash_to_ec+0x3c8>)
c0d00740:	447e      	add	r6, pc
c0d00742:	9805      	ldr	r0, [sp, #20]
c0d00744:	9908      	ldr	r1, [sp, #32]
c0d00746:	4633      	mov	r3, r6
c0d00748:	f004 fa8e 	bl	c0d04c68 <cx_math_addm>
     cx_math_multm(rX, rX, (unsigned char *)C_fe_fffb3, MOD);
c0d0074c:	4668      	mov	r0, sp
c0d0074e:	6005      	str	r5, [r0, #0]
c0d00750:	4638      	mov	r0, r7
c0d00752:	30ce      	adds	r0, #206	; 0xce
c0d00754:	4a11      	ldr	r2, [pc, #68]	; (c0d0079c <monero_hash_to_ec+0x3cc>)
c0d00756:	447a      	add	r2, pc
c0d00758:	4601      	mov	r1, r0
c0d0075a:	4633      	mov	r3, r6
c0d0075c:	f004 fab4 	bl	c0d04cc8 <cx_math_multm>
c0d00760:	2001      	movs	r0, #1
c0d00762:	e763      	b.n	c0d0062c <monero_hash_to_ec+0x25c>
c0d00764:	20001930 	.word	0x20001930
c0d00768:	00008001 	.word	0x00008001
c0d0076c:	000066b2 	.word	0x000066b2
c0d00770:	00006648 	.word	0x00006648
c0d00774:	000066a0 	.word	0x000066a0
c0d00778:	0000656c 	.word	0x0000656c
c0d0077c:	000064fe 	.word	0x000064fe
c0d00780:	0000653c 	.word	0x0000653c
c0d00784:	0000658c 	.word	0x0000658c
c0d00788:	000064d8 	.word	0x000064d8
c0d0078c:	000064c6 	.word	0x000064c6
c0d00790:	000064c4 	.word	0x000064c4
c0d00794:	000063e0 	.word	0x000063e0
c0d00798:	00006394 	.word	0x00006394
c0d0079c:	0000641e 	.word	0x0000641e
c0d007a0:	00006468 	.word	0x00006468
c0d007a4:	000063a4 	.word	0x000063a4
c0d007a8:	0000649a 	.word	0x0000649a
c0d007ac:	0000647a 	.word	0x0000647a

c0d007b0 <monero_ecmul_8>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecmul_8(unsigned char *W, unsigned char *P) {
c0d007b0:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d007b2:	b093      	sub	sp, #76	; 0x4c
c0d007b4:	9001      	str	r0, [sp, #4]
c0d007b6:	af02      	add	r7, sp, #8
c0d007b8:	2002      	movs	r0, #2
    unsigned char Pxy[65];

    Pxy[0] = 0x02;
c0d007ba:	7038      	strb	r0, [r7, #0]
    os_memmove(&Pxy[1], P, 32);
c0d007bc:	1c7d      	adds	r5, r7, #1
c0d007be:	2620      	movs	r6, #32
c0d007c0:	4628      	mov	r0, r5
c0d007c2:	4632      	mov	r2, r6
c0d007c4:	f003 f9e5 	bl	c0d03b92 <os_memmove>
c0d007c8:	2441      	movs	r4, #65	; 0x41
    cx_edward_decompress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d007ca:	4620      	mov	r0, r4
c0d007cc:	4639      	mov	r1, r7
c0d007ce:	4622      	mov	r2, r4
c0d007d0:	f004 fa04 	bl	c0d04bdc <cx_edward_decompress_point>
    cx_ecfp_add_point(CX_CURVE_Ed25519, Pxy, Pxy, Pxy, sizeof(Pxy));
c0d007d4:	4668      	mov	r0, sp
c0d007d6:	6004      	str	r4, [r0, #0]
c0d007d8:	4620      	mov	r0, r4
c0d007da:	4639      	mov	r1, r7
c0d007dc:	463a      	mov	r2, r7
c0d007de:	463b      	mov	r3, r7
c0d007e0:	f004 f9b2 	bl	c0d04b48 <cx_ecfp_add_point>
    cx_ecfp_add_point(CX_CURVE_Ed25519, Pxy, Pxy, Pxy, sizeof(Pxy));
c0d007e4:	4668      	mov	r0, sp
c0d007e6:	6004      	str	r4, [r0, #0]
c0d007e8:	4620      	mov	r0, r4
c0d007ea:	4639      	mov	r1, r7
c0d007ec:	463a      	mov	r2, r7
c0d007ee:	463b      	mov	r3, r7
c0d007f0:	f004 f9aa 	bl	c0d04b48 <cx_ecfp_add_point>
    cx_ecfp_add_point(CX_CURVE_Ed25519, Pxy, Pxy, Pxy, sizeof(Pxy));
c0d007f4:	4668      	mov	r0, sp
c0d007f6:	6004      	str	r4, [r0, #0]
c0d007f8:	4620      	mov	r0, r4
c0d007fa:	4639      	mov	r1, r7
c0d007fc:	463a      	mov	r2, r7
c0d007fe:	463b      	mov	r3, r7
c0d00800:	f004 f9a2 	bl	c0d04b48 <cx_ecfp_add_point>
    cx_edward_compress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d00804:	4620      	mov	r0, r4
c0d00806:	4639      	mov	r1, r7
c0d00808:	4622      	mov	r2, r4
c0d0080a:	f004 f9d1 	bl	c0d04bb0 <cx_edward_compress_point>
    os_memmove(W, &Pxy[1], 32);
c0d0080e:	9801      	ldr	r0, [sp, #4]
c0d00810:	4629      	mov	r1, r5
c0d00812:	4632      	mov	r2, r6
c0d00814:	f003 f9bd 	bl	c0d03b92 <os_memmove>
}
c0d00818:	b013      	add	sp, #76	; 0x4c
c0d0081a:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d0081c <monero_generate_keypair>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_generate_keypair(unsigned char *ec_pub, unsigned char *ec_priv) {
c0d0081c:	b5b0      	push	{r4, r5, r7, lr}
c0d0081e:	460c      	mov	r4, r1
c0d00820:	4605      	mov	r5, r0
c0d00822:	2120      	movs	r1, #32
/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */

void monero_rng(unsigned char *r,  int len) {
    cx_rng(r,len);
c0d00824:	4620      	mov	r0, r4
c0d00826:	f004 f8f9 	bl	c0d04a1c <cx_rng>
/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_generate_keypair(unsigned char *ec_pub, unsigned char *ec_priv) {
    monero_rng(ec_priv,32);
    monero_reduce(ec_priv, ec_priv);
c0d0082a:	4620      	mov	r0, r4
c0d0082c:	4621      	mov	r1, r4
c0d0082e:	f7ff fdab 	bl	c0d00388 <monero_reduce>
    monero_ecmul_G(ec_pub, ec_priv);
c0d00832:	4628      	mov	r0, r5
c0d00834:	4621      	mov	r1, r4
c0d00836:	f000 f801 	bl	c0d0083c <monero_ecmul_G>
}
c0d0083a:	bdb0      	pop	{r4, r5, r7, pc}

c0d0083c <monero_ecmul_G>:
/* ======================================================================= */

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecmul_G(unsigned char *W,  unsigned char *scalar32) {
c0d0083c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0083e:	b09b      	sub	sp, #108	; 0x6c
c0d00840:	4604      	mov	r4, r0
c0d00842:	2000      	movs	r0, #0
c0d00844:	221f      	movs	r2, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00846:	5c0b      	ldrb	r3, [r1, r0]
        rscal[i]    = scal [31-i];
c0d00848:	5c8d      	ldrb	r5, [r1, r2]
c0d0084a:	ae02      	add	r6, sp, #8
c0d0084c:	5435      	strb	r5, [r6, r0]
        rscal[31-i] = x;
c0d0084e:	54b3      	strb	r3, [r6, r2]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00850:	1e52      	subs	r2, r2, #1
c0d00852:	1c40      	adds	r0, r0, #1
c0d00854:	2810      	cmp	r0, #16
c0d00856:	d1f6      	bne.n	c0d00846 <monero_ecmul_G+0xa>
c0d00858:	ad0a      	add	r5, sp, #40	; 0x28
/* ----------------------------------------------------------------------- */
void monero_ecmul_G(unsigned char *W,  unsigned char *scalar32) {
    unsigned char Pxy[65];
    unsigned char s[32];
    monero_reverse32(s, scalar32);
    os_memmove(Pxy, C_ED25519_G, 65);
c0d0085a:	490e      	ldr	r1, [pc, #56]	; (c0d00894 <monero_ecmul_G+0x58>)
c0d0085c:	4479      	add	r1, pc
c0d0085e:	2641      	movs	r6, #65	; 0x41
c0d00860:	4628      	mov	r0, r5
c0d00862:	4632      	mov	r2, r6
c0d00864:	f003 f995 	bl	c0d03b92 <os_memmove>
c0d00868:	2720      	movs	r7, #32
    cx_ecfp_scalar_mult(CX_CURVE_Ed25519, Pxy, sizeof(Pxy), s, 32);
c0d0086a:	4668      	mov	r0, sp
c0d0086c:	6007      	str	r7, [r0, #0]
c0d0086e:	ab02      	add	r3, sp, #8
c0d00870:	4630      	mov	r0, r6
c0d00872:	4629      	mov	r1, r5
c0d00874:	4632      	mov	r2, r6
c0d00876:	f004 f981 	bl	c0d04b7c <cx_ecfp_scalar_mult>
    cx_edward_compress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d0087a:	4630      	mov	r0, r6
c0d0087c:	4629      	mov	r1, r5
c0d0087e:	4632      	mov	r2, r6
c0d00880:	f004 f996 	bl	c0d04bb0 <cx_edward_compress_point>
    os_memmove(W, &Pxy[1], 32);
c0d00884:	1c69      	adds	r1, r5, #1
c0d00886:	4620      	mov	r0, r4
c0d00888:	463a      	mov	r2, r7
c0d0088a:	f003 f982 	bl	c0d03b92 <os_memmove>
}
c0d0088e:	b01b      	add	sp, #108	; 0x6c
c0d00890:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00892:	46c0      	nop			; (mov r8, r8)
c0d00894:	000063a0 	.word	0x000063a0

c0d00898 <monero_generate_key_derivation>:
}

/* ----------------------------------------------------------------------- */
/* --- ok                                                              --- */
/* ----------------------------------------------------------------------- */
void monero_generate_key_derivation(unsigned char *drv_data, unsigned char *P, unsigned char *scalar) {
c0d00898:	b570      	push	{r4, r5, r6, lr}
c0d0089a:	b088      	sub	sp, #32
c0d0089c:	460c      	mov	r4, r1
c0d0089e:	4605      	mov	r5, r0
c0d008a0:	466e      	mov	r6, sp
/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecmul_8k(unsigned char *W, unsigned char *P, unsigned char *scalar32) {
    unsigned char s[32];
    monero_multm_8(s, scalar32);
c0d008a2:	4630      	mov	r0, r6
c0d008a4:	4611      	mov	r1, r2
c0d008a6:	f000 f9ff 	bl	c0d00ca8 <monero_multm_8>
    monero_ecmul_k(W, P, s);
c0d008aa:	4628      	mov	r0, r5
c0d008ac:	4621      	mov	r1, r4
c0d008ae:	4632      	mov	r2, r6
c0d008b0:	f000 f8db 	bl	c0d00a6a <monero_ecmul_k>
/* ----------------------------------------------------------------------- */
/* --- ok                                                              --- */
/* ----------------------------------------------------------------------- */
void monero_generate_key_derivation(unsigned char *drv_data, unsigned char *P, unsigned char *scalar) {
    monero_ecmul_8k(drv_data,P,scalar);
}
c0d008b4:	b008      	add	sp, #32
c0d008b6:	bd70      	pop	{r4, r5, r6, pc}

c0d008b8 <monero_derivation_to_scalar>:

/* ----------------------------------------------------------------------- */
/* ---  ok                                                             --- */
/* ----------------------------------------------------------------------- */
void monero_derivation_to_scalar(unsigned char *scalar, unsigned char *drv_data, unsigned int out_idx) {
c0d008b8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d008ba:	b08d      	sub	sp, #52	; 0x34
c0d008bc:	4617      	mov	r7, r2
c0d008be:	9002      	str	r0, [sp, #8]
c0d008c0:	ac03      	add	r4, sp, #12
c0d008c2:	2520      	movs	r5, #32
    unsigned char varint[32+8];
    unsigned int len_varint;

    os_memmove(varint, drv_data, 32);
c0d008c4:	4620      	mov	r0, r4
c0d008c6:	462a      	mov	r2, r5
c0d008c8:	f003 f963 	bl	c0d03b92 <os_memmove>
    len_varint = monero_encode_varint(varint+32, out_idx);
c0d008cc:	3420      	adds	r4, #32
c0d008ce:	2600      	movs	r6, #0
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
unsigned int monero_encode_varint(unsigned char varint[8], unsigned int out_idx) {
    unsigned int len;
    len = 0;
    while(out_idx >= 0x80) {
c0d008d0:	2f80      	cmp	r7, #128	; 0x80
c0d008d2:	d30b      	bcc.n	c0d008ec <monero_derivation_to_scalar+0x34>
c0d008d4:	a803      	add	r0, sp, #12
        varint[len] = (out_idx & 0x7F) | 0x80;
c0d008d6:	3020      	adds	r0, #32
c0d008d8:	2600      	movs	r6, #0
c0d008da:	4639      	mov	r1, r7
c0d008dc:	2280      	movs	r2, #128	; 0x80
c0d008de:	433a      	orrs	r2, r7
c0d008e0:	5582      	strb	r2, [r0, r6]
        out_idx = out_idx>>7;
c0d008e2:	09cf      	lsrs	r7, r1, #7
        len++;
c0d008e4:	1c76      	adds	r6, r6, #1
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
unsigned int monero_encode_varint(unsigned char varint[8], unsigned int out_idx) {
    unsigned int len;
    len = 0;
    while(out_idx >= 0x80) {
c0d008e6:	0b89      	lsrs	r1, r1, #14
c0d008e8:	4639      	mov	r1, r7
c0d008ea:	d1f7      	bne.n	c0d008dc <monero_derivation_to_scalar+0x24>
        varint[len] = (out_idx & 0x7F) | 0x80;
        out_idx = out_idx>>7;
        len++;
    }
    varint[len] = out_idx;
c0d008ec:	55a7      	strb	r7, [r4, r6]
c0d008ee:	2023      	movs	r0, #35	; 0x23
c0d008f0:	0100      	lsls	r0, r0, #4

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_hash(unsigned int algo, cx_hash_t * hasher, unsigned char* buf, unsigned int len, unsigned char* out) {
    hasher->algo = algo;
c0d008f2:	490d      	ldr	r1, [pc, #52]	; (c0d00928 <monero_derivation_to_scalar+0x70>)
c0d008f4:	2206      	movs	r2, #6
c0d008f6:	540a      	strb	r2, [r1, r0]
c0d008f8:	180c      	adds	r4, r1, r0
c0d008fa:	2001      	movs	r0, #1
c0d008fc:	0201      	lsls	r1, r0, #8
    if (algo == CX_SHA256) {
         cx_sha256_init((cx_sha256_t *)hasher);
    } else {
        cx_keccak_init((cx_sha3_t *)hasher, 256);
c0d008fe:	4620      	mov	r0, r4
c0d00900:	f004 f8d6 	bl	c0d04ab0 <cx_keccak_init>
    }
    return cx_hash(hasher, CX_LAST|CX_NO_REINIT, buf, len, out, 32);
c0d00904:	4668      	mov	r0, sp
c0d00906:	6045      	str	r5, [r0, #4]
c0d00908:	ad03      	add	r5, sp, #12
c0d0090a:	6005      	str	r5, [r0, #0]
    unsigned char varint[32+8];
    unsigned int len_varint;

    os_memmove(varint, drv_data, 32);
    len_varint = monero_encode_varint(varint+32, out_idx);
    len_varint += 32;
c0d0090c:	3621      	adds	r6, #33	; 0x21
c0d0090e:	4907      	ldr	r1, [pc, #28]	; (c0d0092c <monero_derivation_to_scalar+0x74>)
    if (algo == CX_SHA256) {
         cx_sha256_init((cx_sha256_t *)hasher);
    } else {
        cx_keccak_init((cx_sha3_t *)hasher, 256);
    }
    return cx_hash(hasher, CX_LAST|CX_NO_REINIT, buf, len, out, 32);
c0d00910:	4620      	mov	r0, r4
c0d00912:	462a      	mov	r2, r5
c0d00914:	4633      	mov	r3, r6
c0d00916:	f004 f899 	bl	c0d04a4c <cx_hash>

    os_memmove(varint, drv_data, 32);
    len_varint = monero_encode_varint(varint+32, out_idx);
    len_varint += 32;
    monero_keccak_F(varint,len_varint,varint);
    monero_reduce(scalar, varint);
c0d0091a:	9802      	ldr	r0, [sp, #8]
c0d0091c:	4629      	mov	r1, r5
c0d0091e:	f7ff fd33 	bl	c0d00388 <monero_reduce>
}
c0d00922:	b00d      	add	sp, #52	; 0x34
c0d00924:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00926:	46c0      	nop			; (mov r8, r8)
c0d00928:	20001930 	.word	0x20001930
c0d0092c:	00008001 	.word	0x00008001

c0d00930 <monero_derive_secret_key>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_derive_secret_key(unsigned char *x,
                              unsigned char *drv_data, unsigned int out_idx, unsigned char *ec_priv) {
c0d00930:	b570      	push	{r4, r5, r6, lr}
c0d00932:	b088      	sub	sp, #32
c0d00934:	461c      	mov	r4, r3
c0d00936:	4605      	mov	r5, r0
c0d00938:	466e      	mov	r6, sp
    unsigned char tmp[32];

    //derivation to scalar
    monero_derivation_to_scalar(tmp,drv_data,out_idx);
c0d0093a:	4630      	mov	r0, r6
c0d0093c:	f7ff ffbc 	bl	c0d008b8 <monero_derivation_to_scalar>

    //generate
    monero_addm(x, tmp, ec_priv);
c0d00940:	4628      	mov	r0, r5
c0d00942:	4631      	mov	r1, r6
c0d00944:	4622      	mov	r2, r4
c0d00946:	f000 f803 	bl	c0d00950 <monero_addm>
}
c0d0094a:	b008      	add	sp, #32
c0d0094c:	bd70      	pop	{r4, r5, r6, pc}
	...

c0d00950 <monero_addm>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_addm(unsigned char *r, unsigned char *a, unsigned char *b) {
c0d00950:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00952:	b091      	sub	sp, #68	; 0x44
c0d00954:	4604      	mov	r4, r0
c0d00956:	2000      	movs	r0, #0
c0d00958:	231f      	movs	r3, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d0095a:	5c0d      	ldrb	r5, [r1, r0]
        rscal[i]    = scal [31-i];
c0d0095c:	5cce      	ldrb	r6, [r1, r3]
c0d0095e:	af09      	add	r7, sp, #36	; 0x24
c0d00960:	543e      	strb	r6, [r7, r0]
        rscal[31-i] = x;
c0d00962:	54fd      	strb	r5, [r7, r3]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00964:	1e5b      	subs	r3, r3, #1
c0d00966:	1c40      	adds	r0, r0, #1
c0d00968:	2810      	cmp	r0, #16
c0d0096a:	d1f6      	bne.n	c0d0095a <monero_addm+0xa>
c0d0096c:	2000      	movs	r0, #0
c0d0096e:	211f      	movs	r1, #31
        x           = scal[i];
c0d00970:	5c13      	ldrb	r3, [r2, r0]
        rscal[i]    = scal [31-i];
c0d00972:	5c55      	ldrb	r5, [r2, r1]
c0d00974:	ae01      	add	r6, sp, #4
c0d00976:	5435      	strb	r5, [r6, r0]
        rscal[31-i] = x;
c0d00978:	5473      	strb	r3, [r6, r1]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d0097a:	1e49      	subs	r1, r1, #1
c0d0097c:	1c40      	adds	r0, r0, #1
c0d0097e:	2810      	cmp	r0, #16
c0d00980:	d1f6      	bne.n	c0d00970 <monero_addm+0x20>
c0d00982:	2020      	movs	r0, #32
    unsigned char ra[32];
    unsigned char rb[32];

    monero_reverse32(ra,a);
    monero_reverse32(rb,b);
    cx_math_addm(r, ra,  rb, (unsigned char *)C_ED25519_ORDER, 32);
c0d00984:	4669      	mov	r1, sp
c0d00986:	6008      	str	r0, [r1, #0]
c0d00988:	a909      	add	r1, sp, #36	; 0x24
c0d0098a:	aa01      	add	r2, sp, #4
c0d0098c:	4b08      	ldr	r3, [pc, #32]	; (c0d009b0 <monero_addm+0x60>)
c0d0098e:	447b      	add	r3, pc
c0d00990:	4620      	mov	r0, r4
c0d00992:	f004 f969 	bl	c0d04c68 <cx_math_addm>
c0d00996:	2000      	movs	r0, #0
c0d00998:	211f      	movs	r1, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d0099a:	5c22      	ldrb	r2, [r4, r0]
        rscal[i]    = scal [31-i];
c0d0099c:	5c63      	ldrb	r3, [r4, r1]
c0d0099e:	5423      	strb	r3, [r4, r0]
        rscal[31-i] = x;
c0d009a0:	5462      	strb	r2, [r4, r1]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d009a2:	1e49      	subs	r1, r1, #1
c0d009a4:	1c40      	adds	r0, r0, #1
c0d009a6:	290f      	cmp	r1, #15
c0d009a8:	d1f7      	bne.n	c0d0099a <monero_addm+0x4a>

    monero_reverse32(ra,a);
    monero_reverse32(rb,b);
    cx_math_addm(r, ra,  rb, (unsigned char *)C_ED25519_ORDER, 32);
    monero_reverse32(r,r);
}
c0d009aa:	b011      	add	sp, #68	; 0x44
c0d009ac:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d009ae:	46c0      	nop			; (mov r8, r8)
c0d009b0:	00006126 	.word	0x00006126

c0d009b4 <monero_derive_public_key>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_derive_public_key(unsigned char *x,
                              unsigned char* drv_data, unsigned int out_idx, unsigned char *ec_pub) {
c0d009b4:	b570      	push	{r4, r5, r6, lr}
c0d009b6:	b088      	sub	sp, #32
c0d009b8:	461c      	mov	r4, r3
c0d009ba:	4605      	mov	r5, r0
c0d009bc:	466e      	mov	r6, sp
    unsigned char tmp[32];

    //derivation to scalar
    monero_derivation_to_scalar(tmp,drv_data,out_idx);
c0d009be:	4630      	mov	r0, r6
c0d009c0:	f7ff ff7a 	bl	c0d008b8 <monero_derivation_to_scalar>
    //generate
    monero_ecmul_G(tmp,tmp);
c0d009c4:	4630      	mov	r0, r6
c0d009c6:	4631      	mov	r1, r6
c0d009c8:	f7ff ff38 	bl	c0d0083c <monero_ecmul_G>
    monero_ecadd(x,tmp,ec_pub);
c0d009cc:	4628      	mov	r0, r5
c0d009ce:	4631      	mov	r1, r6
c0d009d0:	4622      	mov	r2, r4
c0d009d2:	f000 f802 	bl	c0d009da <monero_ecadd>
}
c0d009d6:	b008      	add	sp, #32
c0d009d8:	bd70      	pop	{r4, r5, r6, pc}

c0d009da <monero_ecadd>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecadd(unsigned char *W, unsigned char *P, unsigned char *Q) {
c0d009da:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d009dc:	b0a7      	sub	sp, #156	; 0x9c
c0d009de:	9202      	str	r2, [sp, #8]
c0d009e0:	9004      	str	r0, [sp, #16]
c0d009e2:	af16      	add	r7, sp, #88	; 0x58
c0d009e4:	2002      	movs	r0, #2
    unsigned char Pxy[65];
    unsigned char Qxy[65];

    Pxy[0] = 0x02;
c0d009e6:	9001      	str	r0, [sp, #4]
c0d009e8:	7038      	strb	r0, [r7, #0]
    os_memmove(&Pxy[1], P, 32);
c0d009ea:	1c78      	adds	r0, r7, #1
c0d009ec:	9003      	str	r0, [sp, #12]
c0d009ee:	2620      	movs	r6, #32
c0d009f0:	4632      	mov	r2, r6
c0d009f2:	f003 f8ce 	bl	c0d03b92 <os_memmove>
c0d009f6:	2441      	movs	r4, #65	; 0x41
    cx_edward_decompress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d009f8:	4620      	mov	r0, r4
c0d009fa:	4639      	mov	r1, r7
c0d009fc:	4622      	mov	r2, r4
c0d009fe:	f004 f8ed 	bl	c0d04bdc <cx_edward_decompress_point>
c0d00a02:	ad05      	add	r5, sp, #20

    Qxy[0] = 0x02;
c0d00a04:	9801      	ldr	r0, [sp, #4]
c0d00a06:	7028      	strb	r0, [r5, #0]
    os_memmove(&Qxy[1], Q, 32);
c0d00a08:	1c68      	adds	r0, r5, #1
c0d00a0a:	9902      	ldr	r1, [sp, #8]
c0d00a0c:	4632      	mov	r2, r6
c0d00a0e:	f003 f8c0 	bl	c0d03b92 <os_memmove>
    cx_edward_decompress_point(CX_CURVE_Ed25519, Qxy, sizeof(Qxy));
c0d00a12:	4620      	mov	r0, r4
c0d00a14:	4629      	mov	r1, r5
c0d00a16:	4622      	mov	r2, r4
c0d00a18:	f004 f8e0 	bl	c0d04bdc <cx_edward_decompress_point>

    cx_ecfp_add_point(CX_CURVE_Ed25519, Pxy, Pxy, Qxy, sizeof(Pxy));
c0d00a1c:	4668      	mov	r0, sp
c0d00a1e:	6004      	str	r4, [r0, #0]
c0d00a20:	4620      	mov	r0, r4
c0d00a22:	4639      	mov	r1, r7
c0d00a24:	463a      	mov	r2, r7
c0d00a26:	462b      	mov	r3, r5
c0d00a28:	f004 f88e 	bl	c0d04b48 <cx_ecfp_add_point>

    cx_edward_compress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d00a2c:	4620      	mov	r0, r4
c0d00a2e:	4639      	mov	r1, r7
c0d00a30:	4622      	mov	r2, r4
c0d00a32:	f004 f8bd 	bl	c0d04bb0 <cx_edward_compress_point>
    os_memmove(W, &Pxy[1], 32);
c0d00a36:	9804      	ldr	r0, [sp, #16]
c0d00a38:	9903      	ldr	r1, [sp, #12]
c0d00a3a:	4632      	mov	r2, r6
c0d00a3c:	f003 f8a9 	bl	c0d03b92 <os_memmove>
}
c0d00a40:	b027      	add	sp, #156	; 0x9c
c0d00a42:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d00a44 <monero_secret_key_to_public_key>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_secret_key_to_public_key(unsigned char *ec_pub, unsigned char *ec_priv) {
c0d00a44:	b580      	push	{r7, lr}
    monero_ecmul_G(ec_pub, ec_priv);
c0d00a46:	f7ff fef9 	bl	c0d0083c <monero_ecmul_G>
}
c0d00a4a:	bd80      	pop	{r7, pc}

c0d00a4c <monero_generate_key_image>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_generate_key_image(unsigned char *img, unsigned char *P, unsigned char* x) {
c0d00a4c:	b570      	push	{r4, r5, r6, lr}
c0d00a4e:	b088      	sub	sp, #32
c0d00a50:	4614      	mov	r4, r2
c0d00a52:	4605      	mov	r5, r0
c0d00a54:	466e      	mov	r6, sp
    unsigned char I[32];
    monero_hash_to_ec(I,P);
c0d00a56:	4630      	mov	r0, r6
c0d00a58:	f7ff fcba 	bl	c0d003d0 <monero_hash_to_ec>
    monero_ecmul_k(img, I,x);
c0d00a5c:	4628      	mov	r0, r5
c0d00a5e:	4631      	mov	r1, r6
c0d00a60:	4622      	mov	r2, r4
c0d00a62:	f000 f802 	bl	c0d00a6a <monero_ecmul_k>
}
c0d00a66:	b008      	add	sp, #32
c0d00a68:	bd70      	pop	{r4, r5, r6, pc}

c0d00a6a <monero_ecmul_k>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecmul_k(unsigned char *W, unsigned char *P, unsigned char *scalar32) {
c0d00a6a:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00a6c:	b09b      	sub	sp, #108	; 0x6c
c0d00a6e:	9001      	str	r0, [sp, #4]
c0d00a70:	2000      	movs	r0, #0
c0d00a72:	231f      	movs	r3, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00a74:	5c14      	ldrb	r4, [r2, r0]
        rscal[i]    = scal [31-i];
c0d00a76:	5cd5      	ldrb	r5, [r2, r3]
c0d00a78:	ae02      	add	r6, sp, #8
c0d00a7a:	5435      	strb	r5, [r6, r0]
        rscal[31-i] = x;
c0d00a7c:	54f4      	strb	r4, [r6, r3]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00a7e:	1e5b      	subs	r3, r3, #1
c0d00a80:	1c40      	adds	r0, r0, #1
c0d00a82:	2810      	cmp	r0, #16
c0d00a84:	d1f6      	bne.n	c0d00a74 <monero_ecmul_k+0xa>
c0d00a86:	af0a      	add	r7, sp, #40	; 0x28
c0d00a88:	2002      	movs	r0, #2
    unsigned char Pxy[65];
    unsigned char s[32];

    monero_reverse32(s, scalar32);

    Pxy[0] = 0x02;
c0d00a8a:	7038      	strb	r0, [r7, #0]
    os_memmove(&Pxy[1], P, 32);
c0d00a8c:	1c7d      	adds	r5, r7, #1
c0d00a8e:	2620      	movs	r6, #32
c0d00a90:	4628      	mov	r0, r5
c0d00a92:	4632      	mov	r2, r6
c0d00a94:	f003 f87d 	bl	c0d03b92 <os_memmove>
c0d00a98:	2441      	movs	r4, #65	; 0x41
    cx_edward_decompress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d00a9a:	4620      	mov	r0, r4
c0d00a9c:	4639      	mov	r1, r7
c0d00a9e:	4622      	mov	r2, r4
c0d00aa0:	f004 f89c 	bl	c0d04bdc <cx_edward_decompress_point>

    cx_ecfp_scalar_mult(CX_CURVE_Ed25519, Pxy, sizeof(Pxy), s, 32);
c0d00aa4:	4668      	mov	r0, sp
c0d00aa6:	6006      	str	r6, [r0, #0]
c0d00aa8:	ab02      	add	r3, sp, #8
c0d00aaa:	4620      	mov	r0, r4
c0d00aac:	4639      	mov	r1, r7
c0d00aae:	4622      	mov	r2, r4
c0d00ab0:	f004 f864 	bl	c0d04b7c <cx_ecfp_scalar_mult>
    cx_edward_compress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d00ab4:	4620      	mov	r0, r4
c0d00ab6:	4639      	mov	r1, r7
c0d00ab8:	4622      	mov	r2, r4
c0d00aba:	f004 f879 	bl	c0d04bb0 <cx_edward_compress_point>

    os_memmove(W, &Pxy[1], 32);
c0d00abe:	9801      	ldr	r0, [sp, #4]
c0d00ac0:	4629      	mov	r1, r5
c0d00ac2:	4632      	mov	r2, r6
c0d00ac4:	f003 f865 	bl	c0d03b92 <os_memmove>
}
c0d00ac8:	b01b      	add	sp, #108	; 0x6c
c0d00aca:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d00acc <monero_derive_subaddress_public_key>:

/* ----------------------------------------------------------------------- */
/* --- ok                                                              --- */
/* ----------------------------------------------------------------------- */
void monero_derive_subaddress_public_key(unsigned char *x,
                                         unsigned char *pub, unsigned char* drv_data, unsigned int index) {
c0d00acc:	b570      	push	{r4, r5, r6, lr}
c0d00ace:	b088      	sub	sp, #32
c0d00ad0:	460c      	mov	r4, r1
c0d00ad2:	4605      	mov	r5, r0
c0d00ad4:	466e      	mov	r6, sp
  unsigned char scalarG[32];

  monero_derivation_to_scalar(scalarG , drv_data, index);
c0d00ad6:	4630      	mov	r0, r6
c0d00ad8:	4611      	mov	r1, r2
c0d00ada:	461a      	mov	r2, r3
c0d00adc:	f7ff feec 	bl	c0d008b8 <monero_derivation_to_scalar>
  monero_ecmul_G(scalarG, scalarG);
c0d00ae0:	4630      	mov	r0, r6
c0d00ae2:	4631      	mov	r1, r6
c0d00ae4:	f7ff feaa 	bl	c0d0083c <monero_ecmul_G>
  monero_ecsub(x, pub, scalarG);
c0d00ae8:	4628      	mov	r0, r5
c0d00aea:	4621      	mov	r1, r4
c0d00aec:	4632      	mov	r2, r6
c0d00aee:	f000 f803 	bl	c0d00af8 <monero_ecsub>
}
c0d00af2:	b008      	add	sp, #32
c0d00af4:	bd70      	pop	{r4, r5, r6, pc}
	...

c0d00af8 <monero_ecsub>:


/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecsub(unsigned char *W, unsigned char *P, unsigned char *Q) {
c0d00af8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00afa:	b0a7      	sub	sp, #156	; 0x9c
c0d00afc:	9201      	str	r2, [sp, #4]
c0d00afe:	9003      	str	r0, [sp, #12]
c0d00b00:	af16      	add	r7, sp, #88	; 0x58
c0d00b02:	2602      	movs	r6, #2
    unsigned char Pxy[65];
    unsigned char Qxy[65];

    Pxy[0] = 0x02;
c0d00b04:	703e      	strb	r6, [r7, #0]
    os_memmove(&Pxy[1], P, 32);
c0d00b06:	1c78      	adds	r0, r7, #1
c0d00b08:	9002      	str	r0, [sp, #8]
c0d00b0a:	2220      	movs	r2, #32
c0d00b0c:	9204      	str	r2, [sp, #16]
c0d00b0e:	f003 f840 	bl	c0d03b92 <os_memmove>
c0d00b12:	2441      	movs	r4, #65	; 0x41
    cx_edward_decompress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d00b14:	4620      	mov	r0, r4
c0d00b16:	4639      	mov	r1, r7
c0d00b18:	4622      	mov	r2, r4
c0d00b1a:	f004 f85f 	bl	c0d04bdc <cx_edward_decompress_point>
c0d00b1e:	ad05      	add	r5, sp, #20

    Qxy[0] = 0x02;
c0d00b20:	702e      	strb	r6, [r5, #0]
    os_memmove(&Qxy[1], Q, 32);
c0d00b22:	1c6e      	adds	r6, r5, #1
c0d00b24:	4630      	mov	r0, r6
c0d00b26:	9901      	ldr	r1, [sp, #4]
c0d00b28:	9a04      	ldr	r2, [sp, #16]
c0d00b2a:	f003 f832 	bl	c0d03b92 <os_memmove>
    cx_edward_decompress_point(CX_CURVE_Ed25519, Qxy, sizeof(Qxy));
c0d00b2e:	4620      	mov	r0, r4
c0d00b30:	4629      	mov	r1, r5
c0d00b32:	4622      	mov	r2, r4
c0d00b34:	f004 f852 	bl	c0d04bdc <cx_edward_decompress_point>

    cx_math_sub(Qxy+1, (unsigned char *)C_ED25519_FIELD,  Qxy+1, 32);
c0d00b38:	490d      	ldr	r1, [pc, #52]	; (c0d00b70 <monero_ecsub+0x78>)
c0d00b3a:	4479      	add	r1, pc
c0d00b3c:	4630      	mov	r0, r6
c0d00b3e:	4632      	mov	r2, r6
c0d00b40:	9e04      	ldr	r6, [sp, #16]
c0d00b42:	4633      	mov	r3, r6
c0d00b44:	f004 f878 	bl	c0d04c38 <cx_math_sub>
    cx_ecfp_add_point(CX_CURVE_Ed25519, Pxy, Pxy, Qxy, sizeof(Pxy));
c0d00b48:	4668      	mov	r0, sp
c0d00b4a:	6004      	str	r4, [r0, #0]
c0d00b4c:	4620      	mov	r0, r4
c0d00b4e:	4639      	mov	r1, r7
c0d00b50:	463a      	mov	r2, r7
c0d00b52:	462b      	mov	r3, r5
c0d00b54:	f003 fff8 	bl	c0d04b48 <cx_ecfp_add_point>

    cx_edward_compress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d00b58:	4620      	mov	r0, r4
c0d00b5a:	4639      	mov	r1, r7
c0d00b5c:	4622      	mov	r2, r4
c0d00b5e:	f004 f827 	bl	c0d04bb0 <cx_edward_compress_point>
    os_memmove(W, &Pxy[1], 32);
c0d00b62:	9803      	ldr	r0, [sp, #12]
c0d00b64:	9902      	ldr	r1, [sp, #8]
c0d00b66:	4632      	mov	r2, r6
c0d00b68:	f003 f813 	bl	c0d03b92 <os_memmove>
}
c0d00b6c:	b027      	add	sp, #156	; 0x9c
c0d00b6e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00b70:	00005f9a 	.word	0x00005f9a

c0d00b74 <monero_get_subaddress_spend_public_key>:
}

/* ----------------------------------------------------------------------- */
/* --- ok                                                              --- */
/* ----------------------------------------------------------------------- */
void monero_get_subaddress_spend_public_key(unsigned char *x,unsigned char *index) {
c0d00b74:	b5b0      	push	{r4, r5, r7, lr}
c0d00b76:	460a      	mov	r2, r1
c0d00b78:	4604      	mov	r4, r0
c0d00b7a:	2051      	movs	r0, #81	; 0x51
c0d00b7c:	0080      	lsls	r0, r0, #2
    // m = Hs(a || index_major || index_minor)
    monero_get_subaddress_secret_key(x, G_monero_vstate.a, index);
c0d00b7e:	4d08      	ldr	r5, [pc, #32]	; (c0d00ba0 <monero_get_subaddress_spend_public_key+0x2c>)
c0d00b80:	1829      	adds	r1, r5, r0
c0d00b82:	4620      	mov	r0, r4
c0d00b84:	f000 f80e 	bl	c0d00ba4 <monero_get_subaddress_secret_key>

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_secret_key_to_public_key(unsigned char *ec_pub, unsigned char *ec_priv) {
    monero_ecmul_G(ec_pub, ec_priv);
c0d00b88:	4620      	mov	r0, r4
c0d00b8a:	4621      	mov	r1, r4
c0d00b8c:	f7ff fe56 	bl	c0d0083c <monero_ecmul_G>
c0d00b90:	2069      	movs	r0, #105	; 0x69
c0d00b92:	0080      	lsls	r0, r0, #2
    // m = Hs(a || index_major || index_minor)
    monero_get_subaddress_secret_key(x, G_monero_vstate.a, index);
    // M = m*G
    monero_secret_key_to_public_key(x,x);
    // D = B + M
    monero_ecadd(x,x,G_monero_vstate.B);
c0d00b94:	182a      	adds	r2, r5, r0
c0d00b96:	4620      	mov	r0, r4
c0d00b98:	4621      	mov	r1, r4
c0d00b9a:	f7ff ff1e 	bl	c0d009da <monero_ecadd>
 }
c0d00b9e:	bdb0      	pop	{r4, r5, r7, pc}
c0d00ba0:	20001930 	.word	0x20001930

c0d00ba4 <monero_get_subaddress_secret_key>:
/* ----------------------------------------------------------------------- */
/* --- ok                                                              --- */
/* ----------------------------------------------------------------------- */
static const  char C_sub_address_prefix[] = {'S','u','b','A','d','d','r', 0};

void monero_get_subaddress_secret_key(unsigned char *sub_s, unsigned char *s, unsigned char *index) {
c0d00ba4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00ba6:	b091      	sub	sp, #68	; 0x44
c0d00ba8:	9204      	str	r2, [sp, #16]
c0d00baa:	9103      	str	r1, [sp, #12]
c0d00bac:	4604      	mov	r4, r0
c0d00bae:	ad05      	add	r5, sp, #20
    unsigned char in[sizeof(C_sub_address_prefix)+32+8];

    os_memmove(in,                               C_sub_address_prefix, sizeof(C_sub_address_prefix)),
c0d00bb0:	4918      	ldr	r1, [pc, #96]	; (c0d00c14 <monero_get_subaddress_secret_key+0x70>)
c0d00bb2:	4479      	add	r1, pc
c0d00bb4:	2708      	movs	r7, #8
c0d00bb6:	4628      	mov	r0, r5
c0d00bb8:	463a      	mov	r2, r7
c0d00bba:	f002 ffea 	bl	c0d03b92 <os_memmove>
    os_memmove(in+sizeof(C_sub_address_prefix),    s,                  32);
c0d00bbe:	4628      	mov	r0, r5
c0d00bc0:	3008      	adds	r0, #8
c0d00bc2:	2620      	movs	r6, #32
c0d00bc4:	9903      	ldr	r1, [sp, #12]
c0d00bc6:	4632      	mov	r2, r6
c0d00bc8:	f002 ffe3 	bl	c0d03b92 <os_memmove>
    os_memmove(in+sizeof(C_sub_address_prefix)+32, index,              8);
c0d00bcc:	4628      	mov	r0, r5
c0d00bce:	3028      	adds	r0, #40	; 0x28
c0d00bd0:	9904      	ldr	r1, [sp, #16]
c0d00bd2:	463a      	mov	r2, r7
c0d00bd4:	f002 ffdd 	bl	c0d03b92 <os_memmove>
c0d00bd8:	2023      	movs	r0, #35	; 0x23
c0d00bda:	0100      	lsls	r0, r0, #4

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_hash(unsigned int algo, cx_hash_t * hasher, unsigned char* buf, unsigned int len, unsigned char* out) {
    hasher->algo = algo;
c0d00bdc:	490b      	ldr	r1, [pc, #44]	; (c0d00c0c <monero_get_subaddress_secret_key+0x68>)
c0d00bde:	2206      	movs	r2, #6
c0d00be0:	540a      	strb	r2, [r1, r0]
c0d00be2:	180f      	adds	r7, r1, r0
c0d00be4:	2001      	movs	r0, #1
c0d00be6:	0201      	lsls	r1, r0, #8
    if (algo == CX_SHA256) {
         cx_sha256_init((cx_sha256_t *)hasher);
    } else {
        cx_keccak_init((cx_sha3_t *)hasher, 256);
c0d00be8:	4638      	mov	r0, r7
c0d00bea:	f003 ff61 	bl	c0d04ab0 <cx_keccak_init>
    }
    return cx_hash(hasher, CX_LAST|CX_NO_REINIT, buf, len, out, 32);
c0d00bee:	4668      	mov	r0, sp
c0d00bf0:	c050      	stmia	r0!, {r4, r6}
c0d00bf2:	4907      	ldr	r1, [pc, #28]	; (c0d00c10 <monero_get_subaddress_secret_key+0x6c>)
c0d00bf4:	2330      	movs	r3, #48	; 0x30
c0d00bf6:	4638      	mov	r0, r7
c0d00bf8:	462a      	mov	r2, r5
c0d00bfa:	f003 ff27 	bl	c0d04a4c <cx_hash>
    os_memmove(in,                               C_sub_address_prefix, sizeof(C_sub_address_prefix)),
    os_memmove(in+sizeof(C_sub_address_prefix),    s,                  32);
    os_memmove(in+sizeof(C_sub_address_prefix)+32, index,              8);
    //hash_to_scalar with more that 32bytes:
    monero_keccak_F(in, sizeof(in), sub_s);
    monero_reduce(sub_s, sub_s);
c0d00bfe:	4620      	mov	r0, r4
c0d00c00:	4621      	mov	r1, r4
c0d00c02:	f7ff fbc1 	bl	c0d00388 <monero_reduce>
}
c0d00c06:	b011      	add	sp, #68	; 0x44
c0d00c08:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00c0a:	46c0      	nop			; (mov r8, r8)
c0d00c0c:	20001930 	.word	0x20001930
c0d00c10:	00008001 	.word	0x00008001
c0d00c14:	00006042 	.word	0x00006042

c0d00c18 <monero_get_subaddress>:
 }

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_get_subaddress(unsigned char *C, unsigned char *D, unsigned char *index) {
c0d00c18:	b5b0      	push	{r4, r5, r7, lr}
c0d00c1a:	460c      	mov	r4, r1
c0d00c1c:	4605      	mov	r5, r0
    //retrieve D
    monero_get_subaddress_spend_public_key(D, index);
c0d00c1e:	4608      	mov	r0, r1
c0d00c20:	4611      	mov	r1, r2
c0d00c22:	f7ff ffa7 	bl	c0d00b74 <monero_get_subaddress_spend_public_key>
c0d00c26:	2051      	movs	r0, #81	; 0x51
c0d00c28:	0080      	lsls	r0, r0, #2
    // C = a*D
    monero_ecmul_k(C,D,G_monero_vstate.a);
c0d00c2a:	4903      	ldr	r1, [pc, #12]	; (c0d00c38 <monero_get_subaddress+0x20>)
c0d00c2c:	180a      	adds	r2, r1, r0
c0d00c2e:	4628      	mov	r0, r5
c0d00c30:	4621      	mov	r1, r4
c0d00c32:	f7ff ff1a 	bl	c0d00a6a <monero_ecmul_k>
}
c0d00c36:	bdb0      	pop	{r4, r5, r7, pc}
c0d00c38:	20001930 	.word	0x20001930

c0d00c3c <monero_ecmul_H>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecmul_H(unsigned char *W,  unsigned char *scalar32) {
c0d00c3c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00c3e:	b09b      	sub	sp, #108	; 0x6c
c0d00c40:	9001      	str	r0, [sp, #4]
c0d00c42:	2000      	movs	r0, #0
c0d00c44:	221f      	movs	r2, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00c46:	5c0b      	ldrb	r3, [r1, r0]
        rscal[i]    = scal [31-i];
c0d00c48:	5c8c      	ldrb	r4, [r1, r2]
c0d00c4a:	ad02      	add	r5, sp, #8
c0d00c4c:	542c      	strb	r4, [r5, r0]
        rscal[31-i] = x;
c0d00c4e:	54ab      	strb	r3, [r5, r2]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00c50:	1e52      	subs	r2, r2, #1
c0d00c52:	1c40      	adds	r0, r0, #1
c0d00c54:	2810      	cmp	r0, #16
c0d00c56:	d1f6      	bne.n	c0d00c46 <monero_ecmul_H+0xa>
c0d00c58:	af0a      	add	r7, sp, #40	; 0x28
c0d00c5a:	2002      	movs	r0, #2
    unsigned char Pxy[65];
    unsigned char s[32];

    monero_reverse32(s, scalar32);

    Pxy[0] = 0x02;
c0d00c5c:	7038      	strb	r0, [r7, #0]
    os_memmove(&Pxy[1], C_ED25519_Hy, 32);
c0d00c5e:	1c7d      	adds	r5, r7, #1
c0d00c60:	4910      	ldr	r1, [pc, #64]	; (c0d00ca4 <monero_ecmul_H+0x68>)
c0d00c62:	4479      	add	r1, pc
c0d00c64:	2620      	movs	r6, #32
c0d00c66:	4628      	mov	r0, r5
c0d00c68:	4632      	mov	r2, r6
c0d00c6a:	f002 ff92 	bl	c0d03b92 <os_memmove>
c0d00c6e:	2441      	movs	r4, #65	; 0x41
    cx_edward_decompress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d00c70:	4620      	mov	r0, r4
c0d00c72:	4639      	mov	r1, r7
c0d00c74:	4622      	mov	r2, r4
c0d00c76:	f003 ffb1 	bl	c0d04bdc <cx_edward_decompress_point>

    cx_ecfp_scalar_mult(CX_CURVE_Ed25519, Pxy, sizeof(Pxy), s, 32);
c0d00c7a:	4668      	mov	r0, sp
c0d00c7c:	6006      	str	r6, [r0, #0]
c0d00c7e:	ab02      	add	r3, sp, #8
c0d00c80:	4620      	mov	r0, r4
c0d00c82:	4639      	mov	r1, r7
c0d00c84:	4622      	mov	r2, r4
c0d00c86:	f003 ff79 	bl	c0d04b7c <cx_ecfp_scalar_mult>
    cx_edward_compress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d00c8a:	4620      	mov	r0, r4
c0d00c8c:	4639      	mov	r1, r7
c0d00c8e:	4622      	mov	r2, r4
c0d00c90:	f003 ff8e 	bl	c0d04bb0 <cx_edward_compress_point>

    os_memmove(W, &Pxy[1], 32);
c0d00c94:	9801      	ldr	r0, [sp, #4]
c0d00c96:	4629      	mov	r1, r5
c0d00c98:	4632      	mov	r2, r6
c0d00c9a:	f002 ff7a 	bl	c0d03b92 <os_memmove>
}
c0d00c9e:	b01b      	add	sp, #108	; 0x6c
c0d00ca0:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00ca2:	46c0      	nop			; (mov r8, r8)
c0d00ca4:	00005fdb 	.word	0x00005fdb

c0d00ca8 <monero_multm_8>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_multm_8(unsigned char *r, unsigned char *a) {
c0d00ca8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00caa:	b091      	sub	sp, #68	; 0x44
c0d00cac:	4604      	mov	r4, r0
c0d00cae:	2000      	movs	r0, #0
c0d00cb0:	221f      	movs	r2, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00cb2:	5c0b      	ldrb	r3, [r1, r0]
        rscal[i]    = scal [31-i];
c0d00cb4:	5c8d      	ldrb	r5, [r1, r2]
c0d00cb6:	ae09      	add	r6, sp, #36	; 0x24
c0d00cb8:	5435      	strb	r5, [r6, r0]
        rscal[31-i] = x;
c0d00cba:	54b3      	strb	r3, [r6, r2]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00cbc:	1e52      	subs	r2, r2, #1
c0d00cbe:	1c40      	adds	r0, r0, #1
c0d00cc0:	2810      	cmp	r0, #16
c0d00cc2:	d1f6      	bne.n	c0d00cb2 <monero_multm_8+0xa>
c0d00cc4:	ae01      	add	r6, sp, #4
c0d00cc6:	2500      	movs	r5, #0
c0d00cc8:	2720      	movs	r7, #32
void monero_multm_8(unsigned char *r, unsigned char *a) {
    unsigned char ra[32];
    unsigned char rb[32];

    monero_reverse32(ra,a);
    os_memset(rb,0,32);
c0d00cca:	4630      	mov	r0, r6
c0d00ccc:	4629      	mov	r1, r5
c0d00cce:	463a      	mov	r2, r7
c0d00cd0:	f002 ff56 	bl	c0d03b80 <os_memset>
c0d00cd4:	2008      	movs	r0, #8
    rb[31] = 8;
c0d00cd6:	77f0      	strb	r0, [r6, #31]
    cx_math_multm(r, ra,  rb, (unsigned char *)C_ED25519_ORDER, 32);
c0d00cd8:	4668      	mov	r0, sp
c0d00cda:	6007      	str	r7, [r0, #0]
c0d00cdc:	a909      	add	r1, sp, #36	; 0x24
c0d00cde:	4b08      	ldr	r3, [pc, #32]	; (c0d00d00 <monero_multm_8+0x58>)
c0d00ce0:	447b      	add	r3, pc
c0d00ce2:	4620      	mov	r0, r4
c0d00ce4:	4632      	mov	r2, r6
c0d00ce6:	f003 ffef 	bl	c0d04cc8 <cx_math_multm>
c0d00cea:	201f      	movs	r0, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00cec:	5d61      	ldrb	r1, [r4, r5]
        rscal[i]    = scal [31-i];
c0d00cee:	5c22      	ldrb	r2, [r4, r0]
c0d00cf0:	5562      	strb	r2, [r4, r5]
        rscal[31-i] = x;
c0d00cf2:	5421      	strb	r1, [r4, r0]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00cf4:	1e40      	subs	r0, r0, #1
c0d00cf6:	1c6d      	adds	r5, r5, #1
c0d00cf8:	280f      	cmp	r0, #15
c0d00cfa:	d1f7      	bne.n	c0d00cec <monero_multm_8+0x44>
    monero_reverse32(ra,a);
    os_memset(rb,0,32);
    rb[31] = 8;
    cx_math_multm(r, ra,  rb, (unsigned char *)C_ED25519_ORDER, 32);
    monero_reverse32(r,r);
}
c0d00cfc:	b011      	add	sp, #68	; 0x44
c0d00cfe:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00d00:	00005dd4 	.word	0x00005dd4

c0d00d04 <monero_ecdhHash>:
        memcpy(data + 6, &k, sizeof(k));
        cn_fast_hash(hash, data, sizeof(data));
        return hash;
    }
*/
void monero_ecdhHash(unsigned char *x, unsigned char *k) {
c0d00d04:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00d06:	b08d      	sub	sp, #52	; 0x34
c0d00d08:	460d      	mov	r5, r1
c0d00d0a:	9002      	str	r0, [sp, #8]
c0d00d0c:	ac03      	add	r4, sp, #12
  unsigned char data[38];
  os_memmove(data, "amount", 6);
c0d00d0e:	4913      	ldr	r1, [pc, #76]	; (c0d00d5c <monero_ecdhHash+0x58>)
c0d00d10:	4479      	add	r1, pc
c0d00d12:	2706      	movs	r7, #6
c0d00d14:	4620      	mov	r0, r4
c0d00d16:	463a      	mov	r2, r7
c0d00d18:	f002 ff3b 	bl	c0d03b92 <os_memmove>
  os_memmove(data + 6, k, 32);
c0d00d1c:	1da0      	adds	r0, r4, #6
c0d00d1e:	2620      	movs	r6, #32
c0d00d20:	4629      	mov	r1, r5
c0d00d22:	4632      	mov	r2, r6
c0d00d24:	f002 ff35 	bl	c0d03b92 <os_memmove>
c0d00d28:	2023      	movs	r0, #35	; 0x23
c0d00d2a:	0100      	lsls	r0, r0, #4

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_hash(unsigned int algo, cx_hash_t * hasher, unsigned char* buf, unsigned int len, unsigned char* out) {
    hasher->algo = algo;
c0d00d2c:	4909      	ldr	r1, [pc, #36]	; (c0d00d54 <monero_ecdhHash+0x50>)
c0d00d2e:	540f      	strb	r7, [r1, r0]
c0d00d30:	180d      	adds	r5, r1, r0
c0d00d32:	2001      	movs	r0, #1
c0d00d34:	0201      	lsls	r1, r0, #8
    if (algo == CX_SHA256) {
         cx_sha256_init((cx_sha256_t *)hasher);
    } else {
        cx_keccak_init((cx_sha3_t *)hasher, 256);
c0d00d36:	4628      	mov	r0, r5
c0d00d38:	f003 feba 	bl	c0d04ab0 <cx_keccak_init>
    }
    return cx_hash(hasher, CX_LAST|CX_NO_REINIT, buf, len, out, 32);
c0d00d3c:	4668      	mov	r0, sp
c0d00d3e:	9902      	ldr	r1, [sp, #8]
c0d00d40:	c042      	stmia	r0!, {r1, r6}
c0d00d42:	4905      	ldr	r1, [pc, #20]	; (c0d00d58 <monero_ecdhHash+0x54>)
c0d00d44:	2326      	movs	r3, #38	; 0x26
c0d00d46:	4628      	mov	r0, r5
c0d00d48:	4622      	mov	r2, r4
c0d00d4a:	f003 fe7f 	bl	c0d04a4c <cx_hash>
void monero_ecdhHash(unsigned char *x, unsigned char *k) {
  unsigned char data[38];
  os_memmove(data, "amount", 6);
  os_memmove(data + 6, k, 32);
  monero_keccak_F(data, 38, x);
}
c0d00d4e:	b00d      	add	sp, #52	; 0x34
c0d00d50:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00d52:	46c0      	nop			; (mov r8, r8)
c0d00d54:	20001930 	.word	0x20001930
c0d00d58:	00008001 	.word	0x00008001
c0d00d5c:	00005f4d 	.word	0x00005f4d

c0d00d60 <monero_genCommitmentMask>:
        key scalar;
        hash_to_scalar(scalar, data, sizeof(data));
        return scalar;
    }
*/
void monero_genCommitmentMask(unsigned char *c,  unsigned char *sk) {
c0d00d60:	b570      	push	{r4, r5, r6, lr}
c0d00d62:	b08c      	sub	sp, #48	; 0x30
c0d00d64:	460e      	mov	r6, r1
c0d00d66:	4604      	mov	r4, r0
c0d00d68:	466d      	mov	r5, sp
    unsigned char data[15 + 32];
    os_memmove(data, "commitment_mask", 15);
c0d00d6a:	4909      	ldr	r1, [pc, #36]	; (c0d00d90 <monero_genCommitmentMask+0x30>)
c0d00d6c:	4479      	add	r1, pc
c0d00d6e:	220f      	movs	r2, #15
c0d00d70:	4628      	mov	r0, r5
c0d00d72:	f002 ff0e 	bl	c0d03b92 <os_memmove>
    os_memmove(data + 15, sk, 32);
c0d00d76:	4628      	mov	r0, r5
c0d00d78:	300f      	adds	r0, #15
c0d00d7a:	2220      	movs	r2, #32
c0d00d7c:	4631      	mov	r1, r6
c0d00d7e:	f002 ff08 	bl	c0d03b92 <os_memmove>
c0d00d82:	222f      	movs	r2, #47	; 0x2f
    monero_hash_to_scalar(c, data, 15+32);
c0d00d84:	4620      	mov	r0, r4
c0d00d86:	4629      	mov	r1, r5
c0d00d88:	f7ff fada 	bl	c0d00340 <monero_hash_to_scalar>
}
c0d00d8c:	b00c      	add	sp, #48	; 0x30
c0d00d8e:	bd70      	pop	{r4, r5, r6, pc}
c0d00d90:	00005ef8 	.word	0x00005ef8

c0d00d94 <monero_subm>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_subm(unsigned char *r, unsigned char *a, unsigned char *b) {
c0d00d94:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00d96:	b091      	sub	sp, #68	; 0x44
c0d00d98:	4604      	mov	r4, r0
c0d00d9a:	2000      	movs	r0, #0
c0d00d9c:	231f      	movs	r3, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00d9e:	5c0d      	ldrb	r5, [r1, r0]
        rscal[i]    = scal [31-i];
c0d00da0:	5cce      	ldrb	r6, [r1, r3]
c0d00da2:	af09      	add	r7, sp, #36	; 0x24
c0d00da4:	543e      	strb	r6, [r7, r0]
        rscal[31-i] = x;
c0d00da6:	54fd      	strb	r5, [r7, r3]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00da8:	1e5b      	subs	r3, r3, #1
c0d00daa:	1c40      	adds	r0, r0, #1
c0d00dac:	2810      	cmp	r0, #16
c0d00dae:	d1f6      	bne.n	c0d00d9e <monero_subm+0xa>
c0d00db0:	2000      	movs	r0, #0
c0d00db2:	211f      	movs	r1, #31
        x           = scal[i];
c0d00db4:	5c13      	ldrb	r3, [r2, r0]
        rscal[i]    = scal [31-i];
c0d00db6:	5c55      	ldrb	r5, [r2, r1]
c0d00db8:	ae01      	add	r6, sp, #4
c0d00dba:	5435      	strb	r5, [r6, r0]
        rscal[31-i] = x;
c0d00dbc:	5473      	strb	r3, [r6, r1]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00dbe:	1e49      	subs	r1, r1, #1
c0d00dc0:	1c40      	adds	r0, r0, #1
c0d00dc2:	2810      	cmp	r0, #16
c0d00dc4:	d1f6      	bne.n	c0d00db4 <monero_subm+0x20>
c0d00dc6:	2020      	movs	r0, #32
    unsigned char ra[32];
    unsigned char rb[32];

    monero_reverse32(ra,a);
    monero_reverse32(rb,b);
    cx_math_subm(r, ra,  rb, (unsigned char *)C_ED25519_ORDER, 32);
c0d00dc8:	4669      	mov	r1, sp
c0d00dca:	6008      	str	r0, [r1, #0]
c0d00dcc:	a909      	add	r1, sp, #36	; 0x24
c0d00dce:	aa01      	add	r2, sp, #4
c0d00dd0:	4b08      	ldr	r3, [pc, #32]	; (c0d00df4 <monero_subm+0x60>)
c0d00dd2:	447b      	add	r3, pc
c0d00dd4:	4620      	mov	r0, r4
c0d00dd6:	f003 ff5f 	bl	c0d04c98 <cx_math_subm>
c0d00dda:	2000      	movs	r0, #0
c0d00ddc:	211f      	movs	r1, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00dde:	5c22      	ldrb	r2, [r4, r0]
        rscal[i]    = scal [31-i];
c0d00de0:	5c63      	ldrb	r3, [r4, r1]
c0d00de2:	5423      	strb	r3, [r4, r0]
        rscal[31-i] = x;
c0d00de4:	5462      	strb	r2, [r4, r1]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00de6:	1e49      	subs	r1, r1, #1
c0d00de8:	1c40      	adds	r0, r0, #1
c0d00dea:	290f      	cmp	r1, #15
c0d00dec:	d1f7      	bne.n	c0d00dde <monero_subm+0x4a>

    monero_reverse32(ra,a);
    monero_reverse32(rb,b);
    cx_math_subm(r, ra,  rb, (unsigned char *)C_ED25519_ORDER, 32);
    monero_reverse32(r,r);
}
c0d00dee:	b011      	add	sp, #68	; 0x44
c0d00df0:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00df2:	46c0      	nop			; (mov r8, r8)
c0d00df4:	00005ce2 	.word	0x00005ce2

c0d00df8 <monero_multm>:
/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_multm(unsigned char *r, unsigned char *a, unsigned char *b) {
c0d00df8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00dfa:	b091      	sub	sp, #68	; 0x44
c0d00dfc:	4604      	mov	r4, r0
c0d00dfe:	2000      	movs	r0, #0
c0d00e00:	231f      	movs	r3, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00e02:	5c0d      	ldrb	r5, [r1, r0]
        rscal[i]    = scal [31-i];
c0d00e04:	5cce      	ldrb	r6, [r1, r3]
c0d00e06:	af09      	add	r7, sp, #36	; 0x24
c0d00e08:	543e      	strb	r6, [r7, r0]
        rscal[31-i] = x;
c0d00e0a:	54fd      	strb	r5, [r7, r3]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00e0c:	1e5b      	subs	r3, r3, #1
c0d00e0e:	1c40      	adds	r0, r0, #1
c0d00e10:	2810      	cmp	r0, #16
c0d00e12:	d1f6      	bne.n	c0d00e02 <monero_multm+0xa>
c0d00e14:	2000      	movs	r0, #0
c0d00e16:	211f      	movs	r1, #31
        x           = scal[i];
c0d00e18:	5c13      	ldrb	r3, [r2, r0]
        rscal[i]    = scal [31-i];
c0d00e1a:	5c55      	ldrb	r5, [r2, r1]
c0d00e1c:	ae01      	add	r6, sp, #4
c0d00e1e:	5435      	strb	r5, [r6, r0]
        rscal[31-i] = x;
c0d00e20:	5473      	strb	r3, [r6, r1]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00e22:	1e49      	subs	r1, r1, #1
c0d00e24:	1c40      	adds	r0, r0, #1
c0d00e26:	2810      	cmp	r0, #16
c0d00e28:	d1f6      	bne.n	c0d00e18 <monero_multm+0x20>
c0d00e2a:	2020      	movs	r0, #32
    unsigned char ra[32];
    unsigned char rb[32];

    monero_reverse32(ra,a);
    monero_reverse32(rb,b);
    cx_math_multm(r, ra,  rb, (unsigned char *)C_ED25519_ORDER, 32);
c0d00e2c:	4669      	mov	r1, sp
c0d00e2e:	6008      	str	r0, [r1, #0]
c0d00e30:	a909      	add	r1, sp, #36	; 0x24
c0d00e32:	aa01      	add	r2, sp, #4
c0d00e34:	4b08      	ldr	r3, [pc, #32]	; (c0d00e58 <monero_multm+0x60>)
c0d00e36:	447b      	add	r3, pc
c0d00e38:	4620      	mov	r0, r4
c0d00e3a:	f003 ff45 	bl	c0d04cc8 <cx_math_multm>
c0d00e3e:	2000      	movs	r0, #0
c0d00e40:	211f      	movs	r1, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00e42:	5c22      	ldrb	r2, [r4, r0]
        rscal[i]    = scal [31-i];
c0d00e44:	5c63      	ldrb	r3, [r4, r1]
c0d00e46:	5423      	strb	r3, [r4, r0]
        rscal[31-i] = x;
c0d00e48:	5462      	strb	r2, [r4, r1]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00e4a:	1e49      	subs	r1, r1, #1
c0d00e4c:	1c40      	adds	r0, r0, #1
c0d00e4e:	290f      	cmp	r1, #15
c0d00e50:	d1f7      	bne.n	c0d00e42 <monero_multm+0x4a>

    monero_reverse32(ra,a);
    monero_reverse32(rb,b);
    cx_math_multm(r, ra,  rb, (unsigned char *)C_ED25519_ORDER, 32);
    monero_reverse32(r,r);
}
c0d00e52:	b011      	add	sp, #68	; 0x44
c0d00e54:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00e56:	46c0      	nop			; (mov r8, r8)
c0d00e58:	00005c7e 	.word	0x00005c7e

c0d00e5c <monero_amount2str>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
/* return 0 if ok, 1 if missing decimal */
int monero_amount2str(uint64_t xmr,  char *str, unsigned int str_len) {
c0d00e5c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00e5e:	b08f      	sub	sp, #60	; 0x3c
c0d00e60:	9108      	str	r1, [sp, #32]
c0d00e62:	4605      	mov	r5, r0
c0d00e64:	2400      	movs	r4, #0
c0d00e66:	9202      	str	r2, [sp, #8]
    //max uint64 is 18446744073709551616, aka 20 char, plus dot
    char stramount[22];
    unsigned int offset,len,ov;

    os_memset(str,0,str_len);
c0d00e68:	4610      	mov	r0, r2
c0d00e6a:	4621      	mov	r1, r4
c0d00e6c:	9301      	str	r3, [sp, #4]
c0d00e6e:	461a      	mov	r2, r3
c0d00e70:	f002 fe86 	bl	c0d03b80 <os_memset>
c0d00e74:	af09      	add	r7, sp, #36	; 0x24
c0d00e76:	2130      	movs	r1, #48	; 0x30
c0d00e78:	2616      	movs	r6, #22

    os_memset(stramount,'0',sizeof(stramount));
c0d00e7a:	4638      	mov	r0, r7
c0d00e7c:	9104      	str	r1, [sp, #16]
c0d00e7e:	4632      	mov	r2, r6
c0d00e80:	f002 fe7e 	bl	c0d03b80 <os_memset>
c0d00e84:	9908      	ldr	r1, [sp, #32]
c0d00e86:	9405      	str	r4, [sp, #20]
    stramount[21] = 0;
c0d00e88:	757c      	strb	r4, [r7, #21]
    //special case
    if (xmr == 0) {
c0d00e8a:	4628      	mov	r0, r5
c0d00e8c:	4308      	orrs	r0, r1
c0d00e8e:	2800      	cmp	r0, #0
c0d00e90:	d051      	beq.n	c0d00f36 <monero_amount2str+0xda>
c0d00e92:	ac09      	add	r4, sp, #36	; 0x24
    // value:  0 | xmrunits | 0

    offset = 20;
    while (xmr) {
        stramount[offset] = '0' + xmr % 10;
        xmr = xmr / 10;
c0d00e94:	3414      	adds	r4, #20
c0d00e96:	43f6      	mvns	r6, r6
c0d00e98:	9603      	str	r6, [sp, #12]
c0d00e9a:	260a      	movs	r6, #10
c0d00e9c:	4628      	mov	r0, r5
c0d00e9e:	9108      	str	r1, [sp, #32]
c0d00ea0:	4632      	mov	r2, r6
c0d00ea2:	9f05      	ldr	r7, [sp, #20]
c0d00ea4:	463b      	mov	r3, r7
c0d00ea6:	f005 fbb5 	bl	c0d06614 <__aeabi_uldivmod>
c0d00eaa:	9007      	str	r0, [sp, #28]
c0d00eac:	9106      	str	r1, [sp, #24]
c0d00eae:	4632      	mov	r2, r6
c0d00eb0:	9e03      	ldr	r6, [sp, #12]
c0d00eb2:	463b      	mov	r3, r7
c0d00eb4:	f005 fbce 	bl	c0d06654 <__aeabi_lmul>
c0d00eb8:	1a28      	subs	r0, r5, r0
    // ----------------------
    // value:  0 | xmrunits | 0

    offset = 20;
    while (xmr) {
        stramount[offset] = '0' + xmr % 10;
c0d00eba:	9904      	ldr	r1, [sp, #16]
c0d00ebc:	4308      	orrs	r0, r1
c0d00ebe:	7020      	strb	r0, [r4, #0]
c0d00ec0:	19a4      	adds	r4, r4, r6
    // offset: 0 | 1-20     | 21
    // ----------------------
    // value:  0 | xmrunits | 0

    offset = 20;
    while (xmr) {
c0d00ec2:	3416      	adds	r4, #22
c0d00ec4:	2009      	movs	r0, #9
c0d00ec6:	1b40      	subs	r0, r0, r5
c0d00ec8:	9908      	ldr	r1, [sp, #32]
c0d00eca:	418f      	sbcs	r7, r1
c0d00ecc:	9d07      	ldr	r5, [sp, #28]
c0d00ece:	9906      	ldr	r1, [sp, #24]
c0d00ed0:	d3e3      	bcc.n	c0d00e9a <monero_amount2str+0x3e>
c0d00ed2:	ac09      	add	r4, sp, #36	; 0x24
        offset--;
    }
    // offset: 0-7 | 8 | 9-20 |21
    // ----------------------
    // value:  xmr | . | units| 0
    os_memmove(stramount, stramount+1, 8);
c0d00ed4:	1c61      	adds	r1, r4, #1
c0d00ed6:	2208      	movs	r2, #8
c0d00ed8:	4620      	mov	r0, r4
c0d00eda:	f002 fe5a 	bl	c0d03b92 <os_memmove>
c0d00ede:	202e      	movs	r0, #46	; 0x2e
    stramount[8] = '.';
c0d00ee0:	7220      	strb	r0, [r4, #8]
c0d00ee2:	4630      	mov	r0, r6
c0d00ee4:	a909      	add	r1, sp, #36	; 0x24
    offset = 0;
    while((stramount[offset]=='0') && (stramount[offset] != '.')) {
c0d00ee6:	1809      	adds	r1, r1, r0
c0d00ee8:	7dca      	ldrb	r2, [r1, #23]
c0d00eea:	1c40      	adds	r0, r0, #1
c0d00eec:	2a30      	cmp	r2, #48	; 0x30
c0d00eee:	d0f9      	beq.n	c0d00ee4 <monero_amount2str+0x88>
c0d00ef0:	9b05      	ldr	r3, [sp, #20]
c0d00ef2:	43d9      	mvns	r1, r3
        offset++;
    }
    if (stramount[offset] == '.') {
c0d00ef4:	2a2e      	cmp	r2, #46	; 0x2e
c0d00ef6:	d000      	beq.n	c0d00efa <monero_amount2str+0x9e>
c0d00ef8:	4619      	mov	r1, r3
        offset--;
    }
    len = 20;
    while((stramount[len]=='0') && (stramount[len] != '.')) {
c0d00efa:	424a      	negs	r2, r1
c0d00efc:	1a14      	subs	r4, r2, r0
c0d00efe:	aa09      	add	r2, sp, #36	; 0x24
c0d00f00:	3214      	adds	r2, #20
c0d00f02:	1993      	adds	r3, r2, r6
c0d00f04:	3316      	adds	r3, #22
c0d00f06:	1e64      	subs	r4, r4, #1
c0d00f08:	7812      	ldrb	r2, [r2, #0]
c0d00f0a:	2a30      	cmp	r2, #48	; 0x30
c0d00f0c:	461a      	mov	r2, r3
c0d00f0e:	d0f8      	beq.n	c0d00f02 <monero_amount2str+0xa6>
        len--;
    }
    len = len-offset+1;
    ov = 0;
    if (len>(str_len-1)) {
c0d00f10:	9a01      	ldr	r2, [sp, #4]
c0d00f12:	1e55      	subs	r5, r2, #1
c0d00f14:	42ac      	cmp	r4, r5
c0d00f16:	462a      	mov	r2, r5
c0d00f18:	d800      	bhi.n	c0d00f1c <monero_amount2str+0xc0>
c0d00f1a:	4622      	mov	r2, r4
c0d00f1c:	ab09      	add	r3, sp, #36	; 0x24
        len = str_len-1;
        ov = 1;
    }
    os_memmove(str, stramount+offset, len);
c0d00f1e:	1859      	adds	r1, r3, r1
c0d00f20:	1809      	adds	r1, r1, r0
c0d00f22:	3116      	adds	r1, #22
c0d00f24:	9802      	ldr	r0, [sp, #8]
c0d00f26:	f002 fe34 	bl	c0d03b92 <os_memmove>
c0d00f2a:	2001      	movs	r0, #1
c0d00f2c:	2100      	movs	r1, #0
    while((stramount[len]=='0') && (stramount[len] != '.')) {
        len--;
    }
    len = len-offset+1;
    ov = 0;
    if (len>(str_len-1)) {
c0d00f2e:	42ac      	cmp	r4, r5
c0d00f30:	d805      	bhi.n	c0d00f3e <monero_amount2str+0xe2>
c0d00f32:	4608      	mov	r0, r1
c0d00f34:	e003      	b.n	c0d00f3e <monero_amount2str+0xe2>

    os_memset(stramount,'0',sizeof(stramount));
    stramount[21] = 0;
    //special case
    if (xmr == 0) {
        str[0] = '0';
c0d00f36:	9804      	ldr	r0, [sp, #16]
c0d00f38:	9902      	ldr	r1, [sp, #8]
c0d00f3a:	7008      	strb	r0, [r1, #0]
c0d00f3c:	2001      	movs	r0, #1
        len = str_len-1;
        ov = 1;
    }
    os_memmove(str, stramount+offset, len);
    return ov;
}
c0d00f3e:	b00f      	add	sp, #60	; 0x3c
c0d00f40:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d00f42 <monero_bamount2uint64>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
uint64_t monero_bamount2uint64(unsigned char *binary) {
c0d00f42:	b5b0      	push	{r4, r5, r7, lr}
c0d00f44:	2400      	movs	r4, #0
c0d00f46:	2307      	movs	r3, #7
c0d00f48:	4621      	mov	r1, r4
    uint64_t xmr;
    int i;
    xmr = 0;
    for (i=7; i>=0; i--) {
        xmr = xmr*256 + binary[i];
c0d00f4a:	5cc2      	ldrb	r2, [r0, r3]
c0d00f4c:	0225      	lsls	r5, r4, #8
c0d00f4e:	18aa      	adds	r2, r5, r2
c0d00f50:	0e24      	lsrs	r4, r4, #24
c0d00f52:	0209      	lsls	r1, r1, #8
c0d00f54:	1909      	adds	r1, r1, r4
/* ----------------------------------------------------------------------- */
uint64_t monero_bamount2uint64(unsigned char *binary) {
    uint64_t xmr;
    int i;
    xmr = 0;
    for (i=7; i>=0; i--) {
c0d00f56:	1e5c      	subs	r4, r3, #1
c0d00f58:	2b00      	cmp	r3, #0
c0d00f5a:	4623      	mov	r3, r4
c0d00f5c:	4614      	mov	r4, r2
c0d00f5e:	d1f4      	bne.n	c0d00f4a <monero_bamount2uint64+0x8>
        xmr = xmr*256 + binary[i];
    }
    return xmr;
c0d00f60:	4610      	mov	r0, r2
c0d00f62:	bdb0      	pop	{r4, r5, r7, pc}

c0d00f64 <monero_vamount2uint64>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
uint64_t monero_vamount2uint64(unsigned char *binary) {
c0d00f64:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00f66:	b081      	sub	sp, #4
c0d00f68:	4601      	mov	r1, r0
    uint64_t xmr,x;
   int shift = 0;
   xmr = 0;
   while((*binary)&0x80) {
c0d00f6a:	7800      	ldrb	r0, [r0, #0]
c0d00f6c:	0602      	lsls	r2, r0, #24
c0d00f6e:	2600      	movs	r6, #0
c0d00f70:	2a00      	cmp	r2, #0
c0d00f72:	d402      	bmi.n	c0d00f7a <monero_vamount2uint64+0x16>
c0d00f74:	4637      	mov	r7, r6
c0d00f76:	4634      	mov	r4, r6
c0d00f78:	e014      	b.n	c0d00fa4 <monero_vamount2uint64+0x40>
       if ( (unsigned int)shift > (8*sizeof(unsigned long long int)-7)) {
c0d00f7a:	1c4d      	adds	r5, r1, #1
c0d00f7c:	2700      	movs	r7, #0
c0d00f7e:	463c      	mov	r4, r7
c0d00f80:	463e      	mov	r6, r7
c0d00f82:	9700      	str	r7, [sp, #0]
c0d00f84:	2c39      	cmp	r4, #57	; 0x39
c0d00f86:	d817      	bhi.n	c0d00fb8 <monero_vamount2uint64+0x54>
c0d00f88:	217f      	movs	r1, #127	; 0x7f
        return 0;
       }
       x = *(binary)&0x7f;
c0d00f8a:	4008      	ands	r0, r1
c0d00f8c:	2100      	movs	r1, #0
       xmr = xmr + (x<<shift);
c0d00f8e:	4622      	mov	r2, r4
c0d00f90:	f005 fb34 	bl	c0d065fc <__aeabi_llsl>
c0d00f94:	1986      	adds	r6, r0, r6
c0d00f96:	414f      	adcs	r7, r1
/* ----------------------------------------------------------------------- */
uint64_t monero_vamount2uint64(unsigned char *binary) {
    uint64_t xmr,x;
   int shift = 0;
   xmr = 0;
   while((*binary)&0x80) {
c0d00f98:	1c69      	adds	r1, r5, #1
        return 0;
       }
       x = *(binary)&0x7f;
       xmr = xmr + (x<<shift);
       binary++;
       shift += 7;
c0d00f9a:	1de4      	adds	r4, r4, #7
/* ----------------------------------------------------------------------- */
uint64_t monero_vamount2uint64(unsigned char *binary) {
    uint64_t xmr,x;
   int shift = 0;
   xmr = 0;
   while((*binary)&0x80) {
c0d00f9c:	7828      	ldrb	r0, [r5, #0]
c0d00f9e:	0602      	lsls	r2, r0, #24
c0d00fa0:	460d      	mov	r5, r1
c0d00fa2:	d4ef      	bmi.n	c0d00f84 <monero_vamount2uint64+0x20>
c0d00fa4:	227f      	movs	r2, #127	; 0x7f
       x = *(binary)&0x7f;
       xmr = xmr + (x<<shift);
       binary++;
       shift += 7;
   }
   x = *(binary)&0x7f;
c0d00fa6:	4002      	ands	r2, r0
c0d00fa8:	2100      	movs	r1, #0
   xmr = xmr + (x<<shift);
c0d00faa:	4610      	mov	r0, r2
c0d00fac:	4622      	mov	r2, r4
c0d00fae:	f005 fb25 	bl	c0d065fc <__aeabi_llsl>
c0d00fb2:	1980      	adds	r0, r0, r6
c0d00fb4:	4179      	adcs	r1, r7
c0d00fb6:	e001      	b.n	c0d00fbc <monero_vamount2uint64+0x58>
c0d00fb8:	9800      	ldr	r0, [sp, #0]
c0d00fba:	4601      	mov	r1, r0
   return xmr;
}
c0d00fbc:	b001      	add	sp, #4
c0d00fbe:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d00fc0 <monero_vamount2str>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_vamount2str(unsigned char *binary,  char *str, unsigned int str_len) {
c0d00fc0:	b5b0      	push	{r4, r5, r7, lr}
c0d00fc2:	4614      	mov	r4, r2
c0d00fc4:	460d      	mov	r5, r1
   return monero_amount2str(monero_vamount2uint64(binary), str,str_len);
c0d00fc6:	f7ff ffcd 	bl	c0d00f64 <monero_vamount2uint64>
c0d00fca:	462a      	mov	r2, r5
c0d00fcc:	4623      	mov	r3, r4
c0d00fce:	f7ff ff45 	bl	c0d00e5c <monero_amount2str>
c0d00fd2:	bdb0      	pop	{r4, r5, r7, pc}

c0d00fd4 <check_potocol>:
#include "monero_api.h"
#include "monero_vars.h"



void check_potocol()  {
c0d00fd4:	b580      	push	{r7, lr}
  /* the first command enforce the protocol version until application quits */
  switch(G_monero_vstate.io_protocol_version) {
c0d00fd6:	4909      	ldr	r1, [pc, #36]	; (c0d00ffc <check_potocol+0x28>)
c0d00fd8:	7888      	ldrb	r0, [r1, #2]
c0d00fda:	2202      	movs	r2, #2
c0d00fdc:	4302      	orrs	r2, r0
c0d00fde:	2a02      	cmp	r2, #2
c0d00fe0:	d107      	bne.n	c0d00ff2 <check_potocol+0x1e>
   case 0x00: /* the first one: PCSC epoch */
   case 0x02: /* protocol V2 */
    if (G_monero_vstate.protocol == 0xff) {
c0d00fe2:	784a      	ldrb	r2, [r1, #1]
c0d00fe4:	2aff      	cmp	r2, #255	; 0xff
c0d00fe6:	d002      	beq.n	c0d00fee <check_potocol+0x1a>
      G_monero_vstate.protocol = G_monero_vstate.io_protocol_version;
    }
    if (G_monero_vstate.protocol == G_monero_vstate.io_protocol_version) {
c0d00fe8:	4282      	cmp	r2, r0
c0d00fea:	d102      	bne.n	c0d00ff2 <check_potocol+0x1e>

   default:
    THROW(SW_CLA_NOT_SUPPORTED);
    return ;
  }
}
c0d00fec:	bd80      	pop	{r7, pc}
  /* the first command enforce the protocol version until application quits */
  switch(G_monero_vstate.io_protocol_version) {
   case 0x00: /* the first one: PCSC epoch */
   case 0x02: /* protocol V2 */
    if (G_monero_vstate.protocol == 0xff) {
      G_monero_vstate.protocol = G_monero_vstate.io_protocol_version;
c0d00fee:	7048      	strb	r0, [r1, #1]

   default:
    THROW(SW_CLA_NOT_SUPPORTED);
    return ;
  }
}
c0d00ff0:	bd80      	pop	{r7, pc}
c0d00ff2:	2037      	movs	r0, #55	; 0x37
c0d00ff4:	0240      	lsls	r0, r0, #9
    }
    //unknown protocol or hot protocol switch is not allowed
    //FALL THROUGH

   default:
    THROW(SW_CLA_NOT_SUPPORTED);
c0d00ff6:	f002 fe9b 	bl	c0d03d30 <os_longjmp>
c0d00ffa:	46c0      	nop			; (mov r8, r8)
c0d00ffc:	20001930 	.word	0x20001930

c0d01000 <check_ins_access>:
    return ;
  }
}

void check_ins_access() {
c0d01000:	b5b0      	push	{r4, r5, r7, lr}
c0d01002:	203d      	movs	r0, #61	; 0x3d
c0d01004:	00c4      	lsls	r4, r0, #3

  if (G_monero_vstate.key_set != 1) {
c0d01006:	4d20      	ldr	r5, [pc, #128]	; (c0d01088 <check_ins_access+0x88>)
c0d01008:	5d28      	ldrb	r0, [r5, r4]
c0d0100a:	07c0      	lsls	r0, r0, #31
c0d0100c:	d039      	beq.n	c0d01082 <check_ins_access+0x82>
    THROW(SW_CONDITIONS_NOT_SATISFIED);
    return;
  }

  switch (G_monero_vstate.io_ins) {
c0d0100e:	78e8      	ldrb	r0, [r5, #3]
c0d01010:	283f      	cmp	r0, #63	; 0x3f
c0d01012:	dd11      	ble.n	c0d01038 <check_ins_access+0x38>
c0d01014:	4602      	mov	r2, r0
c0d01016:	3a70      	subs	r2, #112	; 0x70
c0d01018:	2a10      	cmp	r2, #16
c0d0101a:	d826      	bhi.n	c0d0106a <check_ins_access+0x6a>
c0d0101c:	2101      	movs	r1, #1
c0d0101e:	4091      	lsls	r1, r2
c0d01020:	4a1c      	ldr	r2, [pc, #112]	; (c0d01094 <check_ins_access+0x94>)
c0d01022:	4211      	tst	r1, r2
c0d01024:	d014      	beq.n	c0d01050 <check_ins_access+0x50>
  case INS_GEN_TXOUT_KEYS:
  case INS_BLIND:
  case INS_VALIDATE:
  case INS_MLSAG:
  case INS_GEN_COMMITMENT_MASK:
    if ((os_global_pin_is_validated() != PIN_VERIFIED) ||
c0d01026:	f003 fec5 	bl	c0d04db4 <os_global_pin_is_validated>
c0d0102a:	491b      	ldr	r1, [pc, #108]	; (c0d01098 <check_ins_access+0x98>)
c0d0102c:	4288      	cmp	r0, r1
c0d0102e:	d128      	bne.n	c0d01082 <check_ins_access+0x82>
        (G_monero_vstate.tx_in_progress != 1)) {
c0d01030:	5d28      	ldrb	r0, [r5, r4]
  case INS_GEN_TXOUT_KEYS:
  case INS_BLIND:
  case INS_VALIDATE:
  case INS_MLSAG:
  case INS_GEN_COMMITMENT_MASK:
    if ((os_global_pin_is_validated() != PIN_VERIFIED) ||
c0d01032:	0780      	lsls	r0, r0, #30
c0d01034:	d422      	bmi.n	c0d0107c <check_ins_access+0x7c>
c0d01036:	e024      	b.n	c0d01082 <check_ins_access+0x82>
c0d01038:	4601      	mov	r1, r0
c0d0103a:	3920      	subs	r1, #32
c0d0103c:	291e      	cmp	r1, #30
c0d0103e:	d804      	bhi.n	c0d0104a <check_ins_access+0x4a>
c0d01040:	2201      	movs	r2, #1
c0d01042:	408a      	lsls	r2, r1
c0d01044:	4911      	ldr	r1, [pc, #68]	; (c0d0108c <check_ins_access+0x8c>)
c0d01046:	420a      	tst	r2, r1
c0d01048:	d118      	bne.n	c0d0107c <check_ins_access+0x7c>
  if (G_monero_vstate.key_set != 1) {
    THROW(SW_CONDITIONS_NOT_SATISFIED);
    return;
  }

  switch (G_monero_vstate.io_ins) {
c0d0104a:	2802      	cmp	r0, #2
c0d0104c:	d016      	beq.n	c0d0107c <check_ins_access+0x7c>
c0d0104e:	e018      	b.n	c0d01082 <check_ins_access+0x82>
c0d01050:	2205      	movs	r2, #5
c0d01052:	4211      	tst	r1, r2
c0d01054:	d005      	beq.n	c0d01062 <check_ins_access+0x62>
  case INS_GET_TX_PROOF:
    return;

  case INS_OPEN_TX:
  case INS_SET_SIGNATURE_MODE:
    if (os_global_pin_is_validated() != PIN_VERIFIED) {
c0d01056:	f003 fead 	bl	c0d04db4 <os_global_pin_is_validated>
c0d0105a:	490f      	ldr	r1, [pc, #60]	; (c0d01098 <check_ins_access+0x98>)
c0d0105c:	4288      	cmp	r0, r1
c0d0105e:	d00d      	beq.n	c0d0107c <check_ins_access+0x7c>
c0d01060:	e00f      	b.n	c0d01082 <check_ins_access+0x82>
c0d01062:	2211      	movs	r2, #17
c0d01064:	0192      	lsls	r2, r2, #6
c0d01066:	4211      	tst	r1, r2
c0d01068:	d108      	bne.n	c0d0107c <check_ins_access+0x7c>
c0d0106a:	4601      	mov	r1, r0
c0d0106c:	3940      	subs	r1, #64	; 0x40
c0d0106e:	290c      	cmp	r1, #12
c0d01070:	d805      	bhi.n	c0d0107e <check_ins_access+0x7e>
c0d01072:	2201      	movs	r2, #1
c0d01074:	408a      	lsls	r2, r1
c0d01076:	4906      	ldr	r1, [pc, #24]	; (c0d01090 <check_ins_access+0x90>)
c0d01078:	420a      	tst	r2, r1
c0d0107a:	d000      	beq.n	c0d0107e <check_ins_access+0x7e>
  }

  THROW(SW_CONDITIONS_NOT_SATISFIED);
  return;

}
c0d0107c:	bdb0      	pop	{r4, r5, r7, pc}
  if (G_monero_vstate.key_set != 1) {
    THROW(SW_CONDITIONS_NOT_SATISFIED);
    return;
  }

  switch (G_monero_vstate.io_ins) {
c0d0107e:	28a0      	cmp	r0, #160	; 0xa0
c0d01080:	d0fc      	beq.n	c0d0107c <check_ins_access+0x7c>
c0d01082:	4806      	ldr	r0, [pc, #24]	; (c0d0109c <check_ins_access+0x9c>)
c0d01084:	f002 fe54 	bl	c0d03d30 <os_longjmp>
c0d01088:	20001930 	.word	0x20001930
c0d0108c:	55550155 	.word	0x55550155
c0d01090:	00001555 	.word	0x00001555
c0d01094:	00015980 	.word	0x00015980
c0d01098:	b0105011 	.word	0xb0105011
c0d0109c:	00006985 	.word	0x00006985

c0d010a0 <monero_dispatch>:
  THROW(SW_CONDITIONS_NOT_SATISFIED);
  return;

}

int monero_dispatch() {
c0d010a0:	b510      	push	{r4, lr}

  int sw;

  check_potocol();
c0d010a2:	f7ff ff97 	bl	c0d00fd4 <check_potocol>
  check_ins_access();
c0d010a6:	f7ff ffab 	bl	c0d01000 <check_ins_access>
c0d010aa:	204f      	movs	r0, #79	; 0x4f
c0d010ac:	0084      	lsls	r4, r0, #2

  G_monero_vstate.options = monero_io_fetch_u8();
c0d010ae:	f000 fb3f 	bl	c0d01730 <monero_io_fetch_u8>
c0d010b2:	4975      	ldr	r1, [pc, #468]	; (c0d01288 <monero_dispatch+0x1e8>)
c0d010b4:	5108      	str	r0, [r1, r4]

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d010b6:	78c8      	ldrb	r0, [r1, #3]
c0d010b8:	2843      	cmp	r0, #67	; 0x43
c0d010ba:	dc0a      	bgt.n	c0d010d2 <monero_dispatch+0x32>
c0d010bc:	2833      	cmp	r0, #51	; 0x33
c0d010be:	dc13      	bgt.n	c0d010e8 <monero_dispatch+0x48>
c0d010c0:	2825      	cmp	r0, #37	; 0x25
c0d010c2:	dc23      	bgt.n	c0d0110c <monero_dispatch+0x6c>
c0d010c4:	2821      	cmp	r0, #33	; 0x21
c0d010c6:	dc47      	bgt.n	c0d01158 <monero_dispatch+0xb8>
c0d010c8:	2802      	cmp	r0, #2
c0d010ca:	d16d      	bne.n	c0d011a8 <monero_dispatch+0x108>
    sw = monero_apdu_reset();
c0d010cc:	f000 f9bc 	bl	c0d01448 <monero_apdu_reset>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d010d0:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d010d2:	2876      	cmp	r0, #118	; 0x76
c0d010d4:	dc11      	bgt.n	c0d010fa <monero_dispatch+0x5a>
c0d010d6:	284b      	cmp	r0, #75	; 0x4b
c0d010d8:	dc1f      	bgt.n	c0d0111a <monero_dispatch+0x7a>
c0d010da:	2847      	cmp	r0, #71	; 0x47
c0d010dc:	dc41      	bgt.n	c0d01162 <monero_dispatch+0xc2>
c0d010de:	2844      	cmp	r0, #68	; 0x44
c0d010e0:	d167      	bne.n	c0d011b2 <monero_dispatch+0x112>
    break;
  case INS_SECRET_SCAL_MUL_KEY:
    sw = monero_apdu_scal_mul_key();
    break;
  case INS_SECRET_SCAL_MUL_BASE:
    sw = monero_apdu_scal_mul_base();
c0d010e2:	f000 fdf0 	bl	c0d01cc6 <monero_apdu_scal_mul_base>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d010e6:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d010e8:	283b      	cmp	r0, #59	; 0x3b
c0d010ea:	dc1d      	bgt.n	c0d01128 <monero_dispatch+0x88>
c0d010ec:	2837      	cmp	r0, #55	; 0x37
c0d010ee:	dc3d      	bgt.n	c0d0116c <monero_dispatch+0xcc>
c0d010f0:	2834      	cmp	r0, #52	; 0x34
c0d010f2:	d163      	bne.n	c0d011bc <monero_dispatch+0x11c>
    break;
  case INS_GEN_KEY_DERIVATION:
    sw = monero_apdu_generate_key_derivation();
    break;
  case INS_DERIVATION_TO_SCALAR:
    sw = monero_apdu_derivation_to_scalar();
c0d010f4:	f000 fe4c 	bl	c0d01d90 <monero_apdu_derivation_to_scalar>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d010f8:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d010fa:	287b      	cmp	r0, #123	; 0x7b
c0d010fc:	dc1b      	bgt.n	c0d01136 <monero_dispatch+0x96>
c0d010fe:	2879      	cmp	r0, #121	; 0x79
c0d01100:	dc39      	bgt.n	c0d01176 <monero_dispatch+0xd6>
c0d01102:	2877      	cmp	r0, #119	; 0x77
c0d01104:	d15f      	bne.n	c0d011c6 <monero_dispatch+0x126>
    sw = monero_apu_generate_txout_keys();
    break;

    /*--- COMMITMENT MASK --- */
  case INS_GEN_COMMITMENT_MASK:
    sw = monero_apdu_gen_commitment_mask();
c0d01106:	f7ff f857 	bl	c0d001b8 <monero_apdu_gen_commitment_mask>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0110a:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d0110c:	282f      	cmp	r0, #47	; 0x2f
c0d0110e:	dc37      	bgt.n	c0d01180 <monero_dispatch+0xe0>
c0d01110:	2826      	cmp	r0, #38	; 0x26
c0d01112:	d15d      	bne.n	c0d011d0 <monero_dispatch+0x130>
    sw = monero_apdu_manage_seedwords();
    break;

   /* --- PROVISIONING--- */
  case INS_VERIFY_KEY:
    sw = monero_apdu_verify_key();
c0d01114:	f000 fd14 	bl	c0d01b40 <monero_apdu_verify_key>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01118:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d0111a:	2871      	cmp	r0, #113	; 0x71
c0d0111c:	dc35      	bgt.n	c0d0118a <monero_dispatch+0xea>
c0d0111e:	284c      	cmp	r0, #76	; 0x4c
c0d01120:	d15b      	bne.n	c0d011da <monero_dispatch+0x13a>
    break;
  case INS_GET_SUBADDRESS_SPEND_PUBLIC_KEY:
     sw = monero_apdu_get_subaddress_spend_public_key();
    break;
  case INS_GET_SUBADDRESS_SECRET_KEY:
    sw = monero_apdu_get_subaddress_secret_key();
c0d01122:	f000 ff09 	bl	c0d01f38 <monero_apdu_get_subaddress_secret_key>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01126:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01128:	283f      	cmp	r0, #63	; 0x3f
c0d0112a:	dc33      	bgt.n	c0d01194 <monero_dispatch+0xf4>
c0d0112c:	283c      	cmp	r0, #60	; 0x3c
c0d0112e:	d159      	bne.n	c0d011e4 <monero_dispatch+0x144>
    break;
  case INS_GEN_KEY_IMAGE:
    sw = monero_apdu_generate_key_image();
    break;
  case INS_SECRET_KEY_ADD:
    sw = monero_apdu_sc_add();
c0d01130:	f000 fd70 	bl	c0d01c14 <monero_apdu_sc_add>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01134:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01136:	287f      	cmp	r0, #127	; 0x7f
c0d01138:	dc31      	bgt.n	c0d0119e <monero_dispatch+0xfe>
c0d0113a:	287c      	cmp	r0, #124	; 0x7c
c0d0113c:	d157      	bne.n	c0d011ee <monero_dispatch+0x14e>
    sw = monero_apdu_unblind();
    break;

    /* --- VALIDATE/PREHASH --- */
  case INS_VALIDATE:
    if (G_monero_vstate.io_p1 == 1) {
c0d0113e:	7908      	ldrb	r0, [r1, #4]
c0d01140:	2803      	cmp	r0, #3
c0d01142:	d100      	bne.n	c0d01146 <monero_dispatch+0xa6>
c0d01144:	e08f      	b.n	c0d01266 <monero_dispatch+0x1c6>
c0d01146:	2802      	cmp	r0, #2
c0d01148:	d100      	bne.n	c0d0114c <monero_dispatch+0xac>
c0d0114a:	e089      	b.n	c0d01260 <monero_dispatch+0x1c0>
c0d0114c:	2801      	cmp	r0, #1
c0d0114e:	d000      	beq.n	c0d01152 <monero_dispatch+0xb2>
c0d01150:	e096      	b.n	c0d01280 <monero_dispatch+0x1e0>
      sw = monero_apdu_mlsag_prehash_init();
c0d01152:	f001 fdbd 	bl	c0d02cd0 <monero_apdu_mlsag_prehash_init>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01156:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01158:	2822      	cmp	r0, #34	; 0x22
c0d0115a:	d154      	bne.n	c0d01206 <monero_dispatch+0x166>
    break;


   /* --- KEYS --- */
  case INS_PUT_KEY:
    sw = monero_apdu_put_key();
c0d0115c:	f000 fc58 	bl	c0d01a10 <monero_apdu_put_key>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01160:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01162:	2848      	cmp	r0, #72	; 0x48
c0d01164:	d154      	bne.n	c0d01210 <monero_dispatch+0x170>
  /* --- ADRESSES --- */
  case INS_DERIVE_SUBADDRESS_PUBLIC_KEY:
    sw = monero_apdu_derive_subaddress_public_key();
    break;
  case INS_GET_SUBADDRESS:
    sw = monero_apdu_get_subaddress();
c0d01166:	f000 feb2 	bl	c0d01ece <monero_apdu_get_subaddress>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0116a:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d0116c:	2838      	cmp	r0, #56	; 0x38
c0d0116e:	d154      	bne.n	c0d0121a <monero_dispatch+0x17a>
    break;
  case INS_DERIVE_PUBLIC_KEY:
    sw = monero_apdu_derive_public_key();
    break;
  case INS_DERIVE_SECRET_KEY:
    sw = monero_apdu_derive_secret_key();
c0d01170:	f000 fe4c 	bl	c0d01e0c <monero_apdu_derive_secret_key>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01174:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01176:	287a      	cmp	r0, #122	; 0x7a
c0d01178:	d154      	bne.n	c0d01224 <monero_dispatch+0x184>
    /* --- BLIND --- */
  case INS_BLIND:
    sw = monero_apdu_blind();
    break;
  case INS_UNBLIND:
    sw = monero_apdu_unblind();
c0d0117a:	f7fe ffef 	bl	c0d0015c <monero_apdu_unblind>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0117e:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01180:	2830      	cmp	r0, #48	; 0x30
c0d01182:	d154      	bne.n	c0d0122e <monero_dispatch+0x18e>
    break;
  case INS_GET_CHACHA8_PREKEY:
    sw = monero_apdu_get_chacha8_prekey();
    break;
  case INS_SECRET_KEY_TO_PUBLIC_KEY:
    sw = monero_apdu_secret_key_to_public_key();
c0d01184:	f000 fdcf 	bl	c0d01d26 <monero_apdu_secret_key_to_public_key>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01188:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d0118a:	2872      	cmp	r0, #114	; 0x72
c0d0118c:	d154      	bne.n	c0d01238 <monero_dispatch+0x198>
    sw = monero_apdu_close_tx();
    break;

     /* --- SIG MODE --- */
  case INS_SET_SIGNATURE_MODE:
    sw = monero_apdu_set_signature_mode();
c0d0118e:	f001 fd83 	bl	c0d02c98 <monero_apdu_set_signature_mode>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01192:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01194:	2840      	cmp	r0, #64	; 0x40
c0d01196:	d159      	bne.n	c0d0124c <monero_dispatch+0x1ac>
    break;
  case INS_SECRET_KEY_SUB:
    sw = monero_apdu_sc_sub();
    break;
  case INS_GENERATE_KEYPAIR:
    sw = monero_apdu_generate_keypair();
c0d01198:	f000 fdad 	bl	c0d01cf6 <monero_apdu_generate_keypair>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0119c:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d0119e:	2880      	cmp	r0, #128	; 0x80
c0d011a0:	d159      	bne.n	c0d01256 <monero_dispatch+0x1b6>
  case INS_OPEN_TX:
    sw = monero_apdu_open_tx();
    break;

  case INS_CLOSE_TX:
    sw = monero_apdu_close_tx();
c0d011a2:	f001 fd61 	bl	c0d02c68 <monero_apdu_close_tx>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d011a6:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d011a8:	2820      	cmp	r0, #32
c0d011aa:	d165      	bne.n	c0d01278 <monero_dispatch+0x1d8>
   /* --- KEYS --- */
  case INS_PUT_KEY:
    sw = monero_apdu_put_key();
    break;
  case INS_GET_KEY:
    sw = monero_apdu_get_key();
c0d011ac:	f000 fc94 	bl	c0d01ad8 <monero_apdu_get_key>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d011b0:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d011b2:	2846      	cmp	r0, #70	; 0x46
c0d011b4:	d160      	bne.n	c0d01278 <monero_dispatch+0x1d8>
    sw = monero_apdu_scal_mul_base();
    break;

  /* --- ADRESSES --- */
  case INS_DERIVE_SUBADDRESS_PUBLIC_KEY:
    sw = monero_apdu_derive_subaddress_public_key();
c0d011b6:	f000 fe68 	bl	c0d01e8a <monero_apdu_derive_subaddress_public_key>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d011ba:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d011bc:	2836      	cmp	r0, #54	; 0x36
c0d011be:	d15b      	bne.n	c0d01278 <monero_dispatch+0x1d8>
    break;
  case INS_DERIVATION_TO_SCALAR:
    sw = monero_apdu_derivation_to_scalar();
    break;
  case INS_DERIVE_PUBLIC_KEY:
    sw = monero_apdu_derive_public_key();
c0d011c0:	f000 fe02 	bl	c0d01dc8 <monero_apdu_derive_public_key>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d011c4:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d011c6:	2878      	cmp	r0, #120	; 0x78
c0d011c8:	d156      	bne.n	c0d01278 <monero_dispatch+0x1d8>
    sw = monero_apdu_gen_commitment_mask();
    break;

    /* --- BLIND --- */
  case INS_BLIND:
    sw = monero_apdu_blind();
c0d011ca:	f7fe ff43 	bl	c0d00054 <monero_apdu_blind>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d011ce:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d011d0:	2828      	cmp	r0, #40	; 0x28
c0d011d2:	d151      	bne.n	c0d01278 <monero_dispatch+0x1d8>
    break;
  case INS_GET_KEY:
    sw = monero_apdu_get_key();
    break;
  case INS_MANAGE_SEEDWORDS:
    sw = monero_apdu_manage_seedwords();
c0d011d4:	f000 fb0e 	bl	c0d017f4 <monero_apdu_manage_seedwords>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d011d8:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d011da:	2870      	cmp	r0, #112	; 0x70
c0d011dc:	d14c      	bne.n	c0d01278 <monero_dispatch+0x1d8>

  switch (G_monero_vstate.io_ins) {

    /* --- START TX --- */
  case INS_OPEN_TX:
    sw = monero_apdu_open_tx();
c0d011de:	f001 fd11 	bl	c0d02c04 <monero_apdu_open_tx>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d011e2:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d011e4:	283e      	cmp	r0, #62	; 0x3e
c0d011e6:	d147      	bne.n	c0d01278 <monero_dispatch+0x1d8>
    break;
  case INS_SECRET_KEY_ADD:
    sw = monero_apdu_sc_add();
    break;
  case INS_SECRET_KEY_SUB:
    sw = monero_apdu_sc_sub();
c0d011e8:	f000 fd32 	bl	c0d01c50 <monero_apdu_sc_sub>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d011ec:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d011ee:	287e      	cmp	r0, #126	; 0x7e
c0d011f0:	d142      	bne.n	c0d01278 <monero_dispatch+0x1d8>
    }
    break;

  /* --- MLSAG --- */
  case INS_MLSAG:
    if (G_monero_vstate.io_p1 == 1) {
c0d011f2:	7908      	ldrb	r0, [r1, #4]
c0d011f4:	2803      	cmp	r0, #3
c0d011f6:	d03c      	beq.n	c0d01272 <monero_dispatch+0x1d2>
c0d011f8:	2802      	cmp	r0, #2
c0d011fa:	d037      	beq.n	c0d0126c <monero_dispatch+0x1cc>
c0d011fc:	2801      	cmp	r0, #1
c0d011fe:	d13f      	bne.n	c0d01280 <monero_dispatch+0x1e0>
      sw = monero_apdu_mlsag_prepare();
c0d01200:	f001 fae2 	bl	c0d027c8 <monero_apdu_mlsag_prepare>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01204:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01206:	2824      	cmp	r0, #36	; 0x24
c0d01208:	d136      	bne.n	c0d01278 <monero_dispatch+0x1d8>
   /* --- PROVISIONING--- */
  case INS_VERIFY_KEY:
    sw = monero_apdu_verify_key();
    break;
  case INS_GET_CHACHA8_PREKEY:
    sw = monero_apdu_get_chacha8_prekey();
c0d0120a:	f000 fcd1 	bl	c0d01bb0 <monero_apdu_get_chacha8_prekey>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0120e:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01210:	284a      	cmp	r0, #74	; 0x4a
c0d01212:	d131      	bne.n	c0d01278 <monero_dispatch+0x1d8>
    break;
  case INS_GET_SUBADDRESS:
    sw = monero_apdu_get_subaddress();
    break;
  case INS_GET_SUBADDRESS_SPEND_PUBLIC_KEY:
     sw = monero_apdu_get_subaddress_spend_public_key();
c0d01214:	f000 fe79 	bl	c0d01f0a <monero_apdu_get_subaddress_spend_public_key>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01218:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d0121a:	283a      	cmp	r0, #58	; 0x3a
c0d0121c:	d12c      	bne.n	c0d01278 <monero_dispatch+0x1d8>
    break;
  case INS_DERIVE_SECRET_KEY:
    sw = monero_apdu_derive_secret_key();
    break;
  case INS_GEN_KEY_IMAGE:
    sw = monero_apdu_generate_key_image();
c0d0121e:	f000 fe16 	bl	c0d01e4e <monero_apdu_generate_key_image>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01222:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01224:	287b      	cmp	r0, #123	; 0x7b
c0d01226:	d127      	bne.n	c0d01278 <monero_dispatch+0x1d8>
    sw = monero_apdu_get_tx_proof();
    break;

    /* --- TX OUT KEYS --- */
  case INS_GEN_TXOUT_KEYS:
    sw = monero_apu_generate_txout_keys();
c0d01228:	f000 fea2 	bl	c0d01f70 <monero_apu_generate_txout_keys>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0122c:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d0122e:	2832      	cmp	r0, #50	; 0x32
c0d01230:	d122      	bne.n	c0d01278 <monero_dispatch+0x1d8>
    break;
  case INS_SECRET_KEY_TO_PUBLIC_KEY:
    sw = monero_apdu_secret_key_to_public_key();
    break;
  case INS_GEN_KEY_DERIVATION:
    sw = monero_apdu_generate_key_derivation();
c0d01232:	f000 fd90 	bl	c0d01d56 <monero_apdu_generate_key_derivation>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01236:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01238:	2876      	cmp	r0, #118	; 0x76
c0d0123a:	d11d      	bne.n	c0d01278 <monero_dispatch+0x1d8>
    sw = monero_apdu_set_signature_mode();
    break;

    /* --- STEATH PAYMENT --- */
  case INS_STEALTH:
    if ((G_monero_vstate.io_p1 != 0) ||
c0d0123c:	7908      	ldrb	r0, [r1, #4]
        (G_monero_vstate.io_p2 != 0)) {
c0d0123e:	7949      	ldrb	r1, [r1, #5]
    sw = monero_apdu_set_signature_mode();
    break;

    /* --- STEATH PAYMENT --- */
  case INS_STEALTH:
    if ((G_monero_vstate.io_p1 != 0) ||
c0d01240:	4301      	orrs	r1, r0
c0d01242:	2900      	cmp	r1, #0
c0d01244:	d11c      	bne.n	c0d01280 <monero_dispatch+0x1e0>
        (G_monero_vstate.io_p2 != 0)) {
      THROW(SW_WRONG_P1P2);
    }
    sw = monero_apdu_stealth();
c0d01246:	f001 ff8f 	bl	c0d03168 <monero_apdu_stealth>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0124a:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d0124c:	2842      	cmp	r0, #66	; 0x42
c0d0124e:	d113      	bne.n	c0d01278 <monero_dispatch+0x1d8>
    break;
  case INS_GENERATE_KEYPAIR:
    sw = monero_apdu_generate_keypair();
    break;
  case INS_SECRET_SCAL_MUL_KEY:
    sw = monero_apdu_scal_mul_key();
c0d01250:	f000 fd1c 	bl	c0d01c8c <monero_apdu_scal_mul_key>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01254:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01256:	28a0      	cmp	r0, #160	; 0xa0
c0d01258:	d10e      	bne.n	c0d01278 <monero_dispatch+0x1d8>
    break;

    /* --- PROOF --- */

  case INS_GET_TX_PROOF:
    sw = monero_apdu_get_tx_proof();
c0d0125a:	f001 fef9 	bl	c0d03050 <monero_apdu_get_tx_proof>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0125e:	bd10      	pop	{r4, pc}
    /* --- VALIDATE/PREHASH --- */
  case INS_VALIDATE:
    if (G_monero_vstate.io_p1 == 1) {
      sw = monero_apdu_mlsag_prehash_init();
    }  else if (G_monero_vstate.io_p1 == 2) {
      sw = monero_apdu_mlsag_prehash_update();
c0d01260:	f001 fd84 	bl	c0d02d6c <monero_apdu_mlsag_prehash_update>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01264:	bd10      	pop	{r4, pc}
    if (G_monero_vstate.io_p1 == 1) {
      sw = monero_apdu_mlsag_prehash_init();
    }  else if (G_monero_vstate.io_p1 == 2) {
      sw = monero_apdu_mlsag_prehash_update();
    }  else if (G_monero_vstate.io_p1 == 3) {
      sw = monero_apdu_mlsag_prehash_finalize();
c0d01266:	f001 fe83 	bl	c0d02f70 <monero_apdu_mlsag_prehash_finalize>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0126a:	bd10      	pop	{r4, pc}
  /* --- MLSAG --- */
  case INS_MLSAG:
    if (G_monero_vstate.io_p1 == 1) {
      sw = monero_apdu_mlsag_prepare();
    }  else if (G_monero_vstate.io_p1 == 2) {
      sw = monero_apdu_mlsag_hash();
c0d0126c:	f001 fb14 	bl	c0d02898 <monero_apdu_mlsag_hash>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01270:	bd10      	pop	{r4, pc}
    if (G_monero_vstate.io_p1 == 1) {
      sw = monero_apdu_mlsag_prepare();
    }  else if (G_monero_vstate.io_p1 == 2) {
      sw = monero_apdu_mlsag_hash();
    }  else if (G_monero_vstate.io_p1 == 3) {
      sw = monero_apdu_mlsag_sign();
c0d01272:	f001 fb53 	bl	c0d0291c <monero_apdu_mlsag_sign>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01276:	bd10      	pop	{r4, pc}
c0d01278:	206d      	movs	r0, #109	; 0x6d
c0d0127a:	0200      	lsls	r0, r0, #8
    break;

  /* --- KEYS --- */

  default:
    THROW(SW_INS_NOT_SUPPORTED);
c0d0127c:	f002 fd58 	bl	c0d03d30 <os_longjmp>
c0d01280:	206b      	movs	r0, #107	; 0x6b
c0d01282:	0200      	lsls	r0, r0, #8
c0d01284:	f002 fd54 	bl	c0d03d30 <os_longjmp>
c0d01288:	20001930 	.word	0x20001930

c0d0128c <monero_init>:
};

/* ----------------------------------------------------------------------- */
/* --- Boot                                                            --- */
/* ----------------------------------------------------------------------- */
void monero_init() {
c0d0128c:	b510      	push	{r4, lr}
c0d0128e:	2083      	movs	r0, #131	; 0x83
c0d01290:	0102      	lsls	r2, r0, #4
  os_memset(&G_monero_vstate, 0, sizeof(monero_v_state_t));
c0d01292:	4c0d      	ldr	r4, [pc, #52]	; (c0d012c8 <monero_init+0x3c>)
c0d01294:	2100      	movs	r1, #0
c0d01296:	4620      	mov	r0, r4
c0d01298:	f002 fc72 	bl	c0d03b80 <os_memset>

  //first init ?
  if (os_memcmp(N_monero_pstate->magic, (void*)C_MAGIC, sizeof(C_MAGIC)) != 0) {
c0d0129c:	480b      	ldr	r0, [pc, #44]	; (c0d012cc <monero_init+0x40>)
c0d0129e:	f003 fb65 	bl	c0d0496c <pic>
c0d012a2:	490b      	ldr	r1, [pc, #44]	; (c0d012d0 <monero_init+0x44>)
c0d012a4:	4479      	add	r1, pc
c0d012a6:	2208      	movs	r2, #8
c0d012a8:	f002 fd2e 	bl	c0d03d08 <os_memcmp>
c0d012ac:	2800      	cmp	r0, #0
c0d012ae:	d002      	beq.n	c0d012b6 <monero_init+0x2a>
c0d012b0:	2000      	movs	r0, #0
    monero_install(MAINNET);
c0d012b2:	f000 f80f 	bl	c0d012d4 <monero_install>
c0d012b6:	203f      	movs	r0, #63	; 0x3f
c0d012b8:	43c0      	mvns	r0, r0
  }

  G_monero_vstate.protocol = 0xff;
c0d012ba:	303f      	adds	r0, #63	; 0x3f
c0d012bc:	7060      	strb	r0, [r4, #1]

  //load key
  monero_init_private_key();
c0d012be:	f000 f839 	bl	c0d01334 <monero_init_private_key>
c0d012c2:	20c0      	movs	r0, #192	; 0xc0
  //ux conf
  monero_init_ux();
  // Let's go!
  G_monero_vstate.state = STATE_IDLE;
c0d012c4:	7020      	strb	r0, [r4, #0]
}
c0d012c6:	bd10      	pop	{r4, pc}
c0d012c8:	20001930 	.word	0x20001930
c0d012cc:	c0d07ec0 	.word	0xc0d07ec0
c0d012d0:	000059d0 	.word	0x000059d0

c0d012d4 <monero_install>:
}

/* ----------------------------------------------------------------------- */
/* ---  Install/ReInstall Monero app                                   --- */
/* ----------------------------------------------------------------------- */
void monero_install(unsigned char netId) {
c0d012d4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d012d6:	b083      	sub	sp, #12
c0d012d8:	ad02      	add	r5, sp, #8
c0d012da:	7028      	strb	r0, [r5, #0]
  unsigned char c;

  //full reset data
  monero_nvm_write(N_monero_pstate, NULL, sizeof(monero_nv_state_t));
c0d012dc:	4c12      	ldr	r4, [pc, #72]	; (c0d01328 <monero_install+0x54>)
c0d012de:	4620      	mov	r0, r4
c0d012e0:	f003 fb44 	bl	c0d0496c <pic>
c0d012e4:	2100      	movs	r1, #0
c0d012e6:	4a11      	ldr	r2, [pc, #68]	; (c0d0132c <monero_install+0x58>)
c0d012e8:	f003 fb82 	bl	c0d049f0 <nvm_write>
c0d012ec:	ae01      	add	r6, sp, #4
c0d012ee:	2042      	movs	r0, #66	; 0x42

  //set mode key
  c = KEY_MODE_SEED;
c0d012f0:	7030      	strb	r0, [r6, #0]
  nvm_write(&N_monero_pstate->key_mode, &c, 1);
c0d012f2:	4620      	mov	r0, r4
c0d012f4:	f003 fb3a 	bl	c0d0496c <pic>
c0d012f8:	3009      	adds	r0, #9
c0d012fa:	2701      	movs	r7, #1
c0d012fc:	4631      	mov	r1, r6
c0d012fe:	463a      	mov	r2, r7
c0d01300:	f003 fb76 	bl	c0d049f0 <nvm_write>

  //set net id
  monero_nvm_write(&N_monero_pstate->network_id, &netId, 1);
c0d01304:	4620      	mov	r0, r4
c0d01306:	f003 fb31 	bl	c0d0496c <pic>
c0d0130a:	3008      	adds	r0, #8
c0d0130c:	4629      	mov	r1, r5
c0d0130e:	463a      	mov	r2, r7
c0d01310:	f003 fb6e 	bl	c0d049f0 <nvm_write>

  //write magic
  monero_nvm_write(N_monero_pstate->magic, (void*)C_MAGIC, sizeof(C_MAGIC));
c0d01314:	4620      	mov	r0, r4
c0d01316:	f003 fb29 	bl	c0d0496c <pic>
c0d0131a:	4905      	ldr	r1, [pc, #20]	; (c0d01330 <monero_install+0x5c>)
c0d0131c:	4479      	add	r1, pc
c0d0131e:	2208      	movs	r2, #8
c0d01320:	f003 fb66 	bl	c0d049f0 <nvm_write>
}
c0d01324:	b003      	add	sp, #12
c0d01326:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d01328:	c0d07ec0 	.word	0xc0d07ec0
c0d0132c:	00000252 	.word	0x00000252
c0d01330:	00005958 	.word	0x00005958

c0d01334 <monero_init_private_key>:
 os_memset(G_monero_vstate.B,  0, 32);
 os_memset(&G_monero_vstate.spk, 0, sizeof(G_monero_vstate.spk));
 G_monero_vstate.key_set = 0;
}

void monero_init_private_key() {
c0d01334:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01336:	b099      	sub	sp, #100	; 0x64
c0d01338:	4840      	ldr	r0, [pc, #256]	; (c0d0143c <monero_init_private_key+0x108>)

  //generate account keys

  // m/44'/10343'/0'/0/0
  path[0] = 0x8000002C;
  path[1] = 0x80002867;
c0d0133a:	9015      	str	r0, [sp, #84]	; 0x54
c0d0133c:	2000      	movs	r0, #0
  path[2] = 0x80000000;
  path[3] = 0x00000000;
c0d0133e:	9017      	str	r0, [sp, #92]	; 0x5c
  path[4] = 0x00000000;
c0d01340:	9018      	str	r0, [sp, #96]	; 0x60
c0d01342:	2701      	movs	r7, #1
c0d01344:	07f8      	lsls	r0, r7, #31
  //generate account keys

  // m/44'/10343'/0'/0/0
  path[0] = 0x8000002C;
  path[1] = 0x80002867;
  path[2] = 0x80000000;
c0d01346:	9016      	str	r0, [sp, #88]	; 0x58
  unsigned char chain[32];

  //generate account keys

  // m/44'/10343'/0'/0/0
  path[0] = 0x8000002C;
c0d01348:	302c      	adds	r0, #44	; 0x2c
c0d0134a:	9014      	str	r0, [sp, #80]	; 0x50
c0d0134c:	a804      	add	r0, sp, #16
  path[1] = 0x80002867;
  path[2] = 0x80000000;
  path[3] = 0x00000000;
  path[4] = 0x00000000;
  os_perso_derive_node_bip32(CX_CURVE_SECP256K1, path, 5 , seed, chain);
c0d0134e:	4669      	mov	r1, sp
c0d01350:	6008      	str	r0, [r1, #0]
c0d01352:	2021      	movs	r0, #33	; 0x21
c0d01354:	a914      	add	r1, sp, #80	; 0x50
c0d01356:	2205      	movs	r2, #5
c0d01358:	ab0c      	add	r3, sp, #48	; 0x30
c0d0135a:	f003 fd13 	bl	c0d04d84 <os_perso_derive_node_bip32>

  switch(N_monero_pstate->key_mode) {
c0d0135e:	4838      	ldr	r0, [pc, #224]	; (c0d01440 <monero_init_private_key+0x10c>)
c0d01360:	f003 fb04 	bl	c0d0496c <pic>
c0d01364:	7a40      	ldrb	r0, [r0, #9]
c0d01366:	2821      	cmp	r0, #33	; 0x21
c0d01368:	d028      	beq.n	c0d013bc <monero_init_private_key+0x88>
c0d0136a:	9703      	str	r7, [sp, #12]
c0d0136c:	2842      	cmp	r0, #66	; 0x42
c0d0136e:	d160      	bne.n	c0d01432 <monero_init_private_key+0xfe>
c0d01370:	2061      	movs	r0, #97	; 0x61
c0d01372:	0080      	lsls	r0, r0, #2
  case KEY_MODE_SEED:

    monero_keccak_F(seed,32,G_monero_vstate.b);
c0d01374:	4d33      	ldr	r5, [pc, #204]	; (c0d01444 <monero_init_private_key+0x110>)
c0d01376:	182c      	adds	r4, r5, r0
c0d01378:	4668      	mov	r0, sp
c0d0137a:	6004      	str	r4, [r0, #0]
c0d0137c:	2023      	movs	r0, #35	; 0x23
c0d0137e:	0100      	lsls	r0, r0, #4
c0d01380:	1829      	adds	r1, r5, r0
c0d01382:	9102      	str	r1, [sp, #8]
c0d01384:	2706      	movs	r7, #6
c0d01386:	aa0c      	add	r2, sp, #48	; 0x30
c0d01388:	2620      	movs	r6, #32
c0d0138a:	4638      	mov	r0, r7
c0d0138c:	4633      	mov	r3, r6
c0d0138e:	f7fe ff9d 	bl	c0d002cc <monero_hash>
    monero_reduce(G_monero_vstate.b,G_monero_vstate.b);
c0d01392:	4620      	mov	r0, r4
c0d01394:	4621      	mov	r1, r4
c0d01396:	f7fe fff7 	bl	c0d00388 <monero_reduce>
c0d0139a:	2051      	movs	r0, #81	; 0x51
c0d0139c:	0080      	lsls	r0, r0, #2
    monero_keccak_F(G_monero_vstate.b,32,G_monero_vstate.a);
c0d0139e:	182d      	adds	r5, r5, r0
c0d013a0:	4668      	mov	r0, sp
c0d013a2:	6005      	str	r5, [r0, #0]
c0d013a4:	4638      	mov	r0, r7
c0d013a6:	9902      	ldr	r1, [sp, #8]
c0d013a8:	4622      	mov	r2, r4
c0d013aa:	4633      	mov	r3, r6
c0d013ac:	f7fe ff8e 	bl	c0d002cc <monero_hash>
    monero_reduce(G_monero_vstate.a,G_monero_vstate.a);
c0d013b0:	4628      	mov	r0, r5
c0d013b2:	4629      	mov	r1, r5
c0d013b4:	f7fe ffe8 	bl	c0d00388 <monero_reduce>
c0d013b8:	9f03      	ldr	r7, [sp, #12]
c0d013ba:	e018      	b.n	c0d013ee <monero_init_private_key+0xba>
    break;

  case KEY_MODE_EXTERNAL:
    os_memmove(G_monero_vstate.a,  N_monero_pstate->a, 32);
c0d013bc:	4c20      	ldr	r4, [pc, #128]	; (c0d01440 <monero_init_private_key+0x10c>)
c0d013be:	4620      	mov	r0, r4
c0d013c0:	f003 fad4 	bl	c0d0496c <pic>
c0d013c4:	4601      	mov	r1, r0
c0d013c6:	2051      	movs	r0, #81	; 0x51
c0d013c8:	0080      	lsls	r0, r0, #2
c0d013ca:	4e1e      	ldr	r6, [pc, #120]	; (c0d01444 <monero_init_private_key+0x110>)
c0d013cc:	1830      	adds	r0, r6, r0
c0d013ce:	310a      	adds	r1, #10
c0d013d0:	2520      	movs	r5, #32
c0d013d2:	462a      	mov	r2, r5
c0d013d4:	f002 fbdd 	bl	c0d03b92 <os_memmove>
    os_memmove(G_monero_vstate.b,  N_monero_pstate->b, 32);
c0d013d8:	4620      	mov	r0, r4
c0d013da:	f003 fac7 	bl	c0d0496c <pic>
c0d013de:	4601      	mov	r1, r0
c0d013e0:	2061      	movs	r0, #97	; 0x61
c0d013e2:	0080      	lsls	r0, r0, #2
c0d013e4:	1830      	adds	r0, r6, r0
c0d013e6:	312a      	adds	r1, #42	; 0x2a
c0d013e8:	462a      	mov	r2, r5
c0d013ea:	f002 fbd2 	bl	c0d03b92 <os_memmove>
c0d013ee:	2059      	movs	r0, #89	; 0x59
c0d013f0:	0080      	lsls	r0, r0, #2
  default :
    THROW(SW_SECURITY_LOAD_KEY);
    return;
  }

  monero_ecmul_G(G_monero_vstate.A, G_monero_vstate.a);
c0d013f2:	4e14      	ldr	r6, [pc, #80]	; (c0d01444 <monero_init_private_key+0x110>)
c0d013f4:	1830      	adds	r0, r6, r0
c0d013f6:	2151      	movs	r1, #81	; 0x51
c0d013f8:	0089      	lsls	r1, r1, #2
c0d013fa:	1874      	adds	r4, r6, r1
c0d013fc:	4621      	mov	r1, r4
c0d013fe:	f7ff fa1d 	bl	c0d0083c <monero_ecmul_G>
c0d01402:	2069      	movs	r0, #105	; 0x69
c0d01404:	0080      	lsls	r0, r0, #2
  monero_ecmul_G(G_monero_vstate.B, G_monero_vstate.b);
c0d01406:	1830      	adds	r0, r6, r0
c0d01408:	2161      	movs	r1, #97	; 0x61
c0d0140a:	0089      	lsls	r1, r1, #2
c0d0140c:	1875      	adds	r5, r6, r1
c0d0140e:	4629      	mov	r1, r5
c0d01410:	f7ff fa14 	bl	c0d0083c <monero_ecmul_G>
c0d01414:	2071      	movs	r0, #113	; 0x71
c0d01416:	0080      	lsls	r0, r0, #2

  //generate key protection
  monero_aes_derive(&G_monero_vstate.spk,chain,G_monero_vstate.a,G_monero_vstate.b);
c0d01418:	1830      	adds	r0, r6, r0
c0d0141a:	a904      	add	r1, sp, #16
c0d0141c:	4622      	mov	r2, r4
c0d0141e:	462b      	mov	r3, r5
c0d01420:	f7fe fee2 	bl	c0d001e8 <monero_aes_derive>
c0d01424:	203d      	movs	r0, #61	; 0x3d
c0d01426:	00c0      	lsls	r0, r0, #3


  G_monero_vstate.key_set = 1;
c0d01428:	5c31      	ldrb	r1, [r6, r0]
c0d0142a:	4339      	orrs	r1, r7
c0d0142c:	5431      	strb	r1, [r6, r0]
}
c0d0142e:	b019      	add	sp, #100	; 0x64
c0d01430:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d01432:	2069      	movs	r0, #105	; 0x69
c0d01434:	0200      	lsls	r0, r0, #8
    os_memmove(G_monero_vstate.a,  N_monero_pstate->a, 32);
    os_memmove(G_monero_vstate.b,  N_monero_pstate->b, 32);
    break;

  default :
    THROW(SW_SECURITY_LOAD_KEY);
c0d01436:	f002 fc7b 	bl	c0d03d30 <os_longjmp>
c0d0143a:	46c0      	nop			; (mov r8, r8)
c0d0143c:	80002867 	.word	0x80002867
c0d01440:	c0d07ec0 	.word	0xc0d07ec0
c0d01444:	20001930 	.word	0x20001930

c0d01448 <monero_apdu_reset>:
#define MONERO_SUPPORTED_CLIENT_SIZE 1
const char * const monero_supported_client[MONERO_SUPPORTED_CLIENT_SIZE] = {
  "3.0.0",
};

int monero_apdu_reset() {
c0d01448:	b510      	push	{r4, lr}
c0d0144a:	b084      	sub	sp, #16

  unsigned int client_version_len;
  char client_version[10];
  client_version_len = G_monero_vstate.io_length - G_monero_vstate.io_offset;
c0d0144c:	481a      	ldr	r0, [pc, #104]	; (c0d014b8 <monero_apdu_reset+0x70>)
c0d0144e:	8941      	ldrh	r1, [r0, #10]
c0d01450:	8900      	ldrh	r0, [r0, #8]
c0d01452:	1a44      	subs	r4, r0, r1
  if (client_version_len > 10) {
c0d01454:	2c0b      	cmp	r4, #11
c0d01456:	d22b      	bcs.n	c0d014b0 <monero_apdu_reset+0x68>
c0d01458:	a801      	add	r0, sp, #4
    THROW(SW_CLIENT_NOT_SUPPORTED+1);
  }
  monero_io_fetch(client_version, client_version_len);
c0d0145a:	4621      	mov	r1, r4
c0d0145c:	f000 f8d4 	bl	c0d01608 <monero_io_fetch>

  unsigned int i = 0;
  while(i < MONERO_SUPPORTED_CLIENT_SIZE) {
    if ((strlen(PIC(monero_supported_client[i])) == client_version_len) &&
c0d01460:	4817      	ldr	r0, [pc, #92]	; (c0d014c0 <monero_apdu_reset+0x78>)
c0d01462:	4478      	add	r0, pc
c0d01464:	f003 fa82 	bl	c0d0496c <pic>
c0d01468:	f005 faba 	bl	c0d069e0 <strlen>
c0d0146c:	42a0      	cmp	r0, r4
c0d0146e:	d11c      	bne.n	c0d014aa <monero_apdu_reset+0x62>
        (os_memcmp(PIC(monero_supported_client[i]), client_version, client_version_len)==0) ) {
c0d01470:	4814      	ldr	r0, [pc, #80]	; (c0d014c4 <monero_apdu_reset+0x7c>)
c0d01472:	4478      	add	r0, pc
c0d01474:	f003 fa7a 	bl	c0d0496c <pic>
c0d01478:	a901      	add	r1, sp, #4
c0d0147a:	4622      	mov	r2, r4
c0d0147c:	f002 fc44 	bl	c0d03d08 <os_memcmp>
  }
  monero_io_fetch(client_version, client_version_len);

  unsigned int i = 0;
  while(i < MONERO_SUPPORTED_CLIENT_SIZE) {
    if ((strlen(PIC(monero_supported_client[i])) == client_version_len) &&
c0d01480:	2800      	cmp	r0, #0
c0d01482:	d112      	bne.n	c0d014aa <monero_apdu_reset+0x62>
c0d01484:	2000      	movs	r0, #0
  }
  if (i == MONERO_SUPPORTED_CLIENT_SIZE) {
    THROW(SW_CLIENT_NOT_SUPPORTED);
  }

  monero_io_discard(0);
c0d01486:	f000 f829 	bl	c0d014dc <monero_io_discard>
  monero_init();
c0d0148a:	f7ff feff 	bl	c0d0128c <monero_init>
c0d0148e:	2401      	movs	r4, #1
  monero_io_insert_u8(MONERO_VERSION_MAJOR);
c0d01490:	4620      	mov	r0, r4
c0d01492:	f000 f8ab 	bl	c0d015ec <monero_io_insert_u8>
c0d01496:	2003      	movs	r0, #3
  monero_io_insert_u8(MONERO_VERSION_MINOR);
c0d01498:	f000 f8a8 	bl	c0d015ec <monero_io_insert_u8>
  monero_io_insert_u8(MONERO_VERSION_MICRO);
c0d0149c:	4620      	mov	r0, r4
c0d0149e:	f000 f8a5 	bl	c0d015ec <monero_io_insert_u8>
c0d014a2:	2009      	movs	r0, #9
c0d014a4:	0300      	lsls	r0, r0, #12
  return 0x9000;
c0d014a6:	b004      	add	sp, #16
c0d014a8:	bd10      	pop	{r4, pc}
c0d014aa:	4804      	ldr	r0, [pc, #16]	; (c0d014bc <monero_apdu_reset+0x74>)
      break;
    }
    i++;
  }
  if (i == MONERO_SUPPORTED_CLIENT_SIZE) {
    THROW(SW_CLIENT_NOT_SUPPORTED);
c0d014ac:	f002 fc40 	bl	c0d03d30 <os_longjmp>
c0d014b0:	4802      	ldr	r0, [pc, #8]	; (c0d014bc <monero_apdu_reset+0x74>)

  unsigned int client_version_len;
  char client_version[10];
  client_version_len = G_monero_vstate.io_length - G_monero_vstate.io_offset;
  if (client_version_len > 10) {
    THROW(SW_CLIENT_NOT_SUPPORTED+1);
c0d014b2:	1c40      	adds	r0, r0, #1
c0d014b4:	f002 fc3c 	bl	c0d03d30 <os_longjmp>
c0d014b8:	20001930 	.word	0x20001930
c0d014bc:	00006930 	.word	0x00006930
c0d014c0:	0000581a 	.word	0x0000581a
c0d014c4:	0000580a 	.word	0x0000580a

c0d014c8 <monero_io_inserted>:
  G_monero_vstate.io_mark = G_monero_vstate.io_offset;
}


void monero_io_inserted(unsigned int len) {
  G_monero_vstate.io_offset += len;
c0d014c8:	4903      	ldr	r1, [pc, #12]	; (c0d014d8 <monero_io_inserted+0x10>)
c0d014ca:	894a      	ldrh	r2, [r1, #10]
c0d014cc:	1812      	adds	r2, r2, r0
c0d014ce:	814a      	strh	r2, [r1, #10]
  G_monero_vstate.io_length += len;
c0d014d0:	890a      	ldrh	r2, [r1, #8]
c0d014d2:	1810      	adds	r0, r2, r0
c0d014d4:	8108      	strh	r0, [r1, #8]
}
c0d014d6:	4770      	bx	lr
c0d014d8:	20001930 	.word	0x20001930

c0d014dc <monero_io_discard>:

void monero_io_discard(int clear) {
c0d014dc:	b580      	push	{r7, lr}
c0d014de:	4601      	mov	r1, r0
  G_monero_vstate.io_length = 0;
c0d014e0:	4806      	ldr	r0, [pc, #24]	; (c0d014fc <monero_io_discard+0x20>)
c0d014e2:	2200      	movs	r2, #0
  G_monero_vstate.io_offset = 0;
  G_monero_vstate.io_mark = 0;
c0d014e4:	8182      	strh	r2, [r0, #12]
  G_monero_vstate.io_offset += len;
  G_monero_vstate.io_length += len;
}

void monero_io_discard(int clear) {
  G_monero_vstate.io_length = 0;
c0d014e6:	6082      	str	r2, [r0, #8]
  G_monero_vstate.io_offset = 0;
  G_monero_vstate.io_mark = 0;
  if (clear) {
c0d014e8:	2900      	cmp	r1, #0
c0d014ea:	d005      	beq.n	c0d014f8 <monero_io_discard+0x1c>
    monero_io_clear();
  }
}

void monero_io_clear() {
  os_memset(G_monero_vstate.io_buffer, 0 , MONERO_IO_BUFFER_LENGTH);
c0d014ec:	300e      	adds	r0, #14
c0d014ee:	214b      	movs	r1, #75	; 0x4b
c0d014f0:	008a      	lsls	r2, r1, #2
c0d014f2:	2100      	movs	r1, #0
c0d014f4:	f002 fb44 	bl	c0d03b80 <os_memset>
  G_monero_vstate.io_offset = 0;
  G_monero_vstate.io_mark = 0;
  if (clear) {
    monero_io_clear();
  }
}
c0d014f8:	bd80      	pop	{r7, pc}
c0d014fa:	46c0      	nop			; (mov r8, r8)
c0d014fc:	20001930 	.word	0x20001930

c0d01500 <monero_io_hole>:

/* ----------------------------------------------------------------------- */
/* INSERT data to be sent                                                  */
/* ----------------------------------------------------------------------- */

void monero_io_hole(unsigned int sz) {
c0d01500:	b5b0      	push	{r4, r5, r7, lr}
c0d01502:	4604      	mov	r4, r0
  if ((G_monero_vstate.io_length + sz) > MONERO_IO_BUFFER_LENGTH) {
c0d01504:	4d0a      	ldr	r5, [pc, #40]	; (c0d01530 <monero_io_hole+0x30>)
c0d01506:	8928      	ldrh	r0, [r5, #8]
c0d01508:	1901      	adds	r1, r0, r4
c0d0150a:	22ff      	movs	r2, #255	; 0xff
c0d0150c:	322e      	adds	r2, #46	; 0x2e
c0d0150e:	4291      	cmp	r1, r2
c0d01510:	d20a      	bcs.n	c0d01528 <monero_io_hole+0x28>
    THROW(ERROR_IO_FULL);
    return ;
  }
  os_memmove(G_monero_vstate.io_buffer+G_monero_vstate.io_offset+sz,
c0d01512:	8969      	ldrh	r1, [r5, #10]
             G_monero_vstate.io_buffer+G_monero_vstate.io_offset,
             G_monero_vstate.io_length-G_monero_vstate.io_offset);
c0d01514:	1a42      	subs	r2, r0, r1
void monero_io_hole(unsigned int sz) {
  if ((G_monero_vstate.io_length + sz) > MONERO_IO_BUFFER_LENGTH) {
    THROW(ERROR_IO_FULL);
    return ;
  }
  os_memmove(G_monero_vstate.io_buffer+G_monero_vstate.io_offset+sz,
c0d01516:	1869      	adds	r1, r5, r1
c0d01518:	310e      	adds	r1, #14
c0d0151a:	1908      	adds	r0, r1, r4
c0d0151c:	f002 fb39 	bl	c0d03b92 <os_memmove>
             G_monero_vstate.io_buffer+G_monero_vstate.io_offset,
             G_monero_vstate.io_length-G_monero_vstate.io_offset);
  G_monero_vstate.io_length += sz;
c0d01520:	8928      	ldrh	r0, [r5, #8]
c0d01522:	1900      	adds	r0, r0, r4
c0d01524:	8128      	strh	r0, [r5, #8]
}
c0d01526:	bdb0      	pop	{r4, r5, r7, pc}
c0d01528:	2001      	movs	r0, #1
c0d0152a:	0440      	lsls	r0, r0, #17
/* INSERT data to be sent                                                  */
/* ----------------------------------------------------------------------- */

void monero_io_hole(unsigned int sz) {
  if ((G_monero_vstate.io_length + sz) > MONERO_IO_BUFFER_LENGTH) {
    THROW(ERROR_IO_FULL);
c0d0152c:	f002 fc00 	bl	c0d03d30 <os_longjmp>
c0d01530:	20001930 	.word	0x20001930

c0d01534 <monero_io_insert>:
             G_monero_vstate.io_buffer+G_monero_vstate.io_offset,
             G_monero_vstate.io_length-G_monero_vstate.io_offset);
  G_monero_vstate.io_length += sz;
}

void monero_io_insert(unsigned char const *buff, unsigned int len) {
c0d01534:	b570      	push	{r4, r5, r6, lr}
c0d01536:	460c      	mov	r4, r1
c0d01538:	4605      	mov	r5, r0
  monero_io_hole(len);
c0d0153a:	4608      	mov	r0, r1
c0d0153c:	f7ff ffe0 	bl	c0d01500 <monero_io_hole>
  os_memmove(G_monero_vstate.io_buffer+G_monero_vstate.io_offset, buff, len);
c0d01540:	4e05      	ldr	r6, [pc, #20]	; (c0d01558 <monero_io_insert+0x24>)
c0d01542:	8970      	ldrh	r0, [r6, #10]
c0d01544:	1830      	adds	r0, r6, r0
c0d01546:	300e      	adds	r0, #14
c0d01548:	4629      	mov	r1, r5
c0d0154a:	4622      	mov	r2, r4
c0d0154c:	f002 fb21 	bl	c0d03b92 <os_memmove>
  G_monero_vstate.io_offset += len;
c0d01550:	8970      	ldrh	r0, [r6, #10]
c0d01552:	1900      	adds	r0, r0, r4
c0d01554:	8170      	strh	r0, [r6, #10]
}
c0d01556:	bd70      	pop	{r4, r5, r6, pc}
c0d01558:	20001930 	.word	0x20001930

c0d0155c <monero_io_insert_encrypt>:

void monero_io_insert_encrypt(unsigned char* buffer, int len) {
c0d0155c:	b5b0      	push	{r4, r5, r7, lr}
c0d0155e:	b082      	sub	sp, #8
c0d01560:	460d      	mov	r5, r1
c0d01562:	4604      	mov	r4, r0
  monero_io_hole(len);
c0d01564:	4608      	mov	r0, r1
c0d01566:	f7ff ffcb 	bl	c0d01500 <monero_io_hole>

  //for now, only 32bytes block are allowed
  if (len != 32) {
c0d0156a:	2d20      	cmp	r5, #32
c0d0156c:	d112      	bne.n	c0d01594 <monero_io_insert_encrypt+0x38>
#elif defined(IONOCRYPT)
  os_memmove(G_monero_vstate.io_buffer+G_monero_vstate.io_offset, buffer, len);
#else
  cx_aes(&G_monero_vstate.spk, CX_ENCRYPT|CX_CHAIN_CBC|CX_LAST|CX_PAD_NONE,
         buffer, len,
         G_monero_vstate.io_buffer+G_monero_vstate.io_offset, len);
c0d0156e:	4d0c      	ldr	r5, [pc, #48]	; (c0d015a0 <monero_io_insert_encrypt+0x44>)
c0d01570:	8968      	ldrh	r0, [r5, #10]
c0d01572:	2320      	movs	r3, #32
       G_monero_vstate.io_buffer[G_monero_vstate.io_offset+i] = buffer[i] ^ 0x55;
    }
#elif defined(IONOCRYPT)
  os_memmove(G_monero_vstate.io_buffer+G_monero_vstate.io_offset, buffer, len);
#else
  cx_aes(&G_monero_vstate.spk, CX_ENCRYPT|CX_CHAIN_CBC|CX_LAST|CX_PAD_NONE,
c0d01574:	4669      	mov	r1, sp
         buffer, len,
         G_monero_vstate.io_buffer+G_monero_vstate.io_offset, len);
c0d01576:	1828      	adds	r0, r5, r0
c0d01578:	300e      	adds	r0, #14
       G_monero_vstate.io_buffer[G_monero_vstate.io_offset+i] = buffer[i] ^ 0x55;
    }
#elif defined(IONOCRYPT)
  os_memmove(G_monero_vstate.io_buffer+G_monero_vstate.io_offset, buffer, len);
#else
  cx_aes(&G_monero_vstate.spk, CX_ENCRYPT|CX_CHAIN_CBC|CX_LAST|CX_PAD_NONE,
c0d0157a:	c109      	stmia	r1!, {r0, r3}
c0d0157c:	2071      	movs	r0, #113	; 0x71
c0d0157e:	0080      	lsls	r0, r0, #2
c0d01580:	1828      	adds	r0, r5, r0
c0d01582:	2145      	movs	r1, #69	; 0x45
c0d01584:	4622      	mov	r2, r4
c0d01586:	f003 fac3 	bl	c0d04b10 <cx_aes>
         buffer, len,
         G_monero_vstate.io_buffer+G_monero_vstate.io_offset, len);
#endif
  G_monero_vstate.io_offset += len;
c0d0158a:	8968      	ldrh	r0, [r5, #10]
c0d0158c:	3020      	adds	r0, #32
c0d0158e:	8168      	strh	r0, [r5, #10]
}
c0d01590:	b002      	add	sp, #8
c0d01592:	bdb0      	pop	{r4, r5, r7, pc}
c0d01594:	4801      	ldr	r0, [pc, #4]	; (c0d0159c <monero_io_insert_encrypt+0x40>)
void monero_io_insert_encrypt(unsigned char* buffer, int len) {
  monero_io_hole(len);

  //for now, only 32bytes block are allowed
  if (len != 32) {
    THROW(SW_SECURE_MESSAGING_NOT_SUPPORTED);
c0d01596:	f002 fbcb 	bl	c0d03d30 <os_longjmp>
c0d0159a:	46c0      	nop			; (mov r8, r8)
c0d0159c:	00006882 	.word	0x00006882
c0d015a0:	20001930 	.word	0x20001930

c0d015a4 <monero_io_insert_u32>:
         G_monero_vstate.io_buffer+G_monero_vstate.io_offset, len);
#endif
  G_monero_vstate.io_offset += len;
}

void monero_io_insert_u32(unsigned  int v32) {
c0d015a4:	b510      	push	{r4, lr}
c0d015a6:	4604      	mov	r4, r0
c0d015a8:	2004      	movs	r0, #4
  monero_io_hole(4);
c0d015aa:	f7ff ffa9 	bl	c0d01500 <monero_io_hole>
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] = v32>>24;
c0d015ae:	4806      	ldr	r0, [pc, #24]	; (c0d015c8 <monero_io_insert_u32+0x24>)
c0d015b0:	8941      	ldrh	r1, [r0, #10]
c0d015b2:	1842      	adds	r2, r0, r1
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] = v32>>16;
c0d015b4:	0c23      	lsrs	r3, r4, #16
c0d015b6:	73d3      	strb	r3, [r2, #15]
  G_monero_vstate.io_offset += len;
}

void monero_io_insert_u32(unsigned  int v32) {
  monero_io_hole(4);
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] = v32>>24;
c0d015b8:	0e23      	lsrs	r3, r4, #24
c0d015ba:	7393      	strb	r3, [r2, #14]
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] = v32>>16;
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+2] = v32>>8;
c0d015bc:	0a23      	lsrs	r3, r4, #8
c0d015be:	7413      	strb	r3, [r2, #16]
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+3] = v32>>0;
c0d015c0:	7454      	strb	r4, [r2, #17]
  G_monero_vstate.io_offset += 4;
c0d015c2:	1d09      	adds	r1, r1, #4
c0d015c4:	8141      	strh	r1, [r0, #10]
}
c0d015c6:	bd10      	pop	{r4, pc}
c0d015c8:	20001930 	.word	0x20001930

c0d015cc <monero_io_insert_u16>:
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] = v24>>8;
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+2] = v24>>0;
  G_monero_vstate.io_offset += 3;
}

void monero_io_insert_u16(unsigned  int v16) {
c0d015cc:	b510      	push	{r4, lr}
c0d015ce:	4604      	mov	r4, r0
c0d015d0:	2002      	movs	r0, #2
  monero_io_hole(2);
c0d015d2:	f7ff ff95 	bl	c0d01500 <monero_io_hole>
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] = v16>>8;
c0d015d6:	4804      	ldr	r0, [pc, #16]	; (c0d015e8 <monero_io_insert_u16+0x1c>)
c0d015d8:	8941      	ldrh	r1, [r0, #10]
c0d015da:	1842      	adds	r2, r0, r1
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] = v16>>0;
c0d015dc:	73d4      	strb	r4, [r2, #15]
  G_monero_vstate.io_offset += 3;
}

void monero_io_insert_u16(unsigned  int v16) {
  monero_io_hole(2);
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] = v16>>8;
c0d015de:	0a23      	lsrs	r3, r4, #8
c0d015e0:	7393      	strb	r3, [r2, #14]
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] = v16>>0;
  G_monero_vstate.io_offset += 2;
c0d015e2:	1c89      	adds	r1, r1, #2
c0d015e4:	8141      	strh	r1, [r0, #10]
}
c0d015e6:	bd10      	pop	{r4, pc}
c0d015e8:	20001930 	.word	0x20001930

c0d015ec <monero_io_insert_u8>:

void monero_io_insert_u8(unsigned int v8) {
c0d015ec:	b510      	push	{r4, lr}
c0d015ee:	4604      	mov	r4, r0
c0d015f0:	2001      	movs	r0, #1
  monero_io_hole(1);
c0d015f2:	f7ff ff85 	bl	c0d01500 <monero_io_hole>
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] = v8;
c0d015f6:	4803      	ldr	r0, [pc, #12]	; (c0d01604 <monero_io_insert_u8+0x18>)
c0d015f8:	8941      	ldrh	r1, [r0, #10]
c0d015fa:	1842      	adds	r2, r0, r1
c0d015fc:	7394      	strb	r4, [r2, #14]
  G_monero_vstate.io_offset += 1;
c0d015fe:	1c49      	adds	r1, r1, #1
c0d01600:	8141      	strh	r1, [r0, #10]
}
c0d01602:	bd10      	pop	{r4, pc}
c0d01604:	20001930 	.word	0x20001930

c0d01608 <monero_io_fetch>:
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
    THROW(SW_WRONG_LENGTH + (sz&0xFF));
  }
}

int monero_io_fetch(unsigned char* buffer, int len) {
c0d01608:	b5b0      	push	{r4, r5, r7, lr}
c0d0160a:	460c      	mov	r4, r1

/* ----------------------------------------------------------------------- */
/* FECTH data from received buffer                                         */
/* ----------------------------------------------------------------------- */
void monero_io_assert_availabe(int sz) {
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
c0d0160c:	4d0b      	ldr	r5, [pc, #44]	; (c0d0163c <monero_io_fetch+0x34>)
c0d0160e:	8969      	ldrh	r1, [r5, #10]
c0d01610:	892a      	ldrh	r2, [r5, #8]
c0d01612:	1a52      	subs	r2, r2, r1
c0d01614:	42a2      	cmp	r2, r4
c0d01616:	db0b      	blt.n	c0d01630 <monero_io_fetch+0x28>
  }
}

int monero_io_fetch(unsigned char* buffer, int len) {
  monero_io_assert_availabe(len);
  if (buffer) {
c0d01618:	2800      	cmp	r0, #0
c0d0161a:	d005      	beq.n	c0d01628 <monero_io_fetch+0x20>
    os_memmove(buffer, G_monero_vstate.io_buffer+G_monero_vstate.io_offset, len);
c0d0161c:	1869      	adds	r1, r5, r1
c0d0161e:	310e      	adds	r1, #14
c0d01620:	4622      	mov	r2, r4
c0d01622:	f002 fab6 	bl	c0d03b92 <os_memmove>
  }
  G_monero_vstate.io_offset += len;
c0d01626:	8969      	ldrh	r1, [r5, #10]
c0d01628:	1908      	adds	r0, r1, r4
c0d0162a:	8168      	strh	r0, [r5, #10]
  return len;
c0d0162c:	4620      	mov	r0, r4
c0d0162e:	bdb0      	pop	{r4, r5, r7, pc}
c0d01630:	2067      	movs	r0, #103	; 0x67
c0d01632:	0200      	lsls	r0, r0, #8
/* ----------------------------------------------------------------------- */
/* FECTH data from received buffer                                         */
/* ----------------------------------------------------------------------- */
void monero_io_assert_availabe(int sz) {
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
    THROW(SW_WRONG_LENGTH + (sz&0xFF));
c0d01634:	b2e1      	uxtb	r1, r4
c0d01636:	1808      	adds	r0, r1, r0
c0d01638:	f002 fb7a 	bl	c0d03d30 <os_longjmp>
c0d0163c:	20001930 	.word	0x20001930

c0d01640 <monero_io_fetch_decrypt>:
  }
  G_monero_vstate.io_offset += len;
  return len;
}

int monero_io_fetch_decrypt(unsigned char* buffer, int len) {
c0d01640:	b510      	push	{r4, lr}
c0d01642:	b082      	sub	sp, #8

/* ----------------------------------------------------------------------- */
/* FECTH data from received buffer                                         */
/* ----------------------------------------------------------------------- */
void monero_io_assert_availabe(int sz) {
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
c0d01644:	4c11      	ldr	r4, [pc, #68]	; (c0d0168c <monero_io_fetch_decrypt+0x4c>)
c0d01646:	8962      	ldrh	r2, [r4, #10]
c0d01648:	8923      	ldrh	r3, [r4, #8]
c0d0164a:	1a9b      	subs	r3, r3, r2
c0d0164c:	428b      	cmp	r3, r1
c0d0164e:	db14      	blt.n	c0d0167a <monero_io_fetch_decrypt+0x3a>

int monero_io_fetch_decrypt(unsigned char* buffer, int len) {
  monero_io_assert_availabe(len);

  //for now, only 32bytes block allowed
  if (len != 32) {
c0d01650:	2920      	cmp	r1, #32
c0d01652:	d118      	bne.n	c0d01686 <monero_io_fetch_decrypt+0x46>
    THROW(SW_SECURE_MESSAGING_NOT_SUPPORTED);
    return 0;
  }

  if (buffer) {
c0d01654:	2800      	cmp	r0, #0
c0d01656:	d00b      	beq.n	c0d01670 <monero_io_fetch_decrypt+0x30>
c0d01658:	2320      	movs	r3, #32
      buffer[i] = G_monero_vstate.io_buffer[G_monero_vstate.io_offset+i] ^ 0x55;
    }
#elif defined(IONOCRYPT)
     os_memmove(buffer, G_monero_vstate.io_buffer+G_monero_vstate.io_offset, len);
#else //IOCRYPT
    cx_aes(&G_monero_vstate.spk, CX_DECRYPT|CX_CHAIN_CBC|CX_LAST|CX_PAD_NONE,
c0d0165a:	4669      	mov	r1, sp
c0d0165c:	c109      	stmia	r1!, {r0, r3}
c0d0165e:	2071      	movs	r0, #113	; 0x71
c0d01660:	0080      	lsls	r0, r0, #2
c0d01662:	1820      	adds	r0, r4, r0
           G_monero_vstate.io_buffer+G_monero_vstate.io_offset, len,
c0d01664:	18a2      	adds	r2, r4, r2
c0d01666:	320e      	adds	r2, #14
c0d01668:	2141      	movs	r1, #65	; 0x41
      buffer[i] = G_monero_vstate.io_buffer[G_monero_vstate.io_offset+i] ^ 0x55;
    }
#elif defined(IONOCRYPT)
     os_memmove(buffer, G_monero_vstate.io_buffer+G_monero_vstate.io_offset, len);
#else //IOCRYPT
    cx_aes(&G_monero_vstate.spk, CX_DECRYPT|CX_CHAIN_CBC|CX_LAST|CX_PAD_NONE,
c0d0166a:	f003 fa51 	bl	c0d04b10 <cx_aes>
           G_monero_vstate.io_buffer+G_monero_vstate.io_offset, len,
           buffer, len);
#endif
  }
  G_monero_vstate.io_offset += len;
c0d0166e:	8962      	ldrh	r2, [r4, #10]
c0d01670:	3220      	adds	r2, #32
c0d01672:	8162      	strh	r2, [r4, #10]
c0d01674:	2020      	movs	r0, #32
  return len;
c0d01676:	b002      	add	sp, #8
c0d01678:	bd10      	pop	{r4, pc}
c0d0167a:	2067      	movs	r0, #103	; 0x67
c0d0167c:	0200      	lsls	r0, r0, #8
/* ----------------------------------------------------------------------- */
/* FECTH data from received buffer                                         */
/* ----------------------------------------------------------------------- */
void monero_io_assert_availabe(int sz) {
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
    THROW(SW_WRONG_LENGTH + (sz&0xFF));
c0d0167e:	b2c9      	uxtb	r1, r1
c0d01680:	1808      	adds	r0, r1, r0
c0d01682:	f002 fb55 	bl	c0d03d30 <os_longjmp>
c0d01686:	4802      	ldr	r0, [pc, #8]	; (c0d01690 <monero_io_fetch_decrypt+0x50>)
int monero_io_fetch_decrypt(unsigned char* buffer, int len) {
  monero_io_assert_availabe(len);

  //for now, only 32bytes block allowed
  if (len != 32) {
    THROW(SW_SECURE_MESSAGING_NOT_SUPPORTED);
c0d01688:	f002 fb52 	bl	c0d03d30 <os_longjmp>
c0d0168c:	20001930 	.word	0x20001930
c0d01690:	00006882 	.word	0x00006882

c0d01694 <monero_io_fetch_decrypt_key>:
  }
  G_monero_vstate.io_offset += len;
  return len;
}

int monero_io_fetch_decrypt_key(unsigned char* buffer) {
c0d01694:	b510      	push	{r4, lr}

/* ----------------------------------------------------------------------- */
/* FECTH data from received buffer                                         */
/* ----------------------------------------------------------------------- */
void monero_io_assert_availabe(int sz) {
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
c0d01696:	4c16      	ldr	r4, [pc, #88]	; (c0d016f0 <monero_io_fetch_decrypt_key+0x5c>)
c0d01698:	8961      	ldrh	r1, [r4, #10]
c0d0169a:	8922      	ldrh	r2, [r4, #8]
c0d0169c:	1a52      	subs	r2, r2, r1
c0d0169e:	2a1f      	cmp	r2, #31
c0d016a0:	dd22      	ble.n	c0d016e8 <monero_io_fetch_decrypt_key+0x54>
  unsigned char* k;
  monero_io_assert_availabe(32);

  k = G_monero_vstate.io_buffer+G_monero_vstate.io_offset;
  //view?
  for (i =0; i <32; i++) {
c0d016a2:	1861      	adds	r1, r4, r1
c0d016a4:	310e      	adds	r1, #14
c0d016a6:	2200      	movs	r2, #0
    if (k[i] != 0x00) break;
c0d016a8:	5c8b      	ldrb	r3, [r1, r2]
c0d016aa:	2b00      	cmp	r3, #0
c0d016ac:	d105      	bne.n	c0d016ba <monero_io_fetch_decrypt_key+0x26>
  unsigned char* k;
  monero_io_assert_availabe(32);

  k = G_monero_vstate.io_buffer+G_monero_vstate.io_offset;
  //view?
  for (i =0; i <32; i++) {
c0d016ae:	1c52      	adds	r2, r2, #1
c0d016b0:	2a20      	cmp	r2, #32
c0d016b2:	d3f9      	bcc.n	c0d016a8 <monero_io_fetch_decrypt_key+0x14>
    if (k[i] != 0x00) break;
  }
  if(i==32) {
c0d016b4:	d101      	bne.n	c0d016ba <monero_io_fetch_decrypt_key+0x26>
c0d016b6:	2151      	movs	r1, #81	; 0x51
c0d016b8:	e008      	b.n	c0d016cc <monero_io_fetch_decrypt_key+0x38>
c0d016ba:	2200      	movs	r2, #0
    G_monero_vstate.io_offset += 32;
    return 32;
  }
  //spend?
  for (i =0; i <32; i++) {
    if (k [i] != 0xff) break;
c0d016bc:	5c8b      	ldrb	r3, [r1, r2]
c0d016be:	2bff      	cmp	r3, #255	; 0xff
c0d016c0:	d10d      	bne.n	c0d016de <monero_io_fetch_decrypt_key+0x4a>
    os_memmove(buffer, G_monero_vstate.a,32);
    G_monero_vstate.io_offset += 32;
    return 32;
  }
  //spend?
  for (i =0; i <32; i++) {
c0d016c2:	1c52      	adds	r2, r2, #1
c0d016c4:	2a20      	cmp	r2, #32
c0d016c6:	d3f9      	bcc.n	c0d016bc <monero_io_fetch_decrypt_key+0x28>
c0d016c8:	d109      	bne.n	c0d016de <monero_io_fetch_decrypt_key+0x4a>
c0d016ca:	2161      	movs	r1, #97	; 0x61
c0d016cc:	0089      	lsls	r1, r1, #2
c0d016ce:	1861      	adds	r1, r4, r1
c0d016d0:	2220      	movs	r2, #32
c0d016d2:	f002 fa5e 	bl	c0d03b92 <os_memmove>
c0d016d6:	8960      	ldrh	r0, [r4, #10]
c0d016d8:	3020      	adds	r0, #32
c0d016da:	8160      	strh	r0, [r4, #10]
c0d016dc:	e002      	b.n	c0d016e4 <monero_io_fetch_decrypt_key+0x50>
c0d016de:	2120      	movs	r1, #32
  if(i==32) {
    os_memmove(buffer, G_monero_vstate.b,32);
    G_monero_vstate.io_offset += 32;
    return 32;
  }
  return monero_io_fetch_decrypt(buffer, 32);
c0d016e0:	f7ff ffae 	bl	c0d01640 <monero_io_fetch_decrypt>
c0d016e4:	2020      	movs	r0, #32
}
c0d016e6:	bd10      	pop	{r4, pc}
c0d016e8:	4802      	ldr	r0, [pc, #8]	; (c0d016f4 <monero_io_fetch_decrypt_key+0x60>)
/* ----------------------------------------------------------------------- */
/* FECTH data from received buffer                                         */
/* ----------------------------------------------------------------------- */
void monero_io_assert_availabe(int sz) {
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
    THROW(SW_WRONG_LENGTH + (sz&0xFF));
c0d016ea:	f002 fb21 	bl	c0d03d30 <os_longjmp>
c0d016ee:	46c0      	nop			; (mov r8, r8)
c0d016f0:	20001930 	.word	0x20001930
c0d016f4:	00006720 	.word	0x00006720

c0d016f8 <monero_io_fetch_u32>:
    return 32;
  }
  return monero_io_fetch_decrypt(buffer, 32);
}

unsigned int monero_io_fetch_u32() {
c0d016f8:	b5b0      	push	{r4, r5, r7, lr}

/* ----------------------------------------------------------------------- */
/* FECTH data from received buffer                                         */
/* ----------------------------------------------------------------------- */
void monero_io_assert_availabe(int sz) {
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
c0d016fa:	480b      	ldr	r0, [pc, #44]	; (c0d01728 <monero_io_fetch_u32+0x30>)
c0d016fc:	8941      	ldrh	r1, [r0, #10]
c0d016fe:	8902      	ldrh	r2, [r0, #8]
c0d01700:	1a52      	subs	r2, r2, r1
c0d01702:	2a03      	cmp	r2, #3
c0d01704:	dd0d      	ble.n	c0d01722 <monero_io_fetch_u32+0x2a>
}

unsigned int monero_io_fetch_u32() {
  unsigned int  v32;
  monero_io_assert_availabe(4);
  v32 =  ( (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] << 24) |
c0d01706:	1842      	adds	r2, r0, r1
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] << 16) |
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+2] << 8) |
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+3] << 0) );
c0d01708:	7c53      	ldrb	r3, [r2, #17]
unsigned int monero_io_fetch_u32() {
  unsigned int  v32;
  monero_io_assert_availabe(4);
  v32 =  ( (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] << 24) |
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] << 16) |
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+2] << 8) |
c0d0170a:	7c14      	ldrb	r4, [r2, #16]

unsigned int monero_io_fetch_u32() {
  unsigned int  v32;
  monero_io_assert_availabe(4);
  v32 =  ( (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] << 24) |
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] << 16) |
c0d0170c:	7bd5      	ldrb	r5, [r2, #15]
}

unsigned int monero_io_fetch_u32() {
  unsigned int  v32;
  monero_io_assert_availabe(4);
  v32 =  ( (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] << 24) |
c0d0170e:	7b92      	ldrb	r2, [r2, #14]
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] << 16) |
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+2] << 8) |
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+3] << 0) );
  G_monero_vstate.io_offset += 4;
c0d01710:	1d09      	adds	r1, r1, #4
c0d01712:	8141      	strh	r1, [r0, #10]
}

unsigned int monero_io_fetch_u32() {
  unsigned int  v32;
  monero_io_assert_availabe(4);
  v32 =  ( (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] << 24) |
c0d01714:	0610      	lsls	r0, r2, #24
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] << 16) |
c0d01716:	0429      	lsls	r1, r5, #16
}

unsigned int monero_io_fetch_u32() {
  unsigned int  v32;
  monero_io_assert_availabe(4);
  v32 =  ( (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] << 24) |
c0d01718:	1808      	adds	r0, r1, r0
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] << 16) |
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+2] << 8) |
c0d0171a:	0221      	lsls	r1, r4, #8

unsigned int monero_io_fetch_u32() {
  unsigned int  v32;
  monero_io_assert_availabe(4);
  v32 =  ( (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] << 24) |
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] << 16) |
c0d0171c:	1840      	adds	r0, r0, r1
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+2] << 8) |
c0d0171e:	18c0      	adds	r0, r0, r3
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+3] << 0) );
  G_monero_vstate.io_offset += 4;
  return v32;
c0d01720:	bdb0      	pop	{r4, r5, r7, pc}
c0d01722:	4802      	ldr	r0, [pc, #8]	; (c0d0172c <monero_io_fetch_u32+0x34>)
/* ----------------------------------------------------------------------- */
/* FECTH data from received buffer                                         */
/* ----------------------------------------------------------------------- */
void monero_io_assert_availabe(int sz) {
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
    THROW(SW_WRONG_LENGTH + (sz&0xFF));
c0d01724:	f002 fb04 	bl	c0d03d30 <os_longjmp>
c0d01728:	20001930 	.word	0x20001930
c0d0172c:	00006704 	.word	0x00006704

c0d01730 <monero_io_fetch_u8>:
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] << 0) );
  G_monero_vstate.io_offset += 2;
  return v16;
}

unsigned int monero_io_fetch_u8() {
c0d01730:	b580      	push	{r7, lr}

/* ----------------------------------------------------------------------- */
/* FECTH data from received buffer                                         */
/* ----------------------------------------------------------------------- */
void monero_io_assert_availabe(int sz) {
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
c0d01732:	4906      	ldr	r1, [pc, #24]	; (c0d0174c <monero_io_fetch_u8+0x1c>)
c0d01734:	894a      	ldrh	r2, [r1, #10]
c0d01736:	8908      	ldrh	r0, [r1, #8]
c0d01738:	4290      	cmp	r0, r2
c0d0173a:	d904      	bls.n	c0d01746 <monero_io_fetch_u8+0x16>
}

unsigned int monero_io_fetch_u8() {
  unsigned int  v8;
  monero_io_assert_availabe(1);
  v8 = G_monero_vstate.io_buffer[G_monero_vstate.io_offset] ;
c0d0173c:	1888      	adds	r0, r1, r2
c0d0173e:	7b80      	ldrb	r0, [r0, #14]
  G_monero_vstate.io_offset += 1;
c0d01740:	1c52      	adds	r2, r2, #1
c0d01742:	814a      	strh	r2, [r1, #10]
  return v8;
c0d01744:	bd80      	pop	{r7, pc}
c0d01746:	4802      	ldr	r0, [pc, #8]	; (c0d01750 <monero_io_fetch_u8+0x20>)
/* ----------------------------------------------------------------------- */
/* FECTH data from received buffer                                         */
/* ----------------------------------------------------------------------- */
void monero_io_assert_availabe(int sz) {
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
    THROW(SW_WRONG_LENGTH + (sz&0xFF));
c0d01748:	f002 faf2 	bl	c0d03d30 <os_longjmp>
c0d0174c:	20001930 	.word	0x20001930
c0d01750:	00006701 	.word	0x00006701

c0d01754 <monero_io_do>:
/* REAL IO                                                                 */
/* ----------------------------------------------------------------------- */

#define MAX_OUT MONERO_APDU_LENGTH

int monero_io_do(unsigned int io_flags) {
c0d01754:	b5b0      	push	{r4, r5, r7, lr}
c0d01756:	4604      	mov	r4, r0


  // if IO_ASYNCH_REPLY has been  set,
  //  monero_io_exchange will return when  IO_RETURN_AFTER_TX will set in ui
  if (io_flags & IO_ASYNCH_REPLY) {
c0d01758:	06c0      	lsls	r0, r0, #27
c0d0175a:	d40f      	bmi.n	c0d0177c <monero_io_do+0x28>
    monero_io_exchange(CHANNEL_APDU | IO_ASYNCH_REPLY, 0);
  }
  //else send data now
  else {
    G_monero_vstate.io_offset = 0;
c0d0175c:	4d19      	ldr	r5, [pc, #100]	; (c0d017c4 <monero_io_do+0x70>)
c0d0175e:	2000      	movs	r0, #0
c0d01760:	8168      	strh	r0, [r5, #10]
    if(G_monero_vstate.io_length > MAX_OUT) {
c0d01762:	892a      	ldrh	r2, [r5, #8]
c0d01764:	2aff      	cmp	r2, #255	; 0xff
c0d01766:	d229      	bcs.n	c0d017bc <monero_io_do+0x68>
      THROW(SW_FILE_FULL);
      return SW_FILE_FULL;
    }
    os_memmove(G_io_apdu_buffer,  G_monero_vstate.io_buffer+G_monero_vstate.io_offset, G_monero_vstate.io_length);
c0d01768:	4629      	mov	r1, r5
c0d0176a:	310e      	adds	r1, #14
c0d0176c:	4816      	ldr	r0, [pc, #88]	; (c0d017c8 <monero_io_do+0x74>)
c0d0176e:	f002 fa10 	bl	c0d03b92 <os_memmove>
c0d01772:	8929      	ldrh	r1, [r5, #8]

    if (io_flags & IO_RETURN_AFTER_TX) {
c0d01774:	06a0      	lsls	r0, r4, #26
c0d01776:	d41c      	bmi.n	c0d017b2 <monero_io_do+0x5e>
c0d01778:	2000      	movs	r0, #0
c0d0177a:	e001      	b.n	c0d01780 <monero_io_do+0x2c>
c0d0177c:	2010      	movs	r0, #16
c0d0177e:	2100      	movs	r1, #0
c0d01780:	f002 fe14 	bl	c0d043ac <io_exchange>
      monero_io_exchange(CHANNEL_APDU,  G_monero_vstate.io_length);
    }
  }

  //--- set up received data  ---
  G_monero_vstate.io_offset = 0;
c0d01784:	4c0f      	ldr	r4, [pc, #60]	; (c0d017c4 <monero_io_do+0x70>)
c0d01786:	2000      	movs	r0, #0
  G_monero_vstate.io_length = 0;
c0d01788:	60a0      	str	r0, [r4, #8]
  G_monero_vstate.io_protocol_version = G_io_apdu_buffer[0];
  G_monero_vstate.io_ins = G_io_apdu_buffer[1];
  G_monero_vstate.io_p1  = G_io_apdu_buffer[2];
  G_monero_vstate.io_p2  = G_io_apdu_buffer[3];
  G_monero_vstate.io_lc  = 0;
  G_monero_vstate.io_le  = 0;
c0d0178a:	71e0      	strb	r0, [r4, #7]
  }

  //--- set up received data  ---
  G_monero_vstate.io_offset = 0;
  G_monero_vstate.io_length = 0;
  G_monero_vstate.io_protocol_version = G_io_apdu_buffer[0];
c0d0178c:	490e      	ldr	r1, [pc, #56]	; (c0d017c8 <monero_io_do+0x74>)
c0d0178e:	7808      	ldrb	r0, [r1, #0]
c0d01790:	70a0      	strb	r0, [r4, #2]
  G_monero_vstate.io_ins = G_io_apdu_buffer[1];
c0d01792:	7848      	ldrb	r0, [r1, #1]
c0d01794:	70e0      	strb	r0, [r4, #3]
  G_monero_vstate.io_p1  = G_io_apdu_buffer[2];
c0d01796:	7888      	ldrb	r0, [r1, #2]
c0d01798:	7120      	strb	r0, [r4, #4]
  G_monero_vstate.io_p2  = G_io_apdu_buffer[3];
c0d0179a:	78c8      	ldrb	r0, [r1, #3]
c0d0179c:	7160      	strb	r0, [r4, #5]
  G_monero_vstate.io_lc  = 0;
  G_monero_vstate.io_le  = 0;

  G_monero_vstate.io_lc  = G_io_apdu_buffer[4];
c0d0179e:	790a      	ldrb	r2, [r1, #4]
c0d017a0:	71a2      	strb	r2, [r4, #6]
  os_memmove(G_monero_vstate.io_buffer, G_io_apdu_buffer+5, G_monero_vstate.io_lc);
c0d017a2:	4620      	mov	r0, r4
c0d017a4:	300e      	adds	r0, #14
c0d017a6:	1d49      	adds	r1, r1, #5
c0d017a8:	f002 f9f3 	bl	c0d03b92 <os_memmove>
  G_monero_vstate.io_length =  G_monero_vstate.io_lc;
c0d017ac:	79a0      	ldrb	r0, [r4, #6]
c0d017ae:	8120      	strh	r0, [r4, #8]
c0d017b0:	e002      	b.n	c0d017b8 <monero_io_do+0x64>
c0d017b2:	2020      	movs	r0, #32
      return SW_FILE_FULL;
    }
    os_memmove(G_io_apdu_buffer,  G_monero_vstate.io_buffer+G_monero_vstate.io_offset, G_monero_vstate.io_length);

    if (io_flags & IO_RETURN_AFTER_TX) {
      monero_io_exchange(CHANNEL_APDU |IO_RETURN_AFTER_TX, G_monero_vstate.io_length);
c0d017b4:	f002 fdfa 	bl	c0d043ac <io_exchange>
c0d017b8:	2000      	movs	r0, #0
  G_monero_vstate.io_lc  = G_io_apdu_buffer[4];
  os_memmove(G_monero_vstate.io_buffer, G_io_apdu_buffer+5, G_monero_vstate.io_lc);
  G_monero_vstate.io_length =  G_monero_vstate.io_lc;

  return 0;
}
c0d017ba:	bdb0      	pop	{r4, r5, r7, pc}
c0d017bc:	4803      	ldr	r0, [pc, #12]	; (c0d017cc <monero_io_do+0x78>)
  }
  //else send data now
  else {
    G_monero_vstate.io_offset = 0;
    if(G_monero_vstate.io_length > MAX_OUT) {
      THROW(SW_FILE_FULL);
c0d017be:	f002 fab7 	bl	c0d03d30 <os_longjmp>
c0d017c2:	46c0      	nop			; (mov r8, r8)
c0d017c4:	20001930 	.word	0x20001930
c0d017c8:	2000216c 	.word	0x2000216c
c0d017cc:	00006a84 	.word	0x00006a84

c0d017d0 <monero_clear_words>:
    }
    return( crc32 ^ 0xFFFFFFFF );
}


void monero_clear_words() {
c0d017d0:	b570      	push	{r4, r5, r6, lr}
c0d017d2:	2519      	movs	r5, #25
c0d017d4:	264a      	movs	r6, #74	; 0x4a
c0d017d6:	4c06      	ldr	r4, [pc, #24]	; (c0d017f0 <monero_clear_words+0x20>)
  for (int i = 0; i<25; i++) {
    monero_nvm_write(N_monero_pstate->words[i], NULL,WORDS_MAX_LENGTH);
c0d017d8:	4620      	mov	r0, r4
c0d017da:	f003 f8c7 	bl	c0d0496c <pic>
c0d017de:	1980      	adds	r0, r0, r6
c0d017e0:	2100      	movs	r1, #0
c0d017e2:	2214      	movs	r2, #20
c0d017e4:	f003 f904 	bl	c0d049f0 <nvm_write>
    return( crc32 ^ 0xFFFFFFFF );
}


void monero_clear_words() {
  for (int i = 0; i<25; i++) {
c0d017e8:	3614      	adds	r6, #20
c0d017ea:	1e6d      	subs	r5, r5, #1
c0d017ec:	d1f4      	bne.n	c0d017d8 <monero_clear_words+0x8>
    monero_nvm_write(N_monero_pstate->words[i], NULL,WORDS_MAX_LENGTH);
  }
}
c0d017ee:	bd70      	pop	{r4, r5, r6, pc}
c0d017f0:	c0d07ec0 	.word	0xc0d07ec0

c0d017f4 <monero_apdu_manage_seedwords>:
}

#define word_list_length 1626
#define seed G_monero_vstate.b

int monero_apdu_manage_seedwords() {
c0d017f4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d017f6:	b087      	sub	sp, #28
  unsigned int w_start, w_end;
  unsigned short wc[4];
  switch (G_monero_vstate.io_p1) {
c0d017f8:	4c7e      	ldr	r4, [pc, #504]	; (c0d019f4 <monero_apdu_manage_seedwords+0x200>)
c0d017fa:	7920      	ldrb	r0, [r4, #4]
c0d017fc:	2802      	cmp	r0, #2
c0d017fe:	d100      	bne.n	c0d01802 <monero_apdu_manage_seedwords+0xe>
c0d01800:	e0de      	b.n	c0d019c0 <monero_apdu_manage_seedwords+0x1cc>
c0d01802:	2801      	cmp	r0, #1
c0d01804:	d000      	beq.n	c0d01808 <monero_apdu_manage_seedwords+0x14>
c0d01806:	e0e0      	b.n	c0d019ca <monero_apdu_manage_seedwords+0x1d6>
    //SETUP
  case 1:
    w_start = monero_io_fetch_u32();
c0d01808:	f7ff ff76 	bl	c0d016f8 <monero_io_fetch_u32>
c0d0180c:	4606      	mov	r6, r0
    w_end   = w_start+monero_io_fetch_u32();
c0d0180e:	f7ff ff73 	bl	c0d016f8 <monero_io_fetch_u32>
c0d01812:	1982      	adds	r2, r0, r6
c0d01814:	4978      	ldr	r1, [pc, #480]	; (c0d019f8 <monero_apdu_manage_seedwords+0x204>)
    if ((w_start >= word_list_length) || (w_end > word_list_length) || (w_start > w_end)) {
c0d01816:	1c4b      	adds	r3, r1, #1
c0d01818:	9300      	str	r3, [sp, #0]
c0d0181a:	9204      	str	r2, [sp, #16]
c0d0181c:	4282      	cmp	r2, r0
c0d0181e:	d200      	bcs.n	c0d01822 <monero_apdu_manage_seedwords+0x2e>
c0d01820:	e0e3      	b.n	c0d019ea <monero_apdu_manage_seedwords+0x1f6>
c0d01822:	428e      	cmp	r6, r1
c0d01824:	d900      	bls.n	c0d01828 <monero_apdu_manage_seedwords+0x34>
c0d01826:	e0e0      	b.n	c0d019ea <monero_apdu_manage_seedwords+0x1f6>
c0d01828:	9804      	ldr	r0, [sp, #16]
c0d0182a:	9900      	ldr	r1, [sp, #0]
c0d0182c:	4288      	cmp	r0, r1
c0d0182e:	d900      	bls.n	c0d01832 <monero_apdu_manage_seedwords+0x3e>
c0d01830:	e0db      	b.n	c0d019ea <monero_apdu_manage_seedwords+0x1f6>
c0d01832:	2100      	movs	r1, #0
      THROW(SW_WRONG_DATA);
      return SW_WRONG_DATA;
    }
    for (int i = 0; i<8; i++) {
c0d01834:	9603      	str	r6, [sp, #12]
c0d01836:	9101      	str	r1, [sp, #4]
c0d01838:	2061      	movs	r0, #97	; 0x61
c0d0183a:	0080      	lsls	r0, r0, #2
      unsigned int val = (seed[i*4+0]<<0) | (seed[i*4+1]<<8) | (seed[i*4+2]<<16) | (seed[i*4+3]<<24);
c0d0183c:	1820      	adds	r0, r4, r0
c0d0183e:	0089      	lsls	r1, r1, #2
c0d01840:	5c42      	ldrb	r2, [r0, r1]
c0d01842:	1c4b      	adds	r3, r1, #1
c0d01844:	5cc3      	ldrb	r3, [r0, r3]
c0d01846:	021b      	lsls	r3, r3, #8
c0d01848:	189a      	adds	r2, r3, r2
c0d0184a:	1c8b      	adds	r3, r1, #2
c0d0184c:	5cc3      	ldrb	r3, [r0, r3]
c0d0184e:	041b      	lsls	r3, r3, #16
c0d01850:	18d2      	adds	r2, r2, r3
c0d01852:	1cc9      	adds	r1, r1, #3
c0d01854:	5c40      	ldrb	r0, [r0, r1]
c0d01856:	0600      	lsls	r0, r0, #24
c0d01858:	1815      	adds	r5, r2, r0
      wc[0] = val % word_list_length;
      wc[1] = ((val / word_list_length) +  wc[0]) % word_list_length;
c0d0185a:	9502      	str	r5, [sp, #8]
c0d0185c:	4628      	mov	r0, r5
c0d0185e:	4967      	ldr	r1, [pc, #412]	; (c0d019fc <monero_apdu_manage_seedwords+0x208>)
c0d01860:	460e      	mov	r6, r1
c0d01862:	f004 fe3f 	bl	c0d064e4 <__aeabi_uidiv>
c0d01866:	9900      	ldr	r1, [sp, #0]
c0d01868:	4341      	muls	r1, r0
c0d0186a:	1a6f      	subs	r7, r5, r1
c0d0186c:	ad05      	add	r5, sp, #20
      THROW(SW_WRONG_DATA);
      return SW_WRONG_DATA;
    }
    for (int i = 0; i<8; i++) {
      unsigned int val = (seed[i*4+0]<<0) | (seed[i*4+1]<<8) | (seed[i*4+2]<<16) | (seed[i*4+3]<<24);
      wc[0] = val % word_list_length;
c0d0186e:	802f      	strh	r7, [r5, #0]
      wc[1] = ((val / word_list_length) +  wc[0]) % word_list_length;
c0d01870:	19c0      	adds	r0, r0, r7
c0d01872:	4631      	mov	r1, r6
c0d01874:	f004 febc 	bl	c0d065f0 <__aeabi_uidivmod>
c0d01878:	460e      	mov	r6, r1
c0d0187a:	8069      	strh	r1, [r5, #2]
      wc[2] = (((val / word_list_length) / word_list_length) +  wc[1]) % word_list_length;
c0d0187c:	9802      	ldr	r0, [sp, #8]
c0d0187e:	4960      	ldr	r1, [pc, #384]	; (c0d01a00 <monero_apdu_manage_seedwords+0x20c>)
c0d01880:	f004 fe30 	bl	c0d064e4 <__aeabi_uidiv>
c0d01884:	1830      	adds	r0, r6, r0
c0d01886:	9e03      	ldr	r6, [sp, #12]
c0d01888:	495c      	ldr	r1, [pc, #368]	; (c0d019fc <monero_apdu_manage_seedwords+0x208>)
c0d0188a:	f004 feb1 	bl	c0d065f0 <__aeabi_uidivmod>
c0d0188e:	80a9      	strh	r1, [r5, #4]
c0d01890:	2003      	movs	r0, #3
c0d01892:	9901      	ldr	r1, [sp, #4]
c0d01894:	4348      	muls	r0, r1
c0d01896:	9002      	str	r0, [sp, #8]
c0d01898:	2500      	movs	r5, #0
c0d0189a:	e002      	b.n	c0d018a2 <monero_apdu_manage_seedwords+0xae>
c0d0189c:	0068      	lsls	r0, r5, #1
c0d0189e:	a905      	add	r1, sp, #20

      for (int wi = 0; wi < 3; wi++) {
        if ((wc[wi] >= w_start) && (wc[wi] < w_end)) {
c0d018a0:	5a0f      	ldrh	r7, [r1, r0]
c0d018a2:	b2b9      	uxth	r1, r7
c0d018a4:	428e      	cmp	r6, r1
c0d018a6:	d82c      	bhi.n	c0d01902 <monero_apdu_manage_seedwords+0x10e>
c0d018a8:	9804      	ldr	r0, [sp, #16]
c0d018aa:	4288      	cmp	r0, r1
c0d018ac:	d929      	bls.n	c0d01902 <monero_apdu_manage_seedwords+0x10e>
          monero_set_word(i*3+wi, wc[wi], w_start, G_monero_vstate.io_buffer+G_monero_vstate.io_offset, MONERO_IO_BUFFER_LENGTH-G_monero_vstate.io_offset);
c0d018ae:	9802      	ldr	r0, [sp, #8]
c0d018b0:	1828      	adds	r0, r5, r0
c0d018b2:	8963      	ldrh	r3, [r4, #10]
c0d018b4:	224b      	movs	r2, #75	; 0x4b
c0d018b6:	0092      	lsls	r2, r2, #2
c0d018b8:	1ad2      	subs	r2, r2, r3
c0d018ba:	18e7      	adds	r7, r4, r3
c0d018bc:	370e      	adds	r7, #14
c0d018be:	4633      	mov	r3, r6
 * word_list
 * len : word_list length
 */

static void  monero_set_word(unsigned int n, unsigned int idx, unsigned int w_start, unsigned char* word_list, int len) {
  while (w_start < idx) {
c0d018c0:	428e      	cmp	r6, r1
c0d018c2:	d209      	bcs.n	c0d018d8 <monero_apdu_manage_seedwords+0xe4>
    len -= 1 + word_list[0];
c0d018c4:	783e      	ldrb	r6, [r7, #0]
c0d018c6:	1c76      	adds	r6, r6, #1
c0d018c8:	1b92      	subs	r2, r2, r6
    if (len < 0) {
c0d018ca:	2a00      	cmp	r2, #0
c0d018cc:	da00      	bge.n	c0d018d0 <monero_apdu_manage_seedwords+0xdc>
c0d018ce:	e080      	b.n	c0d019d2 <monero_apdu_manage_seedwords+0x1de>
      monero_clear_words();
      THROW(SW_WRONG_DATA+1);
      return;
    }
    word_list += 1 + word_list[0];
c0d018d0:	19bf      	adds	r7, r7, r6
    w_start++;
c0d018d2:	1c5b      	adds	r3, r3, #1
 * word_list
 * len : word_list length
 */

static void  monero_set_word(unsigned int n, unsigned int idx, unsigned int w_start, unsigned char* word_list, int len) {
  while (w_start < idx) {
c0d018d4:	428b      	cmp	r3, r1
c0d018d6:	d3f5      	bcc.n	c0d018c4 <monero_apdu_manage_seedwords+0xd0>
    }
    word_list += 1 + word_list[0];
    w_start++;
  }

  if ((w_start != idx) || (word_list[0] > (len-1)) || (word_list[0] > 19)) {
c0d018d8:	428b      	cmp	r3, r1
c0d018da:	d000      	beq.n	c0d018de <monero_apdu_manage_seedwords+0xea>
c0d018dc:	e080      	b.n	c0d019e0 <monero_apdu_manage_seedwords+0x1ec>
c0d018de:	783e      	ldrb	r6, [r7, #0]
c0d018e0:	2e13      	cmp	r6, #19
c0d018e2:	d87d      	bhi.n	c0d019e0 <monero_apdu_manage_seedwords+0x1ec>
c0d018e4:	42b2      	cmp	r2, r6
c0d018e6:	dd7b      	ble.n	c0d019e0 <monero_apdu_manage_seedwords+0x1ec>
c0d018e8:	2414      	movs	r4, #20
    THROW(SW_WRONG_DATA+2);
    return;
  }
  len = word_list[0];
  word_list++;
  monero_nvm_write(N_monero_pstate->words[n], word_list, len);
c0d018ea:	4344      	muls	r4, r0
c0d018ec:	4845      	ldr	r0, [pc, #276]	; (c0d01a04 <monero_apdu_manage_seedwords+0x210>)
c0d018ee:	f003 f83d 	bl	c0d0496c <pic>
c0d018f2:	1900      	adds	r0, r0, r4
c0d018f4:	304a      	adds	r0, #74	; 0x4a
  if ((w_start != idx) || (word_list[0] > (len-1)) || (word_list[0] > 19)) {
    THROW(SW_WRONG_DATA+2);
    return;
  }
  len = word_list[0];
  word_list++;
c0d018f6:	1c79      	adds	r1, r7, #1
  monero_nvm_write(N_monero_pstate->words[n], word_list, len);
c0d018f8:	4632      	mov	r2, r6
c0d018fa:	f003 f879 	bl	c0d049f0 <nvm_write>
c0d018fe:	4c3d      	ldr	r4, [pc, #244]	; (c0d019f4 <monero_apdu_manage_seedwords+0x200>)
c0d01900:	9e03      	ldr	r6, [sp, #12]
      unsigned int val = (seed[i*4+0]<<0) | (seed[i*4+1]<<8) | (seed[i*4+2]<<16) | (seed[i*4+3]<<24);
      wc[0] = val % word_list_length;
      wc[1] = ((val / word_list_length) +  wc[0]) % word_list_length;
      wc[2] = (((val / word_list_length) / word_list_length) +  wc[1]) % word_list_length;

      for (int wi = 0; wi < 3; wi++) {
c0d01902:	1c6d      	adds	r5, r5, #1
c0d01904:	2d02      	cmp	r5, #2
c0d01906:	d9c9      	bls.n	c0d0189c <monero_apdu_manage_seedwords+0xa8>
c0d01908:	9901      	ldr	r1, [sp, #4]
    w_end   = w_start+monero_io_fetch_u32();
    if ((w_start >= word_list_length) || (w_end > word_list_length) || (w_start > w_end)) {
      THROW(SW_WRONG_DATA);
      return SW_WRONG_DATA;
    }
    for (int i = 0; i<8; i++) {
c0d0190a:	1c49      	adds	r1, r1, #1
c0d0190c:	2908      	cmp	r1, #8
c0d0190e:	d392      	bcc.n	c0d01836 <monero_apdu_manage_seedwords+0x42>
c0d01910:	2001      	movs	r0, #1
          monero_set_word(i*3+wi, wc[wi], w_start, G_monero_vstate.io_buffer+G_monero_vstate.io_offset, MONERO_IO_BUFFER_LENGTH-G_monero_vstate.io_offset);
        }
      }
    }

    monero_io_discard(1);
c0d01912:	f7ff fde3 	bl	c0d014dc <monero_io_discard>
    if (G_monero_vstate.io_p2) {
c0d01916:	7963      	ldrb	r3, [r4, #5]
c0d01918:	2b00      	cmp	r3, #0
c0d0191a:	d056      	beq.n	c0d019ca <monero_apdu_manage_seedwords+0x1d6>
c0d0191c:	2700      	movs	r7, #0
c0d0191e:	224a      	movs	r2, #74	; 0x4a
c0d01920:	4e38      	ldr	r6, [pc, #224]	; (c0d01a04 <monero_apdu_manage_seedwords+0x210>)
      for (int i = 0; i<24; i++) {
        for (int j = 0; j<G_monero_vstate.io_p2; j++) {
c0d01922:	4619      	mov	r1, r3
c0d01924:	9703      	str	r7, [sp, #12]
c0d01926:	9704      	str	r7, [sp, #16]
c0d01928:	0609      	lsls	r1, r1, #24
c0d0192a:	9903      	ldr	r1, [sp, #12]
c0d0192c:	4f31      	ldr	r7, [pc, #196]	; (c0d019f4 <monero_apdu_manage_seedwords+0x200>)
c0d0192e:	4614      	mov	r4, r2
c0d01930:	d010      	beq.n	c0d01954 <monero_apdu_manage_seedwords+0x160>
c0d01932:	2500      	movs	r5, #0
          G_monero_vstate.io_buffer[i*G_monero_vstate.io_p2+j] = N_monero_pstate->words[i][j];
c0d01934:	4630      	mov	r0, r6
c0d01936:	f003 f819 	bl	c0d0496c <pic>
c0d0193a:	1900      	adds	r0, r0, r4
c0d0193c:	5d41      	ldrb	r1, [r0, r5]
c0d0193e:	797b      	ldrb	r3, [r7, #5]
c0d01940:	461a      	mov	r2, r3
c0d01942:	9804      	ldr	r0, [sp, #16]
c0d01944:	4342      	muls	r2, r0
c0d01946:	18ba      	adds	r2, r7, r2
c0d01948:	1952      	adds	r2, r2, r5
c0d0194a:	7391      	strb	r1, [r2, #14]
    }

    monero_io_discard(1);
    if (G_monero_vstate.io_p2) {
      for (int i = 0; i<24; i++) {
        for (int j = 0; j<G_monero_vstate.io_p2; j++) {
c0d0194c:	1c6d      	adds	r5, r5, #1
c0d0194e:	429d      	cmp	r5, r3
c0d01950:	4619      	mov	r1, r3
c0d01952:	d3ef      	bcc.n	c0d01934 <monero_apdu_manage_seedwords+0x140>
c0d01954:	4622      	mov	r2, r4
      }
    }

    monero_io_discard(1);
    if (G_monero_vstate.io_p2) {
      for (int i = 0; i<24; i++) {
c0d01956:	3214      	adds	r2, #20
c0d01958:	9c04      	ldr	r4, [sp, #16]
c0d0195a:	1c64      	adds	r4, r4, #1
c0d0195c:	2c18      	cmp	r4, #24
c0d0195e:	4627      	mov	r7, r4
c0d01960:	d1e1      	bne.n	c0d01926 <monero_apdu_manage_seedwords+0x132>
        for (int j = 0; j<G_monero_vstate.io_p2; j++) {
          G_monero_vstate.io_buffer[i*G_monero_vstate.io_p2+j] = N_monero_pstate->words[i][j];
        }
      }
      w_start = monero_crc32(0, G_monero_vstate.io_buffer, G_monero_vstate.io_p2*24)%24;
c0d01962:	b2d9      	uxtb	r1, r3
c0d01964:	2018      	movs	r0, #24
c0d01966:	4348      	muls	r0, r1
c0d01968:	2400      	movs	r4, #0
    size_t i;

    /** accumulate crc32 for buffer **/
    crc32 = inCrc32 ^ 0xFFFFFFFF;
    byteBuf = (unsigned char*) buf;
    for (i=0; i < bufLen; i++) {
c0d0196a:	2900      	cmp	r1, #0
c0d0196c:	d016      	beq.n	c0d0199c <monero_apdu_manage_seedwords+0x1a8>
c0d0196e:	2100      	movs	r1, #0
c0d01970:	43c9      	mvns	r1, r1
c0d01972:	4c20      	ldr	r4, [pc, #128]	; (c0d019f4 <monero_apdu_manage_seedwords+0x200>)
c0d01974:	340e      	adds	r4, #14
c0d01976:	4a25      	ldr	r2, [pc, #148]	; (c0d01a0c <monero_apdu_manage_seedwords+0x218>)
c0d01978:	447a      	add	r2, pc
        crc32 = (crc32 >> 8) ^ crcTable[ (crc32 ^ byteBuf[i]) & 0xFF ];
c0d0197a:	7823      	ldrb	r3, [r4, #0]
c0d0197c:	4625      	mov	r5, r4
c0d0197e:	b2cc      	uxtb	r4, r1
c0d01980:	405c      	eors	r4, r3
c0d01982:	00a3      	lsls	r3, r4, #2
c0d01984:	462c      	mov	r4, r5
c0d01986:	58d3      	ldr	r3, [r2, r3]
c0d01988:	0a09      	lsrs	r1, r1, #8
c0d0198a:	4059      	eors	r1, r3
    size_t i;

    /** accumulate crc32 for buffer **/
    crc32 = inCrc32 ^ 0xFFFFFFFF;
    byteBuf = (unsigned char*) buf;
    for (i=0; i < bufLen; i++) {
c0d0198c:	1c6c      	adds	r4, r5, #1
c0d0198e:	1e40      	subs	r0, r0, #1
c0d01990:	d1f3      	bne.n	c0d0197a <monero_apdu_manage_seedwords+0x186>
        crc32 = (crc32 >> 8) ^ crcTable[ (crc32 ^ byteBuf[i]) & 0xFF ];
    }
    return( crc32 ^ 0xFFFFFFFF );
c0d01992:	43c8      	mvns	r0, r1
c0d01994:	2118      	movs	r1, #24
c0d01996:	f004 fe2b 	bl	c0d065f0 <__aeabi_uidivmod>
c0d0199a:	460c      	mov	r4, r1
        for (int j = 0; j<G_monero_vstate.io_p2; j++) {
          G_monero_vstate.io_buffer[i*G_monero_vstate.io_p2+j] = N_monero_pstate->words[i][j];
        }
      }
      w_start = monero_crc32(0, G_monero_vstate.io_buffer, G_monero_vstate.io_p2*24)%24;
      monero_nvm_write(N_monero_pstate->words[24], N_monero_pstate->words[w_start], WORDS_MAX_LENGTH);
c0d0199c:	4d19      	ldr	r5, [pc, #100]	; (c0d01a04 <monero_apdu_manage_seedwords+0x210>)
c0d0199e:	4628      	mov	r0, r5
c0d019a0:	f002 ffe4 	bl	c0d0496c <pic>
c0d019a4:	4918      	ldr	r1, [pc, #96]	; (c0d01a08 <monero_apdu_manage_seedwords+0x214>)
c0d019a6:	1846      	adds	r6, r0, r1
c0d019a8:	2714      	movs	r7, #20
c0d019aa:	437c      	muls	r4, r7
c0d019ac:	4628      	mov	r0, r5
c0d019ae:	f002 ffdd 	bl	c0d0496c <pic>
c0d019b2:	1901      	adds	r1, r0, r4
c0d019b4:	314a      	adds	r1, #74	; 0x4a
c0d019b6:	4630      	mov	r0, r6
c0d019b8:	463a      	mov	r2, r7
c0d019ba:	f003 f819 	bl	c0d049f0 <nvm_write>
c0d019be:	e004      	b.n	c0d019ca <monero_apdu_manage_seedwords+0x1d6>
c0d019c0:	2000      	movs	r0, #0

    break;

    //CLEAR
  case 2:
    monero_io_discard(0);
c0d019c2:	f7ff fd8b 	bl	c0d014dc <monero_io_discard>
    monero_clear_words();
c0d019c6:	f7ff ff03 	bl	c0d017d0 <monero_clear_words>
c0d019ca:	2009      	movs	r0, #9
c0d019cc:	0300      	lsls	r0, r0, #12
    break;
  }

 return SW_OK;
c0d019ce:	b007      	add	sp, #28
c0d019d0:	bdf0      	pop	{r4, r5, r6, r7, pc}

static void  monero_set_word(unsigned int n, unsigned int idx, unsigned int w_start, unsigned char* word_list, int len) {
  while (w_start < idx) {
    len -= 1 + word_list[0];
    if (len < 0) {
      monero_clear_words();
c0d019d2:	f7ff fefd 	bl	c0d017d0 <monero_clear_words>
c0d019d6:	20d5      	movs	r0, #213	; 0xd5
c0d019d8:	01c0      	lsls	r0, r0, #7
      THROW(SW_WRONG_DATA+1);
c0d019da:	1c40      	adds	r0, r0, #1
c0d019dc:	f002 f9a8 	bl	c0d03d30 <os_longjmp>
c0d019e0:	20d5      	movs	r0, #213	; 0xd5
c0d019e2:	01c0      	lsls	r0, r0, #7
    word_list += 1 + word_list[0];
    w_start++;
  }

  if ((w_start != idx) || (word_list[0] > (len-1)) || (word_list[0] > 19)) {
    THROW(SW_WRONG_DATA+2);
c0d019e4:	1c80      	adds	r0, r0, #2
c0d019e6:	f002 f9a3 	bl	c0d03d30 <os_longjmp>
c0d019ea:	20d5      	movs	r0, #213	; 0xd5
c0d019ec:	01c0      	lsls	r0, r0, #7
    //SETUP
  case 1:
    w_start = monero_io_fetch_u32();
    w_end   = w_start+monero_io_fetch_u32();
    if ((w_start >= word_list_length) || (w_end > word_list_length) || (w_start > w_end)) {
      THROW(SW_WRONG_DATA);
c0d019ee:	f002 f99f 	bl	c0d03d30 <os_longjmp>
c0d019f2:	46c0      	nop			; (mov r8, r8)
c0d019f4:	20001930 	.word	0x20001930
c0d019f8:	00000659 	.word	0x00000659
c0d019fc:	0000065a 	.word	0x0000065a
c0d01a00:	002857a4 	.word	0x002857a4
c0d01a04:	c0d07ec0 	.word	0xc0d07ec0
c0d01a08:	0000022a 	.word	0x0000022a
c0d01a0c:	0000530c 	.word	0x0000530c

c0d01a10 <monero_apdu_put_key>:
#undef word_list_length

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_put_key() {
c0d01a10:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01a12:	b099      	sub	sp, #100	; 0x64

  unsigned char raw[32];
  unsigned char pub[32];
  unsigned char sec[32];

  if (G_monero_vstate.io_length != (32*2 + 32*2 + 95)) {
c0d01a14:	482e      	ldr	r0, [pc, #184]	; (c0d01ad0 <monero_apdu_put_key+0xc0>)
c0d01a16:	8900      	ldrh	r0, [r0, #8]
c0d01a18:	28df      	cmp	r0, #223	; 0xdf
c0d01a1a:	d155      	bne.n	c0d01ac8 <monero_apdu_put_key+0xb8>
c0d01a1c:	ad01      	add	r5, sp, #4
c0d01a1e:	2420      	movs	r4, #32
    THROW(SW_WRONG_LENGTH);
    return SW_WRONG_LENGTH;
  }

  //view key
  monero_io_fetch(sec, 32);
c0d01a20:	4628      	mov	r0, r5
c0d01a22:	4621      	mov	r1, r4
c0d01a24:	f7ff fdf0 	bl	c0d01608 <monero_io_fetch>
c0d01a28:	ae09      	add	r6, sp, #36	; 0x24
  monero_io_fetch(pub, 32);
c0d01a2a:	4630      	mov	r0, r6
c0d01a2c:	4621      	mov	r1, r4
c0d01a2e:	f7ff fdeb 	bl	c0d01608 <monero_io_fetch>
c0d01a32:	af11      	add	r7, sp, #68	; 0x44
  monero_ecmul_G(raw,sec);
c0d01a34:	4638      	mov	r0, r7
c0d01a36:	4629      	mov	r1, r5
c0d01a38:	f7fe ff00 	bl	c0d0083c <monero_ecmul_G>
  if (os_memcmp(pub, raw, 32)) {
c0d01a3c:	4630      	mov	r0, r6
c0d01a3e:	4639      	mov	r1, r7
c0d01a40:	4622      	mov	r2, r4
c0d01a42:	f002 f961 	bl	c0d03d08 <os_memcmp>
c0d01a46:	2800      	cmp	r0, #0
c0d01a48:	d13a      	bne.n	c0d01ac0 <monero_apdu_put_key+0xb0>
    THROW(SW_WRONG_DATA);
    return SW_WRONG_DATA;
  }
  nvm_write(N_monero_pstate->a, sec, 32);
c0d01a4a:	4822      	ldr	r0, [pc, #136]	; (c0d01ad4 <monero_apdu_put_key+0xc4>)
c0d01a4c:	f002 ff8e 	bl	c0d0496c <pic>
c0d01a50:	300a      	adds	r0, #10
c0d01a52:	ad01      	add	r5, sp, #4
c0d01a54:	2420      	movs	r4, #32
c0d01a56:	4629      	mov	r1, r5
c0d01a58:	4622      	mov	r2, r4
c0d01a5a:	f002 ffc9 	bl	c0d049f0 <nvm_write>

  //spend key
  monero_io_fetch(sec, 32);
c0d01a5e:	4628      	mov	r0, r5
c0d01a60:	4621      	mov	r1, r4
c0d01a62:	f7ff fdd1 	bl	c0d01608 <monero_io_fetch>
c0d01a66:	ae09      	add	r6, sp, #36	; 0x24
  monero_io_fetch(pub, 32);
c0d01a68:	4630      	mov	r0, r6
c0d01a6a:	4621      	mov	r1, r4
c0d01a6c:	f7ff fdcc 	bl	c0d01608 <monero_io_fetch>
c0d01a70:	af11      	add	r7, sp, #68	; 0x44
  monero_ecmul_G(raw,sec);
c0d01a72:	4638      	mov	r0, r7
c0d01a74:	4629      	mov	r1, r5
c0d01a76:	f7fe fee1 	bl	c0d0083c <monero_ecmul_G>
  if (os_memcmp(pub, raw, 32)) {
c0d01a7a:	4630      	mov	r0, r6
c0d01a7c:	4639      	mov	r1, r7
c0d01a7e:	4622      	mov	r2, r4
c0d01a80:	f002 f942 	bl	c0d03d08 <os_memcmp>
c0d01a84:	2800      	cmp	r0, #0
c0d01a86:	d11b      	bne.n	c0d01ac0 <monero_apdu_put_key+0xb0>
    THROW(SW_WRONG_DATA);
    return SW_WRONG_DATA;
  }
  nvm_write(N_monero_pstate->b, sec, 32);
c0d01a88:	4c12      	ldr	r4, [pc, #72]	; (c0d01ad4 <monero_apdu_put_key+0xc4>)
c0d01a8a:	4620      	mov	r0, r4
c0d01a8c:	f002 ff6e 	bl	c0d0496c <pic>
c0d01a90:	302a      	adds	r0, #42	; 0x2a
c0d01a92:	a901      	add	r1, sp, #4
c0d01a94:	2220      	movs	r2, #32
c0d01a96:	f002 ffab 	bl	c0d049f0 <nvm_write>
c0d01a9a:	466d      	mov	r5, sp
c0d01a9c:	2021      	movs	r0, #33	; 0x21


  //change mode
  unsigned char key_mode = KEY_MODE_EXTERNAL;
c0d01a9e:	7028      	strb	r0, [r5, #0]
  nvm_write(&N_monero_pstate->key_mode, &key_mode, 1);
c0d01aa0:	4620      	mov	r0, r4
c0d01aa2:	f002 ff63 	bl	c0d0496c <pic>
c0d01aa6:	3009      	adds	r0, #9
c0d01aa8:	2401      	movs	r4, #1
c0d01aaa:	4629      	mov	r1, r5
c0d01aac:	4622      	mov	r2, r4
c0d01aae:	f002 ff9f 	bl	c0d049f0 <nvm_write>

  monero_io_discard(1);
c0d01ab2:	4620      	mov	r0, r4
c0d01ab4:	f7ff fd12 	bl	c0d014dc <monero_io_discard>
c0d01ab8:	2009      	movs	r0, #9
c0d01aba:	0300      	lsls	r0, r0, #12

  return SW_OK;
c0d01abc:	b019      	add	sp, #100	; 0x64
c0d01abe:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d01ac0:	20d5      	movs	r0, #213	; 0xd5
c0d01ac2:	01c0      	lsls	r0, r0, #7
c0d01ac4:	f002 f934 	bl	c0d03d30 <os_longjmp>
c0d01ac8:	2067      	movs	r0, #103	; 0x67
c0d01aca:	0200      	lsls	r0, r0, #8
  unsigned char raw[32];
  unsigned char pub[32];
  unsigned char sec[32];

  if (G_monero_vstate.io_length != (32*2 + 32*2 + 95)) {
    THROW(SW_WRONG_LENGTH);
c0d01acc:	f002 f930 	bl	c0d03d30 <os_longjmp>
c0d01ad0:	20001930 	.word	0x20001930
c0d01ad4:	c0d07ec0 	.word	0xc0d07ec0

c0d01ad8 <monero_apdu_get_key>:


/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_get_key() {
c0d01ad8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01ada:	b081      	sub	sp, #4
c0d01adc:	2001      	movs	r0, #1

  monero_io_discard(1);
c0d01ade:	f7ff fcfd 	bl	c0d014dc <monero_io_discard>
  switch (G_monero_vstate.io_p1) {
c0d01ae2:	4f16      	ldr	r7, [pc, #88]	; (c0d01b3c <monero_apdu_get_key+0x64>)
c0d01ae4:	7938      	ldrb	r0, [r7, #4]
c0d01ae6:	2802      	cmp	r0, #2
c0d01ae8:	d01e      	beq.n	c0d01b28 <monero_apdu_get_key+0x50>
c0d01aea:	2801      	cmp	r0, #1
c0d01aec:	d121      	bne.n	c0d01b32 <monero_apdu_get_key+0x5a>
c0d01aee:	2059      	movs	r0, #89	; 0x59
c0d01af0:	0080      	lsls	r0, r0, #2
  //get pub
  case 1:
    //view key
    monero_io_insert(G_monero_vstate.A, 32);
c0d01af2:	183c      	adds	r4, r7, r0
c0d01af4:	2520      	movs	r5, #32
c0d01af6:	4620      	mov	r0, r4
c0d01af8:	4629      	mov	r1, r5
c0d01afa:	f7ff fd1b 	bl	c0d01534 <monero_io_insert>
c0d01afe:	2069      	movs	r0, #105	; 0x69
c0d01b00:	0080      	lsls	r0, r0, #2
    //spend key
    monero_io_insert(G_monero_vstate.B, 32);
c0d01b02:	183e      	adds	r6, r7, r0
c0d01b04:	4630      	mov	r0, r6
c0d01b06:	4629      	mov	r1, r5
c0d01b08:	f7ff fd14 	bl	c0d01534 <monero_io_insert>
    //public base address
    monero_base58_public_key((char*)G_monero_vstate.io_buffer+G_monero_vstate.io_offset, G_monero_vstate.A, G_monero_vstate.B, 0);
c0d01b0c:	8978      	ldrh	r0, [r7, #10]
c0d01b0e:	1838      	adds	r0, r7, r0
c0d01b10:	300e      	adds	r0, #14
c0d01b12:	2300      	movs	r3, #0
c0d01b14:	4621      	mov	r1, r4
c0d01b16:	4632      	mov	r2, r6
c0d01b18:	f000 ff4e 	bl	c0d029b8 <monero_base58_public_key>
c0d01b1c:	205f      	movs	r0, #95	; 0x5f
    monero_io_inserted(95);
c0d01b1e:	f7ff fcd3 	bl	c0d014c8 <monero_io_inserted>
c0d01b22:	2009      	movs	r0, #9
c0d01b24:	0300      	lsls	r0, r0, #12
c0d01b26:	e002      	b.n	c0d01b2e <monero_apdu_get_key+0x56>
    break;

  //get private
  case 2:
    //view key
    ui_export_viewkey_display();
c0d01b28:	f001 fce6 	bl	c0d034f8 <ui_export_viewkey_display>
c0d01b2c:	2000      	movs	r0, #0
  default:
    THROW(SW_WRONG_P1P2);
    return SW_WRONG_P1P2;
  }
  return SW_OK;
}
c0d01b2e:	b001      	add	sp, #4
c0d01b30:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d01b32:	206b      	movs	r0, #107	; 0x6b
c0d01b34:	0200      	lsls	r0, r0, #8
    break;
    }
    #endif

  default:
    THROW(SW_WRONG_P1P2);
c0d01b36:	f002 f8fb 	bl	c0d03d30 <os_longjmp>
c0d01b3a:	46c0      	nop			; (mov r8, r8)
c0d01b3c:	20001930 	.word	0x20001930

c0d01b40 <monero_apdu_verify_key>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_verify_key() {
c0d01b40:	b510      	push	{r4, lr}
c0d01b42:	b098      	sub	sp, #96	; 0x60
c0d01b44:	a808      	add	r0, sp, #32
  unsigned char pub[32];
  unsigned char priv[32];
  unsigned char computed_pub[32];
  unsigned int verified = 0;

  monero_io_fetch_decrypt_key(priv);
c0d01b46:	f7ff fda5 	bl	c0d01694 <monero_io_fetch_decrypt_key>
c0d01b4a:	a810      	add	r0, sp, #64	; 0x40
c0d01b4c:	2120      	movs	r1, #32
  monero_io_fetch(pub, 32);
c0d01b4e:	f7ff fd5b 	bl	c0d01608 <monero_io_fetch>
  switch (G_monero_vstate.io_p1) {
c0d01b52:	4816      	ldr	r0, [pc, #88]	; (c0d01bac <monero_apdu_verify_key+0x6c>)
c0d01b54:	7901      	ldrb	r1, [r0, #4]
c0d01b56:	2902      	cmp	r1, #2
c0d01b58:	d00a      	beq.n	c0d01b70 <monero_apdu_verify_key+0x30>
c0d01b5a:	2901      	cmp	r1, #1
c0d01b5c:	d006      	beq.n	c0d01b6c <monero_apdu_verify_key+0x2c>
c0d01b5e:	2900      	cmp	r1, #0
c0d01b60:	d120      	bne.n	c0d01ba4 <monero_apdu_verify_key+0x64>
c0d01b62:	4668      	mov	r0, sp
c0d01b64:	a908      	add	r1, sp, #32
  case 0:
    monero_secret_key_to_public_key(computed_pub, priv);
c0d01b66:	f7fe ff6d 	bl	c0d00a44 <monero_secret_key_to_public_key>
c0d01b6a:	e008      	b.n	c0d01b7e <monero_apdu_verify_key+0x3e>
c0d01b6c:	2159      	movs	r1, #89	; 0x59
c0d01b6e:	e000      	b.n	c0d01b72 <monero_apdu_verify_key+0x32>
c0d01b70:	2169      	movs	r1, #105	; 0x69
c0d01b72:	0089      	lsls	r1, r1, #2
c0d01b74:	1841      	adds	r1, r0, r1
c0d01b76:	a810      	add	r0, sp, #64	; 0x40
c0d01b78:	2220      	movs	r2, #32
c0d01b7a:	f002 f80a 	bl	c0d03b92 <os_memmove>
c0d01b7e:	4668      	mov	r0, sp
c0d01b80:	a910      	add	r1, sp, #64	; 0x40
c0d01b82:	2220      	movs	r2, #32
    break;
  default:
    THROW(SW_WRONG_P1P2);
    return SW_WRONG_P1P2;
  }
  if (os_memcmp(computed_pub, pub, 32) ==0 ) {
c0d01b84:	f002 f8c0 	bl	c0d03d08 <os_memcmp>
c0d01b88:	4604      	mov	r4, r0
c0d01b8a:	2001      	movs	r0, #1
    verified = 1;
  }

  monero_io_discard(1);
c0d01b8c:	f7ff fca6 	bl	c0d014dc <monero_io_discard>
c0d01b90:	2000      	movs	r0, #0
    break;
  default:
    THROW(SW_WRONG_P1P2);
    return SW_WRONG_P1P2;
  }
  if (os_memcmp(computed_pub, pub, 32) ==0 ) {
c0d01b92:	1b00      	subs	r0, r0, r4
c0d01b94:	4144      	adcs	r4, r0
    verified = 1;
  }

  monero_io_discard(1);
  monero_io_insert_u32(verified);
c0d01b96:	4620      	mov	r0, r4
c0d01b98:	f7ff fd04 	bl	c0d015a4 <monero_io_insert_u32>
c0d01b9c:	2009      	movs	r0, #9
c0d01b9e:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01ba0:	b018      	add	sp, #96	; 0x60
c0d01ba2:	bd10      	pop	{r4, pc}
c0d01ba4:	206b      	movs	r0, #107	; 0x6b
c0d01ba6:	0200      	lsls	r0, r0, #8
    break;
  case 2:
    os_memmove(pub, G_monero_vstate.B, 32);
    break;
  default:
    THROW(SW_WRONG_P1P2);
c0d01ba8:	f002 f8c2 	bl	c0d03d30 <os_longjmp>
c0d01bac:	20001930 	.word	0x20001930

c0d01bb0 <monero_apdu_get_chacha8_prekey>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
#define CHACHA8_KEY_TAIL 0x8c
int monero_apdu_get_chacha8_prekey(/*char  *prekey*/) {
c0d01bb0:	b570      	push	{r4, r5, r6, lr}
c0d01bb2:	b09a      	sub	sp, #104	; 0x68
c0d01bb4:	2000      	movs	r0, #0
  unsigned char abt[65];
  unsigned char pre[32];

  monero_io_discard(0);
c0d01bb6:	f7ff fc91 	bl	c0d014dc <monero_io_discard>
c0d01bba:	2051      	movs	r0, #81	; 0x51
c0d01bbc:	0080      	lsls	r0, r0, #2
  os_memmove(abt, G_monero_vstate.a, 32);
c0d01bbe:	4e14      	ldr	r6, [pc, #80]	; (c0d01c10 <monero_apdu_get_chacha8_prekey+0x60>)
c0d01bc0:	1831      	adds	r1, r6, r0
c0d01bc2:	ac09      	add	r4, sp, #36	; 0x24
c0d01bc4:	2520      	movs	r5, #32
c0d01bc6:	4620      	mov	r0, r4
c0d01bc8:	462a      	mov	r2, r5
c0d01bca:	f001 ffe2 	bl	c0d03b92 <os_memmove>
c0d01bce:	2061      	movs	r0, #97	; 0x61
c0d01bd0:	0080      	lsls	r0, r0, #2
  os_memmove(abt+32, G_monero_vstate.b, 32);
c0d01bd2:	1831      	adds	r1, r6, r0
c0d01bd4:	4620      	mov	r0, r4
c0d01bd6:	3020      	adds	r0, #32
c0d01bd8:	462a      	mov	r2, r5
c0d01bda:	f001 ffda 	bl	c0d03b92 <os_memmove>
c0d01bde:	2040      	movs	r0, #64	; 0x40
c0d01be0:	218c      	movs	r1, #140	; 0x8c
  abt[64] = CHACHA8_KEY_TAIL;
c0d01be2:	5421      	strb	r1, [r4, r0]
c0d01be4:	a801      	add	r0, sp, #4
  monero_keccak_F(abt, 65, pre);
c0d01be6:	4669      	mov	r1, sp
c0d01be8:	6008      	str	r0, [r1, #0]
c0d01bea:	2023      	movs	r0, #35	; 0x23
c0d01bec:	0100      	lsls	r0, r0, #4
c0d01bee:	1831      	adds	r1, r6, r0
c0d01bf0:	2006      	movs	r0, #6
c0d01bf2:	2341      	movs	r3, #65	; 0x41
c0d01bf4:	4622      	mov	r2, r4
c0d01bf6:	f7fe fb69 	bl	c0d002cc <monero_hash>
c0d01bfa:	2031      	movs	r0, #49	; 0x31
c0d01bfc:	0100      	lsls	r0, r0, #4
  monero_io_insert((unsigned char*)G_monero_vstate.keccakF.acc, 200);
c0d01bfe:	1830      	adds	r0, r6, r0
c0d01c00:	21c8      	movs	r1, #200	; 0xc8
c0d01c02:	f7ff fc97 	bl	c0d01534 <monero_io_insert>
c0d01c06:	2009      	movs	r0, #9
c0d01c08:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01c0a:	b01a      	add	sp, #104	; 0x68
c0d01c0c:	bd70      	pop	{r4, r5, r6, pc}
c0d01c0e:	46c0      	nop			; (mov r8, r8)
c0d01c10:	20001930 	.word	0x20001930

c0d01c14 <monero_apdu_sc_add>:
#undef CHACHA8_KEY_TAIL

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_sc_add(/*unsigned char *r, unsigned char *s1, unsigned char *s2*/) {
c0d01c14:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01c16:	b099      	sub	sp, #100	; 0x64
c0d01c18:	ad11      	add	r5, sp, #68	; 0x44
c0d01c1a:	2420      	movs	r4, #32
  unsigned char s1[32];
  unsigned char s2[32];
  unsigned char r[32];
  //fetch
  monero_io_fetch_decrypt(s1,32);
c0d01c1c:	4628      	mov	r0, r5
c0d01c1e:	4621      	mov	r1, r4
c0d01c20:	f7ff fd0e 	bl	c0d01640 <monero_io_fetch_decrypt>
c0d01c24:	ae09      	add	r6, sp, #36	; 0x24
  monero_io_fetch_decrypt(s2,32);
c0d01c26:	4630      	mov	r0, r6
c0d01c28:	4621      	mov	r1, r4
c0d01c2a:	f7ff fd09 	bl	c0d01640 <monero_io_fetch_decrypt>
c0d01c2e:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01c30:	f7ff fc54 	bl	c0d014dc <monero_io_discard>
c0d01c34:	af01      	add	r7, sp, #4
  monero_addm(r,s1,s2);
c0d01c36:	4638      	mov	r0, r7
c0d01c38:	4629      	mov	r1, r5
c0d01c3a:	4632      	mov	r2, r6
c0d01c3c:	f7fe fe88 	bl	c0d00950 <monero_addm>
  monero_io_insert_encrypt(r,32);
c0d01c40:	4638      	mov	r0, r7
c0d01c42:	4621      	mov	r1, r4
c0d01c44:	f7ff fc8a 	bl	c0d0155c <monero_io_insert_encrypt>
c0d01c48:	2009      	movs	r0, #9
c0d01c4a:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01c4c:	b019      	add	sp, #100	; 0x64
c0d01c4e:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d01c50 <monero_apdu_sc_sub>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_sc_sub(/*unsigned char *r, unsigned char *s1, unsigned char *s2*/) {
c0d01c50:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01c52:	b099      	sub	sp, #100	; 0x64
c0d01c54:	ad11      	add	r5, sp, #68	; 0x44
c0d01c56:	2420      	movs	r4, #32
  unsigned char s1[32];
  unsigned char s2[32];
  unsigned char r[32];
  //fetch
  monero_io_fetch_decrypt(s1,32);
c0d01c58:	4628      	mov	r0, r5
c0d01c5a:	4621      	mov	r1, r4
c0d01c5c:	f7ff fcf0 	bl	c0d01640 <monero_io_fetch_decrypt>
c0d01c60:	ae09      	add	r6, sp, #36	; 0x24
  monero_io_fetch_decrypt(s2,32);
c0d01c62:	4630      	mov	r0, r6
c0d01c64:	4621      	mov	r1, r4
c0d01c66:	f7ff fceb 	bl	c0d01640 <monero_io_fetch_decrypt>
c0d01c6a:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01c6c:	f7ff fc36 	bl	c0d014dc <monero_io_discard>
c0d01c70:	af01      	add	r7, sp, #4
  monero_subm(r,s1,s2);
c0d01c72:	4638      	mov	r0, r7
c0d01c74:	4629      	mov	r1, r5
c0d01c76:	4632      	mov	r2, r6
c0d01c78:	f7ff f88c 	bl	c0d00d94 <monero_subm>
  monero_io_insert_encrypt(r,32);
c0d01c7c:	4638      	mov	r0, r7
c0d01c7e:	4621      	mov	r1, r4
c0d01c80:	f7ff fc6c 	bl	c0d0155c <monero_io_insert_encrypt>
c0d01c84:	2009      	movs	r0, #9
c0d01c86:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01c88:	b019      	add	sp, #100	; 0x64
c0d01c8a:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d01c8c <monero_apdu_scal_mul_key>:


/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_scal_mul_key(/*const rct::key &pub, const rct::key &sec, rct::key mulkey*/) {
c0d01c8c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01c8e:	b099      	sub	sp, #100	; 0x64
c0d01c90:	ad11      	add	r5, sp, #68	; 0x44
c0d01c92:	2420      	movs	r4, #32
  unsigned char pub[32];
  unsigned char sec[32];
  unsigned char r[32];
  //fetch
  monero_io_fetch(pub,32);
c0d01c94:	4628      	mov	r0, r5
c0d01c96:	4621      	mov	r1, r4
c0d01c98:	f7ff fcb6 	bl	c0d01608 <monero_io_fetch>
c0d01c9c:	ae09      	add	r6, sp, #36	; 0x24
  monero_io_fetch_decrypt_key(sec);
c0d01c9e:	4630      	mov	r0, r6
c0d01ca0:	f7ff fcf8 	bl	c0d01694 <monero_io_fetch_decrypt_key>
c0d01ca4:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01ca6:	f7ff fc19 	bl	c0d014dc <monero_io_discard>
c0d01caa:	af01      	add	r7, sp, #4

  monero_ecmul_k(r,pub,sec);
c0d01cac:	4638      	mov	r0, r7
c0d01cae:	4629      	mov	r1, r5
c0d01cb0:	4632      	mov	r2, r6
c0d01cb2:	f7fe feda 	bl	c0d00a6a <monero_ecmul_k>
  monero_io_insert(r, 32);
c0d01cb6:	4638      	mov	r0, r7
c0d01cb8:	4621      	mov	r1, r4
c0d01cba:	f7ff fc3b 	bl	c0d01534 <monero_io_insert>
c0d01cbe:	2009      	movs	r0, #9
c0d01cc0:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01cc2:	b019      	add	sp, #100	; 0x64
c0d01cc4:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d01cc6 <monero_apdu_scal_mul_base>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_scal_mul_base(/*const rct::key &sec, rct::key mulkey*/) {
c0d01cc6:	b570      	push	{r4, r5, r6, lr}
c0d01cc8:	b090      	sub	sp, #64	; 0x40
c0d01cca:	ad08      	add	r5, sp, #32
c0d01ccc:	2420      	movs	r4, #32
  unsigned char sec[32];
  unsigned char r[32];
  //fetch
  monero_io_fetch_decrypt(sec,32);
c0d01cce:	4628      	mov	r0, r5
c0d01cd0:	4621      	mov	r1, r4
c0d01cd2:	f7ff fcb5 	bl	c0d01640 <monero_io_fetch_decrypt>
c0d01cd6:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01cd8:	f7ff fc00 	bl	c0d014dc <monero_io_discard>
c0d01cdc:	466e      	mov	r6, sp

  monero_ecmul_G(r,sec);
c0d01cde:	4630      	mov	r0, r6
c0d01ce0:	4629      	mov	r1, r5
c0d01ce2:	f7fe fdab 	bl	c0d0083c <monero_ecmul_G>
  monero_io_insert(r, 32);
c0d01ce6:	4630      	mov	r0, r6
c0d01ce8:	4621      	mov	r1, r4
c0d01cea:	f7ff fc23 	bl	c0d01534 <monero_io_insert>
c0d01cee:	2009      	movs	r0, #9
c0d01cf0:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01cf2:	b010      	add	sp, #64	; 0x40
c0d01cf4:	bd70      	pop	{r4, r5, r6, pc}

c0d01cf6 <monero_apdu_generate_keypair>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_generate_keypair(/*crypto::public_key &pub, crypto::secret_key &sec*/) {
c0d01cf6:	b570      	push	{r4, r5, r6, lr}
c0d01cf8:	b090      	sub	sp, #64	; 0x40
c0d01cfa:	2000      	movs	r0, #0
  unsigned char sec[32];
  unsigned char pub[32];

  monero_io_discard(0);
c0d01cfc:	f7ff fbee 	bl	c0d014dc <monero_io_discard>
c0d01d00:	466c      	mov	r4, sp
c0d01d02:	ad08      	add	r5, sp, #32
  monero_generate_keypair(pub,sec);
c0d01d04:	4620      	mov	r0, r4
c0d01d06:	4629      	mov	r1, r5
c0d01d08:	f7fe fd88 	bl	c0d0081c <monero_generate_keypair>
c0d01d0c:	2620      	movs	r6, #32
  monero_io_insert(pub,32);
c0d01d0e:	4620      	mov	r0, r4
c0d01d10:	4631      	mov	r1, r6
c0d01d12:	f7ff fc0f 	bl	c0d01534 <monero_io_insert>
  monero_io_insert_encrypt(sec,32);
c0d01d16:	4628      	mov	r0, r5
c0d01d18:	4631      	mov	r1, r6
c0d01d1a:	f7ff fc1f 	bl	c0d0155c <monero_io_insert_encrypt>
c0d01d1e:	2009      	movs	r0, #9
c0d01d20:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01d22:	b010      	add	sp, #64	; 0x40
c0d01d24:	bd70      	pop	{r4, r5, r6, pc}

c0d01d26 <monero_apdu_secret_key_to_public_key>:


/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_secret_key_to_public_key(/*const crypto::secret_key &sec, crypto::public_key &pub*/) {
c0d01d26:	b570      	push	{r4, r5, r6, lr}
c0d01d28:	b090      	sub	sp, #64	; 0x40
c0d01d2a:	ad08      	add	r5, sp, #32
c0d01d2c:	2420      	movs	r4, #32
  unsigned char sec[32];
  unsigned char pub[32];
  //fetch
  monero_io_fetch_decrypt(sec,32);
c0d01d2e:	4628      	mov	r0, r5
c0d01d30:	4621      	mov	r1, r4
c0d01d32:	f7ff fc85 	bl	c0d01640 <monero_io_fetch_decrypt>
c0d01d36:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01d38:	f7ff fbd0 	bl	c0d014dc <monero_io_discard>
c0d01d3c:	466e      	mov	r6, sp
  //pub
  monero_ecmul_G(pub,sec);
c0d01d3e:	4630      	mov	r0, r6
c0d01d40:	4629      	mov	r1, r5
c0d01d42:	f7fe fd7b 	bl	c0d0083c <monero_ecmul_G>
  //pub key
  monero_io_insert(pub,32);
c0d01d46:	4630      	mov	r0, r6
c0d01d48:	4621      	mov	r1, r4
c0d01d4a:	f7ff fbf3 	bl	c0d01534 <monero_io_insert>
c0d01d4e:	2009      	movs	r0, #9
c0d01d50:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01d52:	b010      	add	sp, #64	; 0x40
c0d01d54:	bd70      	pop	{r4, r5, r6, pc}

c0d01d56 <monero_apdu_generate_key_derivation>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_generate_key_derivation(/*const crypto::public_key &pub, const crypto::secret_key &sec, crypto::key_derivation &derivation*/) {
c0d01d56:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01d58:	b099      	sub	sp, #100	; 0x64
c0d01d5a:	ad11      	add	r5, sp, #68	; 0x44
c0d01d5c:	2420      	movs	r4, #32
  unsigned char pub[32];
  unsigned char sec[32];
  unsigned char drv[32];
  //fetch
  monero_io_fetch(pub,32);
c0d01d5e:	4628      	mov	r0, r5
c0d01d60:	4621      	mov	r1, r4
c0d01d62:	f7ff fc51 	bl	c0d01608 <monero_io_fetch>
c0d01d66:	ae09      	add	r6, sp, #36	; 0x24
  monero_io_fetch_decrypt_key(sec);
c0d01d68:	4630      	mov	r0, r6
c0d01d6a:	f7ff fc93 	bl	c0d01694 <monero_io_fetch_decrypt_key>
c0d01d6e:	2000      	movs	r0, #0

  monero_io_discard(0);
c0d01d70:	f7ff fbb4 	bl	c0d014dc <monero_io_discard>
c0d01d74:	af01      	add	r7, sp, #4

  //Derive  and keep
  monero_generate_key_derivation(drv, pub, sec);
c0d01d76:	4638      	mov	r0, r7
c0d01d78:	4629      	mov	r1, r5
c0d01d7a:	4632      	mov	r2, r6
c0d01d7c:	f7fe fd8c 	bl	c0d00898 <monero_generate_key_derivation>

  monero_io_insert_encrypt(drv,32);
c0d01d80:	4638      	mov	r0, r7
c0d01d82:	4621      	mov	r1, r4
c0d01d84:	f7ff fbea 	bl	c0d0155c <monero_io_insert_encrypt>
c0d01d88:	2009      	movs	r0, #9
c0d01d8a:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01d8c:	b019      	add	sp, #100	; 0x64
c0d01d8e:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d01d90 <monero_apdu_derivation_to_scalar>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_derivation_to_scalar(/*const crypto::key_derivation &derivation, const size_t output_index, ec_scalar &res*/) {
c0d01d90:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01d92:	b091      	sub	sp, #68	; 0x44
c0d01d94:	ad09      	add	r5, sp, #36	; 0x24
c0d01d96:	2420      	movs	r4, #32
  unsigned char derivation[32];
  unsigned int  output_index;
  unsigned char res[32];

  //fetch
  monero_io_fetch_decrypt(derivation,32);
c0d01d98:	4628      	mov	r0, r5
c0d01d9a:	4621      	mov	r1, r4
c0d01d9c:	f7ff fc50 	bl	c0d01640 <monero_io_fetch_decrypt>
  output_index = monero_io_fetch_u32();
c0d01da0:	f7ff fcaa 	bl	c0d016f8 <monero_io_fetch_u32>
c0d01da4:	4606      	mov	r6, r0
c0d01da6:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01da8:	f7ff fb98 	bl	c0d014dc <monero_io_discard>
c0d01dac:	af01      	add	r7, sp, #4

  //pub
  monero_derivation_to_scalar(res, derivation, output_index);
c0d01dae:	4638      	mov	r0, r7
c0d01db0:	4629      	mov	r1, r5
c0d01db2:	4632      	mov	r2, r6
c0d01db4:	f7fe fd80 	bl	c0d008b8 <monero_derivation_to_scalar>

  //pub key
  monero_io_insert_encrypt(res,32);
c0d01db8:	4638      	mov	r0, r7
c0d01dba:	4621      	mov	r1, r4
c0d01dbc:	f7ff fbce 	bl	c0d0155c <monero_io_insert_encrypt>
c0d01dc0:	2009      	movs	r0, #9
c0d01dc2:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01dc4:	b011      	add	sp, #68	; 0x44
c0d01dc6:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d01dc8 <monero_apdu_derive_public_key>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_derive_public_key(/*const crypto::key_derivation &derivation, const std::size_t output_index, const crypto::public_key &pub, public_key &derived_pub*/) {
c0d01dc8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01dca:	b099      	sub	sp, #100	; 0x64
c0d01dcc:	ad11      	add	r5, sp, #68	; 0x44
c0d01dce:	2420      	movs	r4, #32
  unsigned int  output_index;
  unsigned char pub[32];
  unsigned char drvpub[32];

  //fetch
  monero_io_fetch_decrypt(derivation,32);
c0d01dd0:	4628      	mov	r0, r5
c0d01dd2:	4621      	mov	r1, r4
c0d01dd4:	f7ff fc34 	bl	c0d01640 <monero_io_fetch_decrypt>
  output_index = monero_io_fetch_u32();
c0d01dd8:	f7ff fc8e 	bl	c0d016f8 <monero_io_fetch_u32>
c0d01ddc:	9000      	str	r0, [sp, #0]
c0d01dde:	af09      	add	r7, sp, #36	; 0x24
  monero_io_fetch(pub, 32);
c0d01de0:	4638      	mov	r0, r7
c0d01de2:	4621      	mov	r1, r4
c0d01de4:	f7ff fc10 	bl	c0d01608 <monero_io_fetch>
c0d01de8:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01dea:	f7ff fb77 	bl	c0d014dc <monero_io_discard>
c0d01dee:	ae01      	add	r6, sp, #4

  //pub
  monero_derive_public_key(drvpub, derivation, output_index, pub);
c0d01df0:	4630      	mov	r0, r6
c0d01df2:	4629      	mov	r1, r5
c0d01df4:	9a00      	ldr	r2, [sp, #0]
c0d01df6:	463b      	mov	r3, r7
c0d01df8:	f7fe fddc 	bl	c0d009b4 <monero_derive_public_key>

  //pub key
  monero_io_insert(drvpub,32);
c0d01dfc:	4630      	mov	r0, r6
c0d01dfe:	4621      	mov	r1, r4
c0d01e00:	f7ff fb98 	bl	c0d01534 <monero_io_insert>
c0d01e04:	2009      	movs	r0, #9
c0d01e06:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01e08:	b019      	add	sp, #100	; 0x64
c0d01e0a:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d01e0c <monero_apdu_derive_secret_key>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_derive_secret_key(/*const crypto::key_derivation &derivation, const std::size_t output_index, const crypto::secret_key &sec, secret_key &derived_sec*/){
c0d01e0c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01e0e:	b099      	sub	sp, #100	; 0x64
c0d01e10:	ad11      	add	r5, sp, #68	; 0x44
c0d01e12:	2420      	movs	r4, #32
  unsigned int  output_index;
  unsigned char sec[32];
  unsigned char drvsec[32];

  //fetch
  monero_io_fetch_decrypt(derivation,32);
c0d01e14:	4628      	mov	r0, r5
c0d01e16:	4621      	mov	r1, r4
c0d01e18:	f7ff fc12 	bl	c0d01640 <monero_io_fetch_decrypt>
  output_index = monero_io_fetch_u32();
c0d01e1c:	f7ff fc6c 	bl	c0d016f8 <monero_io_fetch_u32>
c0d01e20:	9000      	str	r0, [sp, #0]
c0d01e22:	af09      	add	r7, sp, #36	; 0x24
  monero_io_fetch_decrypt_key(sec);
c0d01e24:	4638      	mov	r0, r7
c0d01e26:	f7ff fc35 	bl	c0d01694 <monero_io_fetch_decrypt_key>
c0d01e2a:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01e2c:	f7ff fb56 	bl	c0d014dc <monero_io_discard>
c0d01e30:	ae01      	add	r6, sp, #4

  //pub
  monero_derive_secret_key(drvsec, derivation, output_index, sec);
c0d01e32:	4630      	mov	r0, r6
c0d01e34:	4629      	mov	r1, r5
c0d01e36:	9a00      	ldr	r2, [sp, #0]
c0d01e38:	463b      	mov	r3, r7
c0d01e3a:	f7fe fd79 	bl	c0d00930 <monero_derive_secret_key>

  //pub key
  monero_io_insert_encrypt(drvsec,32);
c0d01e3e:	4630      	mov	r0, r6
c0d01e40:	4621      	mov	r1, r4
c0d01e42:	f7ff fb8b 	bl	c0d0155c <monero_io_insert_encrypt>
c0d01e46:	2009      	movs	r0, #9
c0d01e48:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01e4a:	b019      	add	sp, #100	; 0x64
c0d01e4c:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d01e4e <monero_apdu_generate_key_image>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_generate_key_image(/*const crypto::public_key &pub, const crypto::secret_key &sec, crypto::key_image &image*/){
c0d01e4e:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01e50:	b099      	sub	sp, #100	; 0x64
c0d01e52:	ad11      	add	r5, sp, #68	; 0x44
c0d01e54:	2420      	movs	r4, #32
  unsigned char pub[32];
  unsigned char sec[32];
  unsigned char image[32];

  //fetch
  monero_io_fetch(pub,32);
c0d01e56:	4628      	mov	r0, r5
c0d01e58:	4621      	mov	r1, r4
c0d01e5a:	f7ff fbd5 	bl	c0d01608 <monero_io_fetch>
c0d01e5e:	ae09      	add	r6, sp, #36	; 0x24
  monero_io_fetch_decrypt(sec, 32);
c0d01e60:	4630      	mov	r0, r6
c0d01e62:	4621      	mov	r1, r4
c0d01e64:	f7ff fbec 	bl	c0d01640 <monero_io_fetch_decrypt>
c0d01e68:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01e6a:	f7ff fb37 	bl	c0d014dc <monero_io_discard>
c0d01e6e:	af01      	add	r7, sp, #4

  //pub
  monero_generate_key_image(image, pub, sec);
c0d01e70:	4638      	mov	r0, r7
c0d01e72:	4629      	mov	r1, r5
c0d01e74:	4632      	mov	r2, r6
c0d01e76:	f7fe fde9 	bl	c0d00a4c <monero_generate_key_image>

  //pub key
  monero_io_insert(image,32);
c0d01e7a:	4638      	mov	r0, r7
c0d01e7c:	4621      	mov	r1, r4
c0d01e7e:	f7ff fb59 	bl	c0d01534 <monero_io_insert>
c0d01e82:	2009      	movs	r0, #9
c0d01e84:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01e86:	b019      	add	sp, #100	; 0x64
c0d01e88:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d01e8a <monero_apdu_derive_subaddress_public_key>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_derive_subaddress_public_key(/*const crypto::public_key &pub, const crypto::key_derivation &derivation, const std::size_t output_index, public_key &derived_pub*/) {
c0d01e8a:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01e8c:	b099      	sub	sp, #100	; 0x64
c0d01e8e:	ad11      	add	r5, sp, #68	; 0x44
c0d01e90:	2420      	movs	r4, #32
  unsigned char derivation[32];
  unsigned int  output_index;
  unsigned char sub_pub[32];

  //fetch
  monero_io_fetch(pub,32);
c0d01e92:	4628      	mov	r0, r5
c0d01e94:	4621      	mov	r1, r4
c0d01e96:	f7ff fbb7 	bl	c0d01608 <monero_io_fetch>
c0d01e9a:	ae09      	add	r6, sp, #36	; 0x24
  monero_io_fetch_decrypt(derivation, 32);
c0d01e9c:	4630      	mov	r0, r6
c0d01e9e:	4621      	mov	r1, r4
c0d01ea0:	f7ff fbce 	bl	c0d01640 <monero_io_fetch_decrypt>
  output_index = monero_io_fetch_u32();
c0d01ea4:	f7ff fc28 	bl	c0d016f8 <monero_io_fetch_u32>
c0d01ea8:	9000      	str	r0, [sp, #0]
c0d01eaa:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01eac:	f7ff fb16 	bl	c0d014dc <monero_io_discard>
c0d01eb0:	af01      	add	r7, sp, #4

  //pub
  monero_derive_subaddress_public_key(sub_pub, pub, derivation, output_index);
c0d01eb2:	4638      	mov	r0, r7
c0d01eb4:	4629      	mov	r1, r5
c0d01eb6:	4632      	mov	r2, r6
c0d01eb8:	9b00      	ldr	r3, [sp, #0]
c0d01eba:	f7fe fe07 	bl	c0d00acc <monero_derive_subaddress_public_key>
  //pub key
  monero_io_insert(sub_pub,32);
c0d01ebe:	4638      	mov	r0, r7
c0d01ec0:	4621      	mov	r1, r4
c0d01ec2:	f7ff fb37 	bl	c0d01534 <monero_io_insert>
c0d01ec6:	2009      	movs	r0, #9
c0d01ec8:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01eca:	b019      	add	sp, #100	; 0x64
c0d01ecc:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d01ece <monero_apdu_get_subaddress>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_get_subaddress(/*const cryptonote::subaddress_index& index, cryptonote::account_public_address &address*/) {
c0d01ece:	b570      	push	{r4, r5, r6, lr}
c0d01ed0:	b092      	sub	sp, #72	; 0x48
c0d01ed2:	ac10      	add	r4, sp, #64	; 0x40
c0d01ed4:	2108      	movs	r1, #8
  unsigned char index[8];
  unsigned char C[32];
  unsigned char D[32];

  //fetch
  monero_io_fetch(index,8);
c0d01ed6:	4620      	mov	r0, r4
c0d01ed8:	f7ff fb96 	bl	c0d01608 <monero_io_fetch>
c0d01edc:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01ede:	f7ff fafd 	bl	c0d014dc <monero_io_discard>
c0d01ee2:	ad08      	add	r5, sp, #32
c0d01ee4:	466e      	mov	r6, sp

  //pub
  monero_get_subaddress(C,D,index);
c0d01ee6:	4628      	mov	r0, r5
c0d01ee8:	4631      	mov	r1, r6
c0d01eea:	4622      	mov	r2, r4
c0d01eec:	f7fe fe94 	bl	c0d00c18 <monero_get_subaddress>
c0d01ef0:	2420      	movs	r4, #32

  //pub key
  monero_io_insert(C,32);
c0d01ef2:	4628      	mov	r0, r5
c0d01ef4:	4621      	mov	r1, r4
c0d01ef6:	f7ff fb1d 	bl	c0d01534 <monero_io_insert>
  monero_io_insert(D,32);
c0d01efa:	4630      	mov	r0, r6
c0d01efc:	4621      	mov	r1, r4
c0d01efe:	f7ff fb19 	bl	c0d01534 <monero_io_insert>
c0d01f02:	2009      	movs	r0, #9
c0d01f04:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01f06:	b012      	add	sp, #72	; 0x48
c0d01f08:	bd70      	pop	{r4, r5, r6, pc}

c0d01f0a <monero_apdu_get_subaddress_spend_public_key>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_get_subaddress_spend_public_key(/*const cryptonote::subaddress_index& index, crypto::public_key D*/) {
c0d01f0a:	b5b0      	push	{r4, r5, r7, lr}
c0d01f0c:	b08a      	sub	sp, #40	; 0x28
c0d01f0e:	ac08      	add	r4, sp, #32
c0d01f10:	2108      	movs	r1, #8
  unsigned char index[8];
  unsigned char D[32];

  //fetch
  monero_io_fetch(index,8);
c0d01f12:	4620      	mov	r0, r4
c0d01f14:	f7ff fb78 	bl	c0d01608 <monero_io_fetch>
c0d01f18:	2001      	movs	r0, #1
  monero_io_discard(1);
c0d01f1a:	f7ff fadf 	bl	c0d014dc <monero_io_discard>
c0d01f1e:	466d      	mov	r5, sp

  //pub
  monero_get_subaddress_spend_public_key(D, index);
c0d01f20:	4628      	mov	r0, r5
c0d01f22:	4621      	mov	r1, r4
c0d01f24:	f7fe fe26 	bl	c0d00b74 <monero_get_subaddress_spend_public_key>
c0d01f28:	2120      	movs	r1, #32

  //pub key
  monero_io_insert(D,32);
c0d01f2a:	4628      	mov	r0, r5
c0d01f2c:	f7ff fb02 	bl	c0d01534 <monero_io_insert>
c0d01f30:	2009      	movs	r0, #9
c0d01f32:	0300      	lsls	r0, r0, #12

  return SW_OK;
c0d01f34:	b00a      	add	sp, #40	; 0x28
c0d01f36:	bdb0      	pop	{r4, r5, r7, pc}

c0d01f38 <monero_apdu_get_subaddress_secret_key>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_get_subaddress_secret_key(/*const crypto::secret_key& sec, const cryptonote::subaddress_index& index, crypto::secret_key &sub_sec*/) {
c0d01f38:	b570      	push	{r4, r5, r6, lr}
c0d01f3a:	b092      	sub	sp, #72	; 0x48
c0d01f3c:	ac0a      	add	r4, sp, #40	; 0x28
  unsigned char sec[32];
  unsigned char index[8];
  unsigned char sub_sec[32];

  monero_io_fetch_decrypt_key(sec);
c0d01f3e:	4620      	mov	r0, r4
c0d01f40:	f7ff fba8 	bl	c0d01694 <monero_io_fetch_decrypt_key>
c0d01f44:	ad08      	add	r5, sp, #32
c0d01f46:	2108      	movs	r1, #8
  monero_io_fetch(index,8);
c0d01f48:	4628      	mov	r0, r5
c0d01f4a:	f7ff fb5d 	bl	c0d01608 <monero_io_fetch>
c0d01f4e:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01f50:	f7ff fac4 	bl	c0d014dc <monero_io_discard>
c0d01f54:	466e      	mov	r6, sp

  //pub
  monero_get_subaddress_secret_key(sub_sec,sec,index);
c0d01f56:	4630      	mov	r0, r6
c0d01f58:	4621      	mov	r1, r4
c0d01f5a:	462a      	mov	r2, r5
c0d01f5c:	f7fe fe22 	bl	c0d00ba4 <monero_get_subaddress_secret_key>
c0d01f60:	2120      	movs	r1, #32

  //pub key
  monero_io_insert_encrypt(sub_sec,32);
c0d01f62:	4630      	mov	r0, r6
c0d01f64:	f7ff fafa 	bl	c0d0155c <monero_io_insert_encrypt>
c0d01f68:	2009      	movs	r0, #9
c0d01f6a:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01f6c:	b012      	add	sp, #72	; 0x48
c0d01f6e:	bd70      	pop	{r4, r5, r6, pc}

c0d01f70 <monero_apu_generate_txout_keys>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */

int monero_apu_generate_txout_keys(/*size_t tx_version, crypto::secret_key tx_sec, crypto::public_key Aout, crypto::public_key Bout, size_t output_index, bool is_change, bool is_subaddress, bool need_additional_key*/) {
c0d01f70:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01f72:	b0a7      	sub	sp, #156	; 0x9c
  #define out_eph_public_key additional_txkey_sec
  //TMP
  unsigned char derivation[32];


  tx_version = monero_io_fetch_u32();
c0d01f74:	f7ff fbc0 	bl	c0d016f8 <monero_io_fetch_u32>
c0d01f78:	a81f      	add	r0, sp, #124	; 0x7c
  monero_io_fetch_decrypt_key(tx_key);
c0d01f7a:	f7ff fb8b 	bl	c0d01694 <monero_io_fetch_decrypt_key>
  txkey_pub = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
c0d01f7e:	4f5a      	ldr	r7, [pc, #360]	; (c0d020e8 <monero_apu_generate_txout_keys+0x178>)
c0d01f80:	8978      	ldrh	r0, [r7, #10]
c0d01f82:	9005      	str	r0, [sp, #20]
c0d01f84:	2400      	movs	r4, #0
c0d01f86:	2520      	movs	r5, #32
c0d01f88:	4620      	mov	r0, r4
c0d01f8a:	4629      	mov	r1, r5
c0d01f8c:	f7ff fb3c 	bl	c0d01608 <monero_io_fetch>
  Aout = G_monero_vstate.io_buffer+G_monero_vstate.io_offset;   monero_io_fetch(NULL,32);
c0d01f90:	8978      	ldrh	r0, [r7, #10]
c0d01f92:	9004      	str	r0, [sp, #16]
c0d01f94:	4620      	mov	r0, r4
c0d01f96:	4629      	mov	r1, r5
c0d01f98:	f7ff fb36 	bl	c0d01608 <monero_io_fetch>
  Bout = G_monero_vstate.io_buffer+G_monero_vstate.io_offset;   monero_io_fetch(NULL,32);
c0d01f9c:	897e      	ldrh	r6, [r7, #10]
c0d01f9e:	4620      	mov	r0, r4
c0d01fa0:	4629      	mov	r1, r5
c0d01fa2:	f7ff fb31 	bl	c0d01608 <monero_io_fetch>
  output_index = monero_io_fetch_u32();
c0d01fa6:	f7ff fba7 	bl	c0d016f8 <monero_io_fetch_u32>
c0d01faa:	4605      	mov	r5, r0
  is_change = monero_io_fetch_u8();
c0d01fac:	f7ff fbc0 	bl	c0d01730 <monero_io_fetch_u8>
c0d01fb0:	a91e      	add	r1, sp, #120	; 0x78
c0d01fb2:	7008      	strb	r0, [r1, #0]
c0d01fb4:	463c      	mov	r4, r7
  unsigned char derivation[32];


  tx_version = monero_io_fetch_u32();
  monero_io_fetch_decrypt_key(tx_key);
  txkey_pub = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
c0d01fb6:	4638      	mov	r0, r7
c0d01fb8:	300e      	adds	r0, #14
c0d01fba:	9905      	ldr	r1, [sp, #20]
c0d01fbc:	1847      	adds	r7, r0, r1
  Aout = G_monero_vstate.io_buffer+G_monero_vstate.io_offset;   monero_io_fetch(NULL,32);
c0d01fbe:	9904      	ldr	r1, [sp, #16]
c0d01fc0:	1841      	adds	r1, r0, r1
  Bout = G_monero_vstate.io_buffer+G_monero_vstate.io_offset;   monero_io_fetch(NULL,32);
c0d01fc2:	9101      	str	r1, [sp, #4]
c0d01fc4:	1980      	adds	r0, r0, r6
  output_index = monero_io_fetch_u32();
  is_change = monero_io_fetch_u8();
  is_subaddress = monero_io_fetch_u8();
c0d01fc6:	9005      	str	r0, [sp, #20]
c0d01fc8:	f7ff fbb2 	bl	c0d01730 <monero_io_fetch_u8>
c0d01fcc:	9003      	str	r0, [sp, #12]
  need_additional_txkeys = monero_io_fetch_u8();
c0d01fce:	f7ff fbaf 	bl	c0d01730 <monero_io_fetch_u8>
  if (need_additional_txkeys) {
c0d01fd2:	0606      	lsls	r6, r0, #24
c0d01fd4:	9700      	str	r7, [sp, #0]
c0d01fd6:	d003      	beq.n	c0d01fe0 <monero_apu_generate_txout_keys+0x70>
c0d01fd8:	a816      	add	r0, sp, #88	; 0x58
    monero_io_fetch_decrypt_key(additional_txkey_sec);
c0d01fda:	f7ff fb5b 	bl	c0d01694 <monero_io_fetch_decrypt_key>
c0d01fde:	e003      	b.n	c0d01fe8 <monero_apu_generate_txout_keys+0x78>
c0d01fe0:	2000      	movs	r0, #0
c0d01fe2:	2120      	movs	r1, #32
  } else {
    monero_io_fetch(NULL,32);
c0d01fe4:	f7ff fb10 	bl	c0d01608 <monero_io_fetch>
c0d01fe8:	4627      	mov	r7, r4
c0d01fea:	462c      	mov	r4, r5
c0d01fec:	2005      	movs	r0, #5
c0d01fee:	0180      	lsls	r0, r0, #6
c0d01ff0:	9002      	str	r0, [sp, #8]
  }



  //update outkeys hash control
  if (G_monero_vstate.sig_mode == TRANSACTION_CREATE_REAL) {
c0d01ff2:	5838      	ldr	r0, [r7, r0]
c0d01ff4:	2801      	cmp	r0, #1
c0d01ff6:	9604      	str	r6, [sp, #16]
c0d01ff8:	d117      	bne.n	c0d0202a <monero_apu_generate_txout_keys+0xba>
c0d01ffa:	78b8      	ldrb	r0, [r7, #2]
c0d01ffc:	2802      	cmp	r0, #2
c0d01ffe:	d114      	bne.n	c0d0202a <monero_apu_generate_txout_keys+0xba>
c0d02000:	2017      	movs	r0, #23
c0d02002:	0180      	lsls	r0, r0, #6
    if (G_monero_vstate.io_protocol_version == 2) {
      monero_sha256_outkeys_update(Aout,32);
c0d02004:	183e      	adds	r6, r7, r0
c0d02006:	2420      	movs	r4, #32
c0d02008:	4630      	mov	r0, r6
c0d0200a:	9901      	ldr	r1, [sp, #4]
c0d0200c:	4622      	mov	r2, r4
c0d0200e:	f7fe f945 	bl	c0d0029c <monero_hash_update>
      monero_sha256_outkeys_update(Bout,32);
c0d02012:	4630      	mov	r0, r6
c0d02014:	9905      	ldr	r1, [sp, #20]
c0d02016:	4622      	mov	r2, r4
c0d02018:	462c      	mov	r4, r5
c0d0201a:	f7fe f93f 	bl	c0d0029c <monero_hash_update>
c0d0201e:	a91e      	add	r1, sp, #120	; 0x78
c0d02020:	2201      	movs	r2, #1
      monero_sha256_outkeys_update(&is_change,1);
c0d02022:	4630      	mov	r0, r6
c0d02024:	9e04      	ldr	r6, [sp, #16]
c0d02026:	f7fe f939 	bl	c0d0029c <monero_hash_update>
    }
  }

  // make additional tx pubkey if necessary
  if (need_additional_txkeys) {
c0d0202a:	2e00      	cmp	r6, #0
c0d0202c:	d008      	beq.n	c0d02040 <monero_apu_generate_txout_keys+0xd0>
    if (is_subaddress) {
c0d0202e:	9803      	ldr	r0, [sp, #12]
c0d02030:	0600      	lsls	r0, r0, #24
c0d02032:	d00b      	beq.n	c0d0204c <monero_apu_generate_txout_keys+0xdc>
c0d02034:	a80e      	add	r0, sp, #56	; 0x38
c0d02036:	aa16      	add	r2, sp, #88	; 0x58
      monero_ecmul_k(additional_txkey_pub, Bout, additional_txkey_sec);
c0d02038:	9905      	ldr	r1, [sp, #20]
c0d0203a:	f7fe fd16 	bl	c0d00a6a <monero_ecmul_k>
c0d0203e:	e009      	b.n	c0d02054 <monero_apu_generate_txout_keys+0xe4>
c0d02040:	a80e      	add	r0, sp, #56	; 0x38
c0d02042:	2100      	movs	r1, #0
c0d02044:	2220      	movs	r2, #32
    } else {
      monero_ecmul_G(additional_txkey_pub, additional_txkey_sec);
    }
  } else {
      os_memset(additional_txkey_pub, 0, 32);
c0d02046:	f001 fd9b 	bl	c0d03b80 <os_memset>
c0d0204a:	e003      	b.n	c0d02054 <monero_apu_generate_txout_keys+0xe4>
c0d0204c:	a80e      	add	r0, sp, #56	; 0x38
c0d0204e:	a916      	add	r1, sp, #88	; 0x58
  // make additional tx pubkey if necessary
  if (need_additional_txkeys) {
    if (is_subaddress) {
      monero_ecmul_k(additional_txkey_pub, Bout, additional_txkey_sec);
    } else {
      monero_ecmul_G(additional_txkey_pub, additional_txkey_sec);
c0d02050:	f7fe fbf4 	bl	c0d0083c <monero_ecmul_G>
c0d02054:	9d02      	ldr	r5, [sp, #8]
c0d02056:	a81e      	add	r0, sp, #120	; 0x78
  } else {
      os_memset(additional_txkey_pub, 0, 32);
  }

  //derivation
  if (is_change) {
c0d02058:	7800      	ldrb	r0, [r0, #0]
c0d0205a:	2800      	cmp	r0, #0
c0d0205c:	d005      	beq.n	c0d0206a <monero_apu_generate_txout_keys+0xfa>
c0d0205e:	2051      	movs	r0, #81	; 0x51
c0d02060:	0080      	lsls	r0, r0, #2
    monero_generate_key_derivation(derivation, txkey_pub, G_monero_vstate.a);
c0d02062:	183a      	adds	r2, r7, r0
c0d02064:	a806      	add	r0, sp, #24
c0d02066:	9900      	ldr	r1, [sp, #0]
c0d02068:	e00b      	b.n	c0d02082 <monero_apu_generate_txout_keys+0x112>
c0d0206a:	aa1f      	add	r2, sp, #124	; 0x7c
c0d0206c:	a916      	add	r1, sp, #88	; 0x58
  } else {
    monero_generate_key_derivation(derivation, Aout, (is_subaddress && need_additional_txkeys) ? additional_txkey_sec : tx_key);
c0d0206e:	2e00      	cmp	r6, #0
c0d02070:	4610      	mov	r0, r2
c0d02072:	d000      	beq.n	c0d02076 <monero_apu_generate_txout_keys+0x106>
c0d02074:	4608      	mov	r0, r1
c0d02076:	9903      	ldr	r1, [sp, #12]
c0d02078:	0609      	lsls	r1, r1, #24
c0d0207a:	d000      	beq.n	c0d0207e <monero_apu_generate_txout_keys+0x10e>
c0d0207c:	4602      	mov	r2, r0
c0d0207e:	a806      	add	r0, sp, #24
c0d02080:	9901      	ldr	r1, [sp, #4]
c0d02082:	f7fe fc09 	bl	c0d00898 <monero_generate_key_derivation>
c0d02086:	a81f      	add	r0, sp, #124	; 0x7c
c0d02088:	a906      	add	r1, sp, #24
  }

  //compute amount key AKout (scalar1), version is always greater than 1
  monero_derivation_to_scalar(amount_key, derivation, output_index);
c0d0208a:	4622      	mov	r2, r4
c0d0208c:	f7fe fc14 	bl	c0d008b8 <monero_derivation_to_scalar>
  if (G_monero_vstate.sig_mode == TRANSACTION_CREATE_REAL) {
c0d02090:	5978      	ldr	r0, [r7, r5]
c0d02092:	2801      	cmp	r0, #1
c0d02094:	d109      	bne.n	c0d020aa <monero_apu_generate_txout_keys+0x13a>
c0d02096:	78b8      	ldrb	r0, [r7, #2]
c0d02098:	2802      	cmp	r0, #2
c0d0209a:	d106      	bne.n	c0d020aa <monero_apu_generate_txout_keys+0x13a>
c0d0209c:	2017      	movs	r0, #23
c0d0209e:	0180      	lsls	r0, r0, #6
      if (G_monero_vstate.io_protocol_version == 2) {
        monero_sha256_outkeys_update(amount_key,32);
c0d020a0:	1838      	adds	r0, r7, r0
c0d020a2:	a91f      	add	r1, sp, #124	; 0x7c
c0d020a4:	2220      	movs	r2, #32
c0d020a6:	f7fe f8f9 	bl	c0d0029c <monero_hash_update>
c0d020aa:	ae16      	add	r6, sp, #88	; 0x58
c0d020ac:	a906      	add	r1, sp, #24
      }
  }

  //compute ephemeral output key
  monero_derive_public_key(out_eph_public_key, derivation, output_index, Bout);
c0d020ae:	4630      	mov	r0, r6
c0d020b0:	4622      	mov	r2, r4
c0d020b2:	9b05      	ldr	r3, [sp, #20]
c0d020b4:	f7fe fc7e 	bl	c0d009b4 <monero_derive_public_key>
c0d020b8:	2000      	movs	r0, #0

  //send all
  monero_io_discard(0);
c0d020ba:	f7ff fa0f 	bl	c0d014dc <monero_io_discard>
c0d020be:	a81f      	add	r0, sp, #124	; 0x7c
c0d020c0:	2420      	movs	r4, #32
  monero_io_insert_encrypt(amount_key,32);
c0d020c2:	4621      	mov	r1, r4
c0d020c4:	f7ff fa4a 	bl	c0d0155c <monero_io_insert_encrypt>
  monero_io_insert(out_eph_public_key, 32);
c0d020c8:	4630      	mov	r0, r6
c0d020ca:	4621      	mov	r1, r4
c0d020cc:	f7ff fa32 	bl	c0d01534 <monero_io_insert>
  if (need_additional_txkeys) {
c0d020d0:	9804      	ldr	r0, [sp, #16]
c0d020d2:	2800      	cmp	r0, #0
c0d020d4:	d003      	beq.n	c0d020de <monero_apu_generate_txout_keys+0x16e>
c0d020d6:	a80e      	add	r0, sp, #56	; 0x38
c0d020d8:	2120      	movs	r1, #32
    monero_io_insert(additional_txkey_pub, 32);
c0d020da:	f7ff fa2b 	bl	c0d01534 <monero_io_insert>
c0d020de:	2009      	movs	r0, #9
c0d020e0:	0300      	lsls	r0, r0, #12
  }
  return SW_OK;
c0d020e2:	b027      	add	sp, #156	; 0x9c
c0d020e4:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d020e6:	46c0      	nop			; (mov r8, r8)
c0d020e8:	20001930 	.word	0x20001930

c0d020ec <monero_main>:

/* ----------------------------------------------------------------------- */
/* ---                            Application Entry                    --- */
/* ----------------------------------------------------------------------- */

void monero_main(void) {
c0d020ec:	b08c      	sub	sp, #48	; 0x30
c0d020ee:	2700      	movs	r7, #0
c0d020f0:	463c      	mov	r4, r7
c0d020f2:	a80b      	add	r0, sp, #44	; 0x2c
  unsigned int io_flags;
  io_flags = 0;
  for (;;) {
    volatile unsigned short sw = 0;
c0d020f4:	8007      	strh	r7, [r0, #0]
c0d020f6:	466e      	mov	r6, sp
    BEGIN_TRY {
      TRY {
c0d020f8:	4630      	mov	r0, r6
c0d020fa:	f004 fc57 	bl	c0d069ac <setjmp>
c0d020fe:	8530      	strh	r0, [r6, #40]	; 0x28
c0d02100:	b286      	uxth	r6, r0
c0d02102:	2e00      	cmp	r6, #0
c0d02104:	d016      	beq.n	c0d02134 <monero_main+0x48>
c0d02106:	4605      	mov	r5, r0
c0d02108:	4668      	mov	r0, sp
c0d0210a:	2100      	movs	r1, #0
        monero_io_do(io_flags);
        sw = monero_dispatch();
      }
      CATCH_OTHER(e) {
c0d0210c:	8501      	strh	r1, [r0, #40]	; 0x28
c0d0210e:	2001      	movs	r0, #1
        monero_io_discard(1);
c0d02110:	f7ff f9e4 	bl	c0d014dc <monero_io_discard>
c0d02114:	200f      	movs	r0, #15
c0d02116:	0304      	lsls	r4, r0, #12
        monero_reset_tx();
        if ( (e & 0xFFFF0000) ||
             ( ((e&0xF000)!=0x6000) && ((e&0xF000)!=0x9000) ) ) {
c0d02118:	402c      	ands	r4, r5
        monero_io_do(io_flags);
        sw = monero_dispatch();
      }
      CATCH_OTHER(e) {
        monero_io_discard(1);
        monero_reset_tx();
c0d0211a:	f000 fd45 	bl	c0d02ba8 <monero_reset_tx>
c0d0211e:	2003      	movs	r0, #3
c0d02120:	0340      	lsls	r0, r0, #13
        if ( (e & 0xFFFF0000) ||
             ( ((e&0xF000)!=0x6000) && ((e&0xF000)!=0x9000) ) ) {
c0d02122:	4284      	cmp	r4, r0
c0d02124:	d003      	beq.n	c0d0212e <monero_main+0x42>
c0d02126:	2009      	movs	r0, #9
c0d02128:	0300      	lsls	r0, r0, #12
c0d0212a:	4284      	cmp	r4, r0
c0d0212c:	d10d      	bne.n	c0d0214a <monero_main+0x5e>
c0d0212e:	a80b      	add	r0, sp, #44	; 0x2c
          monero_io_insert_u32(e);
          sw = 0x6f42;
        } else {
          sw = e;
c0d02130:	8005      	strh	r5, [r0, #0]
c0d02132:	e010      	b.n	c0d02156 <monero_main+0x6a>
c0d02134:	4668      	mov	r0, sp
  unsigned int io_flags;
  io_flags = 0;
  for (;;) {
    volatile unsigned short sw = 0;
    BEGIN_TRY {
      TRY {
c0d02136:	f001 fc44 	bl	c0d039c2 <try_context_set>
        monero_io_do(io_flags);
c0d0213a:	4620      	mov	r0, r4
c0d0213c:	f7ff fb0a 	bl	c0d01754 <monero_io_do>
        sw = monero_dispatch();
c0d02140:	f7fe ffae 	bl	c0d010a0 <monero_dispatch>
c0d02144:	a90b      	add	r1, sp, #44	; 0x2c
c0d02146:	8008      	strh	r0, [r1, #0]
c0d02148:	e005      	b.n	c0d02156 <monero_main+0x6a>
      CATCH_OTHER(e) {
        monero_io_discard(1);
        monero_reset_tx();
        if ( (e & 0xFFFF0000) ||
             ( ((e&0xF000)!=0x6000) && ((e&0xF000)!=0x9000) ) ) {
          monero_io_insert_u32(e);
c0d0214a:	4630      	mov	r0, r6
c0d0214c:	f7ff fa2a 	bl	c0d015a4 <monero_io_insert_u32>
c0d02150:	a80b      	add	r0, sp, #44	; 0x2c
          sw = 0x6f42;
c0d02152:	490d      	ldr	r1, [pc, #52]	; (c0d02188 <monero_main+0x9c>)
c0d02154:	8001      	strh	r1, [r0, #0]
        } else {
          sw = e;
        }
      }
      FINALLY {
c0d02156:	f001 fdef 	bl	c0d03d38 <try_context_get>
c0d0215a:	4669      	mov	r1, sp
c0d0215c:	4288      	cmp	r0, r1
c0d0215e:	d103      	bne.n	c0d02168 <monero_main+0x7c>
c0d02160:	f001 fdec 	bl	c0d03d3c <try_context_get_previous>
c0d02164:	f001 fc2d 	bl	c0d039c2 <try_context_set>
c0d02168:	a80b      	add	r0, sp, #44	; 0x2c
        if (sw) {
c0d0216a:	8800      	ldrh	r0, [r0, #0]
c0d0216c:	2410      	movs	r4, #16
c0d0216e:	2800      	cmp	r0, #0
c0d02170:	d004      	beq.n	c0d0217c <monero_main+0x90>
c0d02172:	a80b      	add	r0, sp, #44	; 0x2c
          monero_io_insert_u16(sw);
c0d02174:	8800      	ldrh	r0, [r0, #0]
c0d02176:	f7ff fa29 	bl	c0d015cc <monero_io_insert_u16>
c0d0217a:	2400      	movs	r4, #0
c0d0217c:	4668      	mov	r0, sp
        } else {
          io_flags = IO_ASYNCH_REPLY;
        }
      }
    }
    END_TRY;
c0d0217e:	8d00      	ldrh	r0, [r0, #40]	; 0x28
c0d02180:	2800      	cmp	r0, #0
c0d02182:	d0b6      	beq.n	c0d020f2 <monero_main+0x6>
c0d02184:	f001 fdd4 	bl	c0d03d30 <os_longjmp>
c0d02188:	00006f42 	.word	0x00006f42

c0d0218c <io_event>:
  }

}


unsigned char io_event(unsigned char channel) {
c0d0218c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0218e:	b085      	sub	sp, #20
  int s_before ;
  int s_after  ;

  s_before =  os_global_pin_is_validated();
c0d02190:	f002 fe10 	bl	c0d04db4 <os_global_pin_is_validated>
  
  // nothing done with the event, throw an error on the transport layer if
  // needed
  // can't have more than one tag in the reply, not supported yet.
  switch (G_io_seproxyhal_spi_buffer[0]) {
c0d02194:	4fea      	ldr	r7, [pc, #936]	; (c0d02540 <io_event+0x3b4>)
c0d02196:	7839      	ldrb	r1, [r7, #0]
c0d02198:	4dea      	ldr	r5, [pc, #936]	; (c0d02544 <io_event+0x3b8>)
c0d0219a:	290c      	cmp	r1, #12
c0d0219c:	9004      	str	r0, [sp, #16]
c0d0219e:	dc51      	bgt.n	c0d02244 <io_event+0xb8>
c0d021a0:	2905      	cmp	r1, #5
c0d021a2:	d100      	bne.n	c0d021a6 <io_event+0x1a>
c0d021a4:	e099      	b.n	c0d022da <io_event+0x14e>
c0d021a6:	290c      	cmp	r1, #12
c0d021a8:	d000      	beq.n	c0d021ac <io_event+0x20>
c0d021aa:	e122      	b.n	c0d023f2 <io_event+0x266>
  case SEPROXYHAL_TAG_FINGER_EVENT:
    UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
c0d021ac:	4ee6      	ldr	r6, [pc, #920]	; (c0d02548 <io_event+0x3bc>)
c0d021ae:	2400      	movs	r4, #0
c0d021b0:	61f4      	str	r4, [r6, #28]
c0d021b2:	2001      	movs	r0, #1
c0d021b4:	7630      	strb	r0, [r6, #24]
c0d021b6:	4630      	mov	r0, r6
c0d021b8:	3018      	adds	r0, #24
c0d021ba:	f002 fe27 	bl	c0d04e0c <os_ux>
c0d021be:	61f0      	str	r0, [r6, #28]
c0d021c0:	f002 fbd2 	bl	c0d04968 <ux_check_status_default>
c0d021c4:	69f0      	ldr	r0, [r6, #28]
c0d021c6:	4de1      	ldr	r5, [pc, #900]	; (c0d0254c <io_event+0x3c0>)
c0d021c8:	42a8      	cmp	r0, r5
c0d021ca:	d100      	bne.n	c0d021ce <io_event+0x42>
c0d021cc:	e233      	b.n	c0d02636 <io_event+0x4aa>
c0d021ce:	2800      	cmp	r0, #0
c0d021d0:	d100      	bne.n	c0d021d4 <io_event+0x48>
c0d021d2:	e230      	b.n	c0d02636 <io_event+0x4aa>
c0d021d4:	49fc      	ldr	r1, [pc, #1008]	; (c0d025c8 <io_event+0x43c>)
c0d021d6:	4288      	cmp	r0, r1
c0d021d8:	d000      	beq.n	c0d021dc <io_event+0x50>
c0d021da:	e1b9      	b.n	c0d02550 <io_event+0x3c4>
c0d021dc:	f001 fefe 	bl	c0d03fdc <io_seproxyhal_init_ux>
c0d021e0:	f001 ff02 	bl	c0d03fe8 <io_seproxyhal_init_button>
c0d021e4:	60b4      	str	r4, [r6, #8]
c0d021e6:	6830      	ldr	r0, [r6, #0]
c0d021e8:	2800      	cmp	r0, #0
c0d021ea:	d100      	bne.n	c0d021ee <io_event+0x62>
c0d021ec:	e223      	b.n	c0d02636 <io_event+0x4aa>
c0d021ee:	69f0      	ldr	r0, [r6, #28]
c0d021f0:	42a8      	cmp	r0, r5
c0d021f2:	d100      	bne.n	c0d021f6 <io_event+0x6a>
c0d021f4:	e21f      	b.n	c0d02636 <io_event+0x4aa>
c0d021f6:	2800      	cmp	r0, #0
c0d021f8:	d100      	bne.n	c0d021fc <io_event+0x70>
c0d021fa:	e21c      	b.n	c0d02636 <io_event+0x4aa>
c0d021fc:	2000      	movs	r0, #0
c0d021fe:	6871      	ldr	r1, [r6, #4]
c0d02200:	4288      	cmp	r0, r1
c0d02202:	d300      	bcc.n	c0d02206 <io_event+0x7a>
c0d02204:	e217      	b.n	c0d02636 <io_event+0x4aa>
c0d02206:	f002 fe5b 	bl	c0d04ec0 <io_seproxyhal_spi_is_status_sent>
c0d0220a:	2800      	cmp	r0, #0
c0d0220c:	d000      	beq.n	c0d02210 <io_event+0x84>
c0d0220e:	e212      	b.n	c0d02636 <io_event+0x4aa>
c0d02210:	68b0      	ldr	r0, [r6, #8]
c0d02212:	68f1      	ldr	r1, [r6, #12]
c0d02214:	2438      	movs	r4, #56	; 0x38
c0d02216:	4360      	muls	r0, r4
c0d02218:	6832      	ldr	r2, [r6, #0]
c0d0221a:	1810      	adds	r0, r2, r0
c0d0221c:	2900      	cmp	r1, #0
c0d0221e:	d002      	beq.n	c0d02226 <io_event+0x9a>
c0d02220:	4788      	blx	r1
c0d02222:	2800      	cmp	r0, #0
c0d02224:	d007      	beq.n	c0d02236 <io_event+0xaa>
c0d02226:	2801      	cmp	r0, #1
c0d02228:	d103      	bne.n	c0d02232 <io_event+0xa6>
c0d0222a:	68b0      	ldr	r0, [r6, #8]
c0d0222c:	4344      	muls	r4, r0
c0d0222e:	6830      	ldr	r0, [r6, #0]
c0d02230:	1900      	adds	r0, r0, r4
c0d02232:	f001 fa19 	bl	c0d03668 <io_seproxyhal_display>
c0d02236:	68b0      	ldr	r0, [r6, #8]
c0d02238:	1c40      	adds	r0, r0, #1
c0d0223a:	60b0      	str	r0, [r6, #8]
c0d0223c:	6831      	ldr	r1, [r6, #0]
c0d0223e:	2900      	cmp	r1, #0
c0d02240:	d1dd      	bne.n	c0d021fe <io_event+0x72>
c0d02242:	e1f8      	b.n	c0d02636 <io_event+0x4aa>
  s_before =  os_global_pin_is_validated();
  
  // nothing done with the event, throw an error on the transport layer if
  // needed
  // can't have more than one tag in the reply, not supported yet.
  switch (G_io_seproxyhal_spi_buffer[0]) {
c0d02244:	290d      	cmp	r1, #13
c0d02246:	d100      	bne.n	c0d0224a <io_event+0xbe>
c0d02248:	e093      	b.n	c0d02372 <io_event+0x1e6>
c0d0224a:	290e      	cmp	r1, #14
c0d0224c:	d000      	beq.n	c0d02250 <io_event+0xc4>
c0d0224e:	e0d0      	b.n	c0d023f2 <io_event+0x266>

  case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
    UX_DISPLAYED_EVENT({});
    break;
  case SEPROXYHAL_TAG_TICKER_EVENT:
    UX_TICKER_EVENT(G_io_seproxyhal_spi_buffer, 
c0d02250:	4ede      	ldr	r6, [pc, #888]	; (c0d025cc <io_event+0x440>)
c0d02252:	2400      	movs	r4, #0
c0d02254:	61f4      	str	r4, [r6, #28]
c0d02256:	2001      	movs	r0, #1
c0d02258:	7630      	strb	r0, [r6, #24]
c0d0225a:	4630      	mov	r0, r6
c0d0225c:	3018      	adds	r0, #24
c0d0225e:	f002 fdd5 	bl	c0d04e0c <os_ux>
c0d02262:	61f0      	str	r0, [r6, #28]
c0d02264:	f002 fb80 	bl	c0d04968 <ux_check_status_default>
c0d02268:	69f7      	ldr	r7, [r6, #28]
c0d0226a:	42af      	cmp	r7, r5
c0d0226c:	d000      	beq.n	c0d02270 <io_event+0xe4>
c0d0226e:	e104      	b.n	c0d0247a <io_event+0x2ee>
c0d02270:	f001 feb4 	bl	c0d03fdc <io_seproxyhal_init_ux>
c0d02274:	f001 feb8 	bl	c0d03fe8 <io_seproxyhal_init_button>
c0d02278:	60b4      	str	r4, [r6, #8]
c0d0227a:	6830      	ldr	r0, [r6, #0]
c0d0227c:	2800      	cmp	r0, #0
c0d0227e:	d100      	bne.n	c0d02282 <io_event+0xf6>
c0d02280:	e1d9      	b.n	c0d02636 <io_event+0x4aa>
c0d02282:	69f0      	ldr	r0, [r6, #28]
c0d02284:	49d2      	ldr	r1, [pc, #840]	; (c0d025d0 <io_event+0x444>)
c0d02286:	4288      	cmp	r0, r1
c0d02288:	d100      	bne.n	c0d0228c <io_event+0x100>
c0d0228a:	e1d4      	b.n	c0d02636 <io_event+0x4aa>
c0d0228c:	2800      	cmp	r0, #0
c0d0228e:	d100      	bne.n	c0d02292 <io_event+0x106>
c0d02290:	e1d1      	b.n	c0d02636 <io_event+0x4aa>
c0d02292:	2000      	movs	r0, #0
c0d02294:	6871      	ldr	r1, [r6, #4]
c0d02296:	4288      	cmp	r0, r1
c0d02298:	d300      	bcc.n	c0d0229c <io_event+0x110>
c0d0229a:	e1cc      	b.n	c0d02636 <io_event+0x4aa>
c0d0229c:	f002 fe10 	bl	c0d04ec0 <io_seproxyhal_spi_is_status_sent>
c0d022a0:	2800      	cmp	r0, #0
c0d022a2:	d000      	beq.n	c0d022a6 <io_event+0x11a>
c0d022a4:	e1c7      	b.n	c0d02636 <io_event+0x4aa>
c0d022a6:	68b0      	ldr	r0, [r6, #8]
c0d022a8:	68f1      	ldr	r1, [r6, #12]
c0d022aa:	2438      	movs	r4, #56	; 0x38
c0d022ac:	4360      	muls	r0, r4
c0d022ae:	6832      	ldr	r2, [r6, #0]
c0d022b0:	1810      	adds	r0, r2, r0
c0d022b2:	2900      	cmp	r1, #0
c0d022b4:	d002      	beq.n	c0d022bc <io_event+0x130>
c0d022b6:	4788      	blx	r1
c0d022b8:	2800      	cmp	r0, #0
c0d022ba:	d007      	beq.n	c0d022cc <io_event+0x140>
c0d022bc:	2801      	cmp	r0, #1
c0d022be:	d103      	bne.n	c0d022c8 <io_event+0x13c>
c0d022c0:	68b0      	ldr	r0, [r6, #8]
c0d022c2:	4344      	muls	r4, r0
c0d022c4:	6830      	ldr	r0, [r6, #0]
c0d022c6:	1900      	adds	r0, r0, r4
c0d022c8:	f001 f9ce 	bl	c0d03668 <io_seproxyhal_display>
c0d022cc:	68b0      	ldr	r0, [r6, #8]
c0d022ce:	1c40      	adds	r0, r0, #1
c0d022d0:	60b0      	str	r0, [r6, #8]
c0d022d2:	6831      	ldr	r1, [r6, #0]
c0d022d4:	2900      	cmp	r1, #0
c0d022d6:	d1dd      	bne.n	c0d02294 <io_event+0x108>
c0d022d8:	e1ad      	b.n	c0d02636 <io_event+0x4aa>
  case SEPROXYHAL_TAG_FINGER_EVENT:
    UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
    break;
  // power off if long push, else pass to the application callback if any
  case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT: // for Nano S
    UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
c0d022da:	4ebc      	ldr	r6, [pc, #752]	; (c0d025cc <io_event+0x440>)
c0d022dc:	2400      	movs	r4, #0
c0d022de:	61f4      	str	r4, [r6, #28]
c0d022e0:	2001      	movs	r0, #1
c0d022e2:	7630      	strb	r0, [r6, #24]
c0d022e4:	4630      	mov	r0, r6
c0d022e6:	3018      	adds	r0, #24
c0d022e8:	f002 fd90 	bl	c0d04e0c <os_ux>
c0d022ec:	61f0      	str	r0, [r6, #28]
c0d022ee:	f002 fb3b 	bl	c0d04968 <ux_check_status_default>
c0d022f2:	69f0      	ldr	r0, [r6, #28]
c0d022f4:	4db6      	ldr	r5, [pc, #728]	; (c0d025d0 <io_event+0x444>)
c0d022f6:	42a8      	cmp	r0, r5
c0d022f8:	d100      	bne.n	c0d022fc <io_event+0x170>
c0d022fa:	e19c      	b.n	c0d02636 <io_event+0x4aa>
c0d022fc:	2800      	cmp	r0, #0
c0d022fe:	d100      	bne.n	c0d02302 <io_event+0x176>
c0d02300:	e199      	b.n	c0d02636 <io_event+0x4aa>
c0d02302:	49b1      	ldr	r1, [pc, #708]	; (c0d025c8 <io_event+0x43c>)
c0d02304:	4288      	cmp	r0, r1
c0d02306:	d000      	beq.n	c0d0230a <io_event+0x17e>
c0d02308:	e164      	b.n	c0d025d4 <io_event+0x448>
c0d0230a:	f001 fe67 	bl	c0d03fdc <io_seproxyhal_init_ux>
c0d0230e:	f001 fe6b 	bl	c0d03fe8 <io_seproxyhal_init_button>
c0d02312:	60b4      	str	r4, [r6, #8]
c0d02314:	6830      	ldr	r0, [r6, #0]
c0d02316:	2800      	cmp	r0, #0
c0d02318:	d100      	bne.n	c0d0231c <io_event+0x190>
c0d0231a:	e18c      	b.n	c0d02636 <io_event+0x4aa>
c0d0231c:	69f0      	ldr	r0, [r6, #28]
c0d0231e:	42a8      	cmp	r0, r5
c0d02320:	d100      	bne.n	c0d02324 <io_event+0x198>
c0d02322:	e188      	b.n	c0d02636 <io_event+0x4aa>
c0d02324:	2800      	cmp	r0, #0
c0d02326:	d100      	bne.n	c0d0232a <io_event+0x19e>
c0d02328:	e185      	b.n	c0d02636 <io_event+0x4aa>
c0d0232a:	2000      	movs	r0, #0
c0d0232c:	6871      	ldr	r1, [r6, #4]
c0d0232e:	4288      	cmp	r0, r1
c0d02330:	d300      	bcc.n	c0d02334 <io_event+0x1a8>
c0d02332:	e180      	b.n	c0d02636 <io_event+0x4aa>
c0d02334:	f002 fdc4 	bl	c0d04ec0 <io_seproxyhal_spi_is_status_sent>
c0d02338:	2800      	cmp	r0, #0
c0d0233a:	d000      	beq.n	c0d0233e <io_event+0x1b2>
c0d0233c:	e17b      	b.n	c0d02636 <io_event+0x4aa>
c0d0233e:	68b0      	ldr	r0, [r6, #8]
c0d02340:	68f1      	ldr	r1, [r6, #12]
c0d02342:	2438      	movs	r4, #56	; 0x38
c0d02344:	4360      	muls	r0, r4
c0d02346:	6832      	ldr	r2, [r6, #0]
c0d02348:	1810      	adds	r0, r2, r0
c0d0234a:	2900      	cmp	r1, #0
c0d0234c:	d002      	beq.n	c0d02354 <io_event+0x1c8>
c0d0234e:	4788      	blx	r1
c0d02350:	2800      	cmp	r0, #0
c0d02352:	d007      	beq.n	c0d02364 <io_event+0x1d8>
c0d02354:	2801      	cmp	r0, #1
c0d02356:	d103      	bne.n	c0d02360 <io_event+0x1d4>
c0d02358:	68b0      	ldr	r0, [r6, #8]
c0d0235a:	4344      	muls	r4, r0
c0d0235c:	6830      	ldr	r0, [r6, #0]
c0d0235e:	1900      	adds	r0, r0, r4
c0d02360:	f001 f982 	bl	c0d03668 <io_seproxyhal_display>
c0d02364:	68b0      	ldr	r0, [r6, #8]
c0d02366:	1c40      	adds	r0, r0, #1
c0d02368:	60b0      	str	r0, [r6, #8]
c0d0236a:	6831      	ldr	r1, [r6, #0]
c0d0236c:	2900      	cmp	r1, #0
c0d0236e:	d1dd      	bne.n	c0d0232c <io_event+0x1a0>
c0d02370:	e161      	b.n	c0d02636 <io_event+0x4aa>
  default:
    UX_DEFAULT_EVENT();
    break;

  case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
    UX_DISPLAYED_EVENT({});
c0d02372:	4ef0      	ldr	r6, [pc, #960]	; (c0d02734 <io_event+0x5a8>)
c0d02374:	2400      	movs	r4, #0
c0d02376:	61f4      	str	r4, [r6, #28]
c0d02378:	2001      	movs	r0, #1
c0d0237a:	7630      	strb	r0, [r6, #24]
c0d0237c:	4630      	mov	r0, r6
c0d0237e:	3018      	adds	r0, #24
c0d02380:	f002 fd44 	bl	c0d04e0c <os_ux>
c0d02384:	61f0      	str	r0, [r6, #28]
c0d02386:	f002 faef 	bl	c0d04968 <ux_check_status_default>
c0d0238a:	69f0      	ldr	r0, [r6, #28]
c0d0238c:	4dea      	ldr	r5, [pc, #936]	; (c0d02738 <io_event+0x5ac>)
c0d0238e:	42a8      	cmp	r0, r5
c0d02390:	d100      	bne.n	c0d02394 <io_event+0x208>
c0d02392:	e150      	b.n	c0d02636 <io_event+0x4aa>
c0d02394:	49e6      	ldr	r1, [pc, #920]	; (c0d02730 <io_event+0x5a4>)
c0d02396:	4288      	cmp	r0, r1
c0d02398:	d100      	bne.n	c0d0239c <io_event+0x210>
c0d0239a:	e160      	b.n	c0d0265e <io_event+0x4d2>
c0d0239c:	2800      	cmp	r0, #0
c0d0239e:	d100      	bne.n	c0d023a2 <io_event+0x216>
c0d023a0:	e149      	b.n	c0d02636 <io_event+0x4aa>
c0d023a2:	6830      	ldr	r0, [r6, #0]
c0d023a4:	2800      	cmp	r0, #0
c0d023a6:	d100      	bne.n	c0d023aa <io_event+0x21e>
c0d023a8:	e13f      	b.n	c0d0262a <io_event+0x49e>
c0d023aa:	68b0      	ldr	r0, [r6, #8]
c0d023ac:	6871      	ldr	r1, [r6, #4]
c0d023ae:	4288      	cmp	r0, r1
c0d023b0:	d300      	bcc.n	c0d023b4 <io_event+0x228>
c0d023b2:	e13a      	b.n	c0d0262a <io_event+0x49e>
c0d023b4:	f002 fd84 	bl	c0d04ec0 <io_seproxyhal_spi_is_status_sent>
c0d023b8:	2800      	cmp	r0, #0
c0d023ba:	d000      	beq.n	c0d023be <io_event+0x232>
c0d023bc:	e135      	b.n	c0d0262a <io_event+0x49e>
c0d023be:	68b0      	ldr	r0, [r6, #8]
c0d023c0:	68f1      	ldr	r1, [r6, #12]
c0d023c2:	2438      	movs	r4, #56	; 0x38
c0d023c4:	4360      	muls	r0, r4
c0d023c6:	6832      	ldr	r2, [r6, #0]
c0d023c8:	1810      	adds	r0, r2, r0
c0d023ca:	2900      	cmp	r1, #0
c0d023cc:	d002      	beq.n	c0d023d4 <io_event+0x248>
c0d023ce:	4788      	blx	r1
c0d023d0:	2800      	cmp	r0, #0
c0d023d2:	d007      	beq.n	c0d023e4 <io_event+0x258>
c0d023d4:	2801      	cmp	r0, #1
c0d023d6:	d103      	bne.n	c0d023e0 <io_event+0x254>
c0d023d8:	68b0      	ldr	r0, [r6, #8]
c0d023da:	4344      	muls	r4, r0
c0d023dc:	6830      	ldr	r0, [r6, #0]
c0d023de:	1900      	adds	r0, r0, r4
c0d023e0:	f001 f942 	bl	c0d03668 <io_seproxyhal_display>
c0d023e4:	68b0      	ldr	r0, [r6, #8]
c0d023e6:	1c40      	adds	r0, r0, #1
c0d023e8:	60b0      	str	r0, [r6, #8]
c0d023ea:	6831      	ldr	r1, [r6, #0]
c0d023ec:	2900      	cmp	r1, #0
c0d023ee:	d1dd      	bne.n	c0d023ac <io_event+0x220>
c0d023f0:	e11b      	b.n	c0d0262a <io_event+0x49e>
    break;


  // other events are propagated to the UX just in case
  default:
    UX_DEFAULT_EVENT();
c0d023f2:	4ed0      	ldr	r6, [pc, #832]	; (c0d02734 <io_event+0x5a8>)
c0d023f4:	2400      	movs	r4, #0
c0d023f6:	61f4      	str	r4, [r6, #28]
c0d023f8:	2001      	movs	r0, #1
c0d023fa:	7630      	strb	r0, [r6, #24]
c0d023fc:	4630      	mov	r0, r6
c0d023fe:	3018      	adds	r0, #24
c0d02400:	f002 fd04 	bl	c0d04e0c <os_ux>
c0d02404:	61f0      	str	r0, [r6, #28]
c0d02406:	f002 faaf 	bl	c0d04968 <ux_check_status_default>
c0d0240a:	69f0      	ldr	r0, [r6, #28]
c0d0240c:	42a8      	cmp	r0, r5
c0d0240e:	d16f      	bne.n	c0d024f0 <io_event+0x364>
c0d02410:	f001 fde4 	bl	c0d03fdc <io_seproxyhal_init_ux>
c0d02414:	f001 fde8 	bl	c0d03fe8 <io_seproxyhal_init_button>
c0d02418:	60b4      	str	r4, [r6, #8]
c0d0241a:	6830      	ldr	r0, [r6, #0]
c0d0241c:	2800      	cmp	r0, #0
c0d0241e:	d100      	bne.n	c0d02422 <io_event+0x296>
c0d02420:	e109      	b.n	c0d02636 <io_event+0x4aa>
c0d02422:	69f0      	ldr	r0, [r6, #28]
c0d02424:	49c4      	ldr	r1, [pc, #784]	; (c0d02738 <io_event+0x5ac>)
c0d02426:	4288      	cmp	r0, r1
c0d02428:	d100      	bne.n	c0d0242c <io_event+0x2a0>
c0d0242a:	e104      	b.n	c0d02636 <io_event+0x4aa>
c0d0242c:	2800      	cmp	r0, #0
c0d0242e:	d100      	bne.n	c0d02432 <io_event+0x2a6>
c0d02430:	e101      	b.n	c0d02636 <io_event+0x4aa>
c0d02432:	2000      	movs	r0, #0
c0d02434:	6871      	ldr	r1, [r6, #4]
c0d02436:	4288      	cmp	r0, r1
c0d02438:	d300      	bcc.n	c0d0243c <io_event+0x2b0>
c0d0243a:	e0fc      	b.n	c0d02636 <io_event+0x4aa>
c0d0243c:	f002 fd40 	bl	c0d04ec0 <io_seproxyhal_spi_is_status_sent>
c0d02440:	2800      	cmp	r0, #0
c0d02442:	d000      	beq.n	c0d02446 <io_event+0x2ba>
c0d02444:	e0f7      	b.n	c0d02636 <io_event+0x4aa>
c0d02446:	68b0      	ldr	r0, [r6, #8]
c0d02448:	68f1      	ldr	r1, [r6, #12]
c0d0244a:	2438      	movs	r4, #56	; 0x38
c0d0244c:	4360      	muls	r0, r4
c0d0244e:	6832      	ldr	r2, [r6, #0]
c0d02450:	1810      	adds	r0, r2, r0
c0d02452:	2900      	cmp	r1, #0
c0d02454:	d002      	beq.n	c0d0245c <io_event+0x2d0>
c0d02456:	4788      	blx	r1
c0d02458:	2800      	cmp	r0, #0
c0d0245a:	d007      	beq.n	c0d0246c <io_event+0x2e0>
c0d0245c:	2801      	cmp	r0, #1
c0d0245e:	d103      	bne.n	c0d02468 <io_event+0x2dc>
c0d02460:	68b0      	ldr	r0, [r6, #8]
c0d02462:	4344      	muls	r4, r0
c0d02464:	6830      	ldr	r0, [r6, #0]
c0d02466:	1900      	adds	r0, r0, r4
c0d02468:	f001 f8fe 	bl	c0d03668 <io_seproxyhal_display>
c0d0246c:	68b0      	ldr	r0, [r6, #8]
c0d0246e:	1c40      	adds	r0, r0, #1
c0d02470:	60b0      	str	r0, [r6, #8]
c0d02472:	6831      	ldr	r1, [r6, #0]
c0d02474:	2900      	cmp	r1, #0
c0d02476:	d1dd      	bne.n	c0d02434 <io_event+0x2a8>
c0d02478:	e0dd      	b.n	c0d02636 <io_event+0x4aa>

  case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
    UX_DISPLAYED_EVENT({});
    break;
  case SEPROXYHAL_TAG_TICKER_EVENT:
    UX_TICKER_EVENT(G_io_seproxyhal_spi_buffer, 
c0d0247a:	6970      	ldr	r0, [r6, #20]
c0d0247c:	2800      	cmp	r0, #0
c0d0247e:	d008      	beq.n	c0d02492 <io_event+0x306>
c0d02480:	2164      	movs	r1, #100	; 0x64
c0d02482:	2864      	cmp	r0, #100	; 0x64
c0d02484:	4602      	mov	r2, r0
c0d02486:	d300      	bcc.n	c0d0248a <io_event+0x2fe>
c0d02488:	460a      	mov	r2, r1
c0d0248a:	1a80      	subs	r0, r0, r2
c0d0248c:	6170      	str	r0, [r6, #20]
c0d0248e:	d100      	bne.n	c0d02492 <io_event+0x306>
c0d02490:	e114      	b.n	c0d026bc <io_event+0x530>
c0d02492:	48a9      	ldr	r0, [pc, #676]	; (c0d02738 <io_event+0x5ac>)
c0d02494:	4287      	cmp	r7, r0
c0d02496:	d100      	bne.n	c0d0249a <io_event+0x30e>
c0d02498:	e0cd      	b.n	c0d02636 <io_event+0x4aa>
c0d0249a:	2f00      	cmp	r7, #0
c0d0249c:	d100      	bne.n	c0d024a0 <io_event+0x314>
c0d0249e:	e0ca      	b.n	c0d02636 <io_event+0x4aa>
c0d024a0:	6830      	ldr	r0, [r6, #0]
c0d024a2:	2800      	cmp	r0, #0
c0d024a4:	d100      	bne.n	c0d024a8 <io_event+0x31c>
c0d024a6:	e0c0      	b.n	c0d0262a <io_event+0x49e>
c0d024a8:	68b0      	ldr	r0, [r6, #8]
c0d024aa:	6871      	ldr	r1, [r6, #4]
c0d024ac:	4288      	cmp	r0, r1
c0d024ae:	d300      	bcc.n	c0d024b2 <io_event+0x326>
c0d024b0:	e0bb      	b.n	c0d0262a <io_event+0x49e>
c0d024b2:	f002 fd05 	bl	c0d04ec0 <io_seproxyhal_spi_is_status_sent>
c0d024b6:	2800      	cmp	r0, #0
c0d024b8:	d000      	beq.n	c0d024bc <io_event+0x330>
c0d024ba:	e0b6      	b.n	c0d0262a <io_event+0x49e>
c0d024bc:	68b0      	ldr	r0, [r6, #8]
c0d024be:	68f1      	ldr	r1, [r6, #12]
c0d024c0:	2438      	movs	r4, #56	; 0x38
c0d024c2:	4360      	muls	r0, r4
c0d024c4:	6832      	ldr	r2, [r6, #0]
c0d024c6:	1810      	adds	r0, r2, r0
c0d024c8:	2900      	cmp	r1, #0
c0d024ca:	d002      	beq.n	c0d024d2 <io_event+0x346>
c0d024cc:	4788      	blx	r1
c0d024ce:	2800      	cmp	r0, #0
c0d024d0:	d007      	beq.n	c0d024e2 <io_event+0x356>
c0d024d2:	2801      	cmp	r0, #1
c0d024d4:	d103      	bne.n	c0d024de <io_event+0x352>
c0d024d6:	68b0      	ldr	r0, [r6, #8]
c0d024d8:	4344      	muls	r4, r0
c0d024da:	6830      	ldr	r0, [r6, #0]
c0d024dc:	1900      	adds	r0, r0, r4
c0d024de:	f001 f8c3 	bl	c0d03668 <io_seproxyhal_display>
c0d024e2:	68b0      	ldr	r0, [r6, #8]
c0d024e4:	1c40      	adds	r0, r0, #1
c0d024e6:	60b0      	str	r0, [r6, #8]
c0d024e8:	6831      	ldr	r1, [r6, #0]
c0d024ea:	2900      	cmp	r1, #0
c0d024ec:	d1dd      	bne.n	c0d024aa <io_event+0x31e>
c0d024ee:	e09c      	b.n	c0d0262a <io_event+0x49e>
    break;


  // other events are propagated to the UX just in case
  default:
    UX_DEFAULT_EVENT();
c0d024f0:	6830      	ldr	r0, [r6, #0]
c0d024f2:	2800      	cmp	r0, #0
c0d024f4:	d100      	bne.n	c0d024f8 <io_event+0x36c>
c0d024f6:	e098      	b.n	c0d0262a <io_event+0x49e>
c0d024f8:	68b0      	ldr	r0, [r6, #8]
c0d024fa:	6871      	ldr	r1, [r6, #4]
c0d024fc:	4288      	cmp	r0, r1
c0d024fe:	d300      	bcc.n	c0d02502 <io_event+0x376>
c0d02500:	e093      	b.n	c0d0262a <io_event+0x49e>
c0d02502:	f002 fcdd 	bl	c0d04ec0 <io_seproxyhal_spi_is_status_sent>
c0d02506:	2800      	cmp	r0, #0
c0d02508:	d000      	beq.n	c0d0250c <io_event+0x380>
c0d0250a:	e08e      	b.n	c0d0262a <io_event+0x49e>
c0d0250c:	68b0      	ldr	r0, [r6, #8]
c0d0250e:	68f1      	ldr	r1, [r6, #12]
c0d02510:	2438      	movs	r4, #56	; 0x38
c0d02512:	4360      	muls	r0, r4
c0d02514:	6832      	ldr	r2, [r6, #0]
c0d02516:	1810      	adds	r0, r2, r0
c0d02518:	2900      	cmp	r1, #0
c0d0251a:	d002      	beq.n	c0d02522 <io_event+0x396>
c0d0251c:	4788      	blx	r1
c0d0251e:	2800      	cmp	r0, #0
c0d02520:	d007      	beq.n	c0d02532 <io_event+0x3a6>
c0d02522:	2801      	cmp	r0, #1
c0d02524:	d103      	bne.n	c0d0252e <io_event+0x3a2>
c0d02526:	68b0      	ldr	r0, [r6, #8]
c0d02528:	4344      	muls	r4, r0
c0d0252a:	6830      	ldr	r0, [r6, #0]
c0d0252c:	1900      	adds	r0, r0, r4
c0d0252e:	f001 f89b 	bl	c0d03668 <io_seproxyhal_display>
c0d02532:	68b0      	ldr	r0, [r6, #8]
c0d02534:	1c40      	adds	r0, r0, #1
c0d02536:	60b0      	str	r0, [r6, #8]
c0d02538:	6831      	ldr	r1, [r6, #0]
c0d0253a:	2900      	cmp	r1, #0
c0d0253c:	d1dd      	bne.n	c0d024fa <io_event+0x36e>
c0d0253e:	e074      	b.n	c0d0262a <io_event+0x49e>
c0d02540:	20001800 	.word	0x20001800
c0d02544:	b0105055 	.word	0xb0105055
c0d02548:	20001880 	.word	0x20001880
c0d0254c:	b0105044 	.word	0xb0105044
  // nothing done with the event, throw an error on the transport layer if
  // needed
  // can't have more than one tag in the reply, not supported yet.
  switch (G_io_seproxyhal_spi_buffer[0]) {
  case SEPROXYHAL_TAG_FINGER_EVENT:
    UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
c0d02550:	88b0      	ldrh	r0, [r6, #4]
c0d02552:	9003      	str	r0, [sp, #12]
c0d02554:	6830      	ldr	r0, [r6, #0]
c0d02556:	9002      	str	r0, [sp, #8]
c0d02558:	79fb      	ldrb	r3, [r7, #7]
c0d0255a:	79bc      	ldrb	r4, [r7, #6]
c0d0255c:	797a      	ldrb	r2, [r7, #5]
c0d0255e:	793d      	ldrb	r5, [r7, #4]
c0d02560:	78ff      	ldrb	r7, [r7, #3]
c0d02562:	68f1      	ldr	r1, [r6, #12]
c0d02564:	4668      	mov	r0, sp
c0d02566:	6007      	str	r7, [r0, #0]
c0d02568:	6041      	str	r1, [r0, #4]
c0d0256a:	0228      	lsls	r0, r5, #8
c0d0256c:	1880      	adds	r0, r0, r2
c0d0256e:	b282      	uxth	r2, r0
c0d02570:	0220      	lsls	r0, r4, #8
c0d02572:	18c0      	adds	r0, r0, r3
c0d02574:	b283      	uxth	r3, r0
c0d02576:	9802      	ldr	r0, [sp, #8]
c0d02578:	9903      	ldr	r1, [sp, #12]
c0d0257a:	f001 fdad 	bl	c0d040d8 <io_seproxyhal_touch_element_callback>
c0d0257e:	6830      	ldr	r0, [r6, #0]
c0d02580:	2800      	cmp	r0, #0
c0d02582:	d052      	beq.n	c0d0262a <io_event+0x49e>
c0d02584:	68b0      	ldr	r0, [r6, #8]
c0d02586:	6871      	ldr	r1, [r6, #4]
c0d02588:	4288      	cmp	r0, r1
c0d0258a:	d24e      	bcs.n	c0d0262a <io_event+0x49e>
c0d0258c:	f002 fc98 	bl	c0d04ec0 <io_seproxyhal_spi_is_status_sent>
c0d02590:	2800      	cmp	r0, #0
c0d02592:	d14a      	bne.n	c0d0262a <io_event+0x49e>
c0d02594:	68b0      	ldr	r0, [r6, #8]
c0d02596:	68f1      	ldr	r1, [r6, #12]
c0d02598:	2438      	movs	r4, #56	; 0x38
c0d0259a:	4360      	muls	r0, r4
c0d0259c:	6832      	ldr	r2, [r6, #0]
c0d0259e:	1810      	adds	r0, r2, r0
c0d025a0:	2900      	cmp	r1, #0
c0d025a2:	d002      	beq.n	c0d025aa <io_event+0x41e>
c0d025a4:	4788      	blx	r1
c0d025a6:	2800      	cmp	r0, #0
c0d025a8:	d007      	beq.n	c0d025ba <io_event+0x42e>
c0d025aa:	2801      	cmp	r0, #1
c0d025ac:	d103      	bne.n	c0d025b6 <io_event+0x42a>
c0d025ae:	68b0      	ldr	r0, [r6, #8]
c0d025b0:	4344      	muls	r4, r0
c0d025b2:	6830      	ldr	r0, [r6, #0]
c0d025b4:	1900      	adds	r0, r0, r4
c0d025b6:	f001 f857 	bl	c0d03668 <io_seproxyhal_display>
c0d025ba:	68b0      	ldr	r0, [r6, #8]
c0d025bc:	1c40      	adds	r0, r0, #1
c0d025be:	60b0      	str	r0, [r6, #8]
c0d025c0:	6831      	ldr	r1, [r6, #0]
c0d025c2:	2900      	cmp	r1, #0
c0d025c4:	d1df      	bne.n	c0d02586 <io_event+0x3fa>
c0d025c6:	e030      	b.n	c0d0262a <io_event+0x49e>
c0d025c8:	b0105055 	.word	0xb0105055
c0d025cc:	20001880 	.word	0x20001880
c0d025d0:	b0105044 	.word	0xb0105044
    break;
  // power off if long push, else pass to the application callback if any
  case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT: // for Nano S
    UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
c0d025d4:	6930      	ldr	r0, [r6, #16]
c0d025d6:	2800      	cmp	r0, #0
c0d025d8:	d003      	beq.n	c0d025e2 <io_event+0x456>
c0d025da:	78f9      	ldrb	r1, [r7, #3]
c0d025dc:	0849      	lsrs	r1, r1, #1
c0d025de:	f001 fe89 	bl	c0d042f4 <io_seproxyhal_button_push>
c0d025e2:	6830      	ldr	r0, [r6, #0]
c0d025e4:	2800      	cmp	r0, #0
c0d025e6:	d020      	beq.n	c0d0262a <io_event+0x49e>
c0d025e8:	68b0      	ldr	r0, [r6, #8]
c0d025ea:	6871      	ldr	r1, [r6, #4]
c0d025ec:	4288      	cmp	r0, r1
c0d025ee:	d21c      	bcs.n	c0d0262a <io_event+0x49e>
c0d025f0:	f002 fc66 	bl	c0d04ec0 <io_seproxyhal_spi_is_status_sent>
c0d025f4:	2800      	cmp	r0, #0
c0d025f6:	d118      	bne.n	c0d0262a <io_event+0x49e>
c0d025f8:	68b0      	ldr	r0, [r6, #8]
c0d025fa:	68f1      	ldr	r1, [r6, #12]
c0d025fc:	2438      	movs	r4, #56	; 0x38
c0d025fe:	4360      	muls	r0, r4
c0d02600:	6832      	ldr	r2, [r6, #0]
c0d02602:	1810      	adds	r0, r2, r0
c0d02604:	2900      	cmp	r1, #0
c0d02606:	d002      	beq.n	c0d0260e <io_event+0x482>
c0d02608:	4788      	blx	r1
c0d0260a:	2800      	cmp	r0, #0
c0d0260c:	d007      	beq.n	c0d0261e <io_event+0x492>
c0d0260e:	2801      	cmp	r0, #1
c0d02610:	d103      	bne.n	c0d0261a <io_event+0x48e>
c0d02612:	68b0      	ldr	r0, [r6, #8]
c0d02614:	4344      	muls	r4, r0
c0d02616:	6830      	ldr	r0, [r6, #0]
c0d02618:	1900      	adds	r0, r0, r4
c0d0261a:	f001 f825 	bl	c0d03668 <io_seproxyhal_display>
c0d0261e:	68b0      	ldr	r0, [r6, #8]
c0d02620:	1c40      	adds	r0, r0, #1
c0d02622:	60b0      	str	r0, [r6, #8]
c0d02624:	6831      	ldr	r1, [r6, #0]
c0d02626:	2900      	cmp	r1, #0
c0d02628:	d1df      	bne.n	c0d025ea <io_event+0x45e>
c0d0262a:	6870      	ldr	r0, [r6, #4]
c0d0262c:	68b1      	ldr	r1, [r6, #8]
c0d0262e:	4281      	cmp	r1, r0
c0d02630:	d301      	bcc.n	c0d02636 <io_event+0x4aa>
c0d02632:	f002 fc45 	bl	c0d04ec0 <io_seproxyhal_spi_is_status_sent>
    });
    break;
  }

  // close the event if not done previously (by a display or whatever)
  if (!io_seproxyhal_spi_is_status_sent()) {
c0d02636:	f002 fc43 	bl	c0d04ec0 <io_seproxyhal_spi_is_status_sent>
c0d0263a:	2800      	cmp	r0, #0
c0d0263c:	d101      	bne.n	c0d02642 <io_event+0x4b6>
    io_seproxyhal_general_status();
c0d0263e:	f001 fb83 	bl	c0d03d48 <io_seproxyhal_general_status>
c0d02642:	4c3b      	ldr	r4, [pc, #236]	; (c0d02730 <io_event+0x5a4>)
  }

  s_after =  os_global_pin_is_validated();
  
  if (s_before!=s_after) {
    if (s_after == PIN_VERIFIED) {
c0d02644:	3c44      	subs	r4, #68	; 0x44
  // close the event if not done previously (by a display or whatever)
  if (!io_seproxyhal_spi_is_status_sent()) {
    io_seproxyhal_general_status();
  }

  s_after =  os_global_pin_is_validated();
c0d02646:	f002 fbb5 	bl	c0d04db4 <os_global_pin_is_validated>
  
  if (s_before!=s_after) {
c0d0264a:	9904      	ldr	r1, [sp, #16]
c0d0264c:	4281      	cmp	r1, r0
c0d0264e:	d003      	beq.n	c0d02658 <io_event+0x4cc>
c0d02650:	42a0      	cmp	r0, r4
c0d02652:	d101      	bne.n	c0d02658 <io_event+0x4cc>
    if (s_after == PIN_VERIFIED) {
      monero_init_private_key();
c0d02654:	f7fe fe6e 	bl	c0d01334 <monero_init_private_key>
c0d02658:	2001      	movs	r0, #1
      //monero_wipe_private_key();
    }
  }
  
  // command has been processed, DO NOT reset the current APDU transport
  return 1;
c0d0265a:	b005      	add	sp, #20
c0d0265c:	bdf0      	pop	{r4, r5, r6, r7, pc}
  default:
    UX_DEFAULT_EVENT();
    break;

  case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
    UX_DISPLAYED_EVENT({});
c0d0265e:	f001 fcbd 	bl	c0d03fdc <io_seproxyhal_init_ux>
c0d02662:	f001 fcc1 	bl	c0d03fe8 <io_seproxyhal_init_button>
c0d02666:	60b4      	str	r4, [r6, #8]
c0d02668:	6830      	ldr	r0, [r6, #0]
c0d0266a:	2800      	cmp	r0, #0
c0d0266c:	d0e3      	beq.n	c0d02636 <io_event+0x4aa>
c0d0266e:	69f0      	ldr	r0, [r6, #28]
c0d02670:	42a8      	cmp	r0, r5
c0d02672:	d0e0      	beq.n	c0d02636 <io_event+0x4aa>
c0d02674:	2800      	cmp	r0, #0
c0d02676:	d0de      	beq.n	c0d02636 <io_event+0x4aa>
c0d02678:	2000      	movs	r0, #0
c0d0267a:	6871      	ldr	r1, [r6, #4]
c0d0267c:	4288      	cmp	r0, r1
c0d0267e:	d2da      	bcs.n	c0d02636 <io_event+0x4aa>
c0d02680:	f002 fc1e 	bl	c0d04ec0 <io_seproxyhal_spi_is_status_sent>
c0d02684:	2800      	cmp	r0, #0
c0d02686:	d1d6      	bne.n	c0d02636 <io_event+0x4aa>
c0d02688:	68b0      	ldr	r0, [r6, #8]
c0d0268a:	68f1      	ldr	r1, [r6, #12]
c0d0268c:	2438      	movs	r4, #56	; 0x38
c0d0268e:	4360      	muls	r0, r4
c0d02690:	6832      	ldr	r2, [r6, #0]
c0d02692:	1810      	adds	r0, r2, r0
c0d02694:	2900      	cmp	r1, #0
c0d02696:	d002      	beq.n	c0d0269e <io_event+0x512>
c0d02698:	4788      	blx	r1
c0d0269a:	2800      	cmp	r0, #0
c0d0269c:	d007      	beq.n	c0d026ae <io_event+0x522>
c0d0269e:	2801      	cmp	r0, #1
c0d026a0:	d103      	bne.n	c0d026aa <io_event+0x51e>
c0d026a2:	68b0      	ldr	r0, [r6, #8]
c0d026a4:	4344      	muls	r4, r0
c0d026a6:	6830      	ldr	r0, [r6, #0]
c0d026a8:	1900      	adds	r0, r0, r4
c0d026aa:	f000 ffdd 	bl	c0d03668 <io_seproxyhal_display>
c0d026ae:	68b0      	ldr	r0, [r6, #8]
c0d026b0:	1c40      	adds	r0, r0, #1
c0d026b2:	60b0      	str	r0, [r6, #8]
c0d026b4:	6831      	ldr	r1, [r6, #0]
c0d026b6:	2900      	cmp	r1, #0
c0d026b8:	d1df      	bne.n	c0d0267a <io_event+0x4ee>
c0d026ba:	e7bc      	b.n	c0d02636 <io_event+0x4aa>
c0d026bc:	4d1e      	ldr	r5, [pc, #120]	; (c0d02738 <io_event+0x5ac>)
    break;
  case SEPROXYHAL_TAG_TICKER_EVENT:
    UX_TICKER_EVENT(G_io_seproxyhal_spi_buffer, 
c0d026be:	42af      	cmp	r7, r5
c0d026c0:	d0b9      	beq.n	c0d02636 <io_event+0x4aa>
c0d026c2:	2f00      	cmp	r7, #0
c0d026c4:	d0b7      	beq.n	c0d02636 <io_event+0x4aa>
c0d026c6:	f001 fc89 	bl	c0d03fdc <io_seproxyhal_init_ux>
c0d026ca:	f001 fc8d 	bl	c0d03fe8 <io_seproxyhal_init_button>
c0d026ce:	60b4      	str	r4, [r6, #8]
c0d026d0:	6830      	ldr	r0, [r6, #0]
c0d026d2:	2800      	cmp	r0, #0
c0d026d4:	d100      	bne.n	c0d026d8 <io_event+0x54c>
c0d026d6:	e6dc      	b.n	c0d02492 <io_event+0x306>
c0d026d8:	69f0      	ldr	r0, [r6, #28]
c0d026da:	42a8      	cmp	r0, r5
c0d026dc:	d100      	bne.n	c0d026e0 <io_event+0x554>
c0d026de:	e6d8      	b.n	c0d02492 <io_event+0x306>
c0d026e0:	2800      	cmp	r0, #0
c0d026e2:	d100      	bne.n	c0d026e6 <io_event+0x55a>
c0d026e4:	e6d5      	b.n	c0d02492 <io_event+0x306>
c0d026e6:	2000      	movs	r0, #0
c0d026e8:	6871      	ldr	r1, [r6, #4]
c0d026ea:	4288      	cmp	r0, r1
c0d026ec:	d300      	bcc.n	c0d026f0 <io_event+0x564>
c0d026ee:	e6d0      	b.n	c0d02492 <io_event+0x306>
c0d026f0:	f002 fbe6 	bl	c0d04ec0 <io_seproxyhal_spi_is_status_sent>
c0d026f4:	2800      	cmp	r0, #0
c0d026f6:	d000      	beq.n	c0d026fa <io_event+0x56e>
c0d026f8:	e6cb      	b.n	c0d02492 <io_event+0x306>
c0d026fa:	68b0      	ldr	r0, [r6, #8]
c0d026fc:	68f1      	ldr	r1, [r6, #12]
c0d026fe:	2438      	movs	r4, #56	; 0x38
c0d02700:	4360      	muls	r0, r4
c0d02702:	6832      	ldr	r2, [r6, #0]
c0d02704:	1810      	adds	r0, r2, r0
c0d02706:	2900      	cmp	r1, #0
c0d02708:	d002      	beq.n	c0d02710 <io_event+0x584>
c0d0270a:	4788      	blx	r1
c0d0270c:	2800      	cmp	r0, #0
c0d0270e:	d007      	beq.n	c0d02720 <io_event+0x594>
c0d02710:	2801      	cmp	r0, #1
c0d02712:	d103      	bne.n	c0d0271c <io_event+0x590>
c0d02714:	68b0      	ldr	r0, [r6, #8]
c0d02716:	4344      	muls	r4, r0
c0d02718:	6830      	ldr	r0, [r6, #0]
c0d0271a:	1900      	adds	r0, r0, r4
c0d0271c:	f000 ffa4 	bl	c0d03668 <io_seproxyhal_display>
c0d02720:	68b0      	ldr	r0, [r6, #8]
c0d02722:	1c40      	adds	r0, r0, #1
c0d02724:	60b0      	str	r0, [r6, #8]
c0d02726:	6831      	ldr	r1, [r6, #0]
c0d02728:	2900      	cmp	r1, #0
c0d0272a:	d1dd      	bne.n	c0d026e8 <io_event+0x55c>
c0d0272c:	e6b1      	b.n	c0d02492 <io_event+0x306>
c0d0272e:	46c0      	nop			; (mov r8, r8)
c0d02730:	b0105055 	.word	0xb0105055
c0d02734:	20001880 	.word	0x20001880
c0d02738:	b0105044 	.word	0xb0105044

c0d0273c <io_exchange_al>:
  
  // command has been processed, DO NOT reset the current APDU transport
  return 1;
}

unsigned short io_exchange_al(unsigned char channel, unsigned short tx_len) {
c0d0273c:	b5b0      	push	{r4, r5, r7, lr}
c0d0273e:	4605      	mov	r5, r0
c0d02740:	2007      	movs	r0, #7
  switch (channel & ~(IO_FLAGS)) {
c0d02742:	4028      	ands	r0, r5
c0d02744:	2400      	movs	r4, #0
c0d02746:	2801      	cmp	r0, #1
c0d02748:	d014      	beq.n	c0d02774 <io_exchange_al+0x38>
c0d0274a:	2802      	cmp	r0, #2
c0d0274c:	d114      	bne.n	c0d02778 <io_exchange_al+0x3c>
  case CHANNEL_KEYBOARD:
    break;

    // multiplexed io exchange over a SPI channel and TLV encapsulated protocol
  case CHANNEL_SPI:
    if (tx_len) {
c0d0274e:	2900      	cmp	r1, #0
c0d02750:	d009      	beq.n	c0d02766 <io_exchange_al+0x2a>
      io_seproxyhal_spi_send(G_io_apdu_buffer, tx_len);
c0d02752:	480b      	ldr	r0, [pc, #44]	; (c0d02780 <io_exchange_al+0x44>)
c0d02754:	f002 fb9e 	bl	c0d04e94 <io_seproxyhal_spi_send>

      if (channel & IO_RESET_AFTER_REPLIED) {
c0d02758:	b268      	sxtb	r0, r5
c0d0275a:	2800      	cmp	r0, #0
c0d0275c:	da0a      	bge.n	c0d02774 <io_exchange_al+0x38>
        reset();
c0d0275e:	f002 f933 	bl	c0d049c8 <reset>
c0d02762:	2400      	movs	r4, #0
c0d02764:	e006      	b.n	c0d02774 <io_exchange_al+0x38>
c0d02766:	21ff      	movs	r1, #255	; 0xff
c0d02768:	3152      	adds	r1, #82	; 0x52
      }
      return 0; // nothing received from the master so far (it's a tx
      // transaction)
    } else {
      return io_seproxyhal_spi_recv(G_io_apdu_buffer,
c0d0276a:	4805      	ldr	r0, [pc, #20]	; (c0d02780 <io_exchange_al+0x44>)
c0d0276c:	2200      	movs	r2, #0
c0d0276e:	f002 fbbd 	bl	c0d04eec <io_seproxyhal_spi_recv>
c0d02772:	4604      	mov	r4, r0
  default:
    THROW(INVALID_PARAMETER);
    return 0;
  }
  return 0;
}
c0d02774:	4620      	mov	r0, r4
c0d02776:	bdb0      	pop	{r4, r5, r7, pc}
c0d02778:	2002      	movs	r0, #2
      return io_seproxyhal_spi_recv(G_io_apdu_buffer,
                                    sizeof(G_io_apdu_buffer), 0);
    }

  default:
    THROW(INVALID_PARAMETER);
c0d0277a:	f001 fad9 	bl	c0d03d30 <os_longjmp>
c0d0277e:	46c0      	nop			; (mov r8, r8)
c0d02780:	2000216c 	.word	0x2000216c

c0d02784 <app_exit>:
    return 0;
  }
  return 0;
}

void app_exit(void) {
c0d02784:	b510      	push	{r4, lr}
c0d02786:	b08c      	sub	sp, #48	; 0x30
c0d02788:	ac01      	add	r4, sp, #4
  BEGIN_TRY_L(exit) {
    TRY_L(exit) {
c0d0278a:	4620      	mov	r0, r4
c0d0278c:	f004 f90e 	bl	c0d069ac <setjmp>
c0d02790:	8520      	strh	r0, [r4, #40]	; 0x28
c0d02792:	0400      	lsls	r0, r0, #16
c0d02794:	d106      	bne.n	c0d027a4 <app_exit+0x20>
c0d02796:	a801      	add	r0, sp, #4
c0d02798:	f001 f913 	bl	c0d039c2 <try_context_set>
c0d0279c:	2000      	movs	r0, #0
c0d0279e:	43c0      	mvns	r0, r0
      os_sched_exit(-1);
c0d027a0:	f002 fb1e 	bl	c0d04de0 <os_sched_exit>
    }
    FINALLY_L(exit) {
c0d027a4:	f001 fac8 	bl	c0d03d38 <try_context_get>
c0d027a8:	a901      	add	r1, sp, #4
c0d027aa:	4288      	cmp	r0, r1
c0d027ac:	d103      	bne.n	c0d027b6 <app_exit+0x32>
c0d027ae:	f001 fac5 	bl	c0d03d3c <try_context_get_previous>
c0d027b2:	f001 f906 	bl	c0d039c2 <try_context_set>
c0d027b6:	a801      	add	r0, sp, #4
    }
  }
  END_TRY_L(exit);
c0d027b8:	8d00      	ldrh	r0, [r0, #40]	; 0x28
c0d027ba:	2800      	cmp	r0, #0
c0d027bc:	d101      	bne.n	c0d027c2 <app_exit+0x3e>
}
c0d027be:	b00c      	add	sp, #48	; 0x30
c0d027c0:	bd10      	pop	{r4, pc}
      os_sched_exit(-1);
    }
    FINALLY_L(exit) {
    }
  }
  END_TRY_L(exit);
c0d027c2:	f001 fab5 	bl	c0d03d30 <os_longjmp>
	...

c0d027c8 <monero_apdu_mlsag_prepare>:
#include "monero_vars.h"

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_mlsag_prepare() {
c0d027c8:	b570      	push	{r4, r5, r6, lr}
c0d027ca:	b0a0      	sub	sp, #128	; 0x80
    unsigned char xin[32];
    unsigned char alpha[32];
    unsigned char mul[32];


    if (G_monero_vstate.io_length>1) {
c0d027cc:	4c31      	ldr	r4, [pc, #196]	; (c0d02894 <monero_apdu_mlsag_prepare+0xcc>)
c0d027ce:	8920      	ldrh	r0, [r4, #8]
c0d027d0:	2802      	cmp	r0, #2
c0d027d2:	d30e      	bcc.n	c0d027f2 <monero_apdu_mlsag_prepare+0x2a>
c0d027d4:	a818      	add	r0, sp, #96	; 0x60
c0d027d6:	2120      	movs	r1, #32
        monero_io_fetch(Hi,32);
c0d027d8:	f7fe ff16 	bl	c0d01608 <monero_io_fetch>
c0d027dc:	204f      	movs	r0, #79	; 0x4f
c0d027de:	0080      	lsls	r0, r0, #2
        if(G_monero_vstate.options &0x40) {
c0d027e0:	5c20      	ldrb	r0, [r4, r0]
c0d027e2:	0640      	lsls	r0, r0, #25
c0d027e4:	d41e      	bmi.n	c0d02824 <monero_apdu_mlsag_prepare+0x5c>
c0d027e6:	a810      	add	r0, sp, #64	; 0x40
c0d027e8:	2420      	movs	r4, #32
            monero_io_fetch(xin,32);
        } else {
           monero_io_fetch_decrypt(xin,32);
c0d027ea:	4621      	mov	r1, r4
c0d027ec:	f7fe ff28 	bl	c0d01640 <monero_io_fetch_decrypt>
c0d027f0:	e01d      	b.n	c0d0282e <monero_apdu_mlsag_prepare+0x66>
c0d027f2:	2001      	movs	r0, #1
        options = 1;
    }  else {
        options = 0;
    }

    monero_io_discard(1);
c0d027f4:	f7fe fe72 	bl	c0d014dc <monero_io_discard>
c0d027f8:	ad08      	add	r5, sp, #32
c0d027fa:	2420      	movs	r4, #32

    //ai
    monero_rng(alpha, 32);
c0d027fc:	4628      	mov	r0, r5
c0d027fe:	4621      	mov	r1, r4
c0d02800:	f7fd fd84 	bl	c0d0030c <monero_rng>
    monero_reduce(alpha, alpha);
c0d02804:	4628      	mov	r0, r5
c0d02806:	4629      	mov	r1, r5
c0d02808:	f7fd fdbe 	bl	c0d00388 <monero_reduce>
    monero_io_insert_encrypt(alpha, 32);
c0d0280c:	4628      	mov	r0, r5
c0d0280e:	4621      	mov	r1, r4
c0d02810:	f7fe fea4 	bl	c0d0155c <monero_io_insert_encrypt>
c0d02814:	466e      	mov	r6, sp

    //ai.G
    monero_ecmul_G(mul, alpha);
c0d02816:	4630      	mov	r0, r6
c0d02818:	4629      	mov	r1, r5
c0d0281a:	f7fe f80f 	bl	c0d0083c <monero_ecmul_G>
    monero_io_insert(mul,32);
c0d0281e:	4630      	mov	r0, r6
c0d02820:	4621      	mov	r1, r4
c0d02822:	e030      	b.n	c0d02886 <monero_apdu_mlsag_prepare+0xbe>
c0d02824:	a810      	add	r0, sp, #64	; 0x40
c0d02826:	2420      	movs	r4, #32


    if (G_monero_vstate.io_length>1) {
        monero_io_fetch(Hi,32);
        if(G_monero_vstate.options &0x40) {
            monero_io_fetch(xin,32);
c0d02828:	4621      	mov	r1, r4
c0d0282a:	f7fe feed 	bl	c0d01608 <monero_io_fetch>
c0d0282e:	2001      	movs	r0, #1
        options = 1;
    }  else {
        options = 0;
    }

    monero_io_discard(1);
c0d02830:	f7fe fe54 	bl	c0d014dc <monero_io_discard>
c0d02834:	ad08      	add	r5, sp, #32

    //ai
    monero_rng(alpha, 32);
c0d02836:	4628      	mov	r0, r5
c0d02838:	4621      	mov	r1, r4
c0d0283a:	f7fd fd67 	bl	c0d0030c <monero_rng>
    monero_reduce(alpha, alpha);
c0d0283e:	4628      	mov	r0, r5
c0d02840:	4629      	mov	r1, r5
c0d02842:	f7fd fda1 	bl	c0d00388 <monero_reduce>
    monero_io_insert_encrypt(alpha, 32);
c0d02846:	4628      	mov	r0, r5
c0d02848:	4621      	mov	r1, r4
c0d0284a:	f7fe fe87 	bl	c0d0155c <monero_io_insert_encrypt>
c0d0284e:	466e      	mov	r6, sp

    //ai.G
    monero_ecmul_G(mul, alpha);
c0d02850:	4630      	mov	r0, r6
c0d02852:	4629      	mov	r1, r5
c0d02854:	f7fd fff2 	bl	c0d0083c <monero_ecmul_G>
    monero_io_insert(mul,32);
c0d02858:	4630      	mov	r0, r6
c0d0285a:	4621      	mov	r1, r4
c0d0285c:	f7fe fe6a 	bl	c0d01534 <monero_io_insert>
c0d02860:	466c      	mov	r4, sp
c0d02862:	ad18      	add	r5, sp, #96	; 0x60
c0d02864:	aa08      	add	r2, sp, #32

    if (options) {
        //ai.Hi
        monero_ecmul_k(mul, Hi, alpha);
c0d02866:	4620      	mov	r0, r4
c0d02868:	4629      	mov	r1, r5
c0d0286a:	f7fe f8fe 	bl	c0d00a6a <monero_ecmul_k>
c0d0286e:	2620      	movs	r6, #32
        monero_io_insert(mul,32);
c0d02870:	4620      	mov	r0, r4
c0d02872:	4631      	mov	r1, r6
c0d02874:	f7fe fe5e 	bl	c0d01534 <monero_io_insert>
c0d02878:	aa10      	add	r2, sp, #64	; 0x40
        //IIi = xin.Hi
        monero_ecmul_k(mul, Hi, xin);
c0d0287a:	4620      	mov	r0, r4
c0d0287c:	4629      	mov	r1, r5
c0d0287e:	f7fe f8f4 	bl	c0d00a6a <monero_ecmul_k>
        monero_io_insert(mul,32);
c0d02882:	4620      	mov	r0, r4
c0d02884:	4631      	mov	r1, r6
c0d02886:	f7fe fe55 	bl	c0d01534 <monero_io_insert>
c0d0288a:	2009      	movs	r0, #9
c0d0288c:	0300      	lsls	r0, r0, #12
    }

    return SW_OK;
c0d0288e:	b020      	add	sp, #128	; 0x80
c0d02890:	bd70      	pop	{r4, r5, r6, pc}
c0d02892:	46c0      	nop			; (mov r8, r8)
c0d02894:	20001930 	.word	0x20001930

c0d02898 <monero_apdu_mlsag_hash>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_mlsag_hash() {
c0d02898:	b570      	push	{r4, r5, r6, lr}
c0d0289a:	b090      	sub	sp, #64	; 0x40
    unsigned char msg[32];
    unsigned char c[32];
    if (G_monero_vstate.io_p2 == 1) {
c0d0289c:	4e1e      	ldr	r6, [pc, #120]	; (c0d02918 <monero_apdu_mlsag_hash+0x80>)
c0d0289e:	7970      	ldrb	r0, [r6, #5]
c0d028a0:	2801      	cmp	r0, #1
c0d028a2:	d10c      	bne.n	c0d028be <monero_apdu_mlsag_hash+0x26>
c0d028a4:	207b      	movs	r0, #123	; 0x7b
c0d028a6:	00c0      	lsls	r0, r0, #3
        monero_keccak_init_H();
c0d028a8:	1830      	adds	r0, r6, r0
c0d028aa:	f7fd fcf1 	bl	c0d00290 <monero_hash_init_keccak>
c0d028ae:	200b      	movs	r0, #11
c0d028b0:	01c0      	lsls	r0, r0, #7
        os_memmove(msg, G_monero_vstate.H, 32);
c0d028b2:	1831      	adds	r1, r6, r0
c0d028b4:	a808      	add	r0, sp, #32
c0d028b6:	2220      	movs	r2, #32
c0d028b8:	f001 f96b 	bl	c0d03b92 <os_memmove>
c0d028bc:	e003      	b.n	c0d028c6 <monero_apdu_mlsag_hash+0x2e>
c0d028be:	a808      	add	r0, sp, #32
c0d028c0:	2120      	movs	r1, #32
    } else {
        monero_io_fetch(msg, 32);
c0d028c2:	f7fe fea1 	bl	c0d01608 <monero_io_fetch>
c0d028c6:	2001      	movs	r0, #1
    }
    monero_io_discard(1);
c0d028c8:	f7fe fe08 	bl	c0d014dc <monero_io_discard>
c0d028cc:	207b      	movs	r0, #123	; 0x7b
c0d028ce:	00c0      	lsls	r0, r0, #3

    monero_keccak_update_H(msg, 32);
c0d028d0:	1835      	adds	r5, r6, r0
c0d028d2:	a908      	add	r1, sp, #32
c0d028d4:	2220      	movs	r2, #32
c0d028d6:	4628      	mov	r0, r5
c0d028d8:	f7fd fce0 	bl	c0d0029c <monero_hash_update>
c0d028dc:	204f      	movs	r0, #79	; 0x4f
c0d028de:	0080      	lsls	r0, r0, #2
    if ((G_monero_vstate.options&0x80) == 0 ) {
c0d028e0:	5c30      	ldrb	r0, [r6, r0]
c0d028e2:	0600      	lsls	r0, r0, #24
c0d028e4:	d414      	bmi.n	c0d02910 <monero_apdu_mlsag_hash+0x78>
c0d028e6:	466c      	mov	r4, sp
        monero_keccak_final_H(c);
c0d028e8:	4628      	mov	r0, r5
c0d028ea:	4621      	mov	r1, r4
c0d028ec:	f7fd fce2 	bl	c0d002b4 <monero_hash_final>
        monero_reduce(c,c);
c0d028f0:	4620      	mov	r0, r4
c0d028f2:	4621      	mov	r1, r4
c0d028f4:	f7fd fd48 	bl	c0d00388 <monero_reduce>
c0d028f8:	2520      	movs	r5, #32
        monero_io_insert(c,32);
c0d028fa:	4620      	mov	r0, r4
c0d028fc:	4629      	mov	r1, r5
c0d028fe:	f7fe fe19 	bl	c0d01534 <monero_io_insert>
c0d02902:	202d      	movs	r0, #45	; 0x2d
c0d02904:	0140      	lsls	r0, r0, #5
        os_memmove(G_monero_vstate.c, c, 32);
c0d02906:	1830      	adds	r0, r6, r0
c0d02908:	4621      	mov	r1, r4
c0d0290a:	462a      	mov	r2, r5
c0d0290c:	f001 f941 	bl	c0d03b92 <os_memmove>
c0d02910:	2009      	movs	r0, #9
c0d02912:	0300      	lsls	r0, r0, #12
    }
    return SW_OK;
c0d02914:	b010      	add	sp, #64	; 0x40
c0d02916:	bd70      	pop	{r4, r5, r6, pc}
c0d02918:	20001930 	.word	0x20001930

c0d0291c <monero_apdu_mlsag_sign>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_mlsag_sign() {
c0d0291c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0291e:	b0a1      	sub	sp, #132	; 0x84
c0d02920:	2005      	movs	r0, #5
c0d02922:	0187      	lsls	r7, r0, #6
    unsigned char xin[32];
    unsigned char alpha[32];
    unsigned char ss[32];
    unsigned char ss2[32];

    if (G_monero_vstate.sig_mode == TRANSACTION_CREATE_FAKE) {
c0d02924:	4d23      	ldr	r5, [pc, #140]	; (c0d029b4 <monero_apdu_mlsag_sign+0x98>)
c0d02926:	59e8      	ldr	r0, [r5, r7]
c0d02928:	2801      	cmp	r0, #1
c0d0292a:	d00b      	beq.n	c0d02944 <monero_apdu_mlsag_sign+0x28>
c0d0292c:	2802      	cmp	r0, #2
c0d0292e:	d13d      	bne.n	c0d029ac <monero_apdu_mlsag_sign+0x90>
c0d02930:	a819      	add	r0, sp, #100	; 0x64
c0d02932:	2420      	movs	r4, #32
        monero_io_fetch(xin,32);
c0d02934:	4621      	mov	r1, r4
c0d02936:	f7fe fe67 	bl	c0d01608 <monero_io_fetch>
c0d0293a:	a811      	add	r0, sp, #68	; 0x44
        monero_io_fetch(alpha,32);
c0d0293c:	4621      	mov	r1, r4
c0d0293e:	f7fe fe63 	bl	c0d01608 <monero_io_fetch>
c0d02942:	e008      	b.n	c0d02956 <monero_apdu_mlsag_sign+0x3a>
c0d02944:	a819      	add	r0, sp, #100	; 0x64
c0d02946:	2420      	movs	r4, #32
    } else if (G_monero_vstate.sig_mode == TRANSACTION_CREATE_REAL) {
        monero_io_fetch_decrypt(xin,32);
c0d02948:	4621      	mov	r1, r4
c0d0294a:	f7fe fe79 	bl	c0d01640 <monero_io_fetch_decrypt>
c0d0294e:	a811      	add	r0, sp, #68	; 0x44
        monero_io_fetch_decrypt(alpha,32);
c0d02950:	4621      	mov	r1, r4
c0d02952:	f7fe fe75 	bl	c0d01640 <monero_io_fetch_decrypt>
c0d02956:	2001      	movs	r0, #1
    } else {
        THROW(SW_WRONG_DATA);
    }
    monero_io_discard(1);
c0d02958:	f7fe fdc0 	bl	c0d014dc <monero_io_discard>
c0d0295c:	202d      	movs	r0, #45	; 0x2d
c0d0295e:	0140      	lsls	r0, r0, #5


    monero_reduce(ss, G_monero_vstate.c);
c0d02960:	1829      	adds	r1, r5, r0
c0d02962:	ac09      	add	r4, sp, #36	; 0x24
c0d02964:	4620      	mov	r0, r4
c0d02966:	f7fd fd0f 	bl	c0d00388 <monero_reduce>
c0d0296a:	ad19      	add	r5, sp, #100	; 0x64
    monero_reduce(xin,xin);
c0d0296c:	4628      	mov	r0, r5
c0d0296e:	4629      	mov	r1, r5
c0d02970:	f7fd fd0a 	bl	c0d00388 <monero_reduce>
    monero_multm(ss, ss, xin);
c0d02974:	4620      	mov	r0, r4
c0d02976:	4621      	mov	r1, r4
c0d02978:	462a      	mov	r2, r5
c0d0297a:	f7fe fa3d 	bl	c0d00df8 <monero_multm>
c0d0297e:	ad11      	add	r5, sp, #68	; 0x44

    monero_reduce(alpha, alpha);
c0d02980:	4628      	mov	r0, r5
c0d02982:	4629      	mov	r1, r5
c0d02984:	f7fd fd00 	bl	c0d00388 <monero_reduce>
c0d02988:	ae01      	add	r6, sp, #4
    monero_subm(ss2, alpha, ss);
c0d0298a:	4630      	mov	r0, r6
c0d0298c:	4629      	mov	r1, r5
c0d0298e:	4622      	mov	r2, r4
c0d02990:	f7fe fa00 	bl	c0d00d94 <monero_subm>
c0d02994:	2120      	movs	r1, #32

    monero_io_insert(ss2,32);
c0d02996:	4630      	mov	r0, r6
c0d02998:	f7fe fdcc 	bl	c0d01534 <monero_io_insert>
    monero_io_insert_u32(G_monero_vstate.sig_mode);
c0d0299c:	4805      	ldr	r0, [pc, #20]	; (c0d029b4 <monero_apdu_mlsag_sign+0x98>)
c0d0299e:	59c0      	ldr	r0, [r0, r7]
c0d029a0:	f7fe fe00 	bl	c0d015a4 <monero_io_insert_u32>
c0d029a4:	2009      	movs	r0, #9
c0d029a6:	0300      	lsls	r0, r0, #12
    return SW_OK;
c0d029a8:	b021      	add	sp, #132	; 0x84
c0d029aa:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d029ac:	20d5      	movs	r0, #213	; 0xd5
c0d029ae:	01c0      	lsls	r0, r0, #7
        monero_io_fetch(alpha,32);
    } else if (G_monero_vstate.sig_mode == TRANSACTION_CREATE_REAL) {
        monero_io_fetch_decrypt(xin,32);
        monero_io_fetch_decrypt(alpha,32);
    } else {
        THROW(SW_WRONG_DATA);
c0d029b0:	f001 f9be 	bl	c0d03d30 <os_longjmp>
c0d029b4:	20001930 	.word	0x20001930

c0d029b8 <monero_base58_public_key>:
        res[i] = alphabet[remainder];
        --i;
    }
}

int monero_base58_public_key(char* str_b58, unsigned char *view, unsigned char *spend, unsigned char is_subbadress) {
c0d029b8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d029ba:	b099      	sub	sp, #100	; 0x64
c0d029bc:	461c      	mov	r4, r3
c0d029be:	9204      	str	r2, [sp, #16]
c0d029c0:	9105      	str	r1, [sp, #20]
c0d029c2:	9006      	str	r0, [sp, #24]
    unsigned char data[72];
    unsigned int offset;
    unsigned int prefix;

    //data[0] = N_monero_pstate->network_id;
    switch(N_monero_pstate->network_id) {
c0d029c4:	4832      	ldr	r0, [pc, #200]	; (c0d02a90 <monero_base58_public_key+0xd8>)
c0d029c6:	f001 ffd1 	bl	c0d0496c <pic>
c0d029ca:	7a00      	ldrb	r0, [r0, #8]
c0d029cc:	2800      	cmp	r0, #0
c0d029ce:	d007      	beq.n	c0d029e0 <monero_base58_public_key+0x28>
c0d029d0:	2802      	cmp	r0, #2
c0d029d2:	d005      	beq.n	c0d029e0 <monero_base58_public_key+0x28>
c0d029d4:	2801      	cmp	r0, #1
c0d029d6:	d10a      	bne.n	c0d029ee <monero_base58_public_key+0x36>
        case TESTNET:
            prefix = is_subbadress ? TESTNET_CRYPTONOTE_PUBLIC_SUBADDRESS_BASE58_PREFIX : TESTNET_CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX;
c0d029d8:	2c00      	cmp	r4, #0
c0d029da:	d007      	beq.n	c0d029ec <monero_base58_public_key+0x34>
c0d029dc:	4930      	ldr	r1, [pc, #192]	; (c0d02aa0 <monero_base58_public_key+0xe8>)
c0d029de:	e006      	b.n	c0d029ee <monero_base58_public_key+0x36>
c0d029e0:	2c00      	cmp	r4, #0
c0d029e2:	d001      	beq.n	c0d029e8 <monero_base58_public_key+0x30>
c0d029e4:	492c      	ldr	r1, [pc, #176]	; (c0d02a98 <monero_base58_public_key+0xe0>)
c0d029e6:	e002      	b.n	c0d029ee <monero_base58_public_key+0x36>
c0d029e8:	492a      	ldr	r1, [pc, #168]	; (c0d02a94 <monero_base58_public_key+0xdc>)
c0d029ea:	e000      	b.n	c0d029ee <monero_base58_public_key+0x36>
c0d029ec:	492b      	ldr	r1, [pc, #172]	; (c0d02a9c <monero_base58_public_key+0xe4>)
c0d029ee:	ae07      	add	r6, sp, #28
            break;
        case MAINNET:
            prefix = is_subbadress ? MAINNET_CRYPTONOTE_PUBLIC_SUBADDRESS_BASE58_PREFIX : MAINNET_CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX;
            break;
    }
    offset = monero_encode_varint(data, prefix);
c0d029f0:	4630      	mov	r0, r6
c0d029f2:	f7fd fc8f 	bl	c0d00314 <monero_encode_varint>
c0d029f6:	4605      	mov	r5, r0
    
    os_memmove(data+offset,spend,32);
c0d029f8:	1834      	adds	r4, r6, r0
c0d029fa:	2720      	movs	r7, #32
c0d029fc:	4620      	mov	r0, r4
c0d029fe:	9904      	ldr	r1, [sp, #16]
c0d02a00:	463a      	mov	r2, r7
c0d02a02:	f001 f8c6 	bl	c0d03b92 <os_memmove>
    os_memmove(data+offset+32,view,32);
c0d02a06:	4620      	mov	r0, r4
c0d02a08:	3020      	adds	r0, #32
c0d02a0a:	9905      	ldr	r1, [sp, #20]
c0d02a0c:	463a      	mov	r2, r7
c0d02a0e:	f001 f8c0 	bl	c0d03b92 <os_memmove>
c0d02a12:	200b      	movs	r0, #11
c0d02a14:	9003      	str	r0, [sp, #12]
c0d02a16:	01c0      	lsls	r0, r0, #7
    monero_keccak_F(data, offset+64, G_monero_vstate.H);
c0d02a18:	4922      	ldr	r1, [pc, #136]	; (c0d02aa4 <monero_base58_public_key+0xec>)
c0d02a1a:	180f      	adds	r7, r1, r0
c0d02a1c:	4668      	mov	r0, sp
c0d02a1e:	6007      	str	r7, [r0, #0]
c0d02a20:	2023      	movs	r0, #35	; 0x23
c0d02a22:	0100      	lsls	r0, r0, #4
c0d02a24:	1809      	adds	r1, r1, r0
c0d02a26:	462b      	mov	r3, r5
c0d02a28:	3340      	adds	r3, #64	; 0x40
c0d02a2a:	2006      	movs	r0, #6
c0d02a2c:	4632      	mov	r2, r6
c0d02a2e:	f7fd fc4d 	bl	c0d002cc <monero_hash>
    os_memmove(data+offset+32+32, G_monero_vstate.H, 4);
c0d02a32:	3440      	adds	r4, #64	; 0x40
c0d02a34:	2204      	movs	r2, #4
c0d02a36:	4620      	mov	r0, r4
c0d02a38:	4639      	mov	r1, r7
c0d02a3a:	f001 f8aa 	bl	c0d03b92 <os_memmove>

    unsigned int full_block_count = (offset+32+32+4) / FULL_BLOCK_SIZE;
c0d02a3e:	3544      	adds	r5, #68	; 0x44
c0d02a40:	2107      	movs	r1, #7
    unsigned int last_block_size  = (offset+32+32+4) % FULL_BLOCK_SIZE;
c0d02a42:	4628      	mov	r0, r5
c0d02a44:	9102      	str	r1, [sp, #8]
c0d02a46:	4008      	ands	r0, r1
c0d02a48:	9004      	str	r0, [sp, #16]
    os_memmove(data+offset,spend,32);
    os_memmove(data+offset+32,view,32);
    monero_keccak_F(data, offset+64, G_monero_vstate.H);
    os_memmove(data+offset+32+32, G_monero_vstate.H, 4);

    unsigned int full_block_count = (offset+32+32+4) / FULL_BLOCK_SIZE;
c0d02a4a:	08e8      	lsrs	r0, r5, #3
    unsigned int last_block_size  = (offset+32+32+4) % FULL_BLOCK_SIZE;
    for (size_t i = 0; i < full_block_count; ++i) {
c0d02a4c:	9005      	str	r0, [sp, #20]
c0d02a4e:	d00c      	beq.n	c0d02a6a <monero_base58_public_key+0xb2>
c0d02a50:	ac07      	add	r4, sp, #28
c0d02a52:	9e05      	ldr	r6, [sp, #20]
c0d02a54:	9f06      	ldr	r7, [sp, #24]
c0d02a56:	2108      	movs	r1, #8
        encode_block(data + i * FULL_BLOCK_SIZE, FULL_BLOCK_SIZE, &str_b58[i * FULL_ENCODED_BLOCK_SIZE]);
c0d02a58:	4620      	mov	r0, r4
c0d02a5a:	463a      	mov	r2, r7
c0d02a5c:	f000 f824 	bl	c0d02aa8 <encode_block>
    monero_keccak_F(data, offset+64, G_monero_vstate.H);
    os_memmove(data+offset+32+32, G_monero_vstate.H, 4);

    unsigned int full_block_count = (offset+32+32+4) / FULL_BLOCK_SIZE;
    unsigned int last_block_size  = (offset+32+32+4) % FULL_BLOCK_SIZE;
    for (size_t i = 0; i < full_block_count; ++i) {
c0d02a60:	3408      	adds	r4, #8
c0d02a62:	1e76      	subs	r6, r6, #1
c0d02a64:	370b      	adds	r7, #11
c0d02a66:	2e00      	cmp	r6, #0
c0d02a68:	d1f5      	bne.n	c0d02a56 <monero_base58_public_key+0x9e>
c0d02a6a:	9b04      	ldr	r3, [sp, #16]
        encode_block(data + i * FULL_BLOCK_SIZE, FULL_BLOCK_SIZE, &str_b58[i * FULL_ENCODED_BLOCK_SIZE]);
    }

    if (0 < last_block_size) {
c0d02a6c:	2b00      	cmp	r3, #0
c0d02a6e:	d00b      	beq.n	c0d02a88 <monero_base58_public_key+0xd0>
        encode_block(data + full_block_count * FULL_BLOCK_SIZE, last_block_size, &str_b58[full_block_count * FULL_ENCODED_BLOCK_SIZE]);
c0d02a70:	9802      	ldr	r0, [sp, #8]
c0d02a72:	4385      	bics	r5, r0
c0d02a74:	a807      	add	r0, sp, #28
c0d02a76:	1940      	adds	r0, r0, r5
c0d02a78:	9a03      	ldr	r2, [sp, #12]
c0d02a7a:	9905      	ldr	r1, [sp, #20]
c0d02a7c:	434a      	muls	r2, r1
c0d02a7e:	9906      	ldr	r1, [sp, #24]
c0d02a80:	188a      	adds	r2, r1, r2
c0d02a82:	4619      	mov	r1, r3
c0d02a84:	f000 f810 	bl	c0d02aa8 <encode_block>
c0d02a88:	2000      	movs	r0, #0
    }

    return 0;
c0d02a8a:	b019      	add	sp, #100	; 0x64
c0d02a8c:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02a8e:	46c0      	nop			; (mov r8, r8)
c0d02a90:	c0d07ec0 	.word	0xc0d07ec0
c0d02a94:	00002867 	.word	0x00002867
c0d02a98:	00002c68 	.word	0x00002c68
c0d02a9c:	00005b1d 	.word	0x00005b1d
c0d02aa0:	0000641c 	.word	0x0000641c
c0d02aa4:	20001930 	.word	0x20001930

c0d02aa8 <encode_block>:
    }

    return res;
}

static void encode_block(const unsigned char* block, unsigned int  size,  char* res) {
c0d02aa8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d02aaa:	b085      	sub	sp, #20
c0d02aac:	2309      	movs	r3, #9
#define  ADDR_CHECKSUM_SIZE                4


static uint64_t uint_8be_to_64(const unsigned char* data, size_t size) {
    uint64_t res = 0;
    switch (9 - size) {
c0d02aae:	1a5c      	subs	r4, r3, r1
c0d02ab0:	2600      	movs	r6, #0
c0d02ab2:	4633      	mov	r3, r6
c0d02ab4:	2c04      	cmp	r4, #4
c0d02ab6:	dc06      	bgt.n	c0d02ac6 <encode_block+0x1e>
c0d02ab8:	2c02      	cmp	r4, #2
c0d02aba:	dc0b      	bgt.n	c0d02ad4 <encode_block+0x2c>
c0d02abc:	2c01      	cmp	r4, #1
c0d02abe:	d013      	beq.n	c0d02ae8 <encode_block+0x40>
c0d02ac0:	2c02      	cmp	r4, #2
c0d02ac2:	d016      	beq.n	c0d02af2 <encode_block+0x4a>
c0d02ac4:	e069      	b.n	c0d02b9a <encode_block+0xf2>
c0d02ac6:	2c06      	cmp	r4, #6
c0d02ac8:	dc09      	bgt.n	c0d02ade <encode_block+0x36>
c0d02aca:	2c05      	cmp	r4, #5
c0d02acc:	d026      	beq.n	c0d02b1c <encode_block+0x74>
c0d02ace:	2c06      	cmp	r4, #6
c0d02ad0:	d02b      	beq.n	c0d02b2a <encode_block+0x82>
c0d02ad2:	e062      	b.n	c0d02b9a <encode_block+0xf2>
c0d02ad4:	2c03      	cmp	r4, #3
c0d02ad6:	d013      	beq.n	c0d02b00 <encode_block+0x58>
c0d02ad8:	2c04      	cmp	r4, #4
c0d02ada:	d018      	beq.n	c0d02b0e <encode_block+0x66>
c0d02adc:	e05d      	b.n	c0d02b9a <encode_block+0xf2>
c0d02ade:	2c07      	cmp	r4, #7
c0d02ae0:	d02a      	beq.n	c0d02b38 <encode_block+0x90>
c0d02ae2:	2c08      	cmp	r4, #8
c0d02ae4:	d02f      	beq.n	c0d02b46 <encode_block+0x9e>
c0d02ae6:	e058      	b.n	c0d02b9a <encode_block+0xf2>
    case 1:            res |= *data++;
c0d02ae8:	1c44      	adds	r4, r0, #1
c0d02aea:	7800      	ldrb	r0, [r0, #0]
c0d02aec:	0203      	lsls	r3, r0, #8
c0d02aee:	2600      	movs	r6, #0
c0d02af0:	4620      	mov	r0, r4
    case 2: res <<= 8; res |= *data++;
c0d02af2:	7804      	ldrb	r4, [r0, #0]
c0d02af4:	431c      	orrs	r4, r3
c0d02af6:	0e23      	lsrs	r3, r4, #24
c0d02af8:	0235      	lsls	r5, r6, #8
c0d02afa:	18ee      	adds	r6, r5, r3
c0d02afc:	0223      	lsls	r3, r4, #8
c0d02afe:	1c40      	adds	r0, r0, #1
    case 3: res <<= 8; res |= *data++;
c0d02b00:	7804      	ldrb	r4, [r0, #0]
c0d02b02:	431c      	orrs	r4, r3
c0d02b04:	0e23      	lsrs	r3, r4, #24
c0d02b06:	0235      	lsls	r5, r6, #8
c0d02b08:	18ee      	adds	r6, r5, r3
c0d02b0a:	0223      	lsls	r3, r4, #8
c0d02b0c:	1c40      	adds	r0, r0, #1
    case 4: res <<= 8; res |= *data++;
c0d02b0e:	7804      	ldrb	r4, [r0, #0]
c0d02b10:	431c      	orrs	r4, r3
c0d02b12:	0e23      	lsrs	r3, r4, #24
c0d02b14:	0235      	lsls	r5, r6, #8
c0d02b16:	18ee      	adds	r6, r5, r3
c0d02b18:	0223      	lsls	r3, r4, #8
c0d02b1a:	1c40      	adds	r0, r0, #1
    case 5: res <<= 8; res |= *data++;
c0d02b1c:	7804      	ldrb	r4, [r0, #0]
c0d02b1e:	431c      	orrs	r4, r3
c0d02b20:	0e23      	lsrs	r3, r4, #24
c0d02b22:	0235      	lsls	r5, r6, #8
c0d02b24:	18ee      	adds	r6, r5, r3
c0d02b26:	0223      	lsls	r3, r4, #8
c0d02b28:	1c40      	adds	r0, r0, #1
    case 6: res <<= 8; res |= *data++;
c0d02b2a:	7804      	ldrb	r4, [r0, #0]
c0d02b2c:	431c      	orrs	r4, r3
c0d02b2e:	0e23      	lsrs	r3, r4, #24
c0d02b30:	0235      	lsls	r5, r6, #8
c0d02b32:	18ee      	adds	r6, r5, r3
c0d02b34:	0223      	lsls	r3, r4, #8
c0d02b36:	1c40      	adds	r0, r0, #1
    case 7: res <<= 8; res |= *data++;
c0d02b38:	7804      	ldrb	r4, [r0, #0]
c0d02b3a:	431c      	orrs	r4, r3
c0d02b3c:	0e23      	lsrs	r3, r4, #24
c0d02b3e:	0235      	lsls	r5, r6, #8
c0d02b40:	18ee      	adds	r6, r5, r3
c0d02b42:	0223      	lsls	r3, r4, #8
c0d02b44:	1c40      	adds	r0, r0, #1
    case 8: res <<= 8; res |= *data; 
c0d02b46:	7805      	ldrb	r5, [r0, #0]
c0d02b48:	431d      	orrs	r5, r3
}

static void encode_block(const unsigned char* block, unsigned int  size,  char* res) {
    uint64_t num = uint_8be_to_64(block, size);
    int i = encoded_block_sizes[size] - 1;
    while (0 < num) {
c0d02b4a:	4628      	mov	r0, r5
c0d02b4c:	4330      	orrs	r0, r6
c0d02b4e:	2800      	cmp	r0, #0
c0d02b50:	d023      	beq.n	c0d02b9a <encode_block+0xf2>
    return res;
}

static void encode_block(const unsigned char* block, unsigned int  size,  char* res) {
    uint64_t num = uint_8be_to_64(block, size);
    int i = encoded_block_sizes[size] - 1;
c0d02b52:	0088      	lsls	r0, r1, #2
c0d02b54:	4912      	ldr	r1, [pc, #72]	; (c0d02ba0 <encode_block+0xf8>)
c0d02b56:	4479      	add	r1, pc
c0d02b58:	5808      	ldr	r0, [r1, r0]
c0d02b5a:	1810      	adds	r0, r2, r0
c0d02b5c:	1e47      	subs	r7, r0, #1
c0d02b5e:	4811      	ldr	r0, [pc, #68]	; (c0d02ba4 <encode_block+0xfc>)
c0d02b60:	4478      	add	r0, pc
c0d02b62:	9001      	str	r0, [sp, #4]
c0d02b64:	243a      	movs	r4, #58	; 0x3a
c0d02b66:	4631      	mov	r1, r6
c0d02b68:	9604      	str	r6, [sp, #16]
c0d02b6a:	2600      	movs	r6, #0
    while (0 < num) {
        uint64_t remainder = num % alphabet_size;
        num /= alphabet_size;
c0d02b6c:	4628      	mov	r0, r5
c0d02b6e:	4622      	mov	r2, r4
c0d02b70:	4633      	mov	r3, r6
c0d02b72:	f003 fd4f 	bl	c0d06614 <__aeabi_uldivmod>
c0d02b76:	9003      	str	r0, [sp, #12]
c0d02b78:	9102      	str	r1, [sp, #8]
c0d02b7a:	4622      	mov	r2, r4
c0d02b7c:	4633      	mov	r3, r6
c0d02b7e:	f003 fd69 	bl	c0d06654 <__aeabi_lmul>
c0d02b82:	1a28      	subs	r0, r5, r0
        res[i] = alphabet[remainder];
c0d02b84:	9901      	ldr	r1, [sp, #4]
c0d02b86:	5c08      	ldrb	r0, [r1, r0]
c0d02b88:	7038      	strb	r0, [r7, #0]
}

static void encode_block(const unsigned char* block, unsigned int  size,  char* res) {
    uint64_t num = uint_8be_to_64(block, size);
    int i = encoded_block_sizes[size] - 1;
    while (0 < num) {
c0d02b8a:	1e7f      	subs	r7, r7, #1
c0d02b8c:	2039      	movs	r0, #57	; 0x39
c0d02b8e:	1b40      	subs	r0, r0, r5
c0d02b90:	9804      	ldr	r0, [sp, #16]
c0d02b92:	4186      	sbcs	r6, r0
c0d02b94:	9d03      	ldr	r5, [sp, #12]
c0d02b96:	9e02      	ldr	r6, [sp, #8]
c0d02b98:	d3e4      	bcc.n	c0d02b64 <encode_block+0xbc>
        uint64_t remainder = num % alphabet_size;
        num /= alphabet_size;
        res[i] = alphabet[remainder];
        --i;
    }
}
c0d02b9a:	b005      	add	sp, #20
c0d02b9c:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02b9e:	46c0      	nop			; (mov r8, r8)
c0d02ba0:	0000456a 	.word	0x0000456a
c0d02ba4:	00004524 	.word	0x00004524

c0d02ba8 <monero_reset_tx>:


/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reset_tx() {
c0d02ba8:	b570      	push	{r4, r5, r6, lr}
c0d02baa:	2021      	movs	r0, #33	; 0x21
c0d02bac:	0100      	lsls	r0, r0, #4
    os_memset(G_monero_vstate.r, 0, 32);
c0d02bae:	4e13      	ldr	r6, [pc, #76]	; (c0d02bfc <monero_reset_tx+0x54>)
c0d02bb0:	1830      	adds	r0, r6, r0
c0d02bb2:	2400      	movs	r4, #0
c0d02bb4:	2520      	movs	r5, #32
c0d02bb6:	4621      	mov	r1, r4
c0d02bb8:	462a      	mov	r2, r5
c0d02bba:	f000 ffe1 	bl	c0d03b80 <os_memset>
c0d02bbe:	201f      	movs	r0, #31
c0d02bc0:	0100      	lsls	r0, r0, #4
    os_memset(G_monero_vstate.R, 0, 32);
c0d02bc2:	1830      	adds	r0, r6, r0
c0d02bc4:	4621      	mov	r1, r4
c0d02bc6:	462a      	mov	r2, r5
c0d02bc8:	f000 ffda 	bl	c0d03b80 <os_memset>
c0d02bcc:	257b      	movs	r5, #123	; 0x7b
c0d02bce:	00e8      	lsls	r0, r5, #3
    monero_keccak_init_H();
c0d02bd0:	1830      	adds	r0, r6, r0
c0d02bd2:	f7fd fb5d 	bl	c0d00290 <monero_hash_init_keccak>
c0d02bd6:	480a      	ldr	r0, [pc, #40]	; (c0d02c00 <monero_reset_tx+0x58>)
    monero_sha256_commitment_init();
c0d02bd8:	1830      	adds	r0, r6, r0
c0d02bda:	f7fd fbac 	bl	c0d00336 <monero_hash_init_sha256>
c0d02bde:	2017      	movs	r0, #23
c0d02be0:	0180      	lsls	r0, r0, #6
    monero_sha256_outkeys_init();
c0d02be2:	1830      	adds	r0, r6, r0
c0d02be4:	f7fd fba7 	bl	c0d00336 <monero_hash_init_sha256>
c0d02be8:	00a8      	lsls	r0, r5, #2
    G_monero_vstate.tx_in_progress = 0;
    G_monero_vstate.tx_output_cnt = 0;
c0d02bea:	5034      	str	r4, [r6, r0]
c0d02bec:	203d      	movs	r0, #61	; 0x3d
c0d02bee:	00c0      	lsls	r0, r0, #3
    os_memset(G_monero_vstate.r, 0, 32);
    os_memset(G_monero_vstate.R, 0, 32);
    monero_keccak_init_H();
    monero_sha256_commitment_init();
    monero_sha256_outkeys_init();
    G_monero_vstate.tx_in_progress = 0;
c0d02bf0:	5c31      	ldrb	r1, [r6, r0]
c0d02bf2:	22fd      	movs	r2, #253	; 0xfd
c0d02bf4:	400a      	ands	r2, r1
c0d02bf6:	5432      	strb	r2, [r6, r0]
    G_monero_vstate.tx_output_cnt = 0;

 }
c0d02bf8:	bd70      	pop	{r4, r5, r6, pc}
c0d02bfa:	46c0      	nop			; (mov r8, r8)
c0d02bfc:	20001930 	.word	0x20001930
c0d02c00:	0000064c 	.word	0x0000064c

c0d02c04 <monero_apdu_open_tx>:
/* ----------------------------------------------------------------------- */
/*
 * HD wallet not yet supported : account is assumed to be zero
 */
#define OPTION_KEEP_r 1
int monero_apdu_open_tx() {
c0d02c04:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d02c06:	b081      	sub	sp, #4

    unsigned int account;

    account = monero_io_fetch_u32();
c0d02c08:	f7fe fd76 	bl	c0d016f8 <monero_io_fetch_u32>
c0d02c0c:	2001      	movs	r0, #1

    monero_io_discard(1);
c0d02c0e:	f7fe fc65 	bl	c0d014dc <monero_io_discard>

    monero_reset_tx();
c0d02c12:	f7ff ffc9 	bl	c0d02ba8 <monero_reset_tx>
c0d02c16:	2021      	movs	r0, #33	; 0x21
c0d02c18:	0100      	lsls	r0, r0, #4
    monero_rng(G_monero_vstate.r,32);
c0d02c1a:	4f12      	ldr	r7, [pc, #72]	; (c0d02c64 <monero_apdu_open_tx+0x60>)
c0d02c1c:	183c      	adds	r4, r7, r0
c0d02c1e:	2520      	movs	r5, #32
c0d02c20:	4620      	mov	r0, r4
c0d02c22:	4629      	mov	r1, r5
c0d02c24:	f7fd fb72 	bl	c0d0030c <monero_rng>
    monero_reduce(G_monero_vstate.r, G_monero_vstate.r);
c0d02c28:	4620      	mov	r0, r4
c0d02c2a:	4621      	mov	r1, r4
c0d02c2c:	f7fd fbac 	bl	c0d00388 <monero_reduce>
c0d02c30:	201f      	movs	r0, #31
c0d02c32:	0100      	lsls	r0, r0, #4
    monero_ecmul_G(G_monero_vstate.R, G_monero_vstate.r);
c0d02c34:	183e      	adds	r6, r7, r0
c0d02c36:	4630      	mov	r0, r6
c0d02c38:	4621      	mov	r1, r4
c0d02c3a:	f7fd fdff 	bl	c0d0083c <monero_ecmul_G>

    monero_io_insert(G_monero_vstate.R,32);
c0d02c3e:	4630      	mov	r0, r6
c0d02c40:	4629      	mov	r1, r5
c0d02c42:	f7fe fc77 	bl	c0d01534 <monero_io_insert>
    monero_io_insert_encrypt(G_monero_vstate.r,32);
c0d02c46:	4620      	mov	r0, r4
c0d02c48:	4629      	mov	r1, r5
c0d02c4a:	f7fe fc87 	bl	c0d0155c <monero_io_insert_encrypt>
c0d02c4e:	203d      	movs	r0, #61	; 0x3d
c0d02c50:	00c0      	lsls	r0, r0, #3
#ifdef DEBUG_HWDEVICE
    monero_io_insert(G_monero_vstate.r,32);
#endif
    G_monero_vstate.tx_in_progress = 1;
c0d02c52:	5c39      	ldrb	r1, [r7, r0]
c0d02c54:	2202      	movs	r2, #2
c0d02c56:	430a      	orrs	r2, r1
c0d02c58:	543a      	strb	r2, [r7, r0]
c0d02c5a:	2009      	movs	r0, #9
c0d02c5c:	0300      	lsls	r0, r0, #12
    return SW_OK;
c0d02c5e:	b001      	add	sp, #4
c0d02c60:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02c62:	46c0      	nop			; (mov r8, r8)
c0d02c64:	20001930 	.word	0x20001930

c0d02c68 <monero_apdu_close_tx>:
#undef OPTION_KEEP_r

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_close_tx() {
c0d02c68:	b580      	push	{r7, lr}
c0d02c6a:	2001      	movs	r0, #1
   monero_io_discard(1);
c0d02c6c:	f7fe fc36 	bl	c0d014dc <monero_io_discard>
   monero_reset_tx();
c0d02c70:	f7ff ff9a 	bl	c0d02ba8 <monero_reset_tx>
c0d02c74:	203d      	movs	r0, #61	; 0x3d
c0d02c76:	00c0      	lsls	r0, r0, #3
   G_monero_vstate.tx_in_progress = 0;
c0d02c78:	4903      	ldr	r1, [pc, #12]	; (c0d02c88 <monero_apdu_close_tx+0x20>)
c0d02c7a:	5c0a      	ldrb	r2, [r1, r0]
c0d02c7c:	23fd      	movs	r3, #253	; 0xfd
c0d02c7e:	4013      	ands	r3, r2
c0d02c80:	540b      	strb	r3, [r1, r0]
c0d02c82:	2009      	movs	r0, #9
c0d02c84:	0300      	lsls	r0, r0, #12
   return SW_OK;
c0d02c86:	bd80      	pop	{r7, pc}
c0d02c88:	20001930 	.word	0x20001930

c0d02c8c <monero_abort_tx>:
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
/*
 * Sub dest address not yet supported: P1 = 2 not supported
 */
int monero_abort_tx() {
c0d02c8c:	b580      	push	{r7, lr}
    monero_reset_tx();
c0d02c8e:	f7ff ff8b 	bl	c0d02ba8 <monero_reset_tx>
c0d02c92:	2000      	movs	r0, #0
    return 0;
c0d02c94:	bd80      	pop	{r7, pc}
	...

c0d02c98 <monero_apdu_set_signature_mode>:
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
/*
 * Sub dest address not yet supported: P1 = 2 not supported
 */
int monero_apdu_set_signature_mode() {
c0d02c98:	b570      	push	{r4, r5, r6, lr}
c0d02c9a:	2005      	movs	r0, #5
c0d02c9c:	0185      	lsls	r5, r0, #6
    unsigned int sig_mode;

    G_monero_vstate.sig_mode = TRANSACTION_CREATE_FAKE;
c0d02c9e:	4e0b      	ldr	r6, [pc, #44]	; (c0d02ccc <monero_apdu_set_signature_mode+0x34>)
c0d02ca0:	2002      	movs	r0, #2
c0d02ca2:	5170      	str	r0, [r6, r5]

    sig_mode = monero_io_fetch_u8();
c0d02ca4:	f7fe fd44 	bl	c0d01730 <monero_io_fetch_u8>
c0d02ca8:	4604      	mov	r4, r0
c0d02caa:	2000      	movs	r0, #0
    monero_io_discard(0);
c0d02cac:	f7fe fc16 	bl	c0d014dc <monero_io_discard>
    switch(sig_mode) {
c0d02cb0:	1e60      	subs	r0, r4, #1
c0d02cb2:	2802      	cmp	r0, #2
c0d02cb4:	d206      	bcs.n	c0d02cc4 <monero_apdu_set_signature_mode+0x2c>
    case TRANSACTION_CREATE_FAKE:
        break;
    default:
        THROW(SW_WRONG_DATA);
    }
    G_monero_vstate.sig_mode = sig_mode;
c0d02cb6:	5174      	str	r4, [r6, r5]

    monero_io_insert_u32( G_monero_vstate.sig_mode );
c0d02cb8:	4620      	mov	r0, r4
c0d02cba:	f7fe fc73 	bl	c0d015a4 <monero_io_insert_u32>
c0d02cbe:	2009      	movs	r0, #9
c0d02cc0:	0300      	lsls	r0, r0, #12
    return SW_OK;
c0d02cc2:	bd70      	pop	{r4, r5, r6, pc}
c0d02cc4:	20d5      	movs	r0, #213	; 0xd5
c0d02cc6:	01c0      	lsls	r0, r0, #7
    switch(sig_mode) {
    case TRANSACTION_CREATE_REAL:
    case TRANSACTION_CREATE_FAKE:
        break;
    default:
        THROW(SW_WRONG_DATA);
c0d02cc8:	f001 f832 	bl	c0d03d30 <os_longjmp>
c0d02ccc:	20001930 	.word	0x20001930

c0d02cd0 <monero_apdu_mlsag_prehash_init>:
#include "monero_vars.h"

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_mlsag_prehash_init() {
c0d02cd0:	b570      	push	{r4, r5, r6, lr}
c0d02cd2:	2005      	movs	r0, #5
c0d02cd4:	0186      	lsls	r6, r0, #6
    if (G_monero_vstate.sig_mode == TRANSACTION_CREATE_REAL) {
c0d02cd6:	4d22      	ldr	r5, [pc, #136]	; (c0d02d60 <monero_apdu_mlsag_prehash_init+0x90>)
c0d02cd8:	59a8      	ldr	r0, [r5, r6]
c0d02cda:	2801      	cmp	r0, #1
c0d02cdc:	d116      	bne.n	c0d02d0c <monero_apdu_mlsag_prehash_init+0x3c>
c0d02cde:	7968      	ldrb	r0, [r5, #5]
c0d02ce0:	2801      	cmp	r0, #1
c0d02ce2:	d113      	bne.n	c0d02d0c <monero_apdu_mlsag_prehash_init+0x3c>
c0d02ce4:	481f      	ldr	r0, [pc, #124]	; (c0d02d64 <monero_apdu_mlsag_prehash_init+0x94>)
        if (G_monero_vstate.io_p2 == 1) {
            monero_sha256_outkeys_final(NULL);
c0d02ce6:	1829      	adds	r1, r5, r0
c0d02ce8:	2017      	movs	r0, #23
c0d02cea:	0180      	lsls	r0, r0, #6
c0d02cec:	182c      	adds	r4, r5, r0
c0d02cee:	4620      	mov	r0, r4
c0d02cf0:	f7fd fae0 	bl	c0d002b4 <monero_hash_final>
            monero_sha256_outkeys_init();
c0d02cf4:	4620      	mov	r0, r4
c0d02cf6:	f7fd fb1e 	bl	c0d00336 <monero_hash_init_sha256>
c0d02cfa:	481b      	ldr	r0, [pc, #108]	; (c0d02d68 <monero_apdu_mlsag_prehash_init+0x98>)
            monero_sha256_commitment_init();
c0d02cfc:	1828      	adds	r0, r5, r0
c0d02cfe:	f7fd fb1a 	bl	c0d00336 <monero_hash_init_sha256>
c0d02d02:	207b      	movs	r0, #123	; 0x7b
c0d02d04:	00c0      	lsls	r0, r0, #3
            monero_keccak_init_H();
c0d02d06:	1828      	adds	r0, r5, r0
c0d02d08:	f7fd fac2 	bl	c0d00290 <monero_hash_init_keccak>
c0d02d0c:	207b      	movs	r0, #123	; 0x7b
c0d02d0e:	00c0      	lsls	r0, r0, #3
        }
    }
    monero_keccak_update_H(G_monero_vstate.io_buffer+G_monero_vstate.io_offset,
c0d02d10:	1828      	adds	r0, r5, r0
c0d02d12:	8969      	ldrh	r1, [r5, #10]
c0d02d14:	892a      	ldrh	r2, [r5, #8]
c0d02d16:	1a52      	subs	r2, r2, r1
c0d02d18:	1869      	adds	r1, r5, r1
c0d02d1a:	310e      	adds	r1, #14
c0d02d1c:	f7fd fabe 	bl	c0d0029c <monero_hash_update>
                          G_monero_vstate.io_length-G_monero_vstate.io_offset);
    if ((G_monero_vstate.sig_mode == TRANSACTION_CREATE_REAL) &&(G_monero_vstate.io_p2==1)) {
c0d02d20:	59a8      	ldr	r0, [r5, r6]
c0d02d22:	2801      	cmp	r0, #1
c0d02d24:	d115      	bne.n	c0d02d52 <monero_apdu_mlsag_prehash_init+0x82>
c0d02d26:	7968      	ldrb	r0, [r5, #5]
c0d02d28:	2801      	cmp	r0, #1
c0d02d2a:	d112      	bne.n	c0d02d52 <monero_apdu_mlsag_prehash_init+0x82>
        // skip type
        monero_io_fetch_u8();
c0d02d2c:	f7fe fd00 	bl	c0d01730 <monero_io_fetch_u8>
c0d02d30:	20f5      	movs	r0, #245	; 0xf5
c0d02d32:	00c0      	lsls	r0, r0, #3
        // fee str
        monero_vamount2str(G_monero_vstate.io_buffer+G_monero_vstate.io_offset, G_monero_vstate.ux_amount, 15);
c0d02d34:	1829      	adds	r1, r5, r0
c0d02d36:	8968      	ldrh	r0, [r5, #10]
c0d02d38:	1828      	adds	r0, r5, r0
c0d02d3a:	300e      	adds	r0, #14
c0d02d3c:	220f      	movs	r2, #15
c0d02d3e:	f7fe f93f 	bl	c0d00fc0 <monero_vamount2str>
c0d02d42:	2001      	movs	r0, #1
         //ask user
        monero_io_discard(1);
c0d02d44:	f7fe fbca 	bl	c0d014dc <monero_io_discard>
c0d02d48:	2400      	movs	r4, #0
        ui_menu_fee_validation_display(0);
c0d02d4a:	4620      	mov	r0, r4
c0d02d4c:	f000 fa8c 	bl	c0d03268 <ui_menu_fee_validation_display>
c0d02d50:	e004      	b.n	c0d02d5c <monero_apdu_mlsag_prehash_init+0x8c>
c0d02d52:	2001      	movs	r0, #1
        return 0;
    } else {
        monero_io_discard(1);
c0d02d54:	f7fe fbc2 	bl	c0d014dc <monero_io_discard>
c0d02d58:	2009      	movs	r0, #9
c0d02d5a:	0304      	lsls	r4, r0, #12
        return SW_OK;
    }
}
c0d02d5c:	4620      	mov	r0, r4
c0d02d5e:	bd70      	pop	{r4, r5, r6, pc}
c0d02d60:	20001930 	.word	0x20001930
c0d02d64:	0000062c 	.word	0x0000062c
c0d02d68:	0000064c 	.word	0x0000064c

c0d02d6c <monero_apdu_mlsag_prehash_update>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_mlsag_prehash_update() {
c0d02d6c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d02d6e:	b0af      	sub	sp, #188	; 0xbc

    #define aH AKout
    unsigned char kG[32];

    //fetch destination
    is_subaddress = monero_io_fetch_u8();
c0d02d70:	f7fe fcde 	bl	c0d01730 <monero_io_fetch_u8>
c0d02d74:	9001      	str	r0, [sp, #4]
    if (G_monero_vstate.io_protocol_version == 2) {
c0d02d76:	4c7a      	ldr	r4, [pc, #488]	; (c0d02f60 <monero_apdu_mlsag_prehash_update+0x1f4>)
c0d02d78:	78a1      	ldrb	r1, [r4, #2]
c0d02d7a:	2000      	movs	r0, #0
c0d02d7c:	2902      	cmp	r1, #2
c0d02d7e:	d101      	bne.n	c0d02d84 <monero_apdu_mlsag_prehash_update+0x18>
        is_change =  monero_io_fetch_u8();
c0d02d80:	f7fe fcd6 	bl	c0d01730 <monero_io_fetch_u8>
c0d02d84:	a92e      	add	r1, sp, #184	; 0xb8
c0d02d86:	7008      	strb	r0, [r1, #0]
    } else {
        is_change = 0;
    }
    Aout = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
c0d02d88:	8966      	ldrh	r6, [r4, #10]
c0d02d8a:	2400      	movs	r4, #0
c0d02d8c:	2520      	movs	r5, #32
c0d02d8e:	4620      	mov	r0, r4
c0d02d90:	4629      	mov	r1, r5
c0d02d92:	f7fe fc39 	bl	c0d01608 <monero_io_fetch>
    Bout = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
c0d02d96:	4872      	ldr	r0, [pc, #456]	; (c0d02f60 <monero_apdu_mlsag_prehash_update+0x1f4>)
c0d02d98:	8947      	ldrh	r7, [r0, #10]
c0d02d9a:	4620      	mov	r0, r4
c0d02d9c:	4629      	mov	r1, r5
c0d02d9e:	f7fe fc33 	bl	c0d01608 <monero_io_fetch>
c0d02da2:	a826      	add	r0, sp, #152	; 0x98
    monero_io_fetch_decrypt(AKout,32);
c0d02da4:	4629      	mov	r1, r5
c0d02da6:	f7fe fc4b 	bl	c0d01640 <monero_io_fetch_decrypt>
c0d02daa:	a81e      	add	r0, sp, #120	; 0x78
    monero_io_fetch(C, 32);
c0d02dac:	4629      	mov	r1, r5
c0d02dae:	f7fe fc2b 	bl	c0d01608 <monero_io_fetch>
c0d02db2:	a80e      	add	r0, sp, #56	; 0x38
    monero_io_fetch(k, 32);
c0d02db4:	4629      	mov	r1, r5
c0d02db6:	f7fe fc27 	bl	c0d01608 <monero_io_fetch>
c0d02dba:	a816      	add	r0, sp, #88	; 0x58
    monero_io_fetch(v, 32);
c0d02dbc:	4629      	mov	r1, r5
c0d02dbe:	f7fe fc23 	bl	c0d01608 <monero_io_fetch>
c0d02dc2:	9402      	str	r4, [sp, #8]

    monero_io_discard(0);
c0d02dc4:	4620      	mov	r0, r4
c0d02dc6:	4c66      	ldr	r4, [pc, #408]	; (c0d02f60 <monero_apdu_mlsag_prehash_update+0x1f4>)
c0d02dc8:	f7fe fb88 	bl	c0d014dc <monero_io_discard>
    if (G_monero_vstate.io_protocol_version == 2) {
        is_change =  monero_io_fetch_u8();
    } else {
        is_change = 0;
    }
    Aout = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
c0d02dcc:	4620      	mov	r0, r4
c0d02dce:	300e      	adds	r0, #14
c0d02dd0:	1981      	adds	r1, r0, r6
    Bout = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
c0d02dd2:	9103      	str	r1, [sp, #12]
c0d02dd4:	19c0      	adds	r0, r0, r7
c0d02dd6:	9004      	str	r0, [sp, #16]
c0d02dd8:	204f      	movs	r0, #79	; 0x4f
c0d02dda:	0080      	lsls	r0, r0, #2
c0d02ddc:	9005      	str	r0, [sp, #20]
    monero_io_fetch(v, 32);

    monero_io_discard(0);

    //update MLSAG prehash
    if ((G_monero_vstate.options&0x03) == 0x02) {
c0d02dde:	5820      	ldr	r0, [r4, r0]
c0d02de0:	2603      	movs	r6, #3
c0d02de2:	4030      	ands	r0, r6
c0d02de4:	2802      	cmp	r0, #2
c0d02de6:	d105      	bne.n	c0d02df4 <monero_apdu_mlsag_prehash_update+0x88>
c0d02de8:	207b      	movs	r0, #123	; 0x7b
c0d02dea:	00c0      	lsls	r0, r0, #3
        monero_keccak_update_H(v,8);
c0d02dec:	1820      	adds	r0, r4, r0
c0d02dee:	a916      	add	r1, sp, #88	; 0x58
c0d02df0:	2208      	movs	r2, #8
c0d02df2:	e00b      	b.n	c0d02e0c <monero_apdu_mlsag_prehash_update+0xa0>
c0d02df4:	207b      	movs	r0, #123	; 0x7b
c0d02df6:	00c0      	lsls	r0, r0, #3
    } else {
        monero_keccak_update_H(k,32);
c0d02df8:	1825      	adds	r5, r4, r0
c0d02dfa:	a90e      	add	r1, sp, #56	; 0x38
c0d02dfc:	2720      	movs	r7, #32
c0d02dfe:	4628      	mov	r0, r5
c0d02e00:	463a      	mov	r2, r7
c0d02e02:	f7fd fa4b 	bl	c0d0029c <monero_hash_update>
c0d02e06:	a916      	add	r1, sp, #88	; 0x58
        monero_keccak_update_H(v,32);
c0d02e08:	4628      	mov	r0, r5
c0d02e0a:	463a      	mov	r2, r7
c0d02e0c:	f7fd fa46 	bl	c0d0029c <monero_hash_update>
c0d02e10:	2005      	movs	r0, #5
c0d02e12:	0180      	lsls	r0, r0, #6
    }

    if (G_monero_vstate.sig_mode == TRANSACTION_CREATE_REAL) {
c0d02e14:	5820      	ldr	r0, [r4, r0]
c0d02e16:	2109      	movs	r1, #9
c0d02e18:	030f      	lsls	r7, r1, #12
c0d02e1a:	2801      	cmp	r0, #1
c0d02e1c:	d000      	beq.n	c0d02e20 <monero_apdu_mlsag_prehash_update+0xb4>
c0d02e1e:	e094      	b.n	c0d02f4a <monero_apdu_mlsag_prehash_update+0x1de>
c0d02e20:	a82e      	add	r0, sp, #184	; 0xb8
        if (is_change == 0) {
c0d02e22:	7800      	ldrb	r0, [r0, #0]
c0d02e24:	2800      	cmp	r0, #0
c0d02e26:	d108      	bne.n	c0d02e3a <monero_apdu_mlsag_prehash_update+0xce>
c0d02e28:	20e9      	movs	r0, #233	; 0xe9
c0d02e2a:	00c0      	lsls	r0, r0, #3
            //encode dest adress
            monero_base58_public_key(&G_monero_vstate.ux_address[0], Aout, Bout, is_subaddress);
c0d02e2c:	1820      	adds	r0, r4, r0
c0d02e2e:	9901      	ldr	r1, [sp, #4]
c0d02e30:	b2cb      	uxtb	r3, r1
c0d02e32:	9903      	ldr	r1, [sp, #12]
c0d02e34:	9a04      	ldr	r2, [sp, #16]
c0d02e36:	f7ff fdbf 	bl	c0d029b8 <monero_base58_public_key>
        }
        //update destination hash control
        if (G_monero_vstate.io_protocol_version == 2) {
c0d02e3a:	78a0      	ldrb	r0, [r4, #2]
c0d02e3c:	2802      	cmp	r0, #2
c0d02e3e:	d119      	bne.n	c0d02e74 <monero_apdu_mlsag_prehash_update+0x108>
c0d02e40:	2017      	movs	r0, #23
c0d02e42:	0180      	lsls	r0, r0, #6
            monero_sha256_outkeys_update(Aout,32);
c0d02e44:	1825      	adds	r5, r4, r0
c0d02e46:	9701      	str	r7, [sp, #4]
c0d02e48:	2720      	movs	r7, #32
c0d02e4a:	4628      	mov	r0, r5
c0d02e4c:	9903      	ldr	r1, [sp, #12]
c0d02e4e:	463a      	mov	r2, r7
c0d02e50:	f7fd fa24 	bl	c0d0029c <monero_hash_update>
            monero_sha256_outkeys_update(Bout,32);
c0d02e54:	4628      	mov	r0, r5
c0d02e56:	9904      	ldr	r1, [sp, #16]
c0d02e58:	463a      	mov	r2, r7
c0d02e5a:	f7fd fa1f 	bl	c0d0029c <monero_hash_update>
c0d02e5e:	a92e      	add	r1, sp, #184	; 0xb8
c0d02e60:	2201      	movs	r2, #1
            monero_sha256_outkeys_update(&is_change,1);
c0d02e62:	4628      	mov	r0, r5
c0d02e64:	f7fd fa1a 	bl	c0d0029c <monero_hash_update>
c0d02e68:	a926      	add	r1, sp, #152	; 0x98
            monero_sha256_outkeys_update(AKout,32);
c0d02e6a:	4628      	mov	r0, r5
c0d02e6c:	463a      	mov	r2, r7
c0d02e6e:	9f01      	ldr	r7, [sp, #4]
c0d02e70:	f7fd fa14 	bl	c0d0029c <monero_hash_update>
        }

        //check C = aH+kG
        monero_unblind(v,k, AKout, G_monero_vstate.options&0x03);
c0d02e74:	9805      	ldr	r0, [sp, #20]
c0d02e76:	5823      	ldr	r3, [r4, r0]
c0d02e78:	4033      	ands	r3, r6
c0d02e7a:	ad16      	add	r5, sp, #88	; 0x58
c0d02e7c:	ae0e      	add	r6, sp, #56	; 0x38
c0d02e7e:	aa26      	add	r2, sp, #152	; 0x98
c0d02e80:	4628      	mov	r0, r5
c0d02e82:	4631      	mov	r1, r6
c0d02e84:	f7fd f93a 	bl	c0d000fc <monero_unblind>
c0d02e88:	a806      	add	r0, sp, #24
        monero_ecmul_G(kG, k);
c0d02e8a:	4631      	mov	r1, r6
c0d02e8c:	f7fd fcd6 	bl	c0d0083c <monero_ecmul_G>
c0d02e90:	2120      	movs	r1, #32
        if (!cx_math_is_zero(v, 32)) {
c0d02e92:	4628      	mov	r0, r5
c0d02e94:	f001 feb8 	bl	c0d04c08 <cx_math_is_zero>
c0d02e98:	2800      	cmp	r0, #0
c0d02e9a:	d005      	beq.n	c0d02ea8 <monero_apdu_mlsag_prehash_update+0x13c>
c0d02e9c:	a826      	add	r0, sp, #152	; 0x98
c0d02e9e:	a906      	add	r1, sp, #24
c0d02ea0:	2220      	movs	r2, #32
            monero_ecmul_H(aH, v);
            monero_ecadd(aH, kG, aH);
        } else {
            os_memmove(aH, kG, 32);
c0d02ea2:	f000 fe76 	bl	c0d03b92 <os_memmove>
c0d02ea6:	e009      	b.n	c0d02ebc <monero_apdu_mlsag_prehash_update+0x150>
c0d02ea8:	ad26      	add	r5, sp, #152	; 0x98
c0d02eaa:	a916      	add	r1, sp, #88	; 0x58

        //check C = aH+kG
        monero_unblind(v,k, AKout, G_monero_vstate.options&0x03);
        monero_ecmul_G(kG, k);
        if (!cx_math_is_zero(v, 32)) {
            monero_ecmul_H(aH, v);
c0d02eac:	4628      	mov	r0, r5
c0d02eae:	f7fd fec5 	bl	c0d00c3c <monero_ecmul_H>
c0d02eb2:	a906      	add	r1, sp, #24
            monero_ecadd(aH, kG, aH);
c0d02eb4:	4628      	mov	r0, r5
c0d02eb6:	462a      	mov	r2, r5
c0d02eb8:	f7fd fd8f 	bl	c0d009da <monero_ecadd>
c0d02ebc:	a81e      	add	r0, sp, #120	; 0x78
c0d02ebe:	a926      	add	r1, sp, #152	; 0x98
c0d02ec0:	2220      	movs	r2, #32
        } else {
            os_memmove(aH, kG, 32);
        }
        if (os_memcmp(C, aH, 32)) {
c0d02ec2:	f000 ff21 	bl	c0d03d08 <os_memcmp>
c0d02ec6:	2800      	cmp	r0, #0
c0d02ec8:	d142      	bne.n	c0d02f50 <monero_apdu_mlsag_prehash_update+0x1e4>
c0d02eca:	4827      	ldr	r0, [pc, #156]	; (c0d02f68 <monero_apdu_mlsag_prehash_update+0x1fc>)
            THROW(SW_SECURITY_COMMITMENT_CONTROL);
        }
        //update commitment hash control
        monero_sha256_commitment_update(C,32);
c0d02ecc:	1826      	adds	r6, r4, r0
c0d02ece:	a91e      	add	r1, sp, #120	; 0x78
c0d02ed0:	2220      	movs	r2, #32
c0d02ed2:	4630      	mov	r0, r6
c0d02ed4:	f7fd f9e2 	bl	c0d0029c <monero_hash_update>


        if ((G_monero_vstate.options & IN_OPTION_MORE_COMMAND)==0) {
c0d02ed8:	9805      	ldr	r0, [sp, #20]
c0d02eda:	5c20      	ldrb	r0, [r4, r0]
c0d02edc:	0600      	lsls	r0, r0, #24
c0d02ede:	d41a      	bmi.n	c0d02f16 <monero_apdu_mlsag_prehash_update+0x1aa>
            if (G_monero_vstate.io_protocol_version == 2) {
c0d02ee0:	78a0      	ldrb	r0, [r4, #2]
c0d02ee2:	2802      	cmp	r0, #2
c0d02ee4:	d10e      	bne.n	c0d02f04 <monero_apdu_mlsag_prehash_update+0x198>
c0d02ee6:	2017      	movs	r0, #23
c0d02ee8:	0180      	lsls	r0, r0, #6
                //finalize and check destination hash_control
                monero_sha256_outkeys_final(k);
c0d02eea:	1820      	adds	r0, r4, r0
c0d02eec:	ad0e      	add	r5, sp, #56	; 0x38
c0d02eee:	4629      	mov	r1, r5
c0d02ef0:	f7fd f9e0 	bl	c0d002b4 <monero_hash_final>
c0d02ef4:	481d      	ldr	r0, [pc, #116]	; (c0d02f6c <monero_apdu_mlsag_prehash_update+0x200>)
                if (os_memcmp(k, G_monero_vstate.OUTK, 32)) {
c0d02ef6:	1821      	adds	r1, r4, r0
c0d02ef8:	2220      	movs	r2, #32
c0d02efa:	4628      	mov	r0, r5
c0d02efc:	f000 ff04 	bl	c0d03d08 <os_memcmp>
c0d02f00:	2800      	cmp	r0, #0
c0d02f02:	d128      	bne.n	c0d02f56 <monero_apdu_mlsag_prehash_update+0x1ea>
c0d02f04:	20d7      	movs	r0, #215	; 0xd7
c0d02f06:	00c0      	lsls	r0, r0, #3
                    THROW(SW_SECURITY_OUTKEYS_CHAIN_CONTROL);
                }
            }
            //finalize commitment hash control
            monero_sha256_commitment_final(NULL);
c0d02f08:	1821      	adds	r1, r4, r0
c0d02f0a:	4630      	mov	r0, r6
c0d02f0c:	f7fd f9d2 	bl	c0d002b4 <monero_hash_final>
            monero_sha256_commitment_init();
c0d02f10:	4630      	mov	r0, r6
c0d02f12:	f7fd fa10 	bl	c0d00336 <monero_hash_init_sha256>
c0d02f16:	a816      	add	r0, sp, #88	; 0x58
        }

        //ask user
        uint64_t amount;
        amount = monero_bamount2uint64(v);
c0d02f18:	f7fe f813 	bl	c0d00f42 <monero_bamount2uint64>
        if (amount) {
c0d02f1c:	4602      	mov	r2, r0
c0d02f1e:	430a      	orrs	r2, r1
c0d02f20:	2a00      	cmp	r2, #0
c0d02f22:	d012      	beq.n	c0d02f4a <monero_apdu_mlsag_prehash_update+0x1de>
c0d02f24:	22f5      	movs	r2, #245	; 0xf5
c0d02f26:	00d2      	lsls	r2, r2, #3
            monero_amount2str(amount, G_monero_vstate.ux_amount, 15);
c0d02f28:	18a2      	adds	r2, r4, r2
c0d02f2a:	230f      	movs	r3, #15
c0d02f2c:	f7fd ff96 	bl	c0d00e5c <monero_amount2str>
c0d02f30:	a82e      	add	r0, sp, #184	; 0xb8
            if (!is_change) {
c0d02f32:	7800      	ldrb	r0, [r0, #0]
c0d02f34:	2800      	cmp	r0, #0
c0d02f36:	d004      	beq.n	c0d02f42 <monero_apdu_mlsag_prehash_update+0x1d6>
c0d02f38:	9f02      	ldr	r7, [sp, #8]
                ui_menu_validation_display(0);
            } else  {
                ui_menu_change_validation_display(0);
c0d02f3a:	4638      	mov	r0, r7
c0d02f3c:	f000 f9a2 	bl	c0d03284 <ui_menu_change_validation_display>
c0d02f40:	e003      	b.n	c0d02f4a <monero_apdu_mlsag_prehash_update+0x1de>
c0d02f42:	2700      	movs	r7, #0
        uint64_t amount;
        amount = monero_bamount2uint64(v);
        if (amount) {
            monero_amount2str(amount, G_monero_vstate.ux_amount, 15);
            if (!is_change) {
                ui_menu_validation_display(0);
c0d02f44:	4638      	mov	r0, r7
c0d02f46:	f000 fac9 	bl	c0d034dc <ui_menu_validation_display>
        }
    }
    return SW_OK;

    #undef aH
}
c0d02f4a:	4638      	mov	r0, r7
c0d02f4c:	b02f      	add	sp, #188	; 0xbc
c0d02f4e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02f50:	4804      	ldr	r0, [pc, #16]	; (c0d02f64 <monero_apdu_mlsag_prehash_update+0x1f8>)
            monero_ecadd(aH, kG, aH);
        } else {
            os_memmove(aH, kG, 32);
        }
        if (os_memcmp(C, aH, 32)) {
            THROW(SW_SECURITY_COMMITMENT_CONTROL);
c0d02f52:	f000 feed 	bl	c0d03d30 <os_longjmp>
c0d02f56:	4803      	ldr	r0, [pc, #12]	; (c0d02f64 <monero_apdu_mlsag_prehash_update+0x1f8>)
        if ((G_monero_vstate.options & IN_OPTION_MORE_COMMAND)==0) {
            if (G_monero_vstate.io_protocol_version == 2) {
                //finalize and check destination hash_control
                monero_sha256_outkeys_final(k);
                if (os_memcmp(k, G_monero_vstate.OUTK, 32)) {
                    THROW(SW_SECURITY_OUTKEYS_CHAIN_CONTROL);
c0d02f58:	1cc0      	adds	r0, r0, #3
c0d02f5a:	f000 fee9 	bl	c0d03d30 <os_longjmp>
c0d02f5e:	46c0      	nop			; (mov r8, r8)
c0d02f60:	20001930 	.word	0x20001930
c0d02f64:	00006911 	.word	0x00006911
c0d02f68:	0000064c 	.word	0x0000064c
c0d02f6c:	0000062c 	.word	0x0000062c

c0d02f70 <monero_apdu_mlsag_prehash_finalize>:


/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_mlsag_prehash_finalize() {
c0d02f70:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d02f72:	b099      	sub	sp, #100	; 0x64
c0d02f74:	204f      	movs	r0, #79	; 0x4f
c0d02f76:	0080      	lsls	r0, r0, #2
    unsigned char message[32];
    unsigned char proof[32];
    unsigned char H[32];

    if (G_monero_vstate.options & IN_OPTION_MORE_COMMAND) {
c0d02f78:	4e32      	ldr	r6, [pc, #200]	; (c0d03044 <monero_apdu_mlsag_prehash_finalize+0xd4>)
c0d02f7a:	5c30      	ldrb	r0, [r6, r0]
c0d02f7c:	0600      	lsls	r0, r0, #24
c0d02f7e:	d443      	bmi.n	c0d03008 <monero_apdu_mlsag_prehash_finalize+0x98>
c0d02f80:	2005      	movs	r0, #5
c0d02f82:	0180      	lsls	r0, r0, #6
        monero_io_insert(H, 32);
#endif

    } else {
        //Finalize and check commitment hash control
        if (G_monero_vstate.sig_mode == TRANSACTION_CREATE_REAL) {
c0d02f84:	5830      	ldr	r0, [r6, r0]
c0d02f86:	2801      	cmp	r0, #1
c0d02f88:	d10e      	bne.n	c0d02fa8 <monero_apdu_mlsag_prehash_finalize+0x38>
c0d02f8a:	482f      	ldr	r0, [pc, #188]	; (c0d03048 <monero_apdu_mlsag_prehash_finalize+0xd8>)
            monero_sha256_commitment_final(H);
c0d02f8c:	1830      	adds	r0, r6, r0
c0d02f8e:	ac01      	add	r4, sp, #4
c0d02f90:	4621      	mov	r1, r4
c0d02f92:	f7fd f98f 	bl	c0d002b4 <monero_hash_final>
c0d02f96:	20d7      	movs	r0, #215	; 0xd7
c0d02f98:	00c0      	lsls	r0, r0, #3
            if (os_memcmp(H,G_monero_vstate.C,32)) {
c0d02f9a:	1831      	adds	r1, r6, r0
c0d02f9c:	2220      	movs	r2, #32
c0d02f9e:	4620      	mov	r0, r4
c0d02fa0:	f000 feb2 	bl	c0d03d08 <os_memcmp>
c0d02fa4:	2800      	cmp	r0, #0
c0d02fa6:	d149      	bne.n	c0d0303c <monero_apdu_mlsag_prehash_finalize+0xcc>
c0d02fa8:	207b      	movs	r0, #123	; 0x7b
c0d02faa:	00c0      	lsls	r0, r0, #3
                THROW(SW_SECURITY_COMMITMENT_CHAIN_CONTROL);
            }
        }
        //compute last H
        monero_keccak_final_H(H);
c0d02fac:	1834      	adds	r4, r6, r0
c0d02fae:	a901      	add	r1, sp, #4
c0d02fb0:	9100      	str	r1, [sp, #0]
c0d02fb2:	4620      	mov	r0, r4
c0d02fb4:	f7fd f97e 	bl	c0d002b4 <monero_hash_final>
c0d02fb8:	ad11      	add	r5, sp, #68	; 0x44
c0d02fba:	2620      	movs	r6, #32
        //compute last prehash
        monero_io_fetch(message,32);
c0d02fbc:	4628      	mov	r0, r5
c0d02fbe:	4631      	mov	r1, r6
c0d02fc0:	f7fe fb22 	bl	c0d01608 <monero_io_fetch>
c0d02fc4:	af09      	add	r7, sp, #36	; 0x24
        monero_io_fetch(proof,32);
c0d02fc6:	4638      	mov	r0, r7
c0d02fc8:	4631      	mov	r1, r6
c0d02fca:	f7fe fb1d 	bl	c0d01608 <monero_io_fetch>
c0d02fce:	2001      	movs	r0, #1
        monero_io_discard(1);
c0d02fd0:	f7fe fa84 	bl	c0d014dc <monero_io_discard>
        monero_keccak_init_H();
c0d02fd4:	4620      	mov	r0, r4
c0d02fd6:	f7fd f95b 	bl	c0d00290 <monero_hash_init_keccak>
        monero_keccak_update_H(message,32);
c0d02fda:	4620      	mov	r0, r4
c0d02fdc:	4629      	mov	r1, r5
c0d02fde:	4632      	mov	r2, r6
c0d02fe0:	f7fd f95c 	bl	c0d0029c <monero_hash_update>
        monero_keccak_update_H(H,32);
c0d02fe4:	4620      	mov	r0, r4
c0d02fe6:	9900      	ldr	r1, [sp, #0]
c0d02fe8:	4632      	mov	r2, r6
c0d02fea:	f7fd f957 	bl	c0d0029c <monero_hash_update>
        monero_keccak_update_H(proof,32);
c0d02fee:	4620      	mov	r0, r4
c0d02ff0:	4639      	mov	r1, r7
c0d02ff2:	4632      	mov	r2, r6
c0d02ff4:	f7fd f952 	bl	c0d0029c <monero_hash_update>
c0d02ff8:	200b      	movs	r0, #11
c0d02ffa:	01c0      	lsls	r0, r0, #7
        monero_keccak_final_H(NULL);
c0d02ffc:	4911      	ldr	r1, [pc, #68]	; (c0d03044 <monero_apdu_mlsag_prehash_finalize+0xd4>)
c0d02ffe:	1809      	adds	r1, r1, r0
c0d03000:	4620      	mov	r0, r4
c0d03002:	f7fd f957 	bl	c0d002b4 <monero_hash_final>
c0d03006:	e015      	b.n	c0d03034 <monero_apdu_mlsag_prehash_finalize+0xc4>
c0d03008:	ac01      	add	r4, sp, #4
c0d0300a:	2520      	movs	r5, #32
    unsigned char proof[32];
    unsigned char H[32];

    if (G_monero_vstate.options & IN_OPTION_MORE_COMMAND) {
        //accumulate
        monero_io_fetch(H,32);
c0d0300c:	4620      	mov	r0, r4
c0d0300e:	4629      	mov	r1, r5
c0d03010:	f7fe fafa 	bl	c0d01608 <monero_io_fetch>
c0d03014:	2001      	movs	r0, #1
        monero_io_discard(1);
c0d03016:	f7fe fa61 	bl	c0d014dc <monero_io_discard>
c0d0301a:	207b      	movs	r0, #123	; 0x7b
c0d0301c:	00c0      	lsls	r0, r0, #3
        monero_keccak_update_H(H,32);
c0d0301e:	1830      	adds	r0, r6, r0
c0d03020:	4621      	mov	r1, r4
c0d03022:	462a      	mov	r2, r5
c0d03024:	f7fd f93a 	bl	c0d0029c <monero_hash_update>
c0d03028:	4807      	ldr	r0, [pc, #28]	; (c0d03048 <monero_apdu_mlsag_prehash_finalize+0xd8>)
        monero_sha256_commitment_update(H,32);
c0d0302a:	1830      	adds	r0, r6, r0
c0d0302c:	4621      	mov	r1, r4
c0d0302e:	462a      	mov	r2, r5
c0d03030:	f7fd f934 	bl	c0d0029c <monero_hash_update>
c0d03034:	2009      	movs	r0, #9
c0d03036:	0300      	lsls	r0, r0, #12
        monero_io_insert(G_monero_vstate.H, 32);
        monero_io_insert(H, 32);
#endif
    }

    return SW_OK;
c0d03038:	b019      	add	sp, #100	; 0x64
c0d0303a:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d0303c:	4803      	ldr	r0, [pc, #12]	; (c0d0304c <monero_apdu_mlsag_prehash_finalize+0xdc>)
    } else {
        //Finalize and check commitment hash control
        if (G_monero_vstate.sig_mode == TRANSACTION_CREATE_REAL) {
            monero_sha256_commitment_final(H);
            if (os_memcmp(H,G_monero_vstate.C,32)) {
                THROW(SW_SECURITY_COMMITMENT_CHAIN_CONTROL);
c0d0303e:	f000 fe77 	bl	c0d03d30 <os_longjmp>
c0d03042:	46c0      	nop			; (mov r8, r8)
c0d03044:	20001930 	.word	0x20001930
c0d03048:	0000064c 	.word	0x0000064c
c0d0304c:	00006913 	.word	0x00006913

c0d03050 <monero_apdu_get_tx_proof>:
 *   compute X = k*G
 * compute Y = k*A
 * sig.c = Hs(Msg || D || X || Y)
 * sig.r = k - sig.c*r
 */
int monero_apdu_get_tx_proof() {
c0d03050:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03052:	b0a5      	sub	sp, #148	; 0x94
    unsigned char XY[32];
    unsigned char sig_c[32];
    unsigned char sig_r[32];
    #define k (G_monero_vstate.tmp+256)

    msg = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
c0d03054:	4d43      	ldr	r5, [pc, #268]	; (c0d03164 <monero_apdu_get_tx_proof+0x114>)
c0d03056:	8968      	ldrh	r0, [r5, #10]
c0d03058:	9003      	str	r0, [sp, #12]
c0d0305a:	2400      	movs	r4, #0
c0d0305c:	2620      	movs	r6, #32
c0d0305e:	4620      	mov	r0, r4
c0d03060:	4631      	mov	r1, r6
c0d03062:	f7fe fad1 	bl	c0d01608 <monero_io_fetch>
    R = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
c0d03066:	4620      	mov	r0, r4
c0d03068:	4631      	mov	r1, r6
c0d0306a:	f7fe facd 	bl	c0d01608 <monero_io_fetch>
    A = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
c0d0306e:	8968      	ldrh	r0, [r5, #10]
c0d03070:	9002      	str	r0, [sp, #8]
c0d03072:	4620      	mov	r0, r4
c0d03074:	4631      	mov	r1, r6
c0d03076:	f7fe fac7 	bl	c0d01608 <monero_io_fetch>
    B = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
c0d0307a:	8968      	ldrh	r0, [r5, #10]
c0d0307c:	9001      	str	r0, [sp, #4]
c0d0307e:	4620      	mov	r0, r4
c0d03080:	4631      	mov	r1, r6
c0d03082:	f7fe fac1 	bl	c0d01608 <monero_io_fetch>
    D = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
c0d03086:	896f      	ldrh	r7, [r5, #10]
c0d03088:	4620      	mov	r0, r4
c0d0308a:	4631      	mov	r1, r6
c0d0308c:	f7fe fabc 	bl	c0d01608 <monero_io_fetch>
c0d03090:	a81d      	add	r0, sp, #116	; 0x74
    monero_io_fetch_decrypt_key(r);
c0d03092:	f7fe faff 	bl	c0d01694 <monero_io_fetch_decrypt_key>

    monero_io_discard(0);
c0d03096:	4620      	mov	r0, r4
c0d03098:	f7fe fa20 	bl	c0d014dc <monero_io_discard>
c0d0309c:	20fb      	movs	r0, #251	; 0xfb
c0d0309e:	00c0      	lsls	r0, r0, #3

    monero_rng(k,32);
c0d030a0:	182c      	adds	r4, r5, r0
c0d030a2:	4620      	mov	r0, r4
c0d030a4:	4631      	mov	r1, r6
c0d030a6:	f7fd f931 	bl	c0d0030c <monero_rng>
    monero_reduce(k,k);
c0d030aa:	4620      	mov	r0, r4
c0d030ac:	9404      	str	r4, [sp, #16]
c0d030ae:	4621      	mov	r1, r4
c0d030b0:	f7fd f96a 	bl	c0d00388 <monero_reduce>
c0d030b4:	20db      	movs	r0, #219	; 0xdb
c0d030b6:	00c0      	lsls	r0, r0, #3
    D = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
    monero_io_fetch_decrypt_key(r);

    monero_io_discard(0);

    monero_rng(k,32);
c0d030b8:	1828      	adds	r0, r5, r0
    unsigned char XY[32];
    unsigned char sig_c[32];
    unsigned char sig_r[32];
    #define k (G_monero_vstate.tmp+256)

    msg = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
c0d030ba:	462c      	mov	r4, r5
c0d030bc:	340e      	adds	r4, #14
c0d030be:	9903      	ldr	r1, [sp, #12]
c0d030c0:	1861      	adds	r1, r4, r1
c0d030c2:	9003      	str	r0, [sp, #12]

    monero_io_discard(0);

    monero_rng(k,32);
    monero_reduce(k,k);
    os_memmove(G_monero_vstate.tmp+32*0, msg, 32);
c0d030c4:	4632      	mov	r2, r6
c0d030c6:	f000 fd64 	bl	c0d03b92 <os_memmove>
c0d030ca:	20df      	movs	r0, #223	; 0xdf
c0d030cc:	00c0      	lsls	r0, r0, #3
    os_memmove(G_monero_vstate.tmp+32*1, D, 32);
c0d030ce:	1828      	adds	r0, r5, r0

    msg = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
    R = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
    A = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
    B = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
    D = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
c0d030d0:	19e1      	adds	r1, r4, r7
    monero_io_discard(0);

    monero_rng(k,32);
    monero_reduce(k,k);
    os_memmove(G_monero_vstate.tmp+32*0, msg, 32);
    os_memmove(G_monero_vstate.tmp+32*1, D, 32);
c0d030d2:	4632      	mov	r2, r6
c0d030d4:	f000 fd5d 	bl	c0d03b92 <os_memmove>
    unsigned char sig_r[32];
    #define k (G_monero_vstate.tmp+256)

    msg = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
    R = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
    A = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
c0d030d8:	9802      	ldr	r0, [sp, #8]
c0d030da:	1824      	adds	r4, r4, r0
c0d030dc:	204f      	movs	r0, #79	; 0x4f
c0d030de:	0080      	lsls	r0, r0, #2
    monero_rng(k,32);
    monero_reduce(k,k);
    os_memmove(G_monero_vstate.tmp+32*0, msg, 32);
    os_memmove(G_monero_vstate.tmp+32*1, D, 32);

    if(G_monero_vstate.options&1) {
c0d030e0:	5c28      	ldrb	r0, [r5, r0]
c0d030e2:	07c0      	lsls	r0, r0, #31
c0d030e4:	d104      	bne.n	c0d030f0 <monero_apdu_get_tx_proof+0xa0>
c0d030e6:	a815      	add	r0, sp, #84	; 0x54
        monero_ecmul_k(XY,B,k);
    } else {
        monero_ecmul_G(XY,k);
c0d030e8:	9904      	ldr	r1, [sp, #16]
c0d030ea:	f7fd fba7 	bl	c0d0083c <monero_ecmul_G>
c0d030ee:	e006      	b.n	c0d030fe <monero_apdu_get_tx_proof+0xae>
    #define k (G_monero_vstate.tmp+256)

    msg = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
    R = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
    A = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
    B = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
c0d030f0:	9801      	ldr	r0, [sp, #4]
c0d030f2:	1829      	adds	r1, r5, r0
c0d030f4:	310e      	adds	r1, #14
c0d030f6:	a815      	add	r0, sp, #84	; 0x54
    monero_reduce(k,k);
    os_memmove(G_monero_vstate.tmp+32*0, msg, 32);
    os_memmove(G_monero_vstate.tmp+32*1, D, 32);

    if(G_monero_vstate.options&1) {
        monero_ecmul_k(XY,B,k);
c0d030f8:	9a04      	ldr	r2, [sp, #16]
c0d030fa:	f7fd fcb6 	bl	c0d00a6a <monero_ecmul_k>
c0d030fe:	20e3      	movs	r0, #227	; 0xe3
c0d03100:	00c0      	lsls	r0, r0, #3
    } else {
        monero_ecmul_G(XY,k);
    }
    os_memmove(G_monero_vstate.tmp+32*2,  XY, 32);
c0d03102:	1828      	adds	r0, r5, r0
c0d03104:	af15      	add	r7, sp, #84	; 0x54
c0d03106:	2620      	movs	r6, #32
c0d03108:	4639      	mov	r1, r7
c0d0310a:	4632      	mov	r2, r6
c0d0310c:	f000 fd41 	bl	c0d03b92 <os_memmove>

    monero_ecmul_k(XY,A,k);
c0d03110:	4638      	mov	r0, r7
c0d03112:	4621      	mov	r1, r4
c0d03114:	9a04      	ldr	r2, [sp, #16]
c0d03116:	f7fd fca8 	bl	c0d00a6a <monero_ecmul_k>
c0d0311a:	20e7      	movs	r0, #231	; 0xe7
c0d0311c:	00c0      	lsls	r0, r0, #3
    os_memmove(G_monero_vstate.tmp+32*3, XY, 32);
c0d0311e:	1828      	adds	r0, r5, r0
c0d03120:	4639      	mov	r1, r7
c0d03122:	4632      	mov	r2, r6
c0d03124:	f000 fd35 	bl	c0d03b92 <os_memmove>
c0d03128:	ad0d      	add	r5, sp, #52	; 0x34
c0d0312a:	2280      	movs	r2, #128	; 0x80

    monero_hash_to_scalar(sig_c, &G_monero_vstate.tmp[0],32*4);
c0d0312c:	4628      	mov	r0, r5
c0d0312e:	9903      	ldr	r1, [sp, #12]
c0d03130:	f7fd f906 	bl	c0d00340 <monero_hash_to_scalar>
c0d03134:	aa1d      	add	r2, sp, #116	; 0x74

    monero_multm(XY, sig_c, r);
c0d03136:	4638      	mov	r0, r7
c0d03138:	4629      	mov	r1, r5
c0d0313a:	f7fd fe5d 	bl	c0d00df8 <monero_multm>
c0d0313e:	ac05      	add	r4, sp, #20
    monero_subm(sig_r, k, XY);
c0d03140:	4620      	mov	r0, r4
c0d03142:	9904      	ldr	r1, [sp, #16]
c0d03144:	463a      	mov	r2, r7
c0d03146:	f7fd fe25 	bl	c0d00d94 <monero_subm>

    monero_io_insert(sig_c, 32);
c0d0314a:	4628      	mov	r0, r5
c0d0314c:	4631      	mov	r1, r6
c0d0314e:	f7fe f9f1 	bl	c0d01534 <monero_io_insert>
    monero_io_insert(sig_r, 32);
c0d03152:	4620      	mov	r0, r4
c0d03154:	4631      	mov	r1, r6
c0d03156:	f7fe f9ed 	bl	c0d01534 <monero_io_insert>
c0d0315a:	2009      	movs	r0, #9
c0d0315c:	0300      	lsls	r0, r0, #12

    return SW_OK;
c0d0315e:	b025      	add	sp, #148	; 0x94
c0d03160:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d03162:	46c0      	nop			; (mov r8, r8)
c0d03164:	20001930 	.word	0x20001930

c0d03168 <monero_apdu_stealth>:


/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_stealth() {
c0d03168:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0316a:	b09d      	sub	sp, #116	; 0x74
c0d0316c:	af15      	add	r7, sp, #84	; 0x54
c0d0316e:	2120      	movs	r1, #32
    unsigned char sec[32];
    unsigned char drv[33];
    unsigned char payID[8];
    
    //fetch pub
    monero_io_fetch(pub,32);
c0d03170:	9101      	str	r1, [sp, #4]
c0d03172:	4638      	mov	r0, r7
c0d03174:	f7fe fa48 	bl	c0d01608 <monero_io_fetch>
c0d03178:	ae0d      	add	r6, sp, #52	; 0x34
    //fetch sec
    monero_io_fetch_decrypt_key(sec);
c0d0317a:	4630      	mov	r0, r6
c0d0317c:	f7fe fa8a 	bl	c0d01694 <monero_io_fetch_decrypt_key>
c0d03180:	a802      	add	r0, sp, #8
c0d03182:	2108      	movs	r1, #8
    //fetch paymentID
    monero_io_fetch(payID,8);
c0d03184:	f7fe fa40 	bl	c0d01608 <monero_io_fetch>
c0d03188:	2400      	movs	r4, #0

    monero_io_discard(0);
c0d0318a:	4620      	mov	r0, r4
c0d0318c:	f7fe f9a6 	bl	c0d014dc <monero_io_discard>
c0d03190:	ad04      	add	r5, sp, #16

    //Compute Dout
    monero_generate_key_derivation(drv, pub, sec);
c0d03192:	4628      	mov	r0, r5
c0d03194:	4639      	mov	r1, r7
c0d03196:	4632      	mov	r2, r6
c0d03198:	f7fd fb7e 	bl	c0d00898 <monero_generate_key_derivation>
c0d0319c:	208d      	movs	r0, #141	; 0x8d
    
    //compute mask
    drv[32] = ENCRYPTED_PAYMENT_ID_TAIL;
c0d0319e:	9901      	ldr	r1, [sp, #4]
c0d031a0:	5468      	strb	r0, [r5, r1]
    monero_keccak_F(drv,33,sec);
c0d031a2:	4668      	mov	r0, sp
c0d031a4:	6006      	str	r6, [r0, #0]
c0d031a6:	2023      	movs	r0, #35	; 0x23
c0d031a8:	0100      	lsls	r0, r0, #4
c0d031aa:	490c      	ldr	r1, [pc, #48]	; (c0d031dc <monero_apdu_stealth+0x74>)
c0d031ac:	1809      	adds	r1, r1, r0
c0d031ae:	2006      	movs	r0, #6
c0d031b0:	2321      	movs	r3, #33	; 0x21
c0d031b2:	462a      	mov	r2, r5
c0d031b4:	f7fd f88a 	bl	c0d002cc <monero_hash>
c0d031b8:	a802      	add	r0, sp, #8
    
    //stealth!
    for (i=0; i<8; i++) {
        payID[i] = payID[i] ^ sec[i];
c0d031ba:	5d01      	ldrb	r1, [r0, r4]
c0d031bc:	aa0d      	add	r2, sp, #52	; 0x34
c0d031be:	5d12      	ldrb	r2, [r2, r4]
c0d031c0:	404a      	eors	r2, r1
c0d031c2:	5502      	strb	r2, [r0, r4]
    //compute mask
    drv[32] = ENCRYPTED_PAYMENT_ID_TAIL;
    monero_keccak_F(drv,33,sec);
    
    //stealth!
    for (i=0; i<8; i++) {
c0d031c4:	1c64      	adds	r4, r4, #1
c0d031c6:	2c08      	cmp	r4, #8
c0d031c8:	d1f6      	bne.n	c0d031b8 <monero_apdu_stealth+0x50>
c0d031ca:	a802      	add	r0, sp, #8
c0d031cc:	2108      	movs	r1, #8
        payID[i] = payID[i] ^ sec[i];
    }
    
    monero_io_insert(payID,8);
c0d031ce:	f7fe f9b1 	bl	c0d01534 <monero_io_insert>
c0d031d2:	2009      	movs	r0, #9
c0d031d4:	0300      	lsls	r0, r0, #12

    return SW_OK;
c0d031d6:	b01d      	add	sp, #116	; 0x74
c0d031d8:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d031da:	46c0      	nop			; (mov r8, r8)
c0d031dc:	20001930 	.word	0x20001930

c0d031e0 <ui_menu_amount_validation_action>:
  }
  return element;
}


void ui_menu_amount_validation_action(unsigned int value) {
c0d031e0:	b580      	push	{r7, lr}
c0d031e2:	4601      	mov	r1, r0
c0d031e4:	2009      	movs	r0, #9
c0d031e6:	0300      	lsls	r0, r0, #12
c0d031e8:	4a09      	ldr	r2, [pc, #36]	; (c0d03210 <ui_menu_amount_validation_action+0x30>)
  unsigned short sw;
  if (value == ACCEPT) {
c0d031ea:	4291      	cmp	r1, r2
c0d031ec:	d002      	beq.n	c0d031f4 <ui_menu_amount_validation_action+0x14>
    sw = 0x9000;
  } else {
   sw = SW_SECURITY_STATUS_NOT_SATISFIED;
    monero_abort_tx();
c0d031ee:	f7ff fd4d 	bl	c0d02c8c <monero_abort_tx>
c0d031f2:	4808      	ldr	r0, [pc, #32]	; (c0d03214 <ui_menu_amount_validation_action+0x34>)
  }
  monero_io_insert_u16(sw);
c0d031f4:	f7fe f9ea 	bl	c0d015cc <monero_io_insert_u16>
c0d031f8:	2020      	movs	r0, #32
  monero_io_do(IO_RETURN_AFTER_TX);
c0d031fa:	f7fe faab 	bl	c0d01754 <monero_io_do>
c0d031fe:	2000      	movs	r0, #0
    }
  }
  return element;
}
void ui_menu_main_display(unsigned int value) {
   UX_MENU_DISPLAY(value, ui_menu_main, ui_menu_main_preprocessor);
c0d03200:	4905      	ldr	r1, [pc, #20]	; (c0d03218 <ui_menu_amount_validation_action+0x38>)
c0d03202:	4479      	add	r1, pc
c0d03204:	4a05      	ldr	r2, [pc, #20]	; (c0d0321c <ui_menu_amount_validation_action+0x3c>)
c0d03206:	447a      	add	r2, pc
c0d03208:	f001 fb20 	bl	c0d0484c <ux_menu_display>
    monero_abort_tx();
  }
  monero_io_insert_u16(sw);
  monero_io_do(IO_RETURN_AFTER_TX);
  ui_menu_main_display(0);
}
c0d0320c:	bd80      	pop	{r7, pc}
c0d0320e:	46c0      	nop			; (mov r8, r8)
c0d03210:	0000acce 	.word	0x0000acce
c0d03214:	00006982 	.word	0x00006982
c0d03218:	00004856 	.word	0x00004856
c0d0321c:	0000070f 	.word	0x0000070f

c0d03220 <ui_menu_amount_validation_preprocessor>:
};

const bagl_element_t* ui_menu_amount_validation_preprocessor(const ux_menu_entry_t* entry, bagl_element_t* element) {

  /* --- Amount --- */
  if ((entry == &ui_menu_fee_validation[0]) || (entry == &ui_menu_change_validation[0])) {
c0d03220:	4a09      	ldr	r2, [pc, #36]	; (c0d03248 <ui_menu_amount_validation_preprocessor+0x28>)
c0d03222:	447a      	add	r2, pc
c0d03224:	4290      	cmp	r0, r2
c0d03226:	d003      	beq.n	c0d03230 <ui_menu_amount_validation_preprocessor+0x10>
c0d03228:	4a08      	ldr	r2, [pc, #32]	; (c0d0324c <ui_menu_amount_validation_preprocessor+0x2c>)
c0d0322a:	447a      	add	r2, pc
c0d0322c:	4290      	cmp	r0, r2
c0d0322e:	d107      	bne.n	c0d03240 <ui_menu_amount_validation_preprocessor+0x20>
    if(element->component.userid==0x22) {
c0d03230:	7848      	ldrb	r0, [r1, #1]
c0d03232:	2822      	cmp	r0, #34	; 0x22
c0d03234:	d104      	bne.n	c0d03240 <ui_menu_amount_validation_preprocessor+0x20>
c0d03236:	20f5      	movs	r0, #245	; 0xf5
c0d03238:	00c0      	lsls	r0, r0, #3
      element->text = G_monero_vstate.ux_amount;
c0d0323a:	4a02      	ldr	r2, [pc, #8]	; (c0d03244 <ui_menu_amount_validation_preprocessor+0x24>)
c0d0323c:	1810      	adds	r0, r2, r0
c0d0323e:	61c8      	str	r0, [r1, #28]
    }
  }
  return element;
c0d03240:	4608      	mov	r0, r1
c0d03242:	4770      	bx	lr
c0d03244:	20001930 	.word	0x20001930
c0d03248:	00004072 	.word	0x00004072
c0d0324c:	000040da 	.word	0x000040da

c0d03250 <ui_menu_main_display>:
      element->text = G_monero_vstate.ux_menu;
    }
  }
  return element;
}
void ui_menu_main_display(unsigned int value) {
c0d03250:	b580      	push	{r7, lr}
   UX_MENU_DISPLAY(value, ui_menu_main, ui_menu_main_preprocessor);
c0d03252:	4903      	ldr	r1, [pc, #12]	; (c0d03260 <ui_menu_main_display+0x10>)
c0d03254:	4479      	add	r1, pc
c0d03256:	4a03      	ldr	r2, [pc, #12]	; (c0d03264 <ui_menu_main_display+0x14>)
c0d03258:	447a      	add	r2, pc
c0d0325a:	f001 faf7 	bl	c0d0484c <ux_menu_display>
}
c0d0325e:	bd80      	pop	{r7, pc}
c0d03260:	00004804 	.word	0x00004804
c0d03264:	000006bd 	.word	0x000006bd

c0d03268 <ui_menu_fee_validation_display>:
  monero_io_insert_u16(sw);
  monero_io_do(IO_RETURN_AFTER_TX);
  ui_menu_main_display(0);
}

void ui_menu_fee_validation_display(unsigned int value) {
c0d03268:	b580      	push	{r7, lr}
c0d0326a:	2000      	movs	r0, #0
  UX_MENU_DISPLAY(0, ui_menu_fee_validation, ui_menu_amount_validation_preprocessor);
c0d0326c:	4903      	ldr	r1, [pc, #12]	; (c0d0327c <ui_menu_fee_validation_display+0x14>)
c0d0326e:	4479      	add	r1, pc
c0d03270:	4a03      	ldr	r2, [pc, #12]	; (c0d03280 <ui_menu_fee_validation_display+0x18>)
c0d03272:	447a      	add	r2, pc
c0d03274:	f001 faea 	bl	c0d0484c <ux_menu_display>
}
c0d03278:	bd80      	pop	{r7, pc}
c0d0327a:	46c0      	nop			; (mov r8, r8)
c0d0327c:	00004026 	.word	0x00004026
c0d03280:	ffffffab 	.word	0xffffffab

c0d03284 <ui_menu_change_validation_display>:
void ui_menu_change_validation_display(unsigned int value) {
c0d03284:	b580      	push	{r7, lr}
c0d03286:	2000      	movs	r0, #0
  UX_MENU_DISPLAY(0, ui_menu_change_validation, ui_menu_amount_validation_preprocessor);
c0d03288:	4903      	ldr	r1, [pc, #12]	; (c0d03298 <ui_menu_change_validation_display+0x14>)
c0d0328a:	4479      	add	r1, pc
c0d0328c:	4a03      	ldr	r2, [pc, #12]	; (c0d0329c <ui_menu_change_validation_display+0x18>)
c0d0328e:	447a      	add	r2, pc
c0d03290:	f001 fadc 	bl	c0d0484c <ux_menu_display>
}
c0d03294:	bd80      	pop	{r7, pc}
c0d03296:	46c0      	nop			; (mov r8, r8)
c0d03298:	0000407a 	.word	0x0000407a
c0d0329c:	ffffff8f 	.word	0xffffff8f

c0d032a0 <ui_menu_words_back>:
}
void ui_menu_words_clear(unsigned int value) {
  monero_clear_words();
  ui_menu_main_display(0);
}
void ui_menu_words_back(unsigned int value) {
c0d032a0:	b580      	push	{r7, lr}
c0d032a2:	2001      	movs	r0, #1
  UX_MENU_END
};


void ui_menu_settings_display(unsigned int value) {
   UX_MENU_DISPLAY(value, ui_menu_settings, NULL);
c0d032a4:	4902      	ldr	r1, [pc, #8]	; (c0d032b0 <ui_menu_words_back+0x10>)
c0d032a6:	4479      	add	r1, pc
c0d032a8:	2200      	movs	r2, #0
c0d032aa:	f001 facf 	bl	c0d0484c <ux_menu_display>
  monero_clear_words();
  ui_menu_main_display(0);
}
void ui_menu_words_back(unsigned int value) {
  ui_menu_settings_display(1);
}
c0d032ae:	bd80      	pop	{r7, pc}
c0d032b0:	000045ba 	.word	0x000045ba

c0d032b4 <ui_menu_words_clear>:
}

void ui_menu_words_display(unsigned int value) {
  UX_MENU_DISPLAY(0, ui_menu_words, ui_menu_words_preprocessor);
}
void ui_menu_words_clear(unsigned int value) {
c0d032b4:	b580      	push	{r7, lr}
  monero_clear_words();
c0d032b6:	f7fe fa8b 	bl	c0d017d0 <monero_clear_words>
c0d032ba:	2000      	movs	r0, #0
    }
  }
  return element;
}
void ui_menu_main_display(unsigned int value) {
   UX_MENU_DISPLAY(value, ui_menu_main, ui_menu_main_preprocessor);
c0d032bc:	4903      	ldr	r1, [pc, #12]	; (c0d032cc <ui_menu_words_clear+0x18>)
c0d032be:	4479      	add	r1, pc
c0d032c0:	4a03      	ldr	r2, [pc, #12]	; (c0d032d0 <ui_menu_words_clear+0x1c>)
c0d032c2:	447a      	add	r2, pc
c0d032c4:	f001 fac2 	bl	c0d0484c <ux_menu_display>
  UX_MENU_DISPLAY(0, ui_menu_words, ui_menu_words_preprocessor);
}
void ui_menu_words_clear(unsigned int value) {
  monero_clear_words();
  ui_menu_main_display(0);
}
c0d032c8:	bd80      	pop	{r7, pc}
c0d032ca:	46c0      	nop			; (mov r8, r8)
c0d032cc:	0000479a 	.word	0x0000479a
c0d032d0:	00000653 	.word	0x00000653

c0d032d4 <ui_menu_words_preprocessor>:
  {NULL,  ui_menu_words_back,                  24,     NULL,  "",  "",    0, 0},
  {NULL,  ui_menu_words_clear,                 -1,     NULL,  "CLEAR WORDS",  "(NO WIPE)",    0, 0},
  UX_MENU_END
};

const bagl_element_t* ui_menu_words_preprocessor(const ux_menu_entry_t* entry, bagl_element_t* element) {
c0d032d4:	b5b0      	push	{r4, r5, r7, lr}
c0d032d6:	460c      	mov	r4, r1
  if ((entry->userid >= 0) && (entry->userid <25)) {
c0d032d8:	6881      	ldr	r1, [r0, #8]
c0d032da:	2918      	cmp	r1, #24
c0d032dc:	d81a      	bhi.n	c0d03314 <ui_menu_words_preprocessor+0x40>
c0d032de:	4605      	mov	r5, r0

    if(element->component.userid==0x21) {
c0d032e0:	7860      	ldrb	r0, [r4, #1]
c0d032e2:	2821      	cmp	r0, #33	; 0x21
c0d032e4:	d109      	bne.n	c0d032fa <ui_menu_words_preprocessor+0x26>
      element->text = N_monero_pstate->words[entry->userid];
c0d032e6:	480c      	ldr	r0, [pc, #48]	; (c0d03318 <ui_menu_words_preprocessor+0x44>)
c0d032e8:	f001 fb40 	bl	c0d0496c <pic>
c0d032ec:	68a9      	ldr	r1, [r5, #8]
c0d032ee:	2214      	movs	r2, #20
c0d032f0:	434a      	muls	r2, r1
c0d032f2:	1880      	adds	r0, r0, r2
c0d032f4:	304a      	adds	r0, #74	; 0x4a
c0d032f6:	61e0      	str	r0, [r4, #28]
    }

    if ((element->component.userid==0x22)&&(entry->userid<24)) {
c0d032f8:	7860      	ldrb	r0, [r4, #1]
c0d032fa:	2822      	cmp	r0, #34	; 0x22
c0d032fc:	d10a      	bne.n	c0d03314 <ui_menu_words_preprocessor+0x40>
c0d032fe:	2917      	cmp	r1, #23
c0d03300:	d808      	bhi.n	c0d03314 <ui_menu_words_preprocessor+0x40>
      element->text = N_monero_pstate->words[entry->userid+1];
c0d03302:	4805      	ldr	r0, [pc, #20]	; (c0d03318 <ui_menu_words_preprocessor+0x44>)
c0d03304:	f001 fb32 	bl	c0d0496c <pic>
c0d03308:	68a9      	ldr	r1, [r5, #8]
c0d0330a:	2214      	movs	r2, #20
c0d0330c:	434a      	muls	r2, r1
c0d0330e:	1880      	adds	r0, r0, r2
c0d03310:	305e      	adds	r0, #94	; 0x5e
c0d03312:	61e0      	str	r0, [r4, #28]
    }
  }

  return element;
c0d03314:	4620      	mov	r0, r4
c0d03316:	bdb0      	pop	{r4, r5, r7, pc}
c0d03318:	c0d07ec0 	.word	0xc0d07ec0

c0d0331c <ui_menu_words_display>:
}

void ui_menu_words_display(unsigned int value) {
c0d0331c:	b580      	push	{r7, lr}
c0d0331e:	2000      	movs	r0, #0
  UX_MENU_DISPLAY(0, ui_menu_words, ui_menu_words_preprocessor);
c0d03320:	4903      	ldr	r1, [pc, #12]	; (c0d03330 <ui_menu_words_display+0x14>)
c0d03322:	4479      	add	r1, pc
c0d03324:	4a03      	ldr	r2, [pc, #12]	; (c0d03334 <ui_menu_words_display+0x18>)
c0d03326:	447a      	add	r2, pc
c0d03328:	f001 fa90 	bl	c0d0484c <ux_menu_display>
}
c0d0332c:	bd80      	pop	{r7, pc}
c0d0332e:	46c0      	nop			; (mov r8, r8)
c0d03330:	00004052 	.word	0x00004052
c0d03334:	ffffffab 	.word	0xffffffab

c0d03338 <ui_menu_validation_action>:

void ui_menu_validation_display(unsigned int value) {
  UX_MENU_DISPLAY(0, ui_menu_validation, ui_menu_validation_preprocessor);
}

void ui_menu_validation_action(unsigned int value) {
c0d03338:	b580      	push	{r7, lr}
c0d0333a:	4601      	mov	r1, r0
c0d0333c:	2009      	movs	r0, #9
c0d0333e:	0300      	lsls	r0, r0, #12
c0d03340:	4a09      	ldr	r2, [pc, #36]	; (c0d03368 <ui_menu_validation_action+0x30>)
  unsigned short sw;
  if (value == ACCEPT) {
c0d03342:	4291      	cmp	r1, r2
c0d03344:	d002      	beq.n	c0d0334c <ui_menu_validation_action+0x14>
    sw = 0x9000;
  } else {
   sw = SW_SECURITY_STATUS_NOT_SATISFIED;
    monero_abort_tx();
c0d03346:	f7ff fca1 	bl	c0d02c8c <monero_abort_tx>
c0d0334a:	4808      	ldr	r0, [pc, #32]	; (c0d0336c <ui_menu_validation_action+0x34>)
  }
  monero_io_insert_u16(sw);
c0d0334c:	f7fe f93e 	bl	c0d015cc <monero_io_insert_u16>
c0d03350:	2020      	movs	r0, #32
  monero_io_do(IO_RETURN_AFTER_TX);
c0d03352:	f7fe f9ff 	bl	c0d01754 <monero_io_do>
c0d03356:	2000      	movs	r0, #0
    }
  }
  return element;
}
void ui_menu_main_display(unsigned int value) {
   UX_MENU_DISPLAY(value, ui_menu_main, ui_menu_main_preprocessor);
c0d03358:	4905      	ldr	r1, [pc, #20]	; (c0d03370 <ui_menu_validation_action+0x38>)
c0d0335a:	4479      	add	r1, pc
c0d0335c:	4a05      	ldr	r2, [pc, #20]	; (c0d03374 <ui_menu_validation_action+0x3c>)
c0d0335e:	447a      	add	r2, pc
c0d03360:	f001 fa74 	bl	c0d0484c <ux_menu_display>
    monero_abort_tx();
  }
  monero_io_insert_u16(sw);
  monero_io_do(IO_RETURN_AFTER_TX);
  ui_menu_main_display(0);
}
c0d03364:	bd80      	pop	{r7, pc}
c0d03366:	46c0      	nop			; (mov r8, r8)
c0d03368:	0000acce 	.word	0x0000acce
c0d0336c:	00006982 	.word	0x00006982
c0d03370:	000046fe 	.word	0x000046fe
c0d03374:	000005b7 	.word	0x000005b7

c0d03378 <ui_menu_validation_preprocessor>:
  {NULL,  ui_menu_validation_action,  REJECT, NULL,  "Reject",       "TX",         0, 0},
  {NULL,  ui_menu_validation_action,  ACCEPT, NULL,  "Accept",       "TX",         0, 0},
  UX_MENU_END
};

const bagl_element_t* ui_menu_validation_preprocessor(const ux_menu_entry_t* entry, bagl_element_t* element) {
c0d03378:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0337a:	b081      	sub	sp, #4
c0d0337c:	460c      	mov	r4, r1

  /* --- Amount --- */
  if (entry == &ui_menu_validation[0]) {
c0d0337e:	4956      	ldr	r1, [pc, #344]	; (c0d034d8 <ui_menu_validation_preprocessor+0x160>)
c0d03380:	4479      	add	r1, pc
c0d03382:	4288      	cmp	r0, r1
c0d03384:	d02d      	beq.n	c0d033e2 <ui_menu_validation_preprocessor+0x6a>
    }
  }
#endif

   /* --- Destination --- */
  if (entry == &ui_menu_validation[1]) {
c0d03386:	460a      	mov	r2, r1
c0d03388:	321c      	adds	r2, #28
c0d0338a:	4290      	cmp	r0, r2
c0d0338c:	d031      	beq.n	c0d033f2 <ui_menu_validation_preprocessor+0x7a>
      os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*0, 11);
      element->text = G_monero_vstate.ux_menu;
    }
  }
  if (entry == &ui_menu_validation[2]) {
c0d0338e:	460a      	mov	r2, r1
c0d03390:	3238      	adds	r2, #56	; 0x38
c0d03392:	4290      	cmp	r0, r2
c0d03394:	d042      	beq.n	c0d0341c <ui_menu_validation_preprocessor+0xa4>
    if(element->component.userid==0x22) {
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*2, 11);
    }
    element->text = G_monero_vstate.ux_menu;
  }
  if (entry == &ui_menu_validation[3]) {
c0d03396:	460a      	mov	r2, r1
c0d03398:	3254      	adds	r2, #84	; 0x54
c0d0339a:	4290      	cmp	r0, r2
c0d0339c:	d055      	beq.n	c0d0344a <ui_menu_validation_preprocessor+0xd2>
    if(element->component.userid==0x22) {
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*4, 11);
    }
    element->text = G_monero_vstate.ux_menu;
  }
  if (entry == &ui_menu_validation[4]) {
c0d0339e:	460a      	mov	r2, r1
c0d033a0:	3270      	adds	r2, #112	; 0x70
c0d033a2:	4290      	cmp	r0, r2
c0d033a4:	d068      	beq.n	c0d03478 <ui_menu_validation_preprocessor+0x100>
    if(element->component.userid==0x22) {
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*6, 11);
    }
    element->text = G_monero_vstate.ux_menu;
  }
  if (entry == &ui_menu_validation[5]) {
c0d033a6:	318c      	adds	r1, #140	; 0x8c
c0d033a8:	4288      	cmp	r0, r1
c0d033aa:	d000      	beq.n	c0d033ae <ui_menu_validation_preprocessor+0x36>
c0d033ac:	e081      	b.n	c0d034b2 <ui_menu_validation_preprocessor+0x13a>
c0d033ae:	20db      	movs	r0, #219	; 0xdb
c0d033b0:	00c6      	lsls	r6, r0, #3
    os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
c0d033b2:	4f41      	ldr	r7, [pc, #260]	; (c0d034b8 <ui_menu_validation_preprocessor+0x140>)
c0d033b4:	19bd      	adds	r5, r7, r6
c0d033b6:	2100      	movs	r1, #0
c0d033b8:	2270      	movs	r2, #112	; 0x70
c0d033ba:	4628      	mov	r0, r5
c0d033bc:	f000 fbe0 	bl	c0d03b80 <os_memset>
    if(element->component.userid==0x21) {
c0d033c0:	7860      	ldrb	r0, [r4, #1]
c0d033c2:	2821      	cmp	r0, #33	; 0x21
c0d033c4:	d106      	bne.n	c0d033d4 <ui_menu_validation_preprocessor+0x5c>
c0d033c6:	483d      	ldr	r0, [pc, #244]	; (c0d034bc <ui_menu_validation_preprocessor+0x144>)
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*7, 11);
c0d033c8:	1839      	adds	r1, r7, r0
c0d033ca:	220b      	movs	r2, #11
c0d033cc:	4628      	mov	r0, r5
c0d033ce:	f000 fbe0 	bl	c0d03b92 <os_memmove>
    }
    if(element->component.userid==0x22) {
c0d033d2:	7860      	ldrb	r0, [r4, #1]
c0d033d4:	2822      	cmp	r0, #34	; 0x22
c0d033d6:	d16a      	bne.n	c0d034ae <ui_menu_validation_preprocessor+0x136>
c0d033d8:	203d      	movs	r0, #61	; 0x3d
c0d033da:	0140      	lsls	r0, r0, #5
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*8, 7);
c0d033dc:	1839      	adds	r1, r7, r0
c0d033de:	2207      	movs	r2, #7
c0d033e0:	e062      	b.n	c0d034a8 <ui_menu_validation_preprocessor+0x130>

const bagl_element_t* ui_menu_validation_preprocessor(const ux_menu_entry_t* entry, bagl_element_t* element) {

  /* --- Amount --- */
  if (entry == &ui_menu_validation[0]) {
    if(element->component.userid==0x22) {
c0d033e2:	7860      	ldrb	r0, [r4, #1]
c0d033e4:	2822      	cmp	r0, #34	; 0x22
c0d033e6:	d164      	bne.n	c0d034b2 <ui_menu_validation_preprocessor+0x13a>
c0d033e8:	20f5      	movs	r0, #245	; 0xf5
c0d033ea:	00c0      	lsls	r0, r0, #3
      element->text = G_monero_vstate.ux_amount;
c0d033ec:	4932      	ldr	r1, [pc, #200]	; (c0d034b8 <ui_menu_validation_preprocessor+0x140>)
c0d033ee:	1808      	adds	r0, r1, r0
c0d033f0:	e05e      	b.n	c0d034b0 <ui_menu_validation_preprocessor+0x138>
  }
#endif

   /* --- Destination --- */
  if (entry == &ui_menu_validation[1]) {
    if(element->component.userid==0x22) {
c0d033f2:	7860      	ldrb	r0, [r4, #1]
c0d033f4:	2822      	cmp	r0, #34	; 0x22
c0d033f6:	d15c      	bne.n	c0d034b2 <ui_menu_validation_preprocessor+0x13a>
c0d033f8:	20db      	movs	r0, #219	; 0xdb
c0d033fa:	00c0      	lsls	r0, r0, #3
      os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
c0d033fc:	4e2e      	ldr	r6, [pc, #184]	; (c0d034b8 <ui_menu_validation_preprocessor+0x140>)
c0d033fe:	1835      	adds	r5, r6, r0
c0d03400:	2100      	movs	r1, #0
c0d03402:	2270      	movs	r2, #112	; 0x70
c0d03404:	4628      	mov	r0, r5
c0d03406:	f000 fbbb 	bl	c0d03b80 <os_memset>
c0d0340a:	20e9      	movs	r0, #233	; 0xe9
c0d0340c:	00c0      	lsls	r0, r0, #3
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*0, 11);
c0d0340e:	1831      	adds	r1, r6, r0
c0d03410:	220b      	movs	r2, #11
c0d03412:	4628      	mov	r0, r5
c0d03414:	f000 fbbd 	bl	c0d03b92 <os_memmove>
      element->text = G_monero_vstate.ux_menu;
c0d03418:	61e5      	str	r5, [r4, #28]
c0d0341a:	e04a      	b.n	c0d034b2 <ui_menu_validation_preprocessor+0x13a>
c0d0341c:	20db      	movs	r0, #219	; 0xdb
c0d0341e:	00c6      	lsls	r6, r0, #3
    }
  }
  if (entry == &ui_menu_validation[2]) {
    os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
c0d03420:	4f25      	ldr	r7, [pc, #148]	; (c0d034b8 <ui_menu_validation_preprocessor+0x140>)
c0d03422:	19bd      	adds	r5, r7, r6
c0d03424:	2100      	movs	r1, #0
c0d03426:	2270      	movs	r2, #112	; 0x70
c0d03428:	4628      	mov	r0, r5
c0d0342a:	f000 fba9 	bl	c0d03b80 <os_memset>
    if(element->component.userid==0x21) {
c0d0342e:	7860      	ldrb	r0, [r4, #1]
c0d03430:	2821      	cmp	r0, #33	; 0x21
c0d03432:	d106      	bne.n	c0d03442 <ui_menu_validation_preprocessor+0xca>
c0d03434:	4826      	ldr	r0, [pc, #152]	; (c0d034d0 <ui_menu_validation_preprocessor+0x158>)
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*1, 11);
c0d03436:	1839      	adds	r1, r7, r0
c0d03438:	220b      	movs	r2, #11
c0d0343a:	4628      	mov	r0, r5
c0d0343c:	f000 fba9 	bl	c0d03b92 <os_memmove>
    }
    if(element->component.userid==0x22) {
c0d03440:	7860      	ldrb	r0, [r4, #1]
c0d03442:	2822      	cmp	r0, #34	; 0x22
c0d03444:	d133      	bne.n	c0d034ae <ui_menu_validation_preprocessor+0x136>
c0d03446:	4823      	ldr	r0, [pc, #140]	; (c0d034d4 <ui_menu_validation_preprocessor+0x15c>)
c0d03448:	e02c      	b.n	c0d034a4 <ui_menu_validation_preprocessor+0x12c>
c0d0344a:	20db      	movs	r0, #219	; 0xdb
c0d0344c:	00c6      	lsls	r6, r0, #3
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*2, 11);
    }
    element->text = G_monero_vstate.ux_menu;
  }
  if (entry == &ui_menu_validation[3]) {
    os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
c0d0344e:	4f1a      	ldr	r7, [pc, #104]	; (c0d034b8 <ui_menu_validation_preprocessor+0x140>)
c0d03450:	19bd      	adds	r5, r7, r6
c0d03452:	2100      	movs	r1, #0
c0d03454:	2270      	movs	r2, #112	; 0x70
c0d03456:	4628      	mov	r0, r5
c0d03458:	f000 fb92 	bl	c0d03b80 <os_memset>
    if(element->component.userid==0x21) {
c0d0345c:	7860      	ldrb	r0, [r4, #1]
c0d0345e:	2821      	cmp	r0, #33	; 0x21
c0d03460:	d106      	bne.n	c0d03470 <ui_menu_validation_preprocessor+0xf8>
c0d03462:	4819      	ldr	r0, [pc, #100]	; (c0d034c8 <ui_menu_validation_preprocessor+0x150>)
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*3, 11);
c0d03464:	1839      	adds	r1, r7, r0
c0d03466:	220b      	movs	r2, #11
c0d03468:	4628      	mov	r0, r5
c0d0346a:	f000 fb92 	bl	c0d03b92 <os_memmove>
    }
    if(element->component.userid==0x22) {
c0d0346e:	7860      	ldrb	r0, [r4, #1]
c0d03470:	2822      	cmp	r0, #34	; 0x22
c0d03472:	d11c      	bne.n	c0d034ae <ui_menu_validation_preprocessor+0x136>
c0d03474:	4815      	ldr	r0, [pc, #84]	; (c0d034cc <ui_menu_validation_preprocessor+0x154>)
c0d03476:	e015      	b.n	c0d034a4 <ui_menu_validation_preprocessor+0x12c>
c0d03478:	20db      	movs	r0, #219	; 0xdb
c0d0347a:	00c6      	lsls	r6, r0, #3
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*4, 11);
    }
    element->text = G_monero_vstate.ux_menu;
  }
  if (entry == &ui_menu_validation[4]) {
    os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
c0d0347c:	4f0e      	ldr	r7, [pc, #56]	; (c0d034b8 <ui_menu_validation_preprocessor+0x140>)
c0d0347e:	19bd      	adds	r5, r7, r6
c0d03480:	2100      	movs	r1, #0
c0d03482:	2270      	movs	r2, #112	; 0x70
c0d03484:	4628      	mov	r0, r5
c0d03486:	f000 fb7b 	bl	c0d03b80 <os_memset>
    if(element->component.userid==0x21) {
c0d0348a:	7860      	ldrb	r0, [r4, #1]
c0d0348c:	2821      	cmp	r0, #33	; 0x21
c0d0348e:	d106      	bne.n	c0d0349e <ui_menu_validation_preprocessor+0x126>
c0d03490:	480b      	ldr	r0, [pc, #44]	; (c0d034c0 <ui_menu_validation_preprocessor+0x148>)
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*5, 11);
c0d03492:	1839      	adds	r1, r7, r0
c0d03494:	220b      	movs	r2, #11
c0d03496:	4628      	mov	r0, r5
c0d03498:	f000 fb7b 	bl	c0d03b92 <os_memmove>
    }
    if(element->component.userid==0x22) {
c0d0349c:	7860      	ldrb	r0, [r4, #1]
c0d0349e:	2822      	cmp	r0, #34	; 0x22
c0d034a0:	d105      	bne.n	c0d034ae <ui_menu_validation_preprocessor+0x136>
c0d034a2:	4808      	ldr	r0, [pc, #32]	; (c0d034c4 <ui_menu_validation_preprocessor+0x14c>)
c0d034a4:	1839      	adds	r1, r7, r0
c0d034a6:	220b      	movs	r2, #11
c0d034a8:	4628      	mov	r0, r5
c0d034aa:	f000 fb72 	bl	c0d03b92 <os_memmove>
c0d034ae:	19b8      	adds	r0, r7, r6
c0d034b0:	61e0      	str	r0, [r4, #28]
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*8, 7);
    }
    element->text = G_monero_vstate.ux_menu;
  }

  return element;
c0d034b2:	4620      	mov	r0, r4
c0d034b4:	b001      	add	sp, #4
c0d034b6:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d034b8:	20001930 	.word	0x20001930
c0d034bc:	00000795 	.word	0x00000795
c0d034c0:	0000077f 	.word	0x0000077f
c0d034c4:	0000078a 	.word	0x0000078a
c0d034c8:	00000769 	.word	0x00000769
c0d034cc:	00000774 	.word	0x00000774
c0d034d0:	00000753 	.word	0x00000753
c0d034d4:	0000075e 	.word	0x0000075e
c0d034d8:	00004198 	.word	0x00004198

c0d034dc <ui_menu_validation_display>:
}

void ui_menu_validation_display(unsigned int value) {
c0d034dc:	b580      	push	{r7, lr}
c0d034de:	2000      	movs	r0, #0
  UX_MENU_DISPLAY(0, ui_menu_validation, ui_menu_validation_preprocessor);
c0d034e0:	4903      	ldr	r1, [pc, #12]	; (c0d034f0 <ui_menu_validation_display+0x14>)
c0d034e2:	4479      	add	r1, pc
c0d034e4:	4a03      	ldr	r2, [pc, #12]	; (c0d034f4 <ui_menu_validation_display+0x18>)
c0d034e6:	447a      	add	r2, pc
c0d034e8:	f001 f9b0 	bl	c0d0484c <ux_menu_display>
}
c0d034ec:	bd80      	pop	{r7, pc}
c0d034ee:	46c0      	nop			; (mov r8, r8)
c0d034f0:	00004036 	.word	0x00004036
c0d034f4:	fffffe8f 	.word	0xfffffe8f

c0d034f8 <ui_export_viewkey_display>:
    0, 0,
    NULL, NULL, NULL },

};

void ui_export_viewkey_display(unsigned int value) {
c0d034f8:	b5b0      	push	{r4, r5, r7, lr}
 UX_DISPLAY(ui_export_viewkey, (void*)ui_export_viewkey_prepro);
c0d034fa:	4c23      	ldr	r4, [pc, #140]	; (c0d03588 <ui_export_viewkey_display+0x90>)
c0d034fc:	2005      	movs	r0, #5
c0d034fe:	4924      	ldr	r1, [pc, #144]	; (c0d03590 <ui_export_viewkey_display+0x98>)
c0d03500:	4479      	add	r1, pc
c0d03502:	6021      	str	r1, [r4, #0]
c0d03504:	6060      	str	r0, [r4, #4]
c0d03506:	4823      	ldr	r0, [pc, #140]	; (c0d03594 <ui_export_viewkey_display+0x9c>)
c0d03508:	4478      	add	r0, pc
c0d0350a:	4923      	ldr	r1, [pc, #140]	; (c0d03598 <ui_export_viewkey_display+0xa0>)
c0d0350c:	4479      	add	r1, pc
c0d0350e:	60e1      	str	r1, [r4, #12]
c0d03510:	6120      	str	r0, [r4, #16]
c0d03512:	2003      	movs	r0, #3
c0d03514:	7620      	strb	r0, [r4, #24]
c0d03516:	2500      	movs	r5, #0
c0d03518:	61e5      	str	r5, [r4, #28]
c0d0351a:	4620      	mov	r0, r4
c0d0351c:	3018      	adds	r0, #24
c0d0351e:	f001 fc75 	bl	c0d04e0c <os_ux>
c0d03522:	61e0      	str	r0, [r4, #28]
c0d03524:	f001 fa20 	bl	c0d04968 <ux_check_status_default>
c0d03528:	f000 fd58 	bl	c0d03fdc <io_seproxyhal_init_ux>
c0d0352c:	f000 fd5c 	bl	c0d03fe8 <io_seproxyhal_init_button>
c0d03530:	60a5      	str	r5, [r4, #8]
c0d03532:	6820      	ldr	r0, [r4, #0]
c0d03534:	2800      	cmp	r0, #0
c0d03536:	d026      	beq.n	c0d03586 <ui_export_viewkey_display+0x8e>
c0d03538:	69e0      	ldr	r0, [r4, #28]
c0d0353a:	4914      	ldr	r1, [pc, #80]	; (c0d0358c <ui_export_viewkey_display+0x94>)
c0d0353c:	4288      	cmp	r0, r1
c0d0353e:	d022      	beq.n	c0d03586 <ui_export_viewkey_display+0x8e>
c0d03540:	2800      	cmp	r0, #0
c0d03542:	d020      	beq.n	c0d03586 <ui_export_viewkey_display+0x8e>
c0d03544:	2000      	movs	r0, #0
c0d03546:	6861      	ldr	r1, [r4, #4]
c0d03548:	4288      	cmp	r0, r1
c0d0354a:	d21c      	bcs.n	c0d03586 <ui_export_viewkey_display+0x8e>
c0d0354c:	f001 fcb8 	bl	c0d04ec0 <io_seproxyhal_spi_is_status_sent>
c0d03550:	2800      	cmp	r0, #0
c0d03552:	d118      	bne.n	c0d03586 <ui_export_viewkey_display+0x8e>
c0d03554:	68a0      	ldr	r0, [r4, #8]
c0d03556:	68e1      	ldr	r1, [r4, #12]
c0d03558:	2538      	movs	r5, #56	; 0x38
c0d0355a:	4368      	muls	r0, r5
c0d0355c:	6822      	ldr	r2, [r4, #0]
c0d0355e:	1810      	adds	r0, r2, r0
c0d03560:	2900      	cmp	r1, #0
c0d03562:	d002      	beq.n	c0d0356a <ui_export_viewkey_display+0x72>
c0d03564:	4788      	blx	r1
c0d03566:	2800      	cmp	r0, #0
c0d03568:	d007      	beq.n	c0d0357a <ui_export_viewkey_display+0x82>
c0d0356a:	2801      	cmp	r0, #1
c0d0356c:	d103      	bne.n	c0d03576 <ui_export_viewkey_display+0x7e>
c0d0356e:	68a0      	ldr	r0, [r4, #8]
c0d03570:	4345      	muls	r5, r0
c0d03572:	6820      	ldr	r0, [r4, #0]
c0d03574:	1940      	adds	r0, r0, r5
 // setup the first screen changing
  UX_CALLBACK_SET_INTERVAL(1000);
}

void io_seproxyhal_display(const bagl_element_t *element) {
  io_seproxyhal_display_default((bagl_element_t *)element);
c0d03576:	f000 fe7b 	bl	c0d04270 <io_seproxyhal_display_default>
    NULL, NULL, NULL },

};

void ui_export_viewkey_display(unsigned int value) {
 UX_DISPLAY(ui_export_viewkey, (void*)ui_export_viewkey_prepro);
c0d0357a:	68a0      	ldr	r0, [r4, #8]
c0d0357c:	1c40      	adds	r0, r0, #1
c0d0357e:	60a0      	str	r0, [r4, #8]
c0d03580:	6821      	ldr	r1, [r4, #0]
c0d03582:	2900      	cmp	r1, #0
c0d03584:	d1df      	bne.n	c0d03546 <ui_export_viewkey_display+0x4e>
}
c0d03586:	bdb0      	pop	{r4, r5, r7, pc}
c0d03588:	20001880 	.word	0x20001880
c0d0358c:	b0105044 	.word	0xb0105044
c0d03590:	00004114 	.word	0x00004114
c0d03594:	00000091 	.word	0x00000091
c0d03598:	000000f9 	.word	0x000000f9

c0d0359c <ui_export_viewkey_button>:
  }
  snprintf(G_monero_vstate.ux_menu, sizeof(G_monero_vstate.ux_menu), "Please Cancel");
  return 1;
}

unsigned int ui_export_viewkey_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d0359c:	b5b0      	push	{r4, r5, r7, lr}
c0d0359e:	b088      	sub	sp, #32
c0d035a0:	4604      	mov	r4, r0
c0d035a2:	2500      	movs	r5, #0
  unsigned int sw;
  unsigned char x[32];

  monero_io_discard(0);
c0d035a4:	4628      	mov	r0, r5
c0d035a6:	f7fd ff99 	bl	c0d014dc <monero_io_discard>
c0d035aa:	4668      	mov	r0, sp
c0d035ac:	2220      	movs	r2, #32
  os_memset(x,0,32);
c0d035ae:	4629      	mov	r1, r5
c0d035b0:	f000 fae6 	bl	c0d03b80 <os_memset>
c0d035b4:	480f      	ldr	r0, [pc, #60]	; (c0d035f4 <ui_export_viewkey_button+0x58>)
  sw = 0x9000;

  switch(button_mask) {
c0d035b6:	4284      	cmp	r4, r0
c0d035b8:	d004      	beq.n	c0d035c4 <ui_export_viewkey_button+0x28>
c0d035ba:	480f      	ldr	r0, [pc, #60]	; (c0d035f8 <ui_export_viewkey_button+0x5c>)
c0d035bc:	4284      	cmp	r4, r0
c0d035be:	d116      	bne.n	c0d035ee <ui_export_viewkey_button+0x52>
c0d035c0:	4668      	mov	r0, sp
c0d035c2:	e003      	b.n	c0d035cc <ui_export_viewkey_button+0x30>
c0d035c4:	2051      	movs	r0, #81	; 0x51
c0d035c6:	0080      	lsls	r0, r0, #2
  case BUTTON_EVT_RELEASED|BUTTON_LEFT: // CANCEL
    monero_io_insert(x, 32);
    break;

  case BUTTON_EVT_RELEASED|BUTTON_RIGHT:  // OK
    monero_io_insert(G_monero_vstate.a, 32);
c0d035c8:	490c      	ldr	r1, [pc, #48]	; (c0d035fc <ui_export_viewkey_button+0x60>)
c0d035ca:	1808      	adds	r0, r1, r0
c0d035cc:	2120      	movs	r1, #32
c0d035ce:	f7fd ffb1 	bl	c0d01534 <monero_io_insert>
c0d035d2:	2009      	movs	r0, #9
c0d035d4:	0300      	lsls	r0, r0, #12
    break;

  default:
    return 0;
  }
  monero_io_insert_u16(sw);
c0d035d6:	f7fd fff9 	bl	c0d015cc <monero_io_insert_u16>
c0d035da:	2020      	movs	r0, #32
  monero_io_do(IO_RETURN_AFTER_TX);
c0d035dc:	f7fe f8ba 	bl	c0d01754 <monero_io_do>
c0d035e0:	2000      	movs	r0, #0
    }
  }
  return element;
}
void ui_menu_main_display(unsigned int value) {
   UX_MENU_DISPLAY(value, ui_menu_main, ui_menu_main_preprocessor);
c0d035e2:	4907      	ldr	r1, [pc, #28]	; (c0d03600 <ui_export_viewkey_button+0x64>)
c0d035e4:	4479      	add	r1, pc
c0d035e6:	4a07      	ldr	r2, [pc, #28]	; (c0d03604 <ui_export_viewkey_button+0x68>)
c0d035e8:	447a      	add	r2, pc
c0d035ea:	f001 f92f 	bl	c0d0484c <ux_menu_display>
c0d035ee:	2000      	movs	r0, #0
  }
  monero_io_insert_u16(sw);
  monero_io_do(IO_RETURN_AFTER_TX);
  ui_menu_main_display(0);
  return 0;
}
c0d035f0:	b008      	add	sp, #32
c0d035f2:	bdb0      	pop	{r4, r5, r7, pc}
c0d035f4:	80000002 	.word	0x80000002
c0d035f8:	80000001 	.word	0x80000001
c0d035fc:	20001930 	.word	0x20001930
c0d03600:	00004474 	.word	0x00004474
c0d03604:	0000032d 	.word	0x0000032d

c0d03608 <ui_export_viewkey_prepro>:

void ui_export_viewkey_display(unsigned int value) {
 UX_DISPLAY(ui_export_viewkey, (void*)ui_export_viewkey_prepro);
}

unsigned int ui_export_viewkey_prepro(const  bagl_element_t* element) {
c0d03608:	b510      	push	{r4, lr}
  if (element->component.userid == 1) {
c0d0360a:	7840      	ldrb	r0, [r0, #1]
c0d0360c:	2802      	cmp	r0, #2
c0d0360e:	d00b      	beq.n	c0d03628 <ui_export_viewkey_prepro+0x20>
c0d03610:	2801      	cmp	r0, #1
c0d03612:	d114      	bne.n	c0d0363e <ui_export_viewkey_prepro+0x36>
c0d03614:	20db      	movs	r0, #219	; 0xdb
c0d03616:	00c0      	lsls	r0, r0, #3
    snprintf(G_monero_vstate.ux_menu, sizeof(G_monero_vstate.ux_menu), "Export");
c0d03618:	490f      	ldr	r1, [pc, #60]	; (c0d03658 <ui_export_viewkey_prepro+0x50>)
c0d0361a:	1808      	adds	r0, r1, r0
c0d0361c:	490f      	ldr	r1, [pc, #60]	; (c0d0365c <ui_export_viewkey_prepro+0x54>)
c0d0361e:	4479      	add	r1, pc
c0d03620:	2207      	movs	r2, #7
c0d03622:	f003 f933 	bl	c0d0688c <__aeabi_memcpy>
c0d03626:	e014      	b.n	c0d03652 <ui_export_viewkey_prepro+0x4a>
c0d03628:	20db      	movs	r0, #219	; 0xdb
c0d0362a:	00c0      	lsls	r0, r0, #3
    return 1;
  }
  if (element->component.userid == 2) {
    snprintf(G_monero_vstate.ux_menu, sizeof(G_monero_vstate.ux_menu), "View Key");
c0d0362c:	490a      	ldr	r1, [pc, #40]	; (c0d03658 <ui_export_viewkey_prepro+0x50>)
c0d0362e:	1808      	adds	r0, r1, r0
c0d03630:	490b      	ldr	r1, [pc, #44]	; (c0d03660 <ui_export_viewkey_prepro+0x58>)
c0d03632:	4479      	add	r1, pc
c0d03634:	c90c      	ldmia	r1!, {r2, r3}
c0d03636:	c00c      	stmia	r0!, {r2, r3}
c0d03638:	7809      	ldrb	r1, [r1, #0]
c0d0363a:	7001      	strb	r1, [r0, #0]
c0d0363c:	e009      	b.n	c0d03652 <ui_export_viewkey_prepro+0x4a>
c0d0363e:	20db      	movs	r0, #219	; 0xdb
c0d03640:	00c0      	lsls	r0, r0, #3
    return 1;
  }
  snprintf(G_monero_vstate.ux_menu, sizeof(G_monero_vstate.ux_menu), "Please Cancel");
c0d03642:	4905      	ldr	r1, [pc, #20]	; (c0d03658 <ui_export_viewkey_prepro+0x50>)
c0d03644:	1808      	adds	r0, r1, r0
c0d03646:	4907      	ldr	r1, [pc, #28]	; (c0d03664 <ui_export_viewkey_prepro+0x5c>)
c0d03648:	4479      	add	r1, pc
c0d0364a:	c91c      	ldmia	r1!, {r2, r3, r4}
c0d0364c:	c01c      	stmia	r0!, {r2, r3, r4}
c0d0364e:	8809      	ldrh	r1, [r1, #0]
c0d03650:	8001      	strh	r1, [r0, #0]
c0d03652:	2001      	movs	r0, #1
  return 1;
}
c0d03654:	bd10      	pop	{r4, pc}
c0d03656:	46c0      	nop			; (mov r8, r8)
c0d03658:	20001930 	.word	0x20001930
c0d0365c:	00003b41 	.word	0x00003b41
c0d03660:	000040fa 	.word	0x000040fa
c0d03664:	000040f0 	.word	0x000040f0

c0d03668 <io_seproxyhal_display>:
 ui_menu_main_display(0);
 // setup the first screen changing
  UX_CALLBACK_SET_INTERVAL(1000);
}

void io_seproxyhal_display(const bagl_element_t *element) {
c0d03668:	b580      	push	{r7, lr}
  io_seproxyhal_display_default((bagl_element_t *)element);
c0d0366a:	f000 fe01 	bl	c0d04270 <io_seproxyhal_display_default>
}
c0d0366e:	bd80      	pop	{r7, pc}

c0d03670 <ui_menu_network_action>:
    element->text = G_monero_vstate.ux_menu;
  }
  return element;
}

void ui_menu_network_action(unsigned int value) {
c0d03670:	b580      	push	{r7, lr}
  monero_install(value);
c0d03672:	b2c0      	uxtb	r0, r0
c0d03674:	f7fd fe2e 	bl	c0d012d4 <monero_install>
  monero_init();
c0d03678:	f7fd fe08 	bl	c0d0128c <monero_init>
c0d0367c:	2000      	movs	r0, #0
    }
  }
  return element;
}
void ui_menu_main_display(unsigned int value) {
   UX_MENU_DISPLAY(value, ui_menu_main, ui_menu_main_preprocessor);
c0d0367e:	4903      	ldr	r1, [pc, #12]	; (c0d0368c <ui_menu_network_action+0x1c>)
c0d03680:	4479      	add	r1, pc
c0d03682:	4a03      	ldr	r2, [pc, #12]	; (c0d03690 <ui_menu_network_action+0x20>)
c0d03684:	447a      	add	r2, pc
c0d03686:	f001 f8e1 	bl	c0d0484c <ux_menu_display>

void ui_menu_network_action(unsigned int value) {
  monero_install(value);
  monero_init();
  ui_menu_main_display(0);
}
c0d0368a:	bd80      	pop	{r7, pc}
c0d0368c:	000043d8 	.word	0x000043d8
c0d03690:	00000291 	.word	0x00000291

c0d03694 <ui_menu_network_preprocessor>:
  {NULL,   ui_menu_network_action, STAGENET, NULL, "Stage Network", NULL,          0, 0},
  {NULL,   ui_menu_network_action, MAINNET,  NULL, "Main Network",  NULL,          0, 0},
  UX_MENU_END
};

const bagl_element_t* ui_menu_network_preprocessor(const ux_menu_entry_t* entry, bagl_element_t* element) {
c0d03694:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03696:	b081      	sub	sp, #4
c0d03698:	460c      	mov	r4, r1
c0d0369a:	4606      	mov	r6, r0
c0d0369c:	20db      	movs	r0, #219	; 0xdb
c0d0369e:	00c0      	lsls	r0, r0, #3
  os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu));
c0d036a0:	4f20      	ldr	r7, [pc, #128]	; (c0d03724 <ui_menu_network_preprocessor+0x90>)
c0d036a2:	183d      	adds	r5, r7, r0
c0d036a4:	2100      	movs	r1, #0
c0d036a6:	2270      	movs	r2, #112	; 0x70
c0d036a8:	4628      	mov	r0, r5
c0d036aa:	f000 fa69 	bl	c0d03b80 <os_memset>
  if ((entry == &ui_menu_network[2]) && (element->component.userid==0x20) && (N_monero_pstate->network_id == TESTNET)) {
c0d036ae:	4820      	ldr	r0, [pc, #128]	; (c0d03730 <ui_menu_network_preprocessor+0x9c>)
c0d036b0:	4478      	add	r0, pc
c0d036b2:	4601      	mov	r1, r0
c0d036b4:	3138      	adds	r1, #56	; 0x38
c0d036b6:	428e      	cmp	r6, r1
c0d036b8:	d012      	beq.n	c0d036e0 <ui_menu_network_preprocessor+0x4c>
    os_memmove(G_monero_vstate.ux_menu, "Test Network  ", 14);
    G_monero_vstate.ux_menu[13] = '+';
    element->text = G_monero_vstate.ux_menu;
  }
  if ((entry == &ui_menu_network[3]) && (element->component.userid==0x20) && (N_monero_pstate->network_id == STAGENET)) {
c0d036ba:	4601      	mov	r1, r0
c0d036bc:	3154      	adds	r1, #84	; 0x54
c0d036be:	428e      	cmp	r6, r1
c0d036c0:	d01a      	beq.n	c0d036f8 <ui_menu_network_preprocessor+0x64>
    os_memmove(G_monero_vstate.ux_menu, "Stage Network ", 14);
    G_monero_vstate.ux_menu[13] = '+';
    element->text = G_monero_vstate.ux_menu;
  }
  if ((entry == &ui_menu_network[4]) && (element->component.userid==0x20) && (N_monero_pstate->network_id == MAINNET)) {
c0d036c2:	3070      	adds	r0, #112	; 0x70
c0d036c4:	4286      	cmp	r6, r0
c0d036c6:	d12a      	bne.n	c0d0371e <ui_menu_network_preprocessor+0x8a>
c0d036c8:	7860      	ldrb	r0, [r4, #1]
c0d036ca:	2820      	cmp	r0, #32
c0d036cc:	d127      	bne.n	c0d0371e <ui_menu_network_preprocessor+0x8a>
c0d036ce:	4816      	ldr	r0, [pc, #88]	; (c0d03728 <ui_menu_network_preprocessor+0x94>)
c0d036d0:	f001 f94c 	bl	c0d0496c <pic>
c0d036d4:	7a00      	ldrb	r0, [r0, #8]
c0d036d6:	2800      	cmp	r0, #0
c0d036d8:	d121      	bne.n	c0d0371e <ui_menu_network_preprocessor+0x8a>
    os_memmove(G_monero_vstate.ux_menu, "Main Network  ", 14);
c0d036da:	4918      	ldr	r1, [pc, #96]	; (c0d0373c <ui_menu_network_preprocessor+0xa8>)
c0d036dc:	4479      	add	r1, pc
c0d036de:	e016      	b.n	c0d0370e <ui_menu_network_preprocessor+0x7a>
  UX_MENU_END
};

const bagl_element_t* ui_menu_network_preprocessor(const ux_menu_entry_t* entry, bagl_element_t* element) {
  os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu));
  if ((entry == &ui_menu_network[2]) && (element->component.userid==0x20) && (N_monero_pstate->network_id == TESTNET)) {
c0d036e0:	7860      	ldrb	r0, [r4, #1]
c0d036e2:	2820      	cmp	r0, #32
c0d036e4:	d11b      	bne.n	c0d0371e <ui_menu_network_preprocessor+0x8a>
c0d036e6:	4810      	ldr	r0, [pc, #64]	; (c0d03728 <ui_menu_network_preprocessor+0x94>)
c0d036e8:	f001 f940 	bl	c0d0496c <pic>
c0d036ec:	7a00      	ldrb	r0, [r0, #8]
c0d036ee:	2801      	cmp	r0, #1
c0d036f0:	d115      	bne.n	c0d0371e <ui_menu_network_preprocessor+0x8a>
    os_memmove(G_monero_vstate.ux_menu, "Test Network  ", 14);
c0d036f2:	4910      	ldr	r1, [pc, #64]	; (c0d03734 <ui_menu_network_preprocessor+0xa0>)
c0d036f4:	4479      	add	r1, pc
c0d036f6:	e00a      	b.n	c0d0370e <ui_menu_network_preprocessor+0x7a>
    G_monero_vstate.ux_menu[13] = '+';
    element->text = G_monero_vstate.ux_menu;
  }
  if ((entry == &ui_menu_network[3]) && (element->component.userid==0x20) && (N_monero_pstate->network_id == STAGENET)) {
c0d036f8:	7860      	ldrb	r0, [r4, #1]
c0d036fa:	2820      	cmp	r0, #32
c0d036fc:	d10f      	bne.n	c0d0371e <ui_menu_network_preprocessor+0x8a>
c0d036fe:	480a      	ldr	r0, [pc, #40]	; (c0d03728 <ui_menu_network_preprocessor+0x94>)
c0d03700:	f001 f934 	bl	c0d0496c <pic>
c0d03704:	7a00      	ldrb	r0, [r0, #8]
c0d03706:	2802      	cmp	r0, #2
c0d03708:	d109      	bne.n	c0d0371e <ui_menu_network_preprocessor+0x8a>
    os_memmove(G_monero_vstate.ux_menu, "Stage Network ", 14);
c0d0370a:	490b      	ldr	r1, [pc, #44]	; (c0d03738 <ui_menu_network_preprocessor+0xa4>)
c0d0370c:	4479      	add	r1, pc
c0d0370e:	220e      	movs	r2, #14
c0d03710:	4628      	mov	r0, r5
c0d03712:	f000 fa3e 	bl	c0d03b92 <os_memmove>
c0d03716:	4805      	ldr	r0, [pc, #20]	; (c0d0372c <ui_menu_network_preprocessor+0x98>)
c0d03718:	212b      	movs	r1, #43	; 0x2b
c0d0371a:	5439      	strb	r1, [r7, r0]
c0d0371c:	61e5      	str	r5, [r4, #28]
  if ((entry == &ui_menu_network[4]) && (element->component.userid==0x20) && (N_monero_pstate->network_id == MAINNET)) {
    os_memmove(G_monero_vstate.ux_menu, "Main Network  ", 14);
    G_monero_vstate.ux_menu[13] = '+';
    element->text = G_monero_vstate.ux_menu;
  }
  return element;
c0d0371e:	4620      	mov	r0, r4
c0d03720:	b001      	add	sp, #4
c0d03722:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d03724:	20001930 	.word	0x20001930
c0d03728:	c0d07ec0 	.word	0xc0d07ec0
c0d0372c:	000006e5 	.word	0x000006e5
c0d03730:	00004098 	.word	0x00004098
c0d03734:	00003ac0 	.word	0x00003ac0
c0d03738:	00003ab7 	.word	0x00003ab7
c0d0373c:	00003af6 	.word	0x00003af6

c0d03740 <ui_menu_network_display>:
  monero_install(value);
  monero_init();
  ui_menu_main_display(0);
}

void ui_menu_network_display(unsigned int value) {
c0d03740:	b580      	push	{r7, lr}
   UX_MENU_DISPLAY(value, ui_menu_network, ui_menu_network_preprocessor);
c0d03742:	4903      	ldr	r1, [pc, #12]	; (c0d03750 <ui_menu_network_display+0x10>)
c0d03744:	4479      	add	r1, pc
c0d03746:	4a03      	ldr	r2, [pc, #12]	; (c0d03754 <ui_menu_network_display+0x14>)
c0d03748:	447a      	add	r2, pc
c0d0374a:	f001 f87f 	bl	c0d0484c <ux_menu_display>
}
c0d0374e:	bd80      	pop	{r7, pc}
c0d03750:	00004004 	.word	0x00004004
c0d03754:	ffffff49 	.word	0xffffff49

c0d03758 <ui_menu_reset_action>:
  {NULL,   ui_menu_main_display, 0, &C_badge_back, "No",         NULL, 61, 40},
  {NULL,   ui_menu_reset_action, 0, NULL,          "Yes",           NULL, 0, 0},
  UX_MENU_END
};

void ui_menu_reset_action(unsigned int value) {
c0d03758:	b510      	push	{r4, lr}
c0d0375a:	b082      	sub	sp, #8
c0d0375c:	2400      	movs	r4, #0
  unsigned char magic[4];
  magic[0] = 0; magic[1] = 0; magic[2] = 0; magic[3] = 0;
c0d0375e:	9401      	str	r4, [sp, #4]
  monero_nvm_write(N_monero_pstate->magic, magic, 4);
c0d03760:	4808      	ldr	r0, [pc, #32]	; (c0d03784 <ui_menu_reset_action+0x2c>)
c0d03762:	f001 f903 	bl	c0d0496c <pic>
c0d03766:	a901      	add	r1, sp, #4
c0d03768:	2204      	movs	r2, #4
c0d0376a:	f001 f941 	bl	c0d049f0 <nvm_write>
  monero_init();
c0d0376e:	f7fd fd8d 	bl	c0d0128c <monero_init>
    }
  }
  return element;
}
void ui_menu_main_display(unsigned int value) {
   UX_MENU_DISPLAY(value, ui_menu_main, ui_menu_main_preprocessor);
c0d03772:	4905      	ldr	r1, [pc, #20]	; (c0d03788 <ui_menu_reset_action+0x30>)
c0d03774:	4479      	add	r1, pc
c0d03776:	4a05      	ldr	r2, [pc, #20]	; (c0d0378c <ui_menu_reset_action+0x34>)
c0d03778:	447a      	add	r2, pc
c0d0377a:	4620      	mov	r0, r4
c0d0377c:	f001 f866 	bl	c0d0484c <ux_menu_display>
  unsigned char magic[4];
  magic[0] = 0; magic[1] = 0; magic[2] = 0; magic[3] = 0;
  monero_nvm_write(N_monero_pstate->magic, magic, 4);
  monero_init();
  ui_menu_main_display(0);
}
c0d03780:	b002      	add	sp, #8
c0d03782:	bd10      	pop	{r4, pc}
c0d03784:	c0d07ec0 	.word	0xc0d07ec0
c0d03788:	000042e4 	.word	0x000042e4
c0d0378c:	0000019d 	.word	0x0000019d

c0d03790 <ui_menu_pubaddr_preprocessor>:
  {NULL,  NULL,                  7,          NULL,  "?addr.5?",     "?addr.5?",   0, 0},
  {NULL,  ui_menu_main_display,  0, &C_badge_back, "Back",                     NULL, 61, 40},
  UX_MENU_END
};

const bagl_element_t* ui_menu_pubaddr_preprocessor(const ux_menu_entry_t* entry, bagl_element_t* element) {
c0d03790:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03792:	b081      	sub	sp, #4
c0d03794:	460c      	mov	r4, r1

   /* --- address --- */
  if (entry == &ui_menu_pubaddr[0]) {
c0d03796:	4950      	ldr	r1, [pc, #320]	; (c0d038d8 <ui_menu_pubaddr_preprocessor+0x148>)
c0d03798:	4479      	add	r1, pc
c0d0379a:	4288      	cmp	r0, r1
c0d0379c:	d028      	beq.n	c0d037f0 <ui_menu_pubaddr_preprocessor+0x60>
      os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*0, 11);
      element->text = G_monero_vstate.ux_menu;
    }
  }
  if (entry == &ui_menu_pubaddr[1]) {
c0d0379e:	460a      	mov	r2, r1
c0d037a0:	321c      	adds	r2, #28
c0d037a2:	4290      	cmp	r0, r2
c0d037a4:	d039      	beq.n	c0d0381a <ui_menu_pubaddr_preprocessor+0x8a>
    if(element->component.userid==0x22) {
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*2, 11);
    }
    element->text = G_monero_vstate.ux_menu;
  }
  if (entry == &ui_menu_pubaddr[2]) {
c0d037a6:	460a      	mov	r2, r1
c0d037a8:	3238      	adds	r2, #56	; 0x38
c0d037aa:	4290      	cmp	r0, r2
c0d037ac:	d04c      	beq.n	c0d03848 <ui_menu_pubaddr_preprocessor+0xb8>
    if(element->component.userid==0x22) {
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*4, 11);
    }
    element->text = G_monero_vstate.ux_menu;
  }
  if (entry == &ui_menu_pubaddr[3]) {
c0d037ae:	460a      	mov	r2, r1
c0d037b0:	3254      	adds	r2, #84	; 0x54
c0d037b2:	4290      	cmp	r0, r2
c0d037b4:	d05f      	beq.n	c0d03876 <ui_menu_pubaddr_preprocessor+0xe6>
    if(element->component.userid==0x22) {
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*6, 11);
    }
    element->text = G_monero_vstate.ux_menu;
  }
  if (entry == &ui_menu_pubaddr[4]) {
c0d037b6:	3170      	adds	r1, #112	; 0x70
c0d037b8:	4288      	cmp	r0, r1
c0d037ba:	d179      	bne.n	c0d038b0 <ui_menu_pubaddr_preprocessor+0x120>
c0d037bc:	20db      	movs	r0, #219	; 0xdb
c0d037be:	00c6      	lsls	r6, r0, #3
    os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
c0d037c0:	4f3d      	ldr	r7, [pc, #244]	; (c0d038b8 <ui_menu_pubaddr_preprocessor+0x128>)
c0d037c2:	19bd      	adds	r5, r7, r6
c0d037c4:	2100      	movs	r1, #0
c0d037c6:	2270      	movs	r2, #112	; 0x70
c0d037c8:	4628      	mov	r0, r5
c0d037ca:	f000 f9d9 	bl	c0d03b80 <os_memset>
    if(element->component.userid==0x21) {
c0d037ce:	7860      	ldrb	r0, [r4, #1]
c0d037d0:	2821      	cmp	r0, #33	; 0x21
c0d037d2:	d106      	bne.n	c0d037e2 <ui_menu_pubaddr_preprocessor+0x52>
c0d037d4:	4839      	ldr	r0, [pc, #228]	; (c0d038bc <ui_menu_pubaddr_preprocessor+0x12c>)
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*7, 11);
c0d037d6:	1839      	adds	r1, r7, r0
c0d037d8:	220b      	movs	r2, #11
c0d037da:	4628      	mov	r0, r5
c0d037dc:	f000 f9d9 	bl	c0d03b92 <os_memmove>
    }
    if(element->component.userid==0x22) {
c0d037e0:	7860      	ldrb	r0, [r4, #1]
c0d037e2:	2822      	cmp	r0, #34	; 0x22
c0d037e4:	d162      	bne.n	c0d038ac <ui_menu_pubaddr_preprocessor+0x11c>
c0d037e6:	203d      	movs	r0, #61	; 0x3d
c0d037e8:	0140      	lsls	r0, r0, #5
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*8, 7);
c0d037ea:	1839      	adds	r1, r7, r0
c0d037ec:	2207      	movs	r2, #7
c0d037ee:	e05a      	b.n	c0d038a6 <ui_menu_pubaddr_preprocessor+0x116>

const bagl_element_t* ui_menu_pubaddr_preprocessor(const ux_menu_entry_t* entry, bagl_element_t* element) {

   /* --- address --- */
  if (entry == &ui_menu_pubaddr[0]) {
    if(element->component.userid==0x22) {
c0d037f0:	7860      	ldrb	r0, [r4, #1]
c0d037f2:	2822      	cmp	r0, #34	; 0x22
c0d037f4:	d15c      	bne.n	c0d038b0 <ui_menu_pubaddr_preprocessor+0x120>
c0d037f6:	20db      	movs	r0, #219	; 0xdb
c0d037f8:	00c0      	lsls	r0, r0, #3
      os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
c0d037fa:	4e2f      	ldr	r6, [pc, #188]	; (c0d038b8 <ui_menu_pubaddr_preprocessor+0x128>)
c0d037fc:	1835      	adds	r5, r6, r0
c0d037fe:	2100      	movs	r1, #0
c0d03800:	2270      	movs	r2, #112	; 0x70
c0d03802:	4628      	mov	r0, r5
c0d03804:	f000 f9bc 	bl	c0d03b80 <os_memset>
c0d03808:	20e9      	movs	r0, #233	; 0xe9
c0d0380a:	00c0      	lsls	r0, r0, #3
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*0, 11);
c0d0380c:	1831      	adds	r1, r6, r0
c0d0380e:	220b      	movs	r2, #11
c0d03810:	4628      	mov	r0, r5
c0d03812:	f000 f9be 	bl	c0d03b92 <os_memmove>
      element->text = G_monero_vstate.ux_menu;
c0d03816:	61e5      	str	r5, [r4, #28]
c0d03818:	e04a      	b.n	c0d038b0 <ui_menu_pubaddr_preprocessor+0x120>
c0d0381a:	20db      	movs	r0, #219	; 0xdb
c0d0381c:	00c6      	lsls	r6, r0, #3
    }
  }
  if (entry == &ui_menu_pubaddr[1]) {
    os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
c0d0381e:	4f26      	ldr	r7, [pc, #152]	; (c0d038b8 <ui_menu_pubaddr_preprocessor+0x128>)
c0d03820:	19bd      	adds	r5, r7, r6
c0d03822:	2100      	movs	r1, #0
c0d03824:	2270      	movs	r2, #112	; 0x70
c0d03826:	4628      	mov	r0, r5
c0d03828:	f000 f9aa 	bl	c0d03b80 <os_memset>
    if(element->component.userid==0x21) {
c0d0382c:	7860      	ldrb	r0, [r4, #1]
c0d0382e:	2821      	cmp	r0, #33	; 0x21
c0d03830:	d106      	bne.n	c0d03840 <ui_menu_pubaddr_preprocessor+0xb0>
c0d03832:	4827      	ldr	r0, [pc, #156]	; (c0d038d0 <ui_menu_pubaddr_preprocessor+0x140>)
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*1, 11);
c0d03834:	1839      	adds	r1, r7, r0
c0d03836:	220b      	movs	r2, #11
c0d03838:	4628      	mov	r0, r5
c0d0383a:	f000 f9aa 	bl	c0d03b92 <os_memmove>
    }
    if(element->component.userid==0x22) {
c0d0383e:	7860      	ldrb	r0, [r4, #1]
c0d03840:	2822      	cmp	r0, #34	; 0x22
c0d03842:	d133      	bne.n	c0d038ac <ui_menu_pubaddr_preprocessor+0x11c>
c0d03844:	4823      	ldr	r0, [pc, #140]	; (c0d038d4 <ui_menu_pubaddr_preprocessor+0x144>)
c0d03846:	e02c      	b.n	c0d038a2 <ui_menu_pubaddr_preprocessor+0x112>
c0d03848:	20db      	movs	r0, #219	; 0xdb
c0d0384a:	00c6      	lsls	r6, r0, #3
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*2, 11);
    }
    element->text = G_monero_vstate.ux_menu;
  }
  if (entry == &ui_menu_pubaddr[2]) {
    os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
c0d0384c:	4f1a      	ldr	r7, [pc, #104]	; (c0d038b8 <ui_menu_pubaddr_preprocessor+0x128>)
c0d0384e:	19bd      	adds	r5, r7, r6
c0d03850:	2100      	movs	r1, #0
c0d03852:	2270      	movs	r2, #112	; 0x70
c0d03854:	4628      	mov	r0, r5
c0d03856:	f000 f993 	bl	c0d03b80 <os_memset>
    if(element->component.userid==0x21) {
c0d0385a:	7860      	ldrb	r0, [r4, #1]
c0d0385c:	2821      	cmp	r0, #33	; 0x21
c0d0385e:	d106      	bne.n	c0d0386e <ui_menu_pubaddr_preprocessor+0xde>
c0d03860:	4819      	ldr	r0, [pc, #100]	; (c0d038c8 <ui_menu_pubaddr_preprocessor+0x138>)
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*3, 11);
c0d03862:	1839      	adds	r1, r7, r0
c0d03864:	220b      	movs	r2, #11
c0d03866:	4628      	mov	r0, r5
c0d03868:	f000 f993 	bl	c0d03b92 <os_memmove>
    }
    if(element->component.userid==0x22) {
c0d0386c:	7860      	ldrb	r0, [r4, #1]
c0d0386e:	2822      	cmp	r0, #34	; 0x22
c0d03870:	d11c      	bne.n	c0d038ac <ui_menu_pubaddr_preprocessor+0x11c>
c0d03872:	4816      	ldr	r0, [pc, #88]	; (c0d038cc <ui_menu_pubaddr_preprocessor+0x13c>)
c0d03874:	e015      	b.n	c0d038a2 <ui_menu_pubaddr_preprocessor+0x112>
c0d03876:	20db      	movs	r0, #219	; 0xdb
c0d03878:	00c6      	lsls	r6, r0, #3
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*4, 11);
    }
    element->text = G_monero_vstate.ux_menu;
  }
  if (entry == &ui_menu_pubaddr[3]) {
    os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
c0d0387a:	4f0f      	ldr	r7, [pc, #60]	; (c0d038b8 <ui_menu_pubaddr_preprocessor+0x128>)
c0d0387c:	19bd      	adds	r5, r7, r6
c0d0387e:	2100      	movs	r1, #0
c0d03880:	2270      	movs	r2, #112	; 0x70
c0d03882:	4628      	mov	r0, r5
c0d03884:	f000 f97c 	bl	c0d03b80 <os_memset>
    if(element->component.userid==0x21) {
c0d03888:	7860      	ldrb	r0, [r4, #1]
c0d0388a:	2821      	cmp	r0, #33	; 0x21
c0d0388c:	d106      	bne.n	c0d0389c <ui_menu_pubaddr_preprocessor+0x10c>
c0d0388e:	480c      	ldr	r0, [pc, #48]	; (c0d038c0 <ui_menu_pubaddr_preprocessor+0x130>)
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*5, 11);
c0d03890:	1839      	adds	r1, r7, r0
c0d03892:	220b      	movs	r2, #11
c0d03894:	4628      	mov	r0, r5
c0d03896:	f000 f97c 	bl	c0d03b92 <os_memmove>
    }
    if(element->component.userid==0x22) {
c0d0389a:	7860      	ldrb	r0, [r4, #1]
c0d0389c:	2822      	cmp	r0, #34	; 0x22
c0d0389e:	d105      	bne.n	c0d038ac <ui_menu_pubaddr_preprocessor+0x11c>
c0d038a0:	4808      	ldr	r0, [pc, #32]	; (c0d038c4 <ui_menu_pubaddr_preprocessor+0x134>)
c0d038a2:	1839      	adds	r1, r7, r0
c0d038a4:	220b      	movs	r2, #11
c0d038a6:	4628      	mov	r0, r5
c0d038a8:	f000 f973 	bl	c0d03b92 <os_memmove>
c0d038ac:	19b8      	adds	r0, r7, r6
c0d038ae:	61e0      	str	r0, [r4, #28]
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*8, 7);
    }
    element->text = G_monero_vstate.ux_menu;
  }

  return element;
c0d038b0:	4620      	mov	r0, r4
c0d038b2:	b001      	add	sp, #4
c0d038b4:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d038b6:	46c0      	nop			; (mov r8, r8)
c0d038b8:	20001930 	.word	0x20001930
c0d038bc:	00000795 	.word	0x00000795
c0d038c0:	0000077f 	.word	0x0000077f
c0d038c4:	0000078a 	.word	0x0000078a
c0d038c8:	00000769 	.word	0x00000769
c0d038cc:	00000774 	.word	0x00000774
c0d038d0:	00000753 	.word	0x00000753
c0d038d4:	0000075e 	.word	0x0000075e
c0d038d8:	000041fc 	.word	0x000041fc

c0d038dc <ui_menu_pubaddr_display>:
}

void ui_menu_pubaddr_display(unsigned int value) {
c0d038dc:	b510      	push	{r4, lr}
c0d038de:	4604      	mov	r4, r0
c0d038e0:	20e9      	movs	r0, #233	; 0xe9
c0d038e2:	00c0      	lsls	r0, r0, #3
   monero_base58_public_key(G_monero_vstate.ux_address, G_monero_vstate.A,G_monero_vstate.B, 0);
c0d038e4:	4a09      	ldr	r2, [pc, #36]	; (c0d0390c <ui_menu_pubaddr_display+0x30>)
c0d038e6:	1810      	adds	r0, r2, r0
c0d038e8:	2159      	movs	r1, #89	; 0x59
c0d038ea:	0089      	lsls	r1, r1, #2
c0d038ec:	1851      	adds	r1, r2, r1
c0d038ee:	2369      	movs	r3, #105	; 0x69
c0d038f0:	009b      	lsls	r3, r3, #2
c0d038f2:	18d2      	adds	r2, r2, r3
c0d038f4:	2300      	movs	r3, #0
c0d038f6:	f7ff f85f 	bl	c0d029b8 <monero_base58_public_key>
   UX_MENU_DISPLAY(value, ui_menu_pubaddr, ui_menu_pubaddr_preprocessor);
c0d038fa:	4905      	ldr	r1, [pc, #20]	; (c0d03910 <ui_menu_pubaddr_display+0x34>)
c0d038fc:	4479      	add	r1, pc
c0d038fe:	4a05      	ldr	r2, [pc, #20]	; (c0d03914 <ui_menu_pubaddr_display+0x38>)
c0d03900:	447a      	add	r2, pc
c0d03902:	4620      	mov	r0, r4
c0d03904:	f000 ffa2 	bl	c0d0484c <ux_menu_display>
}
c0d03908:	bd10      	pop	{r4, pc}
c0d0390a:	46c0      	nop			; (mov r8, r8)
c0d0390c:	20001930 	.word	0x20001930
c0d03910:	00004098 	.word	0x00004098
c0d03914:	fffffe8d 	.word	0xfffffe8d

c0d03918 <ui_menu_main_preprocessor>:
  {ui_menu_info,               NULL,  0, NULL,              "About",       NULL, 0, 0},
  {NULL,              os_sched_exit,  0, &C_icon_dashboard, "Quit app" ,   NULL, 50, 29},
  UX_MENU_END
};

const bagl_element_t* ui_menu_main_preprocessor(const ux_menu_entry_t* entry, bagl_element_t* element) {
c0d03918:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0391a:	b081      	sub	sp, #4
c0d0391c:	460c      	mov	r4, r1
  if (entry == &ui_menu_main[0]) {
c0d0391e:	491c      	ldr	r1, [pc, #112]	; (c0d03990 <ui_menu_main_preprocessor+0x78>)
c0d03920:	4479      	add	r1, pc
c0d03922:	4288      	cmp	r0, r1
c0d03924:	d126      	bne.n	c0d03974 <ui_menu_main_preprocessor+0x5c>
    if(element->component.userid==0x22) {
c0d03926:	7860      	ldrb	r0, [r4, #1]
c0d03928:	2822      	cmp	r0, #34	; 0x22
c0d0392a:	d123      	bne.n	c0d03974 <ui_menu_main_preprocessor+0x5c>
c0d0392c:	20db      	movs	r0, #219	; 0xdb
c0d0392e:	00c0      	lsls	r0, r0, #3
      os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu));
c0d03930:	4f12      	ldr	r7, [pc, #72]	; (c0d0397c <ui_menu_main_preprocessor+0x64>)
c0d03932:	183d      	adds	r5, r7, r0
c0d03934:	2600      	movs	r6, #0
c0d03936:	2270      	movs	r2, #112	; 0x70
c0d03938:	4628      	mov	r0, r5
c0d0393a:	4631      	mov	r1, r6
c0d0393c:	f000 f920 	bl	c0d03b80 <os_memset>
c0d03940:	2059      	movs	r0, #89	; 0x59
c0d03942:	0080      	lsls	r0, r0, #2
      monero_base58_public_key(G_monero_vstate.ux_menu, G_monero_vstate.A,G_monero_vstate.B, 0);
c0d03944:	1839      	adds	r1, r7, r0
c0d03946:	2069      	movs	r0, #105	; 0x69
c0d03948:	0080      	lsls	r0, r0, #2
c0d0394a:	183a      	adds	r2, r7, r0
c0d0394c:	4628      	mov	r0, r5
c0d0394e:	4633      	mov	r3, r6
c0d03950:	f7ff f832 	bl	c0d029b8 <monero_base58_public_key>
c0d03954:	480a      	ldr	r0, [pc, #40]	; (c0d03980 <ui_menu_main_preprocessor+0x68>)
      os_memset(G_monero_vstate.ux_menu+5,'.',2);
c0d03956:	1838      	adds	r0, r7, r0
c0d03958:	212e      	movs	r1, #46	; 0x2e
c0d0395a:	2202      	movs	r2, #2
c0d0395c:	f000 f910 	bl	c0d03b80 <os_memset>
c0d03960:	4808      	ldr	r0, [pc, #32]	; (c0d03984 <ui_menu_main_preprocessor+0x6c>)
      os_memmove(G_monero_vstate.ux_menu+7, G_monero_vstate.ux_menu+95-5,5);
c0d03962:	1838      	adds	r0, r7, r0
c0d03964:	4908      	ldr	r1, [pc, #32]	; (c0d03988 <ui_menu_main_preprocessor+0x70>)
c0d03966:	1879      	adds	r1, r7, r1
c0d03968:	2205      	movs	r2, #5
c0d0396a:	f000 f912 	bl	c0d03b92 <os_memmove>
c0d0396e:	4807      	ldr	r0, [pc, #28]	; (c0d0398c <ui_menu_main_preprocessor+0x74>)
      G_monero_vstate.ux_menu[12] = 0;
c0d03970:	543e      	strb	r6, [r7, r0]
      element->text = G_monero_vstate.ux_menu;
c0d03972:	61e5      	str	r5, [r4, #28]
    }
  }
  return element;
c0d03974:	4620      	mov	r0, r4
c0d03976:	b001      	add	sp, #4
c0d03978:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d0397a:	46c0      	nop			; (mov r8, r8)
c0d0397c:	20001930 	.word	0x20001930
c0d03980:	000006dd 	.word	0x000006dd
c0d03984:	000006df 	.word	0x000006df
c0d03988:	00000732 	.word	0x00000732
c0d0398c:	000006e4 	.word	0x000006e4
c0d03990:	00004138 	.word	0x00004138

c0d03994 <ui_init>:
}
void ui_menu_main_display(unsigned int value) {
   UX_MENU_DISPLAY(value, ui_menu_main, ui_menu_main_preprocessor);
}

void ui_init(void) {
c0d03994:	b580      	push	{r7, lr}
c0d03996:	2000      	movs	r0, #0
    }
  }
  return element;
}
void ui_menu_main_display(unsigned int value) {
   UX_MENU_DISPLAY(value, ui_menu_main, ui_menu_main_preprocessor);
c0d03998:	4906      	ldr	r1, [pc, #24]	; (c0d039b4 <ui_init+0x20>)
c0d0399a:	4479      	add	r1, pc
c0d0399c:	4a06      	ldr	r2, [pc, #24]	; (c0d039b8 <ui_init+0x24>)
c0d0399e:	447a      	add	r2, pc
c0d039a0:	f000 ff54 	bl	c0d0484c <ux_menu_display>
c0d039a4:	207d      	movs	r0, #125	; 0x7d
c0d039a6:	00c0      	lsls	r0, r0, #3
}

void ui_init(void) {
 ui_menu_main_display(0);
 // setup the first screen changing
  UX_CALLBACK_SET_INTERVAL(1000);
c0d039a8:	4901      	ldr	r1, [pc, #4]	; (c0d039b0 <ui_init+0x1c>)
c0d039aa:	6148      	str	r0, [r1, #20]
}
c0d039ac:	bd80      	pop	{r7, pc}
c0d039ae:	46c0      	nop			; (mov r8, r8)
c0d039b0:	20001880 	.word	0x20001880
c0d039b4:	000040be 	.word	0x000040be
c0d039b8:	ffffff77 	.word	0xffffff77

c0d039bc <os_boot>:

// apdu buffer must hold a complete apdu to avoid troubles
unsigned char G_io_apdu_buffer[IO_APDU_BUFFER_SIZE];


void os_boot(void) {
c0d039bc:	2000      	movs	r0, #0
  //                ^ platform register
  return (try_context_t*) current_ctx->jmp_buf[5];
}

void try_context_set(try_context_t* ctx) {
  __asm volatile ("mov r9, %0"::"r"(ctx));
c0d039be:	4681      	mov	r9, r0

void os_boot(void) {
  // TODO patch entry point when romming (f)
  // set the default try context to nothing
  try_context_set(NULL);
}
c0d039c0:	4770      	bx	lr

c0d039c2 <try_context_set>:
  //                ^ platform register
  return (try_context_t*) current_ctx->jmp_buf[5];
}

void try_context_set(try_context_t* ctx) {
  __asm volatile ("mov r9, %0"::"r"(ctx));
c0d039c2:	4681      	mov	r9, r0
}
c0d039c4:	4770      	bx	lr
	...

c0d039c8 <io_usb_hid_receive>:
volatile unsigned int   G_io_usb_hid_channel;
volatile unsigned int   G_io_usb_hid_remaining_length;
volatile unsigned int   G_io_usb_hid_sequence_number;
volatile unsigned char* G_io_usb_hid_current_buffer;

io_usb_hid_receive_status_t io_usb_hid_receive (io_send_t sndfct, unsigned char* buffer, unsigned short l) {
c0d039c8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d039ca:	b081      	sub	sp, #4
c0d039cc:	4606      	mov	r6, r0
  // avoid over/under flows
  if (buffer != G_io_usb_ep_buffer) {
c0d039ce:	4f65      	ldr	r7, [pc, #404]	; (c0d03b64 <io_usb_hid_receive+0x19c>)
c0d039d0:	42b9      	cmp	r1, r7
c0d039d2:	d038      	beq.n	c0d03a46 <io_usb_hid_receive+0x7e>
c0d039d4:	460d      	mov	r5, r1
c0d039d6:	4614      	mov	r4, r2
c0d039d8:	9600      	str	r6, [sp, #0]
c0d039da:	2640      	movs	r6, #64	; 0x40
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
    DSTCHAR[length] = c;
c0d039dc:	4638      	mov	r0, r7
c0d039de:	4631      	mov	r1, r6
c0d039e0:	f002 ff4e 	bl	c0d06880 <__aeabi_memclr>

io_usb_hid_receive_status_t io_usb_hid_receive (io_send_t sndfct, unsigned char* buffer, unsigned short l) {
  // avoid over/under flows
  if (buffer != G_io_usb_ep_buffer) {
    os_memset(G_io_usb_ep_buffer, 0, sizeof(G_io_usb_ep_buffer));
    os_memmove(G_io_usb_ep_buffer, buffer, MIN(l, sizeof(G_io_usb_ep_buffer)));
c0d039e4:	2c40      	cmp	r4, #64	; 0x40
c0d039e6:	4622      	mov	r2, r4
c0d039e8:	d300      	bcc.n	c0d039ec <io_usb_hid_receive+0x24>
c0d039ea:	4634      	mov	r4, r6
#endif // HAVE_USB_APDU

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
c0d039ec:	42bd      	cmp	r5, r7
c0d039ee:	d217      	bcs.n	c0d03a20 <io_usb_hid_receive+0x58>
    while(length--) {
c0d039f0:	2c00      	cmp	r4, #0
c0d039f2:	9e00      	ldr	r6, [sp, #0]
c0d039f4:	d027      	beq.n	c0d03a46 <io_usb_hid_receive+0x7e>
c0d039f6:	2040      	movs	r0, #64	; 0x40
c0d039f8:	43c1      	mvns	r1, r0
c0d039fa:	4608      	mov	r0, r1
c0d039fc:	3040      	adds	r0, #64	; 0x40
c0d039fe:	1a83      	subs	r3, r0, r2
c0d03a00:	428b      	cmp	r3, r1
c0d03a02:	d800      	bhi.n	c0d03a06 <io_usb_hid_receive+0x3e>
c0d03a04:	460b      	mov	r3, r1
c0d03a06:	313f      	adds	r1, #63	; 0x3f
c0d03a08:	1acc      	subs	r4, r1, r3
c0d03a0a:	1929      	adds	r1, r5, r4
c0d03a0c:	4d55      	ldr	r5, [pc, #340]	; (c0d03b64 <io_usb_hid_receive+0x19c>)
c0d03a0e:	192c      	adds	r4, r5, r4
c0d03a10:	1c5b      	adds	r3, r3, #1
      DSTCHAR[length] = SRCCHAR[length];
c0d03a12:	780d      	ldrb	r5, [r1, #0]
c0d03a14:	7025      	strb	r5, [r4, #0]

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
    while(length--) {
c0d03a16:	1809      	adds	r1, r1, r0
c0d03a18:	1824      	adds	r4, r4, r0
c0d03a1a:	1c5b      	adds	r3, r3, #1
c0d03a1c:	d1f9      	bne.n	c0d03a12 <io_usb_hid_receive+0x4a>
c0d03a1e:	e012      	b.n	c0d03a46 <io_usb_hid_receive+0x7e>
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d03a20:	2c00      	cmp	r4, #0
c0d03a22:	9e00      	ldr	r6, [sp, #0]
c0d03a24:	d00f      	beq.n	c0d03a46 <io_usb_hid_receive+0x7e>
c0d03a26:	2040      	movs	r0, #64	; 0x40
c0d03a28:	43c0      	mvns	r0, r0
c0d03a2a:	4601      	mov	r1, r0
c0d03a2c:	3140      	adds	r1, #64	; 0x40
c0d03a2e:	1a89      	subs	r1, r1, r2
c0d03a30:	4281      	cmp	r1, r0
c0d03a32:	d800      	bhi.n	c0d03a36 <io_usb_hid_receive+0x6e>
c0d03a34:	4601      	mov	r1, r0
c0d03a36:	1c48      	adds	r0, r1, #1
      DSTCHAR[l] = SRCCHAR[l];
c0d03a38:	7829      	ldrb	r1, [r5, #0]
c0d03a3a:	7039      	strb	r1, [r7, #0]
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d03a3c:	1c40      	adds	r0, r0, #1
c0d03a3e:	1c7f      	adds	r7, r7, #1
c0d03a40:	1c6d      	adds	r5, r5, #1
c0d03a42:	2800      	cmp	r0, #0
c0d03a44:	d1f8      	bne.n	c0d03a38 <io_usb_hid_receive+0x70>
    os_memset(G_io_usb_ep_buffer, 0, sizeof(G_io_usb_ep_buffer));
    os_memmove(G_io_usb_ep_buffer, buffer, MIN(l, sizeof(G_io_usb_ep_buffer)));
  }

  // process the chunk content
  switch(G_io_usb_ep_buffer[2]) {
c0d03a46:	4d47      	ldr	r5, [pc, #284]	; (c0d03b64 <io_usb_hid_receive+0x19c>)
c0d03a48:	78a8      	ldrb	r0, [r5, #2]
c0d03a4a:	2801      	cmp	r0, #1
c0d03a4c:	dc0a      	bgt.n	c0d03a64 <io_usb_hid_receive+0x9c>
c0d03a4e:	2800      	cmp	r0, #0
c0d03a50:	d030      	beq.n	c0d03ab4 <io_usb_hid_receive+0xec>
c0d03a52:	2801      	cmp	r0, #1
c0d03a54:	d17a      	bne.n	c0d03b4c <io_usb_hid_receive+0x184>
    // await for the next chunk
    goto apdu_reset;

  case 0x01: // ALLOCATE CHANNEL
    // do not reset the current apdu reception if any
    cx_rng(G_io_usb_ep_buffer+3, 4);
c0d03a56:	1ce8      	adds	r0, r5, #3
c0d03a58:	2104      	movs	r1, #4
c0d03a5a:	f000 ffdf 	bl	c0d04a1c <cx_rng>
c0d03a5e:	2140      	movs	r1, #64	; 0x40
    // send the response
    sndfct(G_io_usb_ep_buffer, IO_HID_EP_LENGTH);
c0d03a60:	4628      	mov	r0, r5
c0d03a62:	e032      	b.n	c0d03aca <io_usb_hid_receive+0x102>
    os_memset(G_io_usb_ep_buffer, 0, sizeof(G_io_usb_ep_buffer));
    os_memmove(G_io_usb_ep_buffer, buffer, MIN(l, sizeof(G_io_usb_ep_buffer)));
  }

  // process the chunk content
  switch(G_io_usb_ep_buffer[2]) {
c0d03a64:	2802      	cmp	r0, #2
c0d03a66:	d02e      	beq.n	c0d03ac6 <io_usb_hid_receive+0xfe>
c0d03a68:	2805      	cmp	r0, #5
c0d03a6a:	d16f      	bne.n	c0d03b4c <io_usb_hid_receive+0x184>
  case 0x05:
    // ensure sequence idx is 0 for the first chunk ! 
    if ((unsigned int)U2BE(G_io_usb_ep_buffer, 3) != (unsigned int)G_io_usb_hid_sequence_number) {
c0d03a6c:	7928      	ldrb	r0, [r5, #4]
c0d03a6e:	78e9      	ldrb	r1, [r5, #3]
c0d03a70:	0209      	lsls	r1, r1, #8
c0d03a72:	1808      	adds	r0, r1, r0
c0d03a74:	4e3c      	ldr	r6, [pc, #240]	; (c0d03b68 <io_usb_hid_receive+0x1a0>)
c0d03a76:	6831      	ldr	r1, [r6, #0]
c0d03a78:	2700      	movs	r7, #0
c0d03a7a:	4288      	cmp	r0, r1
c0d03a7c:	d16c      	bne.n	c0d03b58 <io_usb_hid_receive+0x190>
      // ignore packet
      goto apdu_reset;
    }
    // cid, tag, seq
    l -= 2+1+2;
c0d03a7e:	1f50      	subs	r0, r2, #5
    
    // append the received chunk to the current command apdu
    if (G_io_usb_hid_sequence_number == 0) {
c0d03a80:	6831      	ldr	r1, [r6, #0]
c0d03a82:	2900      	cmp	r1, #0
c0d03a84:	d024      	beq.n	c0d03ad0 <io_usb_hid_receive+0x108>
      // copy data
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+7, l);
    }
    else {
      // check for invalid length encoding (more data in chunk that announced in the total apdu)
      if (l > G_io_usb_hid_remaining_length) {
c0d03a86:	b281      	uxth	r1, r0
c0d03a88:	4a38      	ldr	r2, [pc, #224]	; (c0d03b6c <io_usb_hid_receive+0x1a4>)
c0d03a8a:	6813      	ldr	r3, [r2, #0]
c0d03a8c:	428b      	cmp	r3, r1
c0d03a8e:	d201      	bcs.n	c0d03a94 <io_usb_hid_receive+0xcc>
        l = G_io_usb_hid_remaining_length;
c0d03a90:	6810      	ldr	r0, [r2, #0]
      }

      /// This is a following chunk
      // append content
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+5, l);
c0d03a92:	b281      	uxth	r1, r0
c0d03a94:	4a36      	ldr	r2, [pc, #216]	; (c0d03b70 <io_usb_hid_receive+0x1a8>)
c0d03a96:	6812      	ldr	r2, [r2, #0]
#endif // HAVE_USB_APDU

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
c0d03a98:	1d6b      	adds	r3, r5, #5
c0d03a9a:	429a      	cmp	r2, r3
c0d03a9c:	d93f      	bls.n	c0d03b1e <io_usb_hid_receive+0x156>
c0d03a9e:	2300      	movs	r3, #0
    while(length--) {
c0d03aa0:	0404      	lsls	r4, r0, #16
c0d03aa2:	d047      	beq.n	c0d03b34 <io_usb_hid_receive+0x16c>
c0d03aa4:	3a41      	subs	r2, #65	; 0x41
c0d03aa6:	3240      	adds	r2, #64	; 0x40
      DSTCHAR[length] = SRCCHAR[length];
c0d03aa8:	186b      	adds	r3, r5, r1
c0d03aaa:	791b      	ldrb	r3, [r3, #4]
c0d03aac:	5453      	strb	r3, [r2, r1]

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
    while(length--) {
c0d03aae:	1e49      	subs	r1, r1, #1
c0d03ab0:	d1fa      	bne.n	c0d03aa8 <io_usb_hid_receive+0xe0>
c0d03ab2:	e03e      	b.n	c0d03b32 <io_usb_hid_receive+0x16a>
c0d03ab4:	2700      	movs	r7, #0
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
    DSTCHAR[length] = c;
c0d03ab6:	71af      	strb	r7, [r5, #6]
c0d03ab8:	716f      	strb	r7, [r5, #5]
c0d03aba:	712f      	strb	r7, [r5, #4]
c0d03abc:	70ef      	strb	r7, [r5, #3]
c0d03abe:	2140      	movs	r1, #64	; 0x40

  case 0x00: // get version ID
    // do not reset the current apdu reception if any
    os_memset(G_io_usb_ep_buffer+3, 0, 4); // PROTOCOL VERSION is 0
    // send the response
    sndfct(G_io_usb_ep_buffer, IO_HID_EP_LENGTH);
c0d03ac0:	4628      	mov	r0, r5
c0d03ac2:	47b0      	blx	r6
c0d03ac4:	e048      	b.n	c0d03b58 <io_usb_hid_receive+0x190>
    goto apdu_reset;

  case 0x02: // ECHO|PING
    // do not reset the current apdu reception if any
    // send the response
    sndfct(G_io_usb_ep_buffer, IO_HID_EP_LENGTH);
c0d03ac6:	4827      	ldr	r0, [pc, #156]	; (c0d03b64 <io_usb_hid_receive+0x19c>)
c0d03ac8:	2140      	movs	r1, #64	; 0x40
c0d03aca:	47b0      	blx	r6
c0d03acc:	2700      	movs	r7, #0
c0d03ace:	e043      	b.n	c0d03b58 <io_usb_hid_receive+0x190>
    
    // append the received chunk to the current command apdu
    if (G_io_usb_hid_sequence_number == 0) {
      /// This is the apdu first chunk
      // total apdu size to receive
      G_io_usb_hid_total_length = U2BE(G_io_usb_ep_buffer, 5); //(G_io_usb_ep_buffer[5]<<8)+(G_io_usb_ep_buffer[6]&0xFF);
c0d03ad0:	79a8      	ldrb	r0, [r5, #6]
c0d03ad2:	7969      	ldrb	r1, [r5, #5]
c0d03ad4:	0209      	lsls	r1, r1, #8
c0d03ad6:	1809      	adds	r1, r1, r0
c0d03ad8:	4826      	ldr	r0, [pc, #152]	; (c0d03b74 <io_usb_hid_receive+0x1ac>)
c0d03ada:	6001      	str	r1, [r0, #0]
      // check for invalid length encoding (more data in chunk that announced in the total apdu)
      if (G_io_usb_hid_total_length > sizeof(G_io_apdu_buffer)) {
c0d03adc:	6801      	ldr	r1, [r0, #0]
c0d03ade:	0849      	lsrs	r1, r1, #1
c0d03ae0:	29a8      	cmp	r1, #168	; 0xa8
c0d03ae2:	d839      	bhi.n	c0d03b58 <io_usb_hid_receive+0x190>
        goto apdu_reset;
      }
      // seq and total length
      l -= 2;
      // compute remaining size to receive
      G_io_usb_hid_remaining_length = G_io_usb_hid_total_length;
c0d03ae4:	6801      	ldr	r1, [r0, #0]
c0d03ae6:	4821      	ldr	r0, [pc, #132]	; (c0d03b6c <io_usb_hid_receive+0x1a4>)
c0d03ae8:	6001      	str	r1, [r0, #0]
      G_io_usb_hid_current_buffer = G_io_apdu_buffer;

      // retain the channel id to use for the reply
      G_io_usb_hid_channel = U2BE(G_io_usb_ep_buffer, 0);
c0d03aea:	7869      	ldrb	r1, [r5, #1]
c0d03aec:	782b      	ldrb	r3, [r5, #0]
c0d03aee:	021b      	lsls	r3, r3, #8
c0d03af0:	1859      	adds	r1, r3, r1
c0d03af2:	4b21      	ldr	r3, [pc, #132]	; (c0d03b78 <io_usb_hid_receive+0x1b0>)
c0d03af4:	6019      	str	r1, [r3, #0]
      }
      // seq and total length
      l -= 2;
      // compute remaining size to receive
      G_io_usb_hid_remaining_length = G_io_usb_hid_total_length;
      G_io_usb_hid_current_buffer = G_io_apdu_buffer;
c0d03af6:	491e      	ldr	r1, [pc, #120]	; (c0d03b70 <io_usb_hid_receive+0x1a8>)
c0d03af8:	4b20      	ldr	r3, [pc, #128]	; (c0d03b7c <io_usb_hid_receive+0x1b4>)
c0d03afa:	600b      	str	r3, [r1, #0]
      // check for invalid length encoding (more data in chunk that announced in the total apdu)
      if (G_io_usb_hid_total_length > sizeof(G_io_apdu_buffer)) {
        goto apdu_reset;
      }
      // seq and total length
      l -= 2;
c0d03afc:	1fd4      	subs	r4, r2, #7
      G_io_usb_hid_current_buffer = G_io_apdu_buffer;

      // retain the channel id to use for the reply
      G_io_usb_hid_channel = U2BE(G_io_usb_ep_buffer, 0);

      if (l > G_io_usb_hid_remaining_length) {
c0d03afe:	b2a2      	uxth	r2, r4
c0d03b00:	6801      	ldr	r1, [r0, #0]
c0d03b02:	4291      	cmp	r1, r2
c0d03b04:	d201      	bcs.n	c0d03b0a <io_usb_hid_receive+0x142>
        l = G_io_usb_hid_remaining_length;
c0d03b06:	6804      	ldr	r4, [r0, #0]
      }
      // copy data
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+7, l);
c0d03b08:	b2a2      	uxth	r2, r4
#endif // HAVE_USB_APDU

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
c0d03b0a:	1de9      	adds	r1, r5, #7
c0d03b0c:	428b      	cmp	r3, r1
c0d03b0e:	2300      	movs	r3, #0
c0d03b10:	0420      	lsls	r0, r4, #16
c0d03b12:	d00f      	beq.n	c0d03b34 <io_usb_hid_receive+0x16c>
c0d03b14:	4819      	ldr	r0, [pc, #100]	; (c0d03b7c <io_usb_hid_receive+0x1b4>)
c0d03b16:	f002 feb9 	bl	c0d0688c <__aeabi_memcpy>
c0d03b1a:	4623      	mov	r3, r4
c0d03b1c:	e00a      	b.n	c0d03b34 <io_usb_hid_receive+0x16c>
c0d03b1e:	2300      	movs	r3, #0
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d03b20:	0404      	lsls	r4, r0, #16
c0d03b22:	d007      	beq.n	c0d03b34 <io_usb_hid_receive+0x16c>
c0d03b24:	1d6b      	adds	r3, r5, #5
      DSTCHAR[l] = SRCCHAR[l];
c0d03b26:	781c      	ldrb	r4, [r3, #0]
c0d03b28:	7014      	strb	r4, [r2, #0]
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d03b2a:	1c52      	adds	r2, r2, #1
c0d03b2c:	1c5b      	adds	r3, r3, #1
c0d03b2e:	1e49      	subs	r1, r1, #1
c0d03b30:	d1f9      	bne.n	c0d03b26 <io_usb_hid_receive+0x15e>
c0d03b32:	4603      	mov	r3, r0
      /// This is a following chunk
      // append content
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+5, l);
    }
    // factorize (f)
    G_io_usb_hid_current_buffer += l;
c0d03b34:	b298      	uxth	r0, r3
    G_io_usb_hid_remaining_length -= l;
c0d03b36:	490d      	ldr	r1, [pc, #52]	; (c0d03b6c <io_usb_hid_receive+0x1a4>)
c0d03b38:	680a      	ldr	r2, [r1, #0]
c0d03b3a:	1a12      	subs	r2, r2, r0
c0d03b3c:	600a      	str	r2, [r1, #0]
      /// This is a following chunk
      // append content
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+5, l);
    }
    // factorize (f)
    G_io_usb_hid_current_buffer += l;
c0d03b3e:	490c      	ldr	r1, [pc, #48]	; (c0d03b70 <io_usb_hid_receive+0x1a8>)
c0d03b40:	680a      	ldr	r2, [r1, #0]
c0d03b42:	1810      	adds	r0, r2, r0
c0d03b44:	6008      	str	r0, [r1, #0]
    G_io_usb_hid_remaining_length -= l;
    G_io_usb_hid_sequence_number++;
c0d03b46:	6830      	ldr	r0, [r6, #0]
c0d03b48:	1c40      	adds	r0, r0, #1
c0d03b4a:	6030      	str	r0, [r6, #0]
    // await for the next chunk
    goto apdu_reset;
  }

  // if more data to be received, notify it
  if (G_io_usb_hid_remaining_length) {
c0d03b4c:	4807      	ldr	r0, [pc, #28]	; (c0d03b6c <io_usb_hid_receive+0x1a4>)
c0d03b4e:	6801      	ldr	r1, [r0, #0]
c0d03b50:	2001      	movs	r0, #1
c0d03b52:	2702      	movs	r7, #2
c0d03b54:	2900      	cmp	r1, #0
c0d03b56:	d103      	bne.n	c0d03b60 <io_usb_hid_receive+0x198>
  io_usb_hid_init();
  return IO_USB_APDU_RESET;
}

void io_usb_hid_init(void) {
  G_io_usb_hid_sequence_number = 0; 
c0d03b58:	4803      	ldr	r0, [pc, #12]	; (c0d03b68 <io_usb_hid_receive+0x1a0>)
c0d03b5a:	2100      	movs	r1, #0
c0d03b5c:	6001      	str	r1, [r0, #0]
c0d03b5e:	4638      	mov	r0, r7
  return IO_USB_APDU_RECEIVED;

apdu_reset:
  io_usb_hid_init();
  return IO_USB_APDU_RESET;
}
c0d03b60:	b001      	add	sp, #4
c0d03b62:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d03b64:	20002370 	.word	0x20002370
c0d03b68:	20002160 	.word	0x20002160
c0d03b6c:	20002168 	.word	0x20002168
c0d03b70:	200022c0 	.word	0x200022c0
c0d03b74:	20002164 	.word	0x20002164
c0d03b78:	200022c4 	.word	0x200022c4
c0d03b7c:	2000216c 	.word	0x2000216c

c0d03b80 <os_memset>:
    }
  }
#undef DSTCHAR
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
c0d03b80:	b580      	push	{r7, lr}
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
c0d03b82:	2a00      	cmp	r2, #0
c0d03b84:	d004      	beq.n	c0d03b90 <os_memset+0x10>
c0d03b86:	460b      	mov	r3, r1
    DSTCHAR[length] = c;
c0d03b88:	4611      	mov	r1, r2
c0d03b8a:	461a      	mov	r2, r3
c0d03b8c:	f002 fe82 	bl	c0d06894 <__aeabi_memset>
  }
#undef DSTCHAR
}
c0d03b90:	bd80      	pop	{r7, pc}

c0d03b92 <os_memmove>:
  }
}

#endif // HAVE_USB_APDU

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
c0d03b92:	b5b0      	push	{r4, r5, r7, lr}
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
c0d03b94:	4288      	cmp	r0, r1
c0d03b96:	d908      	bls.n	c0d03baa <os_memmove+0x18>
    while(length--) {
c0d03b98:	2a00      	cmp	r2, #0
c0d03b9a:	d00f      	beq.n	c0d03bbc <os_memmove+0x2a>
c0d03b9c:	1e49      	subs	r1, r1, #1
c0d03b9e:	1e40      	subs	r0, r0, #1
      DSTCHAR[length] = SRCCHAR[length];
c0d03ba0:	5c8b      	ldrb	r3, [r1, r2]
c0d03ba2:	5483      	strb	r3, [r0, r2]

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
    while(length--) {
c0d03ba4:	1e52      	subs	r2, r2, #1
c0d03ba6:	d1fb      	bne.n	c0d03ba0 <os_memmove+0xe>
c0d03ba8:	e008      	b.n	c0d03bbc <os_memmove+0x2a>
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d03baa:	2a00      	cmp	r2, #0
c0d03bac:	d006      	beq.n	c0d03bbc <os_memmove+0x2a>
c0d03bae:	2300      	movs	r3, #0
      DSTCHAR[l] = SRCCHAR[l];
c0d03bb0:	b29c      	uxth	r4, r3
c0d03bb2:	5d0d      	ldrb	r5, [r1, r4]
c0d03bb4:	5505      	strb	r5, [r0, r4]
      l++;
c0d03bb6:	1c5b      	adds	r3, r3, #1
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d03bb8:	1e52      	subs	r2, r2, #1
c0d03bba:	d1f9      	bne.n	c0d03bb0 <os_memmove+0x1e>
      DSTCHAR[l] = SRCCHAR[l];
      l++;
    }
  }
#undef DSTCHAR
}
c0d03bbc:	bdb0      	pop	{r4, r5, r7, pc}
	...

c0d03bc0 <io_usb_hid_init>:
  io_usb_hid_init();
  return IO_USB_APDU_RESET;
}

void io_usb_hid_init(void) {
  G_io_usb_hid_sequence_number = 0; 
c0d03bc0:	4801      	ldr	r0, [pc, #4]	; (c0d03bc8 <io_usb_hid_init+0x8>)
c0d03bc2:	2100      	movs	r1, #0
c0d03bc4:	6001      	str	r1, [r0, #0]
  //G_io_usb_hid_remaining_length = 0; // not really needed
  //G_io_usb_hid_total_length = 0; // not really needed
  //G_io_usb_hid_current_buffer = G_io_apdu_buffer; // not really needed
}
c0d03bc6:	4770      	bx	lr
c0d03bc8:	20002160 	.word	0x20002160

c0d03bcc <io_usb_hid_sent>:

/**
 * sent the next io_usb_hid transport chunk (rx on the host, tx on the device)
 */
void io_usb_hid_sent(io_send_t sndfct) {
c0d03bcc:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03bce:	b081      	sub	sp, #4
  unsigned int l;

  // only prepare next chunk if some data to be sent remain
  if (G_io_usb_hid_remaining_length) {
c0d03bd0:	4f3a      	ldr	r7, [pc, #232]	; (c0d03cbc <io_usb_hid_sent+0xf0>)
c0d03bd2:	6839      	ldr	r1, [r7, #0]
c0d03bd4:	2900      	cmp	r1, #0
c0d03bd6:	d02b      	beq.n	c0d03c30 <io_usb_hid_sent+0x64>
c0d03bd8:	9000      	str	r0, [sp, #0]
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
    DSTCHAR[length] = c;
c0d03bda:	4c39      	ldr	r4, [pc, #228]	; (c0d03cc0 <io_usb_hid_sent+0xf4>)
c0d03bdc:	1d66      	adds	r6, r4, #5
c0d03bde:	2539      	movs	r5, #57	; 0x39
c0d03be0:	4630      	mov	r0, r6
c0d03be2:	4629      	mov	r1, r5
c0d03be4:	f002 fe4c 	bl	c0d06880 <__aeabi_memclr>
c0d03be8:	2005      	movs	r0, #5
    os_memset(G_io_usb_ep_buffer, 0, IO_HID_EP_LENGTH-2);

    // keep the channel identifier
    G_io_usb_ep_buffer[0] = (G_io_usb_hid_channel>>8)&0xFF;
    G_io_usb_ep_buffer[1] = G_io_usb_hid_channel&0xFF;
    G_io_usb_ep_buffer[2] = 0x05;
c0d03bea:	70a0      	strb	r0, [r4, #2]
  if (G_io_usb_hid_remaining_length) {
    // fill the chunk
    os_memset(G_io_usb_ep_buffer, 0, IO_HID_EP_LENGTH-2);

    // keep the channel identifier
    G_io_usb_ep_buffer[0] = (G_io_usb_hid_channel>>8)&0xFF;
c0d03bec:	4835      	ldr	r0, [pc, #212]	; (c0d03cc4 <io_usb_hid_sent+0xf8>)
c0d03bee:	6801      	ldr	r1, [r0, #0]
c0d03bf0:	0a09      	lsrs	r1, r1, #8
c0d03bf2:	7021      	strb	r1, [r4, #0]
    G_io_usb_ep_buffer[1] = G_io_usb_hid_channel&0xFF;
c0d03bf4:	6800      	ldr	r0, [r0, #0]
c0d03bf6:	7060      	strb	r0, [r4, #1]
    G_io_usb_ep_buffer[2] = 0x05;
    G_io_usb_ep_buffer[3] = G_io_usb_hid_sequence_number>>8;
c0d03bf8:	4833      	ldr	r0, [pc, #204]	; (c0d03cc8 <io_usb_hid_sent+0xfc>)
c0d03bfa:	6801      	ldr	r1, [r0, #0]
c0d03bfc:	0a09      	lsrs	r1, r1, #8
c0d03bfe:	70e1      	strb	r1, [r4, #3]
    G_io_usb_ep_buffer[4] = G_io_usb_hid_sequence_number;
c0d03c00:	6801      	ldr	r1, [r0, #0]
c0d03c02:	7121      	strb	r1, [r4, #4]

    if (G_io_usb_hid_sequence_number == 0) {
c0d03c04:	6802      	ldr	r2, [r0, #0]
c0d03c06:	6839      	ldr	r1, [r7, #0]
c0d03c08:	2a00      	cmp	r2, #0
c0d03c0a:	d019      	beq.n	c0d03c40 <io_usb_hid_sent+0x74>
c0d03c0c:	253b      	movs	r5, #59	; 0x3b
      G_io_usb_hid_current_buffer += l;
      G_io_usb_hid_remaining_length -= l;
      l += 7;
    }
    else {
      l = ((G_io_usb_hid_remaining_length>IO_HID_EP_LENGTH-5) ? IO_HID_EP_LENGTH-5 : G_io_usb_hid_remaining_length);
c0d03c0e:	293b      	cmp	r1, #59	; 0x3b
c0d03c10:	d800      	bhi.n	c0d03c14 <io_usb_hid_sent+0x48>
c0d03c12:	683d      	ldr	r5, [r7, #0]
      os_memmove(G_io_usb_ep_buffer+5, (const void*)G_io_usb_hid_current_buffer, l);
c0d03c14:	482d      	ldr	r0, [pc, #180]	; (c0d03ccc <io_usb_hid_sent+0x100>)
c0d03c16:	6801      	ldr	r1, [r0, #0]
#endif // HAVE_USB_APDU

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
c0d03c18:	42b1      	cmp	r1, r6
c0d03c1a:	d228      	bcs.n	c0d03c6e <io_usb_hid_sent+0xa2>
    while(length--) {
c0d03c1c:	2d00      	cmp	r5, #0
c0d03c1e:	d03d      	beq.n	c0d03c9c <io_usb_hid_sent+0xd0>
c0d03c20:	1e4a      	subs	r2, r1, #1
c0d03c22:	462b      	mov	r3, r5
      DSTCHAR[length] = SRCCHAR[length];
c0d03c24:	5cd0      	ldrb	r0, [r2, r3]
c0d03c26:	18e6      	adds	r6, r4, r3
c0d03c28:	7130      	strb	r0, [r6, #4]

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
    while(length--) {
c0d03c2a:	1e5b      	subs	r3, r3, #1
c0d03c2c:	d1fa      	bne.n	c0d03c24 <io_usb_hid_sent+0x58>
c0d03c2e:	e035      	b.n	c0d03c9c <io_usb_hid_sent+0xd0>
    // always pad :)
    sndfct(G_io_usb_ep_buffer, sizeof(G_io_usb_ep_buffer));
  }
  // cleanup when everything has been sent (ack for the last sent usb in packet)
  else {
    G_io_usb_hid_sequence_number = 0; 
c0d03c30:	4825      	ldr	r0, [pc, #148]	; (c0d03cc8 <io_usb_hid_sent+0xfc>)
c0d03c32:	2100      	movs	r1, #0
c0d03c34:	6001      	str	r1, [r0, #0]
    G_io_usb_hid_current_buffer = NULL;
c0d03c36:	4825      	ldr	r0, [pc, #148]	; (c0d03ccc <io_usb_hid_sent+0x100>)
c0d03c38:	6001      	str	r1, [r0, #0]

    // we sent the whole response
    G_io_apdu_state = APDU_IDLE;
c0d03c3a:	4825      	ldr	r0, [pc, #148]	; (c0d03cd0 <io_usb_hid_sent+0x104>)
c0d03c3c:	7001      	strb	r1, [r0, #0]
c0d03c3e:	e03b      	b.n	c0d03cb8 <io_usb_hid_sent+0xec>
    G_io_usb_ep_buffer[2] = 0x05;
    G_io_usb_ep_buffer[3] = G_io_usb_hid_sequence_number>>8;
    G_io_usb_ep_buffer[4] = G_io_usb_hid_sequence_number;

    if (G_io_usb_hid_sequence_number == 0) {
      l = ((G_io_usb_hid_remaining_length>IO_HID_EP_LENGTH-7) ? IO_HID_EP_LENGTH-7 : G_io_usb_hid_remaining_length);
c0d03c40:	2939      	cmp	r1, #57	; 0x39
c0d03c42:	d800      	bhi.n	c0d03c46 <io_usb_hid_sent+0x7a>
c0d03c44:	683d      	ldr	r5, [r7, #0]
      G_io_usb_ep_buffer[5] = G_io_usb_hid_remaining_length>>8;
c0d03c46:	6839      	ldr	r1, [r7, #0]
c0d03c48:	0a09      	lsrs	r1, r1, #8
c0d03c4a:	7161      	strb	r1, [r4, #5]
      G_io_usb_ep_buffer[6] = G_io_usb_hid_remaining_length;
c0d03c4c:	6839      	ldr	r1, [r7, #0]
c0d03c4e:	71a1      	strb	r1, [r4, #6]
      os_memmove(G_io_usb_ep_buffer+7, (const void*)G_io_usb_hid_current_buffer, l);
c0d03c50:	491e      	ldr	r1, [pc, #120]	; (c0d03ccc <io_usb_hid_sent+0x100>)
c0d03c52:	6809      	ldr	r1, [r1, #0]
#endif // HAVE_USB_APDU

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
c0d03c54:	1de2      	adds	r2, r4, #7
c0d03c56:	4291      	cmp	r1, r2
c0d03c58:	d215      	bcs.n	c0d03c86 <io_usb_hid_sent+0xba>
    while(length--) {
c0d03c5a:	2d00      	cmp	r5, #0
c0d03c5c:	d01e      	beq.n	c0d03c9c <io_usb_hid_sent+0xd0>
c0d03c5e:	1e4a      	subs	r2, r1, #1
c0d03c60:	462b      	mov	r3, r5
      DSTCHAR[length] = SRCCHAR[length];
c0d03c62:	5cd6      	ldrb	r6, [r2, r3]
c0d03c64:	18e0      	adds	r0, r4, r3
c0d03c66:	7186      	strb	r6, [r0, #6]

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
    while(length--) {
c0d03c68:	1e5b      	subs	r3, r3, #1
c0d03c6a:	d1fa      	bne.n	c0d03c62 <io_usb_hid_sent+0x96>
c0d03c6c:	e016      	b.n	c0d03c9c <io_usb_hid_sent+0xd0>
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d03c6e:	2d00      	cmp	r5, #0
c0d03c70:	d014      	beq.n	c0d03c9c <io_usb_hid_sent+0xd0>
c0d03c72:	2200      	movs	r2, #0
c0d03c74:	462b      	mov	r3, r5
      DSTCHAR[l] = SRCCHAR[l];
c0d03c76:	b290      	uxth	r0, r2
c0d03c78:	5c0e      	ldrb	r6, [r1, r0]
c0d03c7a:	1820      	adds	r0, r4, r0
c0d03c7c:	7146      	strb	r6, [r0, #5]
      l++;
c0d03c7e:	1c52      	adds	r2, r2, #1
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d03c80:	1e5b      	subs	r3, r3, #1
c0d03c82:	d1f8      	bne.n	c0d03c76 <io_usb_hid_sent+0xaa>
c0d03c84:	e00a      	b.n	c0d03c9c <io_usb_hid_sent+0xd0>
c0d03c86:	2d00      	cmp	r5, #0
c0d03c88:	d008      	beq.n	c0d03c9c <io_usb_hid_sent+0xd0>
c0d03c8a:	2200      	movs	r2, #0
c0d03c8c:	462b      	mov	r3, r5
      DSTCHAR[l] = SRCCHAR[l];
c0d03c8e:	b290      	uxth	r0, r2
c0d03c90:	5c0e      	ldrb	r6, [r1, r0]
c0d03c92:	1820      	adds	r0, r4, r0
c0d03c94:	71c6      	strb	r6, [r0, #7]
      l++;
c0d03c96:	1c52      	adds	r2, r2, #1
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d03c98:	1e5b      	subs	r3, r3, #1
c0d03c9a:	d1f8      	bne.n	c0d03c8e <io_usb_hid_sent+0xc2>
c0d03c9c:	1949      	adds	r1, r1, r5
c0d03c9e:	9a00      	ldr	r2, [sp, #0]
c0d03ca0:	4b09      	ldr	r3, [pc, #36]	; (c0d03cc8 <io_usb_hid_sent+0xfc>)
c0d03ca2:	6838      	ldr	r0, [r7, #0]
c0d03ca4:	1b40      	subs	r0, r0, r5
c0d03ca6:	6038      	str	r0, [r7, #0]
c0d03ca8:	4808      	ldr	r0, [pc, #32]	; (c0d03ccc <io_usb_hid_sent+0x100>)
c0d03caa:	6001      	str	r1, [r0, #0]
      G_io_usb_hid_current_buffer += l;
      G_io_usb_hid_remaining_length -= l;
      l += 5;
    }
    // prepare next chunk numbering
    G_io_usb_hid_sequence_number++;
c0d03cac:	6818      	ldr	r0, [r3, #0]
c0d03cae:	1c40      	adds	r0, r0, #1
c0d03cb0:	6018      	str	r0, [r3, #0]
    // send the chunk
    // always pad :)
    sndfct(G_io_usb_ep_buffer, sizeof(G_io_usb_ep_buffer));
c0d03cb2:	4803      	ldr	r0, [pc, #12]	; (c0d03cc0 <io_usb_hid_sent+0xf4>)
c0d03cb4:	2140      	movs	r1, #64	; 0x40
c0d03cb6:	4790      	blx	r2
    G_io_usb_hid_current_buffer = NULL;

    // we sent the whole response
    G_io_apdu_state = APDU_IDLE;
  }
}
c0d03cb8:	b001      	add	sp, #4
c0d03cba:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d03cbc:	20002168 	.word	0x20002168
c0d03cc0:	20002370 	.word	0x20002370
c0d03cc4:	200022c4 	.word	0x200022c4
c0d03cc8:	20002160 	.word	0x20002160
c0d03ccc:	200022c0 	.word	0x200022c0
c0d03cd0:	200022dc 	.word	0x200022dc

c0d03cd4 <io_usb_hid_send>:

void io_usb_hid_send(io_send_t sndfct, unsigned short sndlength) {
c0d03cd4:	b580      	push	{r7, lr}
  // perform send
  if (sndlength) {
c0d03cd6:	2900      	cmp	r1, #0
c0d03cd8:	d00b      	beq.n	c0d03cf2 <io_usb_hid_send+0x1e>
    G_io_usb_hid_sequence_number = 0; 
c0d03cda:	4a06      	ldr	r2, [pc, #24]	; (c0d03cf4 <io_usb_hid_send+0x20>)
c0d03cdc:	2300      	movs	r3, #0
c0d03cde:	6013      	str	r3, [r2, #0]
    G_io_usb_hid_current_buffer = G_io_apdu_buffer;
    G_io_usb_hid_remaining_length = sndlength;
c0d03ce0:	4a05      	ldr	r2, [pc, #20]	; (c0d03cf8 <io_usb_hid_send+0x24>)
c0d03ce2:	6011      	str	r1, [r2, #0]

void io_usb_hid_send(io_send_t sndfct, unsigned short sndlength) {
  // perform send
  if (sndlength) {
    G_io_usb_hid_sequence_number = 0; 
    G_io_usb_hid_current_buffer = G_io_apdu_buffer;
c0d03ce4:	4a05      	ldr	r2, [pc, #20]	; (c0d03cfc <io_usb_hid_send+0x28>)
c0d03ce6:	4b06      	ldr	r3, [pc, #24]	; (c0d03d00 <io_usb_hid_send+0x2c>)
c0d03ce8:	6013      	str	r3, [r2, #0]
    G_io_usb_hid_remaining_length = sndlength;
    G_io_usb_hid_total_length = sndlength;
c0d03cea:	4a06      	ldr	r2, [pc, #24]	; (c0d03d04 <io_usb_hid_send+0x30>)
c0d03cec:	6011      	str	r1, [r2, #0]
    io_usb_hid_sent(sndfct);
c0d03cee:	f7ff ff6d 	bl	c0d03bcc <io_usb_hid_sent>
  }
}
c0d03cf2:	bd80      	pop	{r7, pc}
c0d03cf4:	20002160 	.word	0x20002160
c0d03cf8:	20002168 	.word	0x20002168
c0d03cfc:	200022c0 	.word	0x200022c0
c0d03d00:	2000216c 	.word	0x2000216c
c0d03d04:	20002164 	.word	0x20002164

c0d03d08 <os_memcmp>:
    DSTCHAR[length] = c;
  }
#undef DSTCHAR
}

char os_memcmp(const void WIDE * buf1, const void WIDE * buf2, unsigned int length) {
c0d03d08:	b570      	push	{r4, r5, r6, lr}
#define BUF1 ((unsigned char const WIDE *)buf1)
#define BUF2 ((unsigned char const WIDE *)buf2)
  while(length--) {
c0d03d0a:	1e40      	subs	r0, r0, #1
c0d03d0c:	1e49      	subs	r1, r1, #1
c0d03d0e:	1e54      	subs	r4, r2, #1
c0d03d10:	2300      	movs	r3, #0
c0d03d12:	2a00      	cmp	r2, #0
c0d03d14:	d00a      	beq.n	c0d03d2c <os_memcmp+0x24>
    if (BUF1[length] != BUF2[length]) {
c0d03d16:	5c8d      	ldrb	r5, [r1, r2]
c0d03d18:	5c86      	ldrb	r6, [r0, r2]
c0d03d1a:	42ae      	cmp	r6, r5
c0d03d1c:	4622      	mov	r2, r4
c0d03d1e:	d0f6      	beq.n	c0d03d0e <os_memcmp+0x6>
c0d03d20:	2000      	movs	r0, #0
c0d03d22:	43c0      	mvns	r0, r0
c0d03d24:	2301      	movs	r3, #1
      return (BUF1[length] > BUF2[length])? 1:-1;
c0d03d26:	42ae      	cmp	r6, r5
c0d03d28:	d800      	bhi.n	c0d03d2c <os_memcmp+0x24>
c0d03d2a:	4603      	mov	r3, r0
  }
  return 0;
#undef BUF1
#undef BUF2

}
c0d03d2c:	b2d8      	uxtb	r0, r3
c0d03d2e:	bd70      	pop	{r4, r5, r6, pc}

c0d03d30 <os_longjmp>:
void try_context_set(try_context_t* ctx) {
  __asm volatile ("mov r9, %0"::"r"(ctx));
}

#ifndef HAVE_BOLOS
void os_longjmp(unsigned int exception) {
c0d03d30:	4601      	mov	r1, r0
  return xoracc;
}

try_context_t* try_context_get(void) {
  try_context_t* current_ctx;
  __asm volatile ("mov %0, r9":"=r"(current_ctx));
c0d03d32:	4648      	mov	r0, r9
  __asm volatile ("mov r9, %0"::"r"(ctx));
}

#ifndef HAVE_BOLOS
void os_longjmp(unsigned int exception) {
  longjmp(try_context_get()->jmp_buf, exception);
c0d03d34:	f002 fe46 	bl	c0d069c4 <longjmp>

c0d03d38 <try_context_get>:
  return xoracc;
}

try_context_t* try_context_get(void) {
  try_context_t* current_ctx;
  __asm volatile ("mov %0, r9":"=r"(current_ctx));
c0d03d38:	4648      	mov	r0, r9
  return current_ctx;
c0d03d3a:	4770      	bx	lr

c0d03d3c <try_context_get_previous>:
}

try_context_t* try_context_get_previous(void) {
c0d03d3c:	2000      	movs	r0, #0
  try_context_t* current_ctx;
  __asm volatile ("mov %0, r9":"=r"(current_ctx));
c0d03d3e:	4649      	mov	r1, r9

  // first context reached ?
  if (current_ctx == NULL) {
c0d03d40:	2900      	cmp	r1, #0
c0d03d42:	d000      	beq.n	c0d03d46 <try_context_get_previous+0xa>
  }

  // return r9 content saved on the current context. It links to the previous context.
  // r4 r5 r6 r7 r8 r9 r10 r11 sp lr
  //                ^ platform register
  return (try_context_t*) current_ctx->jmp_buf[5];
c0d03d44:	6948      	ldr	r0, [r1, #20]
}
c0d03d46:	4770      	bx	lr

c0d03d48 <io_seproxyhal_general_status>:

#ifndef IO_RAPDU_TRANSMIT_TIMEOUT_MS 
#define IO_RAPDU_TRANSMIT_TIMEOUT_MS 2000UL
#endif // IO_RAPDU_TRANSMIT_TIMEOUT_MS

void io_seproxyhal_general_status(void) {
c0d03d48:	b580      	push	{r7, lr}
  // avoid troubles
  if (io_seproxyhal_spi_is_status_sent()) {
c0d03d4a:	f001 f8b9 	bl	c0d04ec0 <io_seproxyhal_spi_is_status_sent>
c0d03d4e:	2800      	cmp	r0, #0
c0d03d50:	d000      	beq.n	c0d03d54 <io_seproxyhal_general_status+0xc>
  G_io_seproxyhal_spi_buffer[1] = 0;
  G_io_seproxyhal_spi_buffer[2] = 2;
  G_io_seproxyhal_spi_buffer[3] = SEPROXYHAL_TAG_GENERAL_STATUS_LAST_COMMAND>>8;
  G_io_seproxyhal_spi_buffer[4] = SEPROXYHAL_TAG_GENERAL_STATUS_LAST_COMMAND;
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 5);
}
c0d03d52:	bd80      	pop	{r7, pc}
  // avoid troubles
  if (io_seproxyhal_spi_is_status_sent()) {
    return;
  }
  // send the general status
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_GENERAL_STATUS;
c0d03d54:	4806      	ldr	r0, [pc, #24]	; (c0d03d70 <io_seproxyhal_general_status+0x28>)
c0d03d56:	2100      	movs	r1, #0
  G_io_seproxyhal_spi_buffer[1] = 0;
c0d03d58:	7041      	strb	r1, [r0, #1]
c0d03d5a:	2260      	movs	r2, #96	; 0x60
  // avoid troubles
  if (io_seproxyhal_spi_is_status_sent()) {
    return;
  }
  // send the general status
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_GENERAL_STATUS;
c0d03d5c:	7002      	strb	r2, [r0, #0]
c0d03d5e:	2202      	movs	r2, #2
  G_io_seproxyhal_spi_buffer[1] = 0;
  G_io_seproxyhal_spi_buffer[2] = 2;
c0d03d60:	7082      	strb	r2, [r0, #2]
  G_io_seproxyhal_spi_buffer[3] = SEPROXYHAL_TAG_GENERAL_STATUS_LAST_COMMAND>>8;
c0d03d62:	70c1      	strb	r1, [r0, #3]
  G_io_seproxyhal_spi_buffer[4] = SEPROXYHAL_TAG_GENERAL_STATUS_LAST_COMMAND;
c0d03d64:	7101      	strb	r1, [r0, #4]
c0d03d66:	2105      	movs	r1, #5
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 5);
c0d03d68:	f001 f894 	bl	c0d04e94 <io_seproxyhal_spi_send>
}
c0d03d6c:	bd80      	pop	{r7, pc}
c0d03d6e:	46c0      	nop			; (mov r8, r8)
c0d03d70:	20001800 	.word	0x20001800

c0d03d74 <io_seproxyhal_handle_usb_event>:
} G_io_usb_ep_timeouts[IO_USB_MAX_ENDPOINTS];
#include "usbd_def.h"
#include "usbd_core.h"
extern USBD_HandleTypeDef USBD_Device;

void io_seproxyhal_handle_usb_event(void) {
c0d03d74:	b510      	push	{r4, lr}
  switch(G_io_seproxyhal_spi_buffer[3]) {
c0d03d76:	4819      	ldr	r0, [pc, #100]	; (c0d03ddc <io_seproxyhal_handle_usb_event+0x68>)
c0d03d78:	78c0      	ldrb	r0, [r0, #3]
c0d03d7a:	2803      	cmp	r0, #3
c0d03d7c:	dc07      	bgt.n	c0d03d8e <io_seproxyhal_handle_usb_event+0x1a>
c0d03d7e:	2801      	cmp	r0, #1
c0d03d80:	d00d      	beq.n	c0d03d9e <io_seproxyhal_handle_usb_event+0x2a>
c0d03d82:	2802      	cmp	r0, #2
c0d03d84:	d126      	bne.n	c0d03dd4 <io_seproxyhal_handle_usb_event+0x60>
      }
      os_memset(G_io_usb_ep_xfer_len, 0, sizeof(G_io_usb_ep_xfer_len));
      os_memset(G_io_usb_ep_timeouts, 0, sizeof(G_io_usb_ep_timeouts));
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SOF:
      USBD_LL_SOF(&USBD_Device);
c0d03d86:	4816      	ldr	r0, [pc, #88]	; (c0d03de0 <io_seproxyhal_handle_usb_event+0x6c>)
c0d03d88:	f001 ff3b 	bl	c0d05c02 <USBD_LL_SOF>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
      break;
  }
}
c0d03d8c:	bd10      	pop	{r4, pc}
#include "usbd_def.h"
#include "usbd_core.h"
extern USBD_HandleTypeDef USBD_Device;

void io_seproxyhal_handle_usb_event(void) {
  switch(G_io_seproxyhal_spi_buffer[3]) {
c0d03d8e:	2804      	cmp	r0, #4
c0d03d90:	d01d      	beq.n	c0d03dce <io_seproxyhal_handle_usb_event+0x5a>
c0d03d92:	2808      	cmp	r0, #8
c0d03d94:	d11e      	bne.n	c0d03dd4 <io_seproxyhal_handle_usb_event+0x60>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SUSPENDED:
      USBD_LL_Suspend(&USBD_Device);
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
c0d03d96:	4812      	ldr	r0, [pc, #72]	; (c0d03de0 <io_seproxyhal_handle_usb_event+0x6c>)
c0d03d98:	f001 ff31 	bl	c0d05bfe <USBD_LL_Resume>
      break;
  }
}
c0d03d9c:	bd10      	pop	{r4, pc}
extern USBD_HandleTypeDef USBD_Device;

void io_seproxyhal_handle_usb_event(void) {
  switch(G_io_seproxyhal_spi_buffer[3]) {
    case SEPROXYHAL_TAG_USB_EVENT_RESET:
      USBD_LL_SetSpeed(&USBD_Device, USBD_SPEED_FULL);  
c0d03d9e:	4c10      	ldr	r4, [pc, #64]	; (c0d03de0 <io_seproxyhal_handle_usb_event+0x6c>)
c0d03da0:	2101      	movs	r1, #1
c0d03da2:	4620      	mov	r0, r4
c0d03da4:	f001 ff26 	bl	c0d05bf4 <USBD_LL_SetSpeed>
      USBD_LL_Reset(&USBD_Device);
c0d03da8:	4620      	mov	r0, r4
c0d03daa:	f001 ff04 	bl	c0d05bb6 <USBD_LL_Reset>
      // ongoing APDU detected, throw a reset, even if not the media. to avoid potential troubles.
      if (G_io_apdu_media != IO_APDU_MEDIA_NONE) {
c0d03dae:	480d      	ldr	r0, [pc, #52]	; (c0d03de4 <io_seproxyhal_handle_usb_event+0x70>)
c0d03db0:	7800      	ldrb	r0, [r0, #0]
c0d03db2:	2800      	cmp	r0, #0
c0d03db4:	d10f      	bne.n	c0d03dd6 <io_seproxyhal_handle_usb_event+0x62>
        THROW(EXCEPTION_IO_RESET);
      }
      os_memset(G_io_usb_ep_xfer_len, 0, sizeof(G_io_usb_ep_xfer_len));
c0d03db6:	480c      	ldr	r0, [pc, #48]	; (c0d03de8 <io_seproxyhal_handle_usb_event+0x74>)
c0d03db8:	2400      	movs	r4, #0
c0d03dba:	2206      	movs	r2, #6
c0d03dbc:	4621      	mov	r1, r4
c0d03dbe:	f7ff fedf 	bl	c0d03b80 <os_memset>
      os_memset(G_io_usb_ep_timeouts, 0, sizeof(G_io_usb_ep_timeouts));
c0d03dc2:	480a      	ldr	r0, [pc, #40]	; (c0d03dec <io_seproxyhal_handle_usb_event+0x78>)
c0d03dc4:	220c      	movs	r2, #12
c0d03dc6:	4621      	mov	r1, r4
c0d03dc8:	f7ff feda 	bl	c0d03b80 <os_memset>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
      break;
  }
}
c0d03dcc:	bd10      	pop	{r4, pc}
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SOF:
      USBD_LL_SOF(&USBD_Device);
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SUSPENDED:
      USBD_LL_Suspend(&USBD_Device);
c0d03dce:	4804      	ldr	r0, [pc, #16]	; (c0d03de0 <io_seproxyhal_handle_usb_event+0x6c>)
c0d03dd0:	f001 ff13 	bl	c0d05bfa <USBD_LL_Suspend>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
      break;
  }
}
c0d03dd4:	bd10      	pop	{r4, pc}
c0d03dd6:	2010      	movs	r0, #16
    case SEPROXYHAL_TAG_USB_EVENT_RESET:
      USBD_LL_SetSpeed(&USBD_Device, USBD_SPEED_FULL);  
      USBD_LL_Reset(&USBD_Device);
      // ongoing APDU detected, throw a reset, even if not the media. to avoid potential troubles.
      if (G_io_apdu_media != IO_APDU_MEDIA_NONE) {
        THROW(EXCEPTION_IO_RESET);
c0d03dd8:	f7ff ffaa 	bl	c0d03d30 <os_longjmp>
c0d03ddc:	20001800 	.word	0x20001800
c0d03de0:	200023b8 	.word	0x200023b8
c0d03de4:	200022c8 	.word	0x200022c8
c0d03de8:	200022c9 	.word	0x200022c9
c0d03dec:	200022d0 	.word	0x200022d0

c0d03df0 <io_seproxyhal_get_ep_rx_size>:
      USBD_LL_Resume(&USBD_Device);
      break;
  }
}

uint16_t io_seproxyhal_get_ep_rx_size(uint8_t epnum) {
c0d03df0:	217f      	movs	r1, #127	; 0x7f
  return G_io_usb_ep_xfer_len[epnum&0x7F];
c0d03df2:	4001      	ands	r1, r0
c0d03df4:	4801      	ldr	r0, [pc, #4]	; (c0d03dfc <io_seproxyhal_get_ep_rx_size+0xc>)
c0d03df6:	5c40      	ldrb	r0, [r0, r1]
c0d03df8:	4770      	bx	lr
c0d03dfa:	46c0      	nop			; (mov r8, r8)
c0d03dfc:	200022c9 	.word	0x200022c9

c0d03e00 <io_seproxyhal_handle_usb_ep_xfer_event>:
}

void io_seproxyhal_handle_usb_ep_xfer_event(void) {
c0d03e00:	b510      	push	{r4, lr}
  switch(G_io_seproxyhal_spi_buffer[4]) {
c0d03e02:	4814      	ldr	r0, [pc, #80]	; (c0d03e54 <io_seproxyhal_handle_usb_ep_xfer_event+0x54>)
c0d03e04:	7901      	ldrb	r1, [r0, #4]
c0d03e06:	2904      	cmp	r1, #4
c0d03e08:	d016      	beq.n	c0d03e38 <io_seproxyhal_handle_usb_ep_xfer_event+0x38>
c0d03e0a:	2902      	cmp	r1, #2
c0d03e0c:	d006      	beq.n	c0d03e1c <io_seproxyhal_handle_usb_ep_xfer_event+0x1c>
c0d03e0e:	2901      	cmp	r1, #1
c0d03e10:	d11e      	bne.n	c0d03e50 <io_seproxyhal_handle_usb_ep_xfer_event+0x50>
    /* This event is received when a new SETUP token had been received on a control endpoint */
    case SEPROXYHAL_TAG_USB_EP_XFER_SETUP:
      // assume length of setup packet, and that it is on endpoint 0
      USBD_LL_SetupStage(&USBD_Device, &G_io_seproxyhal_spi_buffer[6]);
c0d03e12:	1d81      	adds	r1, r0, #6
c0d03e14:	4811      	ldr	r0, [pc, #68]	; (c0d03e5c <io_seproxyhal_handle_usb_ep_xfer_event+0x5c>)
c0d03e16:	f001 fdd4 	bl	c0d059c2 <USBD_LL_SetupStage>
        // prepare reception
        USBD_LL_DataOutStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
      }
      break;
  }
}
c0d03e1a:	bd10      	pop	{r4, pc}
      USBD_LL_SetupStage(&USBD_Device, &G_io_seproxyhal_spi_buffer[6]);
      break;

    /* This event is received after the prepare data packet has been flushed to the usb host */
    case SEPROXYHAL_TAG_USB_EP_XFER_IN:
      if ((G_io_seproxyhal_spi_buffer[3]&0x7F) < IO_USB_MAX_ENDPOINTS) {
c0d03e1c:	78c2      	ldrb	r2, [r0, #3]
c0d03e1e:	217f      	movs	r1, #127	; 0x7f
c0d03e20:	4011      	ands	r1, r2
c0d03e22:	2905      	cmp	r1, #5
c0d03e24:	d814      	bhi.n	c0d03e50 <io_seproxyhal_handle_usb_ep_xfer_event+0x50>
        // discard ep timeout as we received the sent packet confirmation
        G_io_usb_ep_timeouts[G_io_seproxyhal_spi_buffer[3]&0x7F].timeout = 0;
c0d03e26:	004a      	lsls	r2, r1, #1
c0d03e28:	4b0d      	ldr	r3, [pc, #52]	; (c0d03e60 <io_seproxyhal_handle_usb_ep_xfer_event+0x60>)
c0d03e2a:	2400      	movs	r4, #0
c0d03e2c:	529c      	strh	r4, [r3, r2]
        // propagate sending ack of the data
        USBD_LL_DataInStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
c0d03e2e:	1d82      	adds	r2, r0, #6
c0d03e30:	480a      	ldr	r0, [pc, #40]	; (c0d03e5c <io_seproxyhal_handle_usb_ep_xfer_event+0x5c>)
c0d03e32:	f001 fe4c 	bl	c0d05ace <USBD_LL_DataInStage>
        // prepare reception
        USBD_LL_DataOutStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
      }
      break;
  }
}
c0d03e36:	bd10      	pop	{r4, pc}
      }
      break;

    /* This event is received when a new DATA token is received on an endpoint */
    case SEPROXYHAL_TAG_USB_EP_XFER_OUT:
      if ((G_io_seproxyhal_spi_buffer[3]&0x7F) < IO_USB_MAX_ENDPOINTS) {
c0d03e38:	78c2      	ldrb	r2, [r0, #3]
c0d03e3a:	217f      	movs	r1, #127	; 0x7f
c0d03e3c:	4011      	ands	r1, r2
c0d03e3e:	2905      	cmp	r1, #5
c0d03e40:	d806      	bhi.n	c0d03e50 <io_seproxyhal_handle_usb_ep_xfer_event+0x50>
        // saved just in case it is needed ...
        G_io_usb_ep_xfer_len[G_io_seproxyhal_spi_buffer[3]&0x7F] = G_io_seproxyhal_spi_buffer[5];
c0d03e42:	7942      	ldrb	r2, [r0, #5]
c0d03e44:	4b04      	ldr	r3, [pc, #16]	; (c0d03e58 <io_seproxyhal_handle_usb_ep_xfer_event+0x58>)
c0d03e46:	545a      	strb	r2, [r3, r1]
        // prepare reception
        USBD_LL_DataOutStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
c0d03e48:	1d82      	adds	r2, r0, #6
c0d03e4a:	4804      	ldr	r0, [pc, #16]	; (c0d03e5c <io_seproxyhal_handle_usb_ep_xfer_event+0x5c>)
c0d03e4c:	f001 fde7 	bl	c0d05a1e <USBD_LL_DataOutStage>
      }
      break;
  }
}
c0d03e50:	bd10      	pop	{r4, pc}
c0d03e52:	46c0      	nop			; (mov r8, r8)
c0d03e54:	20001800 	.word	0x20001800
c0d03e58:	200022c9 	.word	0x200022c9
c0d03e5c:	200023b8 	.word	0x200023b8
c0d03e60:	200022d0 	.word	0x200022d0

c0d03e64 <io_usb_send_ep>:
#endif // HAVE_L4_USBLIB

// TODO, refactor this using the USB DataIn event like for the U2F tunnel
// TODO add a blocking parameter, for HID KBD sending, or use a USB busy flag per channel to know if 
// the transfer has been processed or not. and move on to the next transfer on the same endpoint
void io_usb_send_ep(unsigned int ep, unsigned char* buffer, unsigned short length, unsigned int timeout) {
c0d03e64:	b570      	push	{r4, r5, r6, lr}
  if (timeout) {
    timeout++;
  }

  // won't send if overflowing seproxyhal buffer format
  if (length > 255) {
c0d03e66:	2aff      	cmp	r2, #255	; 0xff
c0d03e68:	d81d      	bhi.n	c0d03ea6 <io_usb_send_ep+0x42>
c0d03e6a:	4615      	mov	r5, r2
c0d03e6c:	460e      	mov	r6, r1
c0d03e6e:	4604      	mov	r4, r0
    return;
  }
  
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d03e70:	480d      	ldr	r0, [pc, #52]	; (c0d03ea8 <io_usb_send_ep+0x44>)
c0d03e72:	2150      	movs	r1, #80	; 0x50
c0d03e74:	7001      	strb	r1, [r0, #0]
c0d03e76:	2120      	movs	r1, #32
  G_io_seproxyhal_spi_buffer[1] = (3+length)>>8;
  G_io_seproxyhal_spi_buffer[2] = (3+length);
  G_io_seproxyhal_spi_buffer[3] = ep|0x80;
  G_io_seproxyhal_spi_buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_IN;
c0d03e78:	7101      	strb	r1, [r0, #4]
  G_io_seproxyhal_spi_buffer[5] = length;
c0d03e7a:	7142      	strb	r2, [r0, #5]
  if (length > 255) {
    return;
  }
  
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
  G_io_seproxyhal_spi_buffer[1] = (3+length)>>8;
c0d03e7c:	1cd1      	adds	r1, r2, #3
  G_io_seproxyhal_spi_buffer[2] = (3+length);
c0d03e7e:	7081      	strb	r1, [r0, #2]
c0d03e80:	2280      	movs	r2, #128	; 0x80
  G_io_seproxyhal_spi_buffer[3] = ep|0x80;
c0d03e82:	4322      	orrs	r2, r4
c0d03e84:	70c2      	strb	r2, [r0, #3]
  if (length > 255) {
    return;
  }
  
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
  G_io_seproxyhal_spi_buffer[1] = (3+length)>>8;
c0d03e86:	0a09      	lsrs	r1, r1, #8
c0d03e88:	7041      	strb	r1, [r0, #1]
c0d03e8a:	2106      	movs	r1, #6
  G_io_seproxyhal_spi_buffer[2] = (3+length);
  G_io_seproxyhal_spi_buffer[3] = ep|0x80;
  G_io_seproxyhal_spi_buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_IN;
  G_io_seproxyhal_spi_buffer[5] = length;
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 6);
c0d03e8c:	f001 f802 	bl	c0d04e94 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send(buffer, length);
c0d03e90:	4630      	mov	r0, r6
c0d03e92:	4629      	mov	r1, r5
c0d03e94:	f000 fffe 	bl	c0d04e94 <io_seproxyhal_spi_send>
c0d03e98:	207f      	movs	r0, #127	; 0x7f
  // setup timeout of the endpoint
  G_io_usb_ep_timeouts[ep&0x7F].timeout = IO_RAPDU_TRANSMIT_TIMEOUT_MS;
c0d03e9a:	4020      	ands	r0, r4
c0d03e9c:	0040      	lsls	r0, r0, #1
c0d03e9e:	217d      	movs	r1, #125	; 0x7d
c0d03ea0:	0109      	lsls	r1, r1, #4
c0d03ea2:	4a02      	ldr	r2, [pc, #8]	; (c0d03eac <io_usb_send_ep+0x48>)
c0d03ea4:	5211      	strh	r1, [r2, r0]

}
c0d03ea6:	bd70      	pop	{r4, r5, r6, pc}
c0d03ea8:	20001800 	.word	0x20001800
c0d03eac:	200022d0 	.word	0x200022d0

c0d03eb0 <io_usb_send_apdu_data>:

void io_usb_send_apdu_data(unsigned char* buffer, unsigned short length) {
c0d03eb0:	b580      	push	{r7, lr}
c0d03eb2:	460a      	mov	r2, r1
c0d03eb4:	4601      	mov	r1, r0
c0d03eb6:	2082      	movs	r0, #130	; 0x82
c0d03eb8:	2314      	movs	r3, #20
  // wait for 20 events before hanging up and timeout (~2 seconds of timeout)
  io_usb_send_ep(0x82, buffer, length, 20);
c0d03eba:	f7ff ffd3 	bl	c0d03e64 <io_usb_send_ep>
}
c0d03ebe:	bd80      	pop	{r7, pc}

c0d03ec0 <io_seproxyhal_handle_capdu_event>:

}
#endif


void io_seproxyhal_handle_capdu_event(void) {
c0d03ec0:	b580      	push	{r7, lr}
  if(G_io_apdu_state == APDU_IDLE) 
c0d03ec2:	480e      	ldr	r0, [pc, #56]	; (c0d03efc <io_seproxyhal_handle_capdu_event+0x3c>)
c0d03ec4:	7801      	ldrb	r1, [r0, #0]
c0d03ec6:	2900      	cmp	r1, #0
c0d03ec8:	d000      	beq.n	c0d03ecc <io_seproxyhal_handle_capdu_event+0xc>
    G_io_apdu_state = APDU_RAW; // for next call to io_exchange
    G_io_apdu_length = MIN(U2BE(G_io_seproxyhal_spi_buffer, 1), sizeof(G_io_apdu_buffer)); 
    // copy apdu to apdu buffer
    os_memmove(G_io_apdu_buffer, G_io_seproxyhal_spi_buffer+3, G_io_apdu_length);
  }
}
c0d03eca:	bd80      	pop	{r7, pc}


void io_seproxyhal_handle_capdu_event(void) {
  if(G_io_apdu_state == APDU_IDLE) 
  {
    G_io_apdu_media = IO_APDU_MEDIA_RAW; // for application code
c0d03ecc:	490c      	ldr	r1, [pc, #48]	; (c0d03f00 <io_seproxyhal_handle_capdu_event+0x40>)
c0d03ece:	2206      	movs	r2, #6
c0d03ed0:	700a      	strb	r2, [r1, #0]
c0d03ed2:	210a      	movs	r1, #10
    G_io_apdu_state = APDU_RAW; // for next call to io_exchange
c0d03ed4:	7001      	strb	r1, [r0, #0]
    G_io_apdu_length = MIN(U2BE(G_io_seproxyhal_spi_buffer, 1), sizeof(G_io_apdu_buffer)); 
c0d03ed6:	480b      	ldr	r0, [pc, #44]	; (c0d03f04 <io_seproxyhal_handle_capdu_event+0x44>)
c0d03ed8:	7881      	ldrb	r1, [r0, #2]
c0d03eda:	7842      	ldrb	r2, [r0, #1]
c0d03edc:	0212      	lsls	r2, r2, #8
c0d03ede:	1851      	adds	r1, r2, r1
c0d03ee0:	22ff      	movs	r2, #255	; 0xff
c0d03ee2:	3252      	adds	r2, #82	; 0x52
c0d03ee4:	4291      	cmp	r1, r2
c0d03ee6:	d300      	bcc.n	c0d03eea <io_seproxyhal_handle_capdu_event+0x2a>
c0d03ee8:	4611      	mov	r1, r2
c0d03eea:	4a07      	ldr	r2, [pc, #28]	; (c0d03f08 <io_seproxyhal_handle_capdu_event+0x48>)
c0d03eec:	8011      	strh	r1, [r2, #0]
    // copy apdu to apdu buffer
    os_memmove(G_io_apdu_buffer, G_io_seproxyhal_spi_buffer+3, G_io_apdu_length);
c0d03eee:	8812      	ldrh	r2, [r2, #0]
c0d03ef0:	1cc1      	adds	r1, r0, #3
c0d03ef2:	4806      	ldr	r0, [pc, #24]	; (c0d03f0c <io_seproxyhal_handle_capdu_event+0x4c>)
c0d03ef4:	f7ff fe4d 	bl	c0d03b92 <os_memmove>
  }
}
c0d03ef8:	bd80      	pop	{r7, pc}
c0d03efa:	46c0      	nop			; (mov r8, r8)
c0d03efc:	200022dc 	.word	0x200022dc
c0d03f00:	200022c8 	.word	0x200022c8
c0d03f04:	20001800 	.word	0x20001800
c0d03f08:	200022de 	.word	0x200022de
c0d03f0c:	2000216c 	.word	0x2000216c

c0d03f10 <io_seproxyhal_handle_event>:

unsigned int io_seproxyhal_handle_event(void) {
c0d03f10:	b510      	push	{r4, lr}
  unsigned int rx_len = U2BE(G_io_seproxyhal_spi_buffer, 1);
c0d03f12:	481f      	ldr	r0, [pc, #124]	; (c0d03f90 <io_seproxyhal_handle_event+0x80>)
c0d03f14:	7881      	ldrb	r1, [r0, #2]
c0d03f16:	7842      	ldrb	r2, [r0, #1]
c0d03f18:	0212      	lsls	r2, r2, #8
c0d03f1a:	1851      	adds	r1, r2, r1

  switch(G_io_seproxyhal_spi_buffer[0]) {
c0d03f1c:	7800      	ldrb	r0, [r0, #0]
c0d03f1e:	280f      	cmp	r0, #15
c0d03f20:	dc0a      	bgt.n	c0d03f38 <io_seproxyhal_handle_event+0x28>
c0d03f22:	280e      	cmp	r0, #14
c0d03f24:	d010      	beq.n	c0d03f48 <io_seproxyhal_handle_event+0x38>
c0d03f26:	280f      	cmp	r0, #15
c0d03f28:	d120      	bne.n	c0d03f6c <io_seproxyhal_handle_event+0x5c>
c0d03f2a:	2000      	movs	r0, #0
  #ifdef HAVE_IO_USB
    case SEPROXYHAL_TAG_USB_EVENT:
      if (rx_len != 1) {
c0d03f2c:	2901      	cmp	r1, #1
c0d03f2e:	d124      	bne.n	c0d03f7a <io_seproxyhal_handle_event+0x6a>
        return 0;
      }
      io_seproxyhal_handle_usb_event();
c0d03f30:	f7ff ff20 	bl	c0d03d74 <io_seproxyhal_handle_usb_event>
c0d03f34:	2001      	movs	r0, #1
    default:
      return io_event(CHANNEL_SPI);
  }
  // defaultly return as not processed
  return 0;
}
c0d03f36:	bd10      	pop	{r4, pc}
}

unsigned int io_seproxyhal_handle_event(void) {
  unsigned int rx_len = U2BE(G_io_seproxyhal_spi_buffer, 1);

  switch(G_io_seproxyhal_spi_buffer[0]) {
c0d03f38:	2810      	cmp	r0, #16
c0d03f3a:	d01b      	beq.n	c0d03f74 <io_seproxyhal_handle_event+0x64>
c0d03f3c:	2816      	cmp	r0, #22
c0d03f3e:	d115      	bne.n	c0d03f6c <io_seproxyhal_handle_event+0x5c>
      }
      return 1;
  #endif // HAVE_BLE

    case SEPROXYHAL_TAG_CAPDU_EVENT:
      io_seproxyhal_handle_capdu_event();
c0d03f40:	f7ff ffbe 	bl	c0d03ec0 <io_seproxyhal_handle_capdu_event>
c0d03f44:	2001      	movs	r0, #1
    default:
      return io_event(CHANNEL_SPI);
  }
  // defaultly return as not processed
  return 0;
}
c0d03f46:	bd10      	pop	{r4, pc}
c0d03f48:	210a      	movs	r1, #10
c0d03f4a:	4812      	ldr	r0, [pc, #72]	; (c0d03f94 <io_seproxyhal_handle_event+0x84>)
      // process ticker events to timeout the IO transfers, and forward to the user io_event function too
#ifdef HAVE_IO_USB
      {
        unsigned int i = IO_USB_MAX_ENDPOINTS;
        while(i--) {
          if (G_io_usb_ep_timeouts[i].timeout) {
c0d03f4c:	5a42      	ldrh	r2, [r0, r1]
c0d03f4e:	2a00      	cmp	r2, #0
c0d03f50:	d008      	beq.n	c0d03f64 <io_seproxyhal_handle_event+0x54>
c0d03f52:	2364      	movs	r3, #100	; 0x64
            G_io_usb_ep_timeouts[i].timeout-=MIN(G_io_usb_ep_timeouts[i].timeout, 100);
c0d03f54:	2a64      	cmp	r2, #100	; 0x64
c0d03f56:	4614      	mov	r4, r2
c0d03f58:	d300      	bcc.n	c0d03f5c <io_seproxyhal_handle_event+0x4c>
c0d03f5a:	461c      	mov	r4, r3
c0d03f5c:	1b12      	subs	r2, r2, r4
c0d03f5e:	5242      	strh	r2, [r0, r1]
            if (!G_io_usb_ep_timeouts[i].timeout) {
c0d03f60:	0412      	lsls	r2, r2, #16
c0d03f62:	d00f      	beq.n	c0d03f84 <io_seproxyhal_handle_event+0x74>
    case SEPROXYHAL_TAG_TICKER_EVENT:
      // process ticker events to timeout the IO transfers, and forward to the user io_event function too
#ifdef HAVE_IO_USB
      {
        unsigned int i = IO_USB_MAX_ENDPOINTS;
        while(i--) {
c0d03f64:	1e8a      	subs	r2, r1, #2
c0d03f66:	2900      	cmp	r1, #0
c0d03f68:	4611      	mov	r1, r2
c0d03f6a:	d1ef      	bne.n	c0d03f4c <io_seproxyhal_handle_event+0x3c>
c0d03f6c:	2002      	movs	r0, #2
        }
      }
#endif // HAVE_IO_USB
      // no break is intentional
    default:
      return io_event(CHANNEL_SPI);
c0d03f6e:	f7fe f90d 	bl	c0d0218c <io_event>
  }
  // defaultly return as not processed
  return 0;
}
c0d03f72:	bd10      	pop	{r4, pc}
c0d03f74:	2000      	movs	r0, #0
      }
      io_seproxyhal_handle_usb_event();
      return 1;

    case SEPROXYHAL_TAG_USB_EP_XFER_EVENT:
      if (rx_len < 3) {
c0d03f76:	2903      	cmp	r1, #3
c0d03f78:	d200      	bcs.n	c0d03f7c <io_seproxyhal_handle_event+0x6c>
    default:
      return io_event(CHANNEL_SPI);
  }
  // defaultly return as not processed
  return 0;
}
c0d03f7a:	bd10      	pop	{r4, pc}
    case SEPROXYHAL_TAG_USB_EP_XFER_EVENT:
      if (rx_len < 3) {
        // error !
        return 0;
      }
      io_seproxyhal_handle_usb_ep_xfer_event();
c0d03f7c:	f7ff ff40 	bl	c0d03e00 <io_seproxyhal_handle_usb_ep_xfer_event>
c0d03f80:	2001      	movs	r0, #1
    default:
      return io_event(CHANNEL_SPI);
  }
  // defaultly return as not processed
  return 0;
}
c0d03f82:	bd10      	pop	{r4, pc}
        while(i--) {
          if (G_io_usb_ep_timeouts[i].timeout) {
            G_io_usb_ep_timeouts[i].timeout-=MIN(G_io_usb_ep_timeouts[i].timeout, 100);
            if (!G_io_usb_ep_timeouts[i].timeout) {
              // timeout !
              G_io_apdu_state = APDU_IDLE;
c0d03f84:	4804      	ldr	r0, [pc, #16]	; (c0d03f98 <io_seproxyhal_handle_event+0x88>)
c0d03f86:	2100      	movs	r1, #0
c0d03f88:	7001      	strb	r1, [r0, #0]
c0d03f8a:	2010      	movs	r0, #16
              THROW(EXCEPTION_IO_RESET);
c0d03f8c:	f7ff fed0 	bl	c0d03d30 <os_longjmp>
c0d03f90:	20001800 	.word	0x20001800
c0d03f94:	200022d0 	.word	0x200022d0
c0d03f98:	200022dc 	.word	0x200022dc

c0d03f9c <io_seproxyhal_init>:
#ifdef HAVE_BOLOS_APP_STACK_CANARY
#define APP_STACK_CANARY_MAGIC 0xDEAD0031
extern unsigned int app_stack_canary;
#endif // HAVE_BOLOS_APP_STACK_CANARY

void io_seproxyhal_init(void) {
c0d03f9c:	b510      	push	{r4, lr}
c0d03f9e:	2009      	movs	r0, #9
  // Enforce OS compatibility
  check_api_level(CX_COMPAT_APILEVEL);
c0d03fa0:	f000 fcfc 	bl	c0d0499c <check_api_level>

#ifdef HAVE_BOLOS_APP_STACK_CANARY
  app_stack_canary = APP_STACK_CANARY_MAGIC;
#endif // HAVE_BOLOS_APP_STACK_CANARY  

  G_io_apdu_state = APDU_IDLE;
c0d03fa4:	4807      	ldr	r0, [pc, #28]	; (c0d03fc4 <io_seproxyhal_init+0x28>)
c0d03fa6:	2400      	movs	r4, #0
c0d03fa8:	7004      	strb	r4, [r0, #0]
  G_io_apdu_length = 0;
c0d03faa:	4807      	ldr	r0, [pc, #28]	; (c0d03fc8 <io_seproxyhal_init+0x2c>)
c0d03fac:	8004      	strh	r4, [r0, #0]
  G_io_apdu_media = IO_APDU_MEDIA_NONE;
c0d03fae:	4807      	ldr	r0, [pc, #28]	; (c0d03fcc <io_seproxyhal_init+0x30>)
c0d03fb0:	7004      	strb	r4, [r0, #0]
  debug_apdus_offset = 0;
  #endif // DEBUG_APDU


  #ifdef HAVE_USB_APDU
  io_usb_hid_init();
c0d03fb2:	f7ff fe05 	bl	c0d03bc0 <io_usb_hid_init>
  io_seproxyhal_init_button();
}

void io_seproxyhal_init_ux(void) {
  // initialize the touch part
  G_bagl_last_touched_not_released_component = NULL;
c0d03fb6:	4806      	ldr	r0, [pc, #24]	; (c0d03fd0 <io_seproxyhal_init+0x34>)
c0d03fb8:	6004      	str	r4, [r0, #0]
}

void io_seproxyhal_init_button(void) {
  // no button push so far
  G_button_mask = 0;
c0d03fba:	4806      	ldr	r0, [pc, #24]	; (c0d03fd4 <io_seproxyhal_init+0x38>)
c0d03fbc:	6004      	str	r4, [r0, #0]
  G_button_same_mask_counter = 0;
c0d03fbe:	4806      	ldr	r0, [pc, #24]	; (c0d03fd8 <io_seproxyhal_init+0x3c>)
c0d03fc0:	6004      	str	r4, [r0, #0]
  io_usb_hid_init();
  #endif // HAVE_USB_APDU

  io_seproxyhal_init_ux();
  io_seproxyhal_init_button();
}
c0d03fc2:	bd10      	pop	{r4, pc}
c0d03fc4:	200022dc 	.word	0x200022dc
c0d03fc8:	200022de 	.word	0x200022de
c0d03fcc:	200022c8 	.word	0x200022c8
c0d03fd0:	200022e0 	.word	0x200022e0
c0d03fd4:	200022e4 	.word	0x200022e4
c0d03fd8:	200022e8 	.word	0x200022e8

c0d03fdc <io_seproxyhal_init_ux>:

void io_seproxyhal_init_ux(void) {
  // initialize the touch part
  G_bagl_last_touched_not_released_component = NULL;
c0d03fdc:	4801      	ldr	r0, [pc, #4]	; (c0d03fe4 <io_seproxyhal_init_ux+0x8>)
c0d03fde:	2100      	movs	r1, #0
c0d03fe0:	6001      	str	r1, [r0, #0]
}
c0d03fe2:	4770      	bx	lr
c0d03fe4:	200022e0 	.word	0x200022e0

c0d03fe8 <io_seproxyhal_init_button>:

void io_seproxyhal_init_button(void) {
  // no button push so far
  G_button_mask = 0;
c0d03fe8:	4802      	ldr	r0, [pc, #8]	; (c0d03ff4 <io_seproxyhal_init_button+0xc>)
c0d03fea:	2100      	movs	r1, #0
c0d03fec:	6001      	str	r1, [r0, #0]
  G_button_same_mask_counter = 0;
c0d03fee:	4802      	ldr	r0, [pc, #8]	; (c0d03ff8 <io_seproxyhal_init_button+0x10>)
c0d03ff0:	6001      	str	r1, [r0, #0]
}
c0d03ff2:	4770      	bx	lr
c0d03ff4:	200022e4 	.word	0x200022e4
c0d03ff8:	200022e8 	.word	0x200022e8

c0d03ffc <io_seproxyhal_touch_out>:

#ifdef HAVE_BAGL

unsigned int io_seproxyhal_touch_out(const bagl_element_t* element, bagl_element_callback_t before_display) {
c0d03ffc:	b5b0      	push	{r4, r5, r7, lr}
c0d03ffe:	460d      	mov	r5, r1
c0d04000:	4604      	mov	r4, r0
  const bagl_element_t* el;
  if (element->out != NULL) {
c0d04002:	6b00      	ldr	r0, [r0, #48]	; 0x30
c0d04004:	2800      	cmp	r0, #0
c0d04006:	d00b      	beq.n	c0d04020 <io_seproxyhal_touch_out+0x24>
    el = (const bagl_element_t*)PIC(((bagl_element_callback_t)PIC(element->out))(element));
c0d04008:	f000 fcb0 	bl	c0d0496c <pic>
c0d0400c:	4601      	mov	r1, r0
c0d0400e:	4620      	mov	r0, r4
c0d04010:	4788      	blx	r1
c0d04012:	f000 fcab 	bl	c0d0496c <pic>
    // backward compatible with samples and such
    if (! el) {
c0d04016:	2800      	cmp	r0, #0
c0d04018:	d00f      	beq.n	c0d0403a <io_seproxyhal_touch_out+0x3e>
c0d0401a:	2801      	cmp	r0, #1
c0d0401c:	d000      	beq.n	c0d04020 <io_seproxyhal_touch_out+0x24>
c0d0401e:	4604      	mov	r4, r0
      element = el;
    }
  }

  // out function might have triggered a draw of its own during a display callback
  if (before_display) {
c0d04020:	2d00      	cmp	r5, #0
c0d04022:	d006      	beq.n	c0d04032 <io_seproxyhal_touch_out+0x36>
    el = before_display(element);
c0d04024:	4620      	mov	r0, r4
c0d04026:	47a8      	blx	r5
    if (!el) {
c0d04028:	2800      	cmp	r0, #0
c0d0402a:	d006      	beq.n	c0d0403a <io_seproxyhal_touch_out+0x3e>
c0d0402c:	2801      	cmp	r0, #1
c0d0402e:	d000      	beq.n	c0d04032 <io_seproxyhal_touch_out+0x36>
c0d04030:	4604      	mov	r4, r0
    if ((unsigned int)el != 1) {
      element = el;
    }
  }

  io_seproxyhal_display(element);
c0d04032:	4620      	mov	r0, r4
c0d04034:	f7ff fb18 	bl	c0d03668 <io_seproxyhal_display>
c0d04038:	2001      	movs	r0, #1
  return 1;
}
c0d0403a:	bdb0      	pop	{r4, r5, r7, pc}

c0d0403c <io_seproxyhal_touch_over>:

unsigned int io_seproxyhal_touch_over(const bagl_element_t* element, bagl_element_callback_t before_display) {
c0d0403c:	b5b0      	push	{r4, r5, r7, lr}
c0d0403e:	b08e      	sub	sp, #56	; 0x38
c0d04040:	460d      	mov	r5, r1
c0d04042:	4604      	mov	r4, r0
  bagl_element_t e;
  const bagl_element_t* el;
  if (element->over != NULL) {
c0d04044:	6b40      	ldr	r0, [r0, #52]	; 0x34
c0d04046:	2800      	cmp	r0, #0
c0d04048:	d00b      	beq.n	c0d04062 <io_seproxyhal_touch_over+0x26>
    el = (const bagl_element_t*)PIC(((bagl_element_callback_t)PIC(element->over))(element));
c0d0404a:	f000 fc8f 	bl	c0d0496c <pic>
c0d0404e:	4601      	mov	r1, r0
c0d04050:	4620      	mov	r0, r4
c0d04052:	4788      	blx	r1
c0d04054:	f000 fc8a 	bl	c0d0496c <pic>
    // backward compatible with samples and such
    if (!el) {
c0d04058:	2800      	cmp	r0, #0
c0d0405a:	d01a      	beq.n	c0d04092 <io_seproxyhal_touch_over+0x56>
c0d0405c:	2801      	cmp	r0, #1
c0d0405e:	d000      	beq.n	c0d04062 <io_seproxyhal_touch_over+0x26>
c0d04060:	4604      	mov	r4, r0
      element = el;
    }
  }

  // over function might have triggered a draw of its own during a display callback
  if (before_display) {
c0d04062:	2d00      	cmp	r5, #0
c0d04064:	d007      	beq.n	c0d04076 <io_seproxyhal_touch_over+0x3a>
    el = before_display(element);
c0d04066:	4620      	mov	r0, r4
c0d04068:	47a8      	blx	r5
c0d0406a:	466c      	mov	r4, sp
    element = &e;
    if (!el) {
c0d0406c:	2800      	cmp	r0, #0
c0d0406e:	d010      	beq.n	c0d04092 <io_seproxyhal_touch_over+0x56>
c0d04070:	2801      	cmp	r0, #1
c0d04072:	d000      	beq.n	c0d04076 <io_seproxyhal_touch_over+0x3a>
c0d04074:	4604      	mov	r4, r0
c0d04076:	466d      	mov	r5, sp
c0d04078:	2238      	movs	r2, #56	; 0x38
      element = el;
    }
  }

  // swap colors
  os_memmove(&e, (void*)element, sizeof(bagl_element_t));
c0d0407a:	4628      	mov	r0, r5
c0d0407c:	4621      	mov	r1, r4
c0d0407e:	f7ff fd88 	bl	c0d03b92 <os_memmove>
  e.component.fgcolor = element->overfgcolor;
c0d04082:	6a60      	ldr	r0, [r4, #36]	; 0x24
  e.component.bgcolor = element->overbgcolor;
c0d04084:	6aa1      	ldr	r1, [r4, #40]	; 0x28
    }
  }

  // swap colors
  os_memmove(&e, (void*)element, sizeof(bagl_element_t));
  e.component.fgcolor = element->overfgcolor;
c0d04086:	9004      	str	r0, [sp, #16]
  e.component.bgcolor = element->overbgcolor;
c0d04088:	9105      	str	r1, [sp, #20]

  io_seproxyhal_display(&e);
c0d0408a:	4628      	mov	r0, r5
c0d0408c:	f7ff faec 	bl	c0d03668 <io_seproxyhal_display>
c0d04090:	2001      	movs	r0, #1
  return 1;
}
c0d04092:	b00e      	add	sp, #56	; 0x38
c0d04094:	bdb0      	pop	{r4, r5, r7, pc}

c0d04096 <io_seproxyhal_touch_tap>:

unsigned int io_seproxyhal_touch_tap(const bagl_element_t* element, bagl_element_callback_t before_display) {
c0d04096:	b5b0      	push	{r4, r5, r7, lr}
c0d04098:	460d      	mov	r5, r1
c0d0409a:	4604      	mov	r4, r0
  const bagl_element_t* el;
  if (element->tap != NULL) {
c0d0409c:	6ac0      	ldr	r0, [r0, #44]	; 0x2c
c0d0409e:	2800      	cmp	r0, #0
c0d040a0:	d00b      	beq.n	c0d040ba <io_seproxyhal_touch_tap+0x24>
    el = (const bagl_element_t*)PIC(((bagl_element_callback_t)PIC(element->tap))(element));
c0d040a2:	f000 fc63 	bl	c0d0496c <pic>
c0d040a6:	4601      	mov	r1, r0
c0d040a8:	4620      	mov	r0, r4
c0d040aa:	4788      	blx	r1
c0d040ac:	f000 fc5e 	bl	c0d0496c <pic>
    // backward compatible with samples and such
    if (!el) {
c0d040b0:	2800      	cmp	r0, #0
c0d040b2:	d00f      	beq.n	c0d040d4 <io_seproxyhal_touch_tap+0x3e>
c0d040b4:	2801      	cmp	r0, #1
c0d040b6:	d000      	beq.n	c0d040ba <io_seproxyhal_touch_tap+0x24>
c0d040b8:	4604      	mov	r4, r0
      element = el;
    }
  }

  // tap function might have triggered a draw of its own during a display callback
  if (before_display) {
c0d040ba:	2d00      	cmp	r5, #0
c0d040bc:	d006      	beq.n	c0d040cc <io_seproxyhal_touch_tap+0x36>
    el = before_display(element);
c0d040be:	4620      	mov	r0, r4
c0d040c0:	47a8      	blx	r5
    if (!el) {
c0d040c2:	2800      	cmp	r0, #0
c0d040c4:	d006      	beq.n	c0d040d4 <io_seproxyhal_touch_tap+0x3e>
c0d040c6:	2801      	cmp	r0, #1
c0d040c8:	d000      	beq.n	c0d040cc <io_seproxyhal_touch_tap+0x36>
c0d040ca:	4604      	mov	r4, r0
    }
    if ((unsigned int)el != 1) {
      element = el;
    }
  }
  io_seproxyhal_display(element);
c0d040cc:	4620      	mov	r0, r4
c0d040ce:	f7ff facb 	bl	c0d03668 <io_seproxyhal_display>
c0d040d2:	2001      	movs	r0, #1
  return 1;
}
c0d040d4:	bdb0      	pop	{r4, r5, r7, pc}
	...

c0d040d8 <io_seproxyhal_touch_element_callback>:
  io_seproxyhal_touch_element_callback(elements, element_count, x, y, event_kind, NULL);  
}

// browse all elements and until an element has changed state, continue browsing
// return if processed or not
void io_seproxyhal_touch_element_callback(const bagl_element_t* elements, unsigned short element_count, unsigned short x, unsigned short y, unsigned char event_kind, bagl_element_callback_t before_display) {
c0d040d8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d040da:	b087      	sub	sp, #28
c0d040dc:	9302      	str	r3, [sp, #8]
c0d040de:	9203      	str	r2, [sp, #12]
c0d040e0:	9105      	str	r1, [sp, #20]
  unsigned char comp_idx;
  unsigned char last_touched_not_released_component_was_in_current_array = 0;

  // find the first empty entry
  for (comp_idx=0; comp_idx < element_count; comp_idx++) {
c0d040e2:	2900      	cmp	r1, #0
c0d040e4:	d076      	beq.n	c0d041d4 <io_seproxyhal_touch_element_callback+0xfc>
c0d040e6:	9004      	str	r0, [sp, #16]
c0d040e8:	980d      	ldr	r0, [sp, #52]	; 0x34
c0d040ea:	9001      	str	r0, [sp, #4]
c0d040ec:	980c      	ldr	r0, [sp, #48]	; 0x30
c0d040ee:	9000      	str	r0, [sp, #0]
c0d040f0:	2500      	movs	r5, #0
c0d040f2:	4b3c      	ldr	r3, [pc, #240]	; (c0d041e4 <io_seproxyhal_touch_element_callback+0x10c>)
c0d040f4:	9506      	str	r5, [sp, #24]
c0d040f6:	462f      	mov	r7, r5
c0d040f8:	461e      	mov	r6, r3
    // process all components matching the x/y/w/h (no break) => fishy for the released out of zone
    // continue processing only if a status has not been sent
    if (io_seproxyhal_spi_is_status_sent()) {
c0d040fa:	f000 fee1 	bl	c0d04ec0 <io_seproxyhal_spi_is_status_sent>
c0d040fe:	2800      	cmp	r0, #0
c0d04100:	d155      	bne.n	c0d041ae <io_seproxyhal_touch_element_callback+0xd6>
c0d04102:	2038      	movs	r0, #56	; 0x38
      // continue instead of return to process all elemnts and therefore discard last touched element
      break;
    }

    // only perform out callback when element was in the current array, else, leave it be
    if (&elements[comp_idx] == G_bagl_last_touched_not_released_component) {
c0d04104:	4368      	muls	r0, r5
c0d04106:	9c04      	ldr	r4, [sp, #16]
c0d04108:	1825      	adds	r5, r4, r0
c0d0410a:	4633      	mov	r3, r6
c0d0410c:	6832      	ldr	r2, [r6, #0]
c0d0410e:	2101      	movs	r1, #1
c0d04110:	4295      	cmp	r5, r2
c0d04112:	d000      	beq.n	c0d04116 <io_seproxyhal_touch_element_callback+0x3e>
c0d04114:	9906      	ldr	r1, [sp, #24]
c0d04116:	9106      	str	r1, [sp, #24]
      last_touched_not_released_component_was_in_current_array = 1;
    }

    // the first component drawn with a 
    if ((elements[comp_idx].component.type & BAGL_FLAG_TOUCHABLE) 
c0d04118:	5620      	ldrsb	r0, [r4, r0]
        && elements[comp_idx].component.x-elements[comp_idx].touch_area_brim <= x && x<elements[comp_idx].component.x+elements[comp_idx].component.width+elements[comp_idx].touch_area_brim
c0d0411a:	2800      	cmp	r0, #0
c0d0411c:	da41      	bge.n	c0d041a2 <io_seproxyhal_touch_element_callback+0xca>
c0d0411e:	2020      	movs	r0, #32
c0d04120:	5c28      	ldrb	r0, [r5, r0]
c0d04122:	2102      	movs	r1, #2
c0d04124:	5e69      	ldrsh	r1, [r5, r1]
c0d04126:	1a0a      	subs	r2, r1, r0
c0d04128:	9c03      	ldr	r4, [sp, #12]
c0d0412a:	42a2      	cmp	r2, r4
c0d0412c:	dc39      	bgt.n	c0d041a2 <io_seproxyhal_touch_element_callback+0xca>
c0d0412e:	1841      	adds	r1, r0, r1
c0d04130:	88ea      	ldrh	r2, [r5, #6]
c0d04132:	1889      	adds	r1, r1, r2
        && elements[comp_idx].component.y-elements[comp_idx].touch_area_brim <= y && y<elements[comp_idx].component.y+elements[comp_idx].component.height+elements[comp_idx].touch_area_brim) {
c0d04134:	9a03      	ldr	r2, [sp, #12]
c0d04136:	4291      	cmp	r1, r2
c0d04138:	dd33      	ble.n	c0d041a2 <io_seproxyhal_touch_element_callback+0xca>
c0d0413a:	2104      	movs	r1, #4
c0d0413c:	5e6c      	ldrsh	r4, [r5, r1]
c0d0413e:	1a22      	subs	r2, r4, r0
c0d04140:	9902      	ldr	r1, [sp, #8]
c0d04142:	428a      	cmp	r2, r1
c0d04144:	dc2d      	bgt.n	c0d041a2 <io_seproxyhal_touch_element_callback+0xca>
c0d04146:	1820      	adds	r0, r4, r0
c0d04148:	8929      	ldrh	r1, [r5, #8]
c0d0414a:	1840      	adds	r0, r0, r1
    if (&elements[comp_idx] == G_bagl_last_touched_not_released_component) {
      last_touched_not_released_component_was_in_current_array = 1;
    }

    // the first component drawn with a 
    if ((elements[comp_idx].component.type & BAGL_FLAG_TOUCHABLE) 
c0d0414c:	9902      	ldr	r1, [sp, #8]
c0d0414e:	4288      	cmp	r0, r1
c0d04150:	dd27      	ble.n	c0d041a2 <io_seproxyhal_touch_element_callback+0xca>
        && elements[comp_idx].component.x-elements[comp_idx].touch_area_brim <= x && x<elements[comp_idx].component.x+elements[comp_idx].component.width+elements[comp_idx].touch_area_brim
        && elements[comp_idx].component.y-elements[comp_idx].touch_area_brim <= y && y<elements[comp_idx].component.y+elements[comp_idx].component.height+elements[comp_idx].touch_area_brim) {

      // outing the previous over'ed component
      if (&elements[comp_idx] != G_bagl_last_touched_not_released_component 
c0d04152:	6818      	ldr	r0, [r3, #0]
              && G_bagl_last_touched_not_released_component != NULL) {
c0d04154:	4285      	cmp	r5, r0
c0d04156:	d010      	beq.n	c0d0417a <io_seproxyhal_touch_element_callback+0xa2>
c0d04158:	6818      	ldr	r0, [r3, #0]
    if ((elements[comp_idx].component.type & BAGL_FLAG_TOUCHABLE) 
        && elements[comp_idx].component.x-elements[comp_idx].touch_area_brim <= x && x<elements[comp_idx].component.x+elements[comp_idx].component.width+elements[comp_idx].touch_area_brim
        && elements[comp_idx].component.y-elements[comp_idx].touch_area_brim <= y && y<elements[comp_idx].component.y+elements[comp_idx].component.height+elements[comp_idx].touch_area_brim) {

      // outing the previous over'ed component
      if (&elements[comp_idx] != G_bagl_last_touched_not_released_component 
c0d0415a:	2800      	cmp	r0, #0
c0d0415c:	d00d      	beq.n	c0d0417a <io_seproxyhal_touch_element_callback+0xa2>
              && G_bagl_last_touched_not_released_component != NULL) {
        // only out the previous element if the newly matching will be displayed 
        if (!before_display || before_display(&elements[comp_idx])) {
c0d0415e:	9801      	ldr	r0, [sp, #4]
c0d04160:	2800      	cmp	r0, #0
c0d04162:	d005      	beq.n	c0d04170 <io_seproxyhal_touch_element_callback+0x98>
c0d04164:	4628      	mov	r0, r5
c0d04166:	9901      	ldr	r1, [sp, #4]
c0d04168:	4788      	blx	r1
c0d0416a:	4633      	mov	r3, r6
c0d0416c:	2800      	cmp	r0, #0
c0d0416e:	d018      	beq.n	c0d041a2 <io_seproxyhal_touch_element_callback+0xca>
          if (io_seproxyhal_touch_out(G_bagl_last_touched_not_released_component, before_display)) {
c0d04170:	6818      	ldr	r0, [r3, #0]
c0d04172:	9901      	ldr	r1, [sp, #4]
c0d04174:	f7ff ff42 	bl	c0d03ffc <io_seproxyhal_touch_out>
c0d04178:	e008      	b.n	c0d0418c <io_seproxyhal_touch_element_callback+0xb4>
c0d0417a:	9800      	ldr	r0, [sp, #0]
        continue;
      }
      */
      
      // callback the hal to notify the component impacted by the user input
      else if (event_kind == SEPROXYHAL_TAG_FINGER_EVENT_RELEASE) {
c0d0417c:	2801      	cmp	r0, #1
c0d0417e:	d009      	beq.n	c0d04194 <io_seproxyhal_touch_element_callback+0xbc>
c0d04180:	2802      	cmp	r0, #2
c0d04182:	d10e      	bne.n	c0d041a2 <io_seproxyhal_touch_element_callback+0xca>
        if (io_seproxyhal_touch_tap(&elements[comp_idx], before_display)) {
c0d04184:	4628      	mov	r0, r5
c0d04186:	9901      	ldr	r1, [sp, #4]
c0d04188:	f7ff ff85 	bl	c0d04096 <io_seproxyhal_touch_tap>
c0d0418c:	4633      	mov	r3, r6
c0d0418e:	2800      	cmp	r0, #0
c0d04190:	d007      	beq.n	c0d041a2 <io_seproxyhal_touch_element_callback+0xca>
c0d04192:	e021      	b.n	c0d041d8 <io_seproxyhal_touch_element_callback+0x100>
          return;
        }
      }
      else if (event_kind == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) {
        // ask for overing
        if (io_seproxyhal_touch_over(&elements[comp_idx], before_display)) {
c0d04194:	4628      	mov	r0, r5
c0d04196:	9901      	ldr	r1, [sp, #4]
c0d04198:	f7ff ff50 	bl	c0d0403c <io_seproxyhal_touch_over>
c0d0419c:	4633      	mov	r3, r6
c0d0419e:	2800      	cmp	r0, #0
c0d041a0:	d11d      	bne.n	c0d041de <io_seproxyhal_touch_element_callback+0x106>
void io_seproxyhal_touch_element_callback(const bagl_element_t* elements, unsigned short element_count, unsigned short x, unsigned short y, unsigned char event_kind, bagl_element_callback_t before_display) {
  unsigned char comp_idx;
  unsigned char last_touched_not_released_component_was_in_current_array = 0;

  // find the first empty entry
  for (comp_idx=0; comp_idx < element_count; comp_idx++) {
c0d041a2:	1c7f      	adds	r7, r7, #1
c0d041a4:	b2fd      	uxtb	r5, r7
c0d041a6:	9805      	ldr	r0, [sp, #20]
c0d041a8:	4285      	cmp	r5, r0
c0d041aa:	d3a5      	bcc.n	c0d040f8 <io_seproxyhal_touch_element_callback+0x20>
c0d041ac:	e000      	b.n	c0d041b0 <io_seproxyhal_touch_element_callback+0xd8>
c0d041ae:	4633      	mov	r3, r6
    }
  }

  // if overing out of component or over another component, the out event is sent after the over event of the previous component
  if(last_touched_not_released_component_was_in_current_array 
    && G_bagl_last_touched_not_released_component != NULL) {
c0d041b0:	9806      	ldr	r0, [sp, #24]
c0d041b2:	0600      	lsls	r0, r0, #24
c0d041b4:	d00e      	beq.n	c0d041d4 <io_seproxyhal_touch_element_callback+0xfc>
c0d041b6:	6818      	ldr	r0, [r3, #0]
      }
    }
  }

  // if overing out of component or over another component, the out event is sent after the over event of the previous component
  if(last_touched_not_released_component_was_in_current_array 
c0d041b8:	2800      	cmp	r0, #0
c0d041ba:	d00b      	beq.n	c0d041d4 <io_seproxyhal_touch_element_callback+0xfc>
    && G_bagl_last_touched_not_released_component != NULL) {

    // we won't be able to notify the out, don't do it, in case a diplay refused the dra of the relased element and the position matched another element of the array (in autocomplete for example)
    if (io_seproxyhal_spi_is_status_sent()) {
c0d041bc:	f000 fe80 	bl	c0d04ec0 <io_seproxyhal_spi_is_status_sent>
c0d041c0:	2800      	cmp	r0, #0
c0d041c2:	d107      	bne.n	c0d041d4 <io_seproxyhal_touch_element_callback+0xfc>
      return;
    }
    
    if (io_seproxyhal_touch_out(G_bagl_last_touched_not_released_component, before_display)) {
c0d041c4:	6830      	ldr	r0, [r6, #0]
c0d041c6:	9901      	ldr	r1, [sp, #4]
c0d041c8:	f7ff ff18 	bl	c0d03ffc <io_seproxyhal_touch_out>
c0d041cc:	2800      	cmp	r0, #0
c0d041ce:	d001      	beq.n	c0d041d4 <io_seproxyhal_touch_element_callback+0xfc>
c0d041d0:	2000      	movs	r0, #0
      // ok component out has been emitted
      G_bagl_last_touched_not_released_component = NULL;
c0d041d2:	6030      	str	r0, [r6, #0]
    }
  }

  // not processed
}
c0d041d4:	b007      	add	sp, #28
c0d041d6:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d041d8:	2000      	movs	r0, #0
c0d041da:	6018      	str	r0, [r3, #0]
c0d041dc:	e7fa      	b.n	c0d041d4 <io_seproxyhal_touch_element_callback+0xfc>
      }
      else if (event_kind == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) {
        // ask for overing
        if (io_seproxyhal_touch_over(&elements[comp_idx], before_display)) {
          // remember the last touched component
          G_bagl_last_touched_not_released_component = (bagl_element_t*)&elements[comp_idx];
c0d041de:	601d      	str	r5, [r3, #0]
c0d041e0:	e7f8      	b.n	c0d041d4 <io_seproxyhal_touch_element_callback+0xfc>
c0d041e2:	46c0      	nop			; (mov r8, r8)
c0d041e4:	200022e0 	.word	0x200022e0

c0d041e8 <io_seproxyhal_display_icon>:
  // remaining length of bitmap bits to be displayed
  return len;
}
#endif // SEPROXYHAL_TAG_SCREEN_DISPLAY_RAW_STATUS

void io_seproxyhal_display_icon(bagl_component_t* icon_component, bagl_icon_details_t* icon_details) {
c0d041e8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d041ea:	b089      	sub	sp, #36	; 0x24
c0d041ec:	460c      	mov	r4, r1
c0d041ee:	4601      	mov	r1, r0
c0d041f0:	ad02      	add	r5, sp, #8
c0d041f2:	221c      	movs	r2, #28
  bagl_component_t icon_component_mod;
  // ensure not being out of bounds in the icon component agianst the declared icon real size
  os_memmove(&icon_component_mod, icon_component, sizeof(bagl_component_t));
c0d041f4:	4628      	mov	r0, r5
c0d041f6:	9201      	str	r2, [sp, #4]
c0d041f8:	f7ff fccb 	bl	c0d03b92 <os_memmove>
  icon_component_mod.width = icon_details->width;
c0d041fc:	cc06      	ldmia	r4!, {r1, r2}
  // component type = ICON, provided bitmap
  // => bitmap transmitted


  // color index size
  unsigned int h = (1<<(icon_details->bpp))*sizeof(unsigned int); 
c0d041fe:	6820      	ldr	r0, [r4, #0]

void io_seproxyhal_display_icon(bagl_component_t* icon_component, bagl_icon_details_t* icon_details) {
  bagl_component_t icon_component_mod;
  // ensure not being out of bounds in the icon component agianst the declared icon real size
  os_memmove(&icon_component_mod, icon_component, sizeof(bagl_component_t));
  icon_component_mod.width = icon_details->width;
c0d04200:	80e9      	strh	r1, [r5, #6]
  icon_component_mod.height = icon_details->height;
c0d04202:	812a      	strh	r2, [r5, #8]
  unsigned int w = ((icon_component->width*icon_component->height*icon_details->bpp)/8)+((icon_component->width*icon_component->height*icon_details->bpp)%8?1:0);
  unsigned short length = sizeof(bagl_component_t)
                          +1 /* bpp */
                          +h /* color index */
                          +w; /* image bitmap size */
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
c0d04204:	4f19      	ldr	r7, [pc, #100]	; (c0d0426c <io_seproxyhal_display_icon+0x84>)
c0d04206:	2365      	movs	r3, #101	; 0x65
c0d04208:	703b      	strb	r3, [r7, #0]


  // color index size
  unsigned int h = (1<<(icon_details->bpp))*sizeof(unsigned int); 
  // bitmap size
  unsigned int w = ((icon_component->width*icon_component->height*icon_details->bpp)/8)+((icon_component->width*icon_component->height*icon_details->bpp)%8?1:0);
c0d0420a:	b289      	uxth	r1, r1
c0d0420c:	b292      	uxth	r2, r2
c0d0420e:	434a      	muls	r2, r1
c0d04210:	4342      	muls	r2, r0
c0d04212:	0753      	lsls	r3, r2, #29
c0d04214:	08d1      	lsrs	r1, r2, #3
c0d04216:	1c4a      	adds	r2, r1, #1

void io_seproxyhal_display_icon(bagl_component_t* icon_component, bagl_icon_details_t* icon_details) {
  bagl_component_t icon_component_mod;
  // ensure not being out of bounds in the icon component agianst the declared icon real size
  os_memmove(&icon_component_mod, icon_component, sizeof(bagl_component_t));
  icon_component_mod.width = icon_details->width;
c0d04218:	3c08      	subs	r4, #8


  // color index size
  unsigned int h = (1<<(icon_details->bpp))*sizeof(unsigned int); 
  // bitmap size
  unsigned int w = ((icon_component->width*icon_component->height*icon_details->bpp)/8)+((icon_component->width*icon_component->height*icon_details->bpp)%8?1:0);
c0d0421a:	2b00      	cmp	r3, #0
c0d0421c:	d100      	bne.n	c0d04220 <io_seproxyhal_display_icon+0x38>
c0d0421e:	460a      	mov	r2, r1
c0d04220:	9200      	str	r2, [sp, #0]
c0d04222:	2604      	movs	r6, #4
  // component type = ICON, provided bitmap
  // => bitmap transmitted


  // color index size
  unsigned int h = (1<<(icon_details->bpp))*sizeof(unsigned int); 
c0d04224:	4086      	lsls	r6, r0
  // bitmap size
  unsigned int w = ((icon_component->width*icon_component->height*icon_details->bpp)/8)+((icon_component->width*icon_component->height*icon_details->bpp)%8?1:0);
  unsigned short length = sizeof(bagl_component_t)
                          +1 /* bpp */
                          +h /* color index */
c0d04226:	18b0      	adds	r0, r6, r2
                          +w; /* image bitmap size */
c0d04228:	301d      	adds	r0, #29
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
  G_io_seproxyhal_spi_buffer[1] = length>>8;
  G_io_seproxyhal_spi_buffer[2] = length;
c0d0422a:	70b8      	strb	r0, [r7, #2]
  unsigned short length = sizeof(bagl_component_t)
                          +1 /* bpp */
                          +h /* color index */
                          +w; /* image bitmap size */
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
  G_io_seproxyhal_spi_buffer[1] = length>>8;
c0d0422c:	0a00      	lsrs	r0, r0, #8
c0d0422e:	7078      	strb	r0, [r7, #1]
c0d04230:	2103      	movs	r1, #3
  G_io_seproxyhal_spi_buffer[2] = length;
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d04232:	4638      	mov	r0, r7
c0d04234:	f000 fe2e 	bl	c0d04e94 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send((unsigned char*)icon_component, sizeof(bagl_component_t));
c0d04238:	4628      	mov	r0, r5
c0d0423a:	9901      	ldr	r1, [sp, #4]
c0d0423c:	f000 fe2a 	bl	c0d04e94 <io_seproxyhal_spi_send>
  G_io_seproxyhal_spi_buffer[0] = icon_details->bpp;
c0d04240:	68a0      	ldr	r0, [r4, #8]
c0d04242:	7038      	strb	r0, [r7, #0]
c0d04244:	2101      	movs	r1, #1
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 1);
c0d04246:	4638      	mov	r0, r7
c0d04248:	f000 fe24 	bl	c0d04e94 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send((unsigned char*)PIC(icon_details->colors), h);
c0d0424c:	68e0      	ldr	r0, [r4, #12]
c0d0424e:	f000 fb8d 	bl	c0d0496c <pic>
c0d04252:	b2b1      	uxth	r1, r6
c0d04254:	f000 fe1e 	bl	c0d04e94 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send((unsigned char*)PIC(icon_details->bitmap), w);
c0d04258:	9800      	ldr	r0, [sp, #0]
c0d0425a:	b285      	uxth	r5, r0
c0d0425c:	6920      	ldr	r0, [r4, #16]
c0d0425e:	f000 fb85 	bl	c0d0496c <pic>
c0d04262:	4629      	mov	r1, r5
c0d04264:	f000 fe16 	bl	c0d04e94 <io_seproxyhal_spi_send>
#endif // !SEPROXYHAL_TAG_SCREEN_DISPLAY_RAW_STATUS
}
c0d04268:	b009      	add	sp, #36	; 0x24
c0d0426a:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d0426c:	20001800 	.word	0x20001800

c0d04270 <io_seproxyhal_display_default>:

void io_seproxyhal_display_default(const bagl_element_t * element) {
c0d04270:	b570      	push	{r4, r5, r6, lr}
c0d04272:	4604      	mov	r4, r0
  // process automagically address from rom and from ram
  unsigned int type = (element->component.type & ~(BAGL_FLAG_TOUCHABLE));
c0d04274:	7800      	ldrb	r0, [r0, #0]
c0d04276:	267f      	movs	r6, #127	; 0x7f
c0d04278:	4006      	ands	r6, r0

  // avoid sending another status :), fixes a lot of bugs in the end
  if (io_seproxyhal_spi_is_status_sent()) {
c0d0427a:	f000 fe21 	bl	c0d04ec0 <io_seproxyhal_spi_is_status_sent>
c0d0427e:	2800      	cmp	r0, #0
c0d04280:	d130      	bne.n	c0d042e4 <io_seproxyhal_display_default+0x74>
c0d04282:	2e00      	cmp	r6, #0
c0d04284:	d02e      	beq.n	c0d042e4 <io_seproxyhal_display_default+0x74>
    return;
  }

  if (type != BAGL_NONE) {
    if (element->text != NULL) {
c0d04286:	69e0      	ldr	r0, [r4, #28]
c0d04288:	2800      	cmp	r0, #0
c0d0428a:	d01d      	beq.n	c0d042c8 <io_seproxyhal_display_default+0x58>
      unsigned int text_adr = PIC((unsigned int)element->text);
c0d0428c:	f000 fb6e 	bl	c0d0496c <pic>
c0d04290:	4605      	mov	r5, r0
      // consider an icon details descriptor is pointed by the context
      if (type == BAGL_ICON && element->component.icon_id == 0) {
c0d04292:	2e05      	cmp	r6, #5
c0d04294:	d102      	bne.n	c0d0429c <io_seproxyhal_display_default+0x2c>
c0d04296:	7ea0      	ldrb	r0, [r4, #26]
c0d04298:	2800      	cmp	r0, #0
c0d0429a:	d024      	beq.n	c0d042e6 <io_seproxyhal_display_default+0x76>
        io_seproxyhal_display_icon((bagl_component_t*)&element->component, (bagl_icon_details_t*)text_adr);
      }
      else {
        unsigned short length = sizeof(bagl_component_t)+strlen((const char*)text_adr);
c0d0429c:	4628      	mov	r0, r5
c0d0429e:	f002 fb9f 	bl	c0d069e0 <strlen>
c0d042a2:	4606      	mov	r6, r0
        G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
c0d042a4:	4812      	ldr	r0, [pc, #72]	; (c0d042f0 <io_seproxyhal_display_default+0x80>)
c0d042a6:	2165      	movs	r1, #101	; 0x65
c0d042a8:	7001      	strb	r1, [r0, #0]
      // consider an icon details descriptor is pointed by the context
      if (type == BAGL_ICON && element->component.icon_id == 0) {
        io_seproxyhal_display_icon((bagl_component_t*)&element->component, (bagl_icon_details_t*)text_adr);
      }
      else {
        unsigned short length = sizeof(bagl_component_t)+strlen((const char*)text_adr);
c0d042aa:	4631      	mov	r1, r6
c0d042ac:	311c      	adds	r1, #28
        G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
        G_io_seproxyhal_spi_buffer[1] = length>>8;
        G_io_seproxyhal_spi_buffer[2] = length;
c0d042ae:	7081      	strb	r1, [r0, #2]
        io_seproxyhal_display_icon((bagl_component_t*)&element->component, (bagl_icon_details_t*)text_adr);
      }
      else {
        unsigned short length = sizeof(bagl_component_t)+strlen((const char*)text_adr);
        G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
        G_io_seproxyhal_spi_buffer[1] = length>>8;
c0d042b0:	0a09      	lsrs	r1, r1, #8
c0d042b2:	7041      	strb	r1, [r0, #1]
c0d042b4:	2103      	movs	r1, #3
        G_io_seproxyhal_spi_buffer[2] = length;
        io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d042b6:	f000 fded 	bl	c0d04e94 <io_seproxyhal_spi_send>
c0d042ba:	211c      	movs	r1, #28
        io_seproxyhal_spi_send((unsigned char*)&element->component, sizeof(bagl_component_t));
c0d042bc:	4620      	mov	r0, r4
c0d042be:	f000 fde9 	bl	c0d04e94 <io_seproxyhal_spi_send>
        io_seproxyhal_spi_send((unsigned char*)text_adr, length-sizeof(bagl_component_t));
c0d042c2:	b2b1      	uxth	r1, r6
c0d042c4:	4628      	mov	r0, r5
c0d042c6:	e00b      	b.n	c0d042e0 <io_seproxyhal_display_default+0x70>
      }
    }
    else {
      unsigned short length = sizeof(bagl_component_t);
      G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
c0d042c8:	4809      	ldr	r0, [pc, #36]	; (c0d042f0 <io_seproxyhal_display_default+0x80>)
c0d042ca:	2100      	movs	r1, #0
      G_io_seproxyhal_spi_buffer[1] = length>>8;
c0d042cc:	7041      	strb	r1, [r0, #1]
c0d042ce:	2165      	movs	r1, #101	; 0x65
        io_seproxyhal_spi_send((unsigned char*)text_adr, length-sizeof(bagl_component_t));
      }
    }
    else {
      unsigned short length = sizeof(bagl_component_t);
      G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
c0d042d0:	7001      	strb	r1, [r0, #0]
c0d042d2:	251c      	movs	r5, #28
      G_io_seproxyhal_spi_buffer[1] = length>>8;
      G_io_seproxyhal_spi_buffer[2] = length;
c0d042d4:	7085      	strb	r5, [r0, #2]
c0d042d6:	2103      	movs	r1, #3
      io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d042d8:	f000 fddc 	bl	c0d04e94 <io_seproxyhal_spi_send>
      io_seproxyhal_spi_send((unsigned char*)&element->component, sizeof(bagl_component_t));
c0d042dc:	4620      	mov	r0, r4
c0d042de:	4629      	mov	r1, r5
c0d042e0:	f000 fdd8 	bl	c0d04e94 <io_seproxyhal_spi_send>
    }
  }
}
c0d042e4:	bd70      	pop	{r4, r5, r6, pc}
  if (type != BAGL_NONE) {
    if (element->text != NULL) {
      unsigned int text_adr = PIC((unsigned int)element->text);
      // consider an icon details descriptor is pointed by the context
      if (type == BAGL_ICON && element->component.icon_id == 0) {
        io_seproxyhal_display_icon((bagl_component_t*)&element->component, (bagl_icon_details_t*)text_adr);
c0d042e6:	4620      	mov	r0, r4
c0d042e8:	4629      	mov	r1, r5
c0d042ea:	f7ff ff7d 	bl	c0d041e8 <io_seproxyhal_display_icon>
      G_io_seproxyhal_spi_buffer[2] = length;
      io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
      io_seproxyhal_spi_send((unsigned char*)&element->component, sizeof(bagl_component_t));
    }
  }
}
c0d042ee:	bd70      	pop	{r4, r5, r6, pc}
c0d042f0:	20001800 	.word	0x20001800

c0d042f4 <io_seproxyhal_button_push>:
  G_io_seproxyhal_spi_buffer[3] = (backlight_percentage?0x80:0)|(flags & 0x7F); // power on
  G_io_seproxyhal_spi_buffer[4] = backlight_percentage;
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 5);
}

void io_seproxyhal_button_push(button_push_callback_t button_callback, unsigned int new_button_mask) {
c0d042f4:	b570      	push	{r4, r5, r6, lr}
  if (button_callback) {
c0d042f6:	2800      	cmp	r0, #0
c0d042f8:	d02d      	beq.n	c0d04356 <io_seproxyhal_button_push+0x62>
c0d042fa:	4604      	mov	r4, r0
    unsigned int button_mask;
    unsigned int button_same_mask_counter;
    // enable speeded up long push
    if (new_button_mask == G_button_mask) {
c0d042fc:	4816      	ldr	r0, [pc, #88]	; (c0d04358 <io_seproxyhal_button_push+0x64>)
c0d042fe:	6802      	ldr	r2, [r0, #0]
c0d04300:	428a      	cmp	r2, r1
c0d04302:	d103      	bne.n	c0d0430c <io_seproxyhal_button_push+0x18>
      // each 100ms ~
      G_button_same_mask_counter++;
c0d04304:	4a15      	ldr	r2, [pc, #84]	; (c0d0435c <io_seproxyhal_button_push+0x68>)
c0d04306:	6813      	ldr	r3, [r2, #0]
c0d04308:	1c5b      	adds	r3, r3, #1
c0d0430a:	6013      	str	r3, [r2, #0]
    }

    // append the button mask
    button_mask = G_button_mask | new_button_mask;
c0d0430c:	6806      	ldr	r6, [r0, #0]
c0d0430e:	430e      	orrs	r6, r1

    // pre reset variable due to os_sched_exit
    button_same_mask_counter = G_button_same_mask_counter;
c0d04310:	4a12      	ldr	r2, [pc, #72]	; (c0d0435c <io_seproxyhal_button_push+0x68>)
c0d04312:	6815      	ldr	r5, [r2, #0]

    // reset button mask
    if (new_button_mask == 0) {
c0d04314:	2900      	cmp	r1, #0
c0d04316:	d001      	beq.n	c0d0431c <io_seproxyhal_button_push+0x28>

      // notify button released event
      button_mask |= BUTTON_EVT_RELEASED;
    }
    else {
      G_button_mask = button_mask;
c0d04318:	6006      	str	r6, [r0, #0]
c0d0431a:	e005      	b.n	c0d04328 <io_seproxyhal_button_push+0x34>
c0d0431c:	2300      	movs	r3, #0
    button_same_mask_counter = G_button_same_mask_counter;

    // reset button mask
    if (new_button_mask == 0) {
      // reset next state when button are released
      G_button_mask = 0;
c0d0431e:	6003      	str	r3, [r0, #0]
      G_button_same_mask_counter=0;
c0d04320:	6013      	str	r3, [r2, #0]
c0d04322:	4b0f      	ldr	r3, [pc, #60]	; (c0d04360 <io_seproxyhal_button_push+0x6c>)

      // notify button released event
      button_mask |= BUTTON_EVT_RELEASED;
c0d04324:	1c5b      	adds	r3, r3, #1
c0d04326:	431e      	orrs	r6, r3
    else {
      G_button_mask = button_mask;
    }

    // reset counter when button mask changes
    if (new_button_mask != G_button_mask) {
c0d04328:	6800      	ldr	r0, [r0, #0]
c0d0432a:	4288      	cmp	r0, r1
c0d0432c:	d001      	beq.n	c0d04332 <io_seproxyhal_button_push+0x3e>
c0d0432e:	2000      	movs	r0, #0
      G_button_same_mask_counter=0;
c0d04330:	6010      	str	r0, [r2, #0]
    }

    if (button_same_mask_counter >= BUTTON_FAST_THRESHOLD_CS) {
c0d04332:	2d08      	cmp	r5, #8
c0d04334:	d30c      	bcc.n	c0d04350 <io_seproxyhal_button_push+0x5c>
c0d04336:	2103      	movs	r1, #3
      // fast bit when pressing and timing is right
      if ((button_same_mask_counter%BUTTON_FAST_ACTION_CS) == 0) {
c0d04338:	4628      	mov	r0, r5
c0d0433a:	f002 f959 	bl	c0d065f0 <__aeabi_uidivmod>
c0d0433e:	2201      	movs	r2, #1
c0d04340:	0790      	lsls	r0, r2, #30
        button_mask |= BUTTON_EVT_FAST;
c0d04342:	4330      	orrs	r0, r6
      G_button_same_mask_counter=0;
    }

    if (button_same_mask_counter >= BUTTON_FAST_THRESHOLD_CS) {
      // fast bit when pressing and timing is right
      if ((button_same_mask_counter%BUTTON_FAST_ACTION_CS) == 0) {
c0d04344:	2900      	cmp	r1, #0
c0d04346:	d000      	beq.n	c0d0434a <io_seproxyhal_button_push+0x56>
c0d04348:	4630      	mov	r0, r6
c0d0434a:	07d1      	lsls	r1, r2, #31
      }
      */

      // discard the release event after a fastskip has been detected, to avoid strange at release behavior
      // and also to enable user to cancel an operation by starting triggering the fast skip
      button_mask &= ~BUTTON_EVT_RELEASED;
c0d0434c:	4388      	bics	r0, r1
c0d0434e:	e000      	b.n	c0d04352 <io_seproxyhal_button_push+0x5e>
c0d04350:	4630      	mov	r0, r6
    }

    // indicate if button have been released
    button_callback(button_mask, button_same_mask_counter);
c0d04352:	4629      	mov	r1, r5
c0d04354:	47a0      	blx	r4
  }
}
c0d04356:	bd70      	pop	{r4, r5, r6, pc}
c0d04358:	200022e4 	.word	0x200022e4
c0d0435c:	200022e8 	.word	0x200022e8
c0d04360:	7fffffff 	.word	0x7fffffff

c0d04364 <os_io_seproxyhal_get_app_name_and_version>:
#ifdef HAVE_IO_U2F
u2f_service_t G_io_u2f;
#endif // HAVE_IO_U2F

unsigned int os_io_seproxyhal_get_app_name_and_version(void) __attribute__((weak));
unsigned int os_io_seproxyhal_get_app_name_and_version(void) {
c0d04364:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d04366:	b081      	sub	sp, #4
  unsigned int tx_len, len;
  // build the get app name and version reply
  tx_len = 0;
  G_io_apdu_buffer[tx_len++] = 1; // format ID
c0d04368:	4e0f      	ldr	r6, [pc, #60]	; (c0d043a8 <os_io_seproxyhal_get_app_name_and_version+0x44>)
c0d0436a:	2401      	movs	r4, #1
c0d0436c:	7034      	strb	r4, [r6, #0]

  // append app name
  len = os_registry_get_current_app_tag(BOLOS_TAG_APPNAME, G_io_apdu_buffer+tx_len+1, sizeof(G_io_apdu_buffer)-tx_len);
c0d0436e:	1cb1      	adds	r1, r6, #2
c0d04370:	27ff      	movs	r7, #255	; 0xff
c0d04372:	3750      	adds	r7, #80	; 0x50
c0d04374:	1c7a      	adds	r2, r7, #1
c0d04376:	4620      	mov	r0, r4
c0d04378:	f000 fd74 	bl	c0d04e64 <os_registry_get_current_app_tag>
c0d0437c:	4605      	mov	r5, r0
  G_io_apdu_buffer[tx_len++] = len;
c0d0437e:	7070      	strb	r0, [r6, #1]
  tx_len += len;
  // append app version
  len = os_registry_get_current_app_tag(BOLOS_TAG_APPVERSION, G_io_apdu_buffer+tx_len+1, sizeof(G_io_apdu_buffer)-tx_len);
c0d04380:	1a3a      	subs	r2, r7, r0
unsigned int os_io_seproxyhal_get_app_name_and_version(void) __attribute__((weak));
unsigned int os_io_seproxyhal_get_app_name_and_version(void) {
  unsigned int tx_len, len;
  // build the get app name and version reply
  tx_len = 0;
  G_io_apdu_buffer[tx_len++] = 1; // format ID
c0d04382:	1837      	adds	r7, r6, r0
  // append app name
  len = os_registry_get_current_app_tag(BOLOS_TAG_APPNAME, G_io_apdu_buffer+tx_len+1, sizeof(G_io_apdu_buffer)-tx_len);
  G_io_apdu_buffer[tx_len++] = len;
  tx_len += len;
  // append app version
  len = os_registry_get_current_app_tag(BOLOS_TAG_APPVERSION, G_io_apdu_buffer+tx_len+1, sizeof(G_io_apdu_buffer)-tx_len);
c0d04384:	1cf9      	adds	r1, r7, #3
c0d04386:	2002      	movs	r0, #2
c0d04388:	f000 fd6c 	bl	c0d04e64 <os_registry_get_current_app_tag>
  G_io_apdu_buffer[tx_len++] = len;
c0d0438c:	70b8      	strb	r0, [r7, #2]
c0d0438e:	182d      	adds	r5, r5, r0
unsigned int os_io_seproxyhal_get_app_name_and_version(void) __attribute__((weak));
unsigned int os_io_seproxyhal_get_app_name_and_version(void) {
  unsigned int tx_len, len;
  // build the get app name and version reply
  tx_len = 0;
  G_io_apdu_buffer[tx_len++] = 1; // format ID
c0d04390:	1976      	adds	r6, r6, r5
  // append app version
  len = os_registry_get_current_app_tag(BOLOS_TAG_APPVERSION, G_io_apdu_buffer+tx_len+1, sizeof(G_io_apdu_buffer)-tx_len);
  G_io_apdu_buffer[tx_len++] = len;
  tx_len += len;
  // return OS flags to notify of platform's global state (pin lock etc)
  G_io_apdu_buffer[tx_len++] = 1; // flags length
c0d04392:	70f4      	strb	r4, [r6, #3]
  G_io_apdu_buffer[tx_len++] = os_flags();
c0d04394:	f000 fd50 	bl	c0d04e38 <os_flags>
c0d04398:	7130      	strb	r0, [r6, #4]
c0d0439a:	2090      	movs	r0, #144	; 0x90

  // status words
  G_io_apdu_buffer[tx_len++] = 0x90;
c0d0439c:	7170      	strb	r0, [r6, #5]
c0d0439e:	2000      	movs	r0, #0
  G_io_apdu_buffer[tx_len++] = 0x00;
c0d043a0:	71b0      	strb	r0, [r6, #6]
c0d043a2:	1de8      	adds	r0, r5, #7
  return tx_len;
c0d043a4:	b001      	add	sp, #4
c0d043a6:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d043a8:	2000216c 	.word	0x2000216c

c0d043ac <io_exchange>:
}


unsigned short io_exchange(unsigned char channel, unsigned short tx_len) {
c0d043ac:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d043ae:	b085      	sub	sp, #20
c0d043b0:	460b      	mov	r3, r1
c0d043b2:	4601      	mov	r1, r0
  }
  after_debug:
#endif // DEBUG_APDU

reply_apdu:
  switch(channel&~(IO_FLAGS)) {
c0d043b4:	0740      	lsls	r0, r0, #29
c0d043b6:	d007      	beq.n	c0d043c8 <io_exchange+0x1c>
c0d043b8:	460a      	mov	r2, r1
      }
    }
    break;

  default:
    return io_exchange_al(channel, tx_len);
c0d043ba:	b2d0      	uxtb	r0, r2
c0d043bc:	b299      	uxth	r1, r3
c0d043be:	f7fe f9bd 	bl	c0d0273c <io_exchange_al>
  }
}
c0d043c2:	b280      	uxth	r0, r0
c0d043c4:	b005      	add	sp, #20
c0d043c6:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d043c8:	2080      	movs	r0, #128	; 0x80
c0d043ca:	9001      	str	r0, [sp, #4]
c0d043cc:	4f6c      	ldr	r7, [pc, #432]	; (c0d04580 <io_exchange+0x1d4>)
c0d043ce:	4e72      	ldr	r6, [pc, #456]	; (c0d04598 <io_exchange+0x1ec>)
c0d043d0:	4c6f      	ldr	r4, [pc, #444]	; (c0d04590 <io_exchange+0x1e4>)
c0d043d2:	460a      	mov	r2, r1
c0d043d4:	9203      	str	r2, [sp, #12]
c0d043d6:	2010      	movs	r0, #16
reply_apdu:
  switch(channel&~(IO_FLAGS)) {
  case CHANNEL_APDU:
    // TODO work up the spi state machine over the HAL proxy until an APDU is available

    if (tx_len && !(channel&IO_ASYNCH_REPLY)) {
c0d043d8:	4008      	ands	r0, r1
c0d043da:	b29d      	uxth	r5, r3
c0d043dc:	2d00      	cmp	r5, #0
c0d043de:	d075      	beq.n	c0d044cc <io_exchange+0x120>
c0d043e0:	2800      	cmp	r0, #0
c0d043e2:	d173      	bne.n	c0d044cc <io_exchange+0x120>
c0d043e4:	9002      	str	r0, [sp, #8]
      // until the whole RAPDU is transmitted, send chunks using the current mode for communication
      for (;;) {
        switch(G_io_apdu_state) {
c0d043e6:	7838      	ldrb	r0, [r7, #0]
c0d043e8:	2808      	cmp	r0, #8
c0d043ea:	9104      	str	r1, [sp, #16]
c0d043ec:	dd1a      	ble.n	c0d04424 <io_exchange+0x78>
c0d043ee:	2809      	cmp	r0, #9
c0d043f0:	d020      	beq.n	c0d04434 <io_exchange+0x88>
c0d043f2:	280a      	cmp	r0, #10
c0d043f4:	d143      	bne.n	c0d0447e <io_exchange+0xd2>
            LOG("invalid state for APDU reply\n");
            THROW(INVALID_STATE);
            break;

          case APDU_RAW:
            if (tx_len > sizeof(G_io_apdu_buffer)) {
c0d043f6:	4618      	mov	r0, r3
c0d043f8:	4964      	ldr	r1, [pc, #400]	; (c0d0458c <io_exchange+0x1e0>)
c0d043fa:	4008      	ands	r0, r1
c0d043fc:	0840      	lsrs	r0, r0, #1
c0d043fe:	28a9      	cmp	r0, #169	; 0xa9
c0d04400:	d300      	bcc.n	c0d04404 <io_exchange+0x58>
c0d04402:	e0ba      	b.n	c0d0457a <io_exchange+0x1ce>
c0d04404:	2053      	movs	r0, #83	; 0x53
              THROW(INVALID_PARAMETER);
            }
            // reply the RAW APDU over SEPROXYHAL protocol
            G_io_seproxyhal_spi_buffer[0]  = SEPROXYHAL_TAG_RAPDU;
c0d04406:	7020      	strb	r0, [r4, #0]
            G_io_seproxyhal_spi_buffer[1]  = (tx_len)>>8;
            G_io_seproxyhal_spi_buffer[2]  = (tx_len);
c0d04408:	70a3      	strb	r3, [r4, #2]
            if (tx_len > sizeof(G_io_apdu_buffer)) {
              THROW(INVALID_PARAMETER);
            }
            // reply the RAW APDU over SEPROXYHAL protocol
            G_io_seproxyhal_spi_buffer[0]  = SEPROXYHAL_TAG_RAPDU;
            G_io_seproxyhal_spi_buffer[1]  = (tx_len)>>8;
c0d0440a:	0a18      	lsrs	r0, r3, #8
c0d0440c:	7060      	strb	r0, [r4, #1]
c0d0440e:	2103      	movs	r1, #3
            G_io_seproxyhal_spi_buffer[2]  = (tx_len);
            io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d04410:	4620      	mov	r0, r4
c0d04412:	f000 fd3f 	bl	c0d04e94 <io_seproxyhal_spi_send>
            io_seproxyhal_spi_send(G_io_apdu_buffer, tx_len);
c0d04416:	485b      	ldr	r0, [pc, #364]	; (c0d04584 <io_exchange+0x1d8>)
c0d04418:	4629      	mov	r1, r5
c0d0441a:	f000 fd3b 	bl	c0d04e94 <io_seproxyhal_spi_send>
c0d0441e:	2000      	movs	r0, #0

            // isngle packet reply, mark immediate idle
            G_io_apdu_state = APDU_IDLE;
c0d04420:	7038      	strb	r0, [r7, #0]
c0d04422:	e03d      	b.n	c0d044a0 <io_exchange+0xf4>
    // TODO work up the spi state machine over the HAL proxy until an APDU is available

    if (tx_len && !(channel&IO_ASYNCH_REPLY)) {
      // until the whole RAPDU is transmitted, send chunks using the current mode for communication
      for (;;) {
        switch(G_io_apdu_state) {
c0d04424:	2807      	cmp	r0, #7
c0d04426:	d128      	bne.n	c0d0447a <io_exchange+0xce>
            goto break_send;

#ifdef HAVE_USB_APDU
          case APDU_USB_HID:
            // only send, don't perform synchronous reception of the next command (will be done later by the seproxyhal packet processing)
            io_usb_hid_send(io_usb_send_apdu_data, tx_len);
c0d04428:	485c      	ldr	r0, [pc, #368]	; (c0d0459c <io_exchange+0x1f0>)
c0d0442a:	4478      	add	r0, pc
c0d0442c:	4629      	mov	r1, r5
c0d0442e:	f7ff fc51 	bl	c0d03cd4 <io_usb_hid_send>
c0d04432:	e035      	b.n	c0d044a0 <io_exchange+0xf4>
          // case to handle U2F channels. u2f apdu to be dispatched in the upper layers
          case APDU_U2F:
            // prepare reply, the remaining segments will be pumped during USB/BLE events handling while waiting for the next APDU

            // user presence + counter + rapdu + sw must fit the apdu buffer
            if (1U+ 4U+ tx_len +2U > sizeof(G_io_apdu_buffer)) {
c0d04434:	1de8      	adds	r0, r5, #7
c0d04436:	0840      	lsrs	r0, r0, #1
c0d04438:	28a9      	cmp	r0, #169	; 0xa9
c0d0443a:	d300      	bcc.n	c0d0443e <io_exchange+0x92>
c0d0443c:	e09d      	b.n	c0d0457a <io_exchange+0x1ce>
              THROW(INVALID_PARAMETER);
            }

            // u2F tunnel needs the status words to be included in the signature response BLOB, do it now.
            // always return 9000 in the signature to avoid error @ transport level in u2f layers. 
            G_io_apdu_buffer[tx_len] = 0x90; //G_io_apdu_buffer[tx_len-2];
c0d0443e:	9801      	ldr	r0, [sp, #4]
c0d04440:	3010      	adds	r0, #16
c0d04442:	4950      	ldr	r1, [pc, #320]	; (c0d04584 <io_exchange+0x1d8>)
c0d04444:	5548      	strb	r0, [r1, r5]
c0d04446:	1948      	adds	r0, r1, r5
c0d04448:	2500      	movs	r5, #0
            G_io_apdu_buffer[tx_len+1] = 0x00; //G_io_apdu_buffer[tx_len-1];
c0d0444a:	7045      	strb	r5, [r0, #1]
            tx_len += 2;
            os_memmove(G_io_apdu_buffer+5, G_io_apdu_buffer, tx_len);
c0d0444c:	1d48      	adds	r0, r1, #5

            // u2F tunnel needs the status words to be included in the signature response BLOB, do it now.
            // always return 9000 in the signature to avoid error @ transport level in u2f layers. 
            G_io_apdu_buffer[tx_len] = 0x90; //G_io_apdu_buffer[tx_len-2];
            G_io_apdu_buffer[tx_len+1] = 0x00; //G_io_apdu_buffer[tx_len-1];
            tx_len += 2;
c0d0444e:	1c99      	adds	r1, r3, #2
            os_memmove(G_io_apdu_buffer+5, G_io_apdu_buffer, tx_len);
c0d04450:	b28a      	uxth	r2, r1
c0d04452:	494c      	ldr	r1, [pc, #304]	; (c0d04584 <io_exchange+0x1d8>)
c0d04454:	9300      	str	r3, [sp, #0]
c0d04456:	f7ff fb9c 	bl	c0d03b92 <os_memmove>
c0d0445a:	2205      	movs	r2, #5
c0d0445c:	4849      	ldr	r0, [pc, #292]	; (c0d04584 <io_exchange+0x1d8>)
            // zeroize user presence and counter
            os_memset(G_io_apdu_buffer, 0, 5);
c0d0445e:	4629      	mov	r1, r5
c0d04460:	f7ff fb8e 	bl	c0d03b80 <os_memset>
            u2f_message_reply(&G_io_u2f, U2F_CMD_MSG, G_io_apdu_buffer, tx_len+5);
c0d04464:	9801      	ldr	r0, [sp, #4]
c0d04466:	1cc0      	adds	r0, r0, #3
c0d04468:	b2c1      	uxtb	r1, r0
c0d0446a:	9800      	ldr	r0, [sp, #0]
c0d0446c:	1dc0      	adds	r0, r0, #7
c0d0446e:	b283      	uxth	r3, r0
c0d04470:	4845      	ldr	r0, [pc, #276]	; (c0d04588 <io_exchange+0x1dc>)
c0d04472:	4a44      	ldr	r2, [pc, #272]	; (c0d04584 <io_exchange+0x1d8>)
c0d04474:	f001 f8f2 	bl	c0d0565c <u2f_message_reply>
c0d04478:	e012      	b.n	c0d044a0 <io_exchange+0xf4>
    // TODO work up the spi state machine over the HAL proxy until an APDU is available

    if (tx_len && !(channel&IO_ASYNCH_REPLY)) {
      // until the whole RAPDU is transmitted, send chunks using the current mode for communication
      for (;;) {
        switch(G_io_apdu_state) {
c0d0447a:	2800      	cmp	r0, #0
c0d0447c:	d07a      	beq.n	c0d04574 <io_exchange+0x1c8>
          default: 
            // delegate to the hal in case of not generic transport mode (or asynch)
            if (io_exchange_al(channel, tx_len) == 0) {
c0d0447e:	9803      	ldr	r0, [sp, #12]
c0d04480:	b2c0      	uxtb	r0, r0
c0d04482:	4629      	mov	r1, r5
c0d04484:	f7fe f95a 	bl	c0d0273c <io_exchange_al>
c0d04488:	2800      	cmp	r0, #0
c0d0448a:	d009      	beq.n	c0d044a0 <io_exchange+0xf4>
c0d0448c:	e072      	b.n	c0d04574 <io_exchange+0x1c8>
        // wait end of reply transmission
        while (G_io_apdu_state != APDU_IDLE) {
#ifdef HAVE_TINY_COROUTINE
          tcr_yield();
#else // HAVE_TINY_COROUTINE
          io_seproxyhal_general_status();
c0d0448e:	f7ff fc5b 	bl	c0d03d48 <io_seproxyhal_general_status>
c0d04492:	2180      	movs	r1, #128	; 0x80
c0d04494:	2200      	movs	r2, #0
          io_seproxyhal_spi_recv(G_io_seproxyhal_spi_buffer, sizeof(G_io_seproxyhal_spi_buffer), 0);
c0d04496:	4620      	mov	r0, r4
c0d04498:	f000 fd28 	bl	c0d04eec <io_seproxyhal_spi_recv>
          // if packet is not well formed, then too bad ...
          io_seproxyhal_handle_event();
c0d0449c:	f7ff fd38 	bl	c0d03f10 <io_seproxyhal_handle_event>
        continue;

      break_send:

        // wait end of reply transmission
        while (G_io_apdu_state != APDU_IDLE) {
c0d044a0:	7838      	ldrb	r0, [r7, #0]
c0d044a2:	2800      	cmp	r0, #0
c0d044a4:	d1f3      	bne.n	c0d0448e <io_exchange+0xe2>
c0d044a6:	2000      	movs	r0, #0
          io_seproxyhal_handle_event();
#endif // HAVE_TINY_COROUTINE
        }

        // reset apdu state
        G_io_apdu_state = APDU_IDLE;
c0d044a8:	7038      	strb	r0, [r7, #0]
        G_io_apdu_media = IO_APDU_MEDIA_NONE;
c0d044aa:	493a      	ldr	r1, [pc, #232]	; (c0d04594 <io_exchange+0x1e8>)
c0d044ac:	7008      	strb	r0, [r1, #0]

        G_io_apdu_length = 0;
c0d044ae:	8030      	strh	r0, [r6, #0]

        // continue sending commands, don't issue status yet
        if (channel & IO_RETURN_AFTER_TX) {
c0d044b0:	9904      	ldr	r1, [sp, #16]
c0d044b2:	0689      	lsls	r1, r1, #26
c0d044b4:	d485      	bmi.n	c0d043c2 <io_exchange+0x16>
          return 0;
        }
        // acknowledge the write request (general status OK) and no more command to follow (wait until another APDU container is received to continue unwrapping)
        io_seproxyhal_general_status();
c0d044b6:	f7ff fc47 	bl	c0d03d48 <io_seproxyhal_general_status>
c0d044ba:	9904      	ldr	r1, [sp, #16]
        break;
      }

      // perform reset after io exchange
      if (channel & IO_RESET_AFTER_REPLIED) {
c0d044bc:	0608      	lsls	r0, r1, #24
c0d044be:	9802      	ldr	r0, [sp, #8]
c0d044c0:	d504      	bpl.n	c0d044cc <io_exchange+0x120>
c0d044c2:	2001      	movs	r0, #1
        os_sched_exit(1);
c0d044c4:	f000 fc8c 	bl	c0d04de0 <os_sched_exit>
c0d044c8:	9802      	ldr	r0, [sp, #8]
c0d044ca:	9904      	ldr	r1, [sp, #16]
        //reset();
      }
    }

#ifndef HAVE_TINY_COROUTINE
    if (!(channel&IO_ASYNCH_REPLY)) {
c0d044cc:	2800      	cmp	r0, #0
c0d044ce:	d105      	bne.n	c0d044dc <io_exchange+0x130>
      
      // already received the data of the apdu when received the whole apdu
      if ((channel & (CHANNEL_APDU|IO_RECEIVE_DATA)) == (CHANNEL_APDU|IO_RECEIVE_DATA)) {
c0d044d0:	0648      	lsls	r0, r1, #25
c0d044d2:	d44c      	bmi.n	c0d0456e <io_exchange+0x1c2>
c0d044d4:	2000      	movs	r0, #0
        // return apdu data - header
        return G_io_apdu_length-5;
      }

      // reply has ended, proceed to next apdu reception (reset status only after asynch reply)
      G_io_apdu_state = APDU_IDLE;
c0d044d6:	7038      	strb	r0, [r7, #0]
      G_io_apdu_media = IO_APDU_MEDIA_NONE;
c0d044d8:	492e      	ldr	r1, [pc, #184]	; (c0d04594 <io_exchange+0x1e8>)
c0d044da:	7008      	strb	r0, [r1, #0]
c0d044dc:	2000      	movs	r0, #0
c0d044de:	8030      	strh	r0, [r6, #0]
#ifdef HAVE_TINY_COROUTINE
      // give back hand to the seph task which interprets all incoming events first
      tcr_yield();
#else // HAVE_TINY_COROUTINE

      if (!io_seproxyhal_spi_is_status_sent()) {
c0d044e0:	f000 fcee 	bl	c0d04ec0 <io_seproxyhal_spi_is_status_sent>
c0d044e4:	2800      	cmp	r0, #0
c0d044e6:	d101      	bne.n	c0d044ec <io_exchange+0x140>
        io_seproxyhal_general_status();
c0d044e8:	f7ff fc2e 	bl	c0d03d48 <io_seproxyhal_general_status>
c0d044ec:	2180      	movs	r1, #128	; 0x80
c0d044ee:	2500      	movs	r5, #0
      }
      // wait until a SPI packet is available
      // NOTE: on ST31, dual wait ISO & RF (ISO instead of SPI)
      rx_len = io_seproxyhal_spi_recv(G_io_seproxyhal_spi_buffer, sizeof(G_io_seproxyhal_spi_buffer), 0);
c0d044f0:	4620      	mov	r0, r4
c0d044f2:	462a      	mov	r2, r5
c0d044f4:	f000 fcfa 	bl	c0d04eec <io_seproxyhal_spi_recv>

      // can't process split TLV, continue
      if (rx_len < 3 && rx_len-3 != U2(G_io_seproxyhal_spi_buffer[1],G_io_seproxyhal_spi_buffer[2])) {
c0d044f8:	2802      	cmp	r0, #2
c0d044fa:	d806      	bhi.n	c0d0450a <io_exchange+0x15e>
c0d044fc:	78a1      	ldrb	r1, [r4, #2]
c0d044fe:	7862      	ldrb	r2, [r4, #1]
c0d04500:	0212      	lsls	r2, r2, #8
c0d04502:	1851      	adds	r1, r2, r1
c0d04504:	1ec0      	subs	r0, r0, #3
c0d04506:	4288      	cmp	r0, r1
c0d04508:	d108      	bne.n	c0d0451c <io_exchange+0x170>
        G_io_apdu_state = APDU_IDLE;
        G_io_apdu_length = 0;
        continue;
      }

        io_seproxyhal_handle_event();
c0d0450a:	f7ff fd01 	bl	c0d03f10 <io_seproxyhal_handle_event>
#endif // HAVE_TINY_COROUTINE

      // an apdu has been received asynchroneously, return it
      if (G_io_apdu_state != APDU_IDLE && G_io_apdu_length > 0) {
c0d0450e:	7838      	ldrb	r0, [r7, #0]
c0d04510:	2800      	cmp	r0, #0
c0d04512:	d0e5      	beq.n	c0d044e0 <io_exchange+0x134>
c0d04514:	8830      	ldrh	r0, [r6, #0]
c0d04516:	2800      	cmp	r0, #0
c0d04518:	d0e2      	beq.n	c0d044e0 <io_exchange+0x134>
c0d0451a:	e002      	b.n	c0d04522 <io_exchange+0x176>
c0d0451c:	2000      	movs	r0, #0
      rx_len = io_seproxyhal_spi_recv(G_io_seproxyhal_spi_buffer, sizeof(G_io_seproxyhal_spi_buffer), 0);

      // can't process split TLV, continue
      if (rx_len < 3 && rx_len-3 != U2(G_io_seproxyhal_spi_buffer[1],G_io_seproxyhal_spi_buffer[2])) {
        LOG("invalid TLV format\n");
        G_io_apdu_state = APDU_IDLE;
c0d0451e:	7038      	strb	r0, [r7, #0]
c0d04520:	e7dd      	b.n	c0d044de <io_exchange+0x132>

      // an apdu has been received asynchroneously, return it
      if (G_io_apdu_state != APDU_IDLE && G_io_apdu_length > 0) {
        // handle reserved apdus
        // get name and version
        if (os_memcmp(G_io_apdu_buffer, "\xB0\x01\x00\x00", 4) == 0) {
c0d04522:	491f      	ldr	r1, [pc, #124]	; (c0d045a0 <io_exchange+0x1f4>)
c0d04524:	4479      	add	r1, pc
c0d04526:	2204      	movs	r2, #4
c0d04528:	4816      	ldr	r0, [pc, #88]	; (c0d04584 <io_exchange+0x1d8>)
c0d0452a:	f7ff fbed 	bl	c0d03d08 <os_memcmp>
c0d0452e:	2800      	cmp	r0, #0
c0d04530:	d012      	beq.n	c0d04558 <io_exchange+0x1ac>
          // disable 'return after tx' and 'asynch reply' flags
          channel &= ~IO_FLAGS;
          goto reply_apdu; 
        }
        // exit app after replied
        else if (os_memcmp(G_io_apdu_buffer, "\xB0\xA7\x00\x00", 4) == 0) {
c0d04532:	491c      	ldr	r1, [pc, #112]	; (c0d045a4 <io_exchange+0x1f8>)
c0d04534:	4479      	add	r1, pc
c0d04536:	2204      	movs	r2, #4
c0d04538:	4812      	ldr	r0, [pc, #72]	; (c0d04584 <io_exchange+0x1d8>)
c0d0453a:	f7ff fbe5 	bl	c0d03d08 <os_memcmp>
c0d0453e:	2800      	cmp	r0, #0
c0d04540:	d113      	bne.n	c0d0456a <io_exchange+0x1be>
c0d04542:	4810      	ldr	r0, [pc, #64]	; (c0d04584 <io_exchange+0x1d8>)
c0d04544:	4602      	mov	r2, r0
          tx_len = 0;
          G_io_apdu_buffer[tx_len++] = 0x90;
          G_io_apdu_buffer[tx_len++] = 0x00;
c0d04546:	7045      	strb	r5, [r0, #1]
c0d04548:	9901      	ldr	r1, [sp, #4]
          goto reply_apdu; 
        }
        // exit app after replied
        else if (os_memcmp(G_io_apdu_buffer, "\xB0\xA7\x00\x00", 4) == 0) {
          tx_len = 0;
          G_io_apdu_buffer[tx_len++] = 0x90;
c0d0454a:	4608      	mov	r0, r1
c0d0454c:	3010      	adds	r0, #16
c0d0454e:	7010      	strb	r0, [r2, #0]
c0d04550:	9a03      	ldr	r2, [sp, #12]
          G_io_apdu_buffer[tx_len++] = 0x00;
          // exit app after replied
          channel |= IO_RESET_AFTER_REPLIED;
c0d04552:	430a      	orrs	r2, r1
c0d04554:	2302      	movs	r3, #2
c0d04556:	e003      	b.n	c0d04560 <io_exchange+0x1b4>
      // an apdu has been received asynchroneously, return it
      if (G_io_apdu_state != APDU_IDLE && G_io_apdu_length > 0) {
        // handle reserved apdus
        // get name and version
        if (os_memcmp(G_io_apdu_buffer, "\xB0\x01\x00\x00", 4) == 0) {
          tx_len = os_io_seproxyhal_get_app_name_and_version();
c0d04558:	f7ff ff04 	bl	c0d04364 <os_io_seproxyhal_get_app_name_and_version>
c0d0455c:	4603      	mov	r3, r0
c0d0455e:	2200      	movs	r2, #0
  }
  after_debug:
#endif // DEBUG_APDU

reply_apdu:
  switch(channel&~(IO_FLAGS)) {
c0d04560:	b2d1      	uxtb	r1, r2
c0d04562:	0750      	lsls	r0, r2, #29
c0d04564:	d100      	bne.n	c0d04568 <io_exchange+0x1bc>
c0d04566:	e735      	b.n	c0d043d4 <io_exchange+0x28>
c0d04568:	e727      	b.n	c0d043ba <io_exchange+0xe>
          // disable 'return after tx' and 'asynch reply' flags
          channel &= ~IO_FLAGS;
          goto reply_apdu; 
        }
#endif // HAVE_BOLOS_WITH_VIRGIN_ATTESTATION
        return G_io_apdu_length;
c0d0456a:	8830      	ldrh	r0, [r6, #0]
c0d0456c:	e729      	b.n	c0d043c2 <io_exchange+0x16>
    if (!(channel&IO_ASYNCH_REPLY)) {
      
      // already received the data of the apdu when received the whole apdu
      if ((channel & (CHANNEL_APDU|IO_RECEIVE_DATA)) == (CHANNEL_APDU|IO_RECEIVE_DATA)) {
        // return apdu data - header
        return G_io_apdu_length-5;
c0d0456e:	8830      	ldrh	r0, [r6, #0]
c0d04570:	1f40      	subs	r0, r0, #5
c0d04572:	e726      	b.n	c0d043c2 <io_exchange+0x16>
c0d04574:	2009      	movs	r0, #9
            if (io_exchange_al(channel, tx_len) == 0) {
              goto break_send;
            }
          case APDU_IDLE:
            LOG("invalid state for APDU reply\n");
            THROW(INVALID_STATE);
c0d04576:	f7ff fbdb 	bl	c0d03d30 <os_longjmp>
c0d0457a:	2002      	movs	r0, #2
c0d0457c:	f7ff fbd8 	bl	c0d03d30 <os_longjmp>
c0d04580:	200022dc 	.word	0x200022dc
c0d04584:	2000216c 	.word	0x2000216c
c0d04588:	200022ec 	.word	0x200022ec
c0d0458c:	0000fffe 	.word	0x0000fffe
c0d04590:	20001800 	.word	0x20001800
c0d04594:	200022c8 	.word	0x200022c8
c0d04598:	200022de 	.word	0x200022de
c0d0459c:	fffffa83 	.word	0xfffffa83
c0d045a0:	000035c0 	.word	0x000035c0
c0d045a4:	000035b5 	.word	0x000035b5

c0d045a8 <ux_menu_element_preprocessor>:
    return ux_menu.menu_iterator(entry_idx);
  } 
  return &ux_menu.menu_entries[entry_idx];
} 

const bagl_element_t* ux_menu_element_preprocessor(const bagl_element_t* element) {
c0d045a8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d045aa:	b081      	sub	sp, #4
c0d045ac:	4607      	mov	r7, r0
  //todo avoid center alignment when text_x or icon_x AND text_x are not 0
  os_memmove(&ux_menu.tmp_element, element, sizeof(bagl_element_t));
c0d045ae:	4c5d      	ldr	r4, [pc, #372]	; (c0d04724 <ux_menu_element_preprocessor+0x17c>)
c0d045b0:	4625      	mov	r5, r4
c0d045b2:	3514      	adds	r5, #20
c0d045b4:	2238      	movs	r2, #56	; 0x38
c0d045b6:	4628      	mov	r0, r5
c0d045b8:	4639      	mov	r1, r7
c0d045ba:	f7ff faea 	bl	c0d03b92 <os_memmove>
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d045be:	6921      	ldr	r1, [r4, #16]
const bagl_element_t* ux_menu_element_preprocessor(const bagl_element_t* element) {
  //todo avoid center alignment when text_x or icon_x AND text_x are not 0
  os_memmove(&ux_menu.tmp_element, element, sizeof(bagl_element_t));

  // ask the current entry first, to setup other entries
  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);
c0d045c0:	68a0      	ldr	r0, [r4, #8]
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d045c2:	2900      	cmp	r1, #0
c0d045c4:	d003      	beq.n	c0d045ce <ux_menu_element_preprocessor+0x26>
    return ux_menu.menu_iterator(entry_idx);
c0d045c6:	4788      	blx	r1
c0d045c8:	4603      	mov	r3, r0

  // ask the current entry first, to setup other entries
  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);

  const ux_menu_entry_t* previous_entry = NULL;
  if (ux_menu.current_entry) {
c0d045ca:	68a0      	ldr	r0, [r4, #8]
c0d045cc:	e003      	b.n	c0d045d6 <ux_menu_element_preprocessor+0x2e>
c0d045ce:	211c      	movs	r1, #28

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
    return ux_menu.menu_iterator(entry_idx);
  } 
  return &ux_menu.menu_entries[entry_idx];
c0d045d0:	4341      	muls	r1, r0
c0d045d2:	6822      	ldr	r2, [r4, #0]
c0d045d4:	1853      	adds	r3, r2, r1
c0d045d6:	2600      	movs	r6, #0

  // ask the current entry first, to setup other entries
  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);

  const ux_menu_entry_t* previous_entry = NULL;
  if (ux_menu.current_entry) {
c0d045d8:	2800      	cmp	r0, #0
c0d045da:	d010      	beq.n	c0d045fe <ux_menu_element_preprocessor+0x56>
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d045dc:	6922      	ldr	r2, [r4, #16]
  // ask the current entry first, to setup other entries
  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);

  const ux_menu_entry_t* previous_entry = NULL;
  if (ux_menu.current_entry) {
    previous_entry = ux_menu_get_entry(ux_menu.current_entry-1);
c0d045de:	1e41      	subs	r1, r0, #1
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d045e0:	2a00      	cmp	r2, #0
c0d045e2:	d00f      	beq.n	c0d04604 <ux_menu_element_preprocessor+0x5c>
    return ux_menu.menu_iterator(entry_idx);
c0d045e4:	4608      	mov	r0, r1
c0d045e6:	9700      	str	r7, [sp, #0]
c0d045e8:	4637      	mov	r7, r6
c0d045ea:	462e      	mov	r6, r5
c0d045ec:	461d      	mov	r5, r3
c0d045ee:	4790      	blx	r2
c0d045f0:	462b      	mov	r3, r5
c0d045f2:	4635      	mov	r5, r6
c0d045f4:	463e      	mov	r6, r7
c0d045f6:	9f00      	ldr	r7, [sp, #0]
c0d045f8:	4602      	mov	r2, r0
  const ux_menu_entry_t* previous_entry = NULL;
  if (ux_menu.current_entry) {
    previous_entry = ux_menu_get_entry(ux_menu.current_entry-1);
  }
  const ux_menu_entry_t* next_entry = NULL;
  if (ux_menu.current_entry < ux_menu.menu_entries_count-1) {
c0d045fa:	68a0      	ldr	r0, [r4, #8]
c0d045fc:	e006      	b.n	c0d0460c <ux_menu_element_preprocessor+0x64>
c0d045fe:	4630      	mov	r0, r6
c0d04600:	4632      	mov	r2, r6
c0d04602:	e003      	b.n	c0d0460c <ux_menu_element_preprocessor+0x64>
c0d04604:	221c      	movs	r2, #28

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
    return ux_menu.menu_iterator(entry_idx);
  } 
  return &ux_menu.menu_entries[entry_idx];
c0d04606:	434a      	muls	r2, r1
c0d04608:	6821      	ldr	r1, [r4, #0]
c0d0460a:	188a      	adds	r2, r1, r2
  const ux_menu_entry_t* previous_entry = NULL;
  if (ux_menu.current_entry) {
    previous_entry = ux_menu_get_entry(ux_menu.current_entry-1);
  }
  const ux_menu_entry_t* next_entry = NULL;
  if (ux_menu.current_entry < ux_menu.menu_entries_count-1) {
c0d0460c:	6861      	ldr	r1, [r4, #4]
c0d0460e:	1e49      	subs	r1, r1, #1
c0d04610:	4288      	cmp	r0, r1
c0d04612:	d210      	bcs.n	c0d04636 <ux_menu_element_preprocessor+0x8e>
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d04614:	6921      	ldr	r1, [r4, #16]
  if (ux_menu.current_entry) {
    previous_entry = ux_menu_get_entry(ux_menu.current_entry-1);
  }
  const ux_menu_entry_t* next_entry = NULL;
  if (ux_menu.current_entry < ux_menu.menu_entries_count-1) {
    next_entry = ux_menu_get_entry(ux_menu.current_entry+1);
c0d04616:	1c40      	adds	r0, r0, #1
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d04618:	2900      	cmp	r1, #0
c0d0461a:	d008      	beq.n	c0d0462e <ux_menu_element_preprocessor+0x86>
c0d0461c:	9500      	str	r5, [sp, #0]
c0d0461e:	461d      	mov	r5, r3
c0d04620:	4616      	mov	r6, r2
    return ux_menu.menu_iterator(entry_idx);
c0d04622:	4788      	blx	r1
c0d04624:	4632      	mov	r2, r6
c0d04626:	462b      	mov	r3, r5
c0d04628:	9d00      	ldr	r5, [sp, #0]
c0d0462a:	4606      	mov	r6, r0
c0d0462c:	e003      	b.n	c0d04636 <ux_menu_element_preprocessor+0x8e>
c0d0462e:	211c      	movs	r1, #28
  } 
  return &ux_menu.menu_entries[entry_idx];
c0d04630:	4341      	muls	r1, r0
c0d04632:	6820      	ldr	r0, [r4, #0]
c0d04634:	1846      	adds	r6, r0, r1
  const ux_menu_entry_t* next_entry = NULL;
  if (ux_menu.current_entry < ux_menu.menu_entries_count-1) {
    next_entry = ux_menu_get_entry(ux_menu.current_entry+1);
  }

  switch(element->component.userid) {
c0d04636:	7878      	ldrb	r0, [r7, #1]
c0d04638:	2840      	cmp	r0, #64	; 0x40
c0d0463a:	dc0a      	bgt.n	c0d04652 <ux_menu_element_preprocessor+0xaa>
c0d0463c:	2820      	cmp	r0, #32
c0d0463e:	dc21      	bgt.n	c0d04684 <ux_menu_element_preprocessor+0xdc>
c0d04640:	2810      	cmp	r0, #16
c0d04642:	d032      	beq.n	c0d046aa <ux_menu_element_preprocessor+0x102>
c0d04644:	2820      	cmp	r0, #32
c0d04646:	d162      	bne.n	c0d0470e <ux_menu_element_preprocessor+0x166>
      if (current_entry->icon_x) {
        ux_menu.tmp_element.component.x = current_entry->icon_x;
      }
      break;
    case 0x20:
      if (current_entry->line2 != NULL) {
c0d04648:	6959      	ldr	r1, [r3, #20]
c0d0464a:	2000      	movs	r0, #0
c0d0464c:	2900      	cmp	r1, #0
c0d0464e:	d166      	bne.n	c0d0471e <ux_menu_element_preprocessor+0x176>
c0d04650:	e04e      	b.n	c0d046f0 <ux_menu_element_preprocessor+0x148>
  const ux_menu_entry_t* next_entry = NULL;
  if (ux_menu.current_entry < ux_menu.menu_entries_count-1) {
    next_entry = ux_menu_get_entry(ux_menu.current_entry+1);
  }

  switch(element->component.userid) {
c0d04652:	2880      	cmp	r0, #128	; 0x80
c0d04654:	dc20      	bgt.n	c0d04698 <ux_menu_element_preprocessor+0xf0>
c0d04656:	2841      	cmp	r0, #65	; 0x41
c0d04658:	d030      	beq.n	c0d046bc <ux_menu_element_preprocessor+0x114>
c0d0465a:	2842      	cmp	r0, #66	; 0x42
c0d0465c:	d157      	bne.n	c0d0470e <ux_menu_element_preprocessor+0x166>
      }
      ux_menu.tmp_element.text = previous_entry->line1;
      break;
    // next setting name
    case 0x42:
      if (current_entry->line2 != NULL 
c0d0465e:	6959      	ldr	r1, [r3, #20]
c0d04660:	2000      	movs	r0, #0
        || current_entry->icon != NULL
c0d04662:	2900      	cmp	r1, #0
c0d04664:	d15b      	bne.n	c0d0471e <ux_menu_element_preprocessor+0x176>
c0d04666:	68d9      	ldr	r1, [r3, #12]
        || ux_menu.current_entry == ux_menu.menu_entries_count-1
c0d04668:	2900      	cmp	r1, #0
c0d0466a:	d158      	bne.n	c0d0471e <ux_menu_element_preprocessor+0x176>
c0d0466c:	6862      	ldr	r2, [r4, #4]
c0d0466e:	1e51      	subs	r1, r2, #1
        || ux_menu.menu_entries_count == 1
c0d04670:	2a01      	cmp	r2, #1
c0d04672:	d054      	beq.n	c0d0471e <ux_menu_element_preprocessor+0x176>
c0d04674:	68a2      	ldr	r2, [r4, #8]
c0d04676:	428a      	cmp	r2, r1
c0d04678:	d051      	beq.n	c0d0471e <ux_menu_element_preprocessor+0x176>
        || next_entry->icon != NULL) {
c0d0467a:	68f1      	ldr	r1, [r6, #12]
      }
      ux_menu.tmp_element.text = previous_entry->line1;
      break;
    // next setting name
    case 0x42:
      if (current_entry->line2 != NULL 
c0d0467c:	2900      	cmp	r1, #0
c0d0467e:	d14e      	bne.n	c0d0471e <ux_menu_element_preprocessor+0x176>
        || ux_menu.current_entry == ux_menu.menu_entries_count-1
        || ux_menu.menu_entries_count == 1
        || next_entry->icon != NULL) {
        return NULL;
      }
      ux_menu.tmp_element.text = next_entry->line1;
c0d04680:	6930      	ldr	r0, [r6, #16]
c0d04682:	e02f      	b.n	c0d046e4 <ux_menu_element_preprocessor+0x13c>
  const ux_menu_entry_t* next_entry = NULL;
  if (ux_menu.current_entry < ux_menu.menu_entries_count-1) {
    next_entry = ux_menu_get_entry(ux_menu.current_entry+1);
  }

  switch(element->component.userid) {
c0d04684:	2821      	cmp	r0, #33	; 0x21
c0d04686:	d02f      	beq.n	c0d046e8 <ux_menu_element_preprocessor+0x140>
c0d04688:	2822      	cmp	r0, #34	; 0x22
c0d0468a:	d140      	bne.n	c0d0470e <ux_menu_element_preprocessor+0x166>
        return NULL;
      }
      ux_menu.tmp_element.text = current_entry->line1;
      goto adjust_text_x;
    case 0x22:
      if (current_entry->line2 == NULL) {
c0d0468c:	6959      	ldr	r1, [r3, #20]
c0d0468e:	2000      	movs	r0, #0
c0d04690:	2900      	cmp	r1, #0
c0d04692:	d044      	beq.n	c0d0471e <ux_menu_element_preprocessor+0x176>
        return NULL;
      }
      ux_menu.tmp_element.text = current_entry->line2;
c0d04694:	6321      	str	r1, [r4, #48]	; 0x30
c0d04696:	e02d      	b.n	c0d046f4 <ux_menu_element_preprocessor+0x14c>
  const ux_menu_entry_t* next_entry = NULL;
  if (ux_menu.current_entry < ux_menu.menu_entries_count-1) {
    next_entry = ux_menu_get_entry(ux_menu.current_entry+1);
  }

  switch(element->component.userid) {
c0d04698:	2882      	cmp	r0, #130	; 0x82
c0d0469a:	d032      	beq.n	c0d04702 <ux_menu_element_preprocessor+0x15a>
c0d0469c:	2881      	cmp	r0, #129	; 0x81
c0d0469e:	d136      	bne.n	c0d0470e <ux_menu_element_preprocessor+0x166>
    case 0x81:
      if (ux_menu.current_entry == 0) {
c0d046a0:	68a1      	ldr	r1, [r4, #8]
c0d046a2:	2000      	movs	r0, #0
c0d046a4:	2900      	cmp	r1, #0
c0d046a6:	d132      	bne.n	c0d0470e <ux_menu_element_preprocessor+0x166>
c0d046a8:	e039      	b.n	c0d0471e <ux_menu_element_preprocessor+0x176>
        return NULL;
      }
      ux_menu.tmp_element.text = next_entry->line1;
      break;
    case 0x10:
      if (current_entry->icon == NULL) {
c0d046aa:	68d9      	ldr	r1, [r3, #12]
c0d046ac:	2000      	movs	r0, #0
c0d046ae:	2900      	cmp	r1, #0
c0d046b0:	d035      	beq.n	c0d0471e <ux_menu_element_preprocessor+0x176>
        return NULL;
      }
      ux_menu.tmp_element.text = (const char*)current_entry->icon;
c0d046b2:	6321      	str	r1, [r4, #48]	; 0x30
      if (current_entry->icon_x) {
c0d046b4:	7e58      	ldrb	r0, [r3, #25]
c0d046b6:	2800      	cmp	r0, #0
c0d046b8:	d121      	bne.n	c0d046fe <ux_menu_element_preprocessor+0x156>
c0d046ba:	e028      	b.n	c0d0470e <ux_menu_element_preprocessor+0x166>
        return NULL;
      }
      break;
    // previous setting name
    case 0x41:
      if (current_entry->line2 != NULL 
c0d046bc:	6959      	ldr	r1, [r3, #20]
c0d046be:	2000      	movs	r0, #0
        || current_entry->icon != NULL
c0d046c0:	2900      	cmp	r1, #0
c0d046c2:	d12c      	bne.n	c0d0471e <ux_menu_element_preprocessor+0x176>
c0d046c4:	68d9      	ldr	r1, [r3, #12]
        || ux_menu.current_entry == 0
c0d046c6:	2900      	cmp	r1, #0
c0d046c8:	d129      	bne.n	c0d0471e <ux_menu_element_preprocessor+0x176>
c0d046ca:	68a1      	ldr	r1, [r4, #8]
c0d046cc:	2900      	cmp	r1, #0
c0d046ce:	d026      	beq.n	c0d0471e <ux_menu_element_preprocessor+0x176>
c0d046d0:	6861      	ldr	r1, [r4, #4]
c0d046d2:	2901      	cmp	r1, #1
c0d046d4:	d023      	beq.n	c0d0471e <ux_menu_element_preprocessor+0x176>
        || ux_menu.menu_entries_count == 1 
        || previous_entry->icon != NULL
c0d046d6:	68d1      	ldr	r1, [r2, #12]
        || previous_entry->line2 != NULL) {
c0d046d8:	2900      	cmp	r1, #0
c0d046da:	d120      	bne.n	c0d0471e <ux_menu_element_preprocessor+0x176>
c0d046dc:	6951      	ldr	r1, [r2, #20]
        return NULL;
      }
      break;
    // previous setting name
    case 0x41:
      if (current_entry->line2 != NULL 
c0d046de:	2900      	cmp	r1, #0
c0d046e0:	d11d      	bne.n	c0d0471e <ux_menu_element_preprocessor+0x176>
        || ux_menu.menu_entries_count == 1 
        || previous_entry->icon != NULL
        || previous_entry->line2 != NULL) {
        return 0;
      }
      ux_menu.tmp_element.text = previous_entry->line1;
c0d046e2:	6910      	ldr	r0, [r2, #16]
c0d046e4:	6320      	str	r0, [r4, #48]	; 0x30
c0d046e6:	e012      	b.n	c0d0470e <ux_menu_element_preprocessor+0x166>
        return NULL;
      }
      ux_menu.tmp_element.text = current_entry->line1;
      goto adjust_text_x;
    case 0x21:
      if (current_entry->line2 == NULL) {
c0d046e8:	6959      	ldr	r1, [r3, #20]
c0d046ea:	2000      	movs	r0, #0
c0d046ec:	2900      	cmp	r1, #0
c0d046ee:	d016      	beq.n	c0d0471e <ux_menu_element_preprocessor+0x176>
c0d046f0:	6918      	ldr	r0, [r3, #16]
c0d046f2:	6320      	str	r0, [r4, #48]	; 0x30
      if (current_entry->line2 == NULL) {
        return NULL;
      }
      ux_menu.tmp_element.text = current_entry->line2;
    adjust_text_x:
      if (current_entry->text_x) {
c0d046f4:	7e18      	ldrb	r0, [r3, #24]
c0d046f6:	2800      	cmp	r0, #0
c0d046f8:	d009      	beq.n	c0d0470e <ux_menu_element_preprocessor+0x166>
c0d046fa:	2108      	movs	r1, #8
        ux_menu.tmp_element.component.x = current_entry->text_x;
        // discard the 'center' flag
        ux_menu.tmp_element.component.font_id = BAGL_FONT_OPEN_SANS_EXTRABOLD_11px;
c0d046fc:	85a1      	strh	r1, [r4, #44]	; 0x2c
c0d046fe:	82e0      	strh	r0, [r4, #22]
c0d04700:	e005      	b.n	c0d0470e <ux_menu_element_preprocessor+0x166>
      if (ux_menu.current_entry == 0) {
        return NULL;
      }
      break;
    case 0x82:
      if (ux_menu.current_entry == ux_menu.menu_entries_count-1) {
c0d04702:	6860      	ldr	r0, [r4, #4]
c0d04704:	68a1      	ldr	r1, [r4, #8]
c0d04706:	1e42      	subs	r2, r0, #1
c0d04708:	2000      	movs	r0, #0
c0d0470a:	4291      	cmp	r1, r2
c0d0470c:	d007      	beq.n	c0d0471e <ux_menu_element_preprocessor+0x176>
        ux_menu.tmp_element.component.font_id = BAGL_FONT_OPEN_SANS_EXTRABOLD_11px;
      }
      break;
  }
  // ensure prepro agrees to the element to be displayed
  if (ux_menu.menu_entry_preprocessor) {
c0d0470e:	68e2      	ldr	r2, [r4, #12]
c0d04710:	2a00      	cmp	r2, #0
c0d04712:	4628      	mov	r0, r5
c0d04714:	d003      	beq.n	c0d0471e <ux_menu_element_preprocessor+0x176>
    // menu is denied by the menu entry preprocessor
    return ux_menu.menu_entry_preprocessor(current_entry, &ux_menu.tmp_element);
c0d04716:	3414      	adds	r4, #20
c0d04718:	4618      	mov	r0, r3
c0d0471a:	4621      	mov	r1, r4
c0d0471c:	4790      	blx	r2
  }

  return &ux_menu.tmp_element;
}
c0d0471e:	b001      	add	sp, #4
c0d04720:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d04722:	46c0      	nop			; (mov r8, r8)
c0d04724:	20002324 	.word	0x20002324

c0d04728 <ux_menu_elements_button>:

unsigned int ux_menu_elements_button (unsigned int button_mask, unsigned int button_mask_counter) {
c0d04728:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0472a:	b081      	sub	sp, #4
c0d0472c:	4605      	mov	r5, r0
  UNUSED(button_mask_counter);

  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);
c0d0472e:	4f3c      	ldr	r7, [pc, #240]	; (c0d04820 <ux_menu_elements_button+0xf8>)
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d04730:	6939      	ldr	r1, [r7, #16]
}

unsigned int ux_menu_elements_button (unsigned int button_mask, unsigned int button_mask_counter) {
  UNUSED(button_mask_counter);

  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);
c0d04732:	68b8      	ldr	r0, [r7, #8]
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d04734:	2900      	cmp	r1, #0
c0d04736:	d002      	beq.n	c0d0473e <ux_menu_elements_button+0x16>
    return ux_menu.menu_iterator(entry_idx);
c0d04738:	4788      	blx	r1
c0d0473a:	4606      	mov	r6, r0
c0d0473c:	e003      	b.n	c0d04746 <ux_menu_elements_button+0x1e>
c0d0473e:	211c      	movs	r1, #28
  } 
  return &ux_menu.menu_entries[entry_idx];
c0d04740:	4341      	muls	r1, r0
c0d04742:	6838      	ldr	r0, [r7, #0]
c0d04744:	1846      	adds	r6, r0, r1
c0d04746:	2401      	movs	r4, #1
c0d04748:	4836      	ldr	r0, [pc, #216]	; (c0d04824 <ux_menu_elements_button+0xfc>)
unsigned int ux_menu_elements_button (unsigned int button_mask, unsigned int button_mask_counter) {
  UNUSED(button_mask_counter);

  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);

  switch (button_mask) {
c0d0474a:	4285      	cmp	r5, r0
c0d0474c:	dd14      	ble.n	c0d04778 <ux_menu_elements_button+0x50>
c0d0474e:	4836      	ldr	r0, [pc, #216]	; (c0d04828 <ux_menu_elements_button+0x100>)
c0d04750:	4285      	cmp	r5, r0
c0d04752:	d016      	beq.n	c0d04782 <ux_menu_elements_button+0x5a>
c0d04754:	4835      	ldr	r0, [pc, #212]	; (c0d0482c <ux_menu_elements_button+0x104>)
c0d04756:	4285      	cmp	r5, r0
c0d04758:	d01b      	beq.n	c0d04792 <ux_menu_elements_button+0x6a>
c0d0475a:	4835      	ldr	r0, [pc, #212]	; (c0d04830 <ux_menu_elements_button+0x108>)
c0d0475c:	4285      	cmp	r5, r0
c0d0475e:	d15c      	bne.n	c0d0481a <ux_menu_elements_button+0xf2>
    // enter menu or exit menu
    case BUTTON_EVT_RELEASED|BUTTON_LEFT|BUTTON_RIGHT:
      // menu is priority 1
      if (current_entry->menu) {
c0d04760:	6830      	ldr	r0, [r6, #0]
c0d04762:	2800      	cmp	r0, #0
c0d04764:	d050      	beq.n	c0d04808 <ux_menu_elements_button+0xe0>
        // use userid as the pointer to current entry in the parent menu
        UX_MENU_DISPLAY(current_entry->userid, (const ux_menu_entry_t*)PIC(current_entry->menu), ux_menu.menu_entry_preprocessor);
c0d04766:	68b4      	ldr	r4, [r6, #8]
c0d04768:	f000 f900 	bl	c0d0496c <pic>
c0d0476c:	4601      	mov	r1, r0
c0d0476e:	68fa      	ldr	r2, [r7, #12]
c0d04770:	4620      	mov	r0, r4
c0d04772:	f000 f86b 	bl	c0d0484c <ux_menu_display>
c0d04776:	e04f      	b.n	c0d04818 <ux_menu_elements_button+0xf0>
c0d04778:	492e      	ldr	r1, [pc, #184]	; (c0d04834 <ux_menu_elements_button+0x10c>)
unsigned int ux_menu_elements_button (unsigned int button_mask, unsigned int button_mask_counter) {
  UNUSED(button_mask_counter);

  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);

  switch (button_mask) {
c0d0477a:	428d      	cmp	r5, r1
c0d0477c:	d009      	beq.n	c0d04792 <ux_menu_elements_button+0x6a>
c0d0477e:	4285      	cmp	r5, r0
c0d04780:	d14b      	bne.n	c0d0481a <ux_menu_elements_button+0xf2>
      goto redraw;

    case BUTTON_EVT_FAST|BUTTON_RIGHT:
    case BUTTON_EVT_RELEASED|BUTTON_RIGHT:
      // entry 0 is the number of entries in the menu list
      if (ux_menu.current_entry >= ux_menu.menu_entries_count-1) {
c0d04782:	6879      	ldr	r1, [r7, #4]
c0d04784:	68b8      	ldr	r0, [r7, #8]
c0d04786:	1e49      	subs	r1, r1, #1
c0d04788:	2400      	movs	r4, #0
c0d0478a:	4288      	cmp	r0, r1
c0d0478c:	d245      	bcs.n	c0d0481a <ux_menu_elements_button+0xf2>
        return 0;
      }
      ux_menu.current_entry++;
c0d0478e:	1c40      	adds	r0, r0, #1
c0d04790:	e004      	b.n	c0d0479c <ux_menu_elements_button+0x74>
      break;

    case BUTTON_EVT_FAST|BUTTON_LEFT:
    case BUTTON_EVT_RELEASED|BUTTON_LEFT:
      // entry 0 is the number of entries in the menu list
      if (ux_menu.current_entry == 0) {
c0d04792:	68b8      	ldr	r0, [r7, #8]
c0d04794:	2400      	movs	r4, #0
c0d04796:	2800      	cmp	r0, #0
c0d04798:	d03f      	beq.n	c0d0481a <ux_menu_elements_button+0xf2>
        return 0;
      }
      ux_menu.current_entry--;
c0d0479a:	1e40      	subs	r0, r0, #1
  io_seproxyhal_init_button();
}

void io_seproxyhal_init_ux(void) {
  // initialize the touch part
  G_bagl_last_touched_not_released_component = NULL;
c0d0479c:	4926      	ldr	r1, [pc, #152]	; (c0d04838 <ux_menu_elements_button+0x110>)
c0d0479e:	2400      	movs	r4, #0
c0d047a0:	600c      	str	r4, [r1, #0]
c0d047a2:	60b8      	str	r0, [r7, #8]
}

void io_seproxyhal_init_button(void) {
  // no button push so far
  G_button_mask = 0;
c0d047a4:	4825      	ldr	r0, [pc, #148]	; (c0d0483c <ux_menu_elements_button+0x114>)
c0d047a6:	6004      	str	r4, [r0, #0]
      ux_menu.current_entry++;
    redraw:
#ifdef HAVE_BOLOS_UX
      screen_display_init(0);
#else
      UX_REDISPLAY();
c0d047a8:	4d25      	ldr	r5, [pc, #148]	; (c0d04840 <ux_menu_elements_button+0x118>)
c0d047aa:	60ac      	str	r4, [r5, #8]
}

void io_seproxyhal_init_button(void) {
  // no button push so far
  G_button_mask = 0;
  G_button_same_mask_counter = 0;
c0d047ac:	4825      	ldr	r0, [pc, #148]	; (c0d04844 <ux_menu_elements_button+0x11c>)
c0d047ae:	6004      	str	r4, [r0, #0]
      ux_menu.current_entry++;
    redraw:
#ifdef HAVE_BOLOS_UX
      screen_display_init(0);
#else
      UX_REDISPLAY();
c0d047b0:	6828      	ldr	r0, [r5, #0]
c0d047b2:	2800      	cmp	r0, #0
c0d047b4:	d031      	beq.n	c0d0481a <ux_menu_elements_button+0xf2>
c0d047b6:	69e8      	ldr	r0, [r5, #28]
c0d047b8:	4923      	ldr	r1, [pc, #140]	; (c0d04848 <ux_menu_elements_button+0x120>)
c0d047ba:	4288      	cmp	r0, r1
c0d047bc:	d02d      	beq.n	c0d0481a <ux_menu_elements_button+0xf2>
c0d047be:	2800      	cmp	r0, #0
c0d047c0:	d02b      	beq.n	c0d0481a <ux_menu_elements_button+0xf2>
c0d047c2:	2400      	movs	r4, #0
c0d047c4:	4620      	mov	r0, r4
c0d047c6:	6869      	ldr	r1, [r5, #4]
c0d047c8:	4288      	cmp	r0, r1
c0d047ca:	d226      	bcs.n	c0d0481a <ux_menu_elements_button+0xf2>
c0d047cc:	f000 fb78 	bl	c0d04ec0 <io_seproxyhal_spi_is_status_sent>
c0d047d0:	2800      	cmp	r0, #0
c0d047d2:	d122      	bne.n	c0d0481a <ux_menu_elements_button+0xf2>
c0d047d4:	68a8      	ldr	r0, [r5, #8]
c0d047d6:	68e9      	ldr	r1, [r5, #12]
c0d047d8:	2638      	movs	r6, #56	; 0x38
c0d047da:	4370      	muls	r0, r6
c0d047dc:	682a      	ldr	r2, [r5, #0]
c0d047de:	1810      	adds	r0, r2, r0
c0d047e0:	2900      	cmp	r1, #0
c0d047e2:	d002      	beq.n	c0d047ea <ux_menu_elements_button+0xc2>
c0d047e4:	4788      	blx	r1
c0d047e6:	2800      	cmp	r0, #0
c0d047e8:	d007      	beq.n	c0d047fa <ux_menu_elements_button+0xd2>
c0d047ea:	2801      	cmp	r0, #1
c0d047ec:	d103      	bne.n	c0d047f6 <ux_menu_elements_button+0xce>
c0d047ee:	68a8      	ldr	r0, [r5, #8]
c0d047f0:	4346      	muls	r6, r0
c0d047f2:	6828      	ldr	r0, [r5, #0]
c0d047f4:	1980      	adds	r0, r0, r6
c0d047f6:	f7fe ff37 	bl	c0d03668 <io_seproxyhal_display>
c0d047fa:	68a8      	ldr	r0, [r5, #8]
c0d047fc:	1c40      	adds	r0, r0, #1
c0d047fe:	60a8      	str	r0, [r5, #8]
c0d04800:	6829      	ldr	r1, [r5, #0]
c0d04802:	2900      	cmp	r1, #0
c0d04804:	d1df      	bne.n	c0d047c6 <ux_menu_elements_button+0x9e>
c0d04806:	e008      	b.n	c0d0481a <ux_menu_elements_button+0xf2>
        // use userid as the pointer to current entry in the parent menu
        UX_MENU_DISPLAY(current_entry->userid, (const ux_menu_entry_t*)PIC(current_entry->menu), ux_menu.menu_entry_preprocessor);
        return 0;
      }
      // else callback
      else if (current_entry->callback) {
c0d04808:	6870      	ldr	r0, [r6, #4]
c0d0480a:	2800      	cmp	r0, #0
c0d0480c:	d005      	beq.n	c0d0481a <ux_menu_elements_button+0xf2>
        ((ux_menu_callback_t)PIC(current_entry->callback))(current_entry->userid);
c0d0480e:	f000 f8ad 	bl	c0d0496c <pic>
c0d04812:	4601      	mov	r1, r0
c0d04814:	68b0      	ldr	r0, [r6, #8]
c0d04816:	4788      	blx	r1
c0d04818:	2400      	movs	r4, #0
      UX_REDISPLAY();
#endif
      return 0;
  }
  return 1;
}
c0d0481a:	4620      	mov	r0, r4
c0d0481c:	b001      	add	sp, #4
c0d0481e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d04820:	20002324 	.word	0x20002324
c0d04824:	80000002 	.word	0x80000002
c0d04828:	40000002 	.word	0x40000002
c0d0482c:	40000001 	.word	0x40000001
c0d04830:	80000003 	.word	0x80000003
c0d04834:	80000001 	.word	0x80000001
c0d04838:	200022e0 	.word	0x200022e0
c0d0483c:	200022e4 	.word	0x200022e4
c0d04840:	20001880 	.word	0x20001880
c0d04844:	200022e8 	.word	0x200022e8
c0d04848:	b0105044 	.word	0xb0105044

c0d0484c <ux_menu_display>:

const ux_menu_entry_t UX_MENU_END_ENTRY = UX_MENU_END;

void ux_menu_display(unsigned int current_entry, 
                     const ux_menu_entry_t* menu_entries,
                     ux_menu_preprocessor_t menu_entry_preprocessor) {
c0d0484c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0484e:	b083      	sub	sp, #12
c0d04850:	9202      	str	r2, [sp, #8]
c0d04852:	460d      	mov	r5, r1
c0d04854:	9001      	str	r0, [sp, #4]
  // reset to first entry
  ux_menu.menu_entries_count = 0;
c0d04856:	4e39      	ldr	r6, [pc, #228]	; (c0d0493c <ux_menu_display+0xf0>)
c0d04858:	2000      	movs	r0, #0
c0d0485a:	9000      	str	r0, [sp, #0]
c0d0485c:	6070      	str	r0, [r6, #4]

  // count entries
  if (menu_entries) {
c0d0485e:	2900      	cmp	r1, #0
c0d04860:	d015      	beq.n	c0d0488e <ux_menu_display+0x42>
    for(;;) {
      if (os_memcmp(&menu_entries[ux_menu.menu_entries_count], &UX_MENU_END_ENTRY, sizeof(ux_menu_entry_t)) == 0) {
c0d04862:	493c      	ldr	r1, [pc, #240]	; (c0d04954 <ux_menu_display+0x108>)
c0d04864:	4479      	add	r1, pc
c0d04866:	271c      	movs	r7, #28
c0d04868:	4628      	mov	r0, r5
c0d0486a:	463a      	mov	r2, r7
c0d0486c:	f7ff fa4c 	bl	c0d03d08 <os_memcmp>
c0d04870:	2800      	cmp	r0, #0
c0d04872:	d00c      	beq.n	c0d0488e <ux_menu_display+0x42>
c0d04874:	4c38      	ldr	r4, [pc, #224]	; (c0d04958 <ux_menu_display+0x10c>)
c0d04876:	447c      	add	r4, pc
        break;
      }
      ux_menu.menu_entries_count++;
c0d04878:	6870      	ldr	r0, [r6, #4]
c0d0487a:	1c40      	adds	r0, r0, #1
c0d0487c:	6070      	str	r0, [r6, #4]
  ux_menu.menu_entries_count = 0;

  // count entries
  if (menu_entries) {
    for(;;) {
      if (os_memcmp(&menu_entries[ux_menu.menu_entries_count], &UX_MENU_END_ENTRY, sizeof(ux_menu_entry_t)) == 0) {
c0d0487e:	4378      	muls	r0, r7
c0d04880:	1828      	adds	r0, r5, r0
c0d04882:	4621      	mov	r1, r4
c0d04884:	463a      	mov	r2, r7
c0d04886:	f7ff fa3f 	bl	c0d03d08 <os_memcmp>
c0d0488a:	2800      	cmp	r0, #0
c0d0488c:	d1f4      	bne.n	c0d04878 <ux_menu_display+0x2c>
c0d0488e:	9901      	ldr	r1, [sp, #4]
      }
      ux_menu.menu_entries_count++;
    }
  }

  if (current_entry != UX_MENU_UNCHANGED_ENTRY) {
c0d04890:	1c48      	adds	r0, r1, #1
c0d04892:	d005      	beq.n	c0d048a0 <ux_menu_display+0x54>
    ux_menu.current_entry = current_entry;
    if (ux_menu.current_entry > ux_menu.menu_entries_count) {
c0d04894:	6870      	ldr	r0, [r6, #4]
c0d04896:	4288      	cmp	r0, r1
c0d04898:	9800      	ldr	r0, [sp, #0]
c0d0489a:	d300      	bcc.n	c0d0489e <ux_menu_display+0x52>
c0d0489c:	4608      	mov	r0, r1
c0d0489e:	60b0      	str	r0, [r6, #8]
      ux_menu.current_entry = 0;
    }
  }
  ux_menu.menu_entries = menu_entries;
c0d048a0:	6035      	str	r5, [r6, #0]
c0d048a2:	2500      	movs	r5, #0
  ux_menu.menu_entry_preprocessor = menu_entry_preprocessor;
c0d048a4:	9802      	ldr	r0, [sp, #8]
c0d048a6:	60f0      	str	r0, [r6, #12]
  ux_menu.menu_iterator = NULL;
c0d048a8:	6135      	str	r5, [r6, #16]
  G_bolos_ux_context.screen_stack[0].button_push_callback = ux_menu_elements_button;

  screen_display_init(0);
#else
  // display the menu current entry
  UX_DISPLAY(ux_menu_elements, ux_menu_element_preprocessor);
c0d048aa:	4c25      	ldr	r4, [pc, #148]	; (c0d04940 <ux_menu_display+0xf4>)
c0d048ac:	482b      	ldr	r0, [pc, #172]	; (c0d0495c <ux_menu_display+0x110>)
c0d048ae:	4478      	add	r0, pc
c0d048b0:	2109      	movs	r1, #9
c0d048b2:	c403      	stmia	r4!, {r0, r1}
c0d048b4:	482a      	ldr	r0, [pc, #168]	; (c0d04960 <ux_menu_display+0x114>)
c0d048b6:	4478      	add	r0, pc
c0d048b8:	492a      	ldr	r1, [pc, #168]	; (c0d04964 <ux_menu_display+0x118>)
c0d048ba:	4479      	add	r1, pc
c0d048bc:	6061      	str	r1, [r4, #4]
c0d048be:	60a0      	str	r0, [r4, #8]
c0d048c0:	2003      	movs	r0, #3
c0d048c2:	7420      	strb	r0, [r4, #16]
c0d048c4:	6165      	str	r5, [r4, #20]
c0d048c6:	3c08      	subs	r4, #8
c0d048c8:	4620      	mov	r0, r4
c0d048ca:	3018      	adds	r0, #24
c0d048cc:	f000 fa9e 	bl	c0d04e0c <os_ux>
c0d048d0:	61e0      	str	r0, [r4, #28]
c0d048d2:	f000 f849 	bl	c0d04968 <ux_check_status_default>
  io_seproxyhal_init_button();
}

void io_seproxyhal_init_ux(void) {
  // initialize the touch part
  G_bagl_last_touched_not_released_component = NULL;
c0d048d6:	481b      	ldr	r0, [pc, #108]	; (c0d04944 <ux_menu_display+0xf8>)
c0d048d8:	6005      	str	r5, [r0, #0]
}

void io_seproxyhal_init_button(void) {
  // no button push so far
  G_button_mask = 0;
c0d048da:	481b      	ldr	r0, [pc, #108]	; (c0d04948 <ux_menu_display+0xfc>)
c0d048dc:	6005      	str	r5, [r0, #0]
  G_bolos_ux_context.screen_stack[0].button_push_callback = ux_menu_elements_button;

  screen_display_init(0);
#else
  // display the menu current entry
  UX_DISPLAY(ux_menu_elements, ux_menu_element_preprocessor);
c0d048de:	60a5      	str	r5, [r4, #8]
}

void io_seproxyhal_init_button(void) {
  // no button push so far
  G_button_mask = 0;
  G_button_same_mask_counter = 0;
c0d048e0:	481a      	ldr	r0, [pc, #104]	; (c0d0494c <ux_menu_display+0x100>)
c0d048e2:	6005      	str	r5, [r0, #0]
  G_bolos_ux_context.screen_stack[0].button_push_callback = ux_menu_elements_button;

  screen_display_init(0);
#else
  // display the menu current entry
  UX_DISPLAY(ux_menu_elements, ux_menu_element_preprocessor);
c0d048e4:	6820      	ldr	r0, [r4, #0]
c0d048e6:	2800      	cmp	r0, #0
c0d048e8:	d026      	beq.n	c0d04938 <ux_menu_display+0xec>
c0d048ea:	69e0      	ldr	r0, [r4, #28]
c0d048ec:	4918      	ldr	r1, [pc, #96]	; (c0d04950 <ux_menu_display+0x104>)
c0d048ee:	4288      	cmp	r0, r1
c0d048f0:	d022      	beq.n	c0d04938 <ux_menu_display+0xec>
c0d048f2:	2800      	cmp	r0, #0
c0d048f4:	d020      	beq.n	c0d04938 <ux_menu_display+0xec>
c0d048f6:	2000      	movs	r0, #0
c0d048f8:	6861      	ldr	r1, [r4, #4]
c0d048fa:	4288      	cmp	r0, r1
c0d048fc:	d21c      	bcs.n	c0d04938 <ux_menu_display+0xec>
c0d048fe:	f000 fadf 	bl	c0d04ec0 <io_seproxyhal_spi_is_status_sent>
c0d04902:	2800      	cmp	r0, #0
c0d04904:	d118      	bne.n	c0d04938 <ux_menu_display+0xec>
c0d04906:	68a0      	ldr	r0, [r4, #8]
c0d04908:	68e1      	ldr	r1, [r4, #12]
c0d0490a:	2538      	movs	r5, #56	; 0x38
c0d0490c:	4368      	muls	r0, r5
c0d0490e:	6822      	ldr	r2, [r4, #0]
c0d04910:	1810      	adds	r0, r2, r0
c0d04912:	2900      	cmp	r1, #0
c0d04914:	d002      	beq.n	c0d0491c <ux_menu_display+0xd0>
c0d04916:	4788      	blx	r1
c0d04918:	2800      	cmp	r0, #0
c0d0491a:	d007      	beq.n	c0d0492c <ux_menu_display+0xe0>
c0d0491c:	2801      	cmp	r0, #1
c0d0491e:	d103      	bne.n	c0d04928 <ux_menu_display+0xdc>
c0d04920:	68a0      	ldr	r0, [r4, #8]
c0d04922:	4345      	muls	r5, r0
c0d04924:	6820      	ldr	r0, [r4, #0]
c0d04926:	1940      	adds	r0, r0, r5
c0d04928:	f7fe fe9e 	bl	c0d03668 <io_seproxyhal_display>
c0d0492c:	68a0      	ldr	r0, [r4, #8]
c0d0492e:	1c40      	adds	r0, r0, #1
c0d04930:	60a0      	str	r0, [r4, #8]
c0d04932:	6821      	ldr	r1, [r4, #0]
c0d04934:	2900      	cmp	r1, #0
c0d04936:	d1df      	bne.n	c0d048f8 <ux_menu_display+0xac>
#endif
}
c0d04938:	b003      	add	sp, #12
c0d0493a:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d0493c:	20002324 	.word	0x20002324
c0d04940:	20001880 	.word	0x20001880
c0d04944:	200022e0 	.word	0x200022e0
c0d04948:	200022e4 	.word	0x200022e4
c0d0494c:	200022e8 	.word	0x200022e8
c0d04950:	b0105044 	.word	0xb0105044
c0d04954:	00003484 	.word	0x00003484
c0d04958:	00003472 	.word	0x00003472
c0d0495c:	00003242 	.word	0x00003242
c0d04960:	fffffe6f 	.word	0xfffffe6f
c0d04964:	fffffceb 	.word	0xfffffceb

c0d04968 <ux_check_status_default>:
}

void ux_check_status_default(unsigned int status) {
  // nothing to be done here by default.
  UNUSED(status);
}
c0d04968:	4770      	bx	lr
	...

c0d0496c <pic>:

// only apply PIC conversion if link_address is in linked code (over 0xC0D00000 in our example)
// this way, PIC call are armless if the address is not meant to be converted
extern unsigned int _nvram;
extern unsigned int _envram;
unsigned int pic(unsigned int link_address) {
c0d0496c:	b580      	push	{r7, lr}
//  screen_printf(" %08X", link_address);
	if (link_address >= ((unsigned int)&_nvram) && link_address < ((unsigned int)&_envram)) {
c0d0496e:	4904      	ldr	r1, [pc, #16]	; (c0d04980 <pic+0x14>)
c0d04970:	4288      	cmp	r0, r1
c0d04972:	d304      	bcc.n	c0d0497e <pic+0x12>
c0d04974:	4903      	ldr	r1, [pc, #12]	; (c0d04984 <pic+0x18>)
c0d04976:	4288      	cmp	r0, r1
c0d04978:	d201      	bcs.n	c0d0497e <pic+0x12>
		link_address = pic_internal(link_address);
c0d0497a:	f000 f805 	bl	c0d04988 <pic_internal>
//    screen_printf(" -> %08X\n", link_address);
  }
	return link_address;
c0d0497e:	bd80      	pop	{r7, pc}
c0d04980:	c0d00000 	.word	0xc0d00000
c0d04984:	c0d08140 	.word	0xc0d08140

c0d04988 <pic_internal>:

unsigned int pic_internal(unsigned int link_address) __attribute__((naked));
unsigned int pic_internal(unsigned int link_address) 
{
  // compute the delta offset between LinkMemAddr & ExecMemAddr
  __asm volatile ("mov r2, pc\n");          // r2 = 0x109004
c0d04988:	467a      	mov	r2, pc
  __asm volatile ("ldr r1, =pic_internal\n");        // r1 = 0xC0D00001
c0d0498a:	4902      	ldr	r1, [pc, #8]	; (c0d04994 <pic_internal+0xc>)
  __asm volatile ("adds r1, r1, #3\n");     // r1 = 0xC0D00004
c0d0498c:	1cc9      	adds	r1, r1, #3
  __asm volatile ("subs r1, r1, r2\n");     // r1 = 0xC0BF7000 (delta between load and exec address)
c0d0498e:	1a89      	subs	r1, r1, r2

  // adjust value of the given parameter
  __asm volatile ("subs r0, r0, r1\n");     // r0 = 0xC0D0C244 => r0 = 0x115244
c0d04990:	1a40      	subs	r0, r0, r1
  __asm volatile ("bx lr\n");
c0d04992:	4770      	bx	lr
c0d04994:	c0d04989 	.word	0xc0d04989

c0d04998 <SVC_Call>:
  // avoid a separate asm file, but avoid any intrusion from the compiler
  unsigned int SVC_Call(unsigned int syscall_id, unsigned int * parameters) __attribute__ ((naked));
  //                    r0                       r1
  unsigned int SVC_Call(unsigned int syscall_id, unsigned int * parameters) {
    // delegate svc
    asm volatile("svc #1":::"r0","r1");
c0d04998:	df01      	svc	1
    // directly return R0 value
    asm volatile("bx  lr");
c0d0499a:	4770      	bx	lr

c0d0499c <check_api_level>:
  }
  void check_api_level ( unsigned int apiLevel ) 
{
c0d0499c:	b580      	push	{r7, lr}
c0d0499e:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)apiLevel;
c0d049a0:	9000      	str	r0, [sp, #0]
c0d049a2:	4807      	ldr	r0, [pc, #28]	; (c0d049c0 <check_api_level+0x24>)
c0d049a4:	4669      	mov	r1, sp
  retid = SVC_Call(SYSCALL_check_api_level_ID_IN, parameters);
c0d049a6:	f7ff fff7 	bl	c0d04998 <SVC_Call>
c0d049aa:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d049ac:	6011      	str	r1, [r2, #0]
c0d049ae:	4905      	ldr	r1, [pc, #20]	; (c0d049c4 <check_api_level+0x28>)
  if (retid != SYSCALL_check_api_level_ID_OUT) {
c0d049b0:	4288      	cmp	r0, r1
c0d049b2:	d101      	bne.n	c0d049b8 <check_api_level+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d049b4:	b002      	add	sp, #8
c0d049b6:	bd80      	pop	{r7, pc}
c0d049b8:	2004      	movs	r0, #4
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)apiLevel;
  retid = SVC_Call(SYSCALL_check_api_level_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_check_api_level_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d049ba:	f7ff f9b9 	bl	c0d03d30 <os_longjmp>
c0d049be:	46c0      	nop			; (mov r8, r8)
c0d049c0:	60000137 	.word	0x60000137
c0d049c4:	900001c6 	.word	0x900001c6

c0d049c8 <reset>:
  }
}

void reset ( void ) 
{
c0d049c8:	b580      	push	{r7, lr}
c0d049ca:	b082      	sub	sp, #8
c0d049cc:	4806      	ldr	r0, [pc, #24]	; (c0d049e8 <reset+0x20>)
c0d049ce:	a901      	add	r1, sp, #4
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_reset_ID_IN, parameters);
c0d049d0:	f7ff ffe2 	bl	c0d04998 <SVC_Call>
c0d049d4:	466a      	mov	r2, sp
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d049d6:	6011      	str	r1, [r2, #0]
c0d049d8:	4904      	ldr	r1, [pc, #16]	; (c0d049ec <reset+0x24>)
  if (retid != SYSCALL_reset_ID_OUT) {
c0d049da:	4288      	cmp	r0, r1
c0d049dc:	d101      	bne.n	c0d049e2 <reset+0x1a>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d049de:	b002      	add	sp, #8
c0d049e0:	bd80      	pop	{r7, pc}
c0d049e2:	2004      	movs	r0, #4
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_reset_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_reset_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d049e4:	f7ff f9a4 	bl	c0d03d30 <os_longjmp>
c0d049e8:	60000200 	.word	0x60000200
c0d049ec:	900002f1 	.word	0x900002f1

c0d049f0 <nvm_write>:
  }
}

void nvm_write ( void * dst_adr, void * src_adr, unsigned int src_len ) 
{
c0d049f0:	b580      	push	{r7, lr}
c0d049f2:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+3];
  parameters[0] = (unsigned int)dst_adr;
c0d049f4:	ab00      	add	r3, sp, #0
c0d049f6:	c307      	stmia	r3!, {r0, r1, r2}
c0d049f8:	4806      	ldr	r0, [pc, #24]	; (c0d04a14 <nvm_write+0x24>)
c0d049fa:	4669      	mov	r1, sp
  parameters[1] = (unsigned int)src_adr;
  parameters[2] = (unsigned int)src_len;
  retid = SVC_Call(SYSCALL_nvm_write_ID_IN, parameters);
c0d049fc:	f7ff ffcc 	bl	c0d04998 <SVC_Call>
c0d04a00:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04a02:	6011      	str	r1, [r2, #0]
c0d04a04:	4904      	ldr	r1, [pc, #16]	; (c0d04a18 <nvm_write+0x28>)
  if (retid != SYSCALL_nvm_write_ID_OUT) {
c0d04a06:	4288      	cmp	r0, r1
c0d04a08:	d101      	bne.n	c0d04a0e <nvm_write+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04a0a:	b004      	add	sp, #16
c0d04a0c:	bd80      	pop	{r7, pc}
c0d04a0e:	2004      	movs	r0, #4
  parameters[1] = (unsigned int)src_adr;
  parameters[2] = (unsigned int)src_len;
  retid = SVC_Call(SYSCALL_nvm_write_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_nvm_write_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04a10:	f7ff f98e 	bl	c0d03d30 <os_longjmp>
c0d04a14:	6000037f 	.word	0x6000037f
c0d04a18:	900003bc 	.word	0x900003bc

c0d04a1c <cx_rng>:
  }
  return (unsigned char)ret;
}

unsigned char * cx_rng ( unsigned char * buffer, unsigned int len ) 
{
c0d04a1c:	b580      	push	{r7, lr}
c0d04a1e:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)len;
c0d04a20:	9102      	str	r1, [sp, #8]
unsigned char * cx_rng ( unsigned char * buffer, unsigned int len ) 
{
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)buffer;
c0d04a22:	9001      	str	r0, [sp, #4]
c0d04a24:	4807      	ldr	r0, [pc, #28]	; (c0d04a44 <cx_rng+0x28>)
c0d04a26:	a901      	add	r1, sp, #4
  parameters[1] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_rng_ID_IN, parameters);
c0d04a28:	f7ff ffb6 	bl	c0d04998 <SVC_Call>
c0d04a2c:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04a2e:	6011      	str	r1, [r2, #0]
c0d04a30:	4905      	ldr	r1, [pc, #20]	; (c0d04a48 <cx_rng+0x2c>)
  if (retid != SYSCALL_cx_rng_ID_OUT) {
c0d04a32:	4288      	cmp	r0, r1
c0d04a34:	d102      	bne.n	c0d04a3c <cx_rng+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned char *)ret;
c0d04a36:	9803      	ldr	r0, [sp, #12]
c0d04a38:	b004      	add	sp, #16
c0d04a3a:	bd80      	pop	{r7, pc}
c0d04a3c:	2004      	movs	r0, #4
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_rng_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_rng_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04a3e:	f7ff f977 	bl	c0d03d30 <os_longjmp>
c0d04a42:	46c0      	nop			; (mov r8, r8)
c0d04a44:	6000052c 	.word	0x6000052c
c0d04a48:	90000567 	.word	0x90000567

c0d04a4c <cx_hash>:
  }
  return (int)ret;
}

int cx_hash ( cx_hash_t * hash, int mode, const unsigned char * in, unsigned int len, unsigned char * out, unsigned int out_len ) 
{
c0d04a4c:	b580      	push	{r7, lr}
c0d04a4e:	b088      	sub	sp, #32
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+6];
  parameters[0] = (unsigned int)hash;
c0d04a50:	af01      	add	r7, sp, #4
c0d04a52:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04a54:	980a      	ldr	r0, [sp, #40]	; 0x28
  parameters[1] = (unsigned int)mode;
  parameters[2] = (unsigned int)in;
  parameters[3] = (unsigned int)len;
  parameters[4] = (unsigned int)out;
c0d04a56:	9005      	str	r0, [sp, #20]
c0d04a58:	980b      	ldr	r0, [sp, #44]	; 0x2c
  parameters[5] = (unsigned int)out_len;
c0d04a5a:	9006      	str	r0, [sp, #24]
c0d04a5c:	4807      	ldr	r0, [pc, #28]	; (c0d04a7c <cx_hash+0x30>)
c0d04a5e:	a901      	add	r1, sp, #4
  retid = SVC_Call(SYSCALL_cx_hash_ID_IN, parameters);
c0d04a60:	f7ff ff9a 	bl	c0d04998 <SVC_Call>
c0d04a64:	aa07      	add	r2, sp, #28
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04a66:	6011      	str	r1, [r2, #0]
c0d04a68:	4905      	ldr	r1, [pc, #20]	; (c0d04a80 <cx_hash+0x34>)
  if (retid != SYSCALL_cx_hash_ID_OUT) {
c0d04a6a:	4288      	cmp	r0, r1
c0d04a6c:	d102      	bne.n	c0d04a74 <cx_hash+0x28>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d04a6e:	9807      	ldr	r0, [sp, #28]
c0d04a70:	b008      	add	sp, #32
c0d04a72:	bd80      	pop	{r7, pc}
c0d04a74:	2004      	movs	r0, #4
  parameters[4] = (unsigned int)out;
  parameters[5] = (unsigned int)out_len;
  retid = SVC_Call(SYSCALL_cx_hash_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_hash_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04a76:	f7ff f95b 	bl	c0d03d30 <os_longjmp>
c0d04a7a:	46c0      	nop			; (mov r8, r8)
c0d04a7c:	6000073b 	.word	0x6000073b
c0d04a80:	900007ad 	.word	0x900007ad

c0d04a84 <cx_sha256_init>:
  }
  return (int)ret;
}

int cx_sha256_init ( cx_sha256_t * hash ) 
{
c0d04a84:	b580      	push	{r7, lr}
c0d04a86:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)hash;
c0d04a88:	9000      	str	r0, [sp, #0]
c0d04a8a:	4807      	ldr	r0, [pc, #28]	; (c0d04aa8 <cx_sha256_init+0x24>)
c0d04a8c:	4669      	mov	r1, sp
  retid = SVC_Call(SYSCALL_cx_sha256_init_ID_IN, parameters);
c0d04a8e:	f7ff ff83 	bl	c0d04998 <SVC_Call>
c0d04a92:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04a94:	6011      	str	r1, [r2, #0]
c0d04a96:	4905      	ldr	r1, [pc, #20]	; (c0d04aac <cx_sha256_init+0x28>)
  if (retid != SYSCALL_cx_sha256_init_ID_OUT) {
c0d04a98:	4288      	cmp	r0, r1
c0d04a9a:	d102      	bne.n	c0d04aa2 <cx_sha256_init+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d04a9c:	9801      	ldr	r0, [sp, #4]
c0d04a9e:	b002      	add	sp, #8
c0d04aa0:	bd80      	pop	{r7, pc}
c0d04aa2:	2004      	movs	r0, #4
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)hash;
  retid = SVC_Call(SYSCALL_cx_sha256_init_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_sha256_init_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04aa4:	f7ff f944 	bl	c0d03d30 <os_longjmp>
c0d04aa8:	60000adb 	.word	0x60000adb
c0d04aac:	90000a64 	.word	0x90000a64

c0d04ab0 <cx_keccak_init>:
  }
  return (int)ret;
}

int cx_keccak_init ( cx_sha3_t * hash, unsigned int size ) 
{
c0d04ab0:	b580      	push	{r7, lr}
c0d04ab2:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)hash;
  parameters[1] = (unsigned int)size;
c0d04ab4:	9102      	str	r1, [sp, #8]
int cx_keccak_init ( cx_sha3_t * hash, unsigned int size ) 
{
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)hash;
c0d04ab6:	9001      	str	r0, [sp, #4]
c0d04ab8:	4807      	ldr	r0, [pc, #28]	; (c0d04ad8 <cx_keccak_init+0x28>)
c0d04aba:	a901      	add	r1, sp, #4
  parameters[1] = (unsigned int)size;
  retid = SVC_Call(SYSCALL_cx_keccak_init_ID_IN, parameters);
c0d04abc:	f7ff ff6c 	bl	c0d04998 <SVC_Call>
c0d04ac0:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04ac2:	6011      	str	r1, [r2, #0]
c0d04ac4:	4905      	ldr	r1, [pc, #20]	; (c0d04adc <cx_keccak_init+0x2c>)
  if (retid != SYSCALL_cx_keccak_init_ID_OUT) {
c0d04ac6:	4288      	cmp	r0, r1
c0d04ac8:	d102      	bne.n	c0d04ad0 <cx_keccak_init+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d04aca:	9803      	ldr	r0, [sp, #12]
c0d04acc:	b004      	add	sp, #16
c0d04ace:	bd80      	pop	{r7, pc}
c0d04ad0:	2004      	movs	r0, #4
  parameters[0] = (unsigned int)hash;
  parameters[1] = (unsigned int)size;
  retid = SVC_Call(SYSCALL_cx_keccak_init_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_keccak_init_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04ad2:	f7ff f92d 	bl	c0d03d30 <os_longjmp>
c0d04ad6:	46c0      	nop			; (mov r8, r8)
c0d04ad8:	600010cf 	.word	0x600010cf
c0d04adc:	900010d8 	.word	0x900010d8

c0d04ae0 <cx_aes_init_key>:
  }
  return (int)ret;
}

int cx_aes_init_key ( const unsigned char * rawkey, unsigned int key_len, cx_aes_key_t * key ) 
{
c0d04ae0:	b580      	push	{r7, lr}
c0d04ae2:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+3];
  parameters[0] = (unsigned int)rawkey;
c0d04ae4:	ab00      	add	r3, sp, #0
c0d04ae6:	c307      	stmia	r3!, {r0, r1, r2}
c0d04ae8:	4807      	ldr	r0, [pc, #28]	; (c0d04b08 <cx_aes_init_key+0x28>)
c0d04aea:	4669      	mov	r1, sp
  parameters[1] = (unsigned int)key_len;
  parameters[2] = (unsigned int)key;
  retid = SVC_Call(SYSCALL_cx_aes_init_key_ID_IN, parameters);
c0d04aec:	f7ff ff54 	bl	c0d04998 <SVC_Call>
c0d04af0:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04af2:	6011      	str	r1, [r2, #0]
c0d04af4:	4905      	ldr	r1, [pc, #20]	; (c0d04b0c <cx_aes_init_key+0x2c>)
  if (retid != SYSCALL_cx_aes_init_key_ID_OUT) {
c0d04af6:	4288      	cmp	r0, r1
c0d04af8:	d102      	bne.n	c0d04b00 <cx_aes_init_key+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d04afa:	9803      	ldr	r0, [sp, #12]
c0d04afc:	b004      	add	sp, #16
c0d04afe:	bd80      	pop	{r7, pc}
c0d04b00:	2004      	movs	r0, #4
  parameters[1] = (unsigned int)key_len;
  parameters[2] = (unsigned int)key;
  retid = SVC_Call(SYSCALL_cx_aes_init_key_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_aes_init_key_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04b02:	f7ff f915 	bl	c0d03d30 <os_longjmp>
c0d04b06:	46c0      	nop			; (mov r8, r8)
c0d04b08:	60001f2b 	.word	0x60001f2b
c0d04b0c:	90001f31 	.word	0x90001f31

c0d04b10 <cx_aes>:
  }
  return (int)ret;
}

int cx_aes ( const cx_aes_key_t * key, int mode, const unsigned char * in, unsigned int in_len, unsigned char * out, unsigned int out_len ) 
{
c0d04b10:	b580      	push	{r7, lr}
c0d04b12:	b088      	sub	sp, #32
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+6];
  parameters[0] = (unsigned int)key;
c0d04b14:	af01      	add	r7, sp, #4
c0d04b16:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04b18:	980a      	ldr	r0, [sp, #40]	; 0x28
  parameters[1] = (unsigned int)mode;
  parameters[2] = (unsigned int)in;
  parameters[3] = (unsigned int)in_len;
  parameters[4] = (unsigned int)out;
c0d04b1a:	9005      	str	r0, [sp, #20]
c0d04b1c:	980b      	ldr	r0, [sp, #44]	; 0x2c
  parameters[5] = (unsigned int)out_len;
c0d04b1e:	9006      	str	r0, [sp, #24]
c0d04b20:	4807      	ldr	r0, [pc, #28]	; (c0d04b40 <cx_aes+0x30>)
c0d04b22:	a901      	add	r1, sp, #4
  retid = SVC_Call(SYSCALL_cx_aes_ID_IN, parameters);
c0d04b24:	f7ff ff38 	bl	c0d04998 <SVC_Call>
c0d04b28:	aa07      	add	r2, sp, #28
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04b2a:	6011      	str	r1, [r2, #0]
c0d04b2c:	4905      	ldr	r1, [pc, #20]	; (c0d04b44 <cx_aes+0x34>)
  if (retid != SYSCALL_cx_aes_ID_OUT) {
c0d04b2e:	4288      	cmp	r0, r1
c0d04b30:	d102      	bne.n	c0d04b38 <cx_aes+0x28>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d04b32:	9807      	ldr	r0, [sp, #28]
c0d04b34:	b008      	add	sp, #32
c0d04b36:	bd80      	pop	{r7, pc}
c0d04b38:	2004      	movs	r0, #4
  parameters[4] = (unsigned int)out;
  parameters[5] = (unsigned int)out_len;
  retid = SVC_Call(SYSCALL_cx_aes_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_aes_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04b3a:	f7ff f8f9 	bl	c0d03d30 <os_longjmp>
c0d04b3e:	46c0      	nop			; (mov r8, r8)
c0d04b40:	600021e2 	.word	0x600021e2
c0d04b44:	9000213c 	.word	0x9000213c

c0d04b48 <cx_ecfp_add_point>:
  }
  return (int)ret;
}

int cx_ecfp_add_point ( cx_curve_t curve, unsigned char * R, const unsigned char * P, const unsigned char * Q, unsigned int X_len ) 
{
c0d04b48:	b580      	push	{r7, lr}
c0d04b4a:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+5];
  parameters[0] = (unsigned int)curve;
c0d04b4c:	af00      	add	r7, sp, #0
c0d04b4e:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04b50:	9808      	ldr	r0, [sp, #32]
  parameters[1] = (unsigned int)R;
  parameters[2] = (unsigned int)P;
  parameters[3] = (unsigned int)Q;
  parameters[4] = (unsigned int)X_len;
c0d04b52:	9004      	str	r0, [sp, #16]
c0d04b54:	4807      	ldr	r0, [pc, #28]	; (c0d04b74 <cx_ecfp_add_point+0x2c>)
c0d04b56:	4669      	mov	r1, sp
  retid = SVC_Call(SYSCALL_cx_ecfp_add_point_ID_IN, parameters);
c0d04b58:	f7ff ff1e 	bl	c0d04998 <SVC_Call>
c0d04b5c:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04b5e:	6011      	str	r1, [r2, #0]
c0d04b60:	4905      	ldr	r1, [pc, #20]	; (c0d04b78 <cx_ecfp_add_point+0x30>)
  if (retid != SYSCALL_cx_ecfp_add_point_ID_OUT) {
c0d04b62:	4288      	cmp	r0, r1
c0d04b64:	d102      	bne.n	c0d04b6c <cx_ecfp_add_point+0x24>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d04b66:	9805      	ldr	r0, [sp, #20]
c0d04b68:	b006      	add	sp, #24
c0d04b6a:	bd80      	pop	{r7, pc}
c0d04b6c:	2004      	movs	r0, #4
  parameters[3] = (unsigned int)Q;
  parameters[4] = (unsigned int)X_len;
  retid = SVC_Call(SYSCALL_cx_ecfp_add_point_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ecfp_add_point_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04b6e:	f7ff f8df 	bl	c0d03d30 <os_longjmp>
c0d04b72:	46c0      	nop			; (mov r8, r8)
c0d04b74:	60002b17 	.word	0x60002b17
c0d04b78:	90002bc7 	.word	0x90002bc7

c0d04b7c <cx_ecfp_scalar_mult>:
  }
  return (int)ret;
}

int cx_ecfp_scalar_mult ( cx_curve_t curve, unsigned char * P, unsigned int P_len, const unsigned char * k, unsigned int k_len ) 
{
c0d04b7c:	b580      	push	{r7, lr}
c0d04b7e:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+5];
  parameters[0] = (unsigned int)curve;
c0d04b80:	af00      	add	r7, sp, #0
c0d04b82:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04b84:	9808      	ldr	r0, [sp, #32]
  parameters[1] = (unsigned int)P;
  parameters[2] = (unsigned int)P_len;
  parameters[3] = (unsigned int)k;
  parameters[4] = (unsigned int)k_len;
c0d04b86:	9004      	str	r0, [sp, #16]
c0d04b88:	4807      	ldr	r0, [pc, #28]	; (c0d04ba8 <cx_ecfp_scalar_mult+0x2c>)
c0d04b8a:	4669      	mov	r1, sp
  retid = SVC_Call(SYSCALL_cx_ecfp_scalar_mult_ID_IN, parameters);
c0d04b8c:	f7ff ff04 	bl	c0d04998 <SVC_Call>
c0d04b90:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04b92:	6011      	str	r1, [r2, #0]
c0d04b94:	4905      	ldr	r1, [pc, #20]	; (c0d04bac <cx_ecfp_scalar_mult+0x30>)
  if (retid != SYSCALL_cx_ecfp_scalar_mult_ID_OUT) {
c0d04b96:	4288      	cmp	r0, r1
c0d04b98:	d102      	bne.n	c0d04ba0 <cx_ecfp_scalar_mult+0x24>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d04b9a:	9805      	ldr	r0, [sp, #20]
c0d04b9c:	b006      	add	sp, #24
c0d04b9e:	bd80      	pop	{r7, pc}
c0d04ba0:	2004      	movs	r0, #4
  parameters[3] = (unsigned int)k;
  parameters[4] = (unsigned int)k_len;
  retid = SVC_Call(SYSCALL_cx_ecfp_scalar_mult_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ecfp_scalar_mult_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04ba2:	f7ff f8c5 	bl	c0d03d30 <os_longjmp>
c0d04ba6:	46c0      	nop			; (mov r8, r8)
c0d04ba8:	60002cf3 	.word	0x60002cf3
c0d04bac:	90002ce3 	.word	0x90002ce3

c0d04bb0 <cx_edward_compress_point>:
  }
  return (int)ret;
}

void cx_edward_compress_point ( cx_curve_t curve, unsigned char * P, unsigned int P_len ) 
{
c0d04bb0:	b580      	push	{r7, lr}
c0d04bb2:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+3];
  parameters[0] = (unsigned int)curve;
c0d04bb4:	ab00      	add	r3, sp, #0
c0d04bb6:	c307      	stmia	r3!, {r0, r1, r2}
c0d04bb8:	4806      	ldr	r0, [pc, #24]	; (c0d04bd4 <cx_edward_compress_point+0x24>)
c0d04bba:	4669      	mov	r1, sp
  parameters[1] = (unsigned int)P;
  parameters[2] = (unsigned int)P_len;
  retid = SVC_Call(SYSCALL_cx_edward_compress_point_ID_IN, parameters);
c0d04bbc:	f7ff feec 	bl	c0d04998 <SVC_Call>
c0d04bc0:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04bc2:	6011      	str	r1, [r2, #0]
c0d04bc4:	4904      	ldr	r1, [pc, #16]	; (c0d04bd8 <cx_edward_compress_point+0x28>)
  if (retid != SYSCALL_cx_edward_compress_point_ID_OUT) {
c0d04bc6:	4288      	cmp	r0, r1
c0d04bc8:	d101      	bne.n	c0d04bce <cx_edward_compress_point+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04bca:	b004      	add	sp, #16
c0d04bcc:	bd80      	pop	{r7, pc}
c0d04bce:	2004      	movs	r0, #4
  parameters[1] = (unsigned int)P;
  parameters[2] = (unsigned int)P_len;
  retid = SVC_Call(SYSCALL_cx_edward_compress_point_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_edward_compress_point_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04bd0:	f7ff f8ae 	bl	c0d03d30 <os_longjmp>
c0d04bd4:	60003359 	.word	0x60003359
c0d04bd8:	9000332b 	.word	0x9000332b

c0d04bdc <cx_edward_decompress_point>:
  }
}

void cx_edward_decompress_point ( cx_curve_t curve, unsigned char * P, unsigned int P_len ) 
{
c0d04bdc:	b580      	push	{r7, lr}
c0d04bde:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+3];
  parameters[0] = (unsigned int)curve;
c0d04be0:	ab00      	add	r3, sp, #0
c0d04be2:	c307      	stmia	r3!, {r0, r1, r2}
c0d04be4:	4806      	ldr	r0, [pc, #24]	; (c0d04c00 <cx_edward_decompress_point+0x24>)
c0d04be6:	4669      	mov	r1, sp
  parameters[1] = (unsigned int)P;
  parameters[2] = (unsigned int)P_len;
  retid = SVC_Call(SYSCALL_cx_edward_decompress_point_ID_IN, parameters);
c0d04be8:	f7ff fed6 	bl	c0d04998 <SVC_Call>
c0d04bec:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04bee:	6011      	str	r1, [r2, #0]
c0d04bf0:	4904      	ldr	r1, [pc, #16]	; (c0d04c04 <cx_edward_decompress_point+0x28>)
  if (retid != SYSCALL_cx_edward_decompress_point_ID_OUT) {
c0d04bf2:	4288      	cmp	r0, r1
c0d04bf4:	d101      	bne.n	c0d04bfa <cx_edward_decompress_point+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04bf6:	b004      	add	sp, #16
c0d04bf8:	bd80      	pop	{r7, pc}
c0d04bfa:	2004      	movs	r0, #4
  parameters[1] = (unsigned int)P;
  parameters[2] = (unsigned int)P_len;
  retid = SVC_Call(SYSCALL_cx_edward_decompress_point_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_edward_decompress_point_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04bfc:	f7ff f898 	bl	c0d03d30 <os_longjmp>
c0d04c00:	60003431 	.word	0x60003431
c0d04c04:	900034ca 	.word	0x900034ca

c0d04c08 <cx_math_is_zero>:
  }
  return (int)ret;
}

int cx_math_is_zero ( const unsigned char * a, unsigned int len ) 
{
c0d04c08:	b580      	push	{r7, lr}
c0d04c0a:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)a;
  parameters[1] = (unsigned int)len;
c0d04c0c:	9102      	str	r1, [sp, #8]
int cx_math_is_zero ( const unsigned char * a, unsigned int len ) 
{
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)a;
c0d04c0e:	9001      	str	r0, [sp, #4]
c0d04c10:	4807      	ldr	r0, [pc, #28]	; (c0d04c30 <cx_math_is_zero+0x28>)
c0d04c12:	a901      	add	r1, sp, #4
  parameters[1] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_math_is_zero_ID_IN, parameters);
c0d04c14:	f7ff fec0 	bl	c0d04998 <SVC_Call>
c0d04c18:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04c1a:	6011      	str	r1, [r2, #0]
c0d04c1c:	4905      	ldr	r1, [pc, #20]	; (c0d04c34 <cx_math_is_zero+0x2c>)
  if (retid != SYSCALL_cx_math_is_zero_ID_OUT) {
c0d04c1e:	4288      	cmp	r0, r1
c0d04c20:	d102      	bne.n	c0d04c28 <cx_math_is_zero+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d04c22:	9803      	ldr	r0, [sp, #12]
c0d04c24:	b004      	add	sp, #16
c0d04c26:	bd80      	pop	{r7, pc}
c0d04c28:	2004      	movs	r0, #4
  parameters[0] = (unsigned int)a;
  parameters[1] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_math_is_zero_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_math_is_zero_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04c2a:	f7ff f881 	bl	c0d03d30 <os_longjmp>
c0d04c2e:	46c0      	nop			; (mov r8, r8)
c0d04c30:	60003e37 	.word	0x60003e37
c0d04c34:	90003e50 	.word	0x90003e50

c0d04c38 <cx_math_sub>:
  }
  return (int)ret;
}

int cx_math_sub ( unsigned char * r, const unsigned char * a, const unsigned char * b, unsigned int len ) 
{
c0d04c38:	b580      	push	{r7, lr}
c0d04c3a:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+4];
  parameters[0] = (unsigned int)r;
c0d04c3c:	af01      	add	r7, sp, #4
c0d04c3e:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04c40:	4807      	ldr	r0, [pc, #28]	; (c0d04c60 <cx_math_sub+0x28>)
c0d04c42:	a901      	add	r1, sp, #4
  parameters[1] = (unsigned int)a;
  parameters[2] = (unsigned int)b;
  parameters[3] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_math_sub_ID_IN, parameters);
c0d04c44:	f7ff fea8 	bl	c0d04998 <SVC_Call>
c0d04c48:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04c4a:	6011      	str	r1, [r2, #0]
c0d04c4c:	4905      	ldr	r1, [pc, #20]	; (c0d04c64 <cx_math_sub+0x2c>)
  if (retid != SYSCALL_cx_math_sub_ID_OUT) {
c0d04c4e:	4288      	cmp	r0, r1
c0d04c50:	d102      	bne.n	c0d04c58 <cx_math_sub+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d04c52:	9805      	ldr	r0, [sp, #20]
c0d04c54:	b006      	add	sp, #24
c0d04c56:	bd80      	pop	{r7, pc}
c0d04c58:	2004      	movs	r0, #4
  parameters[2] = (unsigned int)b;
  parameters[3] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_math_sub_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_math_sub_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04c5a:	f7ff f869 	bl	c0d03d30 <os_longjmp>
c0d04c5e:	46c0      	nop			; (mov r8, r8)
c0d04c60:	6000409f 	.word	0x6000409f
c0d04c64:	9000401d 	.word	0x9000401d

c0d04c68 <cx_math_addm>:
    THROW(EXCEPTION_SECURITY);
  }
}

void cx_math_addm ( unsigned char * r, const unsigned char * a, const unsigned char * b, const unsigned char * m, unsigned int len ) 
{
c0d04c68:	b580      	push	{r7, lr}
c0d04c6a:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+5];
  parameters[0] = (unsigned int)r;
c0d04c6c:	af00      	add	r7, sp, #0
c0d04c6e:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04c70:	9808      	ldr	r0, [sp, #32]
  parameters[1] = (unsigned int)a;
  parameters[2] = (unsigned int)b;
  parameters[3] = (unsigned int)m;
  parameters[4] = (unsigned int)len;
c0d04c72:	9004      	str	r0, [sp, #16]
c0d04c74:	4806      	ldr	r0, [pc, #24]	; (c0d04c90 <cx_math_addm+0x28>)
c0d04c76:	4669      	mov	r1, sp
  retid = SVC_Call(SYSCALL_cx_math_addm_ID_IN, parameters);
c0d04c78:	f7ff fe8e 	bl	c0d04998 <SVC_Call>
c0d04c7c:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04c7e:	6011      	str	r1, [r2, #0]
c0d04c80:	4904      	ldr	r1, [pc, #16]	; (c0d04c94 <cx_math_addm+0x2c>)
  if (retid != SYSCALL_cx_math_addm_ID_OUT) {
c0d04c82:	4288      	cmp	r0, r1
c0d04c84:	d101      	bne.n	c0d04c8a <cx_math_addm+0x22>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04c86:	b006      	add	sp, #24
c0d04c88:	bd80      	pop	{r7, pc}
c0d04c8a:	2004      	movs	r0, #4
  parameters[3] = (unsigned int)m;
  parameters[4] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_math_addm_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_math_addm_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04c8c:	f7ff f850 	bl	c0d03d30 <os_longjmp>
c0d04c90:	600042a6 	.word	0x600042a6
c0d04c94:	90004248 	.word	0x90004248

c0d04c98 <cx_math_subm>:
  }
}

void cx_math_subm ( unsigned char * r, const unsigned char * a, const unsigned char * b, const unsigned char * m, unsigned int len ) 
{
c0d04c98:	b580      	push	{r7, lr}
c0d04c9a:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+5];
  parameters[0] = (unsigned int)r;
c0d04c9c:	af00      	add	r7, sp, #0
c0d04c9e:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04ca0:	9808      	ldr	r0, [sp, #32]
  parameters[1] = (unsigned int)a;
  parameters[2] = (unsigned int)b;
  parameters[3] = (unsigned int)m;
  parameters[4] = (unsigned int)len;
c0d04ca2:	9004      	str	r0, [sp, #16]
c0d04ca4:	4806      	ldr	r0, [pc, #24]	; (c0d04cc0 <cx_math_subm+0x28>)
c0d04ca6:	4669      	mov	r1, sp
  retid = SVC_Call(SYSCALL_cx_math_subm_ID_IN, parameters);
c0d04ca8:	f7ff fe76 	bl	c0d04998 <SVC_Call>
c0d04cac:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04cae:	6011      	str	r1, [r2, #0]
c0d04cb0:	4904      	ldr	r1, [pc, #16]	; (c0d04cc4 <cx_math_subm+0x2c>)
  if (retid != SYSCALL_cx_math_subm_ID_OUT) {
c0d04cb2:	4288      	cmp	r0, r1
c0d04cb4:	d101      	bne.n	c0d04cba <cx_math_subm+0x22>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04cb6:	b006      	add	sp, #24
c0d04cb8:	bd80      	pop	{r7, pc}
c0d04cba:	2004      	movs	r0, #4
  parameters[3] = (unsigned int)m;
  parameters[4] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_math_subm_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_math_subm_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04cbc:	f7ff f838 	bl	c0d03d30 <os_longjmp>
c0d04cc0:	6000437d 	.word	0x6000437d
c0d04cc4:	900043e0 	.word	0x900043e0

c0d04cc8 <cx_math_multm>:
  }
}

void cx_math_multm ( unsigned char * r, const unsigned char * a, const unsigned char * b, const unsigned char * m, unsigned int len ) 
{
c0d04cc8:	b580      	push	{r7, lr}
c0d04cca:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+5];
  parameters[0] = (unsigned int)r;
c0d04ccc:	af00      	add	r7, sp, #0
c0d04cce:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04cd0:	9808      	ldr	r0, [sp, #32]
  parameters[1] = (unsigned int)a;
  parameters[2] = (unsigned int)b;
  parameters[3] = (unsigned int)m;
  parameters[4] = (unsigned int)len;
c0d04cd2:	9004      	str	r0, [sp, #16]
c0d04cd4:	4806      	ldr	r0, [pc, #24]	; (c0d04cf0 <cx_math_multm+0x28>)
c0d04cd6:	4669      	mov	r1, sp
  retid = SVC_Call(SYSCALL_cx_math_multm_ID_IN, parameters);
c0d04cd8:	f7ff fe5e 	bl	c0d04998 <SVC_Call>
c0d04cdc:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04cde:	6011      	str	r1, [r2, #0]
c0d04ce0:	4904      	ldr	r1, [pc, #16]	; (c0d04cf4 <cx_math_multm+0x2c>)
  if (retid != SYSCALL_cx_math_multm_ID_OUT) {
c0d04ce2:	4288      	cmp	r0, r1
c0d04ce4:	d101      	bne.n	c0d04cea <cx_math_multm+0x22>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04ce6:	b006      	add	sp, #24
c0d04ce8:	bd80      	pop	{r7, pc}
c0d04cea:	2004      	movs	r0, #4
  parameters[3] = (unsigned int)m;
  parameters[4] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_math_multm_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_math_multm_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04cec:	f7ff f820 	bl	c0d03d30 <os_longjmp>
c0d04cf0:	60004445 	.word	0x60004445
c0d04cf4:	900044f3 	.word	0x900044f3

c0d04cf8 <cx_math_powm>:
  }
}

void cx_math_powm ( unsigned char * r, const unsigned char * a, const unsigned char * e, unsigned int len_e, const unsigned char * m, unsigned int len ) 
{
c0d04cf8:	b580      	push	{r7, lr}
c0d04cfa:	b088      	sub	sp, #32
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+6];
  parameters[0] = (unsigned int)r;
c0d04cfc:	af01      	add	r7, sp, #4
c0d04cfe:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04d00:	980a      	ldr	r0, [sp, #40]	; 0x28
  parameters[1] = (unsigned int)a;
  parameters[2] = (unsigned int)e;
  parameters[3] = (unsigned int)len_e;
  parameters[4] = (unsigned int)m;
c0d04d02:	9005      	str	r0, [sp, #20]
c0d04d04:	980b      	ldr	r0, [sp, #44]	; 0x2c
  parameters[5] = (unsigned int)len;
c0d04d06:	9006      	str	r0, [sp, #24]
c0d04d08:	4806      	ldr	r0, [pc, #24]	; (c0d04d24 <cx_math_powm+0x2c>)
c0d04d0a:	a901      	add	r1, sp, #4
  retid = SVC_Call(SYSCALL_cx_math_powm_ID_IN, parameters);
c0d04d0c:	f7ff fe44 	bl	c0d04998 <SVC_Call>
c0d04d10:	aa07      	add	r2, sp, #28
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04d12:	6011      	str	r1, [r2, #0]
c0d04d14:	4904      	ldr	r1, [pc, #16]	; (c0d04d28 <cx_math_powm+0x30>)
  if (retid != SYSCALL_cx_math_powm_ID_OUT) {
c0d04d16:	4288      	cmp	r0, r1
c0d04d18:	d101      	bne.n	c0d04d1e <cx_math_powm+0x26>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04d1a:	b008      	add	sp, #32
c0d04d1c:	bd80      	pop	{r7, pc}
c0d04d1e:	2004      	movs	r0, #4
  parameters[4] = (unsigned int)m;
  parameters[5] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_math_powm_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_math_powm_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04d20:	f7ff f806 	bl	c0d03d30 <os_longjmp>
c0d04d24:	6000454d 	.word	0x6000454d
c0d04d28:	9000453e 	.word	0x9000453e

c0d04d2c <cx_math_modm>:
  }
}

void cx_math_modm ( unsigned char * v, unsigned int len_v, const unsigned char * m, unsigned int len_m ) 
{
c0d04d2c:	b580      	push	{r7, lr}
c0d04d2e:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+4];
  parameters[0] = (unsigned int)v;
c0d04d30:	af01      	add	r7, sp, #4
c0d04d32:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04d34:	4806      	ldr	r0, [pc, #24]	; (c0d04d50 <cx_math_modm+0x24>)
c0d04d36:	a901      	add	r1, sp, #4
  parameters[1] = (unsigned int)len_v;
  parameters[2] = (unsigned int)m;
  parameters[3] = (unsigned int)len_m;
  retid = SVC_Call(SYSCALL_cx_math_modm_ID_IN, parameters);
c0d04d38:	f7ff fe2e 	bl	c0d04998 <SVC_Call>
c0d04d3c:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04d3e:	6011      	str	r1, [r2, #0]
c0d04d40:	4904      	ldr	r1, [pc, #16]	; (c0d04d54 <cx_math_modm+0x28>)
  if (retid != SYSCALL_cx_math_modm_ID_OUT) {
c0d04d42:	4288      	cmp	r0, r1
c0d04d44:	d101      	bne.n	c0d04d4a <cx_math_modm+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04d46:	b006      	add	sp, #24
c0d04d48:	bd80      	pop	{r7, pc}
c0d04d4a:	2004      	movs	r0, #4
  parameters[2] = (unsigned int)m;
  parameters[3] = (unsigned int)len_m;
  retid = SVC_Call(SYSCALL_cx_math_modm_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_math_modm_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04d4c:	f7fe fff0 	bl	c0d03d30 <os_longjmp>
c0d04d50:	60004645 	.word	0x60004645
c0d04d54:	9000468c 	.word	0x9000468c

c0d04d58 <cx_math_invprimem>:
  }
}

void cx_math_invprimem ( unsigned char * r, const unsigned char * a, const unsigned char * m, unsigned int len ) 
{
c0d04d58:	b580      	push	{r7, lr}
c0d04d5a:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+4];
  parameters[0] = (unsigned int)r;
c0d04d5c:	af01      	add	r7, sp, #4
c0d04d5e:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04d60:	4806      	ldr	r0, [pc, #24]	; (c0d04d7c <cx_math_invprimem+0x24>)
c0d04d62:	a901      	add	r1, sp, #4
  parameters[1] = (unsigned int)a;
  parameters[2] = (unsigned int)m;
  parameters[3] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_math_invprimem_ID_IN, parameters);
c0d04d64:	f7ff fe18 	bl	c0d04998 <SVC_Call>
c0d04d68:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04d6a:	6011      	str	r1, [r2, #0]
c0d04d6c:	4904      	ldr	r1, [pc, #16]	; (c0d04d80 <cx_math_invprimem+0x28>)
  if (retid != SYSCALL_cx_math_invprimem_ID_OUT) {
c0d04d6e:	4288      	cmp	r0, r1
c0d04d70:	d101      	bne.n	c0d04d76 <cx_math_invprimem+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04d72:	b006      	add	sp, #24
c0d04d74:	bd80      	pop	{r7, pc}
c0d04d76:	2004      	movs	r0, #4
  parameters[2] = (unsigned int)m;
  parameters[3] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_math_invprimem_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_math_invprimem_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04d78:	f7fe ffda 	bl	c0d03d30 <os_longjmp>
c0d04d7c:	600047e9 	.word	0x600047e9
c0d04d80:	90004719 	.word	0x90004719

c0d04d84 <os_perso_derive_node_bip32>:
  }
  return (unsigned int)ret;
}

void os_perso_derive_node_bip32 ( cx_curve_t curve, const unsigned int * path, unsigned int pathLength, unsigned char * privateKey, unsigned char * chain ) 
{
c0d04d84:	b580      	push	{r7, lr}
c0d04d86:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+5];
  parameters[0] = (unsigned int)curve;
c0d04d88:	af00      	add	r7, sp, #0
c0d04d8a:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04d8c:	9808      	ldr	r0, [sp, #32]
  parameters[1] = (unsigned int)path;
  parameters[2] = (unsigned int)pathLength;
  parameters[3] = (unsigned int)privateKey;
  parameters[4] = (unsigned int)chain;
c0d04d8e:	9004      	str	r0, [sp, #16]
c0d04d90:	4806      	ldr	r0, [pc, #24]	; (c0d04dac <os_perso_derive_node_bip32+0x28>)
c0d04d92:	4669      	mov	r1, sp
  retid = SVC_Call(SYSCALL_os_perso_derive_node_bip32_ID_IN, parameters);
c0d04d94:	f7ff fe00 	bl	c0d04998 <SVC_Call>
c0d04d98:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04d9a:	6011      	str	r1, [r2, #0]
c0d04d9c:	4904      	ldr	r1, [pc, #16]	; (c0d04db0 <os_perso_derive_node_bip32+0x2c>)
  if (retid != SYSCALL_os_perso_derive_node_bip32_ID_OUT) {
c0d04d9e:	4288      	cmp	r0, r1
c0d04da0:	d101      	bne.n	c0d04da6 <os_perso_derive_node_bip32+0x22>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04da2:	b006      	add	sp, #24
c0d04da4:	bd80      	pop	{r7, pc}
c0d04da6:	2004      	movs	r0, #4
  parameters[3] = (unsigned int)privateKey;
  parameters[4] = (unsigned int)chain;
  retid = SVC_Call(SYSCALL_os_perso_derive_node_bip32_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_perso_derive_node_bip32_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04da8:	f7fe ffc2 	bl	c0d03d30 <os_longjmp>
c0d04dac:	600053ba 	.word	0x600053ba
c0d04db0:	9000531e 	.word	0x9000531e

c0d04db4 <os_global_pin_is_validated>:
  }
  return (unsigned int)ret;
}

unsigned int os_global_pin_is_validated ( void ) 
{
c0d04db4:	b580      	push	{r7, lr}
c0d04db6:	b082      	sub	sp, #8
c0d04db8:	4807      	ldr	r0, [pc, #28]	; (c0d04dd8 <os_global_pin_is_validated+0x24>)
c0d04dba:	a901      	add	r1, sp, #4
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_os_global_pin_is_validated_ID_IN, parameters);
c0d04dbc:	f7ff fdec 	bl	c0d04998 <SVC_Call>
c0d04dc0:	466a      	mov	r2, sp
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04dc2:	6011      	str	r1, [r2, #0]
c0d04dc4:	4905      	ldr	r1, [pc, #20]	; (c0d04ddc <os_global_pin_is_validated+0x28>)
  if (retid != SYSCALL_os_global_pin_is_validated_ID_OUT) {
c0d04dc6:	4288      	cmp	r0, r1
c0d04dc8:	d102      	bne.n	c0d04dd0 <os_global_pin_is_validated+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d04dca:	9800      	ldr	r0, [sp, #0]
c0d04dcc:	b002      	add	sp, #8
c0d04dce:	bd80      	pop	{r7, pc}
c0d04dd0:	2004      	movs	r0, #4
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_os_global_pin_is_validated_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_global_pin_is_validated_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04dd2:	f7fe ffad 	bl	c0d03d30 <os_longjmp>
c0d04dd6:	46c0      	nop			; (mov r8, r8)
c0d04dd8:	60005b89 	.word	0x60005b89
c0d04ddc:	90005b45 	.word	0x90005b45

c0d04de0 <os_sched_exit>:
  }
  return (unsigned int)ret;
}

void os_sched_exit ( unsigned int exit_code ) 
{
c0d04de0:	b580      	push	{r7, lr}
c0d04de2:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)exit_code;
c0d04de4:	9000      	str	r0, [sp, #0]
c0d04de6:	4807      	ldr	r0, [pc, #28]	; (c0d04e04 <os_sched_exit+0x24>)
c0d04de8:	4669      	mov	r1, sp
  retid = SVC_Call(SYSCALL_os_sched_exit_ID_IN, parameters);
c0d04dea:	f7ff fdd5 	bl	c0d04998 <SVC_Call>
c0d04dee:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04df0:	6011      	str	r1, [r2, #0]
c0d04df2:	4905      	ldr	r1, [pc, #20]	; (c0d04e08 <os_sched_exit+0x28>)
  if (retid != SYSCALL_os_sched_exit_ID_OUT) {
c0d04df4:	4288      	cmp	r0, r1
c0d04df6:	d101      	bne.n	c0d04dfc <os_sched_exit+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04df8:	b002      	add	sp, #8
c0d04dfa:	bd80      	pop	{r7, pc}
c0d04dfc:	2004      	movs	r0, #4
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)exit_code;
  retid = SVC_Call(SYSCALL_os_sched_exit_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_sched_exit_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04dfe:	f7fe ff97 	bl	c0d03d30 <os_longjmp>
c0d04e02:	46c0      	nop			; (mov r8, r8)
c0d04e04:	600062e1 	.word	0x600062e1
c0d04e08:	9000626f 	.word	0x9000626f

c0d04e0c <os_ux>:
    THROW(EXCEPTION_SECURITY);
  }
}

unsigned int os_ux ( bolos_ux_params_t * params ) 
{
c0d04e0c:	b580      	push	{r7, lr}
c0d04e0e:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)params;
c0d04e10:	9000      	str	r0, [sp, #0]
c0d04e12:	4807      	ldr	r0, [pc, #28]	; (c0d04e30 <os_ux+0x24>)
c0d04e14:	4669      	mov	r1, sp
  retid = SVC_Call(SYSCALL_os_ux_ID_IN, parameters);
c0d04e16:	f7ff fdbf 	bl	c0d04998 <SVC_Call>
c0d04e1a:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04e1c:	6011      	str	r1, [r2, #0]
c0d04e1e:	4905      	ldr	r1, [pc, #20]	; (c0d04e34 <os_ux+0x28>)
  if (retid != SYSCALL_os_ux_ID_OUT) {
c0d04e20:	4288      	cmp	r0, r1
c0d04e22:	d102      	bne.n	c0d04e2a <os_ux+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d04e24:	9801      	ldr	r0, [sp, #4]
c0d04e26:	b002      	add	sp, #8
c0d04e28:	bd80      	pop	{r7, pc}
c0d04e2a:	2004      	movs	r0, #4
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)params;
  retid = SVC_Call(SYSCALL_os_ux_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_ux_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04e2c:	f7fe ff80 	bl	c0d03d30 <os_longjmp>
c0d04e30:	60006458 	.word	0x60006458
c0d04e34:	9000641f 	.word	0x9000641f

c0d04e38 <os_flags>:
    THROW(EXCEPTION_SECURITY);
  }
}

unsigned int os_flags ( void ) 
{
c0d04e38:	b580      	push	{r7, lr}
c0d04e3a:	b082      	sub	sp, #8
c0d04e3c:	4807      	ldr	r0, [pc, #28]	; (c0d04e5c <os_flags+0x24>)
c0d04e3e:	a901      	add	r1, sp, #4
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_os_flags_ID_IN, parameters);
c0d04e40:	f7ff fdaa 	bl	c0d04998 <SVC_Call>
c0d04e44:	466a      	mov	r2, sp
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04e46:	6011      	str	r1, [r2, #0]
c0d04e48:	4905      	ldr	r1, [pc, #20]	; (c0d04e60 <os_flags+0x28>)
  if (retid != SYSCALL_os_flags_ID_OUT) {
c0d04e4a:	4288      	cmp	r0, r1
c0d04e4c:	d102      	bne.n	c0d04e54 <os_flags+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d04e4e:	9800      	ldr	r0, [sp, #0]
c0d04e50:	b002      	add	sp, #8
c0d04e52:	bd80      	pop	{r7, pc}
c0d04e54:	2004      	movs	r0, #4
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_os_flags_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_flags_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04e56:	f7fe ff6b 	bl	c0d03d30 <os_longjmp>
c0d04e5a:	46c0      	nop			; (mov r8, r8)
c0d04e5c:	6000686e 	.word	0x6000686e
c0d04e60:	9000687f 	.word	0x9000687f

c0d04e64 <os_registry_get_current_app_tag>:
  }
  return (unsigned int)ret;
}

unsigned int os_registry_get_current_app_tag ( unsigned int tag, unsigned char * buffer, unsigned int maxlen ) 
{
c0d04e64:	b580      	push	{r7, lr}
c0d04e66:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+3];
  parameters[0] = (unsigned int)tag;
c0d04e68:	ab00      	add	r3, sp, #0
c0d04e6a:	c307      	stmia	r3!, {r0, r1, r2}
c0d04e6c:	4807      	ldr	r0, [pc, #28]	; (c0d04e8c <os_registry_get_current_app_tag+0x28>)
c0d04e6e:	4669      	mov	r1, sp
  parameters[1] = (unsigned int)buffer;
  parameters[2] = (unsigned int)maxlen;
  retid = SVC_Call(SYSCALL_os_registry_get_current_app_tag_ID_IN, parameters);
c0d04e70:	f7ff fd92 	bl	c0d04998 <SVC_Call>
c0d04e74:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04e76:	6011      	str	r1, [r2, #0]
c0d04e78:	4905      	ldr	r1, [pc, #20]	; (c0d04e90 <os_registry_get_current_app_tag+0x2c>)
  if (retid != SYSCALL_os_registry_get_current_app_tag_ID_OUT) {
c0d04e7a:	4288      	cmp	r0, r1
c0d04e7c:	d102      	bne.n	c0d04e84 <os_registry_get_current_app_tag+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d04e7e:	9803      	ldr	r0, [sp, #12]
c0d04e80:	b004      	add	sp, #16
c0d04e82:	bd80      	pop	{r7, pc}
c0d04e84:	2004      	movs	r0, #4
  parameters[1] = (unsigned int)buffer;
  parameters[2] = (unsigned int)maxlen;
  retid = SVC_Call(SYSCALL_os_registry_get_current_app_tag_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_registry_get_current_app_tag_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04e86:	f7fe ff53 	bl	c0d03d30 <os_longjmp>
c0d04e8a:	46c0      	nop			; (mov r8, r8)
c0d04e8c:	600070d4 	.word	0x600070d4
c0d04e90:	90007087 	.word	0x90007087

c0d04e94 <io_seproxyhal_spi_send>:
  }
  return (unsigned int)ret;
}

void io_seproxyhal_spi_send ( const unsigned char * buffer, unsigned short length ) 
{
c0d04e94:	b580      	push	{r7, lr}
c0d04e96:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)length;
c0d04e98:	9102      	str	r1, [sp, #8]
void io_seproxyhal_spi_send ( const unsigned char * buffer, unsigned short length ) 
{
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)buffer;
c0d04e9a:	9001      	str	r0, [sp, #4]
c0d04e9c:	4806      	ldr	r0, [pc, #24]	; (c0d04eb8 <io_seproxyhal_spi_send+0x24>)
c0d04e9e:	a901      	add	r1, sp, #4
  parameters[1] = (unsigned int)length;
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_send_ID_IN, parameters);
c0d04ea0:	f7ff fd7a 	bl	c0d04998 <SVC_Call>
c0d04ea4:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04ea6:	6011      	str	r1, [r2, #0]
c0d04ea8:	4904      	ldr	r1, [pc, #16]	; (c0d04ebc <io_seproxyhal_spi_send+0x28>)
  if (retid != SYSCALL_io_seproxyhal_spi_send_ID_OUT) {
c0d04eaa:	4288      	cmp	r0, r1
c0d04eac:	d101      	bne.n	c0d04eb2 <io_seproxyhal_spi_send+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04eae:	b004      	add	sp, #16
c0d04eb0:	bd80      	pop	{r7, pc}
c0d04eb2:	2004      	movs	r0, #4
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)length;
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_send_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_io_seproxyhal_spi_send_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04eb4:	f7fe ff3c 	bl	c0d03d30 <os_longjmp>
c0d04eb8:	6000721c 	.word	0x6000721c
c0d04ebc:	900072f3 	.word	0x900072f3

c0d04ec0 <io_seproxyhal_spi_is_status_sent>:
  }
}

unsigned int io_seproxyhal_spi_is_status_sent ( void ) 
{
c0d04ec0:	b580      	push	{r7, lr}
c0d04ec2:	b082      	sub	sp, #8
c0d04ec4:	4807      	ldr	r0, [pc, #28]	; (c0d04ee4 <io_seproxyhal_spi_is_status_sent+0x24>)
c0d04ec6:	a901      	add	r1, sp, #4
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_is_status_sent_ID_IN, parameters);
c0d04ec8:	f7ff fd66 	bl	c0d04998 <SVC_Call>
c0d04ecc:	466a      	mov	r2, sp
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04ece:	6011      	str	r1, [r2, #0]
c0d04ed0:	4905      	ldr	r1, [pc, #20]	; (c0d04ee8 <io_seproxyhal_spi_is_status_sent+0x28>)
  if (retid != SYSCALL_io_seproxyhal_spi_is_status_sent_ID_OUT) {
c0d04ed2:	4288      	cmp	r0, r1
c0d04ed4:	d102      	bne.n	c0d04edc <io_seproxyhal_spi_is_status_sent+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d04ed6:	9800      	ldr	r0, [sp, #0]
c0d04ed8:	b002      	add	sp, #8
c0d04eda:	bd80      	pop	{r7, pc}
c0d04edc:	2004      	movs	r0, #4
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_is_status_sent_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_io_seproxyhal_spi_is_status_sent_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04ede:	f7fe ff27 	bl	c0d03d30 <os_longjmp>
c0d04ee2:	46c0      	nop			; (mov r8, r8)
c0d04ee4:	600073cf 	.word	0x600073cf
c0d04ee8:	9000737f 	.word	0x9000737f

c0d04eec <io_seproxyhal_spi_recv>:
  }
  return (unsigned int)ret;
}

unsigned short io_seproxyhal_spi_recv ( unsigned char * buffer, unsigned short maxlength, unsigned int flags ) 
{
c0d04eec:	b580      	push	{r7, lr}
c0d04eee:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+3];
  parameters[0] = (unsigned int)buffer;
c0d04ef0:	ab00      	add	r3, sp, #0
c0d04ef2:	c307      	stmia	r3!, {r0, r1, r2}
c0d04ef4:	4807      	ldr	r0, [pc, #28]	; (c0d04f14 <io_seproxyhal_spi_recv+0x28>)
c0d04ef6:	4669      	mov	r1, sp
  parameters[1] = (unsigned int)maxlength;
  parameters[2] = (unsigned int)flags;
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_recv_ID_IN, parameters);
c0d04ef8:	f7ff fd4e 	bl	c0d04998 <SVC_Call>
c0d04efc:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04efe:	6011      	str	r1, [r2, #0]
c0d04f00:	4905      	ldr	r1, [pc, #20]	; (c0d04f18 <io_seproxyhal_spi_recv+0x2c>)
  if (retid != SYSCALL_io_seproxyhal_spi_recv_ID_OUT) {
c0d04f02:	4288      	cmp	r0, r1
c0d04f04:	d103      	bne.n	c0d04f0e <io_seproxyhal_spi_recv+0x22>
c0d04f06:	a803      	add	r0, sp, #12
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned short)ret;
c0d04f08:	8800      	ldrh	r0, [r0, #0]
c0d04f0a:	b004      	add	sp, #16
c0d04f0c:	bd80      	pop	{r7, pc}
c0d04f0e:	2004      	movs	r0, #4
  parameters[1] = (unsigned int)maxlength;
  parameters[2] = (unsigned int)flags;
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_recv_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_io_seproxyhal_spi_recv_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04f10:	f7fe ff0e 	bl	c0d03d30 <os_longjmp>
c0d04f14:	600074d1 	.word	0x600074d1
c0d04f18:	9000742b 	.word	0x9000742b

c0d04f1c <u2f_apdu_sign>:

    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)SW_INTERNAL, sizeof(SW_INTERNAL));
}

void u2f_apdu_sign(u2f_service_t *service, uint8_t p1, uint8_t p2,
                     uint8_t *buffer, uint16_t length) {
c0d04f1c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d04f1e:	b081      	sub	sp, #4
c0d04f20:	4604      	mov	r4, r0
    UNUSED(p2);
    uint8_t keyHandleLength;
    uint8_t i;

    // can't process the apdu if another one is already scheduled in
    if (G_io_apdu_state != APDU_IDLE) {
c0d04f22:	4833      	ldr	r0, [pc, #204]	; (c0d04ff0 <u2f_apdu_sign+0xd4>)
c0d04f24:	7800      	ldrb	r0, [r0, #0]
c0d04f26:	2800      	cmp	r0, #0
c0d04f28:	d003      	beq.n	c0d04f32 <u2f_apdu_sign+0x16>
c0d04f2a:	2183      	movs	r1, #131	; 0x83
        u2f_message_reply(service, U2F_CMD_MSG,
c0d04f2c:	4a34      	ldr	r2, [pc, #208]	; (c0d05000 <u2f_apdu_sign+0xe4>)
c0d04f2e:	447a      	add	r2, pc
c0d04f30:	e043      	b.n	c0d04fba <u2f_apdu_sign+0x9e>
c0d04f32:	9806      	ldr	r0, [sp, #24]
                  (uint8_t *)SW_BUSY,
                  sizeof(SW_BUSY));
        return;        
    }

    if (length < U2F_HANDLE_SIGN_HEADER_SIZE + 5 /*at least an apdu header*/) {
c0d04f34:	2845      	cmp	r0, #69	; 0x45
c0d04f36:	d803      	bhi.n	c0d04f40 <u2f_apdu_sign+0x24>
c0d04f38:	2183      	movs	r1, #131	; 0x83
        u2f_message_reply(service, U2F_CMD_MSG,
c0d04f3a:	4a32      	ldr	r2, [pc, #200]	; (c0d05004 <u2f_apdu_sign+0xe8>)
c0d04f3c:	447a      	add	r2, pc
c0d04f3e:	e03c      	b.n	c0d04fba <u2f_apdu_sign+0x9e>
                  sizeof(SW_WRONG_LENGTH));
        return;
    }
    
    // Confirm immediately if it's just a validation call
    if (p1 == P1_SIGN_CHECK_ONLY) {
c0d04f40:	2907      	cmp	r1, #7
c0d04f42:	d103      	bne.n	c0d04f4c <u2f_apdu_sign+0x30>
c0d04f44:	2183      	movs	r1, #131	; 0x83
        u2f_message_reply(service, U2F_CMD_MSG,
c0d04f46:	4a30      	ldr	r2, [pc, #192]	; (c0d05008 <u2f_apdu_sign+0xec>)
c0d04f48:	447a      	add	r2, pc
c0d04f4a:	e036      	b.n	c0d04fba <u2f_apdu_sign+0x9e>
c0d04f4c:	461d      	mov	r5, r3
c0d04f4e:	9000      	str	r0, [sp, #0]
c0d04f50:	2040      	movs	r0, #64	; 0x40
                  sizeof(SW_PROOF_OF_PRESENCE_REQUIRED));
        return;
    }

    // Unwrap magic
    keyHandleLength = buffer[U2F_HANDLE_SIGN_HEADER_SIZE-1];
c0d04f52:	5c1e      	ldrb	r6, [r3, r0]
    
    // reply to the "get magic" question of the host
    if (keyHandleLength == 5) {
c0d04f54:	2e00      	cmp	r6, #0
c0d04f56:	d018      	beq.n	c0d04f8a <u2f_apdu_sign+0x6e>
c0d04f58:	2e05      	cmp	r6, #5
c0d04f5a:	d108      	bne.n	c0d04f6e <u2f_apdu_sign+0x52>
        // GET U2F PROXY PARAMETERS
        // this apdu is not subject to proxy magic masking
        // APDU is F1 D0 00 00 00 to get the magic proxy
        // RAPDU: <>
        if (os_memcmp(buffer+U2F_HANDLE_SIGN_HEADER_SIZE, "\xF1\xD0\x00\x00\x00", 5) == 0 ) {
c0d04f5c:	4628      	mov	r0, r5
c0d04f5e:	3041      	adds	r0, #65	; 0x41
c0d04f60:	492a      	ldr	r1, [pc, #168]	; (c0d0500c <u2f_apdu_sign+0xf0>)
c0d04f62:	4479      	add	r1, pc
c0d04f64:	2205      	movs	r2, #5
c0d04f66:	f7fe fecf 	bl	c0d03d08 <os_memcmp>
c0d04f6a:	2800      	cmp	r0, #0
c0d04f6c:	d02b      	beq.n	c0d04fc6 <u2f_apdu_sign+0xaa>
        }
    }
    

    for (i = 0; i < keyHandleLength; i++) {
        buffer[U2F_HANDLE_SIGN_HEADER_SIZE + i] ^= U2F_PROXY_MAGIC[i % (sizeof(U2F_PROXY_MAGIC)-1)];
c0d04f6e:	4628      	mov	r0, r5
c0d04f70:	3041      	adds	r0, #65	; 0x41
c0d04f72:	2100      	movs	r1, #0
c0d04f74:	4a26      	ldr	r2, [pc, #152]	; (c0d05010 <u2f_apdu_sign+0xf4>)
c0d04f76:	447a      	add	r2, pc
c0d04f78:	5c43      	ldrb	r3, [r0, r1]
c0d04f7a:	2703      	movs	r7, #3
c0d04f7c:	400f      	ands	r7, r1
c0d04f7e:	5dd7      	ldrb	r7, [r2, r7]
c0d04f80:	405f      	eors	r7, r3
c0d04f82:	5447      	strb	r7, [r0, r1]
            return;
        }
    }
    

    for (i = 0; i < keyHandleLength; i++) {
c0d04f84:	1c49      	adds	r1, r1, #1
c0d04f86:	428e      	cmp	r6, r1
c0d04f88:	d1f6      	bne.n	c0d04f78 <u2f_apdu_sign+0x5c>
c0d04f8a:	2045      	movs	r0, #69	; 0x45
        buffer[U2F_HANDLE_SIGN_HEADER_SIZE + i] ^= U2F_PROXY_MAGIC[i % (sizeof(U2F_PROXY_MAGIC)-1)];
    }
    // Check that it looks like an APDU
    if (length != U2F_HANDLE_SIGN_HEADER_SIZE + 5 + buffer[U2F_HANDLE_SIGN_HEADER_SIZE + 4]) {
c0d04f8c:	5c28      	ldrb	r0, [r5, r0]
c0d04f8e:	3046      	adds	r0, #70	; 0x46
c0d04f90:	9900      	ldr	r1, [sp, #0]
c0d04f92:	4288      	cmp	r0, r1
c0d04f94:	d10e      	bne.n	c0d04fb4 <u2f_apdu_sign+0x98>
                  sizeof(SW_BAD_KEY_HANDLE));
        return;
    }

    // make the apdu available to higher layers
    os_memmove(G_io_apdu_buffer, buffer + U2F_HANDLE_SIGN_HEADER_SIZE, keyHandleLength);
c0d04f96:	3541      	adds	r5, #65	; 0x41
c0d04f98:	4816      	ldr	r0, [pc, #88]	; (c0d04ff4 <u2f_apdu_sign+0xd8>)
c0d04f9a:	4629      	mov	r1, r5
c0d04f9c:	4632      	mov	r2, r6
c0d04f9e:	f7fe fdf8 	bl	c0d03b92 <os_memmove>
    G_io_apdu_length = keyHandleLength;
c0d04fa2:	4815      	ldr	r0, [pc, #84]	; (c0d04ff8 <u2f_apdu_sign+0xdc>)
c0d04fa4:	8006      	strh	r6, [r0, #0]
    G_io_apdu_media = IO_APDU_MEDIA_U2F; // the effective transport is managed by the U2F layer
c0d04fa6:	4815      	ldr	r0, [pc, #84]	; (c0d04ffc <u2f_apdu_sign+0xe0>)
c0d04fa8:	2107      	movs	r1, #7
c0d04faa:	7001      	strb	r1, [r0, #0]
c0d04fac:	2009      	movs	r0, #9
    G_io_apdu_state = APDU_U2F;
c0d04fae:	4910      	ldr	r1, [pc, #64]	; (c0d04ff0 <u2f_apdu_sign+0xd4>)
c0d04fb0:	7008      	strb	r0, [r1, #0]
c0d04fb2:	e006      	b.n	c0d04fc2 <u2f_apdu_sign+0xa6>
c0d04fb4:	2183      	movs	r1, #131	; 0x83
    for (i = 0; i < keyHandleLength; i++) {
        buffer[U2F_HANDLE_SIGN_HEADER_SIZE + i] ^= U2F_PROXY_MAGIC[i % (sizeof(U2F_PROXY_MAGIC)-1)];
    }
    // Check that it looks like an APDU
    if (length != U2F_HANDLE_SIGN_HEADER_SIZE + 5 + buffer[U2F_HANDLE_SIGN_HEADER_SIZE + 4]) {
        u2f_message_reply(service, U2F_CMD_MSG,
c0d04fb6:	4a17      	ldr	r2, [pc, #92]	; (c0d05014 <u2f_apdu_sign+0xf8>)
c0d04fb8:	447a      	add	r2, pc
c0d04fba:	2302      	movs	r3, #2
c0d04fbc:	4620      	mov	r0, r4
c0d04fbe:	f000 fb4d 	bl	c0d0565c <u2f_message_reply>
    app_dispatch();
    if ((btchip_context_D.io_flags & IO_ASYNCH_REPLY) == 0) {
        u2f_proxy_response(service, btchip_context_D.outLength);
    }
    */
}
c0d04fc2:	b001      	add	sp, #4
c0d04fc4:	bdf0      	pop	{r4, r5, r6, r7, pc}
        // this apdu is not subject to proxy magic masking
        // APDU is F1 D0 00 00 00 to get the magic proxy
        // RAPDU: <>
        if (os_memcmp(buffer+U2F_HANDLE_SIGN_HEADER_SIZE, "\xF1\xD0\x00\x00\x00", 5) == 0 ) {
            // U2F_PROXY_MAGIC is given as a 0 terminated string
            G_io_apdu_buffer[0] = sizeof(U2F_PROXY_MAGIC)-1;
c0d04fc6:	4d0b      	ldr	r5, [pc, #44]	; (c0d04ff4 <u2f_apdu_sign+0xd8>)
c0d04fc8:	2604      	movs	r6, #4
c0d04fca:	702e      	strb	r6, [r5, #0]
            os_memmove(G_io_apdu_buffer+1, U2F_PROXY_MAGIC, sizeof(U2F_PROXY_MAGIC)-1);
c0d04fcc:	1c68      	adds	r0, r5, #1
c0d04fce:	4912      	ldr	r1, [pc, #72]	; (c0d05018 <u2f_apdu_sign+0xfc>)
c0d04fd0:	4479      	add	r1, pc
c0d04fd2:	4632      	mov	r2, r6
c0d04fd4:	f7fe fddd 	bl	c0d03b92 <os_memmove>
            os_memmove(G_io_apdu_buffer+1+sizeof(U2F_PROXY_MAGIC)-1, "\x90\x00\x90\x00", 4);
c0d04fd8:	1d68      	adds	r0, r5, #5
c0d04fda:	4910      	ldr	r1, [pc, #64]	; (c0d0501c <u2f_apdu_sign+0x100>)
c0d04fdc:	4479      	add	r1, pc
c0d04fde:	4632      	mov	r2, r6
c0d04fe0:	f7fe fdd7 	bl	c0d03b92 <os_memmove>
            u2f_message_reply(service, U2F_CMD_MSG,
                              (uint8_t *)G_io_apdu_buffer,
                              G_io_apdu_buffer[0]+1+2+2);
c0d04fe4:	7828      	ldrb	r0, [r5, #0]
c0d04fe6:	1d43      	adds	r3, r0, #5
c0d04fe8:	2183      	movs	r1, #131	; 0x83
        if (os_memcmp(buffer+U2F_HANDLE_SIGN_HEADER_SIZE, "\xF1\xD0\x00\x00\x00", 5) == 0 ) {
            // U2F_PROXY_MAGIC is given as a 0 terminated string
            G_io_apdu_buffer[0] = sizeof(U2F_PROXY_MAGIC)-1;
            os_memmove(G_io_apdu_buffer+1, U2F_PROXY_MAGIC, sizeof(U2F_PROXY_MAGIC)-1);
            os_memmove(G_io_apdu_buffer+1+sizeof(U2F_PROXY_MAGIC)-1, "\x90\x00\x90\x00", 4);
            u2f_message_reply(service, U2F_CMD_MSG,
c0d04fea:	4620      	mov	r0, r4
c0d04fec:	462a      	mov	r2, r5
c0d04fee:	e7e6      	b.n	c0d04fbe <u2f_apdu_sign+0xa2>
c0d04ff0:	200022dc 	.word	0x200022dc
c0d04ff4:	2000216c 	.word	0x2000216c
c0d04ff8:	200022de 	.word	0x200022de
c0d04ffc:	200022c8 	.word	0x200022c8
c0d05000:	00002dd8 	.word	0x00002dd8
c0d05004:	00002dcc 	.word	0x00002dcc
c0d05008:	00002dc2 	.word	0x00002dc2
c0d0500c:	00002daa 	.word	0x00002daa
c0d05010:	00002d9c 	.word	0x00002d9c
c0d05014:	00002d64 	.word	0x00002d64
c0d05018:	00002d42 	.word	0x00002d42
c0d0501c:	00002d3b 	.word	0x00002d3b

c0d05020 <u2f_handle_cmd_init>:
    UNUSED(length);
    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)INFO, sizeof(INFO));
}

void u2f_handle_cmd_init(u2f_service_t *service, uint8_t *buffer,
                         uint16_t length, uint8_t *channelInit) {
c0d05020:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d05022:	b081      	sub	sp, #4
c0d05024:	461d      	mov	r5, r3
c0d05026:	460e      	mov	r6, r1
c0d05028:	4604      	mov	r4, r0
    // screen_printf("U2F init\n");
    uint8_t channel[4];
    (void)length;
    if (u2f_is_channel_broadcast(channelInit)) {
c0d0502a:	4618      	mov	r0, r3
c0d0502c:	f000 fb0a 	bl	c0d05644 <u2f_is_channel_broadcast>
c0d05030:	2800      	cmp	r0, #0
c0d05032:	d004      	beq.n	c0d0503e <u2f_handle_cmd_init+0x1e>
c0d05034:	4668      	mov	r0, sp
c0d05036:	2104      	movs	r1, #4
        cx_rng(channel, 4);
c0d05038:	f7ff fcf0 	bl	c0d04a1c <cx_rng>
c0d0503c:	e004      	b.n	c0d05048 <u2f_handle_cmd_init+0x28>
c0d0503e:	4668      	mov	r0, sp
c0d05040:	2204      	movs	r2, #4
    } else {
        os_memmove(channel, channelInit, 4);
c0d05042:	4629      	mov	r1, r5
c0d05044:	f7fe fda5 	bl	c0d03b92 <os_memmove>
    }
    os_memmove(G_io_apdu_buffer, buffer, 8);
c0d05048:	4f17      	ldr	r7, [pc, #92]	; (c0d050a8 <u2f_handle_cmd_init+0x88>)
c0d0504a:	2208      	movs	r2, #8
c0d0504c:	4638      	mov	r0, r7
c0d0504e:	4631      	mov	r1, r6
c0d05050:	f7fe fd9f 	bl	c0d03b92 <os_memmove>
    os_memmove(G_io_apdu_buffer + 8, channel, 4);
c0d05054:	4638      	mov	r0, r7
c0d05056:	3008      	adds	r0, #8
c0d05058:	4669      	mov	r1, sp
c0d0505a:	2204      	movs	r2, #4
c0d0505c:	f7fe fd99 	bl	c0d03b92 <os_memmove>
c0d05060:	2000      	movs	r0, #0
    G_io_apdu_buffer[12] = INIT_U2F_VERSION;
    G_io_apdu_buffer[13] = INIT_DEVICE_VERSION_MAJOR;
c0d05062:	7378      	strb	r0, [r7, #13]
c0d05064:	2102      	movs	r1, #2
    } else {
        os_memmove(channel, channelInit, 4);
    }
    os_memmove(G_io_apdu_buffer, buffer, 8);
    os_memmove(G_io_apdu_buffer + 8, channel, 4);
    G_io_apdu_buffer[12] = INIT_U2F_VERSION;
c0d05066:	7339      	strb	r1, [r7, #12]
c0d05068:	2101      	movs	r1, #1
    G_io_apdu_buffer[13] = INIT_DEVICE_VERSION_MAJOR;
    G_io_apdu_buffer[14] = INIT_DEVICE_VERSION_MINOR;
c0d0506a:	73b9      	strb	r1, [r7, #14]
    G_io_apdu_buffer[15] = INIT_BUILD_VERSION;
c0d0506c:	73f8      	strb	r0, [r7, #15]
    G_io_apdu_buffer[16] = INIT_CAPABILITIES;
c0d0506e:	7438      	strb	r0, [r7, #16]

    if (u2f_is_channel_broadcast(channelInit)) {
c0d05070:	4628      	mov	r0, r5
c0d05072:	f000 fae7 	bl	c0d05644 <u2f_is_channel_broadcast>
c0d05076:	2586      	movs	r5, #134	; 0x86
c0d05078:	2800      	cmp	r0, #0
c0d0507a:	d007      	beq.n	c0d0508c <u2f_handle_cmd_init+0x6c>
        os_memset(service->channel, 0xff, 4);
c0d0507c:	4628      	mov	r0, r5
c0d0507e:	3079      	adds	r0, #121	; 0x79
c0d05080:	b2c1      	uxtb	r1, r0
c0d05082:	2204      	movs	r2, #4
c0d05084:	4620      	mov	r0, r4
c0d05086:	f7fe fd7b 	bl	c0d03b80 <os_memset>
c0d0508a:	e004      	b.n	c0d05096 <u2f_handle_cmd_init+0x76>
c0d0508c:	4669      	mov	r1, sp
c0d0508e:	2204      	movs	r2, #4
    } else {
        os_memmove(service->channel, channel, 4);
c0d05090:	4620      	mov	r0, r4
c0d05092:	f7fe fd7e 	bl	c0d03b92 <os_memmove>
    }
    u2f_message_reply(service, U2F_CMD_INIT, G_io_apdu_buffer, 17);
c0d05096:	4a04      	ldr	r2, [pc, #16]	; (c0d050a8 <u2f_handle_cmd_init+0x88>)
c0d05098:	2311      	movs	r3, #17
c0d0509a:	4620      	mov	r0, r4
c0d0509c:	4629      	mov	r1, r5
c0d0509e:	f000 fadd 	bl	c0d0565c <u2f_message_reply>
}
c0d050a2:	b001      	add	sp, #4
c0d050a4:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d050a6:	46c0      	nop			; (mov r8, r8)
c0d050a8:	2000216c 	.word	0x2000216c

c0d050ac <u2f_handle_cmd_msg>:
    // screen_printf("U2F ping\n");
    u2f_message_reply(service, U2F_CMD_PING, buffer, length);
}

void u2f_handle_cmd_msg(u2f_service_t *service, uint8_t *buffer,
                        uint16_t length) {
c0d050ac:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d050ae:	b083      	sub	sp, #12
c0d050b0:	9002      	str	r0, [sp, #8]
    uint8_t cla = buffer[0];
    uint8_t ins = buffer[1];
    uint8_t p1 = buffer[2];
    uint8_t p2 = buffer[3];
    // in extended length buffer[4] must be 0
    uint32_t dataLength = /*(buffer[4] << 16) |*/ (buffer[5] << 8) | (buffer[6]);
c0d050b2:	7988      	ldrb	r0, [r1, #6]
c0d050b4:	794b      	ldrb	r3, [r1, #5]
c0d050b6:	021b      	lsls	r3, r3, #8
c0d050b8:	181f      	adds	r7, r3, r0
void u2f_handle_cmd_msg(u2f_service_t *service, uint8_t *buffer,
                        uint16_t length) {
    // screen_printf("U2F msg\n");
    uint8_t cla = buffer[0];
    uint8_t ins = buffer[1];
    uint8_t p1 = buffer[2];
c0d050ba:	7888      	ldrb	r0, [r1, #2]

void u2f_handle_cmd_msg(u2f_service_t *service, uint8_t *buffer,
                        uint16_t length) {
    // screen_printf("U2F msg\n");
    uint8_t cla = buffer[0];
    uint8_t ins = buffer[1];
c0d050bc:	9001      	str	r0, [sp, #4]
c0d050be:	784b      	ldrb	r3, [r1, #1]
}

void u2f_handle_cmd_msg(u2f_service_t *service, uint8_t *buffer,
                        uint16_t length) {
    // screen_printf("U2F msg\n");
    uint8_t cla = buffer[0];
c0d050c0:	780e      	ldrb	r6, [r1, #0]
    uint8_t ins = buffer[1];
    uint8_t p1 = buffer[2];
    uint8_t p2 = buffer[3];
    // in extended length buffer[4] must be 0
    uint32_t dataLength = /*(buffer[4] << 16) |*/ (buffer[5] << 8) | (buffer[6]);
    if (dataLength == (uint16_t)(length - 9) || dataLength == (uint16_t)(length - 7)) {
c0d050c2:	4615      	mov	r5, r2
c0d050c4:	3d09      	subs	r5, #9
c0d050c6:	b2ac      	uxth	r4, r5
c0d050c8:	42a7      	cmp	r7, r4
c0d050ca:	d004      	beq.n	c0d050d6 <u2f_handle_cmd_msg+0x2a>
c0d050cc:	1fd0      	subs	r0, r2, #7
c0d050ce:	1fd2      	subs	r2, r2, #7
c0d050d0:	b292      	uxth	r2, r2
c0d050d2:	4297      	cmp	r7, r2
c0d050d4:	d11b      	bne.n	c0d0510e <u2f_handle_cmd_msg+0x62>
c0d050d6:	463d      	mov	r5, r7
                  (uint8_t *)SW_WRONG_LENGTH,
                  sizeof(SW_WRONG_LENGTH));
        return;
    }

    if (cla != FIDO_CLA) {
c0d050d8:	2e00      	cmp	r6, #0
c0d050da:	d008      	beq.n	c0d050ee <u2f_handle_cmd_msg+0x42>
c0d050dc:	2183      	movs	r1, #131	; 0x83
        u2f_message_reply(service, U2F_CMD_MSG,
c0d050de:	4a1c      	ldr	r2, [pc, #112]	; (c0d05150 <u2f_handle_cmd_msg+0xa4>)
c0d050e0:	447a      	add	r2, pc
c0d050e2:	2302      	movs	r3, #2
c0d050e4:	9802      	ldr	r0, [sp, #8]
c0d050e6:	f000 fab9 	bl	c0d0565c <u2f_message_reply>
        u2f_message_reply(service, U2F_CMD_MSG,
                 (uint8_t *)SW_UNKNOWN_INSTRUCTION,
                 sizeof(SW_UNKNOWN_INSTRUCTION));
        return;
    }
}
c0d050ea:	b003      	add	sp, #12
c0d050ec:	bdf0      	pop	{r4, r5, r6, r7, pc}
        u2f_message_reply(service, U2F_CMD_MSG,
                  (uint8_t *)SW_UNKNOWN_CLASS,
                  sizeof(SW_UNKNOWN_CLASS));
        return;
    }
    switch (ins) {
c0d050ee:	2b02      	cmp	r3, #2
c0d050f0:	dc18      	bgt.n	c0d05124 <u2f_handle_cmd_msg+0x78>
c0d050f2:	2b01      	cmp	r3, #1
c0d050f4:	d023      	beq.n	c0d0513e <u2f_handle_cmd_msg+0x92>
c0d050f6:	2b02      	cmp	r3, #2
c0d050f8:	d11d      	bne.n	c0d05136 <u2f_handle_cmd_msg+0x8a>
        // screen_printf("enroll\n");
        u2f_apdu_enroll(service, p1, p2, buffer + 7, dataLength);
        break;
    case FIDO_INS_SIGN:
        // screen_printf("sign\n");
        u2f_apdu_sign(service, p1, p2, buffer + 7, dataLength);
c0d050fa:	b2a8      	uxth	r0, r5
c0d050fc:	466a      	mov	r2, sp
c0d050fe:	6010      	str	r0, [r2, #0]
c0d05100:	1dcb      	adds	r3, r1, #7
c0d05102:	2200      	movs	r2, #0
c0d05104:	9802      	ldr	r0, [sp, #8]
c0d05106:	9901      	ldr	r1, [sp, #4]
c0d05108:	f7ff ff08 	bl	c0d04f1c <u2f_apdu_sign>
c0d0510c:	e7ed      	b.n	c0d050ea <u2f_handle_cmd_msg+0x3e>
    if (dataLength == (uint16_t)(length - 9) || dataLength == (uint16_t)(length - 7)) {
        // Le is optional
        // nominal case from the specification
    }
    // circumvent google chrome extended length encoding done on the last byte only (module 256) but all data being transferred
    else if (dataLength == (uint16_t)(length - 9)%256) {
c0d0510e:	b2e4      	uxtb	r4, r4
c0d05110:	42a7      	cmp	r7, r4
c0d05112:	d0e1      	beq.n	c0d050d8 <u2f_handle_cmd_msg+0x2c>
        dataLength = length - 9;
    }
    else if (dataLength == (uint16_t)(length - 7)%256) {
c0d05114:	b2d2      	uxtb	r2, r2
c0d05116:	4297      	cmp	r7, r2
c0d05118:	4605      	mov	r5, r0
c0d0511a:	d0dd      	beq.n	c0d050d8 <u2f_handle_cmd_msg+0x2c>
c0d0511c:	2183      	movs	r1, #131	; 0x83
        dataLength = length - 7;
    }    
    else { 
        // invalid size
        u2f_message_reply(service, U2F_CMD_MSG,
c0d0511e:	4a0d      	ldr	r2, [pc, #52]	; (c0d05154 <u2f_handle_cmd_msg+0xa8>)
c0d05120:	447a      	add	r2, pc
c0d05122:	e7de      	b.n	c0d050e2 <u2f_handle_cmd_msg+0x36>
        u2f_message_reply(service, U2F_CMD_MSG,
                  (uint8_t *)SW_UNKNOWN_CLASS,
                  sizeof(SW_UNKNOWN_CLASS));
        return;
    }
    switch (ins) {
c0d05124:	2b03      	cmp	r3, #3
c0d05126:	d00e      	beq.n	c0d05146 <u2f_handle_cmd_msg+0x9a>
c0d05128:	2bc1      	cmp	r3, #193	; 0xc1
c0d0512a:	d104      	bne.n	c0d05136 <u2f_handle_cmd_msg+0x8a>
c0d0512c:	2183      	movs	r1, #131	; 0x83
                            uint8_t *buffer, uint16_t length) {
    UNUSED(p1);
    UNUSED(p2);
    UNUSED(buffer);
    UNUSED(length);
    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)INFO, sizeof(INFO));
c0d0512e:	4a0a      	ldr	r2, [pc, #40]	; (c0d05158 <u2f_handle_cmd_msg+0xac>)
c0d05130:	447a      	add	r2, pc
c0d05132:	2304      	movs	r3, #4
c0d05134:	e7d6      	b.n	c0d050e4 <u2f_handle_cmd_msg+0x38>
c0d05136:	2183      	movs	r1, #131	; 0x83
        u2f_apdu_get_info(service, p1, p2, buffer + 7, dataLength);
        break;

    default:
        // screen_printf("unsupported\n");
        u2f_message_reply(service, U2F_CMD_MSG,
c0d05138:	4a0a      	ldr	r2, [pc, #40]	; (c0d05164 <u2f_handle_cmd_msg+0xb8>)
c0d0513a:	447a      	add	r2, pc
c0d0513c:	e7d1      	b.n	c0d050e2 <u2f_handle_cmd_msg+0x36>
c0d0513e:	2183      	movs	r1, #131	; 0x83
    UNUSED(p1);
    UNUSED(p2);
    UNUSED(buffer);
    UNUSED(length);

    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)SW_INTERNAL, sizeof(SW_INTERNAL));
c0d05140:	4a06      	ldr	r2, [pc, #24]	; (c0d0515c <u2f_handle_cmd_msg+0xb0>)
c0d05142:	447a      	add	r2, pc
c0d05144:	e7cd      	b.n	c0d050e2 <u2f_handle_cmd_msg+0x36>
c0d05146:	2183      	movs	r1, #131	; 0x83
    // screen_printf("U2F version\n");
    UNUSED(p1);
    UNUSED(p2);
    UNUSED(buffer);
    UNUSED(length);
    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)U2F_VERSION, sizeof(U2F_VERSION));
c0d05148:	4a05      	ldr	r2, [pc, #20]	; (c0d05160 <u2f_handle_cmd_msg+0xb4>)
c0d0514a:	447a      	add	r2, pc
c0d0514c:	2308      	movs	r3, #8
c0d0514e:	e7c9      	b.n	c0d050e4 <u2f_handle_cmd_msg+0x38>
c0d05150:	00002c4a 	.word	0x00002c4a
c0d05154:	00002be8 	.word	0x00002be8
c0d05158:	00002bf6 	.word	0x00002bf6
c0d0515c:	00002bc2 	.word	0x00002bc2
c0d05160:	00002bd4 	.word	0x00002bd4
c0d05164:	00002bf2 	.word	0x00002bf2

c0d05168 <u2f_message_complete>:
                 sizeof(SW_UNKNOWN_INSTRUCTION));
        return;
    }
}

void u2f_message_complete(u2f_service_t *service) {
c0d05168:	b580      	push	{r7, lr}
    uint8_t cmd = service->transportBuffer[0];
c0d0516a:	6981      	ldr	r1, [r0, #24]
    uint16_t length = (service->transportBuffer[1] << 8) | (service->transportBuffer[2]);
c0d0516c:	788a      	ldrb	r2, [r1, #2]
c0d0516e:	784b      	ldrb	r3, [r1, #1]
c0d05170:	021b      	lsls	r3, r3, #8
c0d05172:	189b      	adds	r3, r3, r2
        return;
    }
}

void u2f_message_complete(u2f_service_t *service) {
    uint8_t cmd = service->transportBuffer[0];
c0d05174:	780a      	ldrb	r2, [r1, #0]
    uint16_t length = (service->transportBuffer[1] << 8) | (service->transportBuffer[2]);
    switch (cmd) {
c0d05176:	2a81      	cmp	r2, #129	; 0x81
c0d05178:	d009      	beq.n	c0d0518e <u2f_message_complete+0x26>
c0d0517a:	2a83      	cmp	r2, #131	; 0x83
c0d0517c:	d00d      	beq.n	c0d0519a <u2f_message_complete+0x32>
c0d0517e:	2a86      	cmp	r2, #134	; 0x86
c0d05180:	d10f      	bne.n	c0d051a2 <u2f_message_complete+0x3a>
    case U2F_CMD_INIT:
        u2f_handle_cmd_init(service, service->transportBuffer + 3, length, service->channel);
c0d05182:	1cc9      	adds	r1, r1, #3
c0d05184:	2200      	movs	r2, #0
c0d05186:	4603      	mov	r3, r0
c0d05188:	f7ff ff4a 	bl	c0d05020 <u2f_handle_cmd_init>
        break;
    case U2F_CMD_MSG:
        u2f_handle_cmd_msg(service, service->transportBuffer + 3, length);
        break;
    }
}
c0d0518c:	bd80      	pop	{r7, pc}
    switch (cmd) {
    case U2F_CMD_INIT:
        u2f_handle_cmd_init(service, service->transportBuffer + 3, length, service->channel);
        break;
    case U2F_CMD_PING:
        u2f_handle_cmd_ping(service, service->transportBuffer + 3, length);
c0d0518e:	1cca      	adds	r2, r1, #3
}

void u2f_handle_cmd_ping(u2f_service_t *service, uint8_t *buffer,
                         uint16_t length) {
    // screen_printf("U2F ping\n");
    u2f_message_reply(service, U2F_CMD_PING, buffer, length);
c0d05190:	b29b      	uxth	r3, r3
c0d05192:	2181      	movs	r1, #129	; 0x81
c0d05194:	f000 fa62 	bl	c0d0565c <u2f_message_reply>
        break;
    case U2F_CMD_MSG:
        u2f_handle_cmd_msg(service, service->transportBuffer + 3, length);
        break;
    }
}
c0d05198:	bd80      	pop	{r7, pc}
        break;
    case U2F_CMD_PING:
        u2f_handle_cmd_ping(service, service->transportBuffer + 3, length);
        break;
    case U2F_CMD_MSG:
        u2f_handle_cmd_msg(service, service->transportBuffer + 3, length);
c0d0519a:	1cc9      	adds	r1, r1, #3
c0d0519c:	b29a      	uxth	r2, r3
c0d0519e:	f7ff ff85 	bl	c0d050ac <u2f_handle_cmd_msg>
        break;
    }
}
c0d051a2:	bd80      	pop	{r7, pc}

c0d051a4 <u2f_io_send>:
#include "u2f_processing.h"
#include "u2f_impl.h"

#include "os_io_seproxyhal.h"

void u2f_io_send(uint8_t *buffer, uint16_t length, u2f_transport_media_t media) {
c0d051a4:	b570      	push	{r4, r5, r6, lr}
    if (media == U2F_MEDIA_USB) {
c0d051a6:	2a01      	cmp	r2, #1
c0d051a8:	d113      	bne.n	c0d051d2 <u2f_io_send+0x2e>
c0d051aa:	460d      	mov	r5, r1
c0d051ac:	4601      	mov	r1, r0
        os_memmove(G_io_usb_ep_buffer, buffer, length);
c0d051ae:	4c09      	ldr	r4, [pc, #36]	; (c0d051d4 <u2f_io_send+0x30>)
c0d051b0:	4620      	mov	r0, r4
c0d051b2:	462a      	mov	r2, r5
c0d051b4:	f7fe fced 	bl	c0d03b92 <os_memmove>
        // wipe the remaining to avoid :
        // 1/ data leaks
        // 2/ invalid junk
        os_memset(G_io_usb_ep_buffer+length, 0, sizeof(G_io_usb_ep_buffer)-length);
c0d051b8:	1960      	adds	r0, r4, r5
c0d051ba:	2640      	movs	r6, #64	; 0x40
c0d051bc:	1b72      	subs	r2, r6, r5
c0d051be:	2500      	movs	r5, #0
c0d051c0:	4629      	mov	r1, r5
c0d051c2:	f7fe fcdd 	bl	c0d03b80 <os_memset>
c0d051c6:	2081      	movs	r0, #129	; 0x81
    }
    switch (media) {
    case U2F_MEDIA_USB:
        io_usb_send_ep(U2F_EPIN_ADDR, G_io_usb_ep_buffer, USB_SEGMENT_SIZE, 0);
c0d051c8:	4621      	mov	r1, r4
c0d051ca:	4632      	mov	r2, r6
c0d051cc:	462b      	mov	r3, r5
c0d051ce:	f7fe fe49 	bl	c0d03e64 <io_usb_send_ep>
#endif
    default:
        PRINTF("Request to send on unsupported media %d\n", media);
        break;
    }
}
c0d051d2:	bd70      	pop	{r4, r5, r6, pc}
c0d051d4:	20002370 	.word	0x20002370

c0d051d8 <u2f_transport_init>:
/**
 * Initialize the u2f transport and provide the buffer into which to store incoming message
 */
void u2f_transport_init(u2f_service_t *service, uint8_t* message_buffer, uint16_t message_buffer_length) {
    service->transportReceiveBuffer = message_buffer;
    service->transportReceiveBufferLength = message_buffer_length;
c0d051d8:	8182      	strh	r2, [r0, #12]

/**
 * Initialize the u2f transport and provide the buffer into which to store incoming message
 */
void u2f_transport_init(u2f_service_t *service, uint8_t* message_buffer, uint16_t message_buffer_length) {
    service->transportReceiveBuffer = message_buffer;
c0d051da:	6081      	str	r1, [r0, #8]
c0d051dc:	2200      	movs	r2, #0
#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
    service->transportOffset = 0;
c0d051de:	8242      	strh	r2, [r0, #18]

#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
c0d051e0:	8382      	strh	r2, [r0, #28]
    service->transportOffset = 0;
    service->transportMedia = 0;
    service->transportPacketIndex = 0;
c0d051e2:	7582      	strb	r2, [r0, #22]
    // reset the receive buffer to allow for a new message to be received again (in case transmission of a CODE buffer the previous reply)
    service->transportBuffer = service->transportReceiveBuffer;
c0d051e4:	6181      	str	r1, [r0, #24]
 */
void u2f_transport_init(u2f_service_t *service, uint8_t* message_buffer, uint16_t message_buffer_length) {
    service->transportReceiveBuffer = message_buffer;
    service->transportReceiveBufferLength = message_buffer_length;
    u2f_transport_reset(service);
}
c0d051e6:	4770      	bx	lr

c0d051e8 <u2f_transport_sent>:

/**
 * Function called when the previously scheduled message to be sent on the media is effectively sent.
 * And a new message can be scheduled.
 */
void u2f_transport_sent(u2f_service_t* service, u2f_transport_media_t media) {
c0d051e8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d051ea:	b085      	sub	sp, #20
c0d051ec:	4604      	mov	r4, r0
    // if idle (possibly after an error), then only await for a transmission 
    if (service->transportState != U2F_SENDING_RESPONSE 
c0d051ee:	7f00      	ldrb	r0, [r0, #28]
        && service->transportState != U2F_SENDING_ERROR) {
c0d051f0:	1ec0      	subs	r0, r0, #3
c0d051f2:	b2c0      	uxtb	r0, r0
c0d051f4:	2801      	cmp	r0, #1
c0d051f6:	d857      	bhi.n	c0d052a8 <u2f_transport_sent+0xc0>
        // absorb the error, transport is erroneous but that won't hurt in the end.
        //THROW(INVALID_STATE);
        return;
    }
    if (service->transportOffset < service->transportLength) {
c0d051f8:	8aa0      	ldrh	r0, [r4, #20]
c0d051fa:	8a62      	ldrh	r2, [r4, #18]
c0d051fc:	4290      	cmp	r0, r2
c0d051fe:	d927      	bls.n	c0d05250 <u2f_transport_sent+0x68>
        uint16_t mtu = (media == U2F_MEDIA_USB) ? USB_SEGMENT_SIZE : BLE_SEGMENT_SIZE;
        uint16_t channelHeader =
            (media == U2F_MEDIA_USB ? 4 : 0);
        uint8_t headerSize =
            (service->transportPacketIndex == 0 ? (channelHeader + 3)
c0d05200:	7da5      	ldrb	r5, [r4, #22]
c0d05202:	2303      	movs	r3, #3
c0d05204:	2601      	movs	r6, #1
c0d05206:	9502      	str	r5, [sp, #8]
c0d05208:	2d00      	cmp	r5, #0
c0d0520a:	d000      	beq.n	c0d0520e <u2f_transport_sent+0x26>
c0d0520c:	4633      	mov	r3, r6
        // absorb the error, transport is erroneous but that won't hurt in the end.
        //THROW(INVALID_STATE);
        return;
    }
    if (service->transportOffset < service->transportLength) {
        uint16_t mtu = (media == U2F_MEDIA_USB) ? USB_SEGMENT_SIZE : BLE_SEGMENT_SIZE;
c0d0520e:	1e4f      	subs	r7, r1, #1
c0d05210:	2500      	movs	r5, #0
c0d05212:	460e      	mov	r6, r1
c0d05214:	9503      	str	r5, [sp, #12]
c0d05216:	1bed      	subs	r5, r5, r7
c0d05218:	417d      	adcs	r5, r7
c0d0521a:	00ad      	lsls	r5, r5, #2
        uint16_t channelHeader =
            (media == U2F_MEDIA_USB ? 4 : 0);
        uint8_t headerSize =
            (service->transportPacketIndex == 0 ? (channelHeader + 3)
c0d0521c:	195d      	adds	r5, r3, r5
c0d0521e:	2340      	movs	r3, #64	; 0x40
                                                : (channelHeader + 1));
        uint16_t blockSize = ((service->transportLength - service->transportOffset) >
                                      (mtu - headerSize)
c0d05220:	1b5f      	subs	r7, r3, r5
        uint16_t channelHeader =
            (media == U2F_MEDIA_USB ? 4 : 0);
        uint8_t headerSize =
            (service->transportPacketIndex == 0 ? (channelHeader + 3)
                                                : (channelHeader + 1));
        uint16_t blockSize = ((service->transportLength - service->transportOffset) >
c0d05222:	1a81      	subs	r1, r0, r2
c0d05224:	42b9      	cmp	r1, r7
c0d05226:	dc00      	bgt.n	c0d0522a <u2f_transport_sent+0x42>
c0d05228:	460f      	mov	r7, r1
c0d0522a:	9501      	str	r5, [sp, #4]
                                      (mtu - headerSize)
                                  ? (mtu - headerSize)
                                  : service->transportLength - service->transportOffset);
        uint16_t dataSize = blockSize + headerSize;
c0d0522c:	1978      	adds	r0, r7, r5
        uint16_t offset = 0;
        // Fragment
        if (media == U2F_MEDIA_USB) {
c0d0522e:	9004      	str	r0, [sp, #16]
c0d05230:	2e01      	cmp	r6, #1
c0d05232:	4635      	mov	r5, r6
c0d05234:	9e03      	ldr	r6, [sp, #12]
c0d05236:	9802      	ldr	r0, [sp, #8]
c0d05238:	d106      	bne.n	c0d05248 <u2f_transport_sent+0x60>
            os_memmove(G_io_usb_ep_buffer, service->channel, 4);
c0d0523a:	481d      	ldr	r0, [pc, #116]	; (c0d052b0 <u2f_transport_sent+0xc8>)
c0d0523c:	2604      	movs	r6, #4
c0d0523e:	4621      	mov	r1, r4
c0d05240:	4632      	mov	r2, r6
c0d05242:	f7fe fca6 	bl	c0d03b92 <os_memmove>
            offset += 4;
        }
        if (service->transportPacketIndex == 0) {
c0d05246:	7da0      	ldrb	r0, [r4, #22]
c0d05248:	2800      	cmp	r0, #0
c0d0524a:	d00b      	beq.n	c0d05264 <u2f_transport_sent+0x7c>
            G_io_usb_ep_buffer[offset++] = service->sendCmd;
            G_io_usb_ep_buffer[offset++] = (service->transportLength >> 8);
            G_io_usb_ep_buffer[offset++] = (service->transportLength & 0xff);
        } else {
            G_io_usb_ep_buffer[offset++] = (service->transportPacketIndex - 1);
c0d0524c:	1e40      	subs	r0, r0, #1
c0d0524e:	e013      	b.n	c0d05278 <u2f_transport_sent+0x90>
        service->transportOffset += blockSize;
        service->transportPacketIndex++;
        u2f_io_send(G_io_usb_ep_buffer, dataSize, media);
    }
    // last part sent
    else if (service->transportOffset == service->transportLength) {
c0d05250:	d12a      	bne.n	c0d052a8 <u2f_transport_sent+0xc0>
c0d05252:	2000      	movs	r0, #0
#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
    service->transportOffset = 0;
c0d05254:	8260      	strh	r0, [r4, #18]

#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
c0d05256:	83a0      	strh	r0, [r4, #28]
    service->transportOffset = 0;
    service->transportMedia = 0;
    service->transportPacketIndex = 0;
c0d05258:	75a0      	strb	r0, [r4, #22]
    // reset the receive buffer to allow for a new message to be received again (in case transmission of a CODE buffer the previous reply)
    service->transportBuffer = service->transportReceiveBuffer;
c0d0525a:	68a1      	ldr	r1, [r4, #8]
c0d0525c:	61a1      	str	r1, [r4, #24]
    }
    // last part sent
    else if (service->transportOffset == service->transportLength) {
        u2f_transport_reset(service);
        // we sent the whole response (even if we haven't yet received the ack for the last sent usb in packet)
        G_io_apdu_state = APDU_IDLE;
c0d0525e:	4913      	ldr	r1, [pc, #76]	; (c0d052ac <u2f_transport_sent+0xc4>)
c0d05260:	7008      	strb	r0, [r1, #0]
c0d05262:	e021      	b.n	c0d052a8 <u2f_transport_sent+0xc0>
c0d05264:	2034      	movs	r0, #52	; 0x34
        if (media == U2F_MEDIA_USB) {
            os_memmove(G_io_usb_ep_buffer, service->channel, 4);
            offset += 4;
        }
        if (service->transportPacketIndex == 0) {
            G_io_usb_ep_buffer[offset++] = service->sendCmd;
c0d05266:	5c20      	ldrb	r0, [r4, r0]
c0d05268:	4911      	ldr	r1, [pc, #68]	; (c0d052b0 <u2f_transport_sent+0xc8>)
c0d0526a:	5588      	strb	r0, [r1, r6]
c0d0526c:	2001      	movs	r0, #1
c0d0526e:	4330      	orrs	r0, r6
            G_io_usb_ep_buffer[offset++] = (service->transportLength >> 8);
c0d05270:	7d62      	ldrb	r2, [r4, #21]
c0d05272:	540a      	strb	r2, [r1, r0]
c0d05274:	1c46      	adds	r6, r0, #1
            G_io_usb_ep_buffer[offset++] = (service->transportLength & 0xff);
c0d05276:	7d20      	ldrb	r0, [r4, #20]
c0d05278:	4b0d      	ldr	r3, [pc, #52]	; (c0d052b0 <u2f_transport_sent+0xc8>)
c0d0527a:	5598      	strb	r0, [r3, r6]
        } else {
            G_io_usb_ep_buffer[offset++] = (service->transportPacketIndex - 1);
        }
        if (service->transportBuffer != NULL) {
c0d0527c:	69a1      	ldr	r1, [r4, #24]
c0d0527e:	2900      	cmp	r1, #0
c0d05280:	d006      	beq.n	c0d05290 <u2f_transport_sent+0xa8>
c0d05282:	b2ba      	uxth	r2, r7
            os_memmove(G_io_usb_ep_buffer + headerSize,
c0d05284:	9801      	ldr	r0, [sp, #4]
c0d05286:	1818      	adds	r0, r3, r0
                       service->transportBuffer + service->transportOffset, blockSize);
c0d05288:	8a63      	ldrh	r3, [r4, #18]
c0d0528a:	18c9      	adds	r1, r1, r3
            G_io_usb_ep_buffer[offset++] = (service->transportLength & 0xff);
        } else {
            G_io_usb_ep_buffer[offset++] = (service->transportPacketIndex - 1);
        }
        if (service->transportBuffer != NULL) {
            os_memmove(G_io_usb_ep_buffer + headerSize,
c0d0528c:	f7fe fc81 	bl	c0d03b92 <os_memmove>
                       service->transportBuffer + service->transportOffset, blockSize);
        }
        service->transportOffset += blockSize;
c0d05290:	8a60      	ldrh	r0, [r4, #18]
c0d05292:	19c0      	adds	r0, r0, r7
c0d05294:	8260      	strh	r0, [r4, #18]
        service->transportPacketIndex++;
c0d05296:	7da0      	ldrb	r0, [r4, #22]
c0d05298:	1c40      	adds	r0, r0, #1
c0d0529a:	75a0      	strb	r0, [r4, #22]
        u2f_io_send(G_io_usb_ep_buffer, dataSize, media);
c0d0529c:	9804      	ldr	r0, [sp, #16]
c0d0529e:	b281      	uxth	r1, r0
c0d052a0:	4803      	ldr	r0, [pc, #12]	; (c0d052b0 <u2f_transport_sent+0xc8>)
c0d052a2:	462a      	mov	r2, r5
c0d052a4:	f7ff ff7e 	bl	c0d051a4 <u2f_io_send>
    else if (service->transportOffset == service->transportLength) {
        u2f_transport_reset(service);
        // we sent the whole response (even if we haven't yet received the ack for the last sent usb in packet)
        G_io_apdu_state = APDU_IDLE;
    }
}
c0d052a8:	b005      	add	sp, #20
c0d052aa:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d052ac:	200022dc 	.word	0x200022dc
c0d052b0:	20002370 	.word	0x20002370

c0d052b4 <u2f_transport_received>:
/** 
 * Function that process every message received on a media.
 * Performs message concatenation when message is splitted.
 */
void u2f_transport_received(u2f_service_t *service, uint8_t *buffer,
                          uint16_t size, u2f_transport_media_t media) {
c0d052b4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d052b6:	b087      	sub	sp, #28
c0d052b8:	4616      	mov	r6, r2
c0d052ba:	460a      	mov	r2, r1
c0d052bc:	4604      	mov	r4, r0
    uint16_t channelHeader = (media == U2F_MEDIA_USB ? 4 : 0);
    uint16_t xfer_len;
    service->media = media;
c0d052be:	7103      	strb	r3, [r0, #4]
    // If busy, answer immediately, avoid reentry
    if ((service->transportState == U2F_PROCESSING_COMMAND) ||
c0d052c0:	7f00      	ldrb	r0, [r0, #28]
c0d052c2:	1e81      	subs	r1, r0, #2
c0d052c4:	2902      	cmp	r1, #2
c0d052c6:	d20f      	bcs.n	c0d052e8 <u2f_transport_received+0x34>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d052c8:	48da      	ldr	r0, [pc, #872]	; (c0d05634 <u2f_transport_received+0x380>)
c0d052ca:	2106      	movs	r1, #6
c0d052cc:	7201      	strb	r1, [r0, #8]
c0d052ce:	217a      	movs	r1, #122	; 0x7a
c0d052d0:	43c9      	mvns	r1, r1
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d052d2:	313a      	adds	r1, #58	; 0x3a
c0d052d4:	2234      	movs	r2, #52	; 0x34
c0d052d6:	54a1      	strb	r1, [r4, r2]
c0d052d8:	2100      	movs	r1, #0
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
c0d052da:	75a1      	strb	r1, [r4, #22]
c0d052dc:	2204      	movs	r2, #4
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d052de:	7722      	strb	r2, [r4, #28]
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d052e0:	3008      	adds	r0, #8

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
c0d052e2:	61a0      	str	r0, [r4, #24]
    service->transportOffset = 0;
c0d052e4:	8261      	strh	r1, [r4, #18]
c0d052e6:	e063      	b.n	c0d053b0 <u2f_transport_received+0xfc>
c0d052e8:	461d      	mov	r5, r3
                          uint16_t size, u2f_transport_media_t media) {
    uint16_t channelHeader = (media == U2F_MEDIA_USB ? 4 : 0);
    uint16_t xfer_len;
    service->media = media;
    // If busy, answer immediately, avoid reentry
    if ((service->transportState == U2F_PROCESSING_COMMAND) ||
c0d052ea:	2804      	cmp	r0, #4
c0d052ec:	d105      	bne.n	c0d052fa <u2f_transport_received+0x46>
c0d052ee:	2000      	movs	r0, #0
#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
    service->transportOffset = 0;
c0d052f0:	8260      	strh	r0, [r4, #18]

#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
c0d052f2:	83a0      	strh	r0, [r4, #28]
    service->transportOffset = 0;
    service->transportMedia = 0;
    service->transportPacketIndex = 0;
c0d052f4:	75a0      	strb	r0, [r4, #22]
    // reset the receive buffer to allow for a new message to be received again (in case transmission of a CODE buffer the previous reply)
    service->transportBuffer = service->transportReceiveBuffer;
c0d052f6:	68a0      	ldr	r0, [r4, #8]
c0d052f8:	61a0      	str	r0, [r4, #24]
 * Function that process every message received on a media.
 * Performs message concatenation when message is splitted.
 */
void u2f_transport_received(u2f_service_t *service, uint8_t *buffer,
                          uint16_t size, u2f_transport_media_t media) {
    uint16_t channelHeader = (media == U2F_MEDIA_USB ? 4 : 0);
c0d052fa:	1e68      	subs	r0, r5, #1
c0d052fc:	2300      	movs	r3, #0
c0d052fe:	1a19      	subs	r1, r3, r0
c0d05300:	4141      	adcs	r1, r0
    // SENDING_ERROR is accepted, and triggers a reset => means the host hasn't consumed the error.
    if (service->transportState == U2F_SENDING_ERROR) {
        u2f_transport_reset(service);
    }

    if (size < (1 + channelHeader)) {
c0d05302:	008f      	lsls	r7, r1, #2
c0d05304:	1c78      	adds	r0, r7, #1
c0d05306:	42b0      	cmp	r0, r6
c0d05308:	d844      	bhi.n	c0d05394 <u2f_transport_received+0xe0>
c0d0530a:	9004      	str	r0, [sp, #16]
        // Message to short, abort
        u2f_transport_error(service, ERROR_PROP_MESSAGE_TOO_SHORT);
        goto error;
    }
    if (media == U2F_MEDIA_USB) {
c0d0530c:	2d01      	cmp	r5, #1
c0d0530e:	9705      	str	r7, [sp, #20]
c0d05310:	9506      	str	r5, [sp, #24]
c0d05312:	d10c      	bne.n	c0d0532e <u2f_transport_received+0x7a>
c0d05314:	4615      	mov	r5, r2
c0d05316:	2204      	movs	r2, #4
        // hold the current channel value to reply to, for example, INIT commands within flow of segments.
        os_memmove(service->channel, buffer, 4);
c0d05318:	4620      	mov	r0, r4
c0d0531a:	4629      	mov	r1, r5
c0d0531c:	4637      	mov	r7, r6
c0d0531e:	461e      	mov	r6, r3
c0d05320:	f7fe fc37 	bl	c0d03b92 <os_memmove>
c0d05324:	462a      	mov	r2, r5
c0d05326:	9d06      	ldr	r5, [sp, #24]
c0d05328:	4633      	mov	r3, r6
c0d0532a:	463e      	mov	r6, r7
c0d0532c:	9f05      	ldr	r7, [sp, #20]
    }

    // no previous chunk processed for the current message
    if (service->transportOffset == 0
c0d0532e:	8a60      	ldrh	r0, [r4, #18]
        // on USB we could get an INIT within a flow of segments.
        || (media == U2F_MEDIA_USB && os_memcmp(service->transportChannel, service->channel, 4) != 0) ) {
c0d05330:	2800      	cmp	r0, #0
c0d05332:	d011      	beq.n	c0d05358 <u2f_transport_received+0xa4>
c0d05334:	2d01      	cmp	r5, #1
c0d05336:	d129      	bne.n	c0d0538c <u2f_transport_received+0xd8>
c0d05338:	4620      	mov	r0, r4
c0d0533a:	300e      	adds	r0, #14
c0d0533c:	4615      	mov	r5, r2
c0d0533e:	2204      	movs	r2, #4
c0d05340:	4621      	mov	r1, r4
c0d05342:	4637      	mov	r7, r6
c0d05344:	461e      	mov	r6, r3
c0d05346:	f7fe fcdf 	bl	c0d03d08 <os_memcmp>
c0d0534a:	462a      	mov	r2, r5
c0d0534c:	9d06      	ldr	r5, [sp, #24]
c0d0534e:	4633      	mov	r3, r6
c0d05350:	463e      	mov	r6, r7
c0d05352:	9f05      	ldr	r7, [sp, #20]
        // hold the current channel value to reply to, for example, INIT commands within flow of segments.
        os_memmove(service->channel, buffer, 4);
    }

    // no previous chunk processed for the current message
    if (service->transportOffset == 0
c0d05354:	2800      	cmp	r0, #0
c0d05356:	d019      	beq.n	c0d0538c <u2f_transport_received+0xd8>
c0d05358:	2103      	movs	r1, #3
        // on USB we could get an INIT within a flow of segments.
        || (media == U2F_MEDIA_USB && os_memcmp(service->transportChannel, service->channel, 4) != 0) ) {
        if (size < (channelHeader + 3)) {
c0d0535a:	4638      	mov	r0, r7
c0d0535c:	4308      	orrs	r0, r1
c0d0535e:	42b0      	cmp	r0, r6
c0d05360:	d818      	bhi.n	c0d05394 <u2f_transport_received+0xe0>
c0d05362:	9101      	str	r1, [sp, #4]
            // Message to short, abort
            u2f_transport_error(service, ERROR_PROP_MESSAGE_TOO_SHORT);
            goto error;
        }
        // check this is a command, cannot accept continuation without previous command
        if ((buffer[channelHeader+0]&U2F_MASK_COMMAND) == 0) {
c0d05364:	19d0      	adds	r0, r2, r7
c0d05366:	9003      	str	r0, [sp, #12]
c0d05368:	4615      	mov	r5, r2
c0d0536a:	57d0      	ldrsb	r0, [r2, r7]
c0d0536c:	217a      	movs	r1, #122	; 0x7a
c0d0536e:	43c9      	mvns	r1, r1
c0d05370:	317a      	adds	r1, #122	; 0x7a
c0d05372:	b249      	sxtb	r1, r1
c0d05374:	2285      	movs	r2, #133	; 0x85
c0d05376:	4288      	cmp	r0, r1
c0d05378:	dd47      	ble.n	c0d0540a <u2f_transport_received+0x156>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d0537a:	48ae      	ldr	r0, [pc, #696]	; (c0d05634 <u2f_transport_received+0x380>)
c0d0537c:	2104      	movs	r1, #4
c0d0537e:	7201      	strb	r1, [r0, #8]
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d05380:	323a      	adds	r2, #58	; 0x3a
c0d05382:	4615      	mov	r5, r2
c0d05384:	2234      	movs	r2, #52	; 0x34
c0d05386:	54a5      	strb	r5, [r4, r2]
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
c0d05388:	75a3      	strb	r3, [r4, #22]
c0d0538a:	e00d      	b.n	c0d053a8 <u2f_transport_received+0xf4>
c0d0538c:	2002      	movs	r0, #2
        }
    } else {


        // Continuation
        if (size < (channelHeader + 2)) {
c0d0538e:	4338      	orrs	r0, r7
c0d05390:	42b0      	cmp	r0, r6
c0d05392:	d915      	bls.n	c0d053c0 <u2f_transport_received+0x10c>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d05394:	48a7      	ldr	r0, [pc, #668]	; (c0d05634 <u2f_transport_received+0x380>)
c0d05396:	2185      	movs	r1, #133	; 0x85
c0d05398:	7201      	strb	r1, [r0, #8]
c0d0539a:	217a      	movs	r1, #122	; 0x7a
c0d0539c:	43c9      	mvns	r1, r1
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d0539e:	313a      	adds	r1, #58	; 0x3a
c0d053a0:	2234      	movs	r2, #52	; 0x34
c0d053a2:	54a1      	strb	r1, [r4, r2]
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
c0d053a4:	75a3      	strb	r3, [r4, #22]
c0d053a6:	2104      	movs	r1, #4
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d053a8:	7721      	strb	r1, [r4, #28]
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d053aa:	3008      	adds	r0, #8

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
c0d053ac:	61a0      	str	r0, [r4, #24]
    service->transportOffset = 0;
c0d053ae:	8263      	strh	r3, [r4, #18]
c0d053b0:	2001      	movs	r0, #1
    service->transportLength = 1;
c0d053b2:	82a0      	strh	r0, [r4, #20]
    service->sendCmd = U2F_STATUS_ERROR;
    // pump the first message, with the reception media
    u2f_transport_sent(service, service->media);
c0d053b4:	7921      	ldrb	r1, [r4, #4]
c0d053b6:	4620      	mov	r0, r4
c0d053b8:	f7ff ff16 	bl	c0d051e8 <u2f_transport_sent>
        service->seqTimeout = 0;
        service->transportState = U2F_HANDLE_SEGMENTED;
    }
error:
    return;
}
c0d053bc:	b007      	add	sp, #28
c0d053be:	bdf0      	pop	{r4, r5, r6, r7, pc}
        if (size < (channelHeader + 2)) {
            // Message to short, abort
            u2f_transport_error(service, ERROR_PROP_MESSAGE_TOO_SHORT);
            goto error;
        }
        if (media != service->transportMedia) {
c0d053c0:	7f60      	ldrb	r0, [r4, #29]
c0d053c2:	42a8      	cmp	r0, r5
c0d053c4:	d15a      	bne.n	c0d0547c <u2f_transport_received+0x1c8>
            // Mixed medias
            u2f_transport_error(service, ERROR_PROP_MEDIA_MIXED);
            goto error;
        }
        if (service->transportState != U2F_HANDLE_SEGMENTED) {
c0d053c6:	7f20      	ldrb	r0, [r4, #28]
c0d053c8:	2801      	cmp	r0, #1
c0d053ca:	d166      	bne.n	c0d0549a <u2f_transport_received+0x1e6>
            } else {
                u2f_transport_error(service, ERROR_INVALID_SEQ);
                goto error;
            }
        }
        if (media == U2F_MEDIA_USB) {
c0d053cc:	2d01      	cmp	r5, #1
c0d053ce:	d000      	beq.n	c0d053d2 <u2f_transport_received+0x11e>
c0d053d0:	e089      	b.n	c0d054e6 <u2f_transport_received+0x232>
c0d053d2:	2004      	movs	r0, #4
            // Check the channel
            if (os_memcmp(buffer, service->channel, 4) != 0) {
c0d053d4:	9003      	str	r0, [sp, #12]
c0d053d6:	4610      	mov	r0, r2
c0d053d8:	4621      	mov	r1, r4
c0d053da:	4615      	mov	r5, r2
c0d053dc:	9a03      	ldr	r2, [sp, #12]
c0d053de:	4637      	mov	r7, r6
c0d053e0:	461e      	mov	r6, r3
c0d053e2:	f7fe fc91 	bl	c0d03d08 <os_memcmp>
c0d053e6:	462a      	mov	r2, r5
c0d053e8:	9d06      	ldr	r5, [sp, #24]
c0d053ea:	4633      	mov	r3, r6
c0d053ec:	463e      	mov	r6, r7
c0d053ee:	9f05      	ldr	r7, [sp, #20]
c0d053f0:	2800      	cmp	r0, #0
c0d053f2:	d078      	beq.n	c0d054e6 <u2f_transport_received+0x232>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d053f4:	488f      	ldr	r0, [pc, #572]	; (c0d05634 <u2f_transport_received+0x380>)
c0d053f6:	2106      	movs	r1, #6
c0d053f8:	7201      	strb	r1, [r0, #8]
c0d053fa:	217a      	movs	r1, #122	; 0x7a
c0d053fc:	43c9      	mvns	r1, r1
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d053fe:	313a      	adds	r1, #58	; 0x3a
c0d05400:	2234      	movs	r2, #52	; 0x34
c0d05402:	54a1      	strb	r1, [r4, r2]
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
c0d05404:	75a3      	strb	r3, [r4, #22]
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d05406:	9903      	ldr	r1, [sp, #12]
c0d05408:	e7ce      	b.n	c0d053a8 <u2f_transport_received+0xf4>
c0d0540a:	9302      	str	r3, [sp, #8]
            goto error;
        }

        // If waiting for a continuation on a different channel, reply BUSY
        // immediately
        if (media == U2F_MEDIA_USB) {
c0d0540c:	9806      	ldr	r0, [sp, #24]
c0d0540e:	2801      	cmp	r0, #1
c0d05410:	d113      	bne.n	c0d0543a <u2f_transport_received+0x186>
            if ((service->transportState == U2F_HANDLE_SEGMENTED) &&
c0d05412:	7f20      	ldrb	r0, [r4, #28]
c0d05414:	2801      	cmp	r0, #1
c0d05416:	d11c      	bne.n	c0d05452 <u2f_transport_received+0x19e>
                (os_memcmp(service->channel, service->transportChannel, 4) !=
c0d05418:	4621      	mov	r1, r4
c0d0541a:	310e      	adds	r1, #14
c0d0541c:	9200      	str	r2, [sp, #0]
c0d0541e:	2204      	movs	r2, #4
c0d05420:	4620      	mov	r0, r4
c0d05422:	f7fe fc71 	bl	c0d03d08 <os_memcmp>
c0d05426:	9a00      	ldr	r2, [sp, #0]
                 0) &&
c0d05428:	2800      	cmp	r0, #0
c0d0542a:	d006      	beq.n	c0d0543a <u2f_transport_received+0x186>
                (buffer[channelHeader] != U2F_CMD_INIT)) {
c0d0542c:	9803      	ldr	r0, [sp, #12]
c0d0542e:	7800      	ldrb	r0, [r0, #0]
c0d05430:	1c51      	adds	r1, r2, #1
c0d05432:	b2c9      	uxtb	r1, r1
        }

        // If waiting for a continuation on a different channel, reply BUSY
        // immediately
        if (media == U2F_MEDIA_USB) {
            if ((service->transportState == U2F_HANDLE_SEGMENTED) &&
c0d05434:	4288      	cmp	r0, r1
c0d05436:	d000      	beq.n	c0d0543a <u2f_transport_received+0x186>
c0d05438:	e0dd      	b.n	c0d055f6 <u2f_transport_received+0x342>
                goto error;
            }
        }
        // If a command was already sent, and we are not processing a INIT
        // command, abort
        if ((service->transportState == U2F_HANDLE_SEGMENTED) &&
c0d0543a:	7f20      	ldrb	r0, [r4, #28]
c0d0543c:	2801      	cmp	r0, #1
c0d0543e:	d108      	bne.n	c0d05452 <u2f_transport_received+0x19e>
            !((media == U2F_MEDIA_USB) &&
c0d05440:	9806      	ldr	r0, [sp, #24]
c0d05442:	2801      	cmp	r0, #1
c0d05444:	d179      	bne.n	c0d0553a <u2f_transport_received+0x286>
              (buffer[channelHeader] == U2F_CMD_INIT))) {
c0d05446:	9803      	ldr	r0, [sp, #12]
c0d05448:	7800      	ldrb	r0, [r0, #0]
c0d0544a:	1c51      	adds	r1, r2, #1
c0d0544c:	b2c9      	uxtb	r1, r1
                goto error;
            }
        }
        // If a command was already sent, and we are not processing a INIT
        // command, abort
        if ((service->transportState == U2F_HANDLE_SEGMENTED) &&
c0d0544e:	4288      	cmp	r0, r1
c0d05450:	d173      	bne.n	c0d0553a <u2f_transport_received+0x286>
c0d05452:	2002      	movs	r0, #2
            u2f_transport_error(service, ERROR_INVALID_SEQ);
            goto error;
        }
        // Check the length
        uint16_t commandLength =
            (buffer[channelHeader + 1] << 8) | (buffer[channelHeader + 2]);
c0d05454:	4338      	orrs	r0, r7
c0d05456:	5c28      	ldrb	r0, [r5, r0]
c0d05458:	9904      	ldr	r1, [sp, #16]
c0d0545a:	5c69      	ldrb	r1, [r5, r1]
c0d0545c:	0209      	lsls	r1, r1, #8
c0d0545e:	180f      	adds	r7, r1, r0
        if (commandLength > (service->transportReceiveBufferLength - 3)) {
c0d05460:	89a0      	ldrh	r0, [r4, #12]
c0d05462:	1ec0      	subs	r0, r0, #3
c0d05464:	4287      	cmp	r7, r0
c0d05466:	dd21      	ble.n	c0d054ac <u2f_transport_received+0x1f8>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d05468:	4872      	ldr	r0, [pc, #456]	; (c0d05634 <u2f_transport_received+0x380>)
c0d0546a:	9901      	ldr	r1, [sp, #4]
c0d0546c:	7201      	strb	r1, [r0, #8]
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d0546e:	323a      	adds	r2, #58	; 0x3a
c0d05470:	2134      	movs	r1, #52	; 0x34
c0d05472:	5462      	strb	r2, [r4, r1]
c0d05474:	9a02      	ldr	r2, [sp, #8]
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
c0d05476:	75a2      	strb	r2, [r4, #22]
c0d05478:	2104      	movs	r1, #4
c0d0547a:	e067      	b.n	c0d0554c <u2f_transport_received+0x298>
c0d0547c:	207a      	movs	r0, #122	; 0x7a
c0d0547e:	43c0      	mvns	r0, r0
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d05480:	4601      	mov	r1, r0
c0d05482:	3108      	adds	r1, #8
c0d05484:	4a6b      	ldr	r2, [pc, #428]	; (c0d05634 <u2f_transport_received+0x380>)
c0d05486:	7211      	strb	r1, [r2, #8]
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d05488:	303a      	adds	r0, #58	; 0x3a
c0d0548a:	2134      	movs	r1, #52	; 0x34
c0d0548c:	5460      	strb	r0, [r4, r1]
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
c0d0548e:	75a3      	strb	r3, [r4, #22]
c0d05490:	2004      	movs	r0, #4
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d05492:	7720      	strb	r0, [r4, #28]
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d05494:	3208      	adds	r2, #8

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
c0d05496:	61a2      	str	r2, [r4, #24]
c0d05498:	e789      	b.n	c0d053ae <u2f_transport_received+0xfa>
            goto error;
        }
        if (service->transportState != U2F_HANDLE_SEGMENTED) {
            // Unexpected continuation at this stage, abort
            // TODO : review the behavior is HID only
            if (media == U2F_MEDIA_USB) {
c0d0549a:	2d01      	cmp	r5, #1
c0d0549c:	d13e      	bne.n	c0d0551c <u2f_transport_received+0x268>
c0d0549e:	2000      	movs	r0, #0
#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
    service->transportOffset = 0;
c0d054a0:	8260      	strh	r0, [r4, #18]

#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
c0d054a2:	83a0      	strh	r0, [r4, #28]
    service->transportOffset = 0;
    service->transportMedia = 0;
    service->transportPacketIndex = 0;
c0d054a4:	75a0      	strb	r0, [r4, #22]
    // reset the receive buffer to allow for a new message to be received again (in case transmission of a CODE buffer the previous reply)
    service->transportBuffer = service->transportReceiveBuffer;
c0d054a6:	68a0      	ldr	r0, [r4, #8]
c0d054a8:	61a0      	str	r0, [r4, #24]
c0d054aa:	e787      	b.n	c0d053bc <u2f_transport_received+0x108>
            // Overflow in message size, abort
            u2f_transport_error(service, ERROR_INVALID_LEN);
            goto error;
        }
        // Check if the command is supported
        switch (buffer[channelHeader]) {
c0d054ac:	9803      	ldr	r0, [sp, #12]
c0d054ae:	7800      	ldrb	r0, [r0, #0]
c0d054b0:	2881      	cmp	r0, #129	; 0x81
c0d054b2:	9b02      	ldr	r3, [sp, #8]
c0d054b4:	9d06      	ldr	r5, [sp, #24]
c0d054b6:	d004      	beq.n	c0d054c2 <u2f_transport_received+0x20e>
c0d054b8:	2886      	cmp	r0, #134	; 0x86
c0d054ba:	d04c      	beq.n	c0d05556 <u2f_transport_received+0x2a2>
c0d054bc:	2883      	cmp	r0, #131	; 0x83
c0d054be:	d000      	beq.n	c0d054c2 <u2f_transport_received+0x20e>
c0d054c0:	e084      	b.n	c0d055cc <u2f_transport_received+0x318>
c0d054c2:	9200      	str	r2, [sp, #0]
        case U2F_CMD_PING:
        case U2F_CMD_MSG:
            if (media == U2F_MEDIA_USB) {
c0d054c4:	2d01      	cmp	r5, #1
c0d054c6:	d152      	bne.n	c0d0556e <u2f_transport_received+0x2ba>
error:
    return;
}

bool u2f_is_channel_broadcast(uint8_t *channel) {
    return (os_memcmp(channel, BROADCAST_CHANNEL, 4) == 0);
c0d054c8:	495b      	ldr	r1, [pc, #364]	; (c0d05638 <u2f_transport_received+0x384>)
c0d054ca:	4479      	add	r1, pc
c0d054cc:	2204      	movs	r2, #4
c0d054ce:	4620      	mov	r0, r4
c0d054d0:	9204      	str	r2, [sp, #16]
c0d054d2:	f7fe fc19 	bl	c0d03d08 <os_memcmp>
        // Check if the command is supported
        switch (buffer[channelHeader]) {
        case U2F_CMD_PING:
        case U2F_CMD_MSG:
            if (media == U2F_MEDIA_USB) {
                if (u2f_is_channel_broadcast(service->channel) ||
c0d054d6:	2800      	cmp	r0, #0
c0d054d8:	d100      	bne.n	c0d054dc <u2f_transport_received+0x228>
c0d054da:	e0a0      	b.n	c0d0561e <u2f_transport_received+0x36a>
bool u2f_is_channel_broadcast(uint8_t *channel) {
    return (os_memcmp(channel, BROADCAST_CHANNEL, 4) == 0);
}

bool u2f_is_channel_forbidden(uint8_t *channel) {
    return (os_memcmp(channel, FORBIDDEN_CHANNEL, 4) == 0);
c0d054dc:	4957      	ldr	r1, [pc, #348]	; (c0d0563c <u2f_transport_received+0x388>)
c0d054de:	4479      	add	r1, pc
c0d054e0:	2204      	movs	r2, #4
c0d054e2:	4620      	mov	r0, r4
c0d054e4:	e03f      	b.n	c0d05566 <u2f_transport_received+0x2b2>
                u2f_transport_error(service, ERROR_CHANNEL_BUSY);
                goto error;
            }
        }
        // also discriminate invalid command sent instead of a continuation
        if (buffer[channelHeader] != service->transportPacketIndex) {
c0d054e6:	19d1      	adds	r1, r2, r7
c0d054e8:	5dd0      	ldrb	r0, [r2, r7]
c0d054ea:	7da2      	ldrb	r2, [r4, #22]
c0d054ec:	4290      	cmp	r0, r2
c0d054ee:	d115      	bne.n	c0d0551c <u2f_transport_received+0x268>
c0d054f0:	9302      	str	r3, [sp, #8]
            // Bad continuation packet, abort
            u2f_transport_error(service, ERROR_INVALID_SEQ);
            goto error;
        }
        xfer_len = MIN(size - (channelHeader + 1), service->transportLength - service->transportOffset);
c0d054f2:	9804      	ldr	r0, [sp, #16]
c0d054f4:	1a36      	subs	r6, r6, r0
c0d054f6:	8a60      	ldrh	r0, [r4, #18]
c0d054f8:	8aa2      	ldrh	r2, [r4, #20]
c0d054fa:	1a12      	subs	r2, r2, r0
c0d054fc:	4296      	cmp	r6, r2
c0d054fe:	db00      	blt.n	c0d05502 <u2f_transport_received+0x24e>
c0d05500:	4616      	mov	r6, r2
        os_memmove(service->transportBuffer + service->transportOffset, buffer + channelHeader + 1, xfer_len);
c0d05502:	b2b2      	uxth	r2, r6
c0d05504:	69a3      	ldr	r3, [r4, #24]
c0d05506:	1818      	adds	r0, r3, r0
c0d05508:	1c49      	adds	r1, r1, #1
c0d0550a:	f7fe fb42 	bl	c0d03b92 <os_memmove>
        service->transportOffset += xfer_len;
c0d0550e:	8a60      	ldrh	r0, [r4, #18]
c0d05510:	1980      	adds	r0, r0, r6
c0d05512:	8260      	strh	r0, [r4, #18]
        service->transportPacketIndex++;
c0d05514:	7da0      	ldrb	r0, [r4, #22]
c0d05516:	1c40      	adds	r0, r0, #1
c0d05518:	75a0      	strb	r0, [r4, #22]
c0d0551a:	e03e      	b.n	c0d0559a <u2f_transport_received+0x2e6>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d0551c:	4845      	ldr	r0, [pc, #276]	; (c0d05634 <u2f_transport_received+0x380>)
c0d0551e:	2104      	movs	r1, #4
c0d05520:	7201      	strb	r1, [r0, #8]
c0d05522:	227a      	movs	r2, #122	; 0x7a
c0d05524:	43d2      	mvns	r2, r2
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d05526:	323a      	adds	r2, #58	; 0x3a
c0d05528:	461d      	mov	r5, r3
c0d0552a:	2334      	movs	r3, #52	; 0x34
c0d0552c:	54e2      	strb	r2, [r4, r3]
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
c0d0552e:	75a5      	strb	r5, [r4, #22]
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d05530:	7721      	strb	r1, [r4, #28]
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d05532:	3008      	adds	r0, #8

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
c0d05534:	61a0      	str	r0, [r4, #24]
    service->transportOffset = 0;
c0d05536:	8265      	strh	r5, [r4, #18]
c0d05538:	e73a      	b.n	c0d053b0 <u2f_transport_received+0xfc>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d0553a:	483e      	ldr	r0, [pc, #248]	; (c0d05634 <u2f_transport_received+0x380>)
c0d0553c:	2104      	movs	r1, #4
c0d0553e:	7201      	strb	r1, [r0, #8]
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d05540:	323a      	adds	r2, #58	; 0x3a
c0d05542:	4613      	mov	r3, r2
c0d05544:	2234      	movs	r2, #52	; 0x34
c0d05546:	54a3      	strb	r3, [r4, r2]
c0d05548:	9a02      	ldr	r2, [sp, #8]
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
c0d0554a:	75a2      	strb	r2, [r4, #22]
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d0554c:	7721      	strb	r1, [r4, #28]
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d0554e:	3008      	adds	r0, #8

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
c0d05550:	61a0      	str	r0, [r4, #24]
    service->transportOffset = 0;
c0d05552:	8262      	strh	r2, [r4, #18]
c0d05554:	e72c      	b.n	c0d053b0 <u2f_transport_received+0xfc>
                }
            }
            // no channel for BLE
            break;
        case U2F_CMD_INIT:
            if (media != U2F_MEDIA_USB) {
c0d05556:	2d01      	cmp	r5, #1
c0d05558:	d138      	bne.n	c0d055cc <u2f_transport_received+0x318>
c0d0555a:	9200      	str	r2, [sp, #0]
bool u2f_is_channel_broadcast(uint8_t *channel) {
    return (os_memcmp(channel, BROADCAST_CHANNEL, 4) == 0);
}

bool u2f_is_channel_forbidden(uint8_t *channel) {
    return (os_memcmp(channel, FORBIDDEN_CHANNEL, 4) == 0);
c0d0555c:	4938      	ldr	r1, [pc, #224]	; (c0d05640 <u2f_transport_received+0x38c>)
c0d0555e:	4479      	add	r1, pc
c0d05560:	2204      	movs	r2, #4
c0d05562:	4620      	mov	r0, r4
c0d05564:	9204      	str	r2, [sp, #16]
c0d05566:	f7fe fbcf 	bl	c0d03d08 <os_memcmp>
c0d0556a:	2800      	cmp	r0, #0
c0d0556c:	d057      	beq.n	c0d0561e <u2f_transport_received+0x36a>
        }

        // Ok, initialize the buffer
        //if (buffer[channelHeader] != U2F_CMD_INIT) 
        {
            xfer_len = MIN(size - (channelHeader), U2F_COMMAND_HEADER_SIZE+commandLength);
c0d0556e:	9805      	ldr	r0, [sp, #20]
c0d05570:	1a36      	subs	r6, r6, r0
c0d05572:	1cff      	adds	r7, r7, #3
c0d05574:	42be      	cmp	r6, r7
c0d05576:	db00      	blt.n	c0d0557a <u2f_transport_received+0x2c6>
c0d05578:	463e      	mov	r6, r7
            os_memmove(service->transportBuffer, buffer + channelHeader, xfer_len);
c0d0557a:	b2b2      	uxth	r2, r6
c0d0557c:	69a0      	ldr	r0, [r4, #24]
c0d0557e:	9903      	ldr	r1, [sp, #12]
c0d05580:	f7fe fb07 	bl	c0d03b92 <os_memmove>
            service->transportOffset = xfer_len;
            service->transportLength = U2F_COMMAND_HEADER_SIZE+commandLength;
c0d05584:	82a7      	strh	r7, [r4, #20]
        // Ok, initialize the buffer
        //if (buffer[channelHeader] != U2F_CMD_INIT) 
        {
            xfer_len = MIN(size - (channelHeader), U2F_COMMAND_HEADER_SIZE+commandLength);
            os_memmove(service->transportBuffer, buffer + channelHeader, xfer_len);
            service->transportOffset = xfer_len;
c0d05586:	8266      	strh	r6, [r4, #18]
            service->transportLength = U2F_COMMAND_HEADER_SIZE+commandLength;
            service->transportMedia = media;
c0d05588:	7765      	strb	r5, [r4, #29]
            // initialize the response
            service->transportPacketIndex = 0;
c0d0558a:	9802      	ldr	r0, [sp, #8]
c0d0558c:	75a0      	strb	r0, [r4, #22]
            os_memmove(service->transportChannel, service->channel, 4);
c0d0558e:	4620      	mov	r0, r4
c0d05590:	300e      	adds	r0, #14
c0d05592:	2204      	movs	r2, #4
c0d05594:	4621      	mov	r1, r4
c0d05596:	f7fe fafc 	bl	c0d03b92 <os_memmove>
c0d0559a:	8a60      	ldrh	r0, [r4, #18]
        os_memmove(service->transportBuffer + service->transportOffset, buffer + channelHeader + 1, xfer_len);
        service->transportOffset += xfer_len;
        service->transportPacketIndex++;
    }
    // See if we can process the command
    if ((media != U2F_MEDIA_USB) &&
c0d0559c:	2d01      	cmp	r5, #1
c0d0559e:	d101      	bne.n	c0d055a4 <u2f_transport_received+0x2f0>
        (service->transportOffset >
         (service->transportLength + U2F_COMMAND_HEADER_SIZE))) {
        // Overflow, abort
        u2f_transport_error(service, ERROR_INVALID_LEN);
        goto error;
    } else if (service->transportOffset >= service->transportLength) {
c0d055a0:	8aa1      	ldrh	r1, [r4, #20]
c0d055a2:	e00c      	b.n	c0d055be <u2f_transport_received+0x30a>
        service->transportPacketIndex++;
    }
    // See if we can process the command
    if ((media != U2F_MEDIA_USB) &&
        (service->transportOffset >
         (service->transportLength + U2F_COMMAND_HEADER_SIZE))) {
c0d055a4:	8aa1      	ldrh	r1, [r4, #20]
c0d055a6:	1cca      	adds	r2, r1, #3
        os_memmove(service->transportBuffer + service->transportOffset, buffer + channelHeader + 1, xfer_len);
        service->transportOffset += xfer_len;
        service->transportPacketIndex++;
    }
    // See if we can process the command
    if ((media != U2F_MEDIA_USB) &&
c0d055a8:	4282      	cmp	r2, r0
c0d055aa:	d208      	bcs.n	c0d055be <u2f_transport_received+0x30a>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d055ac:	4821      	ldr	r0, [pc, #132]	; (c0d05634 <u2f_transport_received+0x380>)
c0d055ae:	2103      	movs	r1, #3
c0d055b0:	7201      	strb	r1, [r0, #8]
c0d055b2:	217a      	movs	r1, #122	; 0x7a
c0d055b4:	43c9      	mvns	r1, r1
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d055b6:	313a      	adds	r1, #58	; 0x3a
c0d055b8:	2234      	movs	r2, #52	; 0x34
c0d055ba:	54a1      	strb	r1, [r4, r2]
c0d055bc:	e75a      	b.n	c0d05474 <u2f_transport_received+0x1c0>
        (service->transportOffset >
         (service->transportLength + U2F_COMMAND_HEADER_SIZE))) {
        // Overflow, abort
        u2f_transport_error(service, ERROR_INVALID_LEN);
        goto error;
    } else if (service->transportOffset >= service->transportLength) {
c0d055be:	4288      	cmp	r0, r1
c0d055c0:	d213      	bcs.n	c0d055ea <u2f_transport_received+0x336>
c0d055c2:	2001      	movs	r0, #1
        // internal notification of a complete message received
        u2f_message_complete(service);
    } else {
        // new segment received, reset the timeout for the current piece
        service->seqTimeout = 0;
        service->transportState = U2F_HANDLE_SEGMENTED;
c0d055c4:	7720      	strb	r0, [r4, #28]
c0d055c6:	2000      	movs	r0, #0
        service->transportState = U2F_PROCESSING_COMMAND;
        // internal notification of a complete message received
        u2f_message_complete(service);
    } else {
        // new segment received, reset the timeout for the current piece
        service->seqTimeout = 0;
c0d055c8:	62a0      	str	r0, [r4, #40]	; 0x28
c0d055ca:	e6f7      	b.n	c0d053bc <u2f_transport_received+0x108>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d055cc:	4819      	ldr	r0, [pc, #100]	; (c0d05634 <u2f_transport_received+0x380>)
c0d055ce:	2101      	movs	r1, #1
c0d055d0:	7201      	strb	r1, [r0, #8]
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d055d2:	323a      	adds	r2, #58	; 0x3a
c0d055d4:	4615      	mov	r5, r2
c0d055d6:	2234      	movs	r2, #52	; 0x34
c0d055d8:	54a5      	strb	r5, [r4, r2]
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
c0d055da:	75a3      	strb	r3, [r4, #22]
c0d055dc:	2204      	movs	r2, #4
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d055de:	7722      	strb	r2, [r4, #28]
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d055e0:	3008      	adds	r0, #8

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
c0d055e2:	61a0      	str	r0, [r4, #24]
    service->transportOffset = 0;
c0d055e4:	8263      	strh	r3, [r4, #18]
    service->transportLength = 1;
c0d055e6:	82a1      	strh	r1, [r4, #20]
c0d055e8:	e6e4      	b.n	c0d053b4 <u2f_transport_received+0x100>
c0d055ea:	2002      	movs	r0, #2
        // Overflow, abort
        u2f_transport_error(service, ERROR_INVALID_LEN);
        goto error;
    } else if (service->transportOffset >= service->transportLength) {
        // switch before the handler gets the opportunity to change it again
        service->transportState = U2F_PROCESSING_COMMAND;
c0d055ec:	7720      	strb	r0, [r4, #28]
        // internal notification of a complete message received
        u2f_message_complete(service);
c0d055ee:	4620      	mov	r0, r4
c0d055f0:	f7ff fdba 	bl	c0d05168 <u2f_message_complete>
c0d055f4:	e6e2      	b.n	c0d053bc <u2f_transport_received+0x108>
                // special error case, we reply but don't change the current state of the transport (ongoing message for example)
                //u2f_transport_error_no_reset(service, ERROR_CHANNEL_BUSY);
                uint16_t offset = 0;
                // Fragment
                if (media == U2F_MEDIA_USB) {
                    os_memmove(G_io_usb_ep_buffer, service->channel, 4);
c0d055f6:	4d0f      	ldr	r5, [pc, #60]	; (c0d05634 <u2f_transport_received+0x380>)
c0d055f8:	4616      	mov	r6, r2
c0d055fa:	2204      	movs	r2, #4
c0d055fc:	4628      	mov	r0, r5
c0d055fe:	4621      	mov	r1, r4
c0d05600:	f7fe fac7 	bl	c0d03b92 <os_memmove>
                    offset += 4;
                }
                G_io_usb_ep_buffer[offset++] = U2F_STATUS_ERROR;
                G_io_usb_ep_buffer[offset++] = 0;
c0d05604:	9802      	ldr	r0, [sp, #8]
c0d05606:	7168      	strb	r0, [r5, #5]
                // Fragment
                if (media == U2F_MEDIA_USB) {
                    os_memmove(G_io_usb_ep_buffer, service->channel, 4);
                    offset += 4;
                }
                G_io_usb_ep_buffer[offset++] = U2F_STATUS_ERROR;
c0d05608:	363a      	adds	r6, #58	; 0x3a
c0d0560a:	712e      	strb	r6, [r5, #4]
c0d0560c:	2201      	movs	r2, #1
                G_io_usb_ep_buffer[offset++] = 0;
                G_io_usb_ep_buffer[offset++] = 1;
c0d0560e:	71aa      	strb	r2, [r5, #6]
c0d05610:	2006      	movs	r0, #6
                G_io_usb_ep_buffer[offset++] = ERROR_CHANNEL_BUSY;
c0d05612:	71e8      	strb	r0, [r5, #7]
c0d05614:	2108      	movs	r1, #8
                u2f_io_send(G_io_usb_ep_buffer, offset, media);
c0d05616:	4628      	mov	r0, r5
c0d05618:	f7ff fdc4 	bl	c0d051a4 <u2f_io_send>
c0d0561c:	e6ce      	b.n	c0d053bc <u2f_transport_received+0x108>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d0561e:	4805      	ldr	r0, [pc, #20]	; (c0d05634 <u2f_transport_received+0x380>)
c0d05620:	210b      	movs	r1, #11
c0d05622:	7201      	strb	r1, [r0, #8]
c0d05624:	9a00      	ldr	r2, [sp, #0]
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d05626:	323a      	adds	r2, #58	; 0x3a
c0d05628:	2134      	movs	r1, #52	; 0x34
c0d0562a:	5462      	strb	r2, [r4, r1]
c0d0562c:	9902      	ldr	r1, [sp, #8]
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
c0d0562e:	75a1      	strb	r1, [r4, #22]
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d05630:	9a04      	ldr	r2, [sp, #16]
c0d05632:	e654      	b.n	c0d052de <u2f_transport_received+0x2a>
c0d05634:	20002370 	.word	0x20002370
c0d05638:	00002864 	.word	0x00002864
c0d0563c:	00002854 	.word	0x00002854
c0d05640:	000027d4 	.word	0x000027d4

c0d05644 <u2f_is_channel_broadcast>:
    }
error:
    return;
}

bool u2f_is_channel_broadcast(uint8_t *channel) {
c0d05644:	b580      	push	{r7, lr}
    return (os_memcmp(channel, BROADCAST_CHANNEL, 4) == 0);
c0d05646:	4904      	ldr	r1, [pc, #16]	; (c0d05658 <u2f_is_channel_broadcast+0x14>)
c0d05648:	4479      	add	r1, pc
c0d0564a:	2204      	movs	r2, #4
c0d0564c:	f7fe fb5c 	bl	c0d03d08 <os_memcmp>
c0d05650:	2100      	movs	r1, #0
c0d05652:	1a09      	subs	r1, r1, r0
c0d05654:	4148      	adcs	r0, r1
c0d05656:	bd80      	pop	{r7, pc}
c0d05658:	000026e6 	.word	0x000026e6

c0d0565c <u2f_message_reply>:

bool u2f_is_channel_forbidden(uint8_t *channel) {
    return (os_memcmp(channel, FORBIDDEN_CHANNEL, 4) == 0);
}

void u2f_message_reply(u2f_service_t *service, uint8_t cmd, uint8_t *buffer, uint16_t len) {
c0d0565c:	b510      	push	{r4, lr}
c0d0565e:	2434      	movs	r4, #52	; 0x34
    service->transportState = U2F_SENDING_RESPONSE;
    service->transportPacketIndex = 0;
    service->transportBuffer = buffer;
    service->transportOffset = 0;
    service->transportLength = len;
    service->sendCmd = cmd;
c0d05660:	5501      	strb	r1, [r0, r4]
c0d05662:	2100      	movs	r1, #0
    return (os_memcmp(channel, FORBIDDEN_CHANNEL, 4) == 0);
}

void u2f_message_reply(u2f_service_t *service, uint8_t cmd, uint8_t *buffer, uint16_t len) {
    service->transportState = U2F_SENDING_RESPONSE;
    service->transportPacketIndex = 0;
c0d05664:	7581      	strb	r1, [r0, #22]
c0d05666:	2403      	movs	r4, #3
bool u2f_is_channel_forbidden(uint8_t *channel) {
    return (os_memcmp(channel, FORBIDDEN_CHANNEL, 4) == 0);
}

void u2f_message_reply(u2f_service_t *service, uint8_t cmd, uint8_t *buffer, uint16_t len) {
    service->transportState = U2F_SENDING_RESPONSE;
c0d05668:	7704      	strb	r4, [r0, #28]
    service->transportPacketIndex = 0;
    service->transportBuffer = buffer;
c0d0566a:	6182      	str	r2, [r0, #24]
    service->transportOffset = 0;
c0d0566c:	8241      	strh	r1, [r0, #18]
    service->transportLength = len;
c0d0566e:	8283      	strh	r3, [r0, #20]
    service->sendCmd = cmd;
    // pump the first message
    u2f_transport_sent(service, service->transportMedia);
c0d05670:	7f41      	ldrb	r1, [r0, #29]
c0d05672:	f7ff fdb9 	bl	c0d051e8 <u2f_transport_sent>
}
c0d05676:	bd10      	pop	{r4, pc}

c0d05678 <USBD_LL_Init>:
  */
USBD_StatusTypeDef  USBD_LL_Init (USBD_HandleTypeDef *pdev)
{ 
  UNUSED(pdev);
  ep_in_stall = 0;
  ep_out_stall = 0;
c0d05678:	4902      	ldr	r1, [pc, #8]	; (c0d05684 <USBD_LL_Init+0xc>)
c0d0567a:	2000      	movs	r0, #0
c0d0567c:	6008      	str	r0, [r1, #0]
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Init (USBD_HandleTypeDef *pdev)
{ 
  UNUSED(pdev);
  ep_in_stall = 0;
c0d0567e:	4902      	ldr	r1, [pc, #8]	; (c0d05688 <USBD_LL_Init+0x10>)
c0d05680:	6008      	str	r0, [r1, #0]
  ep_out_stall = 0;
  return USBD_OK;
c0d05682:	4770      	bx	lr
c0d05684:	200023b4 	.word	0x200023b4
c0d05688:	200023b0 	.word	0x200023b0

c0d0568c <USBD_LL_DeInit>:
  * @brief  De-Initializes the Low Level portion of the Device driver.
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_DeInit (USBD_HandleTypeDef *pdev)
{
c0d0568c:	b510      	push	{r4, lr}
  UNUSED(pdev);
  // usb off
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d0568e:	4807      	ldr	r0, [pc, #28]	; (c0d056ac <USBD_LL_DeInit+0x20>)
c0d05690:	2400      	movs	r4, #0
  G_io_seproxyhal_spi_buffer[1] = 0;
c0d05692:	7044      	strb	r4, [r0, #1]
c0d05694:	214f      	movs	r1, #79	; 0x4f
  */
USBD_StatusTypeDef  USBD_LL_DeInit (USBD_HandleTypeDef *pdev)
{
  UNUSED(pdev);
  // usb off
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d05696:	7001      	strb	r1, [r0, #0]
c0d05698:	2101      	movs	r1, #1
  G_io_seproxyhal_spi_buffer[1] = 0;
  G_io_seproxyhal_spi_buffer[2] = 1;
c0d0569a:	7081      	strb	r1, [r0, #2]
c0d0569c:	2102      	movs	r1, #2
  G_io_seproxyhal_spi_buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_DISCONNECT;
c0d0569e:	70c1      	strb	r1, [r0, #3]
c0d056a0:	2104      	movs	r1, #4
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 4);
c0d056a2:	f7ff fbf7 	bl	c0d04e94 <io_seproxyhal_spi_send>

  return USBD_OK; 
c0d056a6:	4620      	mov	r0, r4
c0d056a8:	bd10      	pop	{r4, pc}
c0d056aa:	46c0      	nop			; (mov r8, r8)
c0d056ac:	20001800 	.word	0x20001800

c0d056b0 <USBD_LL_Start>:
  * @brief  Starts the Low Level portion of the Device driver. 
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Start(USBD_HandleTypeDef *pdev)
{
c0d056b0:	b570      	push	{r4, r5, r6, lr}
c0d056b2:	b082      	sub	sp, #8
c0d056b4:	466d      	mov	r5, sp
c0d056b6:	2400      	movs	r4, #0
  uint8_t buffer[5];
  UNUSED(pdev);

  // reset address
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
  buffer[1] = 0;
c0d056b8:	706c      	strb	r4, [r5, #1]
c0d056ba:	264f      	movs	r6, #79	; 0x4f
{
  uint8_t buffer[5];
  UNUSED(pdev);

  // reset address
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d056bc:	702e      	strb	r6, [r5, #0]
c0d056be:	2002      	movs	r0, #2
  buffer[1] = 0;
  buffer[2] = 2;
c0d056c0:	70a8      	strb	r0, [r5, #2]
c0d056c2:	2003      	movs	r0, #3
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ADDR;
c0d056c4:	70e8      	strb	r0, [r5, #3]
  buffer[4] = 0;
c0d056c6:	712c      	strb	r4, [r5, #4]
c0d056c8:	2105      	movs	r1, #5
  io_seproxyhal_spi_send(buffer, 5);
c0d056ca:	4628      	mov	r0, r5
c0d056cc:	f7ff fbe2 	bl	c0d04e94 <io_seproxyhal_spi_send>
  
  // start usb operation
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
  buffer[1] = 0;
c0d056d0:	706c      	strb	r4, [r5, #1]
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ADDR;
  buffer[4] = 0;
  io_seproxyhal_spi_send(buffer, 5);
  
  // start usb operation
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d056d2:	702e      	strb	r6, [r5, #0]
c0d056d4:	2001      	movs	r0, #1
  buffer[1] = 0;
  buffer[2] = 1;
c0d056d6:	70a8      	strb	r0, [r5, #2]
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_CONNECT;
c0d056d8:	70e8      	strb	r0, [r5, #3]
c0d056da:	2104      	movs	r1, #4
  io_seproxyhal_spi_send(buffer, 4);
c0d056dc:	4628      	mov	r0, r5
c0d056de:	f7ff fbd9 	bl	c0d04e94 <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d056e2:	4620      	mov	r0, r4
c0d056e4:	b002      	add	sp, #8
c0d056e6:	bd70      	pop	{r4, r5, r6, pc}

c0d056e8 <USBD_LL_Stop>:
  * @brief  Stops the Low Level portion of the Device driver.
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Stop (USBD_HandleTypeDef *pdev)
{
c0d056e8:	b510      	push	{r4, lr}
c0d056ea:	b082      	sub	sp, #8
c0d056ec:	a801      	add	r0, sp, #4
c0d056ee:	2400      	movs	r4, #0
  UNUSED(pdev);
  uint8_t buffer[4];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
  buffer[1] = 0;
c0d056f0:	7044      	strb	r4, [r0, #1]
c0d056f2:	214f      	movs	r1, #79	; 0x4f
  */
USBD_StatusTypeDef  USBD_LL_Stop (USBD_HandleTypeDef *pdev)
{
  UNUSED(pdev);
  uint8_t buffer[4];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d056f4:	7001      	strb	r1, [r0, #0]
c0d056f6:	2101      	movs	r1, #1
  buffer[1] = 0;
  buffer[2] = 1;
c0d056f8:	7081      	strb	r1, [r0, #2]
c0d056fa:	2102      	movs	r1, #2
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_DISCONNECT;
c0d056fc:	70c1      	strb	r1, [r0, #3]
c0d056fe:	2104      	movs	r1, #4
  io_seproxyhal_spi_send(buffer, 4);
c0d05700:	f7ff fbc8 	bl	c0d04e94 <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d05704:	4620      	mov	r0, r4
c0d05706:	b002      	add	sp, #8
c0d05708:	bd10      	pop	{r4, pc}
	...

c0d0570c <USBD_LL_OpenEP>:
  */
USBD_StatusTypeDef  USBD_LL_OpenEP  (USBD_HandleTypeDef *pdev, 
                                      uint8_t  ep_addr,                                      
                                      uint8_t  ep_type,
                                      uint16_t ep_mps)
{
c0d0570c:	b5b0      	push	{r4, r5, r7, lr}
c0d0570e:	b082      	sub	sp, #8
  uint8_t buffer[8];
  UNUSED(pdev);

  ep_in_stall = 0;
  ep_out_stall = 0;
c0d05710:	4814      	ldr	r0, [pc, #80]	; (c0d05764 <USBD_LL_OpenEP+0x58>)
c0d05712:	2400      	movs	r4, #0
c0d05714:	6004      	str	r4, [r0, #0]
                                      uint16_t ep_mps)
{
  uint8_t buffer[8];
  UNUSED(pdev);

  ep_in_stall = 0;
c0d05716:	4814      	ldr	r0, [pc, #80]	; (c0d05768 <USBD_LL_OpenEP+0x5c>)
c0d05718:	6004      	str	r4, [r0, #0]
c0d0571a:	466d      	mov	r5, sp
c0d0571c:	204f      	movs	r0, #79	; 0x4f
  ep_out_stall = 0;

  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d0571e:	7028      	strb	r0, [r5, #0]
  buffer[1] = 0;
c0d05720:	706c      	strb	r4, [r5, #1]
c0d05722:	2005      	movs	r0, #5
  buffer[2] = 5;
c0d05724:	70a8      	strb	r0, [r5, #2]
c0d05726:	2004      	movs	r0, #4
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ENDPOINTS;
c0d05728:	70e8      	strb	r0, [r5, #3]
c0d0572a:	2001      	movs	r0, #1
  buffer[4] = 1;
c0d0572c:	7128      	strb	r0, [r5, #4]
  buffer[5] = ep_addr;
c0d0572e:	7169      	strb	r1, [r5, #5]
  buffer[6] = 0;
c0d05730:	71ac      	strb	r4, [r5, #6]
  switch(ep_type) {
c0d05732:	2a01      	cmp	r2, #1
c0d05734:	dc05      	bgt.n	c0d05742 <USBD_LL_OpenEP+0x36>
c0d05736:	2a00      	cmp	r2, #0
c0d05738:	d00a      	beq.n	c0d05750 <USBD_LL_OpenEP+0x44>
c0d0573a:	2a01      	cmp	r2, #1
c0d0573c:	d10a      	bne.n	c0d05754 <USBD_LL_OpenEP+0x48>
c0d0573e:	2004      	movs	r0, #4
c0d05740:	e006      	b.n	c0d05750 <USBD_LL_OpenEP+0x44>
c0d05742:	2a02      	cmp	r2, #2
c0d05744:	d003      	beq.n	c0d0574e <USBD_LL_OpenEP+0x42>
c0d05746:	2a03      	cmp	r2, #3
c0d05748:	d104      	bne.n	c0d05754 <USBD_LL_OpenEP+0x48>
c0d0574a:	2002      	movs	r0, #2
c0d0574c:	e000      	b.n	c0d05750 <USBD_LL_OpenEP+0x44>
c0d0574e:	2003      	movs	r0, #3
c0d05750:	4669      	mov	r1, sp
c0d05752:	7188      	strb	r0, [r1, #6]
c0d05754:	4668      	mov	r0, sp
      break;
    case USBD_EP_TYPE_INTR:
      buffer[6] = SEPROXYHAL_TAG_USB_CONFIG_TYPE_INTERRUPT;
      break;
  }
  buffer[7] = ep_mps;
c0d05756:	71c3      	strb	r3, [r0, #7]
c0d05758:	2108      	movs	r1, #8
  io_seproxyhal_spi_send(buffer, 8);
c0d0575a:	f7ff fb9b 	bl	c0d04e94 <io_seproxyhal_spi_send>
c0d0575e:	2000      	movs	r0, #0
  return USBD_OK; 
c0d05760:	b002      	add	sp, #8
c0d05762:	bdb0      	pop	{r4, r5, r7, pc}
c0d05764:	200023b4 	.word	0x200023b4
c0d05768:	200023b0 	.word	0x200023b0

c0d0576c <USBD_LL_CloseEP>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_CloseEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
c0d0576c:	b510      	push	{r4, lr}
c0d0576e:	b082      	sub	sp, #8
c0d05770:	4668      	mov	r0, sp
c0d05772:	2400      	movs	r4, #0
  UNUSED(pdev);
  uint8_t buffer[8];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
  buffer[1] = 0;
c0d05774:	7044      	strb	r4, [r0, #1]
c0d05776:	224f      	movs	r2, #79	; 0x4f
  */
USBD_StatusTypeDef  USBD_LL_CloseEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
  UNUSED(pdev);
  uint8_t buffer[8];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d05778:	7002      	strb	r2, [r0, #0]
c0d0577a:	2205      	movs	r2, #5
  buffer[1] = 0;
  buffer[2] = 5;
c0d0577c:	7082      	strb	r2, [r0, #2]
c0d0577e:	2204      	movs	r2, #4
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ENDPOINTS;
c0d05780:	70c2      	strb	r2, [r0, #3]
c0d05782:	2201      	movs	r2, #1
  buffer[4] = 1;
c0d05784:	7102      	strb	r2, [r0, #4]
  buffer[5] = ep_addr;
c0d05786:	7141      	strb	r1, [r0, #5]
  buffer[6] = SEPROXYHAL_TAG_USB_CONFIG_TYPE_DISABLED;
c0d05788:	7184      	strb	r4, [r0, #6]
  buffer[7] = 0;
c0d0578a:	71c4      	strb	r4, [r0, #7]
c0d0578c:	2108      	movs	r1, #8
  io_seproxyhal_spi_send(buffer, 8);
c0d0578e:	f7ff fb81 	bl	c0d04e94 <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d05792:	4620      	mov	r0, r4
c0d05794:	b002      	add	sp, #8
c0d05796:	bd10      	pop	{r4, pc}

c0d05798 <USBD_LL_StallEP>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_StallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{ 
c0d05798:	b5b0      	push	{r4, r5, r7, lr}
c0d0579a:	b082      	sub	sp, #8
c0d0579c:	460d      	mov	r5, r1
c0d0579e:	4668      	mov	r0, sp
c0d057a0:	2400      	movs	r4, #0
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
  buffer[1] = 0;
c0d057a2:	7044      	strb	r4, [r0, #1]
c0d057a4:	2150      	movs	r1, #80	; 0x50
  */
USBD_StatusTypeDef  USBD_LL_StallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{ 
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d057a6:	7001      	strb	r1, [r0, #0]
c0d057a8:	2103      	movs	r1, #3
  buffer[1] = 0;
  buffer[2] = 3;
c0d057aa:	7081      	strb	r1, [r0, #2]
  buffer[3] = ep_addr;
c0d057ac:	70c5      	strb	r5, [r0, #3]
c0d057ae:	2140      	movs	r1, #64	; 0x40
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_STALL;
c0d057b0:	7101      	strb	r1, [r0, #4]
  buffer[5] = 0;
c0d057b2:	7144      	strb	r4, [r0, #5]
c0d057b4:	2106      	movs	r1, #6
  io_seproxyhal_spi_send(buffer, 6);
c0d057b6:	f7ff fb6d 	bl	c0d04e94 <io_seproxyhal_spi_send>
  if (ep_addr & 0x80) {
c0d057ba:	0628      	lsls	r0, r5, #24
c0d057bc:	d501      	bpl.n	c0d057c2 <USBD_LL_StallEP+0x2a>
c0d057be:	4807      	ldr	r0, [pc, #28]	; (c0d057dc <USBD_LL_StallEP+0x44>)
c0d057c0:	e000      	b.n	c0d057c4 <USBD_LL_StallEP+0x2c>
c0d057c2:	4805      	ldr	r0, [pc, #20]	; (c0d057d8 <USBD_LL_StallEP+0x40>)
c0d057c4:	6801      	ldr	r1, [r0, #0]
c0d057c6:	227f      	movs	r2, #127	; 0x7f
c0d057c8:	4015      	ands	r5, r2
c0d057ca:	2201      	movs	r2, #1
c0d057cc:	40aa      	lsls	r2, r5
c0d057ce:	430a      	orrs	r2, r1
c0d057d0:	6002      	str	r2, [r0, #0]
    ep_in_stall |= (1<<(ep_addr&0x7F));
  }
  else {
    ep_out_stall |= (1<<(ep_addr&0x7F)); 
  }
  return USBD_OK; 
c0d057d2:	4620      	mov	r0, r4
c0d057d4:	b002      	add	sp, #8
c0d057d6:	bdb0      	pop	{r4, r5, r7, pc}
c0d057d8:	200023b4 	.word	0x200023b4
c0d057dc:	200023b0 	.word	0x200023b0

c0d057e0 <USBD_LL_ClearStallEP>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_ClearStallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
c0d057e0:	b5b0      	push	{r4, r5, r7, lr}
c0d057e2:	b082      	sub	sp, #8
c0d057e4:	460d      	mov	r5, r1
c0d057e6:	4668      	mov	r0, sp
c0d057e8:	2400      	movs	r4, #0
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
  buffer[1] = 0;
c0d057ea:	7044      	strb	r4, [r0, #1]
c0d057ec:	2150      	movs	r1, #80	; 0x50
  */
USBD_StatusTypeDef  USBD_LL_ClearStallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d057ee:	7001      	strb	r1, [r0, #0]
c0d057f0:	2103      	movs	r1, #3
  buffer[1] = 0;
  buffer[2] = 3;
c0d057f2:	7081      	strb	r1, [r0, #2]
  buffer[3] = ep_addr;
c0d057f4:	70c5      	strb	r5, [r0, #3]
c0d057f6:	2180      	movs	r1, #128	; 0x80
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_UNSTALL;
c0d057f8:	7101      	strb	r1, [r0, #4]
  buffer[5] = 0;
c0d057fa:	7144      	strb	r4, [r0, #5]
c0d057fc:	2106      	movs	r1, #6
  io_seproxyhal_spi_send(buffer, 6);
c0d057fe:	f7ff fb49 	bl	c0d04e94 <io_seproxyhal_spi_send>
  if (ep_addr & 0x80) {
c0d05802:	0628      	lsls	r0, r5, #24
c0d05804:	d501      	bpl.n	c0d0580a <USBD_LL_ClearStallEP+0x2a>
c0d05806:	4807      	ldr	r0, [pc, #28]	; (c0d05824 <USBD_LL_ClearStallEP+0x44>)
c0d05808:	e000      	b.n	c0d0580c <USBD_LL_ClearStallEP+0x2c>
c0d0580a:	4805      	ldr	r0, [pc, #20]	; (c0d05820 <USBD_LL_ClearStallEP+0x40>)
c0d0580c:	6801      	ldr	r1, [r0, #0]
c0d0580e:	227f      	movs	r2, #127	; 0x7f
c0d05810:	4015      	ands	r5, r2
c0d05812:	2201      	movs	r2, #1
c0d05814:	40aa      	lsls	r2, r5
c0d05816:	4391      	bics	r1, r2
c0d05818:	6001      	str	r1, [r0, #0]
    ep_in_stall &= ~(1<<(ep_addr&0x7F));
  }
  else {
    ep_out_stall &= ~(1<<(ep_addr&0x7F)); 
  }
  return USBD_OK; 
c0d0581a:	4620      	mov	r0, r4
c0d0581c:	b002      	add	sp, #8
c0d0581e:	bdb0      	pop	{r4, r5, r7, pc}
c0d05820:	200023b4 	.word	0x200023b4
c0d05824:	200023b0 	.word	0x200023b0

c0d05828 <USBD_LL_IsStallEP>:
c0d05828:	0608      	lsls	r0, r1, #24
c0d0582a:	d501      	bpl.n	c0d05830 <USBD_LL_IsStallEP+0x8>
c0d0582c:	4805      	ldr	r0, [pc, #20]	; (c0d05844 <USBD_LL_IsStallEP+0x1c>)
c0d0582e:	e000      	b.n	c0d05832 <USBD_LL_IsStallEP+0xa>
c0d05830:	4803      	ldr	r0, [pc, #12]	; (c0d05840 <USBD_LL_IsStallEP+0x18>)
c0d05832:	7802      	ldrb	r2, [r0, #0]
c0d05834:	207f      	movs	r0, #127	; 0x7f
c0d05836:	4001      	ands	r1, r0
c0d05838:	2001      	movs	r0, #1
c0d0583a:	4088      	lsls	r0, r1
c0d0583c:	4010      	ands	r0, r2
  }
  else
  {
    return ep_out_stall & (1<<(ep_addr&0x7F));
  }
}
c0d0583e:	4770      	bx	lr
c0d05840:	200023b4 	.word	0x200023b4
c0d05844:	200023b0 	.word	0x200023b0

c0d05848 <USBD_LL_SetUSBAddress>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_SetUSBAddress (USBD_HandleTypeDef *pdev, uint8_t dev_addr)   
{
c0d05848:	b510      	push	{r4, lr}
c0d0584a:	b082      	sub	sp, #8
c0d0584c:	4668      	mov	r0, sp
c0d0584e:	2400      	movs	r4, #0
  UNUSED(pdev);
  uint8_t buffer[5];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
  buffer[1] = 0;
c0d05850:	7044      	strb	r4, [r0, #1]
c0d05852:	224f      	movs	r2, #79	; 0x4f
  */
USBD_StatusTypeDef  USBD_LL_SetUSBAddress (USBD_HandleTypeDef *pdev, uint8_t dev_addr)   
{
  UNUSED(pdev);
  uint8_t buffer[5];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d05854:	7002      	strb	r2, [r0, #0]
c0d05856:	2202      	movs	r2, #2
  buffer[1] = 0;
  buffer[2] = 2;
c0d05858:	7082      	strb	r2, [r0, #2]
c0d0585a:	2203      	movs	r2, #3
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ADDR;
c0d0585c:	70c2      	strb	r2, [r0, #3]
  buffer[4] = dev_addr;
c0d0585e:	7101      	strb	r1, [r0, #4]
c0d05860:	2105      	movs	r1, #5
  io_seproxyhal_spi_send(buffer, 5);
c0d05862:	f7ff fb17 	bl	c0d04e94 <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d05866:	4620      	mov	r0, r4
c0d05868:	b002      	add	sp, #8
c0d0586a:	bd10      	pop	{r4, pc}

c0d0586c <USBD_LL_Transmit>:
  */
USBD_StatusTypeDef  USBD_LL_Transmit (USBD_HandleTypeDef *pdev, 
                                      uint8_t  ep_addr,                                      
                                      uint8_t  *pbuf,
                                      uint16_t  size)
{
c0d0586c:	b5b0      	push	{r4, r5, r7, lr}
c0d0586e:	b082      	sub	sp, #8
c0d05870:	461c      	mov	r4, r3
c0d05872:	4615      	mov	r5, r2
c0d05874:	4668      	mov	r0, sp
c0d05876:	2250      	movs	r2, #80	; 0x50
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d05878:	7002      	strb	r2, [r0, #0]
  buffer[1] = (3+size)>>8;
  buffer[2] = (3+size);
  buffer[3] = ep_addr;
c0d0587a:	70c1      	strb	r1, [r0, #3]
c0d0587c:	2120      	movs	r1, #32
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_IN;
c0d0587e:	7101      	strb	r1, [r0, #4]
  buffer[5] = size;
c0d05880:	7143      	strb	r3, [r0, #5]
                                      uint16_t  size)
{
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
  buffer[1] = (3+size)>>8;
c0d05882:	1cd9      	adds	r1, r3, #3
  buffer[2] = (3+size);
c0d05884:	7081      	strb	r1, [r0, #2]
                                      uint16_t  size)
{
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
  buffer[1] = (3+size)>>8;
c0d05886:	0a09      	lsrs	r1, r1, #8
c0d05888:	7041      	strb	r1, [r0, #1]
c0d0588a:	2106      	movs	r1, #6
  buffer[2] = (3+size);
  buffer[3] = ep_addr;
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_IN;
  buffer[5] = size;
  io_seproxyhal_spi_send(buffer, 6);
c0d0588c:	f7ff fb02 	bl	c0d04e94 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send(pbuf, size);
c0d05890:	4628      	mov	r0, r5
c0d05892:	4621      	mov	r1, r4
c0d05894:	f7ff fafe 	bl	c0d04e94 <io_seproxyhal_spi_send>
c0d05898:	2000      	movs	r0, #0
  return USBD_OK;   
c0d0589a:	b002      	add	sp, #8
c0d0589c:	bdb0      	pop	{r4, r5, r7, pc}

c0d0589e <USBD_LL_PrepareReceive>:
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_PrepareReceive(USBD_HandleTypeDef *pdev, 
                                           uint8_t  ep_addr,
                                           uint16_t  size)
{
c0d0589e:	b510      	push	{r4, lr}
c0d058a0:	b082      	sub	sp, #8
c0d058a2:	4668      	mov	r0, sp
c0d058a4:	2400      	movs	r4, #0
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
  buffer[1] = (3/*+size*/)>>8;
c0d058a6:	7044      	strb	r4, [r0, #1]
c0d058a8:	2350      	movs	r3, #80	; 0x50
                                           uint8_t  ep_addr,
                                           uint16_t  size)
{
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d058aa:	7003      	strb	r3, [r0, #0]
c0d058ac:	2303      	movs	r3, #3
  buffer[1] = (3/*+size*/)>>8;
  buffer[2] = (3/*+size*/);
c0d058ae:	7083      	strb	r3, [r0, #2]
  buffer[3] = ep_addr;
c0d058b0:	70c1      	strb	r1, [r0, #3]
c0d058b2:	2130      	movs	r1, #48	; 0x30
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_OUT;
c0d058b4:	7101      	strb	r1, [r0, #4]
  buffer[5] = size; // expected size, not transmitted here !
c0d058b6:	7142      	strb	r2, [r0, #5]
c0d058b8:	2106      	movs	r1, #6
  io_seproxyhal_spi_send(buffer, 6);
c0d058ba:	f7ff faeb 	bl	c0d04e94 <io_seproxyhal_spi_send>
  return USBD_OK;   
c0d058be:	4620      	mov	r0, r4
c0d058c0:	b002      	add	sp, #8
c0d058c2:	bd10      	pop	{r4, pc}

c0d058c4 <USBD_Init>:
* @param  pdesc: Descriptor structure address
* @param  id: Low level core index
* @retval None
*/
USBD_StatusTypeDef USBD_Init(USBD_HandleTypeDef *pdev, USBD_DescriptorsTypeDef *pdesc, uint8_t id)
{
c0d058c4:	b570      	push	{r4, r5, r6, lr}
c0d058c6:	4604      	mov	r4, r0
c0d058c8:	2002      	movs	r0, #2
  /* Check whether the USB Host handle is valid */
  if(pdev == NULL)
c0d058ca:	2c00      	cmp	r4, #0
c0d058cc:	d012      	beq.n	c0d058f4 <USBD_Init+0x30>
c0d058ce:	4615      	mov	r5, r2
c0d058d0:	460e      	mov	r6, r1
c0d058d2:	2045      	movs	r0, #69	; 0x45
c0d058d4:	0081      	lsls	r1, r0, #2
  {
    USBD_ErrLog("Invalid Device handle");
    return USBD_FAIL; 
  }

  memset(pdev, 0, sizeof(USBD_HandleTypeDef));
c0d058d6:	4620      	mov	r0, r4
c0d058d8:	f000 ffd2 	bl	c0d06880 <__aeabi_memclr>
  
  /* Assign USBD Descriptors */
  if(pdesc != NULL)
c0d058dc:	2e00      	cmp	r6, #0
c0d058de:	d001      	beq.n	c0d058e4 <USBD_Init+0x20>
c0d058e0:	20f0      	movs	r0, #240	; 0xf0
  {
    pdev->pDesc = pdesc;
c0d058e2:	5026      	str	r6, [r4, r0]
c0d058e4:	20dc      	movs	r0, #220	; 0xdc
c0d058e6:	2101      	movs	r1, #1
  }
  
  /* Set Device initial State */
  pdev->dev_state  = USBD_STATE_DEFAULT;
c0d058e8:	5421      	strb	r1, [r4, r0]
  pdev->id = id;
c0d058ea:	7025      	strb	r5, [r4, #0]
  /* Initialize low level driver */
  USBD_LL_Init(pdev);
c0d058ec:	4620      	mov	r0, r4
c0d058ee:	f7ff fec3 	bl	c0d05678 <USBD_LL_Init>
c0d058f2:	2000      	movs	r0, #0
  
  return USBD_OK; 
}
c0d058f4:	bd70      	pop	{r4, r5, r6, pc}

c0d058f6 <USBD_DeInit>:
*         Re-Initialize th device library
* @param  pdev: device instance
* @retval status: status
*/
USBD_StatusTypeDef USBD_DeInit(USBD_HandleTypeDef *pdev)
{
c0d058f6:	b5b0      	push	{r4, r5, r7, lr}
c0d058f8:	4604      	mov	r4, r0
c0d058fa:	20dc      	movs	r0, #220	; 0xdc
c0d058fc:	2101      	movs	r1, #1
  /* Set Default State */
  pdev->dev_state  = USBD_STATE_DEFAULT;
c0d058fe:	5421      	strb	r1, [r4, r0]
c0d05900:	2017      	movs	r0, #23
c0d05902:	43c5      	mvns	r5, r0
  
  /* Free Class Resources */
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
    if(pdev->interfacesClass[intf].pClass != NULL) {
c0d05904:	1960      	adds	r0, r4, r5
c0d05906:	2143      	movs	r1, #67	; 0x43
c0d05908:	0089      	lsls	r1, r1, #2
c0d0590a:	5840      	ldr	r0, [r0, r1]
c0d0590c:	2800      	cmp	r0, #0
c0d0590e:	d006      	beq.n	c0d0591e <USBD_DeInit+0x28>
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config);  
c0d05910:	6840      	ldr	r0, [r0, #4]
c0d05912:	f7ff f82b 	bl	c0d0496c <pic>
c0d05916:	4602      	mov	r2, r0
c0d05918:	7921      	ldrb	r1, [r4, #4]
c0d0591a:	4620      	mov	r0, r4
c0d0591c:	4790      	blx	r2
  /* Set Default State */
  pdev->dev_state  = USBD_STATE_DEFAULT;
  
  /* Free Class Resources */
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d0591e:	3508      	adds	r5, #8
c0d05920:	d1f0      	bne.n	c0d05904 <USBD_DeInit+0xe>
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config);  
    }
  }
  
    /* Stop the low level driver  */
  USBD_LL_Stop(pdev); 
c0d05922:	4620      	mov	r0, r4
c0d05924:	f7ff fee0 	bl	c0d056e8 <USBD_LL_Stop>
  
  /* Initialize low level driver */
  USBD_LL_DeInit(pdev);
c0d05928:	4620      	mov	r0, r4
c0d0592a:	f7ff feaf 	bl	c0d0568c <USBD_LL_DeInit>
c0d0592e:	2000      	movs	r0, #0
  
  return USBD_OK;
c0d05930:	bdb0      	pop	{r4, r5, r7, pc}

c0d05932 <USBD_RegisterClassForInterface>:
  * @param  pDevice : Device Handle
  * @param  pclass: Class handle
  * @retval USBD Status
  */
USBD_StatusTypeDef USBD_RegisterClassForInterface(uint8_t interfaceidx, USBD_HandleTypeDef *pdev, USBD_ClassTypeDef *pclass)
{
c0d05932:	4603      	mov	r3, r0
c0d05934:	2002      	movs	r0, #2
  USBD_StatusTypeDef   status = USBD_OK;
  if(pclass != 0)
c0d05936:	2a00      	cmp	r2, #0
c0d05938:	d007      	beq.n	c0d0594a <USBD_RegisterClassForInterface+0x18>
c0d0593a:	2000      	movs	r0, #0
  {
    if (interfaceidx < USBD_MAX_NUM_INTERFACES) {
c0d0593c:	2b02      	cmp	r3, #2
c0d0593e:	d804      	bhi.n	c0d0594a <USBD_RegisterClassForInterface+0x18>
      /* link the class to the USB Device handle */
      pdev->interfacesClass[interfaceidx].pClass = pclass;
c0d05940:	00d8      	lsls	r0, r3, #3
c0d05942:	1808      	adds	r0, r1, r0
c0d05944:	21f4      	movs	r1, #244	; 0xf4
c0d05946:	5042      	str	r2, [r0, r1]
c0d05948:	2000      	movs	r0, #0
  {
    USBD_ErrLog("Invalid Class handle");
    status = USBD_FAIL; 
  }
  
  return status;
c0d0594a:	4770      	bx	lr

c0d0594c <USBD_Start>:
  *         Start the USB Device Core.
  * @param  pdev: Device Handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_Start  (USBD_HandleTypeDef *pdev)
{
c0d0594c:	b580      	push	{r7, lr}
  
  /* Start the low level driver  */
  USBD_LL_Start(pdev); 
c0d0594e:	f7ff feaf 	bl	c0d056b0 <USBD_LL_Start>
c0d05952:	2000      	movs	r0, #0
  
  return USBD_OK;  
c0d05954:	bd80      	pop	{r7, pc}

c0d05956 <USBD_SetClassConfig>:
* @param  cfgidx: configuration index
* @retval status
*/

USBD_StatusTypeDef USBD_SetClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
c0d05956:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d05958:	b081      	sub	sp, #4
c0d0595a:	460c      	mov	r4, r1
c0d0595c:	4605      	mov	r5, r0
c0d0595e:	2600      	movs	r6, #0
c0d05960:	27f4      	movs	r7, #244	; 0xf4
  /* Set configuration  and Start the Class*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
    if(usbd_is_valid_intf(pdev, intf)) {
c0d05962:	4628      	mov	r0, r5
c0d05964:	4631      	mov	r1, r6
c0d05966:	f000 f969 	bl	c0d05c3c <usbd_is_valid_intf>
c0d0596a:	2800      	cmp	r0, #0
c0d0596c:	d007      	beq.n	c0d0597e <USBD_SetClassConfig+0x28>
      ((Init_t)PIC(pdev->interfacesClass[intf].pClass->Init))(pdev, cfgidx);
c0d0596e:	59e8      	ldr	r0, [r5, r7]
c0d05970:	6800      	ldr	r0, [r0, #0]
c0d05972:	f7fe fffb 	bl	c0d0496c <pic>
c0d05976:	4602      	mov	r2, r0
c0d05978:	4628      	mov	r0, r5
c0d0597a:	4621      	mov	r1, r4
c0d0597c:	4790      	blx	r2

USBD_StatusTypeDef USBD_SetClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
  /* Set configuration  and Start the Class*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d0597e:	3708      	adds	r7, #8
c0d05980:	1c76      	adds	r6, r6, #1
c0d05982:	2e03      	cmp	r6, #3
c0d05984:	d1ed      	bne.n	c0d05962 <USBD_SetClassConfig+0xc>
c0d05986:	2000      	movs	r0, #0
    if(usbd_is_valid_intf(pdev, intf)) {
      ((Init_t)PIC(pdev->interfacesClass[intf].pClass->Init))(pdev, cfgidx);
    }
  }

  return USBD_OK; 
c0d05988:	b001      	add	sp, #4
c0d0598a:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d0598c <USBD_ClrClassConfig>:
* @param  pdev: device instance
* @param  cfgidx: configuration index
* @retval status: USBD_StatusTypeDef
*/
USBD_StatusTypeDef USBD_ClrClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
c0d0598c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0598e:	b081      	sub	sp, #4
c0d05990:	460c      	mov	r4, r1
c0d05992:	4605      	mov	r5, r0
c0d05994:	2600      	movs	r6, #0
c0d05996:	27f4      	movs	r7, #244	; 0xf4
  /* Clear configuration  and De-initialize the Class process*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
    if(usbd_is_valid_intf(pdev, intf)) {
c0d05998:	4628      	mov	r0, r5
c0d0599a:	4631      	mov	r1, r6
c0d0599c:	f000 f94e 	bl	c0d05c3c <usbd_is_valid_intf>
c0d059a0:	2800      	cmp	r0, #0
c0d059a2:	d007      	beq.n	c0d059b4 <USBD_ClrClassConfig+0x28>
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, cfgidx);  
c0d059a4:	59e8      	ldr	r0, [r5, r7]
c0d059a6:	6840      	ldr	r0, [r0, #4]
c0d059a8:	f7fe ffe0 	bl	c0d0496c <pic>
c0d059ac:	4602      	mov	r2, r0
c0d059ae:	4628      	mov	r0, r5
c0d059b0:	4621      	mov	r1, r4
c0d059b2:	4790      	blx	r2
*/
USBD_StatusTypeDef USBD_ClrClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
  /* Clear configuration  and De-initialize the Class process*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d059b4:	3708      	adds	r7, #8
c0d059b6:	1c76      	adds	r6, r6, #1
c0d059b8:	2e03      	cmp	r6, #3
c0d059ba:	d1ed      	bne.n	c0d05998 <USBD_ClrClassConfig+0xc>
c0d059bc:	2000      	movs	r0, #0
    if(usbd_is_valid_intf(pdev, intf)) {
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, cfgidx);  
    }
  }
  return USBD_OK;
c0d059be:	b001      	add	sp, #4
c0d059c0:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d059c2 <USBD_LL_SetupStage>:
*         Handle the setup stage
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef USBD_LL_SetupStage(USBD_HandleTypeDef *pdev, uint8_t *psetup)
{
c0d059c2:	b5b0      	push	{r4, r5, r7, lr}
c0d059c4:	4604      	mov	r4, r0
  USBD_ParseSetupRequest(&pdev->request, psetup);
c0d059c6:	4605      	mov	r5, r0
c0d059c8:	35e8      	adds	r5, #232	; 0xe8
c0d059ca:	4628      	mov	r0, r5
c0d059cc:	f000 fb7f 	bl	c0d060ce <USBD_ParseSetupRequest>
c0d059d0:	20d4      	movs	r0, #212	; 0xd4
c0d059d2:	2101      	movs	r1, #1
  
  pdev->ep0_state = USBD_EP0_SETUP;
c0d059d4:	5021      	str	r1, [r4, r0]
c0d059d6:	20ee      	movs	r0, #238	; 0xee
  pdev->ep0_data_len = pdev->request.wLength;
c0d059d8:	5a20      	ldrh	r0, [r4, r0]
c0d059da:	21d8      	movs	r1, #216	; 0xd8
c0d059dc:	5060      	str	r0, [r4, r1]
c0d059de:	20e8      	movs	r0, #232	; 0xe8
  
  switch (pdev->request.bmRequest & 0x1F) 
c0d059e0:	5c21      	ldrb	r1, [r4, r0]
c0d059e2:	201f      	movs	r0, #31
c0d059e4:	4008      	ands	r0, r1
c0d059e6:	2802      	cmp	r0, #2
c0d059e8:	d008      	beq.n	c0d059fc <USBD_LL_SetupStage+0x3a>
c0d059ea:	2801      	cmp	r0, #1
c0d059ec:	d00b      	beq.n	c0d05a06 <USBD_LL_SetupStage+0x44>
c0d059ee:	2800      	cmp	r0, #0
c0d059f0:	d10e      	bne.n	c0d05a10 <USBD_LL_SetupStage+0x4e>
  {
  case USB_REQ_RECIPIENT_DEVICE:   
    USBD_StdDevReq (pdev, &pdev->request);
c0d059f2:	4620      	mov	r0, r4
c0d059f4:	4629      	mov	r1, r5
c0d059f6:	f000 f92e 	bl	c0d05c56 <USBD_StdDevReq>
c0d059fa:	e00e      	b.n	c0d05a1a <USBD_LL_SetupStage+0x58>
  case USB_REQ_RECIPIENT_INTERFACE:     
    USBD_StdItfReq(pdev, &pdev->request);
    break;
    
  case USB_REQ_RECIPIENT_ENDPOINT:        
    USBD_StdEPReq(pdev, &pdev->request);   
c0d059fc:	4620      	mov	r0, r4
c0d059fe:	4629      	mov	r1, r5
c0d05a00:	f000 fae1 	bl	c0d05fc6 <USBD_StdEPReq>
c0d05a04:	e009      	b.n	c0d05a1a <USBD_LL_SetupStage+0x58>
  case USB_REQ_RECIPIENT_DEVICE:   
    USBD_StdDevReq (pdev, &pdev->request);
    break;
    
  case USB_REQ_RECIPIENT_INTERFACE:     
    USBD_StdItfReq(pdev, &pdev->request);
c0d05a06:	4620      	mov	r0, r4
c0d05a08:	4629      	mov	r1, r5
c0d05a0a:	f000 fab8 	bl	c0d05f7e <USBD_StdItfReq>
c0d05a0e:	e004      	b.n	c0d05a1a <USBD_LL_SetupStage+0x58>
c0d05a10:	2080      	movs	r0, #128	; 0x80
  case USB_REQ_RECIPIENT_ENDPOINT:        
    USBD_StdEPReq(pdev, &pdev->request);   
    break;
    
  default:           
    USBD_LL_StallEP(pdev , pdev->request.bmRequest & 0x80);
c0d05a12:	4001      	ands	r1, r0
c0d05a14:	4620      	mov	r0, r4
c0d05a16:	f7ff febf 	bl	c0d05798 <USBD_LL_StallEP>
c0d05a1a:	2000      	movs	r0, #0
    break;
  }  
  return USBD_OK;  
c0d05a1c:	bdb0      	pop	{r4, r5, r7, pc}

c0d05a1e <USBD_LL_DataOutStage>:
* @param  pdev: device instance
* @param  epnum: endpoint index
* @retval status
*/
USBD_StatusTypeDef USBD_LL_DataOutStage(USBD_HandleTypeDef *pdev , uint8_t epnum, uint8_t *pdata)
{
c0d05a1e:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d05a20:	b083      	sub	sp, #12
c0d05a22:	9202      	str	r2, [sp, #8]
c0d05a24:	4604      	mov	r4, r0
c0d05a26:	9101      	str	r1, [sp, #4]
  USBD_EndpointTypeDef    *pep;
  
  if(epnum == 0) 
c0d05a28:	2900      	cmp	r1, #0
c0d05a2a:	d01c      	beq.n	c0d05a66 <USBD_LL_DataOutStage+0x48>
c0d05a2c:	4625      	mov	r5, r4
c0d05a2e:	35dc      	adds	r5, #220	; 0xdc
c0d05a30:	2700      	movs	r7, #0
c0d05a32:	26f4      	movs	r6, #244	; 0xf4
  }
  else {

    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->DataOut != NULL)&&
c0d05a34:	4620      	mov	r0, r4
c0d05a36:	4639      	mov	r1, r7
c0d05a38:	f000 f900 	bl	c0d05c3c <usbd_is_valid_intf>
c0d05a3c:	2800      	cmp	r0, #0
c0d05a3e:	d00d      	beq.n	c0d05a5c <USBD_LL_DataOutStage+0x3e>
c0d05a40:	59a0      	ldr	r0, [r4, r6]
c0d05a42:	6980      	ldr	r0, [r0, #24]
c0d05a44:	2800      	cmp	r0, #0
c0d05a46:	d009      	beq.n	c0d05a5c <USBD_LL_DataOutStage+0x3e>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d05a48:	7829      	ldrb	r1, [r5, #0]
  }
  else {

    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->DataOut != NULL)&&
c0d05a4a:	2903      	cmp	r1, #3
c0d05a4c:	d106      	bne.n	c0d05a5c <USBD_LL_DataOutStage+0x3e>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
      {
        ((DataOut_t)PIC(pdev->interfacesClass[intf].pClass->DataOut))(pdev, epnum, pdata); 
c0d05a4e:	f7fe ff8d 	bl	c0d0496c <pic>
c0d05a52:	4603      	mov	r3, r0
c0d05a54:	4620      	mov	r0, r4
c0d05a56:	9901      	ldr	r1, [sp, #4]
c0d05a58:	9a02      	ldr	r2, [sp, #8]
c0d05a5a:	4798      	blx	r3
    }
  }
  else {

    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d05a5c:	3608      	adds	r6, #8
c0d05a5e:	1c7f      	adds	r7, r7, #1
c0d05a60:	2f03      	cmp	r7, #3
c0d05a62:	d1e7      	bne.n	c0d05a34 <USBD_LL_DataOutStage+0x16>
c0d05a64:	e030      	b.n	c0d05ac8 <USBD_LL_DataOutStage+0xaa>
c0d05a66:	20d4      	movs	r0, #212	; 0xd4
  
  if(epnum == 0) 
  {
    pep = &pdev->ep_out[0];
    
    if ( pdev->ep0_state == USBD_EP0_DATA_OUT)
c0d05a68:	5820      	ldr	r0, [r4, r0]
c0d05a6a:	2803      	cmp	r0, #3
c0d05a6c:	d12c      	bne.n	c0d05ac8 <USBD_LL_DataOutStage+0xaa>
c0d05a6e:	2080      	movs	r0, #128	; 0x80
    {
      if(pep->rem_length > pep->maxpacket)
c0d05a70:	5820      	ldr	r0, [r4, r0]
c0d05a72:	6fe1      	ldr	r1, [r4, #124]	; 0x7c
c0d05a74:	4281      	cmp	r1, r0
c0d05a76:	d90a      	bls.n	c0d05a8e <USBD_LL_DataOutStage+0x70>
      {
        pep->rem_length -=  pep->maxpacket;
c0d05a78:	1a09      	subs	r1, r1, r0
c0d05a7a:	67e1      	str	r1, [r4, #124]	; 0x7c
       
        USBD_CtlContinueRx (pdev, 
                            pdata,
                            MIN(pep->rem_length ,pep->maxpacket));
c0d05a7c:	4281      	cmp	r1, r0
c0d05a7e:	d300      	bcc.n	c0d05a82 <USBD_LL_DataOutStage+0x64>
c0d05a80:	4601      	mov	r1, r0
    {
      if(pep->rem_length > pep->maxpacket)
      {
        pep->rem_length -=  pep->maxpacket;
       
        USBD_CtlContinueRx (pdev, 
c0d05a82:	b28a      	uxth	r2, r1
c0d05a84:	4620      	mov	r0, r4
c0d05a86:	9902      	ldr	r1, [sp, #8]
c0d05a88:	f000 fd0e 	bl	c0d064a8 <USBD_CtlContinueRx>
c0d05a8c:	e01c      	b.n	c0d05ac8 <USBD_LL_DataOutStage+0xaa>
c0d05a8e:	4626      	mov	r6, r4
c0d05a90:	36dc      	adds	r6, #220	; 0xdc
c0d05a92:	2500      	movs	r5, #0
c0d05a94:	27f4      	movs	r7, #244	; 0xf4
      }
      else
      {
        uint8_t intf;
        for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
          if(usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->EP0_RxReady != NULL)&&
c0d05a96:	4620      	mov	r0, r4
c0d05a98:	4629      	mov	r1, r5
c0d05a9a:	f000 f8cf 	bl	c0d05c3c <usbd_is_valid_intf>
c0d05a9e:	2800      	cmp	r0, #0
c0d05aa0:	d00b      	beq.n	c0d05aba <USBD_LL_DataOutStage+0x9c>
c0d05aa2:	59e0      	ldr	r0, [r4, r7]
c0d05aa4:	6900      	ldr	r0, [r0, #16]
c0d05aa6:	2800      	cmp	r0, #0
c0d05aa8:	d007      	beq.n	c0d05aba <USBD_LL_DataOutStage+0x9c>
             (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d05aaa:	7831      	ldrb	r1, [r6, #0]
      }
      else
      {
        uint8_t intf;
        for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
          if(usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->EP0_RxReady != NULL)&&
c0d05aac:	2903      	cmp	r1, #3
c0d05aae:	d104      	bne.n	c0d05aba <USBD_LL_DataOutStage+0x9c>
             (pdev->dev_state == USBD_STATE_CONFIGURED))
          {
            ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_RxReady))(pdev); 
c0d05ab0:	f7fe ff5c 	bl	c0d0496c <pic>
c0d05ab4:	4601      	mov	r1, r0
c0d05ab6:	4620      	mov	r0, r4
c0d05ab8:	4788      	blx	r1
                            MIN(pep->rem_length ,pep->maxpacket));
      }
      else
      {
        uint8_t intf;
        for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d05aba:	3708      	adds	r7, #8
c0d05abc:	1c6d      	adds	r5, r5, #1
c0d05abe:	2d03      	cmp	r5, #3
c0d05ac0:	d1e9      	bne.n	c0d05a96 <USBD_LL_DataOutStage+0x78>
             (pdev->dev_state == USBD_STATE_CONFIGURED))
          {
            ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_RxReady))(pdev); 
          }
        }
        USBD_CtlSendStatus(pdev);
c0d05ac2:	4620      	mov	r0, r4
c0d05ac4:	f000 fcf7 	bl	c0d064b6 <USBD_CtlSendStatus>
c0d05ac8:	2000      	movs	r0, #0
      {
        ((DataOut_t)PIC(pdev->interfacesClass[intf].pClass->DataOut))(pdev, epnum, pdata); 
      }
    }
  }  
  return USBD_OK;
c0d05aca:	b003      	add	sp, #12
c0d05acc:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d05ace <USBD_LL_DataInStage>:
* @param  pdev: device instance
* @param  epnum: endpoint index
* @retval status
*/
USBD_StatusTypeDef USBD_LL_DataInStage(USBD_HandleTypeDef *pdev ,uint8_t epnum, uint8_t *pdata)
{
c0d05ace:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d05ad0:	b081      	sub	sp, #4
c0d05ad2:	4604      	mov	r4, r0
c0d05ad4:	9100      	str	r1, [sp, #0]
  USBD_EndpointTypeDef    *pep;
  UNUSED(pdata);
    
  if(epnum == 0) 
c0d05ad6:	2900      	cmp	r1, #0
c0d05ad8:	d01b      	beq.n	c0d05b12 <USBD_LL_DataInStage+0x44>
c0d05ada:	4627      	mov	r7, r4
c0d05adc:	37dc      	adds	r7, #220	; 0xdc
c0d05ade:	2600      	movs	r6, #0
c0d05ae0:	25f4      	movs	r5, #244	; 0xf4
    }
  }
  else {
    uint8_t intf;
    for (intf = 0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->DataIn != NULL)&&
c0d05ae2:	4620      	mov	r0, r4
c0d05ae4:	4631      	mov	r1, r6
c0d05ae6:	f000 f8a9 	bl	c0d05c3c <usbd_is_valid_intf>
c0d05aea:	2800      	cmp	r0, #0
c0d05aec:	d00c      	beq.n	c0d05b08 <USBD_LL_DataInStage+0x3a>
c0d05aee:	5960      	ldr	r0, [r4, r5]
c0d05af0:	6940      	ldr	r0, [r0, #20]
c0d05af2:	2800      	cmp	r0, #0
c0d05af4:	d008      	beq.n	c0d05b08 <USBD_LL_DataInStage+0x3a>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d05af6:	7839      	ldrb	r1, [r7, #0]
    }
  }
  else {
    uint8_t intf;
    for (intf = 0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->DataIn != NULL)&&
c0d05af8:	2903      	cmp	r1, #3
c0d05afa:	d105      	bne.n	c0d05b08 <USBD_LL_DataInStage+0x3a>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
      {
        ((DataIn_t)PIC(pdev->interfacesClass[intf].pClass->DataIn))(pdev, epnum); 
c0d05afc:	f7fe ff36 	bl	c0d0496c <pic>
c0d05b00:	4602      	mov	r2, r0
c0d05b02:	4620      	mov	r0, r4
c0d05b04:	9900      	ldr	r1, [sp, #0]
c0d05b06:	4790      	blx	r2
      pdev->dev_test_mode = 0;
    }
  }
  else {
    uint8_t intf;
    for (intf = 0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d05b08:	3508      	adds	r5, #8
c0d05b0a:	1c76      	adds	r6, r6, #1
c0d05b0c:	2e03      	cmp	r6, #3
c0d05b0e:	d1e8      	bne.n	c0d05ae2 <USBD_LL_DataInStage+0x14>
c0d05b10:	e04e      	b.n	c0d05bb0 <USBD_LL_DataInStage+0xe2>
c0d05b12:	20d4      	movs	r0, #212	; 0xd4
    
  if(epnum == 0) 
  {
    pep = &pdev->ep_in[0];
    
    if ( pdev->ep0_state == USBD_EP0_DATA_IN)
c0d05b14:	5820      	ldr	r0, [r4, r0]
c0d05b16:	2802      	cmp	r0, #2
c0d05b18:	d143      	bne.n	c0d05ba2 <USBD_LL_DataInStage+0xd4>
    {
      if(pep->rem_length > pep->maxpacket)
c0d05b1a:	69e0      	ldr	r0, [r4, #28]
c0d05b1c:	6a25      	ldr	r5, [r4, #32]
c0d05b1e:	42a8      	cmp	r0, r5
c0d05b20:	d90b      	bls.n	c0d05b3a <USBD_LL_DataInStage+0x6c>
c0d05b22:	2111      	movs	r1, #17
c0d05b24:	010a      	lsls	r2, r1, #4
      {
        pep->rem_length -=  pep->maxpacket;
        pdev->pData += pep->maxpacket;
c0d05b26:	58a1      	ldr	r1, [r4, r2]
c0d05b28:	1949      	adds	r1, r1, r5
c0d05b2a:	50a1      	str	r1, [r4, r2]
    
    if ( pdev->ep0_state == USBD_EP0_DATA_IN)
    {
      if(pep->rem_length > pep->maxpacket)
      {
        pep->rem_length -=  pep->maxpacket;
c0d05b2c:	1b40      	subs	r0, r0, r5
c0d05b2e:	61e0      	str	r0, [r4, #28]
        USBD_LL_PrepareReceive (pdev,
                                0,
                                0);  
        */
        
        USBD_CtlContinueSendData (pdev, 
c0d05b30:	b282      	uxth	r2, r0
c0d05b32:	4620      	mov	r0, r4
c0d05b34:	f000 fcaa 	bl	c0d0648c <USBD_CtlContinueSendData>
c0d05b38:	e033      	b.n	c0d05ba2 <USBD_LL_DataInStage+0xd4>
                                  pep->rem_length);
        
      }
      else
      { /* last packet is MPS multiple, so send ZLP packet */
        if((pep->total_length % pep->maxpacket == 0) &&
c0d05b3a:	69a6      	ldr	r6, [r4, #24]
c0d05b3c:	4630      	mov	r0, r6
c0d05b3e:	4629      	mov	r1, r5
c0d05b40:	f000 fd56 	bl	c0d065f0 <__aeabi_uidivmod>
c0d05b44:	42ae      	cmp	r6, r5
c0d05b46:	d30f      	bcc.n	c0d05b68 <USBD_LL_DataInStage+0x9a>
c0d05b48:	2900      	cmp	r1, #0
c0d05b4a:	d10d      	bne.n	c0d05b68 <USBD_LL_DataInStage+0x9a>
c0d05b4c:	20d8      	movs	r0, #216	; 0xd8
           (pep->total_length >= pep->maxpacket) &&
             (pep->total_length < pdev->ep0_data_len ))
c0d05b4e:	5820      	ldr	r0, [r4, r0]
c0d05b50:	4627      	mov	r7, r4
c0d05b52:	37d8      	adds	r7, #216	; 0xd8
                                  pep->rem_length);
        
      }
      else
      { /* last packet is MPS multiple, so send ZLP packet */
        if((pep->total_length % pep->maxpacket == 0) &&
c0d05b54:	4286      	cmp	r6, r0
c0d05b56:	d207      	bcs.n	c0d05b68 <USBD_LL_DataInStage+0x9a>
c0d05b58:	2500      	movs	r5, #0
          USBD_LL_PrepareReceive (pdev,
                                  0,
                                  0);
          */

          USBD_CtlContinueSendData(pdev , NULL, 0);
c0d05b5a:	4620      	mov	r0, r4
c0d05b5c:	4629      	mov	r1, r5
c0d05b5e:	462a      	mov	r2, r5
c0d05b60:	f000 fc94 	bl	c0d0648c <USBD_CtlContinueSendData>
          pdev->ep0_data_len = 0;
c0d05b64:	603d      	str	r5, [r7, #0]
c0d05b66:	e01c      	b.n	c0d05ba2 <USBD_LL_DataInStage+0xd4>
c0d05b68:	4626      	mov	r6, r4
c0d05b6a:	36dc      	adds	r6, #220	; 0xdc
c0d05b6c:	2500      	movs	r5, #0
c0d05b6e:	27f4      	movs	r7, #244	; 0xf4
        }
        else
        {
          uint8_t intf;
          for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
            if(usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->EP0_TxSent != NULL)&&
c0d05b70:	4620      	mov	r0, r4
c0d05b72:	4629      	mov	r1, r5
c0d05b74:	f000 f862 	bl	c0d05c3c <usbd_is_valid_intf>
c0d05b78:	2800      	cmp	r0, #0
c0d05b7a:	d00b      	beq.n	c0d05b94 <USBD_LL_DataInStage+0xc6>
c0d05b7c:	59e0      	ldr	r0, [r4, r7]
c0d05b7e:	68c0      	ldr	r0, [r0, #12]
c0d05b80:	2800      	cmp	r0, #0
c0d05b82:	d007      	beq.n	c0d05b94 <USBD_LL_DataInStage+0xc6>
               (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d05b84:	7831      	ldrb	r1, [r6, #0]
        }
        else
        {
          uint8_t intf;
          for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
            if(usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->EP0_TxSent != NULL)&&
c0d05b86:	2903      	cmp	r1, #3
c0d05b88:	d104      	bne.n	c0d05b94 <USBD_LL_DataInStage+0xc6>
               (pdev->dev_state == USBD_STATE_CONFIGURED))
            {
              ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_TxSent))(pdev); 
c0d05b8a:	f7fe feef 	bl	c0d0496c <pic>
c0d05b8e:	4601      	mov	r1, r0
c0d05b90:	4620      	mov	r0, r4
c0d05b92:	4788      	blx	r1
          
        }
        else
        {
          uint8_t intf;
          for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d05b94:	3708      	adds	r7, #8
c0d05b96:	1c6d      	adds	r5, r5, #1
c0d05b98:	2d03      	cmp	r5, #3
c0d05b9a:	d1e9      	bne.n	c0d05b70 <USBD_LL_DataInStage+0xa2>
               (pdev->dev_state == USBD_STATE_CONFIGURED))
            {
              ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_TxSent))(pdev); 
            }
          }
          USBD_CtlReceiveStatus(pdev);
c0d05b9c:	4620      	mov	r0, r4
c0d05b9e:	f000 fc96 	bl	c0d064ce <USBD_CtlReceiveStatus>
c0d05ba2:	20e0      	movs	r0, #224	; 0xe0
        }
      }
    }
    if (pdev->dev_test_mode == 1)
c0d05ba4:	5c20      	ldrb	r0, [r4, r0]
c0d05ba6:	34e0      	adds	r4, #224	; 0xe0
c0d05ba8:	2801      	cmp	r0, #1
c0d05baa:	d101      	bne.n	c0d05bb0 <USBD_LL_DataInStage+0xe2>
c0d05bac:	2000      	movs	r0, #0
    {
      USBD_RunTestMode(pdev); 
      pdev->dev_test_mode = 0;
c0d05bae:	7020      	strb	r0, [r4, #0]
c0d05bb0:	2000      	movs	r0, #0
      {
        ((DataIn_t)PIC(pdev->interfacesClass[intf].pClass->DataIn))(pdev, epnum); 
      }
    }
  }
  return USBD_OK;
c0d05bb2:	b001      	add	sp, #4
c0d05bb4:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d05bb6 <USBD_LL_Reset>:
* @param  pdev: device instance
* @retval status
*/

USBD_StatusTypeDef USBD_LL_Reset(USBD_HandleTypeDef  *pdev)
{
c0d05bb6:	b570      	push	{r4, r5, r6, lr}
c0d05bb8:	4604      	mov	r4, r0
c0d05bba:	2080      	movs	r0, #128	; 0x80
c0d05bbc:	2140      	movs	r1, #64	; 0x40
  pdev->ep_out[0].maxpacket = USB_MAX_EP0_SIZE;
c0d05bbe:	5021      	str	r1, [r4, r0]
c0d05bc0:	20dc      	movs	r0, #220	; 0xdc
c0d05bc2:	2201      	movs	r2, #1
  

  pdev->ep_in[0].maxpacket = USB_MAX_EP0_SIZE;
  /* Upon Reset call user call back */
  pdev->dev_state = USBD_STATE_DEFAULT;
c0d05bc4:	5422      	strb	r2, [r4, r0]
USBD_StatusTypeDef USBD_LL_Reset(USBD_HandleTypeDef  *pdev)
{
  pdev->ep_out[0].maxpacket = USB_MAX_EP0_SIZE;
  

  pdev->ep_in[0].maxpacket = USB_MAX_EP0_SIZE;
c0d05bc6:	6221      	str	r1, [r4, #32]
c0d05bc8:	2500      	movs	r5, #0
c0d05bca:	26f4      	movs	r6, #244	; 0xf4
  /* Upon Reset call user call back */
  pdev->dev_state = USBD_STATE_DEFAULT;
 
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
    if( usbd_is_valid_intf(pdev, intf))
c0d05bcc:	4620      	mov	r0, r4
c0d05bce:	4629      	mov	r1, r5
c0d05bd0:	f000 f834 	bl	c0d05c3c <usbd_is_valid_intf>
c0d05bd4:	2800      	cmp	r0, #0
c0d05bd6:	d007      	beq.n	c0d05be8 <USBD_LL_Reset+0x32>
    {
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config); 
c0d05bd8:	59a0      	ldr	r0, [r4, r6]
c0d05bda:	6840      	ldr	r0, [r0, #4]
c0d05bdc:	f7fe fec6 	bl	c0d0496c <pic>
c0d05be0:	4602      	mov	r2, r0
c0d05be2:	7921      	ldrb	r1, [r4, #4]
c0d05be4:	4620      	mov	r0, r4
c0d05be6:	4790      	blx	r2
  pdev->ep_in[0].maxpacket = USB_MAX_EP0_SIZE;
  /* Upon Reset call user call back */
  pdev->dev_state = USBD_STATE_DEFAULT;
 
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d05be8:	3608      	adds	r6, #8
c0d05bea:	1c6d      	adds	r5, r5, #1
c0d05bec:	2d03      	cmp	r5, #3
c0d05bee:	d1ed      	bne.n	c0d05bcc <USBD_LL_Reset+0x16>
c0d05bf0:	2000      	movs	r0, #0
    {
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config); 
    }
  }
  
  return USBD_OK;
c0d05bf2:	bd70      	pop	{r4, r5, r6, pc}

c0d05bf4 <USBD_LL_SetSpeed>:
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef USBD_LL_SetSpeed(USBD_HandleTypeDef  *pdev, USBD_SpeedTypeDef speed)
{
  pdev->dev_speed = speed;
c0d05bf4:	7401      	strb	r1, [r0, #16]
c0d05bf6:	2000      	movs	r0, #0
  return USBD_OK;
c0d05bf8:	4770      	bx	lr

c0d05bfa <USBD_LL_Suspend>:
* @param  pdev: device instance
* @retval status
*/

USBD_StatusTypeDef USBD_LL_Suspend(USBD_HandleTypeDef  *pdev)
{
c0d05bfa:	2000      	movs	r0, #0
  UNUSED(pdev);
  // Ignored, gently
  //pdev->dev_old_state =  pdev->dev_state;
  //pdev->dev_state  = USBD_STATE_SUSPENDED;
  return USBD_OK;
c0d05bfc:	4770      	bx	lr

c0d05bfe <USBD_LL_Resume>:
* @param  pdev: device instance
* @retval status
*/

USBD_StatusTypeDef USBD_LL_Resume(USBD_HandleTypeDef  *pdev)
{
c0d05bfe:	2000      	movs	r0, #0
  UNUSED(pdev);
  // Ignored, gently
  //pdev->dev_state = pdev->dev_old_state;  
  return USBD_OK;
c0d05c00:	4770      	bx	lr

c0d05c02 <USBD_LL_SOF>:
* @param  pdev: device instance
* @retval status
*/

USBD_StatusTypeDef USBD_LL_SOF(USBD_HandleTypeDef  *pdev)
{
c0d05c02:	b570      	push	{r4, r5, r6, lr}
c0d05c04:	4604      	mov	r4, r0
c0d05c06:	20dc      	movs	r0, #220	; 0xdc
  if(pdev->dev_state == USBD_STATE_CONFIGURED)
c0d05c08:	5c20      	ldrb	r0, [r4, r0]
c0d05c0a:	2803      	cmp	r0, #3
c0d05c0c:	d114      	bne.n	c0d05c38 <USBD_LL_SOF+0x36>
c0d05c0e:	2500      	movs	r5, #0
c0d05c10:	26f4      	movs	r6, #244	; 0xf4
  {
    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) && pdev->interfacesClass[intf].pClass->SOF != NULL)
c0d05c12:	4620      	mov	r0, r4
c0d05c14:	4629      	mov	r1, r5
c0d05c16:	f000 f811 	bl	c0d05c3c <usbd_is_valid_intf>
c0d05c1a:	2800      	cmp	r0, #0
c0d05c1c:	d008      	beq.n	c0d05c30 <USBD_LL_SOF+0x2e>
c0d05c1e:	59a0      	ldr	r0, [r4, r6]
c0d05c20:	69c0      	ldr	r0, [r0, #28]
c0d05c22:	2800      	cmp	r0, #0
c0d05c24:	d004      	beq.n	c0d05c30 <USBD_LL_SOF+0x2e>
      {
        ((SOF_t)PIC(pdev->interfacesClass[intf].pClass->SOF))(pdev); 
c0d05c26:	f7fe fea1 	bl	c0d0496c <pic>
c0d05c2a:	4601      	mov	r1, r0
c0d05c2c:	4620      	mov	r0, r4
c0d05c2e:	4788      	blx	r1
USBD_StatusTypeDef USBD_LL_SOF(USBD_HandleTypeDef  *pdev)
{
  if(pdev->dev_state == USBD_STATE_CONFIGURED)
  {
    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d05c30:	3608      	adds	r6, #8
c0d05c32:	1c6d      	adds	r5, r5, #1
c0d05c34:	2d03      	cmp	r5, #3
c0d05c36:	d1ec      	bne.n	c0d05c12 <USBD_LL_SOF+0x10>
c0d05c38:	2000      	movs	r0, #0
      {
        ((SOF_t)PIC(pdev->interfacesClass[intf].pClass->SOF))(pdev); 
      }
    }
  }
  return USBD_OK;
c0d05c3a:	bd70      	pop	{r4, r5, r6, pc}

c0d05c3c <usbd_is_valid_intf>:

/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
c0d05c3c:	4602      	mov	r2, r0
c0d05c3e:	2000      	movs	r0, #0
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d05c40:	2902      	cmp	r1, #2
c0d05c42:	d807      	bhi.n	c0d05c54 <usbd_is_valid_intf+0x18>
c0d05c44:	00c8      	lsls	r0, r1, #3
c0d05c46:	1810      	adds	r0, r2, r0
c0d05c48:	21f4      	movs	r1, #244	; 0xf4
c0d05c4a:	5841      	ldr	r1, [r0, r1]
c0d05c4c:	2001      	movs	r0, #1
c0d05c4e:	2900      	cmp	r1, #0
c0d05c50:	d100      	bne.n	c0d05c54 <usbd_is_valid_intf+0x18>
c0d05c52:	4608      	mov	r0, r1
c0d05c54:	4770      	bx	lr

c0d05c56 <USBD_StdDevReq>:
* @param  pdev: device instance
* @param  req: usb request
* @retval status
*/
USBD_StatusTypeDef  USBD_StdDevReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
c0d05c56:	b580      	push	{r7, lr}
  USBD_StatusTypeDef ret = USBD_OK;  
  
  switch (req->bRequest) 
c0d05c58:	784a      	ldrb	r2, [r1, #1]
c0d05c5a:	2a04      	cmp	r2, #4
c0d05c5c:	dd08      	ble.n	c0d05c70 <USBD_StdDevReq+0x1a>
c0d05c5e:	2a07      	cmp	r2, #7
c0d05c60:	dc0f      	bgt.n	c0d05c82 <USBD_StdDevReq+0x2c>
c0d05c62:	2a05      	cmp	r2, #5
c0d05c64:	d014      	beq.n	c0d05c90 <USBD_StdDevReq+0x3a>
c0d05c66:	2a06      	cmp	r2, #6
c0d05c68:	d11b      	bne.n	c0d05ca2 <USBD_StdDevReq+0x4c>
  {
  case USB_REQ_GET_DESCRIPTOR: 
    
    USBD_GetDescriptor (pdev, req) ;
c0d05c6a:	f000 f821 	bl	c0d05cb0 <USBD_GetDescriptor>
c0d05c6e:	e01d      	b.n	c0d05cac <USBD_StdDevReq+0x56>
*/
USBD_StatusTypeDef  USBD_StdDevReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
  USBD_StatusTypeDef ret = USBD_OK;  
  
  switch (req->bRequest) 
c0d05c70:	2a00      	cmp	r2, #0
c0d05c72:	d010      	beq.n	c0d05c96 <USBD_StdDevReq+0x40>
c0d05c74:	2a01      	cmp	r2, #1
c0d05c76:	d017      	beq.n	c0d05ca8 <USBD_StdDevReq+0x52>
c0d05c78:	2a03      	cmp	r2, #3
c0d05c7a:	d112      	bne.n	c0d05ca2 <USBD_StdDevReq+0x4c>
    USBD_GetStatus (pdev , req);
    break;
    
    
  case USB_REQ_SET_FEATURE:   
    USBD_SetFeature (pdev , req);    
c0d05c7c:	f000 f930 	bl	c0d05ee0 <USBD_SetFeature>
c0d05c80:	e014      	b.n	c0d05cac <USBD_StdDevReq+0x56>
*/
USBD_StatusTypeDef  USBD_StdDevReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
  USBD_StatusTypeDef ret = USBD_OK;  
  
  switch (req->bRequest) 
c0d05c82:	2a08      	cmp	r2, #8
c0d05c84:	d00a      	beq.n	c0d05c9c <USBD_StdDevReq+0x46>
c0d05c86:	2a09      	cmp	r2, #9
c0d05c88:	d10b      	bne.n	c0d05ca2 <USBD_StdDevReq+0x4c>
  case USB_REQ_SET_ADDRESS:                      
    USBD_SetAddress(pdev, req);
    break;
    
  case USB_REQ_SET_CONFIGURATION:                    
    USBD_SetConfig (pdev , req);
c0d05c8a:	f000 f8b9 	bl	c0d05e00 <USBD_SetConfig>
c0d05c8e:	e00d      	b.n	c0d05cac <USBD_StdDevReq+0x56>
    
    USBD_GetDescriptor (pdev, req) ;
    break;
    
  case USB_REQ_SET_ADDRESS:                      
    USBD_SetAddress(pdev, req);
c0d05c90:	f000 f890 	bl	c0d05db4 <USBD_SetAddress>
c0d05c94:	e00a      	b.n	c0d05cac <USBD_StdDevReq+0x56>
  case USB_REQ_GET_CONFIGURATION:                 
    USBD_GetConfig (pdev , req);
    break;
    
  case USB_REQ_GET_STATUS:                                  
    USBD_GetStatus (pdev , req);
c0d05c96:	f000 f901 	bl	c0d05e9c <USBD_GetStatus>
c0d05c9a:	e007      	b.n	c0d05cac <USBD_StdDevReq+0x56>
  case USB_REQ_SET_CONFIGURATION:                    
    USBD_SetConfig (pdev , req);
    break;
    
  case USB_REQ_GET_CONFIGURATION:                 
    USBD_GetConfig (pdev , req);
c0d05c9c:	f000 f8e7 	bl	c0d05e6e <USBD_GetConfig>
c0d05ca0:	e004      	b.n	c0d05cac <USBD_StdDevReq+0x56>
  case USB_REQ_CLEAR_FEATURE:                                   
    USBD_ClrFeature (pdev , req);
    break;
    
  default:  
    USBD_CtlError(pdev , req);
c0d05ca2:	f000 f962 	bl	c0d05f6a <USBD_CtlError>
c0d05ca6:	e001      	b.n	c0d05cac <USBD_StdDevReq+0x56>
  case USB_REQ_SET_FEATURE:   
    USBD_SetFeature (pdev , req);    
    break;
    
  case USB_REQ_CLEAR_FEATURE:                                   
    USBD_ClrFeature (pdev , req);
c0d05ca8:	f000 f937 	bl	c0d05f1a <USBD_ClrFeature>
c0d05cac:	2000      	movs	r0, #0
  default:  
    USBD_CtlError(pdev , req);
    break;
  }
  
  return ret;
c0d05cae:	bd80      	pop	{r7, pc}

c0d05cb0 <USBD_GetDescriptor>:
* @param  req: usb request
* @retval status
*/
void USBD_GetDescriptor(USBD_HandleTypeDef *pdev , 
                               USBD_SetupReqTypedef *req)
{
c0d05cb0:	b5b0      	push	{r4, r5, r7, lr}
c0d05cb2:	b082      	sub	sp, #8
c0d05cb4:	460d      	mov	r5, r1
c0d05cb6:	4604      	mov	r4, r0
  uint16_t len;
  uint8_t *pbuf = NULL;
  
    
  switch (req->wValue >> 8)
c0d05cb8:	8849      	ldrh	r1, [r1, #2]
c0d05cba:	0a08      	lsrs	r0, r1, #8
c0d05cbc:	2805      	cmp	r0, #5
c0d05cbe:	dc12      	bgt.n	c0d05ce6 <USBD_GetDescriptor+0x36>
c0d05cc0:	2801      	cmp	r0, #1
c0d05cc2:	d01a      	beq.n	c0d05cfa <USBD_GetDescriptor+0x4a>
c0d05cc4:	2802      	cmp	r0, #2
c0d05cc6:	d022      	beq.n	c0d05d0e <USBD_GetDescriptor+0x5e>
c0d05cc8:	2803      	cmp	r0, #3
c0d05cca:	d136      	bne.n	c0d05d3a <USBD_GetDescriptor+0x8a>
c0d05ccc:	b2c8      	uxtb	r0, r1
      }
    }
    break;
    
  case USB_DESC_TYPE_STRING:
    switch ((uint8_t)(req->wValue))
c0d05cce:	2802      	cmp	r0, #2
c0d05cd0:	dc38      	bgt.n	c0d05d44 <USBD_GetDescriptor+0x94>
c0d05cd2:	2800      	cmp	r0, #0
c0d05cd4:	d05e      	beq.n	c0d05d94 <USBD_GetDescriptor+0xe4>
c0d05cd6:	2801      	cmp	r0, #1
c0d05cd8:	d064      	beq.n	c0d05da4 <USBD_GetDescriptor+0xf4>
c0d05cda:	2802      	cmp	r0, #2
c0d05cdc:	d12d      	bne.n	c0d05d3a <USBD_GetDescriptor+0x8a>
c0d05cde:	20f0      	movs	r0, #240	; 0xf0
    case USBD_IDX_MFC_STR:
      pbuf = ((GetManufacturerStrDescriptor_t)PIC(pdev->pDesc->GetManufacturerStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_PRODUCT_STR:
      pbuf = ((GetProductStrDescriptor_t)PIC(pdev->pDesc->GetProductStrDescriptor))(pdev->dev_speed, &len);
c0d05ce0:	5820      	ldr	r0, [r4, r0]
c0d05ce2:	68c0      	ldr	r0, [r0, #12]
c0d05ce4:	e00c      	b.n	c0d05d00 <USBD_GetDescriptor+0x50>
{
  uint16_t len;
  uint8_t *pbuf = NULL;
  
    
  switch (req->wValue >> 8)
c0d05ce6:	2806      	cmp	r0, #6
c0d05ce8:	d01b      	beq.n	c0d05d22 <USBD_GetDescriptor+0x72>
c0d05cea:	2807      	cmp	r0, #7
c0d05cec:	d022      	beq.n	c0d05d34 <USBD_GetDescriptor+0x84>
c0d05cee:	280f      	cmp	r0, #15
c0d05cf0:	d123      	bne.n	c0d05d3a <USBD_GetDescriptor+0x8a>
c0d05cf2:	20f0      	movs	r0, #240	; 0xf0
  { 
#if (USBD_LPM_ENABLED == 1)
  case USB_DESC_TYPE_BOS:
    pbuf = ((GetBOSDescriptor_t)PIC(pdev->pDesc->GetBOSDescriptor))(pdev->dev_speed, &len);
c0d05cf4:	5820      	ldr	r0, [r4, r0]
c0d05cf6:	69c0      	ldr	r0, [r0, #28]
c0d05cf8:	e002      	b.n	c0d05d00 <USBD_GetDescriptor+0x50>
c0d05cfa:	20f0      	movs	r0, #240	; 0xf0
    break;
#endif    
  case USB_DESC_TYPE_DEVICE:
    pbuf = ((GetDeviceDescriptor_t)PIC(pdev->pDesc->GetDeviceDescriptor))(pdev->dev_speed, &len);
c0d05cfc:	5820      	ldr	r0, [r4, r0]
c0d05cfe:	6800      	ldr	r0, [r0, #0]
c0d05d00:	f7fe fe34 	bl	c0d0496c <pic>
c0d05d04:	4602      	mov	r2, r0
c0d05d06:	7c20      	ldrb	r0, [r4, #16]
c0d05d08:	a901      	add	r1, sp, #4
c0d05d0a:	4790      	blx	r2
c0d05d0c:	e030      	b.n	c0d05d70 <USBD_GetDescriptor+0xc0>
c0d05d0e:	20f4      	movs	r0, #244	; 0xf4
    break;
    
  case USB_DESC_TYPE_CONFIGURATION:     
    if(pdev->interfacesClass[0].pClass != NULL) {
c0d05d10:	5820      	ldr	r0, [r4, r0]
c0d05d12:	2100      	movs	r1, #0
c0d05d14:	2800      	cmp	r0, #0
c0d05d16:	d02c      	beq.n	c0d05d72 <USBD_GetDescriptor+0xc2>
      if(pdev->dev_speed == USBD_SPEED_HIGH )   
c0d05d18:	7c21      	ldrb	r1, [r4, #16]
c0d05d1a:	2900      	cmp	r1, #0
c0d05d1c:	d022      	beq.n	c0d05d64 <USBD_GetDescriptor+0xb4>
        pbuf   = (uint8_t *)((GetHSConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetHSConfigDescriptor))(&len);
        //pbuf[1] = USB_DESC_TYPE_CONFIGURATION; CONST BUFFER KTHX
      }
      else
      {
        pbuf   = (uint8_t *)((GetFSConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetFSConfigDescriptor))(&len);
c0d05d1e:	6ac0      	ldr	r0, [r0, #44]	; 0x2c
c0d05d20:	e021      	b.n	c0d05d66 <USBD_GetDescriptor+0xb6>
#endif   
    }
    break;
  case USB_DESC_TYPE_DEVICE_QUALIFIER:                   

    if(pdev->dev_speed == USBD_SPEED_HIGH && pdev->interfacesClass[0].pClass != NULL )   
c0d05d22:	7c20      	ldrb	r0, [r4, #16]
c0d05d24:	2800      	cmp	r0, #0
c0d05d26:	d108      	bne.n	c0d05d3a <USBD_GetDescriptor+0x8a>
c0d05d28:	20f4      	movs	r0, #244	; 0xf4
c0d05d2a:	5820      	ldr	r0, [r4, r0]
c0d05d2c:	2800      	cmp	r0, #0
c0d05d2e:	d004      	beq.n	c0d05d3a <USBD_GetDescriptor+0x8a>
    {
      pbuf   = (uint8_t *)((GetDeviceQualifierDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetDeviceQualifierDescriptor))(&len);
c0d05d30:	6b40      	ldr	r0, [r0, #52]	; 0x34
c0d05d32:	e018      	b.n	c0d05d66 <USBD_GetDescriptor+0xb6>
      USBD_CtlError(pdev , req);
      return;
    } 

  case USB_DESC_TYPE_OTHER_SPEED_CONFIGURATION:
    if(pdev->dev_speed == USBD_SPEED_HIGH && pdev->interfacesClass[0].pClass != NULL)   
c0d05d34:	7c20      	ldrb	r0, [r4, #16]
c0d05d36:	2800      	cmp	r0, #0
c0d05d38:	d00e      	beq.n	c0d05d58 <USBD_GetDescriptor+0xa8>
c0d05d3a:	4620      	mov	r0, r4
c0d05d3c:	4629      	mov	r1, r5
c0d05d3e:	f000 f914 	bl	c0d05f6a <USBD_CtlError>
c0d05d42:	e025      	b.n	c0d05d90 <USBD_GetDescriptor+0xe0>
      }
    }
    break;
    
  case USB_DESC_TYPE_STRING:
    switch ((uint8_t)(req->wValue))
c0d05d44:	2803      	cmp	r0, #3
c0d05d46:	d029      	beq.n	c0d05d9c <USBD_GetDescriptor+0xec>
c0d05d48:	2804      	cmp	r0, #4
c0d05d4a:	d02f      	beq.n	c0d05dac <USBD_GetDescriptor+0xfc>
c0d05d4c:	2805      	cmp	r0, #5
c0d05d4e:	d1f4      	bne.n	c0d05d3a <USBD_GetDescriptor+0x8a>
c0d05d50:	20f0      	movs	r0, #240	; 0xf0
    case USBD_IDX_CONFIG_STR:
      pbuf = ((GetConfigurationStrDescriptor_t)PIC(pdev->pDesc->GetConfigurationStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_INTERFACE_STR:
      pbuf = ((GetInterfaceStrDescriptor_t)PIC(pdev->pDesc->GetInterfaceStrDescriptor))(pdev->dev_speed, &len);
c0d05d52:	5820      	ldr	r0, [r4, r0]
c0d05d54:	6980      	ldr	r0, [r0, #24]
c0d05d56:	e7d3      	b.n	c0d05d00 <USBD_GetDescriptor+0x50>
c0d05d58:	20f4      	movs	r0, #244	; 0xf4
      USBD_CtlError(pdev , req);
      return;
    } 

  case USB_DESC_TYPE_OTHER_SPEED_CONFIGURATION:
    if(pdev->dev_speed == USBD_SPEED_HIGH && pdev->interfacesClass[0].pClass != NULL)   
c0d05d5a:	5820      	ldr	r0, [r4, r0]
c0d05d5c:	2800      	cmp	r0, #0
c0d05d5e:	d0ec      	beq.n	c0d05d3a <USBD_GetDescriptor+0x8a>
    {
      pbuf   = (uint8_t *)((GetOtherSpeedConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetOtherSpeedConfigDescriptor))(&len);
c0d05d60:	6b00      	ldr	r0, [r0, #48]	; 0x30
c0d05d62:	e000      	b.n	c0d05d66 <USBD_GetDescriptor+0xb6>
    
  case USB_DESC_TYPE_CONFIGURATION:     
    if(pdev->interfacesClass[0].pClass != NULL) {
      if(pdev->dev_speed == USBD_SPEED_HIGH )   
      {
        pbuf   = (uint8_t *)((GetHSConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetHSConfigDescriptor))(&len);
c0d05d64:	6a80      	ldr	r0, [r0, #40]	; 0x28
c0d05d66:	f7fe fe01 	bl	c0d0496c <pic>
c0d05d6a:	4601      	mov	r1, r0
c0d05d6c:	a801      	add	r0, sp, #4
c0d05d6e:	4788      	blx	r1
c0d05d70:	4601      	mov	r1, r0
c0d05d72:	a801      	add	r0, sp, #4
  default: 
     USBD_CtlError(pdev , req);
    return;
  }
  
  if((len != 0)&& (req->wLength != 0))
c0d05d74:	8802      	ldrh	r2, [r0, #0]
c0d05d76:	2a00      	cmp	r2, #0
c0d05d78:	d00a      	beq.n	c0d05d90 <USBD_GetDescriptor+0xe0>
c0d05d7a:	88e8      	ldrh	r0, [r5, #6]
c0d05d7c:	2800      	cmp	r0, #0
c0d05d7e:	d007      	beq.n	c0d05d90 <USBD_GetDescriptor+0xe0>
  {
    
    len = MIN(len , req->wLength);
c0d05d80:	4282      	cmp	r2, r0
c0d05d82:	d300      	bcc.n	c0d05d86 <USBD_GetDescriptor+0xd6>
c0d05d84:	4602      	mov	r2, r0
c0d05d86:	a801      	add	r0, sp, #4
c0d05d88:	8002      	strh	r2, [r0, #0]
    
    // prepare abort if host does not read the whole data
    //USBD_CtlReceiveStatus(pdev);

    // start transfer
    USBD_CtlSendData (pdev, 
c0d05d8a:	4620      	mov	r0, r4
c0d05d8c:	f000 fb68 	bl	c0d06460 <USBD_CtlSendData>
                      pbuf,
                      len);
  }
  
}
c0d05d90:	b002      	add	sp, #8
c0d05d92:	bdb0      	pop	{r4, r5, r7, pc}
c0d05d94:	20f0      	movs	r0, #240	; 0xf0
    
  case USB_DESC_TYPE_STRING:
    switch ((uint8_t)(req->wValue))
    {
    case USBD_IDX_LANGID_STR:
     pbuf = ((GetLangIDStrDescriptor_t)PIC(pdev->pDesc->GetLangIDStrDescriptor))(pdev->dev_speed, &len);        
c0d05d96:	5820      	ldr	r0, [r4, r0]
c0d05d98:	6840      	ldr	r0, [r0, #4]
c0d05d9a:	e7b1      	b.n	c0d05d00 <USBD_GetDescriptor+0x50>
c0d05d9c:	20f0      	movs	r0, #240	; 0xf0
    case USBD_IDX_PRODUCT_STR:
      pbuf = ((GetProductStrDescriptor_t)PIC(pdev->pDesc->GetProductStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_SERIAL_STR:
      pbuf = ((GetSerialStrDescriptor_t)PIC(pdev->pDesc->GetSerialStrDescriptor))(pdev->dev_speed, &len);
c0d05d9e:	5820      	ldr	r0, [r4, r0]
c0d05da0:	6900      	ldr	r0, [r0, #16]
c0d05da2:	e7ad      	b.n	c0d05d00 <USBD_GetDescriptor+0x50>
c0d05da4:	20f0      	movs	r0, #240	; 0xf0
    case USBD_IDX_LANGID_STR:
     pbuf = ((GetLangIDStrDescriptor_t)PIC(pdev->pDesc->GetLangIDStrDescriptor))(pdev->dev_speed, &len);        
      break;
      
    case USBD_IDX_MFC_STR:
      pbuf = ((GetManufacturerStrDescriptor_t)PIC(pdev->pDesc->GetManufacturerStrDescriptor))(pdev->dev_speed, &len);
c0d05da6:	5820      	ldr	r0, [r4, r0]
c0d05da8:	6880      	ldr	r0, [r0, #8]
c0d05daa:	e7a9      	b.n	c0d05d00 <USBD_GetDescriptor+0x50>
c0d05dac:	20f0      	movs	r0, #240	; 0xf0
    case USBD_IDX_SERIAL_STR:
      pbuf = ((GetSerialStrDescriptor_t)PIC(pdev->pDesc->GetSerialStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_CONFIG_STR:
      pbuf = ((GetConfigurationStrDescriptor_t)PIC(pdev->pDesc->GetConfigurationStrDescriptor))(pdev->dev_speed, &len);
c0d05dae:	5820      	ldr	r0, [r4, r0]
c0d05db0:	6940      	ldr	r0, [r0, #20]
c0d05db2:	e7a5      	b.n	c0d05d00 <USBD_GetDescriptor+0x50>

c0d05db4 <USBD_SetAddress>:
* @param  req: usb request
* @retval status
*/
void USBD_SetAddress(USBD_HandleTypeDef *pdev , 
                            USBD_SetupReqTypedef *req)
{
c0d05db4:	b570      	push	{r4, r5, r6, lr}
c0d05db6:	4604      	mov	r4, r0
  uint8_t  dev_addr; 
  
  if ((req->wIndex == 0) && (req->wLength == 0)) 
c0d05db8:	8888      	ldrh	r0, [r1, #4]
c0d05dba:	2800      	cmp	r0, #0
c0d05dbc:	d10b      	bne.n	c0d05dd6 <USBD_SetAddress+0x22>
c0d05dbe:	88c8      	ldrh	r0, [r1, #6]
c0d05dc0:	2800      	cmp	r0, #0
c0d05dc2:	d108      	bne.n	c0d05dd6 <USBD_SetAddress+0x22>
  {
    dev_addr = (uint8_t)(req->wValue) & 0x7F;     
c0d05dc4:	8848      	ldrh	r0, [r1, #2]
c0d05dc6:	257f      	movs	r5, #127	; 0x7f
c0d05dc8:	4005      	ands	r5, r0
c0d05dca:	20dc      	movs	r0, #220	; 0xdc
    
    if (pdev->dev_state == USBD_STATE_CONFIGURED) 
c0d05dcc:	5c20      	ldrb	r0, [r4, r0]
c0d05dce:	4626      	mov	r6, r4
c0d05dd0:	36dc      	adds	r6, #220	; 0xdc
c0d05dd2:	2803      	cmp	r0, #3
c0d05dd4:	d103      	bne.n	c0d05dde <USBD_SetAddress+0x2a>
c0d05dd6:	4620      	mov	r0, r4
c0d05dd8:	f000 f8c7 	bl	c0d05f6a <USBD_CtlError>
  } 
  else 
  {
     USBD_CtlError(pdev , req);                        
  } 
}
c0d05ddc:	bd70      	pop	{r4, r5, r6, pc}
c0d05dde:	20de      	movs	r0, #222	; 0xde
    {
      USBD_CtlError(pdev , req);
    } 
    else 
    {
      pdev->dev_address = dev_addr;
c0d05de0:	5425      	strb	r5, [r4, r0]
      USBD_LL_SetUSBAddress(pdev, dev_addr);               
c0d05de2:	4620      	mov	r0, r4
c0d05de4:	4629      	mov	r1, r5
c0d05de6:	f7ff fd2f 	bl	c0d05848 <USBD_LL_SetUSBAddress>
      USBD_CtlSendStatus(pdev);                         
c0d05dea:	4620      	mov	r0, r4
c0d05dec:	f000 fb63 	bl	c0d064b6 <USBD_CtlSendStatus>
      
      if (dev_addr != 0) 
c0d05df0:	2d00      	cmp	r5, #0
c0d05df2:	d002      	beq.n	c0d05dfa <USBD_SetAddress+0x46>
c0d05df4:	2002      	movs	r0, #2
      {
        pdev->dev_state  = USBD_STATE_ADDRESSED;
c0d05df6:	7030      	strb	r0, [r6, #0]
  } 
  else 
  {
     USBD_CtlError(pdev , req);                        
  } 
}
c0d05df8:	bd70      	pop	{r4, r5, r6, pc}
c0d05dfa:	2001      	movs	r0, #1
      {
        pdev->dev_state  = USBD_STATE_ADDRESSED;
      } 
      else 
      {
        pdev->dev_state  = USBD_STATE_DEFAULT; 
c0d05dfc:	7030      	strb	r0, [r6, #0]
  } 
  else 
  {
     USBD_CtlError(pdev , req);                        
  } 
}
c0d05dfe:	bd70      	pop	{r4, r5, r6, pc}

c0d05e00 <USBD_SetConfig>:
* @param  req: usb request
* @retval status
*/
void USBD_SetConfig(USBD_HandleTypeDef *pdev , 
                           USBD_SetupReqTypedef *req)
{
c0d05e00:	b570      	push	{r4, r5, r6, lr}
c0d05e02:	460d      	mov	r5, r1
c0d05e04:	4604      	mov	r4, r0
  
  uint8_t  cfgidx;
  
  cfgidx = (uint8_t)(req->wValue);                 
c0d05e06:	788e      	ldrb	r6, [r1, #2]
  
  if (cfgidx > USBD_MAX_NUM_CONFIGURATION ) 
c0d05e08:	2e02      	cmp	r6, #2
c0d05e0a:	d21d      	bcs.n	c0d05e48 <USBD_SetConfig+0x48>
c0d05e0c:	20dc      	movs	r0, #220	; 0xdc
  {            
     USBD_CtlError(pdev , req);                              
  } 
  else 
  {
    switch (pdev->dev_state) 
c0d05e0e:	5c21      	ldrb	r1, [r4, r0]
c0d05e10:	4620      	mov	r0, r4
c0d05e12:	30dc      	adds	r0, #220	; 0xdc
c0d05e14:	2903      	cmp	r1, #3
c0d05e16:	d007      	beq.n	c0d05e28 <USBD_SetConfig+0x28>
c0d05e18:	2902      	cmp	r1, #2
c0d05e1a:	d115      	bne.n	c0d05e48 <USBD_SetConfig+0x48>
    {
    case USBD_STATE_ADDRESSED:
      if (cfgidx) 
c0d05e1c:	2e00      	cmp	r6, #0
c0d05e1e:	d022      	beq.n	c0d05e66 <USBD_SetConfig+0x66>
      {                                			   							   							   				
        pdev->dev_config = cfgidx;
c0d05e20:	6066      	str	r6, [r4, #4]
c0d05e22:	2103      	movs	r1, #3
        pdev->dev_state = USBD_STATE_CONFIGURED;
c0d05e24:	7001      	strb	r1, [r0, #0]
c0d05e26:	e009      	b.n	c0d05e3c <USBD_SetConfig+0x3c>
      }
      USBD_CtlSendStatus(pdev);
      break;
      
    case USBD_STATE_CONFIGURED:
      if (cfgidx == 0) 
c0d05e28:	2e00      	cmp	r6, #0
c0d05e2a:	d012      	beq.n	c0d05e52 <USBD_SetConfig+0x52>
        pdev->dev_state = USBD_STATE_ADDRESSED;
        pdev->dev_config = cfgidx;          
        USBD_ClrClassConfig(pdev , cfgidx);
        USBD_CtlSendStatus(pdev);
      } 
      else  if (cfgidx != pdev->dev_config) 
c0d05e2c:	6860      	ldr	r0, [r4, #4]
c0d05e2e:	42b0      	cmp	r0, r6
c0d05e30:	d019      	beq.n	c0d05e66 <USBD_SetConfig+0x66>
      {
        /* Clear old configuration */
        USBD_ClrClassConfig(pdev , pdev->dev_config);
c0d05e32:	b2c1      	uxtb	r1, r0
c0d05e34:	4620      	mov	r0, r4
c0d05e36:	f7ff fda9 	bl	c0d0598c <USBD_ClrClassConfig>
        
        /* set new configuration */
        pdev->dev_config = cfgidx;
c0d05e3a:	6066      	str	r6, [r4, #4]
c0d05e3c:	4620      	mov	r0, r4
c0d05e3e:	4631      	mov	r1, r6
c0d05e40:	f7ff fd89 	bl	c0d05956 <USBD_SetClassConfig>
c0d05e44:	2802      	cmp	r0, #2
c0d05e46:	d10e      	bne.n	c0d05e66 <USBD_SetConfig+0x66>
c0d05e48:	4620      	mov	r0, r4
c0d05e4a:	4629      	mov	r1, r5
c0d05e4c:	f000 f88d 	bl	c0d05f6a <USBD_CtlError>
    default:					
       USBD_CtlError(pdev , req);                     
      break;
    }
  }
}
c0d05e50:	bd70      	pop	{r4, r5, r6, pc}
c0d05e52:	2102      	movs	r1, #2
      break;
      
    case USBD_STATE_CONFIGURED:
      if (cfgidx == 0) 
      {                           
        pdev->dev_state = USBD_STATE_ADDRESSED;
c0d05e54:	7001      	strb	r1, [r0, #0]
        pdev->dev_config = cfgidx;          
c0d05e56:	6066      	str	r6, [r4, #4]
        USBD_ClrClassConfig(pdev , cfgidx);
c0d05e58:	4620      	mov	r0, r4
c0d05e5a:	4631      	mov	r1, r6
c0d05e5c:	f7ff fd96 	bl	c0d0598c <USBD_ClrClassConfig>
        USBD_CtlSendStatus(pdev);
c0d05e60:	4620      	mov	r0, r4
c0d05e62:	f000 fb28 	bl	c0d064b6 <USBD_CtlSendStatus>
c0d05e66:	4620      	mov	r0, r4
c0d05e68:	f000 fb25 	bl	c0d064b6 <USBD_CtlSendStatus>
    default:					
       USBD_CtlError(pdev , req);                     
      break;
    }
  }
}
c0d05e6c:	bd70      	pop	{r4, r5, r6, pc}

c0d05e6e <USBD_GetConfig>:
* @param  req: usb request
* @retval status
*/
void USBD_GetConfig(USBD_HandleTypeDef *pdev , 
                           USBD_SetupReqTypedef *req)
{
c0d05e6e:	b580      	push	{r7, lr}

  if (req->wLength != 1) 
c0d05e70:	88ca      	ldrh	r2, [r1, #6]
c0d05e72:	2a01      	cmp	r2, #1
c0d05e74:	d10a      	bne.n	c0d05e8c <USBD_GetConfig+0x1e>
c0d05e76:	22dc      	movs	r2, #220	; 0xdc
  {                   
     USBD_CtlError(pdev , req);
  }
  else 
  {
    switch (pdev->dev_state )  
c0d05e78:	5c82      	ldrb	r2, [r0, r2]
c0d05e7a:	2a03      	cmp	r2, #3
c0d05e7c:	d009      	beq.n	c0d05e92 <USBD_GetConfig+0x24>
c0d05e7e:	2a02      	cmp	r2, #2
c0d05e80:	d104      	bne.n	c0d05e8c <USBD_GetConfig+0x1e>
c0d05e82:	2100      	movs	r1, #0
    {
    case USBD_STATE_ADDRESSED:                     
      pdev->dev_default_config = 0;
c0d05e84:	6081      	str	r1, [r0, #8]
c0d05e86:	4601      	mov	r1, r0
c0d05e88:	3108      	adds	r1, #8
c0d05e8a:	e003      	b.n	c0d05e94 <USBD_GetConfig+0x26>
c0d05e8c:	f000 f86d 	bl	c0d05f6a <USBD_CtlError>
    default:
       USBD_CtlError(pdev , req);
      break;
    }
  }
}
c0d05e90:	bd80      	pop	{r7, pc}
                        1);
      break;
      
    case USBD_STATE_CONFIGURED:   
      USBD_CtlSendData (pdev, 
                        (uint8_t *)&pdev->dev_config,
c0d05e92:	1d01      	adds	r1, r0, #4
c0d05e94:	2201      	movs	r2, #1
c0d05e96:	f000 fae3 	bl	c0d06460 <USBD_CtlSendData>
    default:
       USBD_CtlError(pdev , req);
      break;
    }
  }
}
c0d05e9a:	bd80      	pop	{r7, pc}

c0d05e9c <USBD_GetStatus>:
* @param  req: usb request
* @retval status
*/
void USBD_GetStatus(USBD_HandleTypeDef *pdev , 
                           USBD_SetupReqTypedef *req)
{
c0d05e9c:	b5b0      	push	{r4, r5, r7, lr}
c0d05e9e:	4604      	mov	r4, r0
c0d05ea0:	20dc      	movs	r0, #220	; 0xdc
  
    
  switch (pdev->dev_state) 
c0d05ea2:	5c20      	ldrb	r0, [r4, r0]
c0d05ea4:	22fe      	movs	r2, #254	; 0xfe
c0d05ea6:	4002      	ands	r2, r0
c0d05ea8:	2a02      	cmp	r2, #2
c0d05eaa:	d115      	bne.n	c0d05ed8 <USBD_GetStatus+0x3c>
c0d05eac:	2001      	movs	r0, #1
  {
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    
#if ( USBD_SELF_POWERED == 1)
    pdev->dev_config_status = USB_CONFIG_SELF_POWERED;                                  
c0d05eae:	60e0      	str	r0, [r4, #12]
c0d05eb0:	20e4      	movs	r0, #228	; 0xe4
#else
    pdev->dev_config_status = 0;                                   
#endif
                      
    if (pdev->dev_remote_wakeup) USBD_CtlReceiveStatus(pdev);
c0d05eb2:	5821      	ldr	r1, [r4, r0]
  {
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    
#if ( USBD_SELF_POWERED == 1)
    pdev->dev_config_status = USB_CONFIG_SELF_POWERED;                                  
c0d05eb4:	4625      	mov	r5, r4
c0d05eb6:	350c      	adds	r5, #12
c0d05eb8:	2003      	movs	r0, #3
#else
    pdev->dev_config_status = 0;                                   
#endif
                      
    if (pdev->dev_remote_wakeup) USBD_CtlReceiveStatus(pdev);
c0d05eba:	2900      	cmp	r1, #0
c0d05ebc:	d005      	beq.n	c0d05eca <USBD_GetStatus+0x2e>
c0d05ebe:	4620      	mov	r0, r4
c0d05ec0:	f000 fb05 	bl	c0d064ce <USBD_CtlReceiveStatus>
    {
       pdev->dev_config_status |= USB_CONFIG_REMOTE_WAKEUP;                                
c0d05ec4:	68e1      	ldr	r1, [r4, #12]
c0d05ec6:	2002      	movs	r0, #2
    pdev->dev_config_status = USB_CONFIG_SELF_POWERED;                                  
#else
    pdev->dev_config_status = 0;                                   
#endif
                      
    if (pdev->dev_remote_wakeup) USBD_CtlReceiveStatus(pdev);
c0d05ec8:	4308      	orrs	r0, r1
    {
       pdev->dev_config_status |= USB_CONFIG_REMOTE_WAKEUP;                                
c0d05eca:	60e0      	str	r0, [r4, #12]
c0d05ecc:	2202      	movs	r2, #2
    }
    
    USBD_CtlSendData (pdev, 
c0d05ece:	4620      	mov	r0, r4
c0d05ed0:	4629      	mov	r1, r5
c0d05ed2:	f000 fac5 	bl	c0d06460 <USBD_CtlSendData>
    
  default :
    USBD_CtlError(pdev , req);                        
    break;
  }
}
c0d05ed6:	bdb0      	pop	{r4, r5, r7, pc}
                      (uint8_t *)& pdev->dev_config_status,
                      2);
    break;
    
  default :
    USBD_CtlError(pdev , req);                        
c0d05ed8:	4620      	mov	r0, r4
c0d05eda:	f000 f846 	bl	c0d05f6a <USBD_CtlError>
    break;
  }
}
c0d05ede:	bdb0      	pop	{r4, r5, r7, pc}

c0d05ee0 <USBD_SetFeature>:
* @param  req: usb request
* @retval status
*/
void USBD_SetFeature(USBD_HandleTypeDef *pdev , 
                            USBD_SetupReqTypedef *req)
{
c0d05ee0:	b5b0      	push	{r4, r5, r7, lr}
c0d05ee2:	4604      	mov	r4, r0

  if (req->wValue == USB_FEATURE_REMOTE_WAKEUP)
c0d05ee4:	8848      	ldrh	r0, [r1, #2]
c0d05ee6:	2801      	cmp	r0, #1
c0d05ee8:	d116      	bne.n	c0d05f18 <USBD_SetFeature+0x38>
c0d05eea:	460d      	mov	r5, r1
c0d05eec:	20e4      	movs	r0, #228	; 0xe4
c0d05eee:	2101      	movs	r1, #1
  {
    pdev->dev_remote_wakeup = 1;  
c0d05ef0:	5021      	str	r1, [r4, r0]
    if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d05ef2:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d05ef4:	2802      	cmp	r0, #2
c0d05ef6:	d80c      	bhi.n	c0d05f12 <USBD_SetFeature+0x32>
c0d05ef8:	00c0      	lsls	r0, r0, #3
c0d05efa:	1820      	adds	r0, r4, r0
c0d05efc:	21f4      	movs	r1, #244	; 0xf4
c0d05efe:	5840      	ldr	r0, [r0, r1]
{

  if (req->wValue == USB_FEATURE_REMOTE_WAKEUP)
  {
    pdev->dev_remote_wakeup = 1;  
    if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d05f00:	2800      	cmp	r0, #0
c0d05f02:	d006      	beq.n	c0d05f12 <USBD_SetFeature+0x32>
      ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);   
c0d05f04:	6880      	ldr	r0, [r0, #8]
c0d05f06:	f7fe fd31 	bl	c0d0496c <pic>
c0d05f0a:	4602      	mov	r2, r0
c0d05f0c:	4620      	mov	r0, r4
c0d05f0e:	4629      	mov	r1, r5
c0d05f10:	4790      	blx	r2
    }
    USBD_CtlSendStatus(pdev);
c0d05f12:	4620      	mov	r0, r4
c0d05f14:	f000 facf 	bl	c0d064b6 <USBD_CtlSendStatus>
  }

}
c0d05f18:	bdb0      	pop	{r4, r5, r7, pc}

c0d05f1a <USBD_ClrFeature>:
* @param  req: usb request
* @retval status
*/
void USBD_ClrFeature(USBD_HandleTypeDef *pdev , 
                            USBD_SetupReqTypedef *req)
{
c0d05f1a:	b5b0      	push	{r4, r5, r7, lr}
c0d05f1c:	460d      	mov	r5, r1
c0d05f1e:	4604      	mov	r4, r0
c0d05f20:	20dc      	movs	r0, #220	; 0xdc
  switch (pdev->dev_state)
c0d05f22:	5c20      	ldrb	r0, [r4, r0]
c0d05f24:	21fe      	movs	r1, #254	; 0xfe
c0d05f26:	4001      	ands	r1, r0
c0d05f28:	2902      	cmp	r1, #2
c0d05f2a:	d119      	bne.n	c0d05f60 <USBD_ClrFeature+0x46>
  {
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    if (req->wValue == USB_FEATURE_REMOTE_WAKEUP) 
c0d05f2c:	8868      	ldrh	r0, [r5, #2]
c0d05f2e:	2801      	cmp	r0, #1
c0d05f30:	d11a      	bne.n	c0d05f68 <USBD_ClrFeature+0x4e>
c0d05f32:	20e4      	movs	r0, #228	; 0xe4
c0d05f34:	2100      	movs	r1, #0
    {
      pdev->dev_remote_wakeup = 0; 
c0d05f36:	5021      	str	r1, [r4, r0]
      if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d05f38:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d05f3a:	2802      	cmp	r0, #2
c0d05f3c:	d80c      	bhi.n	c0d05f58 <USBD_ClrFeature+0x3e>
c0d05f3e:	00c0      	lsls	r0, r0, #3
c0d05f40:	1820      	adds	r0, r4, r0
c0d05f42:	21f4      	movs	r1, #244	; 0xf4
c0d05f44:	5840      	ldr	r0, [r0, r1]
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    if (req->wValue == USB_FEATURE_REMOTE_WAKEUP) 
    {
      pdev->dev_remote_wakeup = 0; 
      if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d05f46:	2800      	cmp	r0, #0
c0d05f48:	d006      	beq.n	c0d05f58 <USBD_ClrFeature+0x3e>
        ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);   
c0d05f4a:	6880      	ldr	r0, [r0, #8]
c0d05f4c:	f7fe fd0e 	bl	c0d0496c <pic>
c0d05f50:	4602      	mov	r2, r0
c0d05f52:	4620      	mov	r0, r4
c0d05f54:	4629      	mov	r1, r5
c0d05f56:	4790      	blx	r2
      }
      USBD_CtlSendStatus(pdev);
c0d05f58:	4620      	mov	r0, r4
c0d05f5a:	f000 faac 	bl	c0d064b6 <USBD_CtlSendStatus>
    
  default :
     USBD_CtlError(pdev , req);
    break;
  }
}
c0d05f5e:	bdb0      	pop	{r4, r5, r7, pc}
      USBD_CtlSendStatus(pdev);
    }
    break;
    
  default :
     USBD_CtlError(pdev , req);
c0d05f60:	4620      	mov	r0, r4
c0d05f62:	4629      	mov	r1, r5
c0d05f64:	f000 f801 	bl	c0d05f6a <USBD_CtlError>
    break;
  }
}
c0d05f68:	bdb0      	pop	{r4, r5, r7, pc}

c0d05f6a <USBD_CtlError>:
  USBD_LL_StallEP(pdev , 0);
}

__weak void USBD_CtlError( USBD_HandleTypeDef *pdev ,
                            USBD_SetupReqTypedef *req)
{
c0d05f6a:	b510      	push	{r4, lr}
c0d05f6c:	4604      	mov	r4, r0
c0d05f6e:	2180      	movs	r1, #128	; 0x80
* @param  req: usb request
* @retval None
*/
void USBD_CtlStall( USBD_HandleTypeDef *pdev)
{
  USBD_LL_StallEP(pdev , 0x80);
c0d05f70:	f7ff fc12 	bl	c0d05798 <USBD_LL_StallEP>
c0d05f74:	2100      	movs	r1, #0
  USBD_LL_StallEP(pdev , 0);
c0d05f76:	4620      	mov	r0, r4
c0d05f78:	f7ff fc0e 	bl	c0d05798 <USBD_LL_StallEP>
__weak void USBD_CtlError( USBD_HandleTypeDef *pdev ,
                            USBD_SetupReqTypedef *req)
{
  UNUSED(req);
  USBD_CtlStall(pdev);
}
c0d05f7c:	bd10      	pop	{r4, pc}

c0d05f7e <USBD_StdItfReq>:
* @param  pdev: device instance
* @param  req: usb request
* @retval status
*/
USBD_StatusTypeDef  USBD_StdItfReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
c0d05f7e:	b5b0      	push	{r4, r5, r7, lr}
c0d05f80:	460d      	mov	r5, r1
c0d05f82:	4604      	mov	r4, r0
c0d05f84:	20dc      	movs	r0, #220	; 0xdc
  USBD_StatusTypeDef ret = USBD_OK; 
  
  switch (pdev->dev_state) 
c0d05f86:	5c20      	ldrb	r0, [r4, r0]
c0d05f88:	2803      	cmp	r0, #3
c0d05f8a:	d116      	bne.n	c0d05fba <USBD_StdItfReq+0x3c>
  {
  case USBD_STATE_CONFIGURED:
    
    if (usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) 
c0d05f8c:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d05f8e:	2802      	cmp	r0, #2
c0d05f90:	d813      	bhi.n	c0d05fba <USBD_StdItfReq+0x3c>
c0d05f92:	00c0      	lsls	r0, r0, #3
c0d05f94:	1820      	adds	r0, r4, r0
c0d05f96:	21f4      	movs	r1, #244	; 0xf4
c0d05f98:	5840      	ldr	r0, [r0, r1]
  
  switch (pdev->dev_state) 
  {
  case USBD_STATE_CONFIGURED:
    
    if (usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) 
c0d05f9a:	2800      	cmp	r0, #0
c0d05f9c:	d00d      	beq.n	c0d05fba <USBD_StdItfReq+0x3c>
    {
      ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);
c0d05f9e:	6880      	ldr	r0, [r0, #8]
c0d05fa0:	f7fe fce4 	bl	c0d0496c <pic>
c0d05fa4:	4602      	mov	r2, r0
c0d05fa6:	4620      	mov	r0, r4
c0d05fa8:	4629      	mov	r1, r5
c0d05faa:	4790      	blx	r2
      
      if((req->wLength == 0)&& (ret == USBD_OK))
c0d05fac:	88e8      	ldrh	r0, [r5, #6]
c0d05fae:	2800      	cmp	r0, #0
c0d05fb0:	d107      	bne.n	c0d05fc2 <USBD_StdItfReq+0x44>
      {
         USBD_CtlSendStatus(pdev);
c0d05fb2:	4620      	mov	r0, r4
c0d05fb4:	f000 fa7f 	bl	c0d064b6 <USBD_CtlSendStatus>
c0d05fb8:	e003      	b.n	c0d05fc2 <USBD_StdItfReq+0x44>
c0d05fba:	4620      	mov	r0, r4
c0d05fbc:	4629      	mov	r1, r5
c0d05fbe:	f7ff ffd4 	bl	c0d05f6a <USBD_CtlError>
c0d05fc2:	2000      	movs	r0, #0
    
  default:
     USBD_CtlError(pdev , req);
    break;
  }
  return USBD_OK;
c0d05fc4:	bdb0      	pop	{r4, r5, r7, pc}

c0d05fc6 <USBD_StdEPReq>:
* @param  pdev: device instance
* @param  req: usb request
* @retval status
*/
USBD_StatusTypeDef  USBD_StdEPReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
c0d05fc6:	b5b0      	push	{r4, r5, r7, lr}
c0d05fc8:	460d      	mov	r5, r1
c0d05fca:	4604      	mov	r4, r0
  USBD_StatusTypeDef ret = USBD_OK; 
  USBD_EndpointTypeDef   *pep;
  ep_addr  = LOBYTE(req->wIndex);   
  
  /* Check if it is a class request */
  if ((req->bmRequest & 0x60) == 0x20 && usbd_is_valid_intf(pdev, LOBYTE(req->wIndex)))
c0d05fcc:	7808      	ldrb	r0, [r1, #0]
c0d05fce:	2260      	movs	r2, #96	; 0x60
c0d05fd0:	4002      	ands	r2, r0
{
  
  uint8_t   ep_addr;
  USBD_StatusTypeDef ret = USBD_OK; 
  USBD_EndpointTypeDef   *pep;
  ep_addr  = LOBYTE(req->wIndex);   
c0d05fd2:	7909      	ldrb	r1, [r1, #4]
  
  /* Check if it is a class request */
  if ((req->bmRequest & 0x60) == 0x20 && usbd_is_valid_intf(pdev, LOBYTE(req->wIndex)))
c0d05fd4:	2a20      	cmp	r2, #32
c0d05fd6:	d10f      	bne.n	c0d05ff8 <USBD_StdEPReq+0x32>
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d05fd8:	2902      	cmp	r1, #2
c0d05fda:	d80d      	bhi.n	c0d05ff8 <USBD_StdEPReq+0x32>
c0d05fdc:	00c8      	lsls	r0, r1, #3
c0d05fde:	1820      	adds	r0, r4, r0
c0d05fe0:	22f4      	movs	r2, #244	; 0xf4
c0d05fe2:	5880      	ldr	r0, [r0, r2]
  USBD_StatusTypeDef ret = USBD_OK; 
  USBD_EndpointTypeDef   *pep;
  ep_addr  = LOBYTE(req->wIndex);   
  
  /* Check if it is a class request */
  if ((req->bmRequest & 0x60) == 0x20 && usbd_is_valid_intf(pdev, LOBYTE(req->wIndex)))
c0d05fe4:	2800      	cmp	r0, #0
c0d05fe6:	d007      	beq.n	c0d05ff8 <USBD_StdEPReq+0x32>
  {
    ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);
c0d05fe8:	6880      	ldr	r0, [r0, #8]
c0d05fea:	f7fe fcbf 	bl	c0d0496c <pic>
c0d05fee:	4602      	mov	r2, r0
c0d05ff0:	4620      	mov	r0, r4
c0d05ff2:	4629      	mov	r1, r5
c0d05ff4:	4790      	blx	r2
c0d05ff6:	e068      	b.n	c0d060ca <USBD_StdEPReq+0x104>
    
    return USBD_OK;
  }
  
  switch (req->bRequest) 
c0d05ff8:	7868      	ldrb	r0, [r5, #1]
c0d05ffa:	2800      	cmp	r0, #0
c0d05ffc:	d016      	beq.n	c0d0602c <USBD_StdEPReq+0x66>
c0d05ffe:	2801      	cmp	r0, #1
c0d06000:	d01d      	beq.n	c0d0603e <USBD_StdEPReq+0x78>
c0d06002:	2803      	cmp	r0, #3
c0d06004:	d161      	bne.n	c0d060ca <USBD_StdEPReq+0x104>
c0d06006:	20dc      	movs	r0, #220	; 0xdc
  {
    
  case USB_REQ_SET_FEATURE :
    
    switch (pdev->dev_state) 
c0d06008:	5c20      	ldrb	r0, [r4, r0]
c0d0600a:	2803      	cmp	r0, #3
c0d0600c:	d11b      	bne.n	c0d06046 <USBD_StdEPReq+0x80>
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:   
      if (req->wValue == USB_FEATURE_EP_HALT)
c0d0600e:	8868      	ldrh	r0, [r5, #2]
c0d06010:	2800      	cmp	r0, #0
c0d06012:	d107      	bne.n	c0d06024 <USBD_StdEPReq+0x5e>
c0d06014:	2080      	movs	r0, #128	; 0x80
      {
        if ((ep_addr != 0x00) && (ep_addr != 0x80)) 
c0d06016:	4308      	orrs	r0, r1
c0d06018:	2880      	cmp	r0, #128	; 0x80
c0d0601a:	d003      	beq.n	c0d06024 <USBD_StdEPReq+0x5e>
        { 
          USBD_LL_StallEP(pdev , ep_addr);
c0d0601c:	4620      	mov	r0, r4
c0d0601e:	f7ff fbbb 	bl	c0d05798 <USBD_LL_StallEP>
          
        }
c0d06022:	7929      	ldrb	r1, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d06024:	2902      	cmp	r1, #2
c0d06026:	d84d      	bhi.n	c0d060c4 <USBD_StdEPReq+0xfe>
c0d06028:	00c8      	lsls	r0, r1, #3
c0d0602a:	e03f      	b.n	c0d060ac <USBD_StdEPReq+0xe6>
c0d0602c:	20dc      	movs	r0, #220	; 0xdc
      break;    
    }
    break;
    
  case USB_REQ_GET_STATUS:                  
    switch (pdev->dev_state) 
c0d0602e:	5c20      	ldrb	r0, [r4, r0]
c0d06030:	2803      	cmp	r0, #3
c0d06032:	d017      	beq.n	c0d06064 <USBD_StdEPReq+0x9e>
c0d06034:	2802      	cmp	r0, #2
c0d06036:	d110      	bne.n	c0d0605a <USBD_StdEPReq+0x94>
    {
    case USBD_STATE_ADDRESSED:          
      if ((ep_addr & 0x7F) != 0x00) 
c0d06038:	0648      	lsls	r0, r1, #25
c0d0603a:	d10a      	bne.n	c0d06052 <USBD_StdEPReq+0x8c>
c0d0603c:	e045      	b.n	c0d060ca <USBD_StdEPReq+0x104>
c0d0603e:	20dc      	movs	r0, #220	; 0xdc
    }
    break;
    
  case USB_REQ_CLEAR_FEATURE :
    
    switch (pdev->dev_state) 
c0d06040:	5c20      	ldrb	r0, [r4, r0]
c0d06042:	2803      	cmp	r0, #3
c0d06044:	d026      	beq.n	c0d06094 <USBD_StdEPReq+0xce>
c0d06046:	2802      	cmp	r0, #2
c0d06048:	d107      	bne.n	c0d0605a <USBD_StdEPReq+0x94>
c0d0604a:	2080      	movs	r0, #128	; 0x80
c0d0604c:	4308      	orrs	r0, r1
c0d0604e:	2880      	cmp	r0, #128	; 0x80
c0d06050:	d03b      	beq.n	c0d060ca <USBD_StdEPReq+0x104>
c0d06052:	4620      	mov	r0, r4
c0d06054:	f7ff fba0 	bl	c0d05798 <USBD_LL_StallEP>
c0d06058:	e037      	b.n	c0d060ca <USBD_StdEPReq+0x104>
c0d0605a:	4620      	mov	r0, r4
c0d0605c:	4629      	mov	r1, r5
c0d0605e:	f7ff ff84 	bl	c0d05f6a <USBD_CtlError>
c0d06062:	e032      	b.n	c0d060ca <USBD_StdEPReq+0x104>
c0d06064:	207f      	movs	r0, #127	; 0x7f
c0d06066:	4008      	ands	r0, r1
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:
      pep = ((ep_addr & 0x80) == 0x80) ? &pdev->ep_in[ep_addr & 0x7F]:\
c0d06068:	0100      	lsls	r0, r0, #4
c0d0606a:	1820      	adds	r0, r4, r0
                                         &pdev->ep_out[ep_addr & 0x7F];
c0d0606c:	4605      	mov	r5, r0
c0d0606e:	3574      	adds	r5, #116	; 0x74
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:
      pep = ((ep_addr & 0x80) == 0x80) ? &pdev->ep_in[ep_addr & 0x7F]:\
c0d06070:	3014      	adds	r0, #20
c0d06072:	060a      	lsls	r2, r1, #24
c0d06074:	d500      	bpl.n	c0d06078 <USBD_StdEPReq+0xb2>
c0d06076:	4605      	mov	r5, r0
                                         &pdev->ep_out[ep_addr & 0x7F];
      if(USBD_LL_IsStallEP(pdev, ep_addr))
c0d06078:	4620      	mov	r0, r4
c0d0607a:	f7ff fbd5 	bl	c0d05828 <USBD_LL_IsStallEP>
c0d0607e:	2101      	movs	r1, #1
c0d06080:	2800      	cmp	r0, #0
c0d06082:	d100      	bne.n	c0d06086 <USBD_StdEPReq+0xc0>
c0d06084:	4601      	mov	r1, r0
c0d06086:	6029      	str	r1, [r5, #0]
c0d06088:	2202      	movs	r2, #2
      else
      {
        pep->status = 0x0000;  
      }
      
      USBD_CtlSendData (pdev,
c0d0608a:	4620      	mov	r0, r4
c0d0608c:	4629      	mov	r1, r5
c0d0608e:	f000 f9e7 	bl	c0d06460 <USBD_CtlSendData>
c0d06092:	e01a      	b.n	c0d060ca <USBD_StdEPReq+0x104>
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:   
      if (req->wValue == USB_FEATURE_EP_HALT)
c0d06094:	8868      	ldrh	r0, [r5, #2]
c0d06096:	2800      	cmp	r0, #0
c0d06098:	d117      	bne.n	c0d060ca <USBD_StdEPReq+0x104>
      {
        if ((ep_addr & 0x7F) != 0x00) 
c0d0609a:	0648      	lsls	r0, r1, #25
c0d0609c:	d012      	beq.n	c0d060c4 <USBD_StdEPReq+0xfe>
        {        
          USBD_LL_ClearStallEP(pdev , ep_addr);
c0d0609e:	4620      	mov	r0, r4
c0d060a0:	f7ff fb9e 	bl	c0d057e0 <USBD_LL_ClearStallEP>
          if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d060a4:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d060a6:	2802      	cmp	r0, #2
c0d060a8:	d80c      	bhi.n	c0d060c4 <USBD_StdEPReq+0xfe>
c0d060aa:	00c0      	lsls	r0, r0, #3
c0d060ac:	1820      	adds	r0, r4, r0
c0d060ae:	21f4      	movs	r1, #244	; 0xf4
c0d060b0:	5840      	ldr	r0, [r0, r1]
c0d060b2:	2800      	cmp	r0, #0
c0d060b4:	d006      	beq.n	c0d060c4 <USBD_StdEPReq+0xfe>
c0d060b6:	6880      	ldr	r0, [r0, #8]
c0d060b8:	f7fe fc58 	bl	c0d0496c <pic>
c0d060bc:	4602      	mov	r2, r0
c0d060be:	4620      	mov	r0, r4
c0d060c0:	4629      	mov	r1, r5
c0d060c2:	4790      	blx	r2
c0d060c4:	4620      	mov	r0, r4
c0d060c6:	f000 f9f6 	bl	c0d064b6 <USBD_CtlSendStatus>
c0d060ca:	2000      	movs	r0, #0
    
  default:
    break;
  }
  return ret;
}
c0d060cc:	bdb0      	pop	{r4, r5, r7, pc}

c0d060ce <USBD_ParseSetupRequest>:
* @retval None
*/

void USBD_ParseSetupRequest(USBD_SetupReqTypedef *req, uint8_t *pdata)
{
  req->bmRequest     = *(uint8_t *)  (pdata);
c0d060ce:	780a      	ldrb	r2, [r1, #0]
c0d060d0:	7002      	strb	r2, [r0, #0]
  req->bRequest      = *(uint8_t *)  (pdata +  1);
c0d060d2:	784a      	ldrb	r2, [r1, #1]
c0d060d4:	7042      	strb	r2, [r0, #1]
  req->wValue        = SWAPBYTE      (pdata +  2);
c0d060d6:	788a      	ldrb	r2, [r1, #2]
c0d060d8:	78cb      	ldrb	r3, [r1, #3]
c0d060da:	021b      	lsls	r3, r3, #8
c0d060dc:	189a      	adds	r2, r3, r2
c0d060de:	8042      	strh	r2, [r0, #2]
  req->wIndex        = SWAPBYTE      (pdata +  4);
c0d060e0:	790a      	ldrb	r2, [r1, #4]
c0d060e2:	794b      	ldrb	r3, [r1, #5]
c0d060e4:	021b      	lsls	r3, r3, #8
c0d060e6:	189a      	adds	r2, r3, r2
c0d060e8:	8082      	strh	r2, [r0, #4]
  req->wLength       = SWAPBYTE      (pdata +  6);
c0d060ea:	798a      	ldrb	r2, [r1, #6]
c0d060ec:	79c9      	ldrb	r1, [r1, #7]
c0d060ee:	0209      	lsls	r1, r1, #8
c0d060f0:	1889      	adds	r1, r1, r2
c0d060f2:	80c1      	strh	r1, [r0, #6]

}
c0d060f4:	4770      	bx	lr

c0d060f6 <USBD_HID_Setup>:
  * @param  req: usb requests
  * @retval status
  */
uint8_t  USBD_HID_Setup (USBD_HandleTypeDef *pdev, 
                                USBD_SetupReqTypedef *req)
{
c0d060f6:	b570      	push	{r4, r5, r6, lr}
c0d060f8:	b082      	sub	sp, #8
c0d060fa:	460d      	mov	r5, r1
c0d060fc:	4604      	mov	r4, r0
c0d060fe:	a901      	add	r1, sp, #4
c0d06100:	2000      	movs	r0, #0
  uint16_t len = 0;
c0d06102:	8008      	strh	r0, [r1, #0]
c0d06104:	4669      	mov	r1, sp
  uint8_t  *pbuf = NULL;

  uint8_t val = 0;
c0d06106:	7008      	strb	r0, [r1, #0]

  switch (req->bmRequest & USB_REQ_TYPE_MASK)
c0d06108:	782a      	ldrb	r2, [r5, #0]
c0d0610a:	2160      	movs	r1, #96	; 0x60
c0d0610c:	4011      	ands	r1, r2
c0d0610e:	2900      	cmp	r1, #0
c0d06110:	d010      	beq.n	c0d06134 <USBD_HID_Setup+0x3e>
c0d06112:	2920      	cmp	r1, #32
c0d06114:	d138      	bne.n	c0d06188 <USBD_HID_Setup+0x92>
  {
  case USB_REQ_TYPE_CLASS :  
    switch (req->bRequest)
c0d06116:	7869      	ldrb	r1, [r5, #1]
c0d06118:	460a      	mov	r2, r1
c0d0611a:	3a0a      	subs	r2, #10
c0d0611c:	2a02      	cmp	r2, #2
c0d0611e:	d333      	bcc.n	c0d06188 <USBD_HID_Setup+0x92>
c0d06120:	2902      	cmp	r1, #2
c0d06122:	d01b      	beq.n	c0d0615c <USBD_HID_Setup+0x66>
c0d06124:	2903      	cmp	r1, #3
c0d06126:	d019      	beq.n	c0d0615c <USBD_HID_Setup+0x66>
                        (uint8_t *)&val,
                        1);      
      break;      
      
    default:
      USBD_CtlError (pdev, req);
c0d06128:	4620      	mov	r0, r4
c0d0612a:	4629      	mov	r1, r5
c0d0612c:	f7ff ff1d 	bl	c0d05f6a <USBD_CtlError>
c0d06130:	2002      	movs	r0, #2
c0d06132:	e029      	b.n	c0d06188 <USBD_HID_Setup+0x92>
      return USBD_FAIL; 
    }
    break;
    
  case USB_REQ_TYPE_STANDARD:
    switch (req->bRequest)
c0d06134:	7869      	ldrb	r1, [r5, #1]
c0d06136:	290b      	cmp	r1, #11
c0d06138:	d013      	beq.n	c0d06162 <USBD_HID_Setup+0x6c>
c0d0613a:	290a      	cmp	r1, #10
c0d0613c:	d00e      	beq.n	c0d0615c <USBD_HID_Setup+0x66>
c0d0613e:	2906      	cmp	r1, #6
c0d06140:	d122      	bne.n	c0d06188 <USBD_HID_Setup+0x92>
    {
    case USB_REQ_GET_DESCRIPTOR: 
      // 0x22
      if( req->wValue >> 8 == HID_REPORT_DESC)
c0d06142:	8868      	ldrh	r0, [r5, #2]
c0d06144:	0a00      	lsrs	r0, r0, #8
c0d06146:	2200      	movs	r2, #0
c0d06148:	2821      	cmp	r0, #33	; 0x21
c0d0614a:	d00e      	beq.n	c0d0616a <USBD_HID_Setup+0x74>
c0d0614c:	2822      	cmp	r0, #34	; 0x22
c0d0614e:	4611      	mov	r1, r2
c0d06150:	d116      	bne.n	c0d06180 <USBD_HID_Setup+0x8a>
c0d06152:	ae01      	add	r6, sp, #4
      {
        pbuf =  USBD_HID_GetReportDescriptor_impl(&len);
c0d06154:	4630      	mov	r0, r6
c0d06156:	f000 f857 	bl	c0d06208 <USBD_HID_GetReportDescriptor_impl>
c0d0615a:	e00a      	b.n	c0d06172 <USBD_HID_Setup+0x7c>
c0d0615c:	4669      	mov	r1, sp
c0d0615e:	2201      	movs	r2, #1
c0d06160:	e00e      	b.n	c0d06180 <USBD_HID_Setup+0x8a>
                        len);
      break;

    case USB_REQ_SET_INTERFACE :
      //hhid->AltSetting = (uint8_t)(req->wValue);
      USBD_CtlSendStatus(pdev);
c0d06162:	4620      	mov	r0, r4
c0d06164:	f000 f9a7 	bl	c0d064b6 <USBD_CtlSendStatus>
c0d06168:	e00d      	b.n	c0d06186 <USBD_HID_Setup+0x90>
c0d0616a:	ae01      	add	r6, sp, #4
        len = MIN(len , req->wLength);
      }
      // 0x21
      else if( req->wValue >> 8 == HID_DESCRIPTOR_TYPE)
      {
        pbuf = USBD_HID_GetHidDescriptor_impl(&len);
c0d0616c:	4630      	mov	r0, r6
c0d0616e:	f000 f831 	bl	c0d061d4 <USBD_HID_GetHidDescriptor_impl>
c0d06172:	4601      	mov	r1, r0
c0d06174:	8832      	ldrh	r2, [r6, #0]
c0d06176:	88e8      	ldrh	r0, [r5, #6]
c0d06178:	4282      	cmp	r2, r0
c0d0617a:	d300      	bcc.n	c0d0617e <USBD_HID_Setup+0x88>
c0d0617c:	4602      	mov	r2, r0
c0d0617e:	8032      	strh	r2, [r6, #0]
c0d06180:	4620      	mov	r0, r4
c0d06182:	f000 f96d 	bl	c0d06460 <USBD_CtlSendData>
c0d06186:	2000      	movs	r0, #0
      
    }
  }

  return USBD_OK;
}
c0d06188:	b002      	add	sp, #8
c0d0618a:	bd70      	pop	{r4, r5, r6, pc}

c0d0618c <USBD_HID_Init>:
  * @param  cfgidx: Configuration index
  * @retval status
  */
uint8_t  USBD_HID_Init (USBD_HandleTypeDef *pdev, 
                               uint8_t cfgidx)
{
c0d0618c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0618e:	b081      	sub	sp, #4
c0d06190:	4604      	mov	r4, r0
c0d06192:	2182      	movs	r1, #130	; 0x82
c0d06194:	2603      	movs	r6, #3
c0d06196:	2540      	movs	r5, #64	; 0x40
  UNUSED(cfgidx);

  /* Open EP IN */
  USBD_LL_OpenEP(pdev,
c0d06198:	4632      	mov	r2, r6
c0d0619a:	462b      	mov	r3, r5
c0d0619c:	f7ff fab6 	bl	c0d0570c <USBD_LL_OpenEP>
c0d061a0:	2702      	movs	r7, #2
                 HID_EPIN_ADDR,
                 USBD_EP_TYPE_INTR,
                 HID_EPIN_SIZE);
  
  /* Open EP OUT */
  USBD_LL_OpenEP(pdev,
c0d061a2:	4620      	mov	r0, r4
c0d061a4:	4639      	mov	r1, r7
c0d061a6:	4632      	mov	r2, r6
c0d061a8:	462b      	mov	r3, r5
c0d061aa:	f7ff faaf 	bl	c0d0570c <USBD_LL_OpenEP>
                 HID_EPOUT_ADDR,
                 USBD_EP_TYPE_INTR,
                 HID_EPOUT_SIZE);

        /* Prepare Out endpoint to receive 1st packet */ 
  USBD_LL_PrepareReceive(pdev, HID_EPOUT_ADDR, HID_EPOUT_SIZE);
c0d061ae:	4620      	mov	r0, r4
c0d061b0:	4639      	mov	r1, r7
c0d061b2:	462a      	mov	r2, r5
c0d061b4:	f7ff fb73 	bl	c0d0589e <USBD_LL_PrepareReceive>
c0d061b8:	2000      	movs	r0, #0
  USBD_LL_Transmit (pdev, 
                    HID_EPIN_ADDR,                                      
                    NULL,
                    0);
  */
  return USBD_OK;
c0d061ba:	b001      	add	sp, #4
c0d061bc:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d061be <USBD_HID_DeInit>:
  * @param  cfgidx: Configuration index
  * @retval status
  */
uint8_t  USBD_HID_DeInit (USBD_HandleTypeDef *pdev, 
                                 uint8_t cfgidx)
{
c0d061be:	b510      	push	{r4, lr}
c0d061c0:	4604      	mov	r4, r0
c0d061c2:	2182      	movs	r1, #130	; 0x82
  UNUSED(cfgidx);
  /* Close HID EP IN */
  USBD_LL_CloseEP(pdev,
c0d061c4:	f7ff fad2 	bl	c0d0576c <USBD_LL_CloseEP>
c0d061c8:	2102      	movs	r1, #2
                  HID_EPIN_ADDR);
  
  /* Close HID EP OUT */
  USBD_LL_CloseEP(pdev,
c0d061ca:	4620      	mov	r0, r4
c0d061cc:	f7ff face 	bl	c0d0576c <USBD_LL_CloseEP>
c0d061d0:	2000      	movs	r0, #0
                  HID_EPOUT_ADDR);
  
  return USBD_OK;
c0d061d2:	bd10      	pop	{r4, pc}

c0d061d4 <USBD_HID_GetHidDescriptor_impl>:
{
  *length = sizeof (USBD_CfgDesc);
  return (uint8_t*)USBD_CfgDesc;
}

uint8_t* USBD_HID_GetHidDescriptor_impl(uint16_t* len) {
c0d061d4:	21ec      	movs	r1, #236	; 0xec
  switch (USBD_Device.request.wIndex&0xFF) {
c0d061d6:	4a09      	ldr	r2, [pc, #36]	; (c0d061fc <USBD_HID_GetHidDescriptor_impl+0x28>)
c0d061d8:	5c51      	ldrb	r1, [r2, r1]
c0d061da:	2209      	movs	r2, #9
c0d061dc:	2901      	cmp	r1, #1
c0d061de:	d005      	beq.n	c0d061ec <USBD_HID_GetHidDescriptor_impl+0x18>
c0d061e0:	2900      	cmp	r1, #0
c0d061e2:	d106      	bne.n	c0d061f2 <USBD_HID_GetHidDescriptor_impl+0x1e>
c0d061e4:	4907      	ldr	r1, [pc, #28]	; (c0d06204 <USBD_HID_GetHidDescriptor_impl+0x30>)
c0d061e6:	4479      	add	r1, pc
c0d061e8:	2209      	movs	r2, #9
c0d061ea:	e004      	b.n	c0d061f6 <USBD_HID_GetHidDescriptor_impl+0x22>
c0d061ec:	4904      	ldr	r1, [pc, #16]	; (c0d06200 <USBD_HID_GetHidDescriptor_impl+0x2c>)
c0d061ee:	4479      	add	r1, pc
c0d061f0:	e001      	b.n	c0d061f6 <USBD_HID_GetHidDescriptor_impl+0x22>
c0d061f2:	2200      	movs	r2, #0
c0d061f4:	4611      	mov	r1, r2
c0d061f6:	8002      	strh	r2, [r0, #0]
      *len = sizeof(USBD_HID_Desc);
      return (uint8_t*)USBD_HID_Desc; 
  }
  *len = 0;
  return 0;
}
c0d061f8:	4608      	mov	r0, r1
c0d061fa:	4770      	bx	lr
c0d061fc:	200023b8 	.word	0x200023b8
c0d06200:	00001b4a 	.word	0x00001b4a
c0d06204:	00001b5e 	.word	0x00001b5e

c0d06208 <USBD_HID_GetReportDescriptor_impl>:

uint8_t* USBD_HID_GetReportDescriptor_impl(uint16_t* len) {
c0d06208:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0620a:	b081      	sub	sp, #4
c0d0620c:	4604      	mov	r4, r0
c0d0620e:	20ec      	movs	r0, #236	; 0xec
  switch (USBD_Device.request.wIndex&0xFF) {
c0d06210:	4913      	ldr	r1, [pc, #76]	; (c0d06260 <USBD_HID_GetReportDescriptor_impl+0x58>)
c0d06212:	5c08      	ldrb	r0, [r1, r0]
c0d06214:	2122      	movs	r1, #34	; 0x22
c0d06216:	2800      	cmp	r0, #0
c0d06218:	d019      	beq.n	c0d0624e <USBD_HID_GetReportDescriptor_impl+0x46>
c0d0621a:	2801      	cmp	r0, #1
c0d0621c:	d11a      	bne.n	c0d06254 <USBD_HID_GetReportDescriptor_impl+0x4c>
#ifdef HAVE_IO_U2F
  case U2F_INTF:

    // very dirty work due to lack of callback when USB_HID_Init is called
    USBD_LL_OpenEP(&USBD_Device,
c0d0621e:	4810      	ldr	r0, [pc, #64]	; (c0d06260 <USBD_HID_GetReportDescriptor_impl+0x58>)
c0d06220:	2181      	movs	r1, #129	; 0x81
c0d06222:	2703      	movs	r7, #3
c0d06224:	2640      	movs	r6, #64	; 0x40
c0d06226:	463a      	mov	r2, r7
c0d06228:	4633      	mov	r3, r6
c0d0622a:	f7ff fa6f 	bl	c0d0570c <USBD_LL_OpenEP>
c0d0622e:	2501      	movs	r5, #1
                   U2F_EPIN_ADDR,
                   USBD_EP_TYPE_INTR,
                   U2F_EPIN_SIZE);
    
    USBD_LL_OpenEP(&USBD_Device,
c0d06230:	480b      	ldr	r0, [pc, #44]	; (c0d06260 <USBD_HID_GetReportDescriptor_impl+0x58>)
c0d06232:	4629      	mov	r1, r5
c0d06234:	463a      	mov	r2, r7
c0d06236:	4633      	mov	r3, r6
c0d06238:	f7ff fa68 	bl	c0d0570c <USBD_LL_OpenEP>
                   U2F_EPOUT_ADDR,
                   USBD_EP_TYPE_INTR,
                   U2F_EPOUT_SIZE);

    /* Prepare Out endpoint to receive 1st packet */ 
    USBD_LL_PrepareReceive(&USBD_Device, U2F_EPOUT_ADDR, U2F_EPOUT_SIZE);
c0d0623c:	4808      	ldr	r0, [pc, #32]	; (c0d06260 <USBD_HID_GetReportDescriptor_impl+0x58>)
c0d0623e:	4629      	mov	r1, r5
c0d06240:	4632      	mov	r2, r6
c0d06242:	f7ff fb2c 	bl	c0d0589e <USBD_LL_PrepareReceive>
c0d06246:	4808      	ldr	r0, [pc, #32]	; (c0d06268 <USBD_HID_GetReportDescriptor_impl+0x60>)
c0d06248:	4478      	add	r0, pc
c0d0624a:	2122      	movs	r1, #34	; 0x22
c0d0624c:	e004      	b.n	c0d06258 <USBD_HID_GetReportDescriptor_impl+0x50>
c0d0624e:	4805      	ldr	r0, [pc, #20]	; (c0d06264 <USBD_HID_GetReportDescriptor_impl+0x5c>)
c0d06250:	4478      	add	r0, pc
c0d06252:	e001      	b.n	c0d06258 <USBD_HID_GetReportDescriptor_impl+0x50>
c0d06254:	2100      	movs	r1, #0
c0d06256:	4608      	mov	r0, r1
c0d06258:	8021      	strh	r1, [r4, #0]
    *len = sizeof(HID_ReportDesc);
    return (uint8_t*)HID_ReportDesc;
  }
  *len = 0;
  return 0;
}
c0d0625a:	b001      	add	sp, #4
c0d0625c:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d0625e:	46c0      	nop			; (mov r8, r8)
c0d06260:	200023b8 	.word	0x200023b8
c0d06264:	00001b1f 	.word	0x00001b1f
c0d06268:	00001b05 	.word	0x00001b05

c0d0626c <USBD_U2F_Init>:
  * @param  cfgidx: Configuration index
  * @retval status
  */
uint8_t  USBD_U2F_Init (USBD_HandleTypeDef *pdev, 
                               uint8_t cfgidx)
{
c0d0626c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0626e:	b081      	sub	sp, #4
c0d06270:	4604      	mov	r4, r0
c0d06272:	2181      	movs	r1, #129	; 0x81
c0d06274:	2603      	movs	r6, #3
c0d06276:	2540      	movs	r5, #64	; 0x40
  UNUSED(cfgidx);

  /* Open EP IN */
  USBD_LL_OpenEP(pdev,
c0d06278:	4632      	mov	r2, r6
c0d0627a:	462b      	mov	r3, r5
c0d0627c:	f7ff fa46 	bl	c0d0570c <USBD_LL_OpenEP>
c0d06280:	2701      	movs	r7, #1
                 U2F_EPIN_ADDR,
                 USBD_EP_TYPE_INTR,
                 U2F_EPIN_SIZE);
  
  /* Open EP OUT */
  USBD_LL_OpenEP(pdev,
c0d06282:	4620      	mov	r0, r4
c0d06284:	4639      	mov	r1, r7
c0d06286:	4632      	mov	r2, r6
c0d06288:	462b      	mov	r3, r5
c0d0628a:	f7ff fa3f 	bl	c0d0570c <USBD_LL_OpenEP>
                 U2F_EPOUT_ADDR,
                 USBD_EP_TYPE_INTR,
                 U2F_EPOUT_SIZE);

        /* Prepare Out endpoint to receive 1st packet */ 
  USBD_LL_PrepareReceive(pdev, U2F_EPOUT_ADDR, U2F_EPOUT_SIZE);
c0d0628e:	4620      	mov	r0, r4
c0d06290:	4639      	mov	r1, r7
c0d06292:	462a      	mov	r2, r5
c0d06294:	f7ff fb03 	bl	c0d0589e <USBD_LL_PrepareReceive>
c0d06298:	2000      	movs	r0, #0

  return USBD_OK;
c0d0629a:	b001      	add	sp, #4
c0d0629c:	bdf0      	pop	{r4, r5, r6, r7, pc}
	...

c0d062a0 <USBD_U2F_DataIn_impl>:
}

uint8_t  USBD_U2F_DataIn_impl (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum)
{
c0d062a0:	b580      	push	{r7, lr}
  UNUSED(pdev);
  // only the data hid endpoint will receive data
  switch (epnum) {
c0d062a2:	2901      	cmp	r1, #1
c0d062a4:	d103      	bne.n	c0d062ae <USBD_U2F_DataIn_impl+0xe>
  // FIDO endpoint
  case (U2F_EPIN_ADDR&0x7F):
    // advance the u2f sending machine state
    u2f_transport_sent(&G_io_u2f, U2F_MEDIA_USB);
c0d062a6:	4803      	ldr	r0, [pc, #12]	; (c0d062b4 <USBD_U2F_DataIn_impl+0x14>)
c0d062a8:	2101      	movs	r1, #1
c0d062aa:	f7fe ff9d 	bl	c0d051e8 <u2f_transport_sent>
c0d062ae:	2000      	movs	r0, #0
    break;
  } 
  return USBD_OK;
c0d062b0:	bd80      	pop	{r7, pc}
c0d062b2:	46c0      	nop			; (mov r8, r8)
c0d062b4:	200022ec 	.word	0x200022ec

c0d062b8 <USBD_U2F_DataOut_impl>:
}

uint8_t  USBD_U2F_DataOut_impl (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum, uint8_t* buffer)
{
c0d062b8:	b5b0      	push	{r4, r5, r7, lr}
  switch (epnum) {
c0d062ba:	2901      	cmp	r1, #1
c0d062bc:	d10e      	bne.n	c0d062dc <USBD_U2F_DataOut_impl+0x24>
c0d062be:	4614      	mov	r4, r2
c0d062c0:	2501      	movs	r5, #1
c0d062c2:	2240      	movs	r2, #64	; 0x40
  // FIDO endpoint
  case (U2F_EPOUT_ADDR&0x7F):
      USBD_LL_PrepareReceive(pdev, U2F_EPOUT_ADDR , U2F_EPOUT_SIZE);
c0d062c4:	4629      	mov	r1, r5
c0d062c6:	f7ff faea 	bl	c0d0589e <USBD_LL_PrepareReceive>
      u2f_transport_received(&G_io_u2f, buffer, io_seproxyhal_get_ep_rx_size(U2F_EPOUT_ADDR), U2F_MEDIA_USB);
c0d062ca:	4628      	mov	r0, r5
c0d062cc:	f7fd fd90 	bl	c0d03df0 <io_seproxyhal_get_ep_rx_size>
c0d062d0:	4602      	mov	r2, r0
c0d062d2:	4803      	ldr	r0, [pc, #12]	; (c0d062e0 <USBD_U2F_DataOut_impl+0x28>)
c0d062d4:	4621      	mov	r1, r4
c0d062d6:	462b      	mov	r3, r5
c0d062d8:	f7fe ffec 	bl	c0d052b4 <u2f_transport_received>
c0d062dc:	2000      	movs	r0, #0
    break;
  }

  return USBD_OK;
c0d062de:	bdb0      	pop	{r4, r5, r7, pc}
c0d062e0:	200022ec 	.word	0x200022ec

c0d062e4 <USBD_HID_DataIn_impl>:
}
#endif // HAVE_IO_U2F

uint8_t  USBD_HID_DataIn_impl (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum)
{
c0d062e4:	b580      	push	{r7, lr}
  UNUSED(pdev);
  switch (epnum) {
c0d062e6:	2902      	cmp	r1, #2
c0d062e8:	d103      	bne.n	c0d062f2 <USBD_HID_DataIn_impl+0xe>
    // HID gen endpoint
    case (HID_EPIN_ADDR&0x7F):
      io_usb_hid_sent(io_usb_send_apdu_data);
c0d062ea:	4803      	ldr	r0, [pc, #12]	; (c0d062f8 <USBD_HID_DataIn_impl+0x14>)
c0d062ec:	4478      	add	r0, pc
c0d062ee:	f7fd fc6d 	bl	c0d03bcc <io_usb_hid_sent>
c0d062f2:	2000      	movs	r0, #0
      break;
  }

  return USBD_OK;
c0d062f4:	bd80      	pop	{r7, pc}
c0d062f6:	46c0      	nop			; (mov r8, r8)
c0d062f8:	ffffdbc1 	.word	0xffffdbc1

c0d062fc <USBD_HID_DataOut_impl>:
}

uint8_t  USBD_HID_DataOut_impl (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum, uint8_t* buffer)
{
c0d062fc:	b5b0      	push	{r4, r5, r7, lr}
  // only the data hid endpoint will receive data
  switch (epnum) {
c0d062fe:	2902      	cmp	r1, #2
c0d06300:	d11c      	bne.n	c0d0633c <USBD_HID_DataOut_impl+0x40>
c0d06302:	4614      	mov	r4, r2
c0d06304:	2102      	movs	r1, #2
c0d06306:	2240      	movs	r2, #64	; 0x40

  // HID gen endpoint
  case (HID_EPOUT_ADDR&0x7F):
    // prepare receiving the next chunk (masked time)
    USBD_LL_PrepareReceive(pdev, HID_EPOUT_ADDR , HID_EPOUT_SIZE);
c0d06308:	f7ff fac9 	bl	c0d0589e <USBD_LL_PrepareReceive>

    // avoid troubles when an apdu has not been replied yet
    if (G_io_apdu_media == IO_APDU_MEDIA_NONE) {      
c0d0630c:	4d0c      	ldr	r5, [pc, #48]	; (c0d06340 <USBD_HID_DataOut_impl+0x44>)
c0d0630e:	7828      	ldrb	r0, [r5, #0]
c0d06310:	2800      	cmp	r0, #0
c0d06312:	d113      	bne.n	c0d0633c <USBD_HID_DataOut_impl+0x40>
c0d06314:	2002      	movs	r0, #2
      // add to the hid transport
      switch(io_usb_hid_receive(io_usb_send_apdu_data, buffer, io_seproxyhal_get_ep_rx_size(HID_EPOUT_ADDR))) {
c0d06316:	f7fd fd6b 	bl	c0d03df0 <io_seproxyhal_get_ep_rx_size>
c0d0631a:	4602      	mov	r2, r0
c0d0631c:	480c      	ldr	r0, [pc, #48]	; (c0d06350 <USBD_HID_DataOut_impl+0x54>)
c0d0631e:	4478      	add	r0, pc
c0d06320:	4621      	mov	r1, r4
c0d06322:	f7fd fb51 	bl	c0d039c8 <io_usb_hid_receive>
c0d06326:	2802      	cmp	r0, #2
c0d06328:	d108      	bne.n	c0d0633c <USBD_HID_DataOut_impl+0x40>
c0d0632a:	2001      	movs	r0, #1
        default:
          break;

        case IO_USB_APDU_RECEIVED:
          G_io_apdu_media = IO_APDU_MEDIA_USB_HID; // for application code
c0d0632c:	7028      	strb	r0, [r5, #0]
          G_io_apdu_state = APDU_USB_HID; // for next call to io_exchange
c0d0632e:	4805      	ldr	r0, [pc, #20]	; (c0d06344 <USBD_HID_DataOut_impl+0x48>)
c0d06330:	2107      	movs	r1, #7
c0d06332:	7001      	strb	r1, [r0, #0]
          G_io_apdu_length = G_io_usb_hid_total_length;
c0d06334:	4804      	ldr	r0, [pc, #16]	; (c0d06348 <USBD_HID_DataOut_impl+0x4c>)
c0d06336:	6800      	ldr	r0, [r0, #0]
c0d06338:	4904      	ldr	r1, [pc, #16]	; (c0d0634c <USBD_HID_DataOut_impl+0x50>)
c0d0633a:	8008      	strh	r0, [r1, #0]
c0d0633c:	2000      	movs	r0, #0
      }
    }
    break;
  }

  return USBD_OK;
c0d0633e:	bdb0      	pop	{r4, r5, r7, pc}
c0d06340:	200022c8 	.word	0x200022c8
c0d06344:	200022dc 	.word	0x200022dc
c0d06348:	20002164 	.word	0x20002164
c0d0634c:	200022de 	.word	0x200022de
c0d06350:	ffffdb8f 	.word	0xffffdb8f

c0d06354 <USBD_DeviceDescriptor>:
  * @param  speed: Current device speed
  * @param  length: Pointer to data length variable
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_DeviceDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
c0d06354:	2012      	movs	r0, #18
  UNUSED(speed);
  *length = sizeof(USBD_DeviceDesc);
c0d06356:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_DeviceDesc;
c0d06358:	4801      	ldr	r0, [pc, #4]	; (c0d06360 <USBD_DeviceDescriptor+0xc>)
c0d0635a:	4478      	add	r0, pc
c0d0635c:	4770      	bx	lr
c0d0635e:	46c0      	nop			; (mov r8, r8)
c0d06360:	00001aca 	.word	0x00001aca

c0d06364 <USBD_LangIDStrDescriptor>:
  * @param  speed: Current device speed
  * @param  length: Pointer to data length variable
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_LangIDStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
c0d06364:	2004      	movs	r0, #4
  UNUSED(speed);
  *length = sizeof(USBD_LangIDDesc);  
c0d06366:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_LangIDDesc;
c0d06368:	4801      	ldr	r0, [pc, #4]	; (c0d06370 <USBD_LangIDStrDescriptor+0xc>)
c0d0636a:	4478      	add	r0, pc
c0d0636c:	4770      	bx	lr
c0d0636e:	46c0      	nop			; (mov r8, r8)
c0d06370:	00001acc 	.word	0x00001acc

c0d06374 <USBD_ManufacturerStrDescriptor>:
  * @param  speed: Current device speed
  * @param  length: Pointer to data length variable
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_ManufacturerStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
c0d06374:	200e      	movs	r0, #14
  UNUSED(speed);
  *length = sizeof(USBD_MANUFACTURER_STRING);
c0d06376:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_MANUFACTURER_STRING;
c0d06378:	4801      	ldr	r0, [pc, #4]	; (c0d06380 <USBD_ManufacturerStrDescriptor+0xc>)
c0d0637a:	4478      	add	r0, pc
c0d0637c:	4770      	bx	lr
c0d0637e:	46c0      	nop			; (mov r8, r8)
c0d06380:	00001ac0 	.word	0x00001ac0

c0d06384 <USBD_ProductStrDescriptor>:
  * @param  speed: Current device speed
  * @param  length: Pointer to data length variable
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_ProductStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
c0d06384:	200e      	movs	r0, #14
  UNUSED(speed);
  *length = sizeof(USBD_PRODUCT_FS_STRING);
c0d06386:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_PRODUCT_FS_STRING;
c0d06388:	4801      	ldr	r0, [pc, #4]	; (c0d06390 <USBD_ProductStrDescriptor+0xc>)
c0d0638a:	4478      	add	r0, pc
c0d0638c:	4770      	bx	lr
c0d0638e:	46c0      	nop			; (mov r8, r8)
c0d06390:	00001abe 	.word	0x00001abe

c0d06394 <USBD_SerialStrDescriptor>:
  * @param  speed: Current device speed
  * @param  length: Pointer to data length variable
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_SerialStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
c0d06394:	200a      	movs	r0, #10
  UNUSED(speed);
  *length = sizeof(USB_SERIAL_STRING);
c0d06396:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USB_SERIAL_STRING;
c0d06398:	4801      	ldr	r0, [pc, #4]	; (c0d063a0 <USBD_SerialStrDescriptor+0xc>)
c0d0639a:	4478      	add	r0, pc
c0d0639c:	4770      	bx	lr
c0d0639e:	46c0      	nop			; (mov r8, r8)
c0d063a0:	00001abc 	.word	0x00001abc

c0d063a4 <USBD_ConfigStrDescriptor>:
  * @param  speed: Current device speed
  * @param  length: Pointer to data length variable
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_ConfigStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
c0d063a4:	200e      	movs	r0, #14
  UNUSED(speed);
  *length = sizeof(USBD_CONFIGURATION_FS_STRING);
c0d063a6:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_CONFIGURATION_FS_STRING;
c0d063a8:	4801      	ldr	r0, [pc, #4]	; (c0d063b0 <USBD_ConfigStrDescriptor+0xc>)
c0d063aa:	4478      	add	r0, pc
c0d063ac:	4770      	bx	lr
c0d063ae:	46c0      	nop			; (mov r8, r8)
c0d063b0:	00001a9e 	.word	0x00001a9e

c0d063b4 <USBD_InterfaceStrDescriptor>:
  * @param  speed: Current device speed
  * @param  length: Pointer to data length variable
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_InterfaceStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
c0d063b4:	200e      	movs	r0, #14
  UNUSED(speed);
  *length = sizeof(USBD_INTERFACE_FS_STRING);
c0d063b6:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_INTERFACE_FS_STRING;
c0d063b8:	4801      	ldr	r0, [pc, #4]	; (c0d063c0 <USBD_InterfaceStrDescriptor+0xc>)
c0d063ba:	4478      	add	r0, pc
c0d063bc:	4770      	bx	lr
c0d063be:	46c0      	nop			; (mov r8, r8)
c0d063c0:	00001a8e 	.word	0x00001a8e

c0d063c4 <USB_power>:
  // nothing to do ?
  return 0;
}
#endif // HAVE_USB_CLASS_CCID

void USB_power(unsigned char enabled) {
c0d063c4:	b570      	push	{r4, r5, r6, lr}
c0d063c6:	4604      	mov	r4, r0
c0d063c8:	2045      	movs	r0, #69	; 0x45
c0d063ca:	0085      	lsls	r5, r0, #2
  os_memset(&USBD_Device, 0, sizeof(USBD_Device));
c0d063cc:	4816      	ldr	r0, [pc, #88]	; (c0d06428 <USB_power+0x64>)
c0d063ce:	2100      	movs	r1, #0
c0d063d0:	462a      	mov	r2, r5
c0d063d2:	f7fd fbd5 	bl	c0d03b80 <os_memset>

  if (enabled) {
c0d063d6:	2c00      	cmp	r4, #0
c0d063d8:	d022      	beq.n	c0d06420 <USB_power+0x5c>
    os_memset(&USBD_Device, 0, sizeof(USBD_Device));
c0d063da:	4c13      	ldr	r4, [pc, #76]	; (c0d06428 <USB_power+0x64>)
c0d063dc:	2600      	movs	r6, #0
c0d063de:	4620      	mov	r0, r4
c0d063e0:	4631      	mov	r1, r6
c0d063e2:	462a      	mov	r2, r5
c0d063e4:	f7fd fbcc 	bl	c0d03b80 <os_memset>
    /* Init Device Library */
    USBD_Init(&USBD_Device, (USBD_DescriptorsTypeDef*)&HID_Desc, 0);
c0d063e8:	4912      	ldr	r1, [pc, #72]	; (c0d06434 <USB_power+0x70>)
c0d063ea:	4479      	add	r1, pc
c0d063ec:	4620      	mov	r0, r4
c0d063ee:	4632      	mov	r2, r6
c0d063f0:	f7ff fa68 	bl	c0d058c4 <USBD_Init>
    
    /* Register the HID class */
    USBD_RegisterClassForInterface(HID_INTF,  &USBD_Device, (USBD_ClassTypeDef*)&USBD_HID);
c0d063f4:	4a10      	ldr	r2, [pc, #64]	; (c0d06438 <USB_power+0x74>)
c0d063f6:	447a      	add	r2, pc
c0d063f8:	4630      	mov	r0, r6
c0d063fa:	4621      	mov	r1, r4
c0d063fc:	f7ff fa99 	bl	c0d05932 <USBD_RegisterClassForInterface>
c0d06400:	2001      	movs	r0, #1
#ifdef HAVE_IO_U2F
    USBD_RegisterClassForInterface(U2F_INTF,  &USBD_Device, (USBD_ClassTypeDef*)&USBD_U2F);
c0d06402:	4a0e      	ldr	r2, [pc, #56]	; (c0d0643c <USB_power+0x78>)
c0d06404:	447a      	add	r2, pc
c0d06406:	4621      	mov	r1, r4
c0d06408:	f7ff fa93 	bl	c0d05932 <USBD_RegisterClassForInterface>
c0d0640c:	22ff      	movs	r2, #255	; 0xff
c0d0640e:	3252      	adds	r2, #82	; 0x52
    // initialize the U2F tunnel transport
    u2f_transport_init(&G_io_u2f, G_io_apdu_buffer, IO_APDU_BUFFER_SIZE);
c0d06410:	4806      	ldr	r0, [pc, #24]	; (c0d0642c <USB_power+0x68>)
c0d06412:	4907      	ldr	r1, [pc, #28]	; (c0d06430 <USB_power+0x6c>)
c0d06414:	f7fe fee0 	bl	c0d051d8 <u2f_transport_init>
    USBD_RegisterClassForInterface(WEBUSB_INTF, &USBD_Device, (USBD_ClassTypeDef*)&USBD_WEBUSB);
    USBD_LL_PrepareReceive(&USBD_Device, WEBUSB_EPOUT_ADDR , WEBUSB_EPOUT_SIZE);
#endif // HAVE_WEBUSB

    /* Start Device Process */
    USBD_Start(&USBD_Device);
c0d06418:	4620      	mov	r0, r4
c0d0641a:	f7ff fa97 	bl	c0d0594c <USBD_Start>
  }
  else {
    USBD_DeInit(&USBD_Device);
  }
}
c0d0641e:	bd70      	pop	{r4, r5, r6, pc}

    /* Start Device Process */
    USBD_Start(&USBD_Device);
  }
  else {
    USBD_DeInit(&USBD_Device);
c0d06420:	4801      	ldr	r0, [pc, #4]	; (c0d06428 <USB_power+0x64>)
c0d06422:	f7ff fa68 	bl	c0d058f6 <USBD_DeInit>
  }
}
c0d06426:	bd70      	pop	{r4, r5, r6, pc}
c0d06428:	200023b8 	.word	0x200023b8
c0d0642c:	200022ec 	.word	0x200022ec
c0d06430:	2000216c 	.word	0x2000216c
c0d06434:	000019aa 	.word	0x000019aa
c0d06438:	000019be 	.word	0x000019be
c0d0643c:	000019e8 	.word	0x000019e8

c0d06440 <USBD_GetCfgDesc_impl>:
  * @param  speed : current device speed
  * @param  length : pointer data length
  * @retval pointer to descriptor buffer
  */
static uint8_t  *USBD_GetCfgDesc_impl (uint16_t *length)
{
c0d06440:	2149      	movs	r1, #73	; 0x49
  *length = sizeof (USBD_CfgDesc);
c0d06442:	8001      	strh	r1, [r0, #0]
  return (uint8_t*)USBD_CfgDesc;
c0d06444:	4801      	ldr	r0, [pc, #4]	; (c0d0644c <USBD_GetCfgDesc_impl+0xc>)
c0d06446:	4478      	add	r0, pc
c0d06448:	4770      	bx	lr
c0d0644a:	46c0      	nop			; (mov r8, r8)
c0d0644c:	00001a1a 	.word	0x00001a1a

c0d06450 <USBD_GetDeviceQualifierDesc_impl>:
*         return Device Qualifier descriptor
* @param  length : pointer data length
* @retval pointer to descriptor buffer
*/
static uint8_t  *USBD_GetDeviceQualifierDesc_impl (uint16_t *length)
{
c0d06450:	210a      	movs	r1, #10
  *length = sizeof (USBD_DeviceQualifierDesc);
c0d06452:	8001      	strh	r1, [r0, #0]
  return (uint8_t*)USBD_DeviceQualifierDesc;
c0d06454:	4801      	ldr	r0, [pc, #4]	; (c0d0645c <USBD_GetDeviceQualifierDesc_impl+0xc>)
c0d06456:	4478      	add	r0, pc
c0d06458:	4770      	bx	lr
c0d0645a:	46c0      	nop			; (mov r8, r8)
c0d0645c:	00001a56 	.word	0x00001a56

c0d06460 <USBD_CtlSendData>:
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlSendData (USBD_HandleTypeDef  *pdev, 
                               uint8_t *pbuf,
                               uint16_t len)
{
c0d06460:	b5b0      	push	{r4, r5, r7, lr}
c0d06462:	460c      	mov	r4, r1
c0d06464:	21d4      	movs	r1, #212	; 0xd4
c0d06466:	2302      	movs	r3, #2
  /* Set EP0 State */
  pdev->ep0_state          = USBD_EP0_DATA_IN;                                      
c0d06468:	5043      	str	r3, [r0, r1]
c0d0646a:	2111      	movs	r1, #17
c0d0646c:	0109      	lsls	r1, r1, #4
  pdev->ep_in[0].total_length = len;
  pdev->ep_in[0].rem_length   = len;
  // store the continuation data if needed
  pdev->pData = pbuf;
c0d0646e:	5044      	str	r4, [r0, r1]
                               uint8_t *pbuf,
                               uint16_t len)
{
  /* Set EP0 State */
  pdev->ep0_state          = USBD_EP0_DATA_IN;                                      
  pdev->ep_in[0].total_length = len;
c0d06470:	6182      	str	r2, [r0, #24]
  pdev->ep_in[0].rem_length   = len;
c0d06472:	61c2      	str	r2, [r0, #28]
  // store the continuation data if needed
  pdev->pData = pbuf;
 /* Start the transfer */
  USBD_LL_Transmit (pdev, 0x00, pbuf, MIN(len, pdev->ep_in[0].maxpacket));  
c0d06474:	6a01      	ldr	r1, [r0, #32]
c0d06476:	4291      	cmp	r1, r2
c0d06478:	d800      	bhi.n	c0d0647c <USBD_CtlSendData+0x1c>
c0d0647a:	460a      	mov	r2, r1
c0d0647c:	b293      	uxth	r3, r2
c0d0647e:	2500      	movs	r5, #0
c0d06480:	4629      	mov	r1, r5
c0d06482:	4622      	mov	r2, r4
c0d06484:	f7ff f9f2 	bl	c0d0586c <USBD_LL_Transmit>
  
  return USBD_OK;
c0d06488:	4628      	mov	r0, r5
c0d0648a:	bdb0      	pop	{r4, r5, r7, pc}

c0d0648c <USBD_CtlContinueSendData>:
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlContinueSendData (USBD_HandleTypeDef  *pdev, 
                                       uint8_t *pbuf,
                                       uint16_t len)
{
c0d0648c:	b5b0      	push	{r4, r5, r7, lr}
c0d0648e:	460c      	mov	r4, r1
 /* Start the next transfer */
  USBD_LL_Transmit (pdev, 0x00, pbuf, MIN(len, pdev->ep_in[0].maxpacket));   
c0d06490:	6a01      	ldr	r1, [r0, #32]
c0d06492:	4291      	cmp	r1, r2
c0d06494:	d800      	bhi.n	c0d06498 <USBD_CtlContinueSendData+0xc>
c0d06496:	460a      	mov	r2, r1
c0d06498:	b293      	uxth	r3, r2
c0d0649a:	2500      	movs	r5, #0
c0d0649c:	4629      	mov	r1, r5
c0d0649e:	4622      	mov	r2, r4
c0d064a0:	f7ff f9e4 	bl	c0d0586c <USBD_LL_Transmit>
  return USBD_OK;
c0d064a4:	4628      	mov	r0, r5
c0d064a6:	bdb0      	pop	{r4, r5, r7, pc}

c0d064a8 <USBD_CtlContinueRx>:
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlContinueRx (USBD_HandleTypeDef  *pdev, 
                                          uint8_t *pbuf,                                          
                                          uint16_t len)
{
c0d064a8:	b510      	push	{r4, lr}
c0d064aa:	2400      	movs	r4, #0
  UNUSED(pbuf);
  USBD_LL_PrepareReceive (pdev,
c0d064ac:	4621      	mov	r1, r4
c0d064ae:	f7ff f9f6 	bl	c0d0589e <USBD_LL_PrepareReceive>
                          0,                                            
                          len);
  return USBD_OK;
c0d064b2:	4620      	mov	r0, r4
c0d064b4:	bd10      	pop	{r4, pc}

c0d064b6 <USBD_CtlSendStatus>:
*         send zero lzngth packet on the ctl pipe
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlSendStatus (USBD_HandleTypeDef  *pdev)
{
c0d064b6:	b510      	push	{r4, lr}
c0d064b8:	21d4      	movs	r1, #212	; 0xd4
c0d064ba:	2204      	movs	r2, #4

  /* Set EP0 State */
  pdev->ep0_state = USBD_EP0_STATUS_IN;
c0d064bc:	5042      	str	r2, [r0, r1]
c0d064be:	2400      	movs	r4, #0
  
 /* Start the transfer */
  USBD_LL_Transmit (pdev, 0x00, NULL, 0);   
c0d064c0:	4621      	mov	r1, r4
c0d064c2:	4622      	mov	r2, r4
c0d064c4:	4623      	mov	r3, r4
c0d064c6:	f7ff f9d1 	bl	c0d0586c <USBD_LL_Transmit>
  
  return USBD_OK;
c0d064ca:	4620      	mov	r0, r4
c0d064cc:	bd10      	pop	{r4, pc}

c0d064ce <USBD_CtlReceiveStatus>:
*         receive zero lzngth packet on the ctl pipe
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlReceiveStatus (USBD_HandleTypeDef  *pdev)
{
c0d064ce:	b510      	push	{r4, lr}
c0d064d0:	21d4      	movs	r1, #212	; 0xd4
c0d064d2:	2205      	movs	r2, #5
  /* Set EP0 State */
  pdev->ep0_state = USBD_EP0_STATUS_OUT; 
c0d064d4:	5042      	str	r2, [r0, r1]
c0d064d6:	2400      	movs	r4, #0
  
 /* Start the transfer */  
  USBD_LL_PrepareReceive ( pdev,
c0d064d8:	4621      	mov	r1, r4
c0d064da:	4622      	mov	r2, r4
c0d064dc:	f7ff f9df 	bl	c0d0589e <USBD_LL_PrepareReceive>
                    0,
                    0);  

  return USBD_OK;
c0d064e0:	4620      	mov	r0, r4
c0d064e2:	bd10      	pop	{r4, pc}

c0d064e4 <__aeabi_uidiv>:
c0d064e4:	2200      	movs	r2, #0
c0d064e6:	0843      	lsrs	r3, r0, #1
c0d064e8:	428b      	cmp	r3, r1
c0d064ea:	d374      	bcc.n	c0d065d6 <__aeabi_uidiv+0xf2>
c0d064ec:	0903      	lsrs	r3, r0, #4
c0d064ee:	428b      	cmp	r3, r1
c0d064f0:	d35f      	bcc.n	c0d065b2 <__aeabi_uidiv+0xce>
c0d064f2:	0a03      	lsrs	r3, r0, #8
c0d064f4:	428b      	cmp	r3, r1
c0d064f6:	d344      	bcc.n	c0d06582 <__aeabi_uidiv+0x9e>
c0d064f8:	0b03      	lsrs	r3, r0, #12
c0d064fa:	428b      	cmp	r3, r1
c0d064fc:	d328      	bcc.n	c0d06550 <__aeabi_uidiv+0x6c>
c0d064fe:	0c03      	lsrs	r3, r0, #16
c0d06500:	428b      	cmp	r3, r1
c0d06502:	d30d      	bcc.n	c0d06520 <__aeabi_uidiv+0x3c>
c0d06504:	22ff      	movs	r2, #255	; 0xff
c0d06506:	0209      	lsls	r1, r1, #8
c0d06508:	ba12      	rev	r2, r2
c0d0650a:	0c03      	lsrs	r3, r0, #16
c0d0650c:	428b      	cmp	r3, r1
c0d0650e:	d302      	bcc.n	c0d06516 <__aeabi_uidiv+0x32>
c0d06510:	1212      	asrs	r2, r2, #8
c0d06512:	0209      	lsls	r1, r1, #8
c0d06514:	d065      	beq.n	c0d065e2 <__aeabi_uidiv+0xfe>
c0d06516:	0b03      	lsrs	r3, r0, #12
c0d06518:	428b      	cmp	r3, r1
c0d0651a:	d319      	bcc.n	c0d06550 <__aeabi_uidiv+0x6c>
c0d0651c:	e000      	b.n	c0d06520 <__aeabi_uidiv+0x3c>
c0d0651e:	0a09      	lsrs	r1, r1, #8
c0d06520:	0bc3      	lsrs	r3, r0, #15
c0d06522:	428b      	cmp	r3, r1
c0d06524:	d301      	bcc.n	c0d0652a <__aeabi_uidiv+0x46>
c0d06526:	03cb      	lsls	r3, r1, #15
c0d06528:	1ac0      	subs	r0, r0, r3
c0d0652a:	4152      	adcs	r2, r2
c0d0652c:	0b83      	lsrs	r3, r0, #14
c0d0652e:	428b      	cmp	r3, r1
c0d06530:	d301      	bcc.n	c0d06536 <__aeabi_uidiv+0x52>
c0d06532:	038b      	lsls	r3, r1, #14
c0d06534:	1ac0      	subs	r0, r0, r3
c0d06536:	4152      	adcs	r2, r2
c0d06538:	0b43      	lsrs	r3, r0, #13
c0d0653a:	428b      	cmp	r3, r1
c0d0653c:	d301      	bcc.n	c0d06542 <__aeabi_uidiv+0x5e>
c0d0653e:	034b      	lsls	r3, r1, #13
c0d06540:	1ac0      	subs	r0, r0, r3
c0d06542:	4152      	adcs	r2, r2
c0d06544:	0b03      	lsrs	r3, r0, #12
c0d06546:	428b      	cmp	r3, r1
c0d06548:	d301      	bcc.n	c0d0654e <__aeabi_uidiv+0x6a>
c0d0654a:	030b      	lsls	r3, r1, #12
c0d0654c:	1ac0      	subs	r0, r0, r3
c0d0654e:	4152      	adcs	r2, r2
c0d06550:	0ac3      	lsrs	r3, r0, #11
c0d06552:	428b      	cmp	r3, r1
c0d06554:	d301      	bcc.n	c0d0655a <__aeabi_uidiv+0x76>
c0d06556:	02cb      	lsls	r3, r1, #11
c0d06558:	1ac0      	subs	r0, r0, r3
c0d0655a:	4152      	adcs	r2, r2
c0d0655c:	0a83      	lsrs	r3, r0, #10
c0d0655e:	428b      	cmp	r3, r1
c0d06560:	d301      	bcc.n	c0d06566 <__aeabi_uidiv+0x82>
c0d06562:	028b      	lsls	r3, r1, #10
c0d06564:	1ac0      	subs	r0, r0, r3
c0d06566:	4152      	adcs	r2, r2
c0d06568:	0a43      	lsrs	r3, r0, #9
c0d0656a:	428b      	cmp	r3, r1
c0d0656c:	d301      	bcc.n	c0d06572 <__aeabi_uidiv+0x8e>
c0d0656e:	024b      	lsls	r3, r1, #9
c0d06570:	1ac0      	subs	r0, r0, r3
c0d06572:	4152      	adcs	r2, r2
c0d06574:	0a03      	lsrs	r3, r0, #8
c0d06576:	428b      	cmp	r3, r1
c0d06578:	d301      	bcc.n	c0d0657e <__aeabi_uidiv+0x9a>
c0d0657a:	020b      	lsls	r3, r1, #8
c0d0657c:	1ac0      	subs	r0, r0, r3
c0d0657e:	4152      	adcs	r2, r2
c0d06580:	d2cd      	bcs.n	c0d0651e <__aeabi_uidiv+0x3a>
c0d06582:	09c3      	lsrs	r3, r0, #7
c0d06584:	428b      	cmp	r3, r1
c0d06586:	d301      	bcc.n	c0d0658c <__aeabi_uidiv+0xa8>
c0d06588:	01cb      	lsls	r3, r1, #7
c0d0658a:	1ac0      	subs	r0, r0, r3
c0d0658c:	4152      	adcs	r2, r2
c0d0658e:	0983      	lsrs	r3, r0, #6
c0d06590:	428b      	cmp	r3, r1
c0d06592:	d301      	bcc.n	c0d06598 <__aeabi_uidiv+0xb4>
c0d06594:	018b      	lsls	r3, r1, #6
c0d06596:	1ac0      	subs	r0, r0, r3
c0d06598:	4152      	adcs	r2, r2
c0d0659a:	0943      	lsrs	r3, r0, #5
c0d0659c:	428b      	cmp	r3, r1
c0d0659e:	d301      	bcc.n	c0d065a4 <__aeabi_uidiv+0xc0>
c0d065a0:	014b      	lsls	r3, r1, #5
c0d065a2:	1ac0      	subs	r0, r0, r3
c0d065a4:	4152      	adcs	r2, r2
c0d065a6:	0903      	lsrs	r3, r0, #4
c0d065a8:	428b      	cmp	r3, r1
c0d065aa:	d301      	bcc.n	c0d065b0 <__aeabi_uidiv+0xcc>
c0d065ac:	010b      	lsls	r3, r1, #4
c0d065ae:	1ac0      	subs	r0, r0, r3
c0d065b0:	4152      	adcs	r2, r2
c0d065b2:	08c3      	lsrs	r3, r0, #3
c0d065b4:	428b      	cmp	r3, r1
c0d065b6:	d301      	bcc.n	c0d065bc <__aeabi_uidiv+0xd8>
c0d065b8:	00cb      	lsls	r3, r1, #3
c0d065ba:	1ac0      	subs	r0, r0, r3
c0d065bc:	4152      	adcs	r2, r2
c0d065be:	0883      	lsrs	r3, r0, #2
c0d065c0:	428b      	cmp	r3, r1
c0d065c2:	d301      	bcc.n	c0d065c8 <__aeabi_uidiv+0xe4>
c0d065c4:	008b      	lsls	r3, r1, #2
c0d065c6:	1ac0      	subs	r0, r0, r3
c0d065c8:	4152      	adcs	r2, r2
c0d065ca:	0843      	lsrs	r3, r0, #1
c0d065cc:	428b      	cmp	r3, r1
c0d065ce:	d301      	bcc.n	c0d065d4 <__aeabi_uidiv+0xf0>
c0d065d0:	004b      	lsls	r3, r1, #1
c0d065d2:	1ac0      	subs	r0, r0, r3
c0d065d4:	4152      	adcs	r2, r2
c0d065d6:	1a41      	subs	r1, r0, r1
c0d065d8:	d200      	bcs.n	c0d065dc <__aeabi_uidiv+0xf8>
c0d065da:	4601      	mov	r1, r0
c0d065dc:	4152      	adcs	r2, r2
c0d065de:	4610      	mov	r0, r2
c0d065e0:	4770      	bx	lr
c0d065e2:	e7ff      	b.n	c0d065e4 <__aeabi_uidiv+0x100>
c0d065e4:	b501      	push	{r0, lr}
c0d065e6:	2000      	movs	r0, #0
c0d065e8:	f000 f806 	bl	c0d065f8 <__aeabi_idiv0>
c0d065ec:	bd02      	pop	{r1, pc}
c0d065ee:	46c0      	nop			; (mov r8, r8)

c0d065f0 <__aeabi_uidivmod>:
c0d065f0:	2900      	cmp	r1, #0
c0d065f2:	d0f7      	beq.n	c0d065e4 <__aeabi_uidiv+0x100>
c0d065f4:	e776      	b.n	c0d064e4 <__aeabi_uidiv>
c0d065f6:	4770      	bx	lr

c0d065f8 <__aeabi_idiv0>:
c0d065f8:	4770      	bx	lr
c0d065fa:	46c0      	nop			; (mov r8, r8)

c0d065fc <__aeabi_llsl>:
c0d065fc:	4091      	lsls	r1, r2
c0d065fe:	1c03      	adds	r3, r0, #0
c0d06600:	4090      	lsls	r0, r2
c0d06602:	469c      	mov	ip, r3
c0d06604:	3a20      	subs	r2, #32
c0d06606:	4093      	lsls	r3, r2
c0d06608:	4319      	orrs	r1, r3
c0d0660a:	4252      	negs	r2, r2
c0d0660c:	4663      	mov	r3, ip
c0d0660e:	40d3      	lsrs	r3, r2
c0d06610:	4319      	orrs	r1, r3
c0d06612:	4770      	bx	lr

c0d06614 <__aeabi_uldivmod>:
c0d06614:	2b00      	cmp	r3, #0
c0d06616:	d111      	bne.n	c0d0663c <__aeabi_uldivmod+0x28>
c0d06618:	2a00      	cmp	r2, #0
c0d0661a:	d10f      	bne.n	c0d0663c <__aeabi_uldivmod+0x28>
c0d0661c:	2900      	cmp	r1, #0
c0d0661e:	d100      	bne.n	c0d06622 <__aeabi_uldivmod+0xe>
c0d06620:	2800      	cmp	r0, #0
c0d06622:	d002      	beq.n	c0d0662a <__aeabi_uldivmod+0x16>
c0d06624:	2100      	movs	r1, #0
c0d06626:	43c9      	mvns	r1, r1
c0d06628:	1c08      	adds	r0, r1, #0
c0d0662a:	b407      	push	{r0, r1, r2}
c0d0662c:	4802      	ldr	r0, [pc, #8]	; (c0d06638 <__aeabi_uldivmod+0x24>)
c0d0662e:	a102      	add	r1, pc, #8	; (adr r1, c0d06638 <__aeabi_uldivmod+0x24>)
c0d06630:	1840      	adds	r0, r0, r1
c0d06632:	9002      	str	r0, [sp, #8]
c0d06634:	bd03      	pop	{r0, r1, pc}
c0d06636:	46c0      	nop			; (mov r8, r8)
c0d06638:	ffffffc1 	.word	0xffffffc1
c0d0663c:	b403      	push	{r0, r1}
c0d0663e:	4668      	mov	r0, sp
c0d06640:	b501      	push	{r0, lr}
c0d06642:	9802      	ldr	r0, [sp, #8]
c0d06644:	f000 f832 	bl	c0d066ac <__udivmoddi4>
c0d06648:	9b01      	ldr	r3, [sp, #4]
c0d0664a:	469e      	mov	lr, r3
c0d0664c:	b002      	add	sp, #8
c0d0664e:	bc0c      	pop	{r2, r3}
c0d06650:	4770      	bx	lr
c0d06652:	46c0      	nop			; (mov r8, r8)

c0d06654 <__aeabi_lmul>:
c0d06654:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d06656:	464f      	mov	r7, r9
c0d06658:	4646      	mov	r6, r8
c0d0665a:	b4c0      	push	{r6, r7}
c0d0665c:	0416      	lsls	r6, r2, #16
c0d0665e:	0c36      	lsrs	r6, r6, #16
c0d06660:	4699      	mov	r9, r3
c0d06662:	0033      	movs	r3, r6
c0d06664:	0405      	lsls	r5, r0, #16
c0d06666:	0c2c      	lsrs	r4, r5, #16
c0d06668:	0c07      	lsrs	r7, r0, #16
c0d0666a:	0c15      	lsrs	r5, r2, #16
c0d0666c:	4363      	muls	r3, r4
c0d0666e:	437e      	muls	r6, r7
c0d06670:	436f      	muls	r7, r5
c0d06672:	4365      	muls	r5, r4
c0d06674:	0c1c      	lsrs	r4, r3, #16
c0d06676:	19ad      	adds	r5, r5, r6
c0d06678:	1964      	adds	r4, r4, r5
c0d0667a:	469c      	mov	ip, r3
c0d0667c:	42a6      	cmp	r6, r4
c0d0667e:	d903      	bls.n	c0d06688 <__aeabi_lmul+0x34>
c0d06680:	2380      	movs	r3, #128	; 0x80
c0d06682:	025b      	lsls	r3, r3, #9
c0d06684:	4698      	mov	r8, r3
c0d06686:	4447      	add	r7, r8
c0d06688:	4663      	mov	r3, ip
c0d0668a:	0c25      	lsrs	r5, r4, #16
c0d0668c:	19ef      	adds	r7, r5, r7
c0d0668e:	041d      	lsls	r5, r3, #16
c0d06690:	464b      	mov	r3, r9
c0d06692:	434a      	muls	r2, r1
c0d06694:	4343      	muls	r3, r0
c0d06696:	0c2d      	lsrs	r5, r5, #16
c0d06698:	0424      	lsls	r4, r4, #16
c0d0669a:	1964      	adds	r4, r4, r5
c0d0669c:	1899      	adds	r1, r3, r2
c0d0669e:	19c9      	adds	r1, r1, r7
c0d066a0:	0020      	movs	r0, r4
c0d066a2:	bc0c      	pop	{r2, r3}
c0d066a4:	4690      	mov	r8, r2
c0d066a6:	4699      	mov	r9, r3
c0d066a8:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d066aa:	46c0      	nop			; (mov r8, r8)

c0d066ac <__udivmoddi4>:
c0d066ac:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d066ae:	464d      	mov	r5, r9
c0d066b0:	4656      	mov	r6, sl
c0d066b2:	4644      	mov	r4, r8
c0d066b4:	465f      	mov	r7, fp
c0d066b6:	b4f0      	push	{r4, r5, r6, r7}
c0d066b8:	4692      	mov	sl, r2
c0d066ba:	b083      	sub	sp, #12
c0d066bc:	0004      	movs	r4, r0
c0d066be:	000d      	movs	r5, r1
c0d066c0:	4699      	mov	r9, r3
c0d066c2:	428b      	cmp	r3, r1
c0d066c4:	d82f      	bhi.n	c0d06726 <__udivmoddi4+0x7a>
c0d066c6:	d02c      	beq.n	c0d06722 <__udivmoddi4+0x76>
c0d066c8:	4649      	mov	r1, r9
c0d066ca:	4650      	mov	r0, sl
c0d066cc:	f000 f8ae 	bl	c0d0682c <__clzdi2>
c0d066d0:	0029      	movs	r1, r5
c0d066d2:	0006      	movs	r6, r0
c0d066d4:	0020      	movs	r0, r4
c0d066d6:	f000 f8a9 	bl	c0d0682c <__clzdi2>
c0d066da:	1a33      	subs	r3, r6, r0
c0d066dc:	4698      	mov	r8, r3
c0d066de:	3b20      	subs	r3, #32
c0d066e0:	469b      	mov	fp, r3
c0d066e2:	d500      	bpl.n	c0d066e6 <__udivmoddi4+0x3a>
c0d066e4:	e074      	b.n	c0d067d0 <__udivmoddi4+0x124>
c0d066e6:	4653      	mov	r3, sl
c0d066e8:	465a      	mov	r2, fp
c0d066ea:	4093      	lsls	r3, r2
c0d066ec:	001f      	movs	r7, r3
c0d066ee:	4653      	mov	r3, sl
c0d066f0:	4642      	mov	r2, r8
c0d066f2:	4093      	lsls	r3, r2
c0d066f4:	001e      	movs	r6, r3
c0d066f6:	42af      	cmp	r7, r5
c0d066f8:	d829      	bhi.n	c0d0674e <__udivmoddi4+0xa2>
c0d066fa:	d026      	beq.n	c0d0674a <__udivmoddi4+0x9e>
c0d066fc:	465b      	mov	r3, fp
c0d066fe:	1ba4      	subs	r4, r4, r6
c0d06700:	41bd      	sbcs	r5, r7
c0d06702:	2b00      	cmp	r3, #0
c0d06704:	da00      	bge.n	c0d06708 <__udivmoddi4+0x5c>
c0d06706:	e079      	b.n	c0d067fc <__udivmoddi4+0x150>
c0d06708:	2200      	movs	r2, #0
c0d0670a:	2300      	movs	r3, #0
c0d0670c:	9200      	str	r2, [sp, #0]
c0d0670e:	9301      	str	r3, [sp, #4]
c0d06710:	2301      	movs	r3, #1
c0d06712:	465a      	mov	r2, fp
c0d06714:	4093      	lsls	r3, r2
c0d06716:	9301      	str	r3, [sp, #4]
c0d06718:	2301      	movs	r3, #1
c0d0671a:	4642      	mov	r2, r8
c0d0671c:	4093      	lsls	r3, r2
c0d0671e:	9300      	str	r3, [sp, #0]
c0d06720:	e019      	b.n	c0d06756 <__udivmoddi4+0xaa>
c0d06722:	4282      	cmp	r2, r0
c0d06724:	d9d0      	bls.n	c0d066c8 <__udivmoddi4+0x1c>
c0d06726:	2200      	movs	r2, #0
c0d06728:	2300      	movs	r3, #0
c0d0672a:	9200      	str	r2, [sp, #0]
c0d0672c:	9301      	str	r3, [sp, #4]
c0d0672e:	9b0c      	ldr	r3, [sp, #48]	; 0x30
c0d06730:	2b00      	cmp	r3, #0
c0d06732:	d001      	beq.n	c0d06738 <__udivmoddi4+0x8c>
c0d06734:	601c      	str	r4, [r3, #0]
c0d06736:	605d      	str	r5, [r3, #4]
c0d06738:	9800      	ldr	r0, [sp, #0]
c0d0673a:	9901      	ldr	r1, [sp, #4]
c0d0673c:	b003      	add	sp, #12
c0d0673e:	bc3c      	pop	{r2, r3, r4, r5}
c0d06740:	4690      	mov	r8, r2
c0d06742:	4699      	mov	r9, r3
c0d06744:	46a2      	mov	sl, r4
c0d06746:	46ab      	mov	fp, r5
c0d06748:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d0674a:	42a3      	cmp	r3, r4
c0d0674c:	d9d6      	bls.n	c0d066fc <__udivmoddi4+0x50>
c0d0674e:	2200      	movs	r2, #0
c0d06750:	2300      	movs	r3, #0
c0d06752:	9200      	str	r2, [sp, #0]
c0d06754:	9301      	str	r3, [sp, #4]
c0d06756:	4643      	mov	r3, r8
c0d06758:	2b00      	cmp	r3, #0
c0d0675a:	d0e8      	beq.n	c0d0672e <__udivmoddi4+0x82>
c0d0675c:	07fb      	lsls	r3, r7, #31
c0d0675e:	0872      	lsrs	r2, r6, #1
c0d06760:	431a      	orrs	r2, r3
c0d06762:	4646      	mov	r6, r8
c0d06764:	087b      	lsrs	r3, r7, #1
c0d06766:	e00e      	b.n	c0d06786 <__udivmoddi4+0xda>
c0d06768:	42ab      	cmp	r3, r5
c0d0676a:	d101      	bne.n	c0d06770 <__udivmoddi4+0xc4>
c0d0676c:	42a2      	cmp	r2, r4
c0d0676e:	d80c      	bhi.n	c0d0678a <__udivmoddi4+0xde>
c0d06770:	1aa4      	subs	r4, r4, r2
c0d06772:	419d      	sbcs	r5, r3
c0d06774:	2001      	movs	r0, #1
c0d06776:	1924      	adds	r4, r4, r4
c0d06778:	416d      	adcs	r5, r5
c0d0677a:	2100      	movs	r1, #0
c0d0677c:	3e01      	subs	r6, #1
c0d0677e:	1824      	adds	r4, r4, r0
c0d06780:	414d      	adcs	r5, r1
c0d06782:	2e00      	cmp	r6, #0
c0d06784:	d006      	beq.n	c0d06794 <__udivmoddi4+0xe8>
c0d06786:	42ab      	cmp	r3, r5
c0d06788:	d9ee      	bls.n	c0d06768 <__udivmoddi4+0xbc>
c0d0678a:	3e01      	subs	r6, #1
c0d0678c:	1924      	adds	r4, r4, r4
c0d0678e:	416d      	adcs	r5, r5
c0d06790:	2e00      	cmp	r6, #0
c0d06792:	d1f8      	bne.n	c0d06786 <__udivmoddi4+0xda>
c0d06794:	465b      	mov	r3, fp
c0d06796:	9800      	ldr	r0, [sp, #0]
c0d06798:	9901      	ldr	r1, [sp, #4]
c0d0679a:	1900      	adds	r0, r0, r4
c0d0679c:	4169      	adcs	r1, r5
c0d0679e:	2b00      	cmp	r3, #0
c0d067a0:	db22      	blt.n	c0d067e8 <__udivmoddi4+0x13c>
c0d067a2:	002b      	movs	r3, r5
c0d067a4:	465a      	mov	r2, fp
c0d067a6:	40d3      	lsrs	r3, r2
c0d067a8:	002a      	movs	r2, r5
c0d067aa:	4644      	mov	r4, r8
c0d067ac:	40e2      	lsrs	r2, r4
c0d067ae:	001c      	movs	r4, r3
c0d067b0:	465b      	mov	r3, fp
c0d067b2:	0015      	movs	r5, r2
c0d067b4:	2b00      	cmp	r3, #0
c0d067b6:	db2c      	blt.n	c0d06812 <__udivmoddi4+0x166>
c0d067b8:	0026      	movs	r6, r4
c0d067ba:	409e      	lsls	r6, r3
c0d067bc:	0033      	movs	r3, r6
c0d067be:	0026      	movs	r6, r4
c0d067c0:	4647      	mov	r7, r8
c0d067c2:	40be      	lsls	r6, r7
c0d067c4:	0032      	movs	r2, r6
c0d067c6:	1a80      	subs	r0, r0, r2
c0d067c8:	4199      	sbcs	r1, r3
c0d067ca:	9000      	str	r0, [sp, #0]
c0d067cc:	9101      	str	r1, [sp, #4]
c0d067ce:	e7ae      	b.n	c0d0672e <__udivmoddi4+0x82>
c0d067d0:	4642      	mov	r2, r8
c0d067d2:	2320      	movs	r3, #32
c0d067d4:	1a9b      	subs	r3, r3, r2
c0d067d6:	4652      	mov	r2, sl
c0d067d8:	40da      	lsrs	r2, r3
c0d067da:	4641      	mov	r1, r8
c0d067dc:	0013      	movs	r3, r2
c0d067de:	464a      	mov	r2, r9
c0d067e0:	408a      	lsls	r2, r1
c0d067e2:	0017      	movs	r7, r2
c0d067e4:	431f      	orrs	r7, r3
c0d067e6:	e782      	b.n	c0d066ee <__udivmoddi4+0x42>
c0d067e8:	4642      	mov	r2, r8
c0d067ea:	2320      	movs	r3, #32
c0d067ec:	1a9b      	subs	r3, r3, r2
c0d067ee:	002a      	movs	r2, r5
c0d067f0:	4646      	mov	r6, r8
c0d067f2:	409a      	lsls	r2, r3
c0d067f4:	0023      	movs	r3, r4
c0d067f6:	40f3      	lsrs	r3, r6
c0d067f8:	4313      	orrs	r3, r2
c0d067fa:	e7d5      	b.n	c0d067a8 <__udivmoddi4+0xfc>
c0d067fc:	4642      	mov	r2, r8
c0d067fe:	2320      	movs	r3, #32
c0d06800:	2100      	movs	r1, #0
c0d06802:	1a9b      	subs	r3, r3, r2
c0d06804:	2200      	movs	r2, #0
c0d06806:	9100      	str	r1, [sp, #0]
c0d06808:	9201      	str	r2, [sp, #4]
c0d0680a:	2201      	movs	r2, #1
c0d0680c:	40da      	lsrs	r2, r3
c0d0680e:	9201      	str	r2, [sp, #4]
c0d06810:	e782      	b.n	c0d06718 <__udivmoddi4+0x6c>
c0d06812:	4642      	mov	r2, r8
c0d06814:	2320      	movs	r3, #32
c0d06816:	0026      	movs	r6, r4
c0d06818:	1a9b      	subs	r3, r3, r2
c0d0681a:	40de      	lsrs	r6, r3
c0d0681c:	002f      	movs	r7, r5
c0d0681e:	46b4      	mov	ip, r6
c0d06820:	4097      	lsls	r7, r2
c0d06822:	4666      	mov	r6, ip
c0d06824:	003b      	movs	r3, r7
c0d06826:	4333      	orrs	r3, r6
c0d06828:	e7c9      	b.n	c0d067be <__udivmoddi4+0x112>
c0d0682a:	46c0      	nop			; (mov r8, r8)

c0d0682c <__clzdi2>:
c0d0682c:	b510      	push	{r4, lr}
c0d0682e:	2900      	cmp	r1, #0
c0d06830:	d103      	bne.n	c0d0683a <__clzdi2+0xe>
c0d06832:	f000 f807 	bl	c0d06844 <__clzsi2>
c0d06836:	3020      	adds	r0, #32
c0d06838:	e002      	b.n	c0d06840 <__clzdi2+0x14>
c0d0683a:	1c08      	adds	r0, r1, #0
c0d0683c:	f000 f802 	bl	c0d06844 <__clzsi2>
c0d06840:	bd10      	pop	{r4, pc}
c0d06842:	46c0      	nop			; (mov r8, r8)

c0d06844 <__clzsi2>:
c0d06844:	211c      	movs	r1, #28
c0d06846:	2301      	movs	r3, #1
c0d06848:	041b      	lsls	r3, r3, #16
c0d0684a:	4298      	cmp	r0, r3
c0d0684c:	d301      	bcc.n	c0d06852 <__clzsi2+0xe>
c0d0684e:	0c00      	lsrs	r0, r0, #16
c0d06850:	3910      	subs	r1, #16
c0d06852:	0a1b      	lsrs	r3, r3, #8
c0d06854:	4298      	cmp	r0, r3
c0d06856:	d301      	bcc.n	c0d0685c <__clzsi2+0x18>
c0d06858:	0a00      	lsrs	r0, r0, #8
c0d0685a:	3908      	subs	r1, #8
c0d0685c:	091b      	lsrs	r3, r3, #4
c0d0685e:	4298      	cmp	r0, r3
c0d06860:	d301      	bcc.n	c0d06866 <__clzsi2+0x22>
c0d06862:	0900      	lsrs	r0, r0, #4
c0d06864:	3904      	subs	r1, #4
c0d06866:	a202      	add	r2, pc, #8	; (adr r2, c0d06870 <__clzsi2+0x2c>)
c0d06868:	5c10      	ldrb	r0, [r2, r0]
c0d0686a:	1840      	adds	r0, r0, r1
c0d0686c:	4770      	bx	lr
c0d0686e:	46c0      	nop			; (mov r8, r8)
c0d06870:	02020304 	.word	0x02020304
c0d06874:	01010101 	.word	0x01010101
	...

c0d06880 <__aeabi_memclr>:
c0d06880:	b510      	push	{r4, lr}
c0d06882:	2200      	movs	r2, #0
c0d06884:	f000 f806 	bl	c0d06894 <__aeabi_memset>
c0d06888:	bd10      	pop	{r4, pc}
c0d0688a:	46c0      	nop			; (mov r8, r8)

c0d0688c <__aeabi_memcpy>:
c0d0688c:	b510      	push	{r4, lr}
c0d0688e:	f000 f809 	bl	c0d068a4 <memcpy>
c0d06892:	bd10      	pop	{r4, pc}

c0d06894 <__aeabi_memset>:
c0d06894:	0013      	movs	r3, r2
c0d06896:	b510      	push	{r4, lr}
c0d06898:	000a      	movs	r2, r1
c0d0689a:	0019      	movs	r1, r3
c0d0689c:	f000 f840 	bl	c0d06920 <memset>
c0d068a0:	bd10      	pop	{r4, pc}
c0d068a2:	46c0      	nop			; (mov r8, r8)

c0d068a4 <memcpy>:
c0d068a4:	b570      	push	{r4, r5, r6, lr}
c0d068a6:	2a0f      	cmp	r2, #15
c0d068a8:	d932      	bls.n	c0d06910 <memcpy+0x6c>
c0d068aa:	000c      	movs	r4, r1
c0d068ac:	4304      	orrs	r4, r0
c0d068ae:	000b      	movs	r3, r1
c0d068b0:	07a4      	lsls	r4, r4, #30
c0d068b2:	d131      	bne.n	c0d06918 <memcpy+0x74>
c0d068b4:	0015      	movs	r5, r2
c0d068b6:	0004      	movs	r4, r0
c0d068b8:	3d10      	subs	r5, #16
c0d068ba:	092d      	lsrs	r5, r5, #4
c0d068bc:	3501      	adds	r5, #1
c0d068be:	012d      	lsls	r5, r5, #4
c0d068c0:	1949      	adds	r1, r1, r5
c0d068c2:	681e      	ldr	r6, [r3, #0]
c0d068c4:	6026      	str	r6, [r4, #0]
c0d068c6:	685e      	ldr	r6, [r3, #4]
c0d068c8:	6066      	str	r6, [r4, #4]
c0d068ca:	689e      	ldr	r6, [r3, #8]
c0d068cc:	60a6      	str	r6, [r4, #8]
c0d068ce:	68de      	ldr	r6, [r3, #12]
c0d068d0:	3310      	adds	r3, #16
c0d068d2:	60e6      	str	r6, [r4, #12]
c0d068d4:	3410      	adds	r4, #16
c0d068d6:	4299      	cmp	r1, r3
c0d068d8:	d1f3      	bne.n	c0d068c2 <memcpy+0x1e>
c0d068da:	230f      	movs	r3, #15
c0d068dc:	1945      	adds	r5, r0, r5
c0d068de:	4013      	ands	r3, r2
c0d068e0:	2b03      	cmp	r3, #3
c0d068e2:	d91b      	bls.n	c0d0691c <memcpy+0x78>
c0d068e4:	1f1c      	subs	r4, r3, #4
c0d068e6:	2300      	movs	r3, #0
c0d068e8:	08a4      	lsrs	r4, r4, #2
c0d068ea:	3401      	adds	r4, #1
c0d068ec:	00a4      	lsls	r4, r4, #2
c0d068ee:	58ce      	ldr	r6, [r1, r3]
c0d068f0:	50ee      	str	r6, [r5, r3]
c0d068f2:	3304      	adds	r3, #4
c0d068f4:	429c      	cmp	r4, r3
c0d068f6:	d1fa      	bne.n	c0d068ee <memcpy+0x4a>
c0d068f8:	2303      	movs	r3, #3
c0d068fa:	192d      	adds	r5, r5, r4
c0d068fc:	1909      	adds	r1, r1, r4
c0d068fe:	401a      	ands	r2, r3
c0d06900:	d005      	beq.n	c0d0690e <memcpy+0x6a>
c0d06902:	2300      	movs	r3, #0
c0d06904:	5ccc      	ldrb	r4, [r1, r3]
c0d06906:	54ec      	strb	r4, [r5, r3]
c0d06908:	3301      	adds	r3, #1
c0d0690a:	429a      	cmp	r2, r3
c0d0690c:	d1fa      	bne.n	c0d06904 <memcpy+0x60>
c0d0690e:	bd70      	pop	{r4, r5, r6, pc}
c0d06910:	0005      	movs	r5, r0
c0d06912:	2a00      	cmp	r2, #0
c0d06914:	d1f5      	bne.n	c0d06902 <memcpy+0x5e>
c0d06916:	e7fa      	b.n	c0d0690e <memcpy+0x6a>
c0d06918:	0005      	movs	r5, r0
c0d0691a:	e7f2      	b.n	c0d06902 <memcpy+0x5e>
c0d0691c:	001a      	movs	r2, r3
c0d0691e:	e7f8      	b.n	c0d06912 <memcpy+0x6e>

c0d06920 <memset>:
c0d06920:	b570      	push	{r4, r5, r6, lr}
c0d06922:	0783      	lsls	r3, r0, #30
c0d06924:	d03f      	beq.n	c0d069a6 <memset+0x86>
c0d06926:	1e54      	subs	r4, r2, #1
c0d06928:	2a00      	cmp	r2, #0
c0d0692a:	d03b      	beq.n	c0d069a4 <memset+0x84>
c0d0692c:	b2ce      	uxtb	r6, r1
c0d0692e:	0003      	movs	r3, r0
c0d06930:	2503      	movs	r5, #3
c0d06932:	e003      	b.n	c0d0693c <memset+0x1c>
c0d06934:	1e62      	subs	r2, r4, #1
c0d06936:	2c00      	cmp	r4, #0
c0d06938:	d034      	beq.n	c0d069a4 <memset+0x84>
c0d0693a:	0014      	movs	r4, r2
c0d0693c:	3301      	adds	r3, #1
c0d0693e:	1e5a      	subs	r2, r3, #1
c0d06940:	7016      	strb	r6, [r2, #0]
c0d06942:	422b      	tst	r3, r5
c0d06944:	d1f6      	bne.n	c0d06934 <memset+0x14>
c0d06946:	2c03      	cmp	r4, #3
c0d06948:	d924      	bls.n	c0d06994 <memset+0x74>
c0d0694a:	25ff      	movs	r5, #255	; 0xff
c0d0694c:	400d      	ands	r5, r1
c0d0694e:	022a      	lsls	r2, r5, #8
c0d06950:	4315      	orrs	r5, r2
c0d06952:	042a      	lsls	r2, r5, #16
c0d06954:	4315      	orrs	r5, r2
c0d06956:	2c0f      	cmp	r4, #15
c0d06958:	d911      	bls.n	c0d0697e <memset+0x5e>
c0d0695a:	0026      	movs	r6, r4
c0d0695c:	3e10      	subs	r6, #16
c0d0695e:	0936      	lsrs	r6, r6, #4
c0d06960:	3601      	adds	r6, #1
c0d06962:	0136      	lsls	r6, r6, #4
c0d06964:	001a      	movs	r2, r3
c0d06966:	199b      	adds	r3, r3, r6
c0d06968:	6015      	str	r5, [r2, #0]
c0d0696a:	6055      	str	r5, [r2, #4]
c0d0696c:	6095      	str	r5, [r2, #8]
c0d0696e:	60d5      	str	r5, [r2, #12]
c0d06970:	3210      	adds	r2, #16
c0d06972:	4293      	cmp	r3, r2
c0d06974:	d1f8      	bne.n	c0d06968 <memset+0x48>
c0d06976:	220f      	movs	r2, #15
c0d06978:	4014      	ands	r4, r2
c0d0697a:	2c03      	cmp	r4, #3
c0d0697c:	d90a      	bls.n	c0d06994 <memset+0x74>
c0d0697e:	1f26      	subs	r6, r4, #4
c0d06980:	08b6      	lsrs	r6, r6, #2
c0d06982:	3601      	adds	r6, #1
c0d06984:	00b6      	lsls	r6, r6, #2
c0d06986:	001a      	movs	r2, r3
c0d06988:	199b      	adds	r3, r3, r6
c0d0698a:	c220      	stmia	r2!, {r5}
c0d0698c:	4293      	cmp	r3, r2
c0d0698e:	d1fc      	bne.n	c0d0698a <memset+0x6a>
c0d06990:	2203      	movs	r2, #3
c0d06992:	4014      	ands	r4, r2
c0d06994:	2c00      	cmp	r4, #0
c0d06996:	d005      	beq.n	c0d069a4 <memset+0x84>
c0d06998:	b2c9      	uxtb	r1, r1
c0d0699a:	191c      	adds	r4, r3, r4
c0d0699c:	7019      	strb	r1, [r3, #0]
c0d0699e:	3301      	adds	r3, #1
c0d069a0:	429c      	cmp	r4, r3
c0d069a2:	d1fb      	bne.n	c0d0699c <memset+0x7c>
c0d069a4:	bd70      	pop	{r4, r5, r6, pc}
c0d069a6:	0014      	movs	r4, r2
c0d069a8:	0003      	movs	r3, r0
c0d069aa:	e7cc      	b.n	c0d06946 <memset+0x26>

c0d069ac <setjmp>:
c0d069ac:	c0f0      	stmia	r0!, {r4, r5, r6, r7}
c0d069ae:	4641      	mov	r1, r8
c0d069b0:	464a      	mov	r2, r9
c0d069b2:	4653      	mov	r3, sl
c0d069b4:	465c      	mov	r4, fp
c0d069b6:	466d      	mov	r5, sp
c0d069b8:	4676      	mov	r6, lr
c0d069ba:	c07e      	stmia	r0!, {r1, r2, r3, r4, r5, r6}
c0d069bc:	3828      	subs	r0, #40	; 0x28
c0d069be:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0d069c0:	2000      	movs	r0, #0
c0d069c2:	4770      	bx	lr

c0d069c4 <longjmp>:
c0d069c4:	3010      	adds	r0, #16
c0d069c6:	c87c      	ldmia	r0!, {r2, r3, r4, r5, r6}
c0d069c8:	4690      	mov	r8, r2
c0d069ca:	4699      	mov	r9, r3
c0d069cc:	46a2      	mov	sl, r4
c0d069ce:	46ab      	mov	fp, r5
c0d069d0:	46b5      	mov	sp, r6
c0d069d2:	c808      	ldmia	r0!, {r3}
c0d069d4:	3828      	subs	r0, #40	; 0x28
c0d069d6:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0d069d8:	1c08      	adds	r0, r1, #0
c0d069da:	d100      	bne.n	c0d069de <longjmp+0x1a>
c0d069dc:	2001      	movs	r0, #1
c0d069de:	4718      	bx	r3

c0d069e0 <strlen>:
c0d069e0:	b510      	push	{r4, lr}
c0d069e2:	0783      	lsls	r3, r0, #30
c0d069e4:	d027      	beq.n	c0d06a36 <strlen+0x56>
c0d069e6:	7803      	ldrb	r3, [r0, #0]
c0d069e8:	2b00      	cmp	r3, #0
c0d069ea:	d026      	beq.n	c0d06a3a <strlen+0x5a>
c0d069ec:	0003      	movs	r3, r0
c0d069ee:	2103      	movs	r1, #3
c0d069f0:	e002      	b.n	c0d069f8 <strlen+0x18>
c0d069f2:	781a      	ldrb	r2, [r3, #0]
c0d069f4:	2a00      	cmp	r2, #0
c0d069f6:	d01c      	beq.n	c0d06a32 <strlen+0x52>
c0d069f8:	3301      	adds	r3, #1
c0d069fa:	420b      	tst	r3, r1
c0d069fc:	d1f9      	bne.n	c0d069f2 <strlen+0x12>
c0d069fe:	6819      	ldr	r1, [r3, #0]
c0d06a00:	4a0f      	ldr	r2, [pc, #60]	; (c0d06a40 <strlen+0x60>)
c0d06a02:	4c10      	ldr	r4, [pc, #64]	; (c0d06a44 <strlen+0x64>)
c0d06a04:	188a      	adds	r2, r1, r2
c0d06a06:	438a      	bics	r2, r1
c0d06a08:	4222      	tst	r2, r4
c0d06a0a:	d10f      	bne.n	c0d06a2c <strlen+0x4c>
c0d06a0c:	3304      	adds	r3, #4
c0d06a0e:	6819      	ldr	r1, [r3, #0]
c0d06a10:	4a0b      	ldr	r2, [pc, #44]	; (c0d06a40 <strlen+0x60>)
c0d06a12:	188a      	adds	r2, r1, r2
c0d06a14:	438a      	bics	r2, r1
c0d06a16:	4222      	tst	r2, r4
c0d06a18:	d108      	bne.n	c0d06a2c <strlen+0x4c>
c0d06a1a:	3304      	adds	r3, #4
c0d06a1c:	6819      	ldr	r1, [r3, #0]
c0d06a1e:	4a08      	ldr	r2, [pc, #32]	; (c0d06a40 <strlen+0x60>)
c0d06a20:	188a      	adds	r2, r1, r2
c0d06a22:	438a      	bics	r2, r1
c0d06a24:	4222      	tst	r2, r4
c0d06a26:	d0f1      	beq.n	c0d06a0c <strlen+0x2c>
c0d06a28:	e000      	b.n	c0d06a2c <strlen+0x4c>
c0d06a2a:	3301      	adds	r3, #1
c0d06a2c:	781a      	ldrb	r2, [r3, #0]
c0d06a2e:	2a00      	cmp	r2, #0
c0d06a30:	d1fb      	bne.n	c0d06a2a <strlen+0x4a>
c0d06a32:	1a18      	subs	r0, r3, r0
c0d06a34:	bd10      	pop	{r4, pc}
c0d06a36:	0003      	movs	r3, r0
c0d06a38:	e7e1      	b.n	c0d069fe <strlen+0x1e>
c0d06a3a:	2000      	movs	r0, #0
c0d06a3c:	e7fa      	b.n	c0d06a34 <strlen+0x54>
c0d06a3e:	46c0      	nop			; (mov r8, r8)
c0d06a40:	fefefeff 	.word	0xfefefeff
c0d06a44:	80808080 	.word	0x80808080

c0d06a48 <C_badge_back_colors>:
c0d06a48:	00000000 00ffffff                       ........

c0d06a50 <C_badge_back_bitmap>:
c0d06a50:	c1fe01e0 067f38fd c4ff81df bcfff37f     .....8..........
c0d06a60:	f1e7e71f 7807f83f 00000000              ....?..x....

c0d06a6c <C_badge_back>:
c0d06a6c:	0000000e 0000000e 00000001 c0d06a48     ............Hj..
c0d06a7c:	c0d06a50                                Pj..

c0d06a80 <C_icon_dashboard_colors>:
c0d06a80:	00000000 00ffffff                       ........

c0d06a88 <C_icon_dashboard_bitmap>:
c0d06a88:	c1fe01e0 067038ff 9e7e79d8 b9e7e79f     .....8p..y~.....
c0d06a98:	f1c0e601 7807f83f 00000000              ....?..x....

c0d06aa4 <C_icon_dashboard>:
c0d06aa4:	0000000e 0000000e 00000001 c0d06a80     .............j..
c0d06ab4:	c0d06a88                                .j..

c0d06ab8 <C_ED25519_ORDER>:
c0d06ab8:	00000010 00000000 00000000 00000000     ................
c0d06ac8:	def9de14 d69cf7a2 1a631258 edd3f55c     ........X.c.\...

c0d06ad8 <C_ED25519_FIELD>:
c0d06ad8:	ffffff7f ffffffff ffffffff ffffffff     ................
c0d06ae8:	ffffffff ffffffff ffffffff edffffff     ................

c0d06af8 <C_fe_ma2>:
c0d06af8:	ffffff7f ffffffff ffffffff ffffffff     ................
c0d06b08:	ffffffff ffffffff c8ffffff c9e33ddb     .............=..

c0d06b18 <C_fe_ma>:
c0d06b18:	ffffff7f ffffffff ffffffff ffffffff     ................
c0d06b28:	ffffffff ffffffff ffffffff e792f8ff     ................

c0d06b38 <C_fe_fffb1>:
c0d06b38:	effb717e 171bd6da 37c5a920 e319fb41     ~q...... ..7A...
c0d06b48:	a80494d1 8d732ab9 7569a722 ee411c32     .....*s.".iu2.A.

c0d06b58 <C_fe_fffb2>:
c0d06b58:	0a1e064d f62c5a04 b751d491 be5f16c0     M....Z,...Q..._.
c0d06b68:	4603de51 dff75604 8364ded2 e09a7c60     Q..F.V....d.`|..

c0d06b78 <C_fe_fffb3>:
c0d06b78:	0d114a67 ef08c214 404695b8 eda20d3f     gJ........F@?...
c0d06b88:	4eff2440 294296a5 877d1b58 662c3017     @$.N..B)X.}..0,f

c0d06b98 <C_fe_fffb4>:
c0d06b98:	03f3431a f9db6710 88f4c026 2e43f77e     .C...g..&...~.C.
c0d06ba8:	08fc46ee 494a3fa1 03193d85 8691b3b6     .F...?JI.=......

c0d06bb8 <C_fe_sqrtm1>:
c0d06bb8:	8024832b 0bdfc14f 99004d2b a7d7fb3d     +.$.O...+M..=...
c0d06bc8:	0618432f 78e42fad 271beec4 b0a00e4a     /C.../.x...'J...

c0d06bd8 <C_fe_qm5div8>:
c0d06bd8:	ffffff0f ffffffff ffffffff ffffffff     ................
c0d06be8:	ffffffff ffffffff ffffffff fdffffff     ................

c0d06bf8 <C_sub_address_prefix>:
c0d06bf8:	41627553 00726464                       SubAddr.

c0d06c00 <C_ED25519_G>:
c0d06c00:	36692104 536ecdd3 e2a4c0fe dcd6fd31     .!i6..nS....1...
c0d06c10:	c72c695c a7259560 2d56c9b2 d5258f60     \i,.`.%...V-`.%.
c0d06c20:	6666661a 66666666 66666666 66666666     .fffffffffffffff
c0d06c30:	66666666 66666666 66666666 66666666     ffffffffffffffff
c0d06c40:	59658b58                                         X

c0d06c41 <C_ED25519_Hy>:
c0d06c41:	7059658b af993715 9fdcea2a ead0adf1     .eYp.7..*.......
c0d06c51:	d551726c a9cf5441 0d3a172c 941f9cd3     lrQ.AT..,.:.....
c0d06c61:	756f6d61 6300746e 696d6d6f 6e656d74     amount.commitmen
c0d06c71:	616d5f74 4d006b73                                t_mask.

c0d06c78 <C_MAGIC>:
c0d06c78:	454e4f4d 57484f52 2e302e33 00000030     MONEROHW3.0.0...

c0d06c88 <crcTable>:
c0d06c88:	00000000 77073096 ee0e612c 990951ba     .....0.w,a...Q..
c0d06c98:	076dc419 706af48f e963a535 9e6495a3     ..m...jp5.c...d.
c0d06ca8:	0edb8832 79dcb8a4 e0d5e91e 97d2d988     2......y........
c0d06cb8:	09b64c2b 7eb17cbd e7b82d07 90bf1d91     +L...|.~.-......
c0d06cc8:	1db71064 6ab020f2 f3b97148 84be41de     d.... .jHq...A..
c0d06cd8:	1adad47d 6ddde4eb f4d4b551 83d385c7     }......mQ.......
c0d06ce8:	136c9856 646ba8c0 fd62f97a 8a65c9ec     V.l...kdz.b...e.
c0d06cf8:	14015c4f 63066cd9 fa0f3d63 8d080df5     O\...l.cc=......
c0d06d08:	3b6e20c8 4c69105e d56041e4 a2677172     . n;^.iL.A`.rqg.
c0d06d18:	3c03e4d1 4b04d447 d20d85fd a50ab56b     ...<G..K....k...
c0d06d28:	35b5a8fa 42b2986c dbbbc9d6 acbcf940     ...5l..B....@...
c0d06d38:	32d86ce3 45df5c75 dcd60dcf abd13d59     .l.2u\.E....Y=..
c0d06d48:	26d930ac 51de003a c8d75180 bfd06116     .0.&:..Q.Q...a..
c0d06d58:	21b4f4b5 56b3c423 cfba9599 b8bda50f     ...!#..V........
c0d06d68:	2802b89e 5f058808 c60cd9b2 b10be924     ...(..._....$...
c0d06d78:	2f6f7c87 58684c11 c1611dab b6662d3d     .|o/.LhX..a.=-f.
c0d06d88:	76dc4190 01db7106 98d220bc efd5102a     .A.v.q... ..*...
c0d06d98:	71b18589 06b6b51f 9fbfe4a5 e8b8d433     ...q........3...
c0d06da8:	7807c9a2 0f00f934 9609a88e e10e9818     ...x4...........
c0d06db8:	7f6a0dbb 086d3d2d 91646c97 e6635c01     ..j.-=m..ld..\c.
c0d06dc8:	6b6b51f4 1c6c6162 856530d8 f262004e     .Qkkbal..0e.N.b.
c0d06dd8:	6c0695ed 1b01a57b 8208f4c1 f50fc457     ...l{.......W...
c0d06de8:	65b0d9c6 12b7e950 8bbeb8ea fcb9887c     ...eP.......|...
c0d06df8:	62dd1ddf 15da2d49 8cd37cf3 fbd44c65     ...bI-...|..eL..
c0d06e08:	4db26158 3ab551ce a3bc0074 d4bb30e2     Xa.M.Q.:t....0..
c0d06e18:	4adfa541 3dd895d7 a4d1c46d d3d6f4fb     A..J...=m.......
c0d06e28:	4369e96a 346ed9fc ad678846 da60b8d0     j.iC..n4F.g...`.
c0d06e38:	44042d73 33031de5 aa0a4c5f dd0d7cc9     s-.D...3_L...|..
c0d06e48:	5005713c 270241aa be0b1010 c90c2086     <q.P.A.'..... ..
c0d06e58:	5768b525 206f85b3 b966d409 ce61e49f     %.hW..o ..f...a.
c0d06e68:	5edef90e 29d9c998 b0d09822 c7d7a8b4     ...^...)".......
c0d06e78:	59b33d17 2eb40d81 b7bd5c3b c0ba6cad     .=.Y....;\...l..
c0d06e88:	edb88320 9abfb3b6 03b6e20c 74b1d29a      ..............t
c0d06e98:	ead54739 9dd277af 04db2615 73dc1683     9G...w...&.....s
c0d06ea8:	e3630b12 94643b84 0d6d6a3e 7a6a5aa8     ..c..;d.>jm..Zjz
c0d06eb8:	e40ecf0b 9309ff9d 0a00ae27 7d079eb1     ........'......}
c0d06ec8:	f00f9344 8708a3d2 1e01f268 6906c2fe     D.......h......i
c0d06ed8:	f762575d 806567cb 196c3671 6e6b06e7     ]Wb..ge.q6l...kn
c0d06ee8:	fed41b76 89d32be0 10da7a5a 67dd4acc     v....+..Zz...J.g
c0d06ef8:	f9b9df6f 8ebeeff9 17b7be43 60b08ed5     o.......C......`
c0d06f08:	d6d6a3e8 a1d1937e 38d8c2c4 4fdff252     ....~......8R..O
c0d06f18:	d1bb67f1 a6bc5767 3fb506dd 48b2364b     .g..gW.....?K6.H
c0d06f28:	d80d2bda af0a1b4c 36034af6 41047a60     .+..L....J.6`z.A
c0d06f38:	df60efc3 a867df55 316e8eef 4669be79     ..`.U.g...n1y.iF
c0d06f48:	cb61b38c bc66831a 256fd2a0 5268e236     ..a...f...o%6.hR
c0d06f58:	cc0c7795 bb0b4703 220216b9 5505262f     .w...G....."/&.U
c0d06f68:	c5ba3bbe b2bd0b28 2bb45a92 5cb36a04     .;..(....Z.+.j.\
c0d06f78:	c2d7ffa7 b5d0cf31 2cd99e8b 5bdeae1d     ....1......,...[
c0d06f88:	9b64c2b0 ec63f226 756aa39c 026d930a     ..d.&.c...ju..m.
c0d06f98:	9c0906a9 eb0e363f 72076785 05005713     ....?6...g.r.W..
c0d06fa8:	95bf4a82 e2b87a14 7bb12bae 0cb61b38     .J...z...+.{8...
c0d06fb8:	92d28e9b e5d5be0d 7cdcefb7 0bdbdf21     ...........|!...
c0d06fc8:	86d3d2d4 f1d4e242 68ddb3f8 1fda836e     ....B......hn...
c0d06fd8:	81be16cd f6b9265b 6fb077e1 18b74777     ....[&...w.owG..
c0d06fe8:	88085ae6 ff0f6a70 66063bca 11010b5c     .Z..pj...;.f\...
c0d06ff8:	8f659eff f862ae69 616bffd3 166ccf45     ..e.i.b...kaE.l.
c0d07008:	a00ae278 d70dd2ee 4e048354 3903b3c2     x.......T..N...9
c0d07018:	a7672661 d06016f7 4969474d 3e6e77db     a&g...`.MGiI.wn>
c0d07028:	aed16a4a d9d65adc 40df0b66 37d83bf0     Jj...Z..f..@.;.7
c0d07038:	a9bcae53 debb9ec5 47b2cf7f 30b5ffe9     S..........G...0
c0d07048:	bdbdf21c cabac28a 53b39330 24b4a3a6     ........0..S...$
c0d07058:	bad03605 cdd70693 54de5729 23d967bf     .6......)W.T.g.#
c0d07068:	b3667a2e c4614ab8 5d681b02 2a6f2b94     .zf..Ja...h].+o*
c0d07078:	b40bbe37 c30c8ea1 5a05df1b 2d02ef8d     7..........Z...-

c0d07088 <alphabet>:
c0d07088:	34333231 38373635 43424139 47464544     123456789ABCDEFG
c0d07098:	4c4b4a48 51504e4d 55545352 59585756     HJKLMNPQRSTUVWXY
c0d070a8:	6362615a 67666564 6b6a6968 706f6e6d     Zabcdefghijkmnop
c0d070b8:	74737271 78777675 00007a79              qrstuvwxyz..

c0d070c4 <encoded_block_sizes>:
c0d070c4:	00000000 00000002 00000003 00000005     ................
c0d070d4:	00000006 00000007 00000009 0000000a     ................
c0d070e4:	0000000b 65654620 6d783f00 52003f72     .... Fee.?xmr?.R
c0d070f4:	63656a65 63410074 74706563 68432000     eject.Accept. Ch
c0d07104:	65676e61 454c4300 57205241 5344524f     ange.CLEAR WORDS
c0d07114:	4f4e2800 50495720 20002945 756f6d41     .(NO WIPE). Amou
c0d07124:	4400746e 69747365 6974616e 3f006e6f     nt.Destination.?
c0d07134:	74736564 003f312e 7365643f 3f322e74     dest.1?.?dest.2?
c0d07144:	65643f00 332e7473 643f003f 2e747365     .?dest.3?.?dest.
c0d07154:	3f003f34 74736564 003f352e 45005854     4?.?dest.5?.TX.E
c0d07164:	726f7078 74490074 6c697720 6572206c     xport.It will re
c0d07174:	00746573 20656874 6c707061 74616369     set.the applicat
c0d07184:	216e6f69 6f624100 54007472 20747365     ion!.Abort.Test 
c0d07194:	7774654e 206b726f 61745300 4e206567     Network .Stage N
c0d071a4:	6f777465 4d006b72 206e6961 7774654e     etwork.Main Netw
c0d071b4:	006b726f 74736554 74654e20 6b726f77     ork.Test Network
c0d071c4:	53002020 65676174 74654e20 6b726f77       .Stage Network
c0d071d4:	614d0020 4e206e69 6f777465 20206b72      .Main Network  
c0d071e4:	61655200 20796c6c 65736552 003f2074     .Really Reset ?.
c0d071f4:	59006f4e 43007365 676e6168 654e2065     No.Yes.Change Ne
c0d07204:	726f7774 6853006b 3220776f 6f772035     twork.Show 25 wo
c0d07214:	00736472 65736552 61420074 53006b63     rds.Reset.Back.S
c0d07224:	00706177 20296328 6764654c 53207265     wap.(c) Ledger S
c0d07234:	53005341 20636570 706c6120 41006168     AS.Spec  alpha.A
c0d07244:	20207070 2e332e31 57580031 613f0050     pp  1.3.1.XWP.?a
c0d07254:	2e726464 3f003f31 72646461 003f322e     ddr.1?.?addr.2?.
c0d07264:	6464613f 3f332e72 64613f00 342e7264     ?addr.3?.?addr.4
c0d07274:	613f003f 2e726464 53003f35 69747465     ?.?addr.5?.Setti
c0d07284:	0073676e 756f6241 75510074 61207469     ngs.About.Quit a
c0d07294:	00007070                                pp..

c0d07298 <ui_menu_fee_validation>:
	...
c0d072a0:	00000001 00000000 c0d070e8 c0d070ed     .........p...p..
	...
c0d072b8:	c0d031e1 ffff5331 00000000 c0d070f3     .1..1S.......p..
c0d072c8:	c0d070e9 00000000 00000000 c0d031e1     .p...........1..
c0d072d8:	0000acce 00000000 c0d070fa c0d070e9     .........p...p..
	...

c0d07308 <ui_menu_change_validation>:
	...
c0d07310:	00000001 00000000 c0d07101 c0d070ed     .........q...p..
	...
c0d07328:	c0d031e1 ffff5331 00000000 c0d070f3     .1..1S.......p..
c0d07338:	c0d07102 00000000 00000000 c0d031e1     .q...........1..
c0d07348:	0000acce 00000000 c0d070fa c0d07102     .........p...q..
	...

c0d07378 <ui_menu_words>:
c0d07378:	00000000 c0d032a1 00000000 00000000     .....2..........
c0d07388:	c0d071e4 c0d071e4 00000000 00000000     .q...q..........
c0d07398:	c0d032a1 00000002 00000000 c0d071e4     .2...........q..
c0d073a8:	c0d071e4 00000000 00000000 c0d032a1     .q...........2..
c0d073b8:	00000004 00000000 c0d071e4 c0d071e4     .........q...q..
	...
c0d073d0:	c0d032a1 00000006 00000000 c0d071e4     .2...........q..
c0d073e0:	c0d071e4 00000000 00000000 c0d032a1     .q...........2..
c0d073f0:	00000008 00000000 c0d071e4 c0d071e4     .........q...q..
	...
c0d07408:	c0d032a1 0000000a 00000000 c0d071e4     .2...........q..
c0d07418:	c0d071e4 00000000 00000000 c0d032a1     .q...........2..
c0d07428:	0000000c 00000000 c0d071e4 c0d071e4     .........q...q..
	...
c0d07440:	c0d032a1 0000000e 00000000 c0d071e4     .2...........q..
c0d07450:	c0d071e4 00000000 00000000 c0d032a1     .q...........2..
c0d07460:	00000010 00000000 c0d071e4 c0d071e4     .........q...q..
	...
c0d07478:	c0d032a1 00000012 00000000 c0d071e4     .2...........q..
c0d07488:	c0d071e4 00000000 00000000 c0d032a1     .q...........2..
c0d07498:	00000014 00000000 c0d071e4 c0d071e4     .........q...q..
	...
c0d074b0:	c0d032a1 00000016 00000000 c0d071e4     .2...........q..
c0d074c0:	c0d071e4 00000000 00000000 c0d032a1     .q...........2..
c0d074d0:	00000018 00000000 c0d071e4 c0d071e4     .........q...q..
	...
c0d074e8:	c0d032b5 ffffffff 00000000 c0d07109     .2...........q..
c0d074f8:	c0d07115 00000000 00000000 00000000     .q..............
	...

c0d0751c <ui_menu_validation>:
	...
c0d07524:	00000001 00000000 c0d0711f c0d070ed     .........q...p..
	...
c0d07540:	00000003 00000000 c0d07127 c0d07133     ........'q..3q..
	...
c0d0755c:	00000004 00000000 c0d0713c c0d0713c     ........<q..<q..
	...
c0d07578:	00000005 00000000 c0d07145 c0d07145     ........Eq..Eq..
	...
c0d07594:	00000006 00000000 c0d0714e c0d0714e     ........Nq..Nq..
	...
c0d075b0:	00000007 00000000 c0d07157 c0d07157     ........Wq..Wq..
	...
c0d075c8:	c0d03339 ffff5331 00000000 c0d070f3     93..1S.......p..
c0d075d8:	c0d07160 00000000 00000000 c0d03339     `q..........93..
c0d075e8:	0000acce 00000000 c0d070fa c0d07160     .........p..`q..
	...

c0d07618 <ui_export_viewkey>:
c0d07618:	00000003 00800000 00000020 00000001     ........ .......
c0d07628:	00000000 00ffffff 00000000 00000000     ................
	...
c0d07650:	00030005 0007000c 00000007 00000000     ................
c0d07660:	00ffffff 00000000 00070000 00000000     ................
	...
c0d07688:	00750005 0008000d 00000006 00000000     ..u.............
c0d07698:	00ffffff 00000000 00060000 00000000     ................
	...
c0d076c0:	00000107 0080000c 00000020 00000000     ........ .......
c0d076d0:	00ffffff 00000000 00008008 20002008     ............. . 
	...
c0d076f8:	00000207 0080001a 00000020 00000000     ........ .......
c0d07708:	00ffffff 00000000 00008008 20002008     ............. . 
	...
c0d07730:	77656956 79654b20 00000000 61656c50     View Key....Plea
c0d07740:	43206573 65636e61 0000006c              se Cancel...

c0d0774c <ui_menu_network>:
	...
c0d0775c:	c0d0716a c0d07178 00000000 00000000     jq..xq..........
c0d0776c:	c0d03251 00000000 c0d06a6c c0d07189     Q2......lj...q..
c0d0777c:	00000000 0000283d 00000000 c0d03671     ....=(......q6..
c0d0778c:	00000001 00000000 c0d0718f 00000000     .........q......
	...
c0d077a4:	c0d03671 00000002 00000000 c0d0719d     q6...........q..
	...
c0d077c0:	c0d03671 00000000 00000000 c0d071ab     q6...........q..
	...

c0d077f4 <ui_menu_reset>:
	...
c0d07804:	c0d071e5 00000000 00000000 00000000     .q..............
c0d07814:	c0d03251 00000000 c0d06a6c c0d071f4     Q2......lj...q..
c0d07824:	00000000 0000283d 00000000 c0d03759     ....=(......Y7..
	...
c0d0783c:	c0d071f7 00000000 00000000 00000000     .q..............
	...

c0d07864 <ui_menu_settings>:
c0d07864:	00000000 c0d03741 00000000 00000000     ....A7..........
c0d07874:	c0d071fb 00000000 00000000 00000000     .q..............
c0d07884:	c0d0331d 00000000 00000000 c0d0720a     .3...........r..
	...
c0d0789c:	c0d077f4 00000000 00000000 00000000     .w..............
c0d078ac:	c0d07218 00000000 00000000 00000000     .r..............
c0d078bc:	c0d03251 00000002 c0d06a6c c0d0721e     Q2......lj...r..
c0d078cc:	00000000 0000283d 00000000 00000000     ....=(..........
	...

c0d078f0 <ui_menu_info>:
	...
c0d078f8:	ffffffff 00000000 c0d07223 00000000     ........#r......
	...
c0d07914:	ffffffff 00000000 c0d07228 00000000     ........(r......
	...
c0d07930:	ffffffff 00000000 c0d07237 00000000     ........7r......
	...
c0d0794c:	ffffffff 00000000 c0d07243 00000000     ........Cr......
	...
c0d07964:	c0d03251 00000003 c0d06a6c c0d0721e     Q2......lj...r..
c0d07974:	00000000 0000283d 00000000 00000000     ....=(..........
	...

c0d07998 <ui_menu_pubaddr>:
	...
c0d079a0:	00000003 00000000 c0d0724e c0d07252     ........Nr..Rr..
	...
c0d079bc:	00000004 00000000 c0d0725b c0d0725b     ........[r..[r..
	...
c0d079d8:	00000005 00000000 c0d07264 c0d07264     ........dr..dr..
	...
c0d079f4:	00000006 00000000 c0d0726d c0d0726d     ........mr..mr..
	...
c0d07a10:	00000007 00000000 c0d07276 c0d07276     ........vr..vr..
	...
c0d07a28:	c0d03251 00000000 c0d06a6c c0d0721e     Q2......lj...r..
c0d07a38:	00000000 0000283d 00000000 00000000     ....=(..........
	...

c0d07a5c <ui_menu_main>:
c0d07a5c:	00000000 c0d038dd 00000000 00000000     .....8..........
c0d07a6c:	c0d0724e c0d071e4 00000000 c0d07864     Nr...q......dx..
	...
c0d07a88:	c0d0727f 00000000 00000000 c0d078f0     .r...........x..
	...
c0d07aa4:	c0d07288 00000000 00000000 00000000     .r..............
c0d07ab4:	c0d04de1 00000000 c0d06aa4 c0d0728e     .M.......j...r..
c0d07ac4:	00000000 00001d32 00000000 00000000     ....2...........
	...
c0d07ae8:	000001b0 00a7b000 00000000              ............

c0d07af4 <ux_menu_elements>:
c0d07af4:	00008003 00800000 00000020 00000001     ........ .......
c0d07b04:	00000000 00ffffff 00000000 00000000     ................
	...
c0d07b2c:	00038105 0007000e 00000004 00000000     ................
c0d07b3c:	00ffffff 00000000 000b0000 00000000     ................
	...
c0d07b64:	00768205 0007000e 00000004 00000000     ..v.............
c0d07b74:	00ffffff 00000000 000c0000 00000000     ................
	...
c0d07b9c:	000e4107 00640003 0000000c 00000000     .A....d.........
c0d07bac:	00ffffff 00000000 0000800a 00000000     ................
	...
c0d07bd4:	000e4207 00640023 0000000c 00000000     .B..#.d.........
c0d07be4:	00ffffff 00000000 0000800a 00000000     ................
	...
c0d07c0c:	000e1005 00000009 00000000 00000000     ................
c0d07c1c:	00ffffff 00000000 00000000 00000000     ................
	...
c0d07c44:	000e2007 00640013 0000000c 00000000     . ....d.........
c0d07c54:	00ffffff 00000000 00008008 00000000     ................
	...
c0d07c7c:	000e2107 0064000c 0000000c 00000000     .!....d.........
c0d07c8c:	00ffffff 00000000 00008008 00000000     ................
	...
c0d07cb4:	000e2207 0064001a 0000000c 00000000     ."....d.........
c0d07cc4:	00ffffff 00000000 00008008 00000000     ................
	...

c0d07cec <UX_MENU_END_ENTRY>:
	...

c0d07d08 <SW_INTERNAL>:
c0d07d08:	0190006f                                         o.

c0d07d0a <SW_BUSY>:
c0d07d0a:	00670190                                         ..

c0d07d0c <SW_WRONG_LENGTH>:
c0d07d0c:	85690067                                         g.

c0d07d0e <SW_PROOF_OF_PRESENCE_REQUIRED>:
c0d07d0e:	d0f18569 00000000 4e4f4f4d 90009000     i.......MOON....
	...

c0d07d20 <SW_BAD_KEY_HANDLE>:
c0d07d20:	3255806a                                         j.

c0d07d22 <U2F_VERSION>:
c0d07d22:	5f463255 00903256                       U2F_V2..

c0d07d2a <INFO>:
c0d07d2a:	00900901                                ....

c0d07d2e <SW_UNKNOWN_CLASS>:
c0d07d2e:	006d006e                                         n.

c0d07d30 <SW_UNKNOWN_INSTRUCTION>:
c0d07d30:	ffff006d                                         m.

c0d07d32 <BROADCAST_CHANNEL>:
c0d07d32:	ffffffff                                ....

c0d07d36 <FORBIDDEN_CHANNEL>:
c0d07d36:	00000000 21090000                                ......

c0d07d3c <USBD_HID_Desc_fido>:
c0d07d3c:	01112109 22220121 00000000              .!..!.""....

c0d07d48 <USBD_HID_Desc>:
c0d07d48:	01112109 22220100 f1d00600                       .!...."".

c0d07d51 <HID_ReportDesc_fido>:
c0d07d51:	09f1d006 0901a101 26001503 087500ff     ...........&..u.
c0d07d61:	08814095 00150409 7500ff26 91409508     .@......&..u..@.
c0d07d71:	a006c008                                         ..

c0d07d73 <HID_ReportDesc>:
c0d07d73:	09ffa006 0901a101 26001503 087500ff     ...........&..u.
c0d07d83:	08814095 00150409 7500ff26 91409508     .@......&..u..@.
c0d07d93:	0000c008 d0635500                                .....

c0d07d98 <HID_Desc>:
c0d07d98:	c0d06355 c0d06365 c0d06375 c0d06385     Uc..ec..uc...c..
c0d07da8:	c0d06395 c0d063a5 c0d063b5 00000000     .c...c...c......

c0d07db8 <USBD_HID>:
c0d07db8:	c0d0618d c0d061bf c0d060f7 00000000     .a...a...`......
c0d07dc8:	00000000 c0d062e5 c0d062fd 00000000     .....b...b......
	...
c0d07de0:	c0d06441 c0d06441 c0d06441 c0d06451     Ad..Ad..Ad..Qd..

c0d07df0 <USBD_U2F>:
c0d07df0:	c0d0626d c0d061bf c0d060f7 00000000     mb...a...`......
c0d07e00:	00000000 c0d062a1 c0d062b9 00000000     .....b...b......
	...
c0d07e18:	c0d06441 c0d06441 c0d06441 c0d06451     Ad..Ad..Ad..Qd..

c0d07e28 <USBD_DeviceDesc>:
c0d07e28:	02000112 40000000 00012c97 02010200     .......@.,......
c0d07e38:	03040103                                         ..

c0d07e3a <USBD_LangIDDesc>:
c0d07e3a:	04090304                                ....

c0d07e3e <USBD_MANUFACTURER_STRING>:
c0d07e3e:	004c030e 00640065 00650067 030e0072              ..L.e.d.g.e.r.

c0d07e4c <USBD_PRODUCT_FS_STRING>:
c0d07e4c:	004e030e 006e0061 0020006f 030a0053              ..N.a.n.o. .S.

c0d07e5a <USB_SERIAL_STRING>:
c0d07e5a:	0030030a 00300030 02090031                       ..0.0.0.1.

c0d07e64 <USBD_CfgDesc>:
c0d07e64:	00490209 c0020102 00040932 00030200     ..I.....2.......
c0d07e74:	21090200 01000111 07002222 40038205     ...!...."".....@
c0d07e84:	05070100 00400302 01040901 01030200     ......@.........
c0d07e94:	21090201 01210111 07002222 40038105     ...!..!."".....@
c0d07ea4:	05070100 00400301 00000001              ......@.....

c0d07eb0 <USBD_DeviceQualifierDesc>:
c0d07eb0:	0200060a 40000000 00000001              .......@....

c0d07ebc <_etext>:
c0d07ebc:	00000000 	.word	0x00000000

c0d07ec0 <N_state_pic>:
	...
