import React, { useState, useEffect, useMemo } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { LayoutGrid, Zap, Trophy, User, Star, Search, Bell, Plus } from 'lucide-react';

const MOCK_DATA = {
  usernames: ["DegenDon", "Whale_Watcher", "SolanaSlayer", "AlphaHunter", "EtherGhost", "Luna_Tic", "BullRun_X", "BearKiller", "CryptoVizier", "Zenith_Ops", "Nova_Pulse", "Void_Trader"],
  actions: ["placed a dare", "doubled down", "closed position", "entered market"]
};

const FEATURED_DARES = {
  "All": [
    { title: "BTC to $100k", time: "12:45:01", category: "Crypto", prize: "$50,000" },
    { title: "Apple to $250", time: "05:12:40", category: "Stocks", prize: "$12,500" },
    { title: "Lakers vs Celtics", time: "01:30:15", category: "Sports", prize: "$5,000" },
    { title: "Election 2026", time: "48:00:00", category: "Politics", prize: "$100,000" }
  ],
  "Crypto": [
    { title: "BTC to $100k", time: "12:45:01", category: "Crypto", prize: "$50,000" },
    { title: "ETH to $5k", time: "08:10:22", category: "Crypto", prize: "$25,000" },
    { title: "SOL to $250", time: "22:15:45", category: "Crypto", prize: "$15,000" }
  ],
  "Stocks": [
    { title: "Apple to $250", time: "05:12:40", category: "Stocks", prize: "$12,500" },
    { title: "Tesla Recovery", time: "02:44:12", category: "Stocks", prize: "$8,000" },
    { title: "NVIDIA Split?", time: "14:20:05", category: "Stocks", prize: "$20,000" }
  ],
  "Sports": [
    { title: "Lakers vs Celtics", time: "01:30:15", category: "Sports", prize: "$5,000" },
    { title: "Super Bowl MVP", time: "72:10:00", category: "Sports", prize: "$30,000" },
    { title: "World Cup Finals", time: "96:00:00", category: "Sports", prize: "$200,000" }
  ],
  "Politics": [
    { title: "Election 2026", time: "48:00:00", category: "Politics", prize: "$100,000" },
    { title: "Policy Change", time: "120:00:00", category: "Politics", prize: "$10,000" }
  ]
};

const getRandom = (arr: string[]) => arr[Math.floor(Math.random() * arr.length)];

// --- COMPONENTS ---

const NotificationToast: React.FC = () => {
  const [notification, setNotification] = useState<string | null>(null);

  useEffect(() => {
    const interval = setInterval(() => {
      const msg = `${getRandom(MOCK_DATA.usernames)} ${getRandom(MOCK_DATA.actions)}!`;
      setNotification(msg);
      setTimeout(() => setNotification(null), 3000);
    }, 8000);
    return () => clearInterval(interval);
  }, []);

  return (
    <AnimatePresence>
      {notification && (
        <motion.div 
          initial={{ y: -100, opacity: 0 }}
          animate={{ y: 20, opacity: 1 }}
          exit={{ y: -100, opacity: 0 }}
          style={{ 
            position: 'absolute', top: 50, left: 20, right: 20, zIndex: 5000,
            background: 'rgba(20, 20, 20, 0.9)', backdropFilter: 'blur(10px)',
            border: '1px solid #CCFF0033', padding: '12px 20px', borderRadius: '40px',
            display: 'flex', alignItems: 'center', gap: '12px', boxShadow: '0 10px 30px rgba(0,0,0,0.5)'
          }}
        >
          <div style={{ width: '8px', height: '8px', borderRadius: '50%', background: '#CCFF00', boxShadow: '0 0 10px #CCFF00' }} />
          <span style={{ fontSize: '12px', fontWeight: 700, color: '#CCFF00' }}>{notification}</span>
        </motion.div>
      )}
    </AnimatePresence>
  );
};

