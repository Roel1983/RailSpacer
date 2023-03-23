module round_off(r) {
    offset(r=r)offset(-r) children();
}

module mirror_copy(vec = undef) {
    children();
    mirror(vec) children();
}

module distribute(vec, length, distance) {
    count       = floor(length / distance) + 1;
    start_index = -count / 2 + 1;
    end_index   =  count / 2 - 1;
   
    for(index = [start_index:1:end_index]) {
        a = index * distance;
        translate(vec * a) {
            children();
        }
    }
}