import { useState, useEffect, useCallback } from "react";

const QUOTES = [
  { id: 1, text: "I used to be an adventurer like you, then I took an arrow in the knee.", npc: "Whiterun Guard", race: "Nord", location: "Whiterun", hold: "Whiterun Hold", category: "Guard", quest: null, unlocked: true },
  { id: 2, text: "Do you get to the Cloud District very often? Oh, what am I saying, of course you don't.", npc: "Nazeem", race: "Redguard", location: "Whiterun", hold: "Whiterun Hold", category: "Citizen", quest: null, unlocked: true },
  { id: 3, text: "Let me guess... someone stole your sweetroll.", npc: "Whiterun Guard", race: "Nord", location: "Whiterun", hold: "Whiterun Hold", category: "Guard", quest: null, unlocked: true },
  { id: 4, text: "Skyrim belongs to the Nords!", npc: "Stormcloak Soldier", race: "Nord", location: "Various", hold: "Various", category: "Guard", quest: "Civil War", unlocked: true },
  { id: 5, text: "I am sworn to carry your burdens.", npc: "Lydia", race: "Nord", location: "Dragonsreach", hold: "Whiterun Hold", category: "Companion", quest: "Dragon Rising", unlocked: true },
  { id: 6, text: "You have committed crimes against Skyrim and her people. What say you in your defense?", npc: "Hold Guard", race: "Nord", location: "Various", hold: "Various", category: "Guard", quest: null, unlocked: true },
  { id: 7, text: "Fus Ro Dah!", npc: "Dragonborn", race: "Various", location: "Various", hold: "Various", category: "Dragon", quest: "Main Quest", unlocked: true },
  { id: 8, text: "A new hand touches the Beacon!", npc: "Meridia", race: "Daedric Prince", location: "Mount Kilkreath", hold: "Haafingar", category: "Daedric", quest: "The Break of Dawn", unlocked: true },
  { id: 9, text: "I mostly deal with petty thievery and drunken brawls. Been too long since we've had a good bandit raid.", npc: "Whiterun Guard", race: "Nord", location: "Whiterun", hold: "Whiterun Hold", category: "Guard", quest: null, unlocked: true },
  { id: 10, text: "What is better — to be born good, or to overcome your evil nature through great effort?", npc: "Paarthurnax", race: "Dragon", location: "Throat of the World", hold: "Whiterun Hold", category: "Dragon", quest: "Main Quest", unlocked: true },
  { id: 11, text: "My favorite drinking buddy! Let's get some mead.", npc: "Sam Guevenne", race: "Breton", location: "Various Taverns", hold: "Various", category: "Daedric", quest: "A Night to Remember", unlocked: false },
  { id: 12, text: "By the order of the Jarl, stop right there!", npc: "Hold Guard", race: "Nord", location: "Various", hold: "Various", category: "Guard", quest: null, unlocked: false },
];

const CATEGORIES = ["All", "Guard", "Companion", "Daedric", "Dragon", "Citizen"];

const THEMES = {
  whiterun: { name: "Whiterun Warm", bg: "#1a1408", card: "#2a2010", accent: "#c9a84c", text: "#e8dcc4", subtle: "#8a7a5a", glow: "rgba(201,168,76,0.15)" },
  winterhold: { name: "Winterhold Frost", bg: "#0a0f1a", card: "#121c2e", accent: "#6aafd6", text: "#c4dce8", subtle: "#5a7a8a", glow: "rgba(106,175,214,0.15)" },
  solstheim: { name: "Solstheim Dark", bg: "#0d0808", card: "#1e1212", accent: "#c45a4a", text: "#e0c8c4", subtle: "#8a5a5a", glow: "rgba(196,90,74,0.15)" },
  sovngarde: { name: "Sovngarde Gold", bg: "#12100a", card: "#221e12", accent: "#e8b830", text: "#f0e8d0", subtle: "#9a8a5a", glow: "rgba(232,184,48,0.15)" },
};