const PortfolioChart: React.FC = () => (
  <div style={{ height: '120px', width: '100%', position: 'relative', marginTop: '20px', padding: '0 10px' }}>
    <svg width="100%" height="100%" viewBox="0 0 100 40" preserveAspectRatio="none">
      <defs>
        <linearGradient id="chartGradient" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stopColor="#CCFF00" stopOpacity="0.4" />
          <stop offset="100%" stopColor="#CCFF00" stopOpacity="0" />
        </linearGradient>
      </defs>
      <motion.path
        initial={{ pathLength: 0 }}
        animate={{ pathLength: 1 }}
        transition={{ duration: 2, ease: "easeOut" }}
        d="M0,35 Q10,32 20,25 T40,28 T60,15 T80,20 T100,5"
        fill="none"
        stroke="#CCFF00"
        strokeWidth="2"
      />
      <path d="M0,35 Q10,32 20,25 T40,28 T60,15 T80,20 T100,5 L100,40 L0,40 Z" fill="url(#chartGradient)" />
    </svg>
    <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: '4px', opacity: 0.3, fontSize: '10px' }}>
      <span>MON</span><span>WED</span><span>FRI</span><span>SUN</span>
    </div>
  </div>
);

const BadgeItem: React.FC<{ icon: string, name: string, color: string }> = ({ icon, name, color }) => (
  <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '8px' }}>
    <div style={{ 
      width: '50px', height: '50px', borderRadius: '15px', background: `${color}11`, 
      border: `1px solid ${color}33`, display: 'flex', justifyContent: 'center', alignItems: 'center',
      fontSize: '20px', boxShadow: `0 0 20px ${color}11`
    }}>
      {icon}
    </div>
    <span style={{ fontSize: '9px', fontWeight: 800, opacity: 0.6, textAlign: 'center' }}>{name}</span>
  </div>
);

const PriceTicker: React.FC = () => {
  const items = [
    { coin: 'BTC', price: '$98,421', change: '+2.4%' },
    { coin: 'ETH', price: '$3,241', change: '-1.2%' },
    { coin: 'SOL', price: '$184', change: '+5.8%' },
    { coin: 'AVAX', price: '$42', change: '+0.4%' },
  ];

  return (
    <div style={{ overflow: 'hidden', whiteSpace: 'nowrap', padding: '10px 0', background: 'rgba(255,255,255,0.03)', marginBottom: '10px' }}>
      <motion.div
        animate={{ x: [0, -1000] }}
        transition={{ duration: 30, repeat: Infinity, ease: "linear" }}
        style={{ display: 'inline-block' }}
      >
        {[...Array(10)].map((_, i) => (
          <span key={i}>
            {items.map(item => (
              <span key={item.coin} style={{ marginRight: '40px', fontSize: '12px' }}>
                <b style={{ marginRight: '8px' }}>{item.coin}</b>
                <span style={{ marginRight: '8px' }}>{item.price}</span>
                <span style={{ color: item.change.includes('+') ? '#CCFF00' : '#ff4444', fontWeight: 800 }}>{item.change}</span>
              </span>
            ))}
          </span>
        ))}
      </motion.div>
    </div>
  );
};

const Header: React.FC<{ title: string, subtitle: string }> = ({ title, subtitle }) => (
  <div style={{ padding: '40px 20px 20px 20px' }}>
    <div className="subtitle">{subtitle}</div>
    <h1>{title}</h1>
  </div>
);

const BentoCard: React.FC<{ id: string, title: string, value: string, color: string, isLarge?: boolean, onClick: () => void }> = ({ id, title, value, color, isLarge, onClick }) => (
  <motion.div 
    layoutId={`bg-${id}`}
    className={`glass-card bento-item ${isLarge ? 'large' : ''}`} 
    onClick={onClick}
    style={{ cursor: 'pointer' }}
  >
    <div style={{ width: '16px', height: '16px', borderRadius: '50%', background: color, opacity: 0.2, marginBottom: '12px' }} />
    <motion.div layoutId={`title-${id}`} style={{ opacity: 0.5, fontSize: '12px' }}>{title}</motion.div>
    <div style={{ fontSize: '18px', fontWeight: 800 }}>{value}</div>
  </motion.div>
);

