function normalized = normalize(x)
  if ~isvector(x)
      error('Input must be a vector')
  end
  normalized = x./sqrt(sum(x.^2));
  normalized(!isfinite(normalized))=0;
end

weights = normalize(exprnd(1,2*4,1))';
examples = [
normalize(
  [ 0, 0, \
    0, 0 ]);
normalize(
  [ 0, 0, \
    1,-1 ]);
normalize(
  [ 0, 0, \
    0,-1 ]);
normalize(
  [ 0, 0, \
    0, 1 ]);
];
answers = [
  1;
  1;
  2;
  2;
];

for iteration = 1:1000
  for example_index = 1:size(examples)
    example = examples(example_index, :);
    from = 1+(answers(example_index)-1)*4;
    to = answers(example_index)*4;
    winner_weights = weights(from:to);
    weights(from:to) = weights(from:to) + (example-winner_weights);
    weights = normalize(weights);
  endfor
endfor

for example_index = 1:size(examples)
  input_signal = weights.*[examples(example_index,:),examples(example_index,:)];
  neurons_outputs = [sum(input_signal(1:4)), sum(input_signal(5:8))];
  [value, index] =  max(neurons_outputs);
  printf("Expected: %d%% Actual: %d%%\n", answers(example_index), index);
endfor
