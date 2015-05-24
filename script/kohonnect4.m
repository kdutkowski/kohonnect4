function normalized = normalize(x)
  if ~isvector(x)
      error('Input must be a vector')
  end
  normalized = x./sqrt(sum(x.^2));
  normalized(!isfinite(normalized))=0;
end

WIDTH = 7;
HEIGHT = 6;
INPUTS = WIDTH*HEIGHT;
RATE = 0.01;

weights = normalize(exprnd(1,WIDTH*INPUTS,1))';

data = csvread(argv(){1});
examples = data(:, 1:INPUTS);
answers = data(:, INPUTS+1);

for iteration = 1:100
  for example_index = 1:size(examples)
    example = examples(example_index, :);
    from = 1+(answers(example_index))*INPUTS;
    to = (answers(example_index)+1)*INPUTS;
    winner_weights = weights(from:to);
    weights(from:to) = weights(from:to) + RATE*(example-winner_weights);
    %weights = normalize(weights); %Should we normalize all weights or only updated ones
    weights(from:to) = normalize(weights(from:to));
  endfor
endfor

actuals = answers;
for example_index = 1:size(examples)
  input = [];
  for neuron_index = 1:WIDTH
    input = [input examples(example_index,:)];
  endfor
  input_signal = weights.*input;
  output_index = 1:INPUTS: length(weights);
  neurons_outputs = zeros(WIDTH, 1);
  for output = 2:WIDTH
    neurons_outputs(output-1) = [sum(input_signal(output_index(output-1):output_index(output)))];
  endfor
  [value, index] =  max(neurons_outputs);
  actuals(example_index) = index-1;
endfor
score = sum((actuals-answers) == 0) / length(answers)