const MarketDetailView: React.FC<{ id: string, onClose: () => void }> = ({ id, onClose }) => {
  const getBrandColor = () => {
    switch (id) {
      case 'cyber': return '#3b82f6';
      case 'winrate': return '#CCFF00';
      case 'volume': return '#f97316';
      case 'livefeed': return '#a855f7';
      default: return '#fff';
    }
  };

  const getTitle = () => {
    switch (id) {
      case 'cyber': return 'Cyber Hub';
      case 'winrate': return 'Your Alpha';
      case 'volume': return 'Total Flow';
      case 'livefeed': return 'Network Pulse';
      default: return 'Insights';
    }
  };

  return (
    <motion.div 
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      style={{ 
        position: 'absolute', top: 0, left: 0, right: 0, bottom: 0, 
        background: '#000', zIndex: 1500, display: 'flex', flexDirection: 'column'
      }}
    >
      <motion.div 
        layoutId={`bg-${id}`}
        style={{ height: '300px', background: `${getBrandColor()}11`, padding: '20px', display: 'flex', flexDirection: 'column', justifyContent: 'space-between', borderBottom: '1px solid rgba(255,255,255,0.1)' }}
      >
        <div onClick={onClose} style={{ width: '40px', height: '40px', background: 'rgba(255,255,255,0.1)', borderRadius: '50%', display: 'flex', justifyContent: 'center', alignItems: 'center', cursor: 'pointer' }}>←</div>
        <div>
          <motion.div layoutId={`title-${id}`} style={{ color: getBrandColor(), fontWeight: 800, fontSize: '14px' }}>{id.toUpperCase()}</motion.div>
          <h1 style={{ margin: 0, fontSize: '32px' }}>{getTitle()}</h1>
        </div>
      </motion.div>
      
      <div style={{ padding: '24px', display: 'flex', flexDirection: 'column', gap: '30px', overflowY: 'auto' }}>
        {id === 'cyber' && (
           <>
             <div>
               <div style={{ color: getBrandColor(), fontWeight: 800, fontSize: '12px', marginBottom: '8px' }}>ACTIVE MARKETS</div>
               <p style={{ opacity: 0.7 }}>Bitcoin, Ethereum, and Solana are seeing the highest dare frequency today.</p>
             </div>
             <div className="glass-card" style={{ display: 'flex', justifyContent: 'space-between' }}>
                <span style={{ opacity: 0.5 }}>Liquidity</span>
                <span style={{ fontWeight: 800 }}>$4.2B</span>
             </div>
           </>
        )}
        {id === 'winrate' && (
           <>
             <div>
               <div style={{ color: getBrandColor(), fontWeight: 800, fontSize: '12px', marginBottom: '8px' }}>PERFORMANCE</div>
               <p style={{ opacity: 0.7 }}>Your average win rate has stabilized at 68% after the recent SOL bull run.</p>
             </div>
             <div style={{ display: 'flex', alignItems: 'flex-end', gap: '4px', height: '100px' }}>
                {[40, 70, 45, 90, 65, 80, 50].map((h, i) => (
                  <div key={i} style={{ flex: 1, background: getBrandColor(), height: `${h}%`, opacity: (i+1)/7, borderRadius: '4px' }} />
                ))}
             </div>
           </>
        )}
        {id === 'volume' && (
           <>
             <div>
               <div style={{ color: getBrandColor(), fontWeight: 800, fontSize: '12px', marginBottom: '8px' }}>24H VOLUME</div>
               <p style={{ opacity: 0.7 }}>$1,204,551 total volume traded across all markets.</p>
             </div>
             <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
                {['BTC', 'ETH', 'SOL'].map(coin => (
                  <div key={coin} style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                    <span style={{ fontSize: '10px', width: '30px' }}>{coin}</span>
                    <div style={{ flex: 1, height: '6px', background: 'rgba(255,255,255,0.1)', borderRadius: '3px' }}>
                       <div style={{ width: `${Math.random() * 60 + 30}%`, height: '100%', background: getBrandColor(), borderRadius: '3px' }} />
                    </div>
                  </div>
                ))}
             </div>
           </>
        )}
        {id === 'livefeed' && (
           <>
             <div>
               <div style={{ color: getBrandColor(), fontWeight: 800, fontSize: '12px', marginBottom: '8px' }}>LIVE PULSE</div>
               <p style={{ opacity: 0.7 }}>Real-time updates from the global dare network.</p>
             </div>
             <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
                {[...Array(5)].map((_, i) => (
                  <div key={i} style={{ display: 'flex', alignItems: 'center', gap: '12px', fontSize: '12px' }}>
                    <div style={{ width: '6px', height: '6px', borderRadius: '50%', background: getBrandColor() }} />
                    <span>{getRandom(MOCK_DATA.usernames)} {getRandom(MOCK_DATA.actions)}</span>
                  </div>
                ))}
             </div>
           </>
        )}
        <button className="glass-card" style={{ width: '100%', fontWeight: 800, padding: '16px', background: 'rgba(255,255,255,0.05)' }}>EXPLORE MORE</button>
      </div>
    </motion.div>
  );
};

