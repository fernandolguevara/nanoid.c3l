module nanoid::test @test;

import nanoid, std::math::random;

fn void! default_length() {
    String nid = nanoid::new()!;

    assert(nid.len == nanoid::DEFAULT_SIZE);
}

fn void! length() {
    String nid = nanoid::new(12)!;

    assert(nid.len == 12);
}

fn void! alphanumeric() {
    for(int i = 0; i < 2000; i++){
        String nid = nanoid::new_alphanumeric(12)!;
        
        anyfault err = @catch(nid.index_of("_"));

        assert(err == SearchResult.MISSING);

        err = @catch(nid.index_of("-"));

        assert(err == SearchResult.MISSING);
    }
}

fn void! custom_long_id() {
    for(int i = 0; i < 2000; i++){
        String nid = nanoid::generate("0123456789abcdefghijklmnopqrstuvwxyz", 60, prefix: "xxx_", sufix: "_yyyyy")!;
        
        assert(nid.len == 70);
    }
}

fn void! custom_chars() {
    for(int i = 0; i < 2000; i++){
        String nid = nanoid::generate("abcdef", 12)!;
        
        anyfault err = @catch(nid.index_of("x"));

        assert(err == SearchResult.MISSING);
    }
}

fn void! empty_alphabet() {
    anyfault err = @catch(nanoid::generate("", 12));
    assert(err == NanoError.ALPHABET_EMPTY);
}

fn void! long_alphabet() {
    char[] alphabeth = "fpcao7roltou3feeq7eul0bv0jka9djywidfvvnptxka6w55yca4na5y2ssblebtahzgwxyn5urlsd6ikbn17nfz5nab20p5o9no3rv2zn9aa7dlizdt6t0xa02kzjzfmuf2valddz9ji8ccfee56fl45solqvilxn0g6b8algt2gfvxie2yfk3srod4nfe20t43vkba5ysk4bn15a0s5jdf9ga47o6ndttt17h2kfryeiqnoh9j8ridmqw3wui5";
    anyfault err = @catch(nanoid::generate(alphabeth, 12));
    assert(err == NanoError.ALPHABET_GREATER_THAN_255);
}

fn void! negative_size() {
    char[] alphabeth = "_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

    anyfault err = @catch(nanoid::generate(alphabeth, -1));
    assert(err == NanoError.SIZE_NEGATIVE);
}

fn void! custom_random_generator() {
    Mcg128Random mcg128; 
    random::seed_entropy(&mcg128);
    nanoid::set_rand(&mcg128);

    for(int i = 0; i < 2000; i++){
        String nid = nanoid::generate("0123456789abcdefghijklmnopqrstuvwxyz", 60, prefix: "xxx_", sufix: "_yyyyy")!;
        
        assert(nid.len == 70);
    }
}