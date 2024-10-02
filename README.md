# nanoid for c3 

based on https://github.com/ai/nanoid 

## Example

```c++
import nanoid, std::math::random;

fn void! main(String[] args) {
    io::printfn(nanoid::new(8)!);
    // vv_p-BNU

    io::printfn(nanoid::new_alphanumeric(11)!);
    // YRICKamvWl0

    // alpha
    io::printfn(nanoid::new_alpha(22)!);
    // xrFVXGBAqDADIFFSQwOPVr

    // numeric
    io::printfn(nanoid::new_numeric(22)!);
    // 8075112413450034103340

    // alpha with prefix
    io::printfn(nanoid::new_alpha(22, prefix: "prod_")!);
    // prod_TFNFPxYtDSLVZXSvsxLBzu

    // Custom alphabet with sufix
    io::printfn(nanoid::generate("customalpha123", 42, sufix: "_xxx")!);
    // oa132al3mattl2pau1sllaacoaalslhhattaaasllu_xxx

    // Custom random gen
    Mcg128Random mcg128; 
    random::seed_entropy(&mcg128);
    nanoid::set_rand(&mcg128);
    
    io::printfn(nanoid::generate("customalpha123", 42)!);
}
```