const ExploreView: React.FC<{ 
  isWalletConnected: boolean, 
  onConnect: () => void, 
  onTapDare: (title: string) => void,
  onOpenCreate: () => void
}> = ({ isWalletConnected, onConnect, onTapDare, onOpenCreate }) => {
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [activeCategory, setActiveCategory] = useState("All");

  const filteredDares = FEATURED_DARES[activeCategory as keyof typeof FEATURED_DARES];

  return (
    <div style={{ position: 'relative' }}>
      <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }}>
        <PriceTicker />
        
        <div style={{ padding: '20px', display: 'flex', gap: '12px', alignItems: 'center' }}>
          <div style={{ flex: 1, background: 'rgba(255,255,255,0.05)', borderRadius: '15px', padding: '12px 16px', display: 'flex', alignItems: 'center', gap: '10px', border: '1px solid rgba(255,255,255,0.1)' }}>
            <Search size={18} style={{ opacity: 0.3 }} />
            <input type="text" placeholder="Search markets..." style={{ background: 'none', border: 'none', color: 'white', fontSize: '14px', width: '100%', outline: 'none' }} />
          </div>
          {!isWalletConnected ? (
             <button onClick={onConnect} className="neon-btn" style={{ padding: '12px 16px', fontSize: '12px' }}>CONNECT</button>
          ) : (
             <div style={{ width: '45px', height: '45px', background: 'rgba(204, 255, 0, 0.1)', borderRadius: '15px', display: 'flex', justifyContent: 'center', alignItems: 'center', color: '#CCFF00', border: '1px solid #CCFF0033' }}>👛</div>
          )}
        </div>

        <div style={{ display: 'flex', gap: '10px', overflowX: 'auto', padding: '0 20px', marginBottom: '20px' }}>
          {["All", "Crypto", "Stocks", "Sports", "Politics"].map(cat => (
            <div 
              key={cat} 
              onClick={() => setActiveCategory(cat)}
              style={{ 
                padding: '8px 16px', borderRadius: '20px', fontSize: '12px', fontWeight: 800, cursor: 'pointer',
                background: activeCategory === cat ? '#CCFF00' : 'rgba(255,255,255,0.05)',
                color: activeCategory === cat ? 'black' : 'white',
                border: activeCategory === cat ? 'none' : '1px solid rgba(255,255,255,0.1)',
                transition: 'all 0.2s ease'
              }}
            >
              {cat}
            </div>
          ))}
        </div>

        <div className="bento-grid">
          <BentoCard id="cyber" title="Cyber Market" value="2.4k Active" color="#3b82f6" isLarge onClick={() => setSelectedId('cyber')} />
          <BentoCard id="winrate" title="Win Rate" value="68%" color="#CCFF00" onClick={() => setSelectedId('winrate')} />
          <BentoCard id="volume" title="Volume" value="$1.2M" color="#f97316" onClick={() => setSelectedId('volume')} />
          <BentoCard id="livefeed" title="Live Feed" value="Tap to view" color="#a855f7" isLarge onClick={() => setSelectedId('livefeed')} />
        </div>

        <div style={{ padding: '20px' }}>
          <div style={{ fontWeight: 800, marginBottom: '12px', display: 'flex', justifyContent: 'space-between' }}>
            <span>{activeCategory} Dares</span>
            <span style={{ color: '#CCFF00', fontSize: '12px' }}>See All</span>
          </div>
          <AnimatePresence mode="popLayout">
            {filteredDares.map(dare => (
              <motion.div 
                key={dare.title} 
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, scale: 0.95 }}
                className="glass-card" 
                style={{ marginBottom: '12px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}
              >
                <div>
                  <div style={{ fontWeight: 700 }}>{dare.title}</div>
                  <div style={{ fontSize: '10px', opacity: 0.5 }}>{dare.category} • Ends in {dare.time}</div>
                  <div style={{ fontSize: '12px', color: '#CCFF00', fontWeight: 800, marginTop: '4px' }}>Prize Pool: {dare.prize}</div>
                </div>
                <button 
                  onClick={() => onTapDare(dare.title)}
                  style={{ background: '#CCFF00', border: 'none', borderRadius: '20px', padding: '8px 16px', fontWeight: 800, fontSize: '12px', cursor: 'pointer' }}
                >
                  DARE
                </button>
              </motion.div>
            ))}
          </AnimatePresence>
        </div>
      </motion.div>

      {/* Floating Action Button */}
      <motion.div 
        whileHover={{ scale: 1.1 }}
        whileTap={{ scale: 0.9 }}
        onClick={onOpenCreate}
        style={{ 
          position: 'fixed', bottom: '100px', right: '20px', width: '56px', height: '56px', 
          background: '#CCFF00', borderRadius: '50%', display: 'flex', justifyContent: 'center', 
          alignItems: 'center', color: 'black', boxShadow: '0 0 20px rgba(204, 255, 0, 0.4)',
          cursor: 'pointer', zIndex: 1000
        }}
      >
        <Plus size={24} strokeWidth={3} />
      </motion.div>

      <AnimatePresence>
        {selectedId && (
          <MarketDetailView id={selectedId} onClose={() => setSelectedId(null)} />
        )}
      </AnimatePresence>
    </div>
  );
};