const RACE_ICONS = { Nord: "⚔️", Redguard: "🗡️", Dragon: "🐉", "Daedric Prince": "👁️", Breton: "🧙", Various: "🛡️" };

const PhoneFrame = ({ children, theme }) => (
  <div style={{
    width: 300, height: 620, borderRadius: 44, background: "#000",
    border: "3px solid #333", position: "relative", overflow: "hidden",
    boxShadow: `0 24px 80px rgba(0,0,0,0.6), 0 0 60px ${theme.glow}`,
    display: "flex", flexDirection: "column",
  }}>
    <div style={{ position: "absolute", top: 10, left: "50%", transform: "translateX(-50%)", width: 90, height: 24, borderRadius: 12, background: "#111", zIndex: 50 }} />
    <div style={{ flex: 1, overflow: "hidden", background: theme.bg }}>{children}</div>
    <div style={{ height: 4, width: 120, borderRadius: 2, background: "#444", margin: "6px auto 8px", flexShrink: 0 }} />
  </div>
);

const WidgetSmall = ({ quote, theme, onClick }) => (
  <div onClick={onClick} style={{
    background: `linear-gradient(135deg, ${theme.card}, ${theme.bg})`,
    borderRadius: 20, padding: 16, width: 140, height: 140,
    display: "flex", flexDirection: "column", justifyContent: "space-between",
    border: `1px solid ${theme.accent}22`, cursor: "pointer",
    boxShadow: `inset 0 1px 0 ${theme.accent}15, 0 4px 20px rgba(0,0,0,0.3)`,
    transition: "transform 0.2s, box-shadow 0.2s", position: "relative", overflow: "hidden",
  }}>
    <div style={{ position: "absolute", top: -20, right: -20, width: 60, height: 60, borderRadius: "50%", background: `${theme.accent}08` }} />
    <p style={{ fontFamily: "'Palatino Linotype', Palatino, Georgia, serif", fontSize: 11, color: theme.text, lineHeight: 1.4, margin: 0, display: "-webkit-box", WebkitLineClamp: 5, WebkitBoxOrient: "vertical", overflow: "hidden" }}>"{quote.text}"</p>
    <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 9, color: theme.accent, margin: 0, letterSpacing: 0.5 }}>— {quote.npc}</p>
  </div>
);

const WidgetMedium = ({ quote, theme, onClick }) => (
  <div onClick={onClick} style={{
    background: `linear-gradient(135deg, ${theme.card}, ${theme.bg})`,
    borderRadius: 20, padding: 18, width: "100%", height: 140, boxSizing: "border-box",
    display: "flex", flexDirection: "column", justifyContent: "space-between",
    border: `1px solid ${theme.accent}22`, cursor: "pointer",
    boxShadow: `inset 0 1px 0 ${theme.accent}15, 0 4px 20px rgba(0,0,0,0.3)`,
    position: "relative", overflow: "hidden",
  }}>
    <div style={{ position: "absolute", top: 0, right: 0, width: 120, height: 120, background: `radial-gradient(circle at top right, ${theme.accent}0a, transparent)` }} />
    <div>
      <p style={{ fontFamily: "'Palatino Linotype', Palatino, Georgia, serif", fontSize: 13.5, color: theme.text, lineHeight: 1.45, margin: 0, display: "-webkit-box", WebkitLineClamp: 4, WebkitBoxOrient: "vertical", overflow: "hidden" }}>"{quote.text}"</p>
    </div>
    <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-end" }}>
      <div>
        <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 11, color: theme.accent, margin: 0, fontWeight: 600 }}>— {quote.npc}</p>
        <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 9, color: theme.subtle, margin: "2px 0 0" }}>{quote.location} · {quote.hold}</p>
      </div>
      <span style={{ fontSize: 9, color: theme.subtle, fontFamily: "'Trebuchet MS', sans-serif", textTransform: "uppercase", letterSpacing: 1 }}>{quote.category}</span>
    </div>
  </div>
);

