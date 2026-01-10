part of 'index.dart';

// Logo 映射表 (保持静态，提升性能)
const Map<String, String> _logoMap = {
  'google': 'google-color',
  'deepseek-ai': 'deepseek-color',
  'qwen': 'qwen-color',
  'openai': 'openai',
  'z-ai': 'zhipu-color',
  '01-ai': 'zeroone',
  'baichuan-inc': 'Baichuan-color',
  'mistralai': 'Mistral-color',
  'moonshotai': 'Moonshot',
  'bytedance': 'ByteDance-color',
  'microsoft': 'microsoft-color',
  'nvidia': 'nvidia-color',
  'meta': 'meta-color',
  'minimaxai': 'minimax-color',
  'ibm': 'ibm',
  'baai': 'baai',
  'ai21labs': 'ai21',
};
String? getLogoUriOfProvider(String provider, {String iconThemeStr = 'light'}) {
  final logoName = _logoMap[provider];
  if (logoName == null) {
    return null;
  }
  return 'https://registry.npmmirror.com/@lobehub/icons-static-webp/latest/files/$iconThemeStr/$logoName.webp';
}
