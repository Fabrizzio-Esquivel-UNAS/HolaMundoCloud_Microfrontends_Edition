import React, { useEffect, useRef, useState } from 'react';
import { loadMicroApp, start } from 'qiankun';

function App() {
  const subApp1Ref = useRef(null);
  const subApp2Ref = useRef(null);
  const [subAppsLoaded, setSubAppsLoaded] = useState(false);

  // Ensure Qiankun's singular mode is disabled
  useEffect(() => {
    start({
      singular: false,
    });
  }, []);

  const loadSubApps = () => {
    setSubAppsLoaded(true);
    loadMicroApp({
        name: 'sub1 app',
        entry: 'http://3.144.8.160',
        container: subApp1Ref.current,
        props: { title: 'Sub App 1' },
      });

      // loadMicroApp({
      //   name: 'sub2 app',
      //   entry: 'http://localhost:3002', // Make sure the second sub-app is running on this port
      //   container: subApp2Ref.current,
      //   props: { title: 'Sub App 2' },
      // });
  };

  return (
    <div>
      <h1>Main App</h1>

      {/* Button to load Sub-App 1 */}
      <button onClick={loadSubApps} disabled={subAppsLoaded}>
        {subAppsLoaded ? 'Sub-Apps Loaded' : 'Load Sub-Apps'}
      </button>

      <div
        id="sub1-container"
        ref={subApp1Ref}
        style={{ border: '1px solid #000', padding: '10px', marginBottom: '10px' }}
      >
        {subAppsLoaded ? 'Sub-App 1 is loading...' : 'Click the button to load Sub-App 1.'}
      </div>

      <div
        id="sub2-container"
        ref={subApp2Ref}
        style={{ border: '1px solid #000', padding: '10px', marginBottom: '10px' }}
      >
        {subAppsLoaded ? 'Sub-App 2 is loading...' : 'Click the button to load Sub-App 2.'}
      </div>
    </div>
  );
}

export default App;
