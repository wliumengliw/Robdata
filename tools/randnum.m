function randomNumbers = randnum(lowerBound, upperBound, n, type)
% generateRandomList(lowerBound, upperBound, n, type)
%   生成一个包含n个随机数的列表，这些随机数在给定的下限和上限之间。
%   默认生成整数，可选择生成指定小数位数的浮点数。
%
%   输入:
%       lowerBound: 随机数的下限 (标量)
%       upperBound: 随机数的上限 (标量)
%       n:          要生成的随机数的个数 (正整数)
%       type:       指定随机数类型的字符串 (可选):
%                   - 'integer' (或省略): 生成整数 (默认)
%                   - 'decimal': 生成浮点数
%                   - 'decimal,k': 生成小数点后k位的浮点数 (例如 'decimal,2')
%
%   输出:
%       randomNumbers: 包含n个随机数的行向量

  % 检查输入参数的有效性
  if ~isscalar(lowerBound) || ~isscalar(upperBound)
    error('上下限必须是标量。');
  end

  if lowerBound >= upperBound
    error('下限必须严格小于上限。');
  end

  if ~isscalar(n) || n <= 0 || floor(n) ~= n
    error('n必须是正整数。');
  end

  % 默认类型为整数
  if nargin < 4 || isempty(type) || strcmpi(type, 'integer')
    generateInteger = true;
    numDecimals = 0; % 用于后续处理，表示 0 位小数
  else
    generateInteger = false;
  end

  % 生成n个在0到1之间的均匀分布的随机数
  randomValues = rand(1, n);

  % 缩放到指定的范围 [lowerBound, upperBound]
  scaledValues = lowerBound + (upperBound - lowerBound) * randomValues;

  if generateInteger
    % 生成整数
    randomNumbers = round(scaledValues);
  else
    switch lower(type)
      case 'decimal'
        % 生成浮点数 (不进行额外处理)
        randomNumbers = scaledValues;
      otherwise
        % 尝试解析小数点位数
        parts = split(type, ',');
        if length(parts) == 2 && strcmpi(parts{1}, 'decimal')
          numDecimals = str2double(parts{2});
          if ~isnan(numDecimals) && numDecimals >= 0 && floor(numDecimals) == numDecimals
            factor = 10^numDecimals;
            randomNumbers = round(scaledValues * factor) / factor;
          else
            warning('指定的小数位数无效，将生成默认整数。');
            randomNumbers = round(scaledValues);
          end
        else
          warning('未知的随机数类型，将生成默认整数。');
          randomNumbers = round(scaledValues);
        end
    end
  end

end

