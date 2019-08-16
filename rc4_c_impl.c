/* gcc -Wall -O3 -o rc4_c_impl rc4_c_impl.c */

#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

struct rc4_state_t {
	uint8_t S[256];
	uint8_t i, j;
};

static void swap(uint8_t *x, uint8_t *y) {
	uint8_t tmp = *x;
	*x = *y;
	*y = tmp;
}

void rc4_keyschedule(struct rc4_state_t *state, const uint8_t *key, unsigned int keylen) {
	for (int i = 0; i < 256; i++) {
		state->S[i] = i;
	}

	int j = 0;
	for (int i = 0; i < 256; i++) {
		j = (j + state->S[i] + key[i % keylen]) & 0xff;
		swap(state->S + i, state->S + j);
	}

	state->i = 0;
	state->j = 0;
}

uint8_t rc4_next(struct rc4_state_t *state) {
	state->i++;
	state->j += state->S[state->i];
	swap(state->S + state->i, state->S + state->j);
	return state->S[(state->S[state->i] + state->S[state->j]) & 0xff];
}


int main(int argc, char **argv) {
	if (false) {
		uint8_t key[3] = { 'K', 'e', 'y' };
		struct rc4_state_t ctx;
		rc4_keyschedule(&ctx, key, 3);

		uint8_t expect[] = { 0xEB, 0x9F, 0x77, 0x81, 0xB7, 0x34, 0xCA, 0x72, 0xA7, 0x19 };
		for (int i = 0; i < sizeof(expect); i++) {
			uint8_t next = rc4_next(&ctx);
			printf("%02x %02x %s\n", next, expect[i], next == expect[i] ? "PASS" : "FAIL");
		}
		printf("\n");
	}

	if (argc != 2) {
		fprintf(stderr, "%s [schedule | stream]\n", argv[0]);
		return 1;
	}

	uint8_t key[5] = { 0x61, 0x8A, 0x63, 0xD2, 0xFB };
    struct rc4_state_t ctx;

	if (!strcmp(argv[1], "schedule")) {
		for (int i = 0; i < 10000000; i++) {
			rc4_keyschedule(&ctx, key, 5);
		}
	} else if (!strcmp(argv[1], "stream")) {
		rc4_keyschedule(&ctx, key, 5);
		for (int i = 0; i < 2000000000; i++) {
			rc4_next(&ctx);
		}
	} else {
		fprintf(stderr, "%s [schedule | stream]\n", argv[0]);
		return 1;
	}

	/* Return something it isn't optimized away */
	return ctx.S[0];
}

