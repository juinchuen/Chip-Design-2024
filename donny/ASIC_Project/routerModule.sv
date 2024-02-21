module Router(
  input wire stage, //stage 1 - 6
  input wire [15:0] inRe0,
  input wire [15:0] inIm0,
  output wire [15:0] outRe0,
  output wire [15:0] outIm0,
  input wire [15:0] inRe1,
  input wire [15:0] inIm1,
  output wire [15:0] outRe1,
  output wire [15:0] outIm1,
  input wire [15:0] inRe2,
  input wire [15:0] inIm2,
  output wire [15:0] outRe2,
  output wire [15:0] outIm2,
  input wire [15:0] inRe3,
  input wire [15:0] inIm3,
  output wire [15:0] outRe3,
  output wire [15:0] outIm3,
  input wire [15:0] inRe4,
  input wire [15:0] inIm4,
  output wire [15:0] outRe4,
  output wire [15:0] outIm4,
  input wire [15:0] inRe5,
  input wire [15:0] inIm5,
  output wire [15:0] outRe5,
  output wire [15:0] outIm5,
  input wire [15:0] inRe6,
  input wire [15:0] inIm6,
  output wire [15:0] outRe6,
  output wire [15:0] outIm6,
  input wire [15:0] inRe7,
  input wire [15:0] inIm7,
  output wire [15:0] outRe7,
  output wire [15:0] outIm7,
  input wire [15:0] inRe8,
  input wire [15:0] inIm8,
  output wire [15:0] outRe8,
  output wire [15:0] outIm8,
  input wire [15:0] inRe9,
  input wire [15:0] inIm9,
  output wire [15:0] outRe9,
  output wire [15:0] outIm9,
  input wire [15:0] inRe10,
  input wire [15:0] inIm10,
  output wire [15:0] outRe10,
  output wire [15:0] outIm10,
  input wire [15:0] inRe11,
  input wire [15:0] inIm11,
  output wire [15:0] outRe11,
  output wire [15:0] outIm11,
  input wire [15:0] inRe12,
  input wire [15:0] inIm12,
  output wire [15:0] outRe12,
  output wire [15:0] outIm12,
  input wire [15:0] inRe13,
  input wire [15:0] inIm13,
  output wire [15:0] outRe13,
  output wire [15:0] outIm13,
  input wire [15:0] inRe14,
  input wire [15:0] inIm14,
  output wire [15:0] outRe14,
  output wire [15:0] outIm14,
  input wire [15:0] inRe15,
  input wire [15:0] inIm15,
  output wire [15:0] outRe15,
  output wire [15:0] outIm15,
  input wire [15:0] inRe16,
  input wire [15:0] inIm16,
  output wire [15:0] outRe16,
  output wire [15:0] outIm16,
  input wire [15:0] inRe17,
  input wire [15:0] inIm17,
  output wire [15:0] outRe17,
  output wire [15:0] outIm17,
  input wire [15:0] inRe18,
  input wire [15:0] inIm18,
  output wire [15:0] outRe18,
  output wire [15:0] outIm18,
  input wire [15:0] inRe19,
  input wire [15:0] inIm19,
  output wire [15:0] outRe19,
  output wire [15:0] outIm19,
  input wire [15:0] inRe20,
  input wire [15:0] inIm20,
  output wire [15:0] outRe20,
  output wire [15:0] outIm20,
  input wire [15:0] inRe21,
  input wire [15:0] inIm21,
  output wire [15:0] outRe21,
  output wire [15:0] outIm21,
  input wire [15:0] inRe22,
  input wire [15:0] inIm22,
  output wire [15:0] outRe22,
  output wire [15:0] outIm22,
  input wire [15:0] inRe23,
  input wire [15:0] inIm23,
  output wire [15:0] outRe23,
  output wire [15:0] outIm23,
  input wire [15:0] inRe24,
  input wire [15:0] inIm24,
  output wire [15:0] outRe24,
  output wire [15:0] outIm24,
  input wire [15:0] inRe25,
  input wire [15:0] inIm25,
  output wire [15:0] outRe25,
  output wire [15:0] outIm25,
  input wire [15:0] inRe26,
  input wire [15:0] inIm26,
  output wire [15:0] outRe26,
  output wire [15:0] outIm26,
  input wire [15:0] inRe27,
  input wire [15:0] inIm27,
  output wire [15:0] outRe27,
  output wire [15:0] outIm27,
  input wire [15:0] inRe28,
  input wire [15:0] inIm28,
  output wire [15:0] outRe28,
  output wire [15:0] outIm28,
  input wire [15:0] inRe29,
  input wire [15:0] inIm29,
  output wire [15:0] outRe29,
  output wire [15:0] outIm29,
  input wire [15:0] inRe30,
  input wire [15:0] inIm30,
  output wire [15:0] outRe30,
  output wire [15:0] outIm30,
  input wire [15:0] inRe31,
  input wire [15:0] inIm31,
  output wire [15:0] outRe31,
  output wire [15:0] outIm31,
  input wire [15:0] inRe32,
  input wire [15:0] inIm32,
  output wire [15:0] outRe32,
  output wire [15:0] outIm32,
  input wire [15:0] inRe33,
  input wire [15:0] inIm33,
  output wire [15:0] outRe33,
  output wire [15:0] outIm33,
  input wire [15:0] inRe34,
  input wire [15:0] inIm34,
  output wire [15:0] outRe34,
  output wire [15:0] outIm34,
  input wire [15:0] inRe35,
  input wire [15:0] inIm35,
  output wire [15:0] outRe35,
  output wire [15:0] outIm35,
  input wire [15:0] inRe36,
  input wire [15:0] inIm36,
  output wire [15:0] outRe36,
  output wire [15:0] outIm36,
  input wire [15:0] inRe37,
  input wire [15:0] inIm37,
  output wire [15:0] outRe37,
  output wire [15:0] outIm37,
  input wire [15:0] inRe38,
  input wire [15:0] inIm38,
  output wire [15:0] outRe38,
  output wire [15:0] outIm38,
  input wire [15:0] inRe39,
  input wire [15:0] inIm39,
  output wire [15:0] outRe39,
  output wire [15:0] outIm39,
  input wire [15:0] inRe40,
  input wire [15:0] inIm40,
  output wire [15:0] outRe40,
  output wire [15:0] outIm40,
  input wire [15:0] inRe41,
  input wire [15:0] inIm41,
  output wire [15:0] outRe41,
  output wire [15:0] outIm41,
  input wire [15:0] inRe42,
  input wire [15:0] inIm42,
  output wire [15:0] outRe42,
  output wire [15:0] outIm42,
  input wire [15:0] inRe43,
  input wire [15:0] inIm43,
  output wire [15:0] outRe43,
  output wire [15:0] outIm43,
  input wire [15:0] inRe44,
  input wire [15:0] inIm44,
  output wire [15:0] outRe44,
  output wire [15:0] outIm44,
  input wire [15:0] inRe45,
  input wire [15:0] inIm45,
  output wire [15:0] outRe45,
  output wire [15:0] outIm45,
  input wire [15:0] inRe46,
  input wire [15:0] inIm46,
  output wire [15:0] outRe46,
  output wire [15:0] outIm46,
  input wire [15:0] inRe47,
  input wire [15:0] inIm47,
  output wire [15:0] outRe47,
  output wire [15:0] outIm47,
  input wire [15:0] inRe48,
  input wire [15:0] inIm48,
  output wire [15:0] outRe48,
  output wire [15:0] outIm48,
  input wire [15:0] inRe49,
  input wire [15:0] inIm49,
  output wire [15:0] outRe49,
  output wire [15:0] outIm49,
  input wire [15:0] inRe50,
  input wire [15:0] inIm50,
  output wire [15:0] outRe50,
  output wire [15:0] outIm50,
  input wire [15:0] inRe51,
  input wire [15:0] inIm51,
  output wire [15:0] outRe51,
  output wire [15:0] outIm51,
  input wire [15:0] inRe52,
  input wire [15:0] inIm52,
  output wire [15:0] outRe52,
  output wire [15:0] outIm52,
  input wire [15:0] inRe53,
  input wire [15:0] inIm53,
  output wire [15:0] outRe53,
  output wire [15:0] outIm53,
  input wire [15:0] inRe54,
  input wire [15:0] inIm54,
  output wire [15:0] outRe54,
  output wire [15:0] outIm54,
  input wire [15:0] inRe55,
  input wire [15:0] inIm55,
  output wire [15:0] outRe55,
  output wire [15:0] outIm55,
  input wire [15:0] inRe56,
  input wire [15:0] inIm56,
  output wire [15:0] outRe56,
  output wire [15:0] outIm56,
  input wire [15:0] inRe57,
  input wire [15:0] inIm57,
  output wire [15:0] outRe57,
  output wire [15:0] outIm57,
  input wire [15:0] inRe58,
  input wire [15:0] inIm58,
  output wire [15:0] outRe58,
  output wire [15:0] outIm58,
  input wire [15:0] inRe59,
  input wire [15:0] inIm59,
  output wire [15:0] outRe59,
  output wire [15:0] outIm59,
  input wire [15:0] inRe60,
  input wire [15:0] inIm60,
  output wire [15:0] outRe60,
  output wire [15:0] outIm60,
  input wire [15:0] inRe61,
  input wire [15:0] inIm61,
  output wire [15:0] outRe61,
  output wire [15:0] outIm61,
  input wire [15:0] inRe62,
  input wire [15:0] inIm62,
  output wire [15:0] outRe62,
  output wire [15:0] outIm62,
  input wire [15:0] inRe63,
  input wire [15:0] inIm63,
  output wire [15:0] outRe63,
  output wire [15:0] outIm63
);