const FeedView: React.FC = () => (
  <motion.div initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }}>
    <Header title="Feed" subtitle="Live Activity" />
    <div style={{ padding: '0 20px 20px 20px' }}>
      {[...Array(12)].map((_, i) => (
        <div key={i} className="glass-card" style={{ marginBottom: '16px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div>
            <div style={{ fontWeight: 800 }}>{MOCK_DATA.usernames[i % MOCK_DATA.usernames.length]}</div>
            <div style={{ fontSize: '10px', opacity: 0.5 }}>{getRandom(MOCK_DATA.actions)}</div>
          </div>
          <div style={{ textAlign: 'right' }}>
            <div style={{ color: '#CCFF00', fontWeight: 800 }}>{(Math.random() * 2).toFixed(2)} ETH</div>
            <div style={{ fontSize: '10px', opacity: 0.3 }}>{Math.floor(Math.random() * 59) + 1}m ago</div>
          </div>
        </div>
      ))}
    </div>
  </motion.div>
);

const LeaderboardView: React.FC = () => (
  <motion.div initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }}>
    <Header title="Rankings" subtitle="Top Darers" />
    <div style={{ padding: '0 20px 20px 20px' }}>
      {[...Array(10)].map((_, i) => (
        <div key={i} className="glass-card" style={{ marginBottom: '12px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
            <div style={{ width: '24px', fontWeight: 800, opacity: 0.5 }}>{i + 1}</div>
            <div style={{ fontWeight: 800 }}>{MOCK_DATA.usernames[i % MOCK_DATA.usernames.length]}</div>
          </div>
          <div style={{ fontWeight: 800, color: '#CCFF00' }}>{12000 - i * 800 + Math.floor(Math.random() * 400)} pts</div>
        </div>
      ))}
    </div>
  </motion.div>
);

const WalletModal: React.FC<{ onConnect: () => void, onClose: () => void }> = ({ onConnect, onClose }) => (
  <motion.div 
    initial={{ y: '100%' }} animate={{ y: 0 }} exit={{ y: '100%' }}
    style={{ position: 'absolute', top: 0, left: 0, right: 0, bottom: 0, background: '#000', zIndex: 3000, padding: '20px' }}
  >
    <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '40px', marginTop: '40px' }}>
      <div style={{ color: '#CCFF00', fontWeight: 800, fontSize: '12px' }}>CONNECT WALLET</div>
      <div onClick={onClose} style={{ cursor: 'pointer', opacity: 0.3 }}>✖</div>
    </div>
    <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
      {['MetaMask', 'Phantom', 'WalletConnect'].map(w => (
        <div key={w} onClick={onConnect} className="glass-card" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', cursor: 'pointer' }}>
          <div style={{ fontWeight: 800 }}>{w}</div>
          <div style={{ opacity: 0.3 }}>→</div>
        </div>
      ))}
    </div>
  </motion.div>
);

