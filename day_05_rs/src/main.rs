#[derive(Debug)]
struct Program {
    mem: Vec<i32>,
    idx: usize,
    input_value: i32
}

impl From<&str> for Program  {
    fn from(st: &str) -> Program {
        let s = st.split(",");
        let mem = s.map(|s| {
            s.parse().unwrap()
        }).collect();

        let p = Program { 
            mem,
            idx: 0,
            input_value: 1
        };
        p
    }
}

impl Program {
    fn get_input(&self) -> i32 {
        self.input_value
    }

    fn get_val(&self, idx: i32, mode: i32) -> i32 {
        if idx as usize > self.mem.len() - 1 {
            println!("out of bounds\n");
            return 0
        }
        match mode {
            0 => { 
                self.mem[idx as usize]
            },
            _ => {
                idx
            }
        }
    }
    fn step(&mut self) -> Option<i32> {
        println!("{:?}", &self.mem[0..10]);
        let opt_meta = self.mem[self.idx];

        let opt = opt_meta % 100; // first two digits
        println!("{}, {}, {}", opt, opt_meta, self.idx);

        let param_mode_a = ((opt_meta / 100) % 10) as i32;
        let param_mode_b = ((opt_meta / 1000) % 10) as i32;
        let param_mode_c = ((opt_meta / 10000) % 10) as i32;

        let a = self.get_val((self.idx + 1) as i32, param_mode_a);
        let b = self.get_val((self.idx + 2) as i32, param_mode_b);
        let c = self.get_val((self.idx + 3) as i32, param_mode_c);
        match opt {
            1 => { // add
                self.mem[c as usize] = self.mem[a as usize] + self.mem[b as usize];
                println!("add {}:{} + {}:{} -> {}", self.mem[a as usize], param_mode_a, self.mem[b as usize], param_mode_b,c);
                self.idx += 4;
            },
            2 => { // mult
                self.mem[c as usize] = self.mem[a as usize] * self.mem[b as usize];
                println!("mul {}:{} * {}:{} -> {}", a, param_mode_a, b, param_mode_b, c);
                self.idx += 4;
            },
            3 => { // get input 
                self.mem[a as usize] = self.get_input();
                println!("get -> {}", c);
                self.idx += 2;
            },
            4 => { // output
                self.idx += 2;
                println!("returning: {}", self.mem[a as usize]);
                return Some(self.mem[a as usize]);
            },
            5 => { // jump ne
                if self.mem[a as usize] != 0 {
                    self.idx = self.mem[b as usize] as usize;
                } else {
                    self.idx += 3;
                }
            },
            6 => { // jump eq
                if self.mem[a as usize] == 0 {
                    self.idx = self.mem[b as usize] as usize;
                } else {
                    self.idx += 3;
                }
            },
            7 => { // < 
                let c = self.get_val(self.idx as i32 + 3, 1);
                self.mem[c as usize] = if self.mem[a as usize] < self.mem[b as usize] {
                    1
                } else {
                    0
                };
                self.idx += 4;
            },
            8 => { // == 
                let c = self.get_val(self.idx as i32 + 3, 1);
                self.mem[c as usize] = if self.mem[a as usize] == self.mem[b as usize] {
                    1
                } else {
                    0
                };
                self.idx += 4;
            },
            99 => {
                panic!("Halt");
            }
            _ => panic!("bad opt {}", opt)
        };
        None
    }

    fn run(&mut self) -> i32 {
        loop {
            match self.step() {
                Some(val) => {
                    if val == 0 {
                        continue;
                    } else {
                        return val
                    }
                }
                None => continue
            }
        }
        0
    }
}

fn main() {
    let st: String = std::fs::read_to_string("./input.txt").unwrap();
    let mut p = Program::from(st.as_ref());
    // println!("program : {:#?}", p);
    let part_1 = p.run();
    assert_eq!(part_1, 9961446);
    println!("program output: {:#?}", part_1);

    let sample = std::fs::read_to_string("./input.txt").unwrap();
    let mut p2 = Program::from(sample.as_ref());
    // let mut p2 = Program::from("3,9,8,9,10,9,4,9,99,-1,8");
    p2.input_value = 5;
    let part_2 = p2.run();
    println!("program output: {:#?}", part_2);

}
