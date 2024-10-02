module nanoid;

import std::math::random;

const char[] ALPHANUMERIC_ALPHABET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
const char[] ALPHABET = "_-" +++ ALPHANUMERIC_ALPHABET;

const DEFAULT_SIZE = 21;

fault NanoError {
    ALPHABET_EMPTY,
    ALPHABET_GREATER_THAN_255,
    SIZE_NEGATIVE
}

Random rand @noinit;

fn void init() @init {
    rand = &&DefaultRandom{};
    random::seed_entropy(rand);
}

fn void set_rand(Random rnd) {
    if (rnd == null) {
        return;
    }
    rand = rnd;
}

fn String! new(int size = DEFAULT_SIZE, String prefix = "", String sufix = "") {
    if (size <= 0) {
        return NanoError.SIZE_NEGATIVE?;
    }
    
    char[] id = mem::new_array(char, size);
    char[] bytes = mem::temp_new_array(char, size);
    rand.next_bytes(bytes);

    for (int i; i < size; i++) {
        id[i] = ALPHABET[bytes[i] & 63];
    }
    
    int nidl = size + prefix.len + sufix.len;
    if (nidl == size){
        return (String)id;
    }

    char[] nid = ((char*)mem::realloc(id, nidl))[:nidl];

    nid[prefix.len:size] = id[..];

    if (prefix.len) {
        nid[0:prefix.len] = prefix[..];
    }

    if(sufix.len) {
        nid[prefix.len+size..] = sufix[..];
    }

    return (String)nid[:nidl];
}

fn String! generate(char[] alphabet, int size, String prefix = "", String sufix = "") {
    if (alphabet.len == 0) {
        return NanoError.ALPHABET_EMPTY?;
    }
    
    if (alphabet.len > 255) {
        return NanoError.ALPHABET_GREATER_THAN_255?;
    }

    if (size <= 0) {
        return NanoError.SIZE_NEGATIVE?;
    }

    int mask = (2 << (31 - ((int)((alphabet.len - 1) | 1)).clz())) - 1;

    double ceil_arg = 1.6 * (double)(mask * size) / (double)(alphabet.len);
    int step = (int)math::ceil(ceil_arg);

    char[] id = mem::new_array(char, size);
    char[] bytes = mem::temp_new_array(char, step);
    
    for LOOP: (int j=0;;) {
        rand.next_bytes(bytes);
        for (int i; i < step; i++) {
            char cbyte = bytes[i] & (char)mask;
            if (cbyte < alphabet.len) {
                id[j] = alphabet[cbyte];
                j++;
                if (j == size) {
                    break LOOP;
                }
            }
        }
    }

    int nidl = size + prefix.len + sufix.len;

    if (nidl == size){
        return (String)id[:size];
    }
    
    char[] nid = ((char*)mem::realloc(id, char.sizeof * nidl))[:nidl];
    
    nid[prefix.len:size] = id[..];

    if (prefix.len) {
        nid[0:prefix.len] = prefix[..];
    }

    if(sufix.len) {
        nid[prefix.len+size..] = sufix[..];
    }

    return (String) nid;
}

macro String! new_numeric(int size = DEFAULT_SIZE, String prefix = "", String sufix = "") {
    return generate(ALPHANUMERIC_ALPHABET[0:10], size, prefix, sufix);
}

macro String! new_alpha(int size = DEFAULT_SIZE, String prefix = "", String sufix = "") {
    return generate(ALPHANUMERIC_ALPHABET[26..], size, prefix, sufix);
}

macro String! new_alphanumeric(int size = DEFAULT_SIZE, String prefix = "", String sufix = "") {
    return generate(ALPHANUMERIC_ALPHABET, size, prefix, sufix);
}