const ProfileView: React.FC<{ isConnected: boolean }> = ({ isConnected }) => (
  <motion.div initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }}>
    <Header title="Profile" subtitle="Settings" />
    <div style={{ padding: '20px' }}>
      <div className="glass-card" style={{ padding: '40px 20px', textAlign: 'center' }}>
        <div style={{ width: '80px', height: '80px', background: 'rgba(255,255,255,0.1)', borderRadius: '50%', margin: '0 auto 20px auto', display: 'flex', justifyContent: 'center', alignItems: 'center', fontSize: '32px', border: '1px solid rgba(255,255,255,0.1)' }}>👤</div>
        <div style={{ fontWeight: 800, fontSize: '20px' }}>{isConnected ? '0x71C...3A2' : 'Guest User'}</div>
        <div style={{ color: isConnected ? '#CCFF00' : '#ff4444', fontSize: '12px', fontWeight: 800, marginBottom: '24px' }}>
          {isConnected ? 'CONNECTED' : 'NOT CONNECTED'}
        </div>
        
        {isConnected && (
          <>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginBottom: '30px' }}>
              <div className="glass-card" style={{ padding: '12px', background: 'rgba(255,255,255,0.03)' }}>
                <div style={{ fontSize: '10px', opacity: 0.5 }}>Balance</div>
                <div style={{ fontWeight: 800 }}>1.24 ETH</div>
              </div>
              <div className="glass-card" style={{ padding: '12px', background: 'rgba(255,255,255,0.03)' }}>
                <div style={{ fontSize: '10px', opacity: 0.5 }}>Active Dares</div>
                <div style={{ fontWeight: 800 }}>4</div>
              </div>
            </div>

            <div style={{ textAlign: 'left' }}>
              <div style={{ fontSize: '14px', fontWeight: 800, marginBottom: '10px', display: 'flex', justifyContent: 'space-between' }}>
                <span>Portfolio Growth</span>
                <span style={{ color: '#CCFF00' }}>+12.4%</span>
              </div>
              <PortfolioChart />
            </div>

            <div style={{ textAlign: 'left', marginTop: '40px' }}>
              <div style={{ fontSize: '14px', fontWeight: 800, marginBottom: '20px' }}>Achievements</div>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '15px' }}>
                <BadgeItem icon="🌱" name="Early Adopter" color="#CCFF00" />
                <BadgeItem icon="🔥" name="High Roller" color="#f97316" />
                <BadgeItem icon="💎" name="Diamond Hands" color="#3b82f6" />
              </div>
            </div>
          </>
        )}
      </div>
    </div>
  </motion.div>
);

const TabItem: React.FC<{ icon: any, active: boolean, onClick: () => void, index: number }> = ({ icon, active, onClick }) => (
  <div className={`tab-item ${active ? 'active' : ''}`} onClick={onClick}>
    {icon}
  </div>
);

const MainContainer: React.FC<{ 
  selectedTab: number, 
  setSelectedTab: (i: number) => void,
  isWalletConnected: boolean,
  onConnect: () => void,
  onTapDare: (title: string) => void,
  onOpenCreate: () => void
}> = ({ selectedTab, setSelectedTab, isWalletConnected, onConnect, onTapDare, onOpenCreate }) => {
  return (
    <motion.div 
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      className="app-container"
    >
      <NotificationToast />
      
      <div style={{ flex: 1, overflowY: 'auto', paddingBottom: '120px' }}>
        {selectedTab === 0 && (
          <ExploreView 
            isWalletConnected={isWalletConnected} 
            onConnect={onConnect} 
            onTapDare={onTapDare} 
            onOpenCreate={onOpenCreate}
          />
        )}
        {selectedTab === 1 && <FeedView />}
        {selectedTab === 2 && <LeaderboardView />}
        {selectedTab === 3 && <ProfileView isConnected={isWalletConnected} />}
      </div>

      <div className="tab-bar">
        <TabItem icon={<LayoutGrid size={24} />} index={0} active={selectedTab === 0} onClick={() => setSelectedTab(0)} />
        <TabItem icon={<Zap size={24} />} index={1} active={selectedTab === 1} onClick={() => setSelectedTab(1)} />
        <TabItem icon={<Trophy size={24} />} index={2} active={selectedTab === 2} onClick={() => setSelectedTab(2)} />
        <TabItem icon={<User size={24} />} index={3} active={selectedTab === 3} onClick={() => setSelectedTab(3)} />
      </div>
    </motion.div>
  );
};

