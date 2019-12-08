#[derive(Debug)]
struct Program {
    mem: Vec<i32>,
    idx: usize
}

impl From<&str> for Program  {
    fn from(st: &str) -> Program {
        let s = st.split(",");
        let mem = s.map(|s| {
            s.parse().unwrap()
        }).collect();

        let p = Program { 
            mem,
            idx: 0
        };
        p
    }
}

impl Program {
    fn get_input() -> i32 {
        1
    }

    fn get_val(&self, idx: i32, mode: i32) -> i32 {
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
        let opt_meta = self.mem[self.idx];

        let opt = opt_meta % 100; // first two digits

        let param_mode_a = ((opt_meta / 100) % 10) as i32;
        let param_mode_b = ((opt_meta / 1000) % 10) as i32;
        let param_mode_c = ((opt_meta / 10000) % 10) as i32;

        let a = self.get_val((self.idx + 1) as i32, param_mode_a);
        let b = self.get_val((self.idx + 2) as i32, param_mode_b);
        let c = self.get_val((self.idx + 3) as i32, param_mode_c);
        match opt {
            1 => {
                self.mem[c as usize] = self.mem[a as usize] + self.mem[b as usize];
                self.idx += 4;
            },
            2 => {
                self.mem[c as usize] = self.mem[a as usize] * self.mem[b as usize];
                self.idx += 4;
            },
            3 => {
                self.mem[a as usize] = Self::get_input();
                self.idx += 2;
            },
            4 => { 
                self.idx += 2;
                return Some(self.mem[a as usize]);
            },
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
    println!("program : {:#?}", p);
    let part_1 = p.run();
    assert_eq!(part_1, 9961446);
    println!("program output: {:#?}", part_1);
}