always @(stage) begin
  if (stage == 1) begin
    out1 = in0;
    out0 = in1;
    out3 = in2;
    out2 = in3;
    out5 = in4;
    out4 = in5;
    out7 = in6;
    out6 = in7;
    out9 = in8;
    out8 = in9;
    out11 = in10;
    out10 = in11;
    out13 = in12;
    out12 = in13;
    out15 = in14;
    out14 = in15;
    out17 = in16;
    out16 = in17;
    out19 = in18;
    out18 = in19;
    out21 = in20;
    out20 = in21;
    out23 = in22;
    out22 = in23;
    out25 = in24;
    out24 = in25;
    out27 = in26;
    out26 = in27;
    out29 = in28;
    out28 = in29;
    out31 = in30;
    out30 = in31;
    out33 = in32;
    out32 = in33;
    out35 = in34;
    out34 = in35;
    out37 = in36;
    out36 = in37;
    out39 = in38;
    out38 = in39;
    out41 = in40;
    out40 = in41;
    out43 = in42;
    out42 = in43;
    out45 = in44;
    out44 = in45;
    out47 = in46;
    out46 = in47;
    out49 = in48;
    out48 = in49;
    out51 = in50;
    out50 = in51;
    out53 = in52;
    out52 = in53;
    out55 = in54;
    out54 = in55;
    out57 = in56;
    out56 = in57;
    out59 = in58;
    out58 = in59;
    out61 = in60;
    out60 = in61;
    out63 = in62;
    out62 = in63;
  end else if (stage == 2) begin
    out2 = in0;
    out3 = in1;
    out0 = in2;
    out1 = in3;
    out6 = in4;
    out7 = in5;
    out4 = in6;
    out5 = in7;
    out10 = in8;
    out11 = in9;
    out8 = in10;
    out9 = in11;
    out14 = in12;
    out15 = in13;
    out12 = in14;
    out13 = in15;
    out18 = in16;
    out19 = in17;
    out16 = in18;
    out17 = in19;
    out22 = in20;
    out23 = in21;
    out20 = in22;
    out21 = in23;
    out26 = in24;
    out27 = in25;
    out24 = in26;
    out25 = in27;
    out30 = in28;
    out31 = in29;
    out28 = in30;
    out29 = in31;
    out34 = in32;
    out35 = in33;
    out32 = in34;
    out33 = in35;
    out38 = in36;
    out39 = in37;
    out36 = in38;
    out37 = in39;
    out42 = in40;
    out43 = in41;
    out40 = in42;
    out41 = in43;
    out46 = in44;
    out47 = in45;
    out44 = in46;
    out45 = in47;
    out50 = in48;
    out51 = in49;
    out48 = in50;
    out49 = in51;
    out54 = in52;
    out55 = in53;
    out52 = in54;
    out53 = in55;
    out58 = in56;
    out59 = in57;
    out56 = in58;
    out57 = in59;
    out62 = in60;
    out63 = in61;
    out60 = in62;
    out61 = in63;
  end else if (stage == 3) begin
    out4 = in0;
    out5 = in1;
    out6 = in2;
    out7 = in3;
    out0 = in4;
    out1 = in5;
    out2 = in6;
    out3 = in7;
    out12 = in8;
    out13 = in9;
    out14 = in10;
    out15 = in11;
    out8 = in12;
    out9 = in13;
    out10 = in14;
    out11 = in15;
    out20 = in16;
    out21 = in17;
    out22 = in18;
    out23 = in19;
    out16 = in20;
    out17 = in21;
    out18 = in22;
    out19 = in23;
    out28 = in24;
    out29 = in25;
    out30 = in26;
    out31 = in27;
    out24 = in28;
    out25 = in29;
    out26 = in30;
    out27 = in31;
    out36 = in32;
    out37 = in33;
    out38 = in34;
    out39 = in35;
    out32 = in36;
    out33 = in37;
    out34 = in38;
    out35 = in39;
    out44 = in40;
    out45 = in41;
    out46 = in42;
    out47 = in43;
    out40 = in44;
    out41 = in45;
    out42 = in46;
    out43 = in47;
    out52 = in48;
    out53 = in49;
    out54 = in50;
    out55 = in51;
    out48 = in52;
    out49 = in53;
    out50 = in54;
    out51 = in55;
    out60 = in56;
    out61 = in57;
    out62 = in58;
    out63 = in59;
    out56 = in60;
    out57 = in61;
    out58 = in62;
    out59 = in63;
  end else if (stage == 4) begin
    out8 = in0;
    out9 = in1;
    out10 = in2;
    out11 = in3;
    out12 = in4;
    out13 = in5;
    out14 = in6;
    out15 = in7;
    out0 = in8;
    out1 = in9;
    out2 = in10;
    out3 = in11;
    out4 = in12;
    out5 = in13;
    out6 = in14;
    out7 = in15;
    out24 = in16;
    out25 = in17;
    out26 = in18;
    out27 = in19;
    out28 = in20;
    out29 = in21;
    out30 = in22;
    out31 = in23;
    out16 = in24;
    out17 = in25;
    out18 = in26;
    out19 = in27;
    out20 = in28;
    out21 = in29;
    out22 = in30;
    out23 = in31;
    out40 = in32;
    out41 = in33;
    out42 = in34;
    out43 = in35;
    out44 = in36;
    out45 = in37;
    out46 = in38;
    out47 = in39;
    out32 = in40;
    out33 = in41;
    out34 = in42;
    out35 = in43;
    out36 = in44;
    out37 = in45;
    out38 = in46;
    out39 = in47;
    out56 = in48;
    out57 = in49;
    out58 = in50;
    out59 = in51;
    out60 = in52;
    out61 = in53;
    out62 = in54;
    out63 = in55;
    out48 = in56;
    out49 = in57;
    out50 = in58;
    out51 = in59;
    out52 = in60;
    out53 = in61;
    out54 = in62;
    out55 = in63;
  end else if (stage == 5) begin
    out16 = in0;
    out17 = in1;
    out18 = in2;
    out19 = in3;
    out20 = in4;
    out21 = in5;
    out22 = in6;
    out23 = in7;
    out24 = in8;
    out25 = in9;
    out26 = in10;
    out27 = in11;
    out28 = in12;
    out29 = in13;
    out30 = in14;
    out31 = in15;
    out0 = in16;
    out1 = in17;
    out2 = in18;
    out3 = in19;
    out4 = in20;
    out5 = in21;
    out6 = in22;
    out7 = in23;
    out8 = in24;
    out9 = in25;
    out10 = in26;
    out11 = in27;
    out12 = in28;
    out13 = in29;
    out14 = in30;
    out15 = in31;
    out48 = in32;
    out49 = in33;
    out50 = in34;
    out51 = in35;
    out52 = in36;
    out53 = in37;
    out54 = in38;
    out55 = in39;
    out56 = in40;
    out57 = in41;
    out58 = in42;
    out59 = in43;
    out60 = in44;
    out61 = in45;
    out62 = in46;
    out63 = in47;
    out32 = in48;
    out33 = in49;
    out34 = in50;
    out35 = in51;
    out36 = in52;
    out37 = in53;
    out38 = in54;
    out39 = in55;
    out40 = in56;
    out41 = in57;
    out42 = in58;
    out43 = in59;
    out44 = in60;
    out45 = in61;
    out46 = in62;
    out47 = in63;
  end else if (stage == 6) begin
    out32 = in0;
    out33 = in1;
    out34 = in2;
    out35 = in3;
    out36 = in4;
    out37 = in5;
    out38 = in6;
    out39 = in7;
    out40 = in8;
    out41 = in9;
    out42 = in10;
    out43 = in11;
    out44 = in12;
    out45 = in13;
    out46 = in14;
    out47 = in15;
    out48 = in16;
    out49 = in17;
    out50 = in18;
    out51 = in19;
    out52 = in20;
    out53 = in21;
    out54 = in22;
    out55 = in23;
    out56 = in24;
    out57 = in25;
    out58 = in26;
    out59 = in27;
    out60 = in28;
    out61 = in29;
    out62 = in30;
    out63 = in31;
    out0 = in32;
    out1 = in33;
    out2 = in34;
    out3 = in35;
    out4 = in36;
    out5 = in37;
    out6 = in38;
    out7 = in39;
    out8 = in40;
    out9 = in41;
    out10 = in42;
    out11 = in43;
    out12 = in44;
    out13 = in45;
    out14 = in46;
    out15 = in47;
    out16 = in48;
    out17 = in49;
    out18 = in50;
    out19 = in51;
    out20 = in52;
    out21 = in53;
    out22 = in54;
    out23 = in55;
    out24 = in56;
    out25 = in57;
    out26 = in58;
    out27 = in59;
    out28 = in60;
    out29 = in61;
    out30 = in62;
    out31 = in63;
  end 
end

endmodule