const CreateDareModal: React.FC<{ onClose: () => void }> = ({ onClose }) => (
  <motion.div 
    initial={{ y: '100%' }} animate={{ y: 0 }} exit={{ y: '100%' }}
    style={{ position: 'absolute', top: 0, left: 0, right: 0, bottom: 0, background: '#000', zIndex: 4000, padding: '20px' }}
  >
    <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '40px', marginTop: '40px' }}>
      <div style={{ color: '#CCFF00', fontWeight: 800, fontSize: '12px' }}>CREATE NEW DARE</div>
      <div onClick={onClose} style={{ cursor: 'pointer', opacity: 0.3 }}>✖</div>
    </div>
    <div style={{ display: 'flex', flexDirection: 'column', gap: '24px' }}>
       <div className="glass-card" style={{ padding: '20px' }}>
          <div style={{ opacity: 0.5, fontSize: '12px', marginBottom: '8px' }}>Market Title</div>
          <input type="text" placeholder="e.g. BTC to $200k" style={{ background: 'none', border: 'none', color: 'white', fontSize: '20px', fontWeight: 800, width: '100%', outline: 'none' }} />
       </div>
       <div className="glass-card" style={{ padding: '20px' }}>
          <div style={{ opacity: 0.5, fontSize: '12px', marginBottom: '8px' }}>Prize Pool</div>
          <input type="text" placeholder="e.g. $10,000" style={{ background: 'none', border: 'none', color: 'white', fontSize: '20px', fontWeight: 800, width: '100%', outline: 'none' }} />
       </div>
       <button className="neon-btn" onClick={onClose} style={{ marginTop: '20px' }}>PUBLISH DARE</button>
    </div>
  </motion.div>
);

const PlaceDareModal: React.FC<{ title: string, onClose: () => void }> = ({ title, onClose }) => {
  const [isSuccess, setIsSuccess] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  const handleConfirm = () => {
    setIsLoading(true);
    setTimeout(() => {
      setIsLoading(false);
      setIsSuccess(true);
    }, 2000);
  };

  return (
    <motion.div 
      initial={{ y: '100%' }}
      animate={{ y: 0 }}
      exit={{ y: '100%' }}
      transition={{ type: 'spring', damping: 25, stiffness: 200 }}
      style={{ 
        position: 'absolute', top: 0, left: 0, right: 0, bottom: 0, 
        background: '#000', zIndex: 2000, padding: '20px',
        display: 'flex', flexDirection: 'column'
      }}
    >
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: '40px' }}>
        <div>
          <div style={{ color: '#CCFF00', fontSize: '12px', fontWeight: 800 }}>PLACE YOUR DARE</div>
          <h2 style={{ margin: 0, fontSize: '28px' }}>{title}</h2>
        </div>
        <div onClick={onClose} style={{ opacity: 0.3, cursor: 'pointer' }}>✖</div>
      </div>

      <AnimatePresence mode="wait">
        {!isSuccess ? (
          <motion.div key="form" initial={{ opacity: 0 }} animate={{ opacity: 1 }} style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: '40px', marginTop: '40px' }}>
            <div className="glass-card" style={{ padding: '24px' }}>
              <div style={{ opacity: 0.5, fontSize: '14px', marginBottom: '8px' }}>Amount (ETH)</div>
              <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                <span style={{ fontSize: '32px', color: '#CCFF00', fontWeight: 800 }}>Ξ</span>
                <input 
                  type="text" 
                  defaultValue="0.5" 
                  style={{ background: 'none', border: 'none', color: 'white', fontSize: '48px', fontWeight: 900, width: '100%', outline: 'none' }}
                />
              </div>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
               <div className="glass-card" style={{ padding: '16px' }}>
                  <div style={{ fontSize: '10px', opacity: 0.5 }}>Potential Win</div>
                  <div style={{ fontWeight: 800 }}>Ξ 1.2</div>
               </div>
               <div className="glass-card" style={{ padding: '16px' }}>
                  <div style={{ fontSize: '10px', opacity: 0.5 }}>Platform Fee</div>
                  <div style={{ fontWeight: 800 }}>Ξ 0.005</div>
               </div>
            </div>

            <div style={{ marginTop: 'auto', marginBottom: '20px' }}>
              <button 
                className="neon-btn" 
                style={{ width: '100%' }} 
                onClick={handleConfirm}
                disabled={isLoading}
              >
                {isLoading ? 'PROCESSING...' : 'CONFIRM DARE'}
              </button>
            </div>
          </motion.div>
        ) : (
          <motion.div key="success" initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', textAlign: 'center' }}>
            <div style={{ width: '100px', height: '100px', borderRadius: '50%', border: '4px solid #CCFF00', display: 'flex', justifyContent: 'center', alignItems: 'center', marginBottom: '32px' }}>
              <span style={{ color: '#CCFF00', fontSize: '40px', fontWeight: 900 }}>✓</span>
            </div>
            <h2 style={{ fontSize: '32px', fontWeight: 900 }}>DARE PLACED!</h2>
            <p style={{ opacity: 0.5, marginBottom: '40px' }}>Your position is now live on the feed.</p>
            <button className="neon-btn" onClick={onClose} style={{ background: 'rgba(255,255,255,0.1)', color: 'white' }}>AWESOME</button>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  );
};