const QuoteCard = ({ quote, theme, fav, onFav, onShare }) => (
  <div style={{
    background: theme.card, borderRadius: 16, padding: 16, marginBottom: 10,
    border: `1px solid ${theme.accent}15`, position: "relative",
    transition: "border-color 0.2s",
  }}>
    <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 8 }}>
      <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
        <span style={{ fontSize: 18 }}>{RACE_ICONS[quote.race] || "🛡️"}</span>
        <div>
          <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 12, fontWeight: 700, color: theme.accent, margin: 0 }}>{quote.npc}</p>
          <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 9, color: theme.subtle, margin: "1px 0 0" }}>{quote.race} · {quote.location}</p>
        </div>
      </div>
      <span style={{ fontSize: 8, color: theme.bg, background: `${theme.accent}40`, padding: "2px 8px", borderRadius: 8, fontFamily: "'Trebuchet MS', sans-serif", fontWeight: 600, textTransform: "uppercase", letterSpacing: 0.5 }}>{quote.category}</span>
    </div>
    {quote.unlocked ? (
      <p style={{ fontFamily: "'Palatino Linotype', Palatino, Georgia, serif", fontSize: 13, color: theme.text, lineHeight: 1.5, margin: "8px 0 12px", fontStyle: "italic" }}>"{quote.text}"</p>
    ) : (
      <div style={{ padding: "12px 0", textAlign: "center" }}>
        <span style={{ fontSize: 20 }}>🔒</span>
        <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 10, color: theme.subtle, margin: "4px 0 0" }}>Discover this quote by exploring Skyrim...</p>
      </div>
    )}
    {quote.unlocked && (
      <div style={{ display: "flex", gap: 8, justifyContent: "flex-end" }}>
        <button onClick={onFav} style={{ background: "none", border: "none", cursor: "pointer", fontSize: 16, padding: 4 }}>{fav ? "❤️" : "🤍"}</button>
        <button onClick={onShare} style={{ background: "none", border: "none", cursor: "pointer", fontSize: 14, padding: 4 }}>📤</button>
      </div>
    )}
    {quote.quest && quote.unlocked && (
      <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 9, color: theme.subtle, margin: "4px 0 0", borderTop: `1px solid ${theme.accent}10`, paddingTop: 6 }}>🗺️ Quest: {quote.quest}</p>
    )}
  </div>
);

