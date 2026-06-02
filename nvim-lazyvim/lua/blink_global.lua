-- blink.cmp 源:用 GNU GLOBAL 的 `global -c <前缀>` 做项目级符号补全。
-- 读 cache 里的 GTAGS(由 tags.lua 设的 b:gtags_root / b:gtags_dbpath 定位),
-- 随 global -u 增量即时刷新;无库时返回空(由 buffer/片段/路径源兜底)。
local M = {}
M.__index = M

function M.new()
  return setmetatable({}, M)
end

-- 标识符前缀才触发
function M:get_trigger_characters()
  return {}
end

function M:get_completions(ctx, callback)
  local before = ctx.line:sub(1, ctx.cursor[2])
  local prefix = before:match("[%w_]+$") or ""

  local empty = { is_incomplete_forward = false, is_incomplete_backward = false, items = {} }
  if #prefix < 2 then
    callback(empty)
    return
  end

  local root = vim.b.gtags_root
  local dbpath = vim.b.gtags_dbpath
  if not (root and dbpath) then
    callback(empty)
    return
  end

  local KIND = vim.lsp.protocol.CompletionItemKind.Function
  vim.system(
    { "global", "-c", prefix },
    { cwd = root, env = { GTAGSROOT = root, GTAGSDBPATH = dbpath }, text = true },
    function(res)
      local items = {}
      if res.code == 0 and res.stdout then
        for name in res.stdout:gmatch("[^\r\n]+") do
          items[#items + 1] = { label = name, kind = KIND }
        end
      end
      vim.schedule(function()
        callback({ is_incomplete_forward = true, is_incomplete_backward = true, items = items })
      end)
    end
  )
end

return M