const SplashView: React.FC<{ onEnter: () => void }> = ({ onEnter }) => {
  return (
    <motion.div 
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0, scale: 0.95 }}
      className="app-container"
      style={{ justifyContent: 'center', alignItems: 'center', textAlign: 'center' }}
    >
      <motion.div
        initial={{ y: 20 }}
        animate={{ y: 0 }}
        transition={{ delay: 0.2 }}
      >
        <h1 style={{ fontSize: '64px', fontStyle: 'italic', lineHeight: 1 }}>DARE</h1>
        <div style={{ color: '#CCFF00', fontWeight: 800, letterSpacing: '8px', marginBottom: '40px' }}>MARKET</div>
        <p style={{ opacity: 0.5, marginBottom: '60px' }}>Would you dare?</p>
      </motion.div>

      <motion.button 
        whileHover={{ scale: 1.05 }}
        whileTap={{ scale: 0.95 }}
        className="neon-btn"
        onClick={onEnter}
      >
        ENTER APP
      </motion.button>
    </motion.div>
  );
};

const App: React.FC = () => {
  const [hasEntered, setHasEntered] = useState(false);
  const [selectedTab, setSelectedTab] = useState(0);
  const [isShowingPlaceDare, setIsShowingPlaceDare] = useState(false);
  const [isShowingCreateDare, setIsShowingCreateDare] = useState(false);
  const [selectedMarketTitle, setSelectedMarketTitle] = useState("");
  const [isWalletConnected, setIsWalletConnected] = useState(false);
  const [isShowingWalletModal, setIsShowingWalletModal] = useState(false);

  return (
    <div className="iphone-frame">
      <div className="iphone-notch" />
      
      <AnimatePresence mode="wait">
        {!hasEntered ? (
          <SplashView key="splash" onEnter={() => setHasEntered(true)} />
        ) : (
          <MainContainer 
            key="main" 
            selectedTab={selectedTab} 
            setSelectedTab={setSelectedTab} 
            isWalletConnected={isWalletConnected}
            onConnect={() => setIsShowingWalletModal(true)}
            onOpenCreate={() => setIsShowingCreateDare(true)}
            onTapDare={(title) => {
              setSelectedMarketTitle(title);
              setIsShowingPlaceDare(true);
            }}
          />
        )}
      </AnimatePresence>

      <AnimatePresence>
        {isShowingPlaceDare && (
          <PlaceDareModal 
            title={selectedMarketTitle} 
            onClose={() => setIsShowingPlaceDare(false)} 
          />
        )}
        {isShowingCreateDare && (
          <CreateDareModal 
            onClose={() => setIsShowingCreateDare(false)} 
          />
        )}
        {isShowingWalletModal && (
          <WalletModal 
            onConnect={() => {
              setIsWalletConnected(true);
              setIsShowingWalletModal(false);
            }}
            onClose={() => setIsShowingWalletModal(false)}
          />
        )}
      </AnimatePresence>
    </div>
  );
};

export default App;