export default function ShoutsOfSkyrim() {
  const [view, setView] = useState("home");
  const [themeKey, setThemeKey] = useState("whiterun");
  const [activeCategory, setActiveCategory] = useState("All");
  const [favorites, setFavorites] = useState(new Set());
  const [quoteIdx, setQuoteIdx] = useState(0);
  const [showToast, setShowToast] = useState(null);
  const [widgetAnim, setWidgetAnim] = useState(false);

  const theme = THEMES[themeKey];
  const unlocked = QUOTES.filter(q => q.unlocked);
  const filtered = activeCategory === "All" ? QUOTES : QUOTES.filter(q => q.category === activeCategory);
  const currentQuote = unlocked[quoteIdx % unlocked.length];

  const cycleQuote = useCallback(() => {
    setWidgetAnim(true);
    setTimeout(() => { setQuoteIdx(i => (i + 1) % unlocked.length); setWidgetAnim(false); }, 300);
  }, [unlocked.length]);

  useEffect(() => { const t = setInterval(cycleQuote, 6000); return () => clearInterval(t); }, [cycleQuote]);

  const toast = (msg) => { setShowToast(msg); setTimeout(() => setShowToast(null), 2000); };
  const toggleFav = (id) => { setFavorites(prev => { const n = new Set(prev); n.has(id) ? n.delete(id) : n.add(id); return n; }); };

  const TabBar = () => (
    <div style={{
      display: "flex", justifyContent: "space-around", padding: "8px 0 2px",
      borderTop: `1px solid ${theme.accent}15`, background: `${theme.bg}ee`,
      backdropFilter: "blur(10px)", flexShrink: 0,
    }}>
      {[["home", "🏠", "Home"], ["quotes", "📜", "Quotes"], ["themes", "🎨", "Themes"], ["settings", "⚙️", "Settings"]].map(([v, icon, label]) => (
        <button key={v} onClick={() => setView(v)} style={{
          background: "none", border: "none", cursor: "pointer",
          display: "flex", flexDirection: "column", alignItems: "center", gap: 1, padding: "2px 8px",
        }}>
          <span style={{ fontSize: 18, filter: view === v ? "none" : "grayscale(0.8) opacity(0.5)" }}>{icon}</span>
          <span style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 8, color: view === v ? theme.accent : theme.subtle, fontWeight: view === v ? 700 : 400 }}>{label}</span>
        </button>
      ))}
    </div>
  );

  const HomeView = () => (
    <div style={{ padding: "48px 16px 8px", height: "100%", boxSizing: "border-box", display: "flex", flexDirection: "column", overflow: "auto" }}>
      <div style={{ textAlign: "center", marginBottom: 16 }}>
        <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 9, color: theme.subtle, margin: 0, textTransform: "uppercase", letterSpacing: 2 }}>Today's Widget Preview</p>
      </div>
      <div style={{ display: "flex", gap: 12, marginBottom: 16 }}>
        <div style={{ opacity: widgetAnim ? 0 : 1, transition: "opacity 0.3s", transform: widgetAnim ? "scale(0.95)" : "scale(1)" }}>
          <WidgetSmall quote={currentQuote} theme={theme} onClick={cycleQuote} />
        </div>
        <div style={{ flex: 1, display: "flex", flexDirection: "column", gap: 8 }}>
          <div style={{ background: theme.card, borderRadius: 14, padding: 12, border: `1px solid ${theme.accent}15`, flex: 1, display: "flex", flexDirection: "column", justifyContent: "center", alignItems: "center" }}>
            <span style={{ fontSize: 22 }}>📊</span>
            <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 10, color: theme.text, margin: "4px 0 0", fontWeight: 600 }}>{unlocked.length}/{QUOTES.length}</p>
            <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 8, color: theme.subtle, margin: "1px 0 0" }}>Discovered</p>
          </div>
          <div style={{ background: theme.card, borderRadius: 14, padding: 12, border: `1px solid ${theme.accent}15`, flex: 1, display: "flex", flexDirection: "column", justifyContent: "center", alignItems: "center" }}>
            <span style={{ fontSize: 22 }}>❤️</span>
            <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 10, color: theme.text, margin: "4px 0 0", fontWeight: 600 }}>{favorites.size}</p>
            <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 8, color: theme.subtle, margin: "1px 0 0" }}>Favorites</p>
          </div>
        </div>
      </div>
      <div style={{ opacity: widgetAnim ? 0 : 1, transition: "opacity 0.3s" }}>
        <WidgetMedium quote={currentQuote} theme={theme} onClick={cycleQuote} />
      </div>
      <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 8, color: theme.subtle, textAlign: "center", margin: "10px 0 4px", letterSpacing: 0.3 }}>Tap widgets to cycle · Auto-refreshes every 6s</p>
      <div style={{ background: `linear-gradient(135deg, ${theme.accent}12, ${theme.accent}06)`, borderRadius: 14, padding: 14, marginTop: 8, border: `1px solid ${theme.accent}20` }}>
        <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 10, color: theme.accent, fontWeight: 700, margin: 0 }}>🎮 Daily Challenge</p>
        <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 10, color: theme.text, margin: "4px 0 0", lineHeight: 1.4 }}>Browse 5 quotes today to unlock a hidden NPC line!</p>
        <div style={{ height: 4, borderRadius: 2, background: `${theme.accent}20`, marginTop: 8, overflow: "hidden" }}>
          <div style={{ height: "100%", width: "60%", borderRadius: 2, background: theme.accent, transition: "width 0.5s" }} />
        </div>
      </div>
    </div>
  );

  const QuotesView = () => (
    <div style={{ padding: "48px 16px 8px", height: "100%", boxSizing: "border-box", display: "flex", flexDirection: "column" }}>
      <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 16, fontWeight: 800, color: theme.text, margin: "0 0 10px" }}>Quote Library</p>
      <div style={{ display: "flex", gap: 6, marginBottom: 12, overflowX: "auto", flexShrink: 0, paddingBottom: 4 }}>
        {CATEGORIES.map(c => (
          <button key={c} onClick={() => setActiveCategory(c)} style={{
            background: activeCategory === c ? theme.accent : `${theme.accent}15`,
            border: "none", borderRadius: 12, padding: "5px 12px", cursor: "pointer",
            fontFamily: "'Trebuchet MS', sans-serif", fontSize: 10, fontWeight: 600,
            color: activeCategory === c ? theme.bg : theme.subtle, whiteSpace: "nowrap",
            transition: "all 0.2s",
          }}>{c}</button>
        ))}
      </div>
      <div style={{ flex: 1, overflowY: "auto", paddingRight: 4 }}>
        {filtered.map(q => (
          <QuoteCard key={q.id} quote={q} theme={theme}
            fav={favorites.has(q.id)}
            onFav={() => { toggleFav(q.id); toast(favorites.has(q.id) ? "Removed from favorites" : "Added to favorites ❤️"); }}
            onShare={() => toast("Share card generated! 📤")} />
        ))}
      </div>
    </div>
  );

  const ThemesView = () => (
    <div style={{ padding: "48px 16px 8px", height: "100%", boxSizing: "border-box", overflow: "auto" }}>
      <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 16, fontWeight: 800, color: theme.text, margin: "0 0 4px" }}>Themes</p>
      <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 10, color: theme.subtle, margin: "0 0 14px" }}>Choose your hold's aesthetic</p>
      <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
        {Object.entries(THEMES).map(([key, t]) => (
          <button key={key} onClick={() => setThemeKey(key)} style={{
            background: t.card, border: themeKey === key ? `2px solid ${t.accent}` : `1px solid ${t.accent}30`,
            borderRadius: 16, padding: 14, cursor: "pointer", textAlign: "left",
            display: "flex", alignItems: "center", gap: 14, transition: "all 0.2s",
            boxShadow: themeKey === key ? `0 0 20px ${t.glow}` : "none",
          }}>
            <div style={{ width: 44, height: 44, borderRadius: 12, background: `linear-gradient(135deg, ${t.bg}, ${t.accent}40)`, display: "flex", alignItems: "center", justifyContent: "center", border: `1px solid ${t.accent}40`, flexShrink: 0 }}>
              <div style={{ width: 14, height: 14, borderRadius: "50%", background: t.accent }} />
            </div>
            <div>
              <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 13, fontWeight: 700, color: t.text, margin: 0 }}>{t.name}</p>
              <div style={{ display: "flex", gap: 4, marginTop: 6 }}>
                {[t.bg, t.card, t.accent, t.text, t.subtle].map((c, i) => (
                  <div key={i} style={{ width: 16, height: 16, borderRadius: 4, background: c, border: "1px solid rgba(255,255,255,0.1)" }} />
                ))}
              </div>
            </div>
            {themeKey === key && <span style={{ marginLeft: "auto", fontSize: 16 }}>✓</span>}
          </button>
        ))}
      </div>
    </div>
  );

  const SettingsView = () => (
    <div style={{ padding: "48px 16px 8px", height: "100%", boxSizing: "border-box", overflow: "auto" }}>
      <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 16, fontWeight: 800, color: theme.text, margin: "0 0 14px" }}>Settings</p>
      {[
        ["Widget Refresh", "Every 4 hours"],
        ["Display Mode", "Random"],
        ["Notifications", "Daily quote at 9 AM"],
        ["Active Categories", `${CATEGORIES.length - 1} selected`],
      ].map(([label, value]) => (
        <div key={label} style={{ display: "flex", justifyContent: "space-between", alignItems: "center", padding: "12px 0", borderBottom: `1px solid ${theme.accent}10` }}>
          <span style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 12, color: theme.text }}>{label}</span>
          <span style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 11, color: theme.accent }}>{value} ›</span>
        </div>
      ))}
      <div style={{ marginTop: 20, padding: 14, background: `${theme.accent}08`, borderRadius: 14, border: `1px solid ${theme.accent}15` }}>
        <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 11, fontWeight: 700, color: theme.accent, margin: "0 0 4px" }}>⭐ Upgrade to Premium</p>
        <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 10, color: theme.subtle, margin: "0 0 10px", lineHeight: 1.4 }}>Unlock all themes, NPC profiles, and advanced filtering for $2.99</p>
        <button style={{ background: theme.accent, color: theme.bg, border: "none", borderRadius: 10, padding: "8px 20px", fontFamily: "'Trebuchet MS', sans-serif", fontSize: 11, fontWeight: 700, cursor: "pointer" }}>Unlock Now</button>
      </div>
      <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 8, color: theme.subtle, textAlign: "center", margin: "20px 0 0", lineHeight: 1.5 }}>Shouts of Skyrim v1.0 · Fan Project<br/>Not affiliated with Bethesda Softworks</p>
    </div>
  );

  return (
    <div style={{
      minHeight: "100vh", display: "flex", flexDirection: "column", alignItems: "center",
      justifyContent: "center", padding: "40px 20px",
      background: `radial-gradient(ellipse at 30% 20%, ${theme.accent}08, transparent 50%),
                    radial-gradient(ellipse at 70% 80%, ${theme.accent}05, transparent 50%),
                    #0a0a0a`,
      transition: "background 0.5s",
    }}>
      <div style={{ textAlign: "center", marginBottom: 32 }}>
        <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 10, color: theme.subtle, margin: "0 0 6px", textTransform: "uppercase", letterSpacing: 4 }}>Product Demo</p>
        <h1 style={{ fontFamily: "'Palatino Linotype', Palatino, Georgia, serif", fontSize: 32, fontWeight: 400, color: theme.text, margin: "0 0 6px", letterSpacing: 1 }}>
          Shouts of <span style={{ color: theme.accent, fontWeight: 700 }}>Skyrim</span>
        </h1>
        <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 13, color: theme.subtle, margin: 0 }}>iOS Widget App · NPC Quotes on Your Home Screen</p>
      </div>

      <PhoneFrame theme={theme}>
        <div style={{ height: "100%", display: "flex", flexDirection: "column" }}>
          <div style={{ flex: 1, overflow: "hidden" }}>
            {view === "home" && <HomeView />}
            {view === "quotes" && <QuotesView />}
            {view === "themes" && <ThemesView />}
            {view === "settings" && <SettingsView />}
          </div>
          <TabBar />
        </div>
        {showToast && (
          <div style={{
            position: "absolute", bottom: 60, left: "50%", transform: "translateX(-50%)",
            background: theme.accent, color: theme.bg, padding: "8px 16px", borderRadius: 20,
            fontFamily: "'Trebuchet MS', sans-serif", fontSize: 11, fontWeight: 600,
            whiteSpace: "nowrap", boxShadow: `0 4px 20px ${theme.glow}`,
            animation: "fadeIn 0.2s ease",
          }}>{showToast}</div>
        )}
      </PhoneFrame>

      <div style={{ display: "flex", gap: 10, marginTop: 28, flexWrap: "wrap", justifyContent: "center" }}>
        {Object.entries(THEMES).map(([key, t]) => (
          <button key={key} onClick={() => setThemeKey(key)} style={{
            background: themeKey === key ? t.accent : "transparent",
            color: themeKey === key ? t.bg : t.accent,
            border: `1px solid ${t.accent}60`, borderRadius: 20, padding: "6px 14px",
            fontFamily: "'Trebuchet MS', sans-serif", fontSize: 11, cursor: "pointer",
            transition: "all 0.2s", fontWeight: 600,
          }}>{t.name}</button>
        ))}
      </div>
      <p style={{ fontFamily: "'Trebuchet MS', sans-serif", fontSize: 10, color: "#555", margin: "16px 0 0", textAlign: "center" }}>Interactive prototype · Tap widgets to cycle quotes · Switch themes below</p>
    </div>
  );
